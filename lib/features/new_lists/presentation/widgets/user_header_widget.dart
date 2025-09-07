import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
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
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,

      children: [
        // Left side - Back button
        Positioned.directional(textDirection: Directionality.of(context), start: 20, child: const CustomBackButton()),

        // Center - Details title
        Center(child: Text(LocaleKeys.details.tr(), style: context.titleLarge.copyWith(fontWeight: FontWeight.bold))),

        // Right side - Action buttons
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                iconAsset: AppIcons.cameraIc,
                color: const Color(0xffEAEAF3),
                iconColor: AppColors.primary,
                onPressed: () {
                  context.push(Routes.scanQr);
                },
              ),
              10.gap,
              NotificationsButton(color: const Color(0xffEAEAF3), iconColor: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
