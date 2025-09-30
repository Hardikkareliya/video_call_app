import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache configuration for different data types
class CacheConfig {
  final Duration ttl;
  final int maxSize;
  final String version;

  const CacheConfig({
    required this.ttl,
    this.maxSize = 1000,
    this.version = '1.0.0',
  });

  static const CacheConfig users = CacheConfig(
    ttl: Duration(hours: 2),
    maxSize: 500,
    version: '1.0.0',
  );

  static const CacheConfig general = CacheConfig(
    ttl: Duration(hours: 1),
    maxSize: 1000,
    version: '1.0.0',
  );
}

/// Cache entry with metadata
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final String version;
  final String key;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.version,
    required this.key,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(timestamp) > ttl;
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'version': version,
      'key': key,
    };
  }

  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return CacheEntry<T>(
      data: fromJsonT(json['data']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      version: json['version'],
      key: json['key'],
    );
  }
}

/// Comprehensive cache service with TTL, versioning, and size management
class CacheService {
  static const String _cachePrefix = 'cache_';
  static const String _metadataKey = 'cache_metadata';

  SharedPreferences? _prefs;
  final Map<String, CacheEntry> _memoryCache = {};
  final int _maxMemoryEntries = 50;

  static final CacheService _instance = CacheService._internal();

  factory CacheService() => _instance;

  CacheService._internal();

  /// Initialize the cache service
  Future<void> initialize() async {
    print('CacheService: Initializing...');
    _prefs ??= await SharedPreferences.getInstance();
    await _loadMemoryCache();
    print('CacheService: Initialization complete');
  }

  /// Store data in cache with TTL and versioning
  Future<bool> store<T>(
    String key,
    T data, {
    CacheConfig? config,
    T Function(T)? serializer,
  }) async {
    try {
      config ??= CacheConfig.general;

      final entry = CacheEntry<T>(
        data: data,
        timestamp: DateTime.now(),
        version: config.version,
        key: key,
      );

      // Store in memory cache
      _memoryCache[key] = entry;
      _manageMemoryCache();

      // Store in persistent cache
      final jsonString = jsonEncode(entry.toJson());
      final success =
          await _prefs?.setString('$_cachePrefix$key', jsonString) ?? false;

      if (success) {
        await _updateCacheMetadata(key, config);
      }

      return success;
    } catch (e) {
      print('CacheService: Error storing data for key $key: $e');
      return false;
    }
  }

