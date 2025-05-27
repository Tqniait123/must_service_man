// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/observers/router_observer.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/account_type_screen.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/check_your_email_screen.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/forget_password_screen.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/login_screen.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/otp_screen.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/register_screen.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/register_step_three.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/register_step_two.dart';
import 'package:must_invest_service_man/features/auth/presentation/pages/reset_password.dart';
import 'package:must_invest_service_man/features/history/presentation/pages/history_screen.dart';
import 'package:must_invest_service_man/features/home/data/models/parking_model.dart';
import 'package:must_invest_service_man/features/home/presentation/pages/home_screen.dart';
import 'package:must_invest_service_man/features/my_cards/presentation/pages/my_cards_screen.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/pages/new_list_screen.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/pages/parking_details_screen.dart';
import 'package:must_invest_service_man/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:must_invest_service_man/features/on_boarding/presentation/pages/on_boarding_screen.dart';
import 'package:must_invest_service_man/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:must_invest_service_man/features/profile/presentation/pages/profile_screen.dart';
import 'package:must_invest_service_man/features/profile/presentation/pages/scan_qr_code_screen.dart';
import 'package:must_invest_service_man/features/splash/presentation/pages/splash.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Define the AppRouter class
class AppRouter {
  // Create a GoRouter instance
  final GoRouter router = GoRouter(
    initialLocation: Routes.initialRoute,
    navigatorKey: rootNavigatorKey,
    errorPageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 200),
        key: state.pageKey,
        child: _unFoundRoute(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
    observers: [
      GoRouterObserver(), // Specify your observer here
    ],
    routes: [
      // Define routes using GoRoute
      GoRoute(
        path: Routes.initialRoute,
        builder: (context, state) {
          // Return the SplashScreen widget
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: Routes.onBoarding1,
        builder: (context, state) {
          // Return the SplashScreen widget
          return const OnBoardingScreen();
        },
      ),
      GoRoute(
        path: Routes.accountType,
        builder: (context, state) {
          // Return the AccountTypeScreen widget
          return const AccountTypeScreen();
        },
      ),

      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          // Return the SplashScreen widget
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) {
          // Return the RegisterScreen widget
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: Routes.forgetPassword,
        builder: (context, state) {
          // Return the ForgetPasswordScreen widget
          return const ForgetPasswordScreen();
        },
      ),
      GoRoute(
        path: Routes.otpScreen,
        builder: (context, state) {
          // Return the OtpScreen widget
          return OtpScreen(phone: state.extra as String);
        },
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) {
          // Return the OtpScreen widget
          return ResetPasswordScreen(email: state.extra as String);
        },
      ),
      GoRoute(
        path: Routes.homeUser,
        builder: (context, state) {
          // Return the HomeUser widget
          return const HomeParkingMan();
        },
      ),
      GoRoute(
        path: Routes.homeParkingMan,
        builder: (context, state) {
          // Return the HomeParkingMan widget
          return const HomeParkingMan();
        },
      ),
      GoRoute(
        path: Routes.registerStepTwo,
        builder: (context, state) {
          // Return the RegisterStepTwoScreen widget
          return const RegisterStepTwoScreen();
        },
      ),
      GoRoute(
        path: Routes.registerStepThree,
        builder: (context, state) {
          // Return the RegisterStepThreeScreen widget
          return const RegisterStepThreeScreen();
        },
      ),
      GoRoute(
        path: Routes.checkYourEmail,
        builder: (context, state) {
          // Return the CheckYourEmailScreen widget
          return CheckYourEmailScreen(email: state.extra as String);
        },
      ),
      GoRoute(
        path: Routes.newList,
        builder: (context, state) {
          // Return the ExploreScreen widget
          return NewListScreen();
        },
      ),

      GoRoute(
        path: Routes.parkingDetails,
        builder: (context, state) {
          // Return the ParkingDetails widget
          return ParkingDetailsScreen(parking: state.extra as Parking);
        },
      ),

      GoRoute(
        path: Routes.notifications,
        builder: (context, state) {
          // Return the Routing widget
          return NotificationsScreen();
        },
      ),
      GoRoute(
        path: Routes.myCards,
        builder: (context, state) {
          // Return the MyCardsScreen widget
          return MyCardsScreen();
        },
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) {
          // Return the ProfileScreen widget
          return ProfileScreen();
        },
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) {
          // Return the EditProfileScreen widget
          return EditProfileScreen();
        },
      ),
      GoRoute(
        path: Routes.scanQr,
        builder: (context, state) {
          // Return the MyQrCodeScreen widget
          return ScanQrCodeScreen();
        },
      ),
      GoRoute(
        path: Routes.history,
        builder: (context, state) {
          // Return the HistoryScreen widget
          return HistoryScreen();
        },
      ),
    ],
  );

  // Define a static method for the "Un Found Route" page
  static Widget _unFoundRoute() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBackButton(),
            100.gap,
            Center(
              child: Text(
                "Un Found Route",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ).paddingHorizontal(24),
    );
  }

  @override
  List<Object?> get props => [router];
}
