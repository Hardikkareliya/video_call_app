import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/cache_service.dart';
import '../models/ui_stats/users_state.dart';
import '../models/user_model.dart';
import '../repository/users_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersState());
  final UsersRepository _repository = UsersRepository();
  final ConnectivityService _connectivityService = ConnectivityService();

  void onInit() {
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    await _initializeServices();
    await _loadCachedData();
  }

  Future<void> _initializeServices() async {
    await _repository.initialize();
    _connectivityService.startMonitoring();

    // Listen to connectivity changes
    _connectivityService.statusStream.listen((status) {
      if (status == ConnectivityStatus.connected && state.usersList.isEmpty) {
        // Auto-refresh when coming back online with no data
        loadData();
      }
    });
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedResult = await _repository.getAllCachedUsers();
      if (cachedResult.isSuccess && cachedResult.data != null) {
        emit(
          state.copyWith(
            usersList: cachedResult.data!,
            isFromCache: true,
            isOffline: !_connectivityService.isOnline,
          ),
        );

        // If online, try to refresh data in background
        if (_connectivityService.isOnline) {
          _refreshInBackground();
        }
      } else {
        // No cached data, try to load from API if online
        if (_connectivityService.isOnline) {
          await loadData();
        }
      }
    } catch (e) {
      // Try to load from API if online
      if (_connectivityService.isOnline) {
        await loadData();
      }
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      final result = await _repository.getUsers(page: 1, forceRefresh: true);
      if (result.isSuccess && result.data != null) {
        emit(
          state.copyWith(
            usersList: result.data!.data,
            nextPageIndex: result.data!.nextPage.page,
            totalDataCount: result.data!.totalDataCount,
            isFromCache: false,
            isOffline: false,
          ),
        );
      }
    } catch (e) {
      print('UsersCubit: Background refresh failed: $e');
    }
  }

  Future<void> loadData({String? searchQuery, int page = 0}) async {
    if (page == 0) {
      emit(state.toggleLoading);
    }

    List<UserModel> usersList = List.empty(growable: true);
    if (page > 1) {
      usersList = List.from(state.usersList, growable: true);
    }

    if (state.totalDataCount == 0 || usersList.length < state.totalDataCount) {
      final result = await _repository.getUsers(
        page: page,
        forceRefresh: false, // Never force refresh - let repository decide
      );

      if (result.isSuccess && result.data != null) {
        usersList.addAll(result.data!.data);

        emit(
          state.copyWith(
            usersList: usersList,
            nextPageIndex: result.data!.nextPage.page,
            totalDataCount: result.data!.totalDataCount,
            isOffline: result.isOffline,
            isFromCache: result.isFromCache,
            lastError: result.error,
          ),
        );
      } else {
        emit(
          state.copyWith(isOffline: result.isOffline, lastError: result.error),
        );
      }
    }

    if (page == 0) {
      emit(state.toggleLoading);
    }
  }

  Future<void> loadMoreData() async {
    if (state.nextPageIndex != null && !state.isLoading) {
      await loadData(page: state.nextPageIndex!);
    }
  }

  Future<void> refreshData() async {
    emit(state.toggleLoading);

    try {
      final result = await _repository.refreshUsers();

      if (result.isSuccess && result.data != null) {
        emit(
          state.copyWith(
            usersList: result.data!.data,
            nextPageIndex: result.data!.nextPage.page,
            totalDataCount: result.data!.totalDataCount,
          ),
        );
      }
    } catch (e) {
      print('UsersCubit: Unexpected error during refresh: $e');
    } finally {
      emit(state.toggleLoading);
    }
  }

  @override
  Future<void> close() {
    _connectivityService.dispose();
    return super.close();
  }
}
