import 'package:get_it/get_it.dart';
import 'package:must_invest_service_man/config/app_settings/cubit/settings_cubit.dart';
import 'package:must_invest_service_man/config/app_settings/data/datasources/settings_remote_data_source.dart';
import 'package:must_invest_service_man/config/app_settings/data/datasources/settings_remote_data_source_impl.dart';
import 'package:must_invest_service_man/config/app_settings/data/repo/settings_repo_impl.dart';
import 'package:must_invest_service_man/config/app_settings/domain/repo/settings_repo.dart';
import 'package:must_invest_service_man/core/api/dio_client.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:must_invest_service_man/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:must_invest_service_man/features/auth/data/repositories/auth_repo.dart';
import 'package:must_invest_service_man/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:must_invest_service_man/features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:must_invest_service_man/features/home/data/datasources/home_remote_data_source.dart';
import 'package:must_invest_service_man/features/home/data/repositories/home_repo.dart';
import 'package:must_invest_service_man/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:must_invest_service_man/features/notifications/data/repositories/notifications_repo.dart';
import 'package:must_invest_service_man/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:must_invest_service_man/features/profile/data/repositories/profile_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initLocator(SharedPreferences sharedPreferences) async {
  // Register SharedPreferences first
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register MustInvestPreferences
  sl.registerLazySingleton(() => MustInvestServiceManPreferences(sl()));

  // Register DioClient
  sl.registerLazySingleton(() => DioClient(sl()));

  //? Cubits
  sl.registerFactory<UserCubit>(() => UserCubit());
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl()));
  sl.registerLazySingleton<AppSettingsCubit>(() => AppSettingsCubit(sl()));

  //* Repository
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl(), sl()));
  sl.registerLazySingleton<PagesRepo>(() => PagesRepoImpl(sl(), sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl(), sl()));
  sl.registerLazySingleton<NotificationsRepo>(() => NotificationsRepoImpl(sl(), sl()));
  sl.registerLazySingleton<AppSettingsRepo>(() => AppSettingsRepoImpl(sl()));

  //* Datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PagesRemoteDataSource>(() => PagesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NotificationsRemoteDataSource>(() => NotificationsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AppSettingsRemoteDataSource>(() => AppSettingsRemoteDataSourceImpl(sl()));
}
