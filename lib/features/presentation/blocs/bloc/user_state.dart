// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

enum UserStatus { initial, loading, loaded, failure, msz }

class UserState extends Equatable {
  final UserStatus userStatus;
  final List<Users> users;
  final String? msz;
  final bool hasReachedMax;
  final bool isLoadingMore;
  const UserState({
    this.userStatus = UserStatus.initial,
    this.users = const [],
    this.msz,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
    userStatus,
    users,
    msz,
    hasReachedMax,
    isLoadingMore,
  ];

  UserState copyWith({
    UserStatus? userStatus,
    List<Users>? users,
    String? msz,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return UserState(
      userStatus: userStatus ?? this.userStatus,
      users: users ?? this.users,
      msz: msz ?? this.msz,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
