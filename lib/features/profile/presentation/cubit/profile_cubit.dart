import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/profile/data/models/update_profile_params.dart';
import 'package:must_invest_service_man/features/profile/data/repositories/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final PagesRepo _repo;
  ProfileCubit(this._repo) : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of<ProfileCubit>(context);

  /// The `updateProfile` function handles updating user profile information by calling the repository
  /// method and emitting appropriate states based on the response.
  ///
  /// Args:
  ///   params (UpdateProfileParams): Contains the profile update details including name and optional image.
  Future<void> updateProfile(UpdateProfileParams params) async {
    try {
      emit(UpdateProfileLoading());
      final response = await _repo.updateProfile(params);
      response.fold((user) => emit(UpdateProfileSuccess(user)), (error) => emit(UpdateProfileError(error.message)));
    } on AppError catch (e) {
      emit(UpdateProfileError(e.message));
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }
}
