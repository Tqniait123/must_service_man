import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';

import '../../data/repositories/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);

  Future<void> getCurrentUsersInParking() async {
    try {
      emit(CurrentUsersLoading());
      final response = await _homeRepository.getCurrentUsersInParking();
      response.fold(
        (userListResponse) => emit(CurrentUsersSuccess(userListResponse)),
        (error) => emit(CurrentUsersError(error.message)),
      );
    } on AppError catch (e) {
      emit(CurrentUsersError(e.message));
    } catch (e) {
      emit(CurrentUsersError(e.toString()));
    }
  }
}
