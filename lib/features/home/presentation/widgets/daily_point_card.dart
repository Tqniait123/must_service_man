import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/daily_point_model.dart';

class DailyPointCard extends StatelessWidget {
  final DailyPointModel dailyPoint;

  const DailyPointCard({super.key, required this.dailyPoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - User Info and Points
          Row(
            children: [
              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                  image:
                      dailyPoint.userPhoto != null
                          ? DecorationImage(image: NetworkImage(dailyPoint.userPhoto!), fit: BoxFit.cover)
                          : null,
                ),
                child:
                    dailyPoint.userPhoto == null
                        ? Icon(Icons.person, color: AppColors.primary.withOpacity(0.7), size: 24)
                        : null,
              ),
              12.gap,

              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dailyPoint.displayUserName,
                      style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    4.gap,
                    if (dailyPoint.userEmail != null)
                      Text(
                        dailyPoint.userEmail!,
                        style: context.bodySmall.s12.copyWith(color: AppColors.primary.withOpacity(0.6)),
                      ),
                  ],
                ),
              ),

              // Points Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.white, size: 16),
                    4.gap,
                    Text(
                      '+${dailyPoint.displayPoints}',
                      style: context.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          16.gap,

          // Car Details Row
          Row(
            children: [
              Icon(Icons.directions_car, color: AppColors.primary.withOpacity(0.7), size: 18),
              8.gap,
              Expanded(
                child: Text(
                  dailyPoint.displayCarInfo,
                  style: context.bodyMedium.s14.copyWith(
                    color: AppColors.primary.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  dailyPoint.displayPlateNumber,
                  style: context.bodySmall.s12.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          12.gap,

          // Divider
          Container(height: 1, width: double.infinity, color: AppColors.primary.withOpacity(0.1)),

          12.gap,

          // Parking Details
          Row(
            children: [
              // Time Info
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.access_time,
                  title: LocaleKeys.entry_time.tr(),
                  value: _formatTime(dailyPoint.entryTime),
                  context: context,
                ),
              ),

              // Duration Info
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.timer_outlined,
                  title: LocaleKeys.duration_time.tr(),
                  value: dailyPoint.displayDuration,
                  context: context,
                ),
              ),
            ],
          ),

          12.gap,

          Row(
            children: [
              // Entrance Info
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.login,
                  title: LocaleKeys.entrance_gate.tr(),
                  value: dailyPoint.displayEntrance,
                  context: context,
                ),
              ),

              // Cost Info
              if (dailyPoint.cost != null)
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.payments_outlined,
                    title: LocaleKeys.parking_fee.tr(),
                    value: '${dailyPoint.cost} ${LocaleKeys.EGP.tr()}',
                    context: context,
                  ),
                ),
            ],
          ),

          if (dailyPoint.pointSource != null) ...[
            12.gap,

            // Point Source
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary.withOpacity(0.6), size: 16),
                8.gap,
                Text(
                  '${LocaleKeys.point_source.tr()}: ${dailyPoint.pointSource}',
                  style: context.bodySmall.s12.copyWith(
                    color: AppColors.primary.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],

          if (dailyPoint.createdAt != null) ...[
            8.gap,

            // Timestamp
            Row(
              children: [
                Icon(Icons.schedule, color: AppColors.primary.withOpacity(0.5), size: 14),
                6.gap,
                Text(
                  _formatDateTime(dailyPoint.createdAt),
                  style: context.bodySmall.s11.copyWith(color: AppColors.primary.withOpacity(0.5)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary.withOpacity(0.6), size: 16),
            6.gap,
            Text(title, style: context.bodySmall.s11.copyWith(color: AppColors.primary.withOpacity(0.6))),
          ],
        ),
        4.gap,
        Text(
          value,
          style: context.bodyMedium.s14.copyWith(
            color: AppColors.primary.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTime(String? time) {
    if (time == null) return LocaleKeys.unknown.tr();

    try {
      final DateTime parsedTime = DateTime.parse(time);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return '';

    try {
      final DateTime parsed = DateTime.parse(dateTime);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return dateTime;
    }
  }
}
