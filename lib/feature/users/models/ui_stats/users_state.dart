import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_model.dart';

part 'users_state.freezed.dart';

@freezed
abstract class UsersState with _$UsersState {
  const factory UsersState({
    @Default(false) bool isLoading,
    @Default([]) List<UserModel> usersList,
    @Default(0) int totalDataCount,
    int? nextPageIndex,
    @Default(false) bool isOffline,
    @Default(false) bool isFromCache,
    String? lastError,
  }) = _UsersState;
}

extension UsersStateExtension on UsersState {

  UsersState get toggleLoading => copyWith(isLoading: !isLoading);
}