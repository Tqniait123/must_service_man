import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/features/notifications/data/models/notification_model.dart';
import 'package:must_invest_service_man/features/notifications/data/repositories/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _repo;
  NotificationsCubit(this._repo) : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of<NotificationsCubit>(context);

  /// The `getNotifications` function retrieves notifications from the repository and emits
  /// appropriate states based on the response.
  Future<void> getNotifications() async {
    try {
      emit(NotificationsLoading());
      final response = await _repo.getNotifications();
      response.fold(
        (notifications) => emit(NotificationsSuccess(notifications)),
        (error) => emit(NotificationsError(error.message)),
      );
    } on AppError catch (e) {
      emit(NotificationsError(e.message));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
