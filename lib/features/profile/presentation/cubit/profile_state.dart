part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class UpdateProfileLoading extends ProfileState {}

class UpdateProfileSuccess extends ProfileState {
  final ParkingMan user;

  const UpdateProfileSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateProfileError extends ProfileState {
  final String message;

  const UpdateProfileError(this.message);

  @override
  List<Object> get props => [message];
}
