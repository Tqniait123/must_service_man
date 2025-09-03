import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/dialogs/error_toast.dart';
import 'package:must_invest_service_man/core/utils/widgets/adaptive_layout/custom_layout.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_phone_field.dart';
import 'package:must_invest_service_man/core/utils/widgets/logo_widget.dart';
import 'package:must_invest_service_man/features/auth/data/models/login_params.dart';
import 'package:must_invest_service_man/features/auth/data/models/otp_screen_params.dart';
import 'package:must_invest_service_man/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:must_invest_service_man/features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:must_invest_service_man/features/auth/presentation/widgets/sign_up_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isRemembered = false;
  String _code = '+20';
  String _countryCode = 'EG';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomLayout(
        withPadding: true,
        patternOffset: const Offset(-150, -200),
        spacerHeight: 35,
        topPadding: 70,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),

        upperContent: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: LogoWidget(type: LogoType.svg)),
              27.gap,
              Text(
                LocaleKeys.login_to_your_account.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        children: [
          30.gap,
          Form(
            key: _formKey,
            child: Hero(
              tag: "form",
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    CustomPhoneFormField(
                      includeCountryCodeInValue: true,
                      controller: _phoneController,
                      margin: 0,
                      hint: LocaleKeys.phone_number.tr(),
                      title: LocaleKeys.phone_number.tr(),
                      // Add autofill hints for phone number
                      // autofillHints: sl<MustInvestPreferences>().isRememberedMe() ? [AutofillHints.telephoneNumber] : null,
                      onChanged: (phone) {
                        log(phone);
                      },
                      onChangedCountryCode: (code, countryCode) {
                        setState(() {
                          _code = code;
                          _countryCode = countryCode;
                          log(' $code');
                        });
                      },
                    ),
                    16.gap,
                    CustomTextFormField(
                      margin: 0,
                      controller: _passwordController,
                      hint: LocaleKeys.password.tr(),
                      title: LocaleKeys.password.tr(),
                      obscureText: true,
                      isPassword: true,
                    ),
                    19.gap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                activeColor: AppColors.secondary,
                                checkColor: AppColors.white,
                                value: isRemembered,
                                onChanged: (value) {
                                  setState(() {
                                    isRemembered = value ?? false;
                                  });
                                },
                              ),
                            ),
                            8.gap,
                            Text(LocaleKeys.remember_me.tr(), style: context.bodyMedium.s12.regular),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(Routes.forgetPassword);
                          },
                          child: Text(
                            LocaleKeys.forgot_password.tr(),
                            style: context.bodyMedium.s12.bold.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          40.gap,

          // 71.gap,

          // or login with divider
          // 20.gap,
          // SignUpButton(
          //   isLogin: true,
          //   onTap: () {
          //     context.push(Routes.accountType);
          //   },
          // ),
          // 30.gap, // Add extra bottom padding
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) async {
              if (state is AuthSuccess) {
                UserCubit.get(context).setCurrentUser(state.user);

                context.go(Routes.homeUser);
              } else if (state is AuthUnverified) {
                // Show bottom sheet for unverified account
                _showVerificationBottomSheet(context);
              }
              if (state is AuthError) {
                showErrorToast(context, state.message);
              }
            },
            builder:
                (BuildContext context, AuthState state) => CustomElevatedButton(
                  heroTag: 'button',
                  loading: state is AuthLoading,
                  title: LocaleKeys.login.tr(),
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    AuthCubit.get(context).login(
                      LoginParams(
                        phone: '$_code${_phoneController.text}',
                        password: _passwordController.text,
                        isRemembered: isRemembered,
                      ),
                    );
                    // }
                  },
                ),
          ),
          SignUpButton(isLogin: true, onTap: () => context.push(Routes.register)),
        ],
      ).paddingAll(32),
    );
  }

  void _showVerificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, size: 64, color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  LocaleKeys.account_verification_required.tr(),
                  style: context.bodyLarge.bold.copyWith(color: AppColors.black, fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  LocaleKeys.account_verification_message.tr(),
                  textAlign: TextAlign.center,
                  style: context.bodyMedium.regular.copyWith(color: AppColors.grey, fontSize: 16),
                ),
                SizedBox(height: 24),
                BlocConsumer<AuthCubit, AuthState>(
                  builder:
                      (BuildContext context, AuthState state) => CustomElevatedButton(
                        loading: state is ResendOTPLoading,
                        onPressed: () async {
                          await AuthCubit.get(context).resendOTP("$_code${_phoneController.text}");
                          context.pop(); // Close bottom sheet
                          context.push(
                            Routes.otpScreen,
                            extra: OtpScreenParams(
                              otpFlow: OtpFlow.registration,
                              phone: "$_code${_phoneController.text}",
                            ),
                          );
                        },
                        title: LocaleKeys.verify_now.tr(),
                      ),
                  listener: (BuildContext context, AuthState state) {
                    if (state is ResendOTPSuccess) {
                      showSuccessToast(context, state.message, seconds: 15);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }
}
