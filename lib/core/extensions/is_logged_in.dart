import 'package:flutter/material.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/auth/presentation/cubit/user_cubit/user_cubit.dart';

extension UserCubitX on BuildContext {
  UserCubit get userCubit => UserCubit.get(this);

  bool get isLoggedIn => userCubit.isLoggedIn();
  void setCurrentUser(AppUser user) => userCubit.setCurrentUser(user);
  AppUser get user => UserCubit.get(this).currentUser!;
}
