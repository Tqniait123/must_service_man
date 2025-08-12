import 'package:equatable/equatable.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class CurrentUsersLoading extends HomeState {}

class CurrentUsersSuccess extends HomeState {
  final UserListResponse userListResponse;

  const CurrentUsersSuccess(this.userListResponse);

  @override
  List<Object> get props => [userListResponse];
}

class CurrentUsersError extends HomeState {
  final String message;

  const CurrentUsersError(this.message);

  @override
  List<Object> get props => [message];
}
