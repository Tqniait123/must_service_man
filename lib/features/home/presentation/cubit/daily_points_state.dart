part of 'daily_points_cubit.dart';

abstract class DailyPointsState {}

class DailyPointsInitial extends DailyPointsState {}

class DailyPointsLoading extends DailyPointsState {}

class DailyPointsSuccess extends DailyPointsState {
  final List<DailyPointModel> dailyPoints;

  DailyPointsSuccess(this.dailyPoints);
}

class DailyPointsError extends DailyPointsState {
  final String message;

  DailyPointsError(this.message);
}
