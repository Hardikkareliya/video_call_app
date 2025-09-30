import '../../../core/services/cache_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/utils/paginated_response.dart';
import '../models/user_model.dart';
import '../../../core/repo/users_repo.dart';

/// Repository result wrapper
class RepositoryResult<T> {
  final T? data;
  final bool isFromCache;
  final String? error;
  final bool isOffline;

  const RepositoryResult({
    this.data,
    this.isFromCache = false,
    this.error,
    this.isOffline = false,
  });

  bool get isSuccess => data != null && error == null;

  bool get hasError => error != null;
}

/// Smart repository that handles caching, offline scenarios, and data synchronization
class UsersRepository {
  static final UsersRepository _instance = UsersRepository._internal();

  factory UsersRepository() => _instance;

  UsersRepository._internal();

  final UserRepo _apiRepo = UserRepo();
  final CacheService _cacheService = CacheService();
  final ConnectivityService _connectivityService = ConnectivityService();

  static const String _usersCacheKey = 'users_list';
  static const String _usersPageCacheKey = 'users_page_';

  /// Initialize the repository
  Future<void> initialize() async {
    await _cacheService.initialize();
    _connectivityService.startMonitoring();
  }

  /// Get users with smart caching and offline support
  Future<RepositoryResult<PaginatedListResult<UserModel>>> getUsers({
    required int page,
    bool forceRefresh = false,
  }) async {
    try {
      final isOnline = _connectivityService.isOnline;

      // Try to get from cache first (if not forcing refresh)
      if (!forceRefresh) {
        final cachedResult = await _getCachedUsers(page);
        if (cachedResult != null) {
          return RepositoryResult(
            data: cachedResult,
            isFromCache: true,
            isOffline: !isOnline,
          );
        }

        // If no page-specific cache, try general cache
        final generalCachedResult = await getAllCachedUsers();
        if (generalCachedResult.isSuccess && generalCachedResult.data != null) {
          // Convert to paginated result
          final paginatedResult = PaginatedListResult<UserModel>.empty();
          paginatedResult.data = generalCachedResult.data!;
          paginatedResult.totalDataCount = generalCachedResult.data!.length;

          return RepositoryResult(
            data: paginatedResult,
            isFromCache: true,
            isOffline: !isOnline,
          );
        }
      }

      // If offline and no cache, return error
      if (!isOnline && !forceRefresh) {
        return const RepositoryResult(
          error: 'No internet connection and no cached data available',
          isOffline: true,
        );
      }

      // Fetch from API
      if (isOnline) {
        try {
          final apiResult = await _apiRepo.getUsers(page: page);

          // Cache the result
          await _cacheUsers(page, apiResult);

          // Also cache in general cache for offline use
          await _cacheGeneralUsers(apiResult.data);

          return RepositoryResult(
            data: apiResult,
            isFromCache: false,
            isOffline: false,
          );
        } catch (e) {
          // If API fails, try to return cached data
          final cachedResult = await _getCachedUsers(page);
          if (cachedResult != null) {
            return RepositoryResult(
              data: cachedResult,
              isFromCache: true,
              error: 'API failed, showing cached data: ${e.toString()}',
              isOffline: false,
            );
          }

          return RepositoryResult(
            error: 'API failed and no cached data available: ${e.toString()}',
            isOffline: false,
          );
        }
      }

      return const RepositoryResult(
        error: 'No internet connection',
        isOffline: true,
      );
    } catch (e) {
      return RepositoryResult(
        error: 'Unexpected error: ${e.toString()}',
        isOffline: !_connectivityService.isOnline,
      );
    }
  }

  /// Get all cached users (for offline mode)
  Future<RepositoryResult<List<UserModel>>> getAllCachedUsers() async {
    try {
      final cachedData = await _cacheService.retrieve<List<dynamic>>(
        _usersCacheKey,
        config: CacheConfig.users,
      );

      if (cachedData != null) {
        final cachedUsers = cachedData
            .cast<Map<String, dynamic>>()
            .map((item) => UserModel.fromJson(item))
            .toList();

        return RepositoryResult(
          data: cachedUsers,
          isFromCache: true,
          isOffline: !_connectivityService.isOnline,
        );
      }

      print('UsersRepository: No cached users found');
      return RepositoryResult(
        error: 'No cached users available',
        isOffline: !_connectivityService.isOnline,
      );
    } catch (e) {
      print('UsersRepository: Error retrieving cached users: $e');
      return RepositoryResult(
        error: 'Error retrieving cached users: ${e.toString()}',
        isOffline: !_connectivityService.isOnline,
      );
    }
  }

