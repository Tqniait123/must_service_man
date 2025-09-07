// Driver Details Container Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

class DriverDetailsContainer extends StatelessWidget {
  final UserModel user;

  const DriverDetailsContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                12.gap,
                Text(
                  LocaleKeys.driver_details.tr(),
                  style: context.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Driver Image with enhanced styling
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      user.user?.image ?? '',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.person, size: 40, color: AppColors.primary),
                          ),
                    ),
                  ),
                ),
                20.gap,

                // Driver Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem(
                        icon: Icons.badge_outlined,
                        label: LocaleKeys.name.tr(),
                        value: user.user?.name ?? LocaleKeys.not_available.tr(),
                        isMain: true,
                      ),
                      12.gap,
                      _buildInfoItem(
                        icon: Icons.email_outlined,
                        label: LocaleKeys.email.tr(),
                        value: user.user?.email ?? LocaleKeys.not_available.tr(),
                      ),
                      if (user.user?.phone != null) ...[
                        12.gap,
                        _buildInfoItem(
                          icon: Icons.phone_outlined,
                          label: LocaleKeys.phone.tr(),
                          value: user.user!.phone!,
                        ),
                      ],
                      if (user.user?.city != null) ...[
                        12.gap,
                        _buildInfoItem(
                          icon: Icons.location_city_outlined,
                          label: LocaleKeys.city.tr(),
                          value: user.user!.city!,
                        ),
                      ],
                      // if (user.user?.points != null) ...[
                      //   12.gap,
                      //   _buildInfoItem(
                      //     icon: Icons.stars_outlined,
                      //     label: LocaleKeys.points.tr(),
                      //     value: user.user!.points!.toStringAsFixed(0),
                      //     valueColor: AppColors.primary,
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isMain = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        8.gap,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              2.gap,
              Text(
                value,
                style: TextStyle(
                  fontSize: isMain ? 16 : 14,
                  fontWeight: isMain ? FontWeight.bold : FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
