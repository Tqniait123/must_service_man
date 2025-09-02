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
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xffF4F4FA),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
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
                                color: AppColors.primary.withOpacity(0.5),
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
                onPressed: () => context.push(Routes.userDetails, extra: user.id),
              ).flippedForLocale(context),
            ],
          ),

          // Split Car and Parking Information
          if (_buildInfoItems().isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: _buildInfoItems()),
          ],
        ],
      ),
    ).withPressEffect(onTap: () => context.push(Routes.userDetails, extra: user.id), onLongPress: () {});
  }

  List<Widget> _buildInfoItems() {
    final items = <Widget>[];

    if (user.car?.metalPlate != null) {
      items.add(
        InfoItemContainer(
          icon: Icons.local_taxi_outlined,
          value: user.car!.metalPlate!,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          iconColor: AppColors.primary,
        ),
      );
    }

    if (user.startTime != null) {
      items.add(
        InfoItemContainer(
          icon: Icons.schedule_outlined,
          value: _formatDateTime(user.startTime),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          iconColor: AppColors.primary,
        ),
      );
    }

    if (user.car?.name != null) {
      final carText = '${user.car!.name}${user.car!.color != null ? ' • ${user.car!.color}' : ''}';
      items.add(
        InfoItemContainer(
          icon: Icons.directions_car_outlined,
          value: carText,
          backgroundColor: AppColors.primary.withOpacity(0.1),
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
    return GestureDetector(
      onTap: () {}, // Add functionality if needed
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: iconColor.withOpacity(0.3), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: context.textTheme.bodyMedium?.s11.medium.copyWith(color: iconColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
