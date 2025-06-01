import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';

// Parking Info Container Widget
class ParkingInfoContainer extends StatelessWidget {
  final int parkingDuration;
  final double parkingPrice;
  final int pointsToRequest;

  const ParkingInfoContainer({
    super.key,
    required this.parkingDuration,
    required this.parkingPrice,
    required this.pointsToRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ParkingInfoItem(
            label: LocaleKeys.duration.tr(),
            value: LocaleKeys.hours_format.tr(
              namedArgs: {'hours': parkingDuration.toString()},
            ),
          ),
          ParkingInfoItem(
            label: LocaleKeys.price.tr(),
            value: LocaleKeys.currency_format.tr(
              namedArgs: {'amount': parkingPrice.toStringAsFixed(2)},
            ),
          ),
          ParkingInfoItem(
            label: LocaleKeys.points.tr(),
            value: LocaleKeys.points_format.tr(
              namedArgs: {'points': pointsToRequest.toString()},
            ),
          ),
        ],
      ),
    );
  }
}

// Parking Info Item Widget
class ParkingInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const ParkingInfoItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
