import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(userStatus: UserStatus.loading));
    try {
      _page = 1;

      final users = await repo.getAllUsers(_page, _limit);
      emit(
        state.copyWith(
          users: users,
          userStatus: UserStatus.loaded,
          hasReachedMax: users.length < _limit,
        ),
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
      final users = await repo.getAllUsers(_page, _limit);

      emit(
        state.copyWith(
          users: users,
          isLoadingMore: false,
          hasReachedMax: users.length < (_page * _limit),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}
