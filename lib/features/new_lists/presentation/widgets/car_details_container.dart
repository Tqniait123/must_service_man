// Car Details Container Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/detail_row_widget.dart';

class CarDetailsContainer extends StatelessWidget {
  final UserModel user;

  const CarDetailsContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final car = user.car;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              10.gap,
              Text(LocaleKeys.car_details.tr(), style: context.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          16.gap,
          if (car != null) ...[
            // Car Image
            if (car.carPhoto != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  car.carPhoto!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(Icons.directions_car, size: 40, color: Colors.grey[500]),
                      ),
                ),
              ),
              16.gap,
            ],
            DetailRow(label: LocaleKeys.car_name.tr(), value: car.name ?? LocaleKeys.not_available.tr()),
            8.gap,
            if (car.color != null) ...[DetailRow(label: LocaleKeys.car_color.tr(), value: car.color!), 8.gap],
            if (car.metalPlate != null) ...[
              DetailRow(label: LocaleKeys.car_number.tr(), value: car.metalPlate!),
              8.gap,
            ],
            if (car.manufactureYear != null) ...[
              DetailRow(label: LocaleKeys.manufacture_year.tr(), value: car.manufactureYear!),
              8.gap,
            ],
            if (car.approved != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: car.approved == "Yes" ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  car.approved == "Yes" ? LocaleKeys.approved.tr() : LocaleKeys.not_approved.tr(),
                  style: TextStyle(
                    color: car.approved == "Yes" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ] else ...[
            Text(
              LocaleKeys.no_car_information.tr(),
              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
