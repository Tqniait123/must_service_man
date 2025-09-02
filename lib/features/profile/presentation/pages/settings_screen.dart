import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/dialogs/languages_bottom_sheet.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/features/profile/presentation/widgets/profile_item_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                Text(LocaleKeys.settings.tr(), style: context.titleLarge.copyWith(color: AppColors.black)),
                51.gap,
              ],
            ),
            40.gap,
            Expanded(
              child: ListView(
                children: [
                  ProfileItemWidget(
                    title: LocaleKeys.language.tr(),
                    iconPath: AppIcons.languageIc,
                    onPressed: () {
                      showLanguageBottomSheet(context);
                    },
                  ),
                  // if (context.isLoggedIn)
                  //   ProfileItemWidget(title: LocaleKeys.face_id.tr(), iconPath: AppIcons.faceIdIc),
                ],
              ),
            ),
          ],
        ).paddingHorizontal(16),
      ),
    );
  }
}
