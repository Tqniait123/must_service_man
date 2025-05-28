import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';

class WithdrawRequestScreen extends StatefulWidget {
  const WithdrawRequestScreen({super.key});

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                Text(
                  LocaleKeys.withdrawal_request.tr(),
                  style: context.titleLarge.copyWith(),
                ),
                NotificationsButton(
                  color: Color(0xffEAEAF3),
                  iconColor: AppColors.primary,
                ),
              ],
            ),
            40.gap,

            CustomTextFormField(
              controller: TextEditingController(),
              margin: 0,
              hint: LocaleKeys.enter_the_number_of_points.tr(),
              title: LocaleKeys.points.tr(),
            ),
            16.gap,

            CustomTextFormField(
              controller: TextEditingController(),
              margin: 0,
              hint: LocaleKeys.enter_the_number_of_cash.tr(),
              title: LocaleKeys.cash.tr(),
            ),
            16.gap,

            CustomTextFormField(
              controller: TextEditingController(),
              margin: 0,

              hint: LocaleKeys.enter_withdrawal_method.tr(),
              title: LocaleKeys.note.tr(),
            ),
          ],
        ).paddingHorizontal(24),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                context.pop();
              },
              title: LocaleKeys.send.tr(),
            ),
          ),
        ],
      ).paddingAll(30),
    );
  }
}