  /// Retrieve data from cache
  Future<T?> retrieve<T>(
    String key, {
    CacheConfig? config,
    T Function(Map<String, dynamic>)? deserializer,
  }) async {
    try {
      config ??= CacheConfig.general;

      // Check memory cache first
      final memoryEntry = _memoryCache[key];
      if (memoryEntry != null && !memoryEntry.isExpired(config.ttl)) {
        return memoryEntry.data as T;
      }

      // Check persistent cache
      final jsonString = _prefs?.getString('$_cachePrefix$key');
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        final entry = CacheEntry.fromJson(json, (data) => data);

        if (!entry.isExpired(config.ttl) && entry.version == config.version) {
          // Move back to memory cache
          _memoryCache[key] = entry;
          _manageMemoryCache();

          return entry.data as T;
        } else {
          // Remove expired entry
          await remove(key);
        }
      }

      return null;
    } catch (e) {
      print('CacheService: Error retrieving data for key $key: $e');
      return null;
    }
  }

  /// Check if data exists and is not expired
  Future<bool> exists(String key, {CacheConfig? config}) async {
    final data = await retrieve(key, config: config);
    return data != null;
  }

  /// Remove specific cache entry
  Future<bool> remove(String key) async {
    try {
      _memoryCache.remove(key);
      final success = await _prefs?.remove('$_cachePrefix$key') ?? false;
      await _removeCacheMetadata(key);
      return success;
    } catch (e) {
      print('CacheService: Error removing cache entry $key: $e');
      return false;
    }
  }

  /// Clear all cache entries
  Future<bool> clearAll() async {
    try {
      _memoryCache.clear();
      final keys =
          _prefs
              ?.getKeys()
              .where((key) => key.startsWith(_cachePrefix))
              .toList() ??
          [];

      for (final key in keys) {
        await _prefs?.remove(key);
      }

      await _prefs?.remove(_metadataKey);
      return true;
    } catch (e) {
      print('CacheService: Error clearing cache: $e');
      return false;
    }
  }

  /// Clear expired entries
  Future<int> clearExpired() async {
    try {
      int removedCount = 0;
      final keys =
          _prefs
              ?.getKeys()
              .where((key) => key.startsWith(_cachePrefix))
              .toList() ??
          [];

      for (final key in keys) {
        final jsonString = _prefs?.getString(key);
        if (jsonString != null) {
          try {
            final json = jsonDecode(jsonString);
            final entry = CacheEntry.fromJson(json, (data) => data);

            // Check if expired (using default TTL)
            if (entry.isExpired(CacheConfig.general.ttl)) {
              await _prefs?.remove(key);
              _memoryCache.remove(key.replaceFirst(_cachePrefix, ''));
              removedCount++;
            }
          } catch (e) {
            // Remove corrupted entries
            await _prefs?.remove(key);
            removedCount++;
          }
        }
      }

      return removedCount;
    } catch (e) {
      print('CacheService: Error clearing expired entries: $e');
      return 0;
    }
  }

  /// Get cache statistics
  Future<CacheStats> getStats() async {
    try {
      final keys =
          _prefs
              ?.getKeys()
              .where((key) => key.startsWith(_cachePrefix))
              .toList() ??
          [];
      int totalSize = 0;
      int expiredCount = 0;

      for (final key in keys) {
        final jsonString = _prefs?.getString(key);
        if (jsonString != null) {
          totalSize += jsonString.length;

          try {
            final json = jsonDecode(jsonString);
            final entry = CacheEntry.fromJson(json, (data) => data);
            if (entry.isExpired(CacheConfig.general.ttl)) {
              expiredCount++;
            }
          } catch (e) {
            expiredCount++;
          }
        }
      }

      return CacheStats(
        totalEntries: keys.length,
        memoryEntries: _memoryCache.length,
        totalSizeBytes: totalSize,
        expiredEntries: expiredCount,
      );
    } catch (e) {
      print('CacheService: Error getting cache stats: $e');
      return CacheStats.empty();
    }
  }

  /// Load memory cache from persistent storage
  Future<void> _loadMemoryCache() async {
    try {
      final keys =
          _prefs
              ?.getKeys()
              .where((key) => key.startsWith(_cachePrefix))
              .toList() ??
          [];

      for (final key in keys) {
        final jsonString = _prefs?.getString(key);
        if (jsonString != null) {
          try {
            final json = jsonDecode(jsonString);
            final entry = CacheEntry.fromJson(json, (data) => data);

            if (!entry.isExpired(CacheConfig.general.ttl)) {
              _memoryCache[key.replaceFirst(_cachePrefix, '')] = entry;
            }
          } catch (e) {
            // Skip corrupted entries
            continue;
          }
        }
      }

      _manageMemoryCache();
    } catch (e) {
      print('CacheService: Error loading memory cache: $e');
    }
  }

  /// Manage memory cache size
  void _manageMemoryCache() {
    if (_memoryCache.length > _maxMemoryEntries) {
      final sortedEntries = _memoryCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

      final toRemove = sortedEntries.take(
        _memoryCache.length - _maxMemoryEntries,
      );
      for (final entry in toRemove) {
        _memoryCache.remove(entry.key);
      }
    }
  }

  /// Update cache metadata
  Future<void> _updateCacheMetadata(String key, CacheConfig config) async {
    try {
      final metadata = _prefs?.getString(_metadataKey);
      Map<String, dynamic> metadataMap = {};

      if (metadata != null) {
        metadataMap = jsonDecode(metadata);
      }

      metadataMap[key] = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'version': config.version,
        'ttl': config.ttl.inMilliseconds,
      };

      await _prefs?.setString(_metadataKey, jsonEncode(metadataMap));
    } catch (e) {
      print('CacheService: Error updating cache metadata: $e');
    }
  }

  /// Remove cache metadata
  Future<void> _removeCacheMetadata(String key) async {
    try {
      final metadata = _prefs?.getString(_metadataKey);
      if (metadata != null) {
        final metadataMap = jsonDecode(metadata);
        metadataMap.remove(key);
        await _prefs?.setString(_metadataKey, jsonEncode(metadataMap));
      }
    } catch (e) {
      print('CacheService: Error removing cache metadata: $e');
    }
  }
}

/// Cache statistics
class CacheStats {
  final int totalEntries;
  final int memoryEntries;
  final int totalSizeBytes;
  final int expiredEntries;

  const CacheStats({
    required this.totalEntries,
    required this.memoryEntries,
    required this.totalSizeBytes,
    required this.expiredEntries,
  });

  factory CacheStats.empty() {
    return const CacheStats(
      totalEntries: 0,
      memoryEntries: 0,
      totalSizeBytes: 0,
      expiredEntries: 0,
    );
  }

  double get sizeInMB => totalSizeBytes / (1024 * 1024);

  @override
  String toString() {
    return 'CacheStats(totalEntries: $totalEntries, memoryEntries: $memoryEntries, size: ${sizeInMB.toStringAsFixed(2)}MB, expired: $expiredEntries)';
  }
}
