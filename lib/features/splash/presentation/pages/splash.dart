import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/app_settings/cubit/settings_cubit.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:must_invest_service_man/core/services/di.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _positionController;
  late AnimationController _logoFadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _logoFadeAnimation;
  bool _settingsLoaded = false;

  @override
  void initState() {
    super.initState();

    // Setup fade animation for welcome message
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    // Setup fade animation for logo
    _logoFadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_logoFadeController);

    // Setup position animation for logo - match duration with fade animation
    _positionController = AnimationController(
      duration: const Duration(milliseconds: 800), // Match fade duration
      vsync: this,
    );
    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: -20.0,
    ).animate(CurvedAnimation(parent: _positionController, curve: Curves.easeOut));

    final settingsCubit = AppSettingsCubit.get(context);
    settingsCubit.getAppSettings().then((_) {
      if (settingsCubit.state is AppSettingsSuccessState) {
        _settingsLoaded = true;
        _startAnimationSequence();
      } else {
        _showRetryButton();
      }
    });
  }

  void _showRetryButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.error.tr()), // Generic error title
          content: Text(LocaleKeys.something_went_wrong.tr()), // Generic message
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final settingsCubit = AppSettingsCubit.get(context);
                settingsCubit.getAppSettings().then((_) {
                  if (settingsCubit.state is AppSettingsSuccessState) {
                    _settingsLoaded = true;
                    _handleNavigation();
                  } else {
                    _showRetryButton(); // Retry if it fails again
                  }
                });
              },
              child: Text(LocaleKeys.retry.tr()),
            ),
          ],
        );
      },
    );
  }

  void _startAnimationSequence() async {
    // Wait for initial delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Start logo fade animation
    _logoFadeController.forward();

    // Wait 2 seconds before showing welcome message and moving logo
    await Future.delayed(const Duration(seconds: 1));

    // Start both animations simultaneously
    _fadeController.forward();
    _positionController.forward();

    // Wait 1 second after animations complete and check navigation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      await _handleNavigation();
    }
  }

  Future<void> _handleNavigation() async {
    final pref = MustInvestServiceManPreferences(sl());
    final bool isOnBoardingCompleted = pref.isOnBoardingCompleted();

    if (!isOnBoardingCompleted) {
      // Navigate to onboarding if not completed
      context.go(Routes.onBoarding1);
    } else {
      // Always navigate to login screen
      context.go(Routes.login);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _positionController.dispose();
    _logoFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -300, // Shift pattern to the left
            child: Opacity(
              opacity: 0.3,
              child: AppIcons.splashPattern.svg(
                width: MediaQuery.sizeOf(context).width * 1.2,
                height: MediaQuery.sizeOf(context).height * 1.2,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo with position change and fade
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: AnimatedBuilder(
                    animation: _positionAnimation,
                    builder: (context, child) {
                      return Transform.translate(offset: Offset(0, _positionAnimation.value), child: child);
                    },
                    child: LogoWidget(type: LogoType.svg),
                  ),
                ),
                44.gap,
                // Fade in animation for welcome message
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    LocaleKeys.welcome_to_must_invest.tr(),
                    style: context.bodyLarge.bold.s16.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
