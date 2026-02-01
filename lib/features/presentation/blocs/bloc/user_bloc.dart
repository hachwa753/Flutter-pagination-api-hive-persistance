import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hivecaching/features/domain/model/users.dart';
import 'package:hivecaching/features/domain/repo/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo repo;

  int _page = 1;
  final int _limit = 5;

  UserBloc(this.repo) : super(UserState()) {
    on<GetAllUsers>(_getAllUsers);
    on<LoadMoreUsers>(_loadMoreUsers);
  }

  void _getAllUsers(GetAllUsers event, Emitter<UserState> emit) async {
    try {
      _page = 1;

      //emit cached users instantly
      final cachedUsers = repo.getCachedUsers();
      if (cachedUsers.isNotEmpty) {
        emit(state.copyWith(users: cachedUsers, userStatus: UserStatus.loaded));
      } else {
        emit(state.copyWith(userStatus: UserStatus.loading));
      }
      //fetch fresh api users
      final result = await repo.getAllUsers(_page, _limit);

      result.fold(
        (failure) {
          emit(state.copyWith(userStatus: UserStatus.failure, msz: failure));
        },
        (apiUsers) {
          // Merge with cached users to prevent duplicates
          final mergedUsers = [
            ...cachedUsers,
            ...apiUsers.where((u) => !cachedUsers.any((c) => c.id == u.id)),
          ];
          emit(
            state.copyWith(
              users: mergedUsers,
              userStatus: UserStatus.loaded,
              hasReachedMax: apiUsers.length < _limit,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(userStatus: UserStatus.failure, msz: e.toString()));
    }
  }

  Future<void> _loadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    _page++;

    try {
      final result = await repo.getAllUsers(_page, _limit);
      result.fold(
        (failure) {
          emit(state.copyWith(isLoadingMore: false));
        },
        (apiUsers) {
          // Merge with existing state users
          final updatedUsers = [
            ...state.users,
            ...apiUsers.where((u) => !state.users.any((e) => e.id == u.id)),
          ];
          emit(
            state.copyWith(
              users: updatedUsers,
              isLoadingMore: false,
              hasReachedMax: apiUsers.length < _limit,
             // hasReachedMax: apiUsers.length < (_page * _limit),
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
