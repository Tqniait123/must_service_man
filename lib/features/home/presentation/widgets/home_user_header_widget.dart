import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/is_logged_in.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';
import 'package:must_invest_service_man/core/utils/widgets/long_press_effect.dart';

class UserHomeHeaderWidget extends StatelessWidget {
  const UserHomeHeaderWidget({super.key, required TextEditingController searchController})
    : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Burger Menu Button (similar to user app)
                  CustomIconButton(
                    iconAsset: AppIcons.menuIc,
                    iconColor: AppColors.white,
                    color: Color(0xff6468AC),
                    onPressed: () {
                      context.push(Routes.profile);
                      // close opened keyboard first
                      // FocusManager.instance.primaryFocus?.unfocus();
                      // Future.delayed(Duration(milliseconds: 500), () {
                      // });
                    },
                  ),
                  15.gap,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.hola_name.tr(namedArgs: {"name": context.user.name}),
                          style: context.bodyMedium.s24.bold.copyWith(color: AppColors.white),
                        ).withPressEffect(
                          onTap: () {
                            context.push(Routes.profile);
                          },
                        ),
                        10.gap,
                        Text(
                          LocaleKeys.manage_parking_users_efficiently.tr(),
                          style: context.bodyMedium.s16.regular.copyWith(color: AppColors.white.withValues(alpha: 0.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            15.gap,
            Row(
              children: [
                // CustomIconButton(
                //   color: Color(0xff6468AC),
                //   iconColor: AppColors.white,
                //   iconAsset: AppIcons.qrCodeIc,
                //   onPressed: () {
                //     context.push(Routes.myQrcode);
                //   },
                // ),
                // 10.gap,
                // context.user.type == UserType.parkingMan
                //     ? CustomIconButton(
                //       iconAsset: AppIcons.cameraIc,
                //       color: Color(0xff6468AC),
                //       onPressed: () {
                //         context.push(Routes.scanQr);
                //       },
                //     )
                //     : SizedBox.shrink(),
                // 10.gap,
                NotificationsButton(),
              ],
            ),
          ],
        ),
        40.gap,
        CustomTextFormField(
          controller: _searchController,
          backgroundColor: Color(0xff6468AC),
          isBordered: false,
          styleColor: AppColors.white,
          margin: 0,
          prefixIC: AppIcons.searchIc.icon(),
          hint: LocaleKeys.search_for_current_customers_in_parking.tr(),
          waitTyping: true,
          suffixIC: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                iconAsset: AppIcons.cameraIc,
                color: AppColors.primary,
                onPressed: () {
                  context.push(Routes.scanQr);
                },
              ),
              6.gap,
              CustomIconButton(
                iconAsset: AppIcons.qrCodeIc,
                color: AppColors.primary,
                onPressed: () {
                  context.push(Routes.myQrcode);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
