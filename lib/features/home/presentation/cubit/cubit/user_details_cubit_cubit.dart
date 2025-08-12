import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/home/data/repositories/home_repo.dart';

part 'user_details_cubit_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final HomeRepo _repo;
  UserDetailsCubit(this._repo) : super(UserDetailsCubitInitial());

  /// The `getUserDetails` function retrieves user details by ID, handling different outcomes and
  /// emitting corresponding states.
  ///
  /// Args:
  ///   userId (int): The ID of the user whose details should be retrieved
  Future<void> getUserDetails(int userId) async {
    try {
      emit(UserDetailsLoading());
      final response = await _repo.getUserDetails(userId);
      response.fold(
        (userModel) => emit(UserDetailsSuccess(userModel)),
        (error) => emit(UserDetailsError(error.message)),
      );
    } on AppError catch (e) {
      emit(UserDetailsError(e.message));
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }
}
