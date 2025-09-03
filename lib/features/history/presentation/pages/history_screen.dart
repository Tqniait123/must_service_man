import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/static/constants.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersList = Constants.getRealisticFakeUsers();
    return Scaffold(
      // backgroundColor: Color(0xffF4F4FA),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                Text(LocaleKeys.history.tr(), style: context.titleLarge.copyWith()),
                NotificationsButton(color: Color(0xffEAEAF3), iconColor: AppColors.primary),
              ],
            ),
            39.gap,
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hint: LocaleKeys.search.tr(),
                    margin: 0,
                    isBordered: false,
                    backgroundColor: Color(0xffEAEAF3),
                    prefixIC: AppIcons.searchIc.icon(color: AppColors.primary),
                    hintColor: AppColors.primary.withValues(alpha: 0.4),
                    controller: TextEditingController(),
                  ),
                ),
                7.gap,
                CustomIconButton(
                  height: 50,
                  width: 50,
                  iconAsset: AppIcons.filterIc,
                  color: Color(0xffEAEAF3),
                  iconColor: AppColors.primary,
                  onPressed: () {},
                ),
              ],
            ),
            16.gap,
            // Expanded(
            //   child: ListView.separated(
            //     padding: EdgeInsets.zero, // Remove padding to avoid extra space
            //     itemCount: usersList.length,
            //     separatorBuilder:
            //         (context, index) => const SizedBox(height: 16),
            //     itemBuilder: (context, index) {
            //       return UserWidget(user: usersList[index]);
            //     },
            //   ),
            // ),
          ],
        ).paddingHorizontal(24),
      ),
    );
  }
}
