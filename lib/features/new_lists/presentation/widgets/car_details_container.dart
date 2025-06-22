import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/detail_row_widget.dart';

// Car Details Container Widget
class CarDetailsContainer extends StatelessWidget {
  final User user;

  const CarDetailsContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // final car = user.cars.isNotEmpty ? user.cars.first : null;
    final car = Car(id: '123', model: 'Toyota Camry', plateNumber: 'ABC 123');
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
          ...[
            DetailRow(label: LocaleKeys.car_model.tr(), value: car.model ?? LocaleKeys.not_available.tr()),
            8.gap,
            DetailRow(label: LocaleKeys.car_number.tr(), value: car.plateNumber ?? LocaleKeys.not_available.tr()),
          ],
        ],
      ),
    );
  }
}
