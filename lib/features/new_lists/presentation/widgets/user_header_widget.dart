import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';

// Header Widget
class UserDetailsHeader extends StatelessWidget {
  const UserDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomBackButton(),
        Text(LocaleKeys.details.tr(), style: context.titleLarge.copyWith()),
        Row(
          children: [
            CustomIconButton(
              iconAsset: AppIcons.cameraIc,
              color: const Color(0xffEAEAF3),
              iconColor: AppColors.primary,
              onPressed: () {},
            ),
            10.gap,
            NotificationsButton(
              color: const Color(0xffEAEAF3),
              iconColor: AppColors.primary,
            ),
          ],
        ),
      ],
    ).paddingHorizontal(20);
  }
}