  /// Refresh all users data
  Future<RepositoryResult<PaginatedListResult<UserModel>>> refreshUsers({
    int startPage = 1,
    int maxPages = 3,
  }) async {
    try {
      if (!_connectivityService.isOnline) {
        return const RepositoryResult(
          error: 'Cannot refresh without internet connection',
          isOffline: true,
        );
      }

      List<UserModel> allUsers = [];
      int totalDataCount = 0;
      int? nextPageIndex;

      for (int page = startPage; page <= maxPages; page++) {
        try {
          final result = await _apiRepo.getUsers(page: page);
          allUsers.addAll(result.data);
          totalDataCount = result.totalDataCount;

          if (result.nextPage.page != null) {
            nextPageIndex = result.nextPage.page;
          }

          // Cache each page
          await _cacheUsers(page, result);
        } catch (e) {
          print('UsersRepository: Error fetching page $page: $e');
          break;
        }
      }

      // Cache all users as a single list
      final userJsonList = allUsers.map((user) => user.toJson()).toList();
      await _cacheService.store(
        _usersCacheKey,
        userJsonList,
        config: CacheConfig.users,
      );

      final paginatedResult = PaginatedListResult<UserModel>.empty();
      paginatedResult.data = allUsers;
      paginatedResult.totalDataCount = totalDataCount;
      paginatedResult.nextPage = nextPageIndex != null
          ? PaginatedPageData(page: nextPageIndex)
          : PaginatedPageData.empty();

      return RepositoryResult(
        data: paginatedResult,
        isFromCache: false,
        isOffline: false,
      );
    } catch (e) {
      return RepositoryResult(
        error: 'Error refreshing users: ${e.toString()}',
        isOffline: !_connectivityService.isOnline,
      );
    }
  }

  /// Clear all cached users data
  Future<bool> clearCache() async {
    try {
      await _cacheService.remove(_usersCacheKey);

      // Clear all page caches
      for (int i = 1; i <= 10; i++) {
        // Assuming max 10 pages
        await _cacheService.remove('$_usersPageCacheKey$i');
      }

      return true;
    } catch (e) {
      print('UsersRepository: Error clearing cache: $e');
      return false;
    }
  }

  /// Get cache statistics
  Future<CacheStats> getCacheStats() async {
    return await _cacheService.getStats();
  }

  /// Check if users data is cached
  Future<bool> hasCachedData() async {
    return await _cacheService.exists(
      _usersCacheKey,
      config: CacheConfig.users,
    );
  }

  /// Get cached users for a specific page
  Future<PaginatedListResult<UserModel>?> _getCachedUsers(int page) async {
    try {
      final cacheKey = '$_usersPageCacheKey$page';
      return await _cacheService.retrieve<PaginatedListResult<UserModel>>(
        cacheKey,
        config: CacheConfig.users,
        deserializer: (json) {
          final result = PaginatedListResult<UserModel>.empty();
          result.data = (json['data'] as List)
              .map((item) => UserModel.fromJson(item))
              .toList();
          result.totalDataCount = json['totalDataCount'] ?? 0;
          result.nextPage = json['nextPage'] != null
              ? PaginatedPageData.fromJson(json['nextPage'])
              : PaginatedPageData.empty();
          result.previousPage = json['previousPage'] != null
              ? PaginatedPageData.fromJson(json['previousPage'])
              : PaginatedPageData.empty();
          return result;
        },
      );
    } catch (e) {
      print(
        'UsersRepository: Error retrieving cached users for page $page: $e',
      );
      return null;
    }
  }

  /// Cache users data for a specific page
  Future<void> _cacheUsers(
    int page,
    PaginatedListResult<UserModel> result,
  ) async {
    try {
      final cacheKey = '$_usersPageCacheKey$page';
      await _cacheService.store(cacheKey, {
        'data': result.data.map((user) => user.toJson()).toList(),
        'totalDataCount': result.totalDataCount,
        'nextPage': result.nextPage.toJson(),
        'previousPage': result.previousPage.toJson(),
      }, config: CacheConfig.users);
    } catch (e) {
      print('UsersRepository: Error caching users for page $page: $e');
    }
  }

  /// Cache users in general cache for offline use
  Future<void> _cacheGeneralUsers(List<UserModel> users) async {
    try {
      // Get existing cached users
      final existingCachedData = await _cacheService.retrieve<List<dynamic>>(
        _usersCacheKey,
        config: CacheConfig.users,
      );

      List<UserModel> allUsers = [];
      if (existingCachedData != null) {
        allUsers = existingCachedData
            .cast<Map<String, dynamic>>()
            .map((item) => UserModel.fromJson(item))
            .toList();
      }

      // Add new users (avoid duplicates)
      for (final user in users) {
        if (!allUsers.any((existingUser) => existingUser.id == user.id)) {
          allUsers.add(user);
        }
      }

      // Cache the combined list
      final userJsonList = allUsers.map((user) => user.toJson()).toList();
      await _cacheService.store(
        _usersCacheKey,
        userJsonList,
        config: CacheConfig.users,
      );

      print(
        'UsersRepository: Cached ${allUsers.length} total users in general cache',
      );
    } catch (e) {
      print('UsersRepository: Error caching general users: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivityService.dispose();
  }
}
