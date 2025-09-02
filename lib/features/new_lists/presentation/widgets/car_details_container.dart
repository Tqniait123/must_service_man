// Car Details Container Widget - Improved Layout
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

class CarDetailsContainer extends StatelessWidget {
  final UserModel user;

  const CarDetailsContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final car = user.car;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.directions_car, color: AppColors.primary, size: 20),
                ),
                12.gap,
                Text(
                  LocaleKeys.car_details.tr(),
                  style: context.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          if (car != null) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Car Image with stacked approval tag
                  if (car.carPhoto != null) ...[
                    Stack(
                      children: [
                        Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              car.carPhoto!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey[100],
                                    child: Icon(Icons.directions_car, size: 60, color: Colors.grey[400]),
                                  ),
                            ),
                          ),
                        ),

                        // Approval status tag stacked on image
                        if (car.approved != null)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: car.approved == "Yes" ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    car.approved == "Yes" ? Icons.check_circle_outline : Icons.error_outline,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  4.gap,
                                  Text(
                                    car.approved == "Yes" ? LocaleKeys.approved.tr() : LocaleKeys.not_approved.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    20.gap,
                  ],

                  // Car details in grid layout with equal heights
                  _buildCarDetailsGrid(car),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.directions_car_outlined, size: 48, color: Colors.grey[400]),
                      12.gap,
                      Text(
                        LocaleKeys.no_car_information.tr(),
                        style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarDetailsGrid(car) {
    // Create list of detail items
    List<DetailItem> details = [];

    if (car.name != null) {
      details.add(
        DetailItem(
          icon: Icons.directions_car_outlined,
          label: LocaleKeys.car_name.tr(),
          value: car.name!,
          isHighlighted: false,
        ),
      );
    }

    if (car.color != null) {
      details.add(
        DetailItem(
          icon: Icons.palette_outlined,
          label: LocaleKeys.car_color.tr(),
          value: car.color!,
          isHighlighted: false,
        ),
      );
    }

    if (car.metalPlate != null) {
      details.add(
        DetailItem(
          icon: Icons.confirmation_number_outlined,
          label: LocaleKeys.car_number.tr(),
          value: car.metalPlate!,
          isHighlighted: true,
        ),
      );
    }

    if (car.manufactureYear != null) {
      details.add(
        DetailItem(
          icon: Icons.calendar_today_outlined,
          label: LocaleKeys.manufacture_year.tr(),
          value: car.manufactureYear!,
          isHighlighted: false,
        ),
      );
    }

    // Use Row for horizontal layout with equal sized smaller cards
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            details.asMap().entries.map((entry) {
              final index = entry.key;
              final detail = entry.value;
              return Padding(
                padding: EdgeInsets.only(right: index < details.length - 1 ? 10 : 0),
                child: SizedBox(
                  width: 90, // Fixed smaller width
                  height: 100, // Fixed smaller height
                  child: _buildDetailCard(
                    icon: detail.icon,
                    label: detail.label,
                    value: detail.value,
                    isHighlighted: detail.isHighlighted,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isHighlighted ? AppColors.primary.withOpacity(0.3) : Colors.grey[200]!, width: 1.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isHighlighted ? AppColors.primary.withOpacity(0.2) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: isHighlighted ? AppColors.primary : Colors.grey[600]),
            ),

            6.gap,

            // Label
            Text(
              label,
              style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            2.gap,

            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? AppColors.primary : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for detail items
class DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;

  DetailItem({required this.icon, required this.label, required this.value, required this.isHighlighted});
}
