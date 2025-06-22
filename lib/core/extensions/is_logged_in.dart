import 'package:flutter/material.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/auth/presentation/cubit/user_cubit/user_cubit.dart';

extension UserCubitX on BuildContext {
  UserCubit get userCubit => UserCubit.get(this);

  bool get isLoggedIn => userCubit.isLoggedIn();
  void setCurrentUser(ParkingMan user) => userCubit.setCurrentUser(user);
  ParkingMan get currentUser => userCubit.currentUser!;
  ParkingMan get user => userCubit.currentUser!;
}
