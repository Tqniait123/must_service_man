// User Status Container Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

class UserStatusContainer extends StatelessWidget {
  final UserModel user;

  const UserStatusContainer({super.key, required this.user});

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return LocaleKeys.not_available.tr();
    
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.1),
                  Colors.orange.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_parking,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                ),
                12.gap,
                Text(
                  LocaleKeys.parking_details.tr(),
                  style: context.titleMedium.copyWith(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Left column
                    Expanded(
                      child: Column(
                        children: [
                          if (user.parking != null)
                            _buildParkingDetailCard(
                              icon: Icons.business,
                              name: LocaleKeys.parking_facility_name.tr(),
                              value: user.parking!,
                              color: Colors.blue,
                            ),
                          12.gap,
                          if (user.startTime != null)
                            _buildParkingDetailCard(
                              icon: Icons.access_time,
                              name: LocaleKeys.entry_time.tr(),
                              value: _formatDateTime(user.startTime),
                              color: Colors.green,
                            ),
                          12.gap,
                          if (user.cost != null)
                            _buildParkingDetailCard(
                              icon: Icons.attach_money,
                              name: LocaleKeys.parking_fee.tr(),
                              value: "${user.cost!} ${LocaleKeys.currency.tr()}",
                              color: Colors.purple,
                            ),
                        ],
                      ),
                    ),
                    
                    16.gap,
                    
                    // Right column
                    Expanded(
                      child: Column(
                        children: [
                          if (user.entrance != null)
                            _buildParkingDetailCard(
                              icon: Icons.login,
                              name: LocaleKeys.entrance_gate.tr(),
                              value: user.entrance!,
                              color: Colors.teal,
                            ),
                          12.gap,
                          if (user.duration != null)
                            _buildParkingDetailCard(
                              icon: Icons.timer,
                              name: LocaleKeys.duration_time.tr(),
                              value: user.duration!,
                              color: Colors.orange,
                            ),
                          12.gap,
                          if (user.points != null)
                            _buildParkingDetailCard(
                              icon: Icons.stars,
                              name: LocaleKeys.reward_points.tr(),
                              value: user.points!.toStringAsFixed(0),
                              color: Colors.amber[700]!,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingDetailCard({
    required IconData icon,
    required String name,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          12.gap,
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          6.gap,
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}