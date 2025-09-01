import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/flipped_for_lcale.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/static/constants.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/long_press_effect.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

class UserWidget extends StatelessWidget {
  final UserModel user;

  const UserWidget({super.key, required this.user});

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return LocaleKeys.unknown.tr();

    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeString; // Return original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xffF4F4FA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          user.user?.image ?? Constants.placeholderProfileImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(Constants.placeholderProfileImage, fit: BoxFit.cover);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.user?.name ?? LocaleKeys.unknown_user.tr(),
                            style: context.textTheme.bodyMedium?.s16.bold.copyWith(color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          if (user.user?.phone != null)
                            Text(
                              user.user!.phone!,
                              style: context.textTheme.bodyMedium?.s12.regular.copyWith(
                                color: AppColors.primary.withValues(alpha: 0.5),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconButton(
                height: 30,
                width: 30,
                radius: 10,
                color: Color(0xffE2E4FF),
                iconAsset: AppIcons.arrowIc,
                onPressed: () {},
              ).flippedForLocale(context),
            ],
          ),
          const SizedBox(height: 16),

          // Car and Parking Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1),
            ),
            child: Column(
              children: [
                // Plate Number Row
                if (user.car?.metalPlate != null)
                  Row(
                    children: [
                      Icon(Icons.local_taxi, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.plate_number.tr(),
                        style: context.textTheme.bodyMedium?.s12.regular.copyWith(
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.car!.metalPlate!,
                          style: context.textTheme.bodyMedium?.s14.bold.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),

                if (user.car?.metalPlate != null && user.startTime != null) const SizedBox(height: 8),

                // Inside from Date Row
                if (user.startTime != null)
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.inside_from.tr(),
                        style: context.textTheme.bodyMedium?.s12.regular.copyWith(
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDateTime(user.startTime),
                          style: context.textTheme.bodyMedium?.s14.medium.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),

                // Car Name Row (if available)
                if (user.car?.name != null && (user.car?.metalPlate != null || user.startTime != null))
                  const SizedBox(height: 8),

                if (user.car?.name != null)
                  Row(
                    children: [
                      Icon(Icons.directions_car, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.vehicle.tr(),
                        style: context.textTheme.bodyMedium?.s12.regular.copyWith(
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${user.car!.name}${user.car!.color != null ? ' (${user.car!.color})' : ''}',
                          style: context.textTheme.bodyMedium?.s14.medium.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ).withPressEffect(onTap: () => context.push(Routes.userDetails, extra: user.id), onLongPress: () {});
  }
}
