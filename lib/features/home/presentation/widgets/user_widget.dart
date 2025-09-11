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

  String _formatDateTime(String? dateTimeString, context) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return LocaleKeys.unknown.tr();
    }
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy • hh:mm a', context.locale.toString()).format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.userDetails, extra: user.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  user.user?.image ?? Constants.placeholderProfileImage,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Image.network(Constants.placeholderProfileImage, fit: BoxFit.cover),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.user?.name ?? LocaleKeys.unknown_user.tr(),
                        style: context.textTheme.bodyLarge?.s16.bold.copyWith(color: AppColors.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomIconButton(
                        height: 36,
                        width: 36,
                        radius: 10,
                        color: AppColors.primary.withOpacity(0.1),
                        iconAsset: AppIcons.arrowIc,
                        onPressed: () => context.push(Routes.userDetails, extra: user.id),
                      ).flippedForLocale(context),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: _buildInfoItems(context)),
                ],
              ),
            ),

            // Action Button
          ],
        ),
      ).withPressEffect(onTap: () => context.push(Routes.userDetails, extra: user.id), onLongPress: () {}),
    );
  }

  List<Widget> _buildInfoItems(BuildContext context) {
    final items = <Widget>[];

    if (user.car?.name != null) {
      final carText = '${user.car!.name}${user.car!.color != null ? ' • ${user.car!.color}' : ''}';
      items.add(
        InfoItemContainer(
          icon: Icons.directions_car_outlined,
          value: carText,
          backgroundColor: AppColors.primary.withOpacity(0.05),
          iconColor: AppColors.primary,
        ),
      );
    }

    if (user.car?.metalPlate != null) {
      items.add(
        InfoItemContainer(
          icon: Icons.local_taxi_outlined,
          value: user.car!.metalPlate!,
          backgroundColor: AppColors.primary.withOpacity(0.05),
          iconColor: AppColors.primary,
        ),
      );
    }

    if (user.startTime != null) {
      items.add(
        InfoItemContainer(
          icon: Icons.schedule_outlined,
          value: _formatDateTime(user.startTime, context),
          backgroundColor: AppColors.primary.withOpacity(0.05),
          iconColor: AppColors.primary,
        ),
      );
    }

    return items;
  }
}

class InfoItemContainer extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color backgroundColor;
  final Color iconColor;

  const InfoItemContainer({
    super.key,
    required this.icon,
    required this.value,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: context.textTheme.bodySmall?.s12.medium.copyWith(color: iconColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
