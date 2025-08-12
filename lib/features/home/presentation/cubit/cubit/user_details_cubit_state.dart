part of 'user_details_cubit_cubit.dart';

sealed class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object> get props => [];
}

final class UserDetailsCubitInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsSuccess extends UserDetailsState {
  final UserModel userModel;

  const UserDetailsSuccess(this.userModel);

  @override
  List<Object> get props => [userModel];
}

class UserDetailsError extends UserDetailsState {
  final String message;

  const UserDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
