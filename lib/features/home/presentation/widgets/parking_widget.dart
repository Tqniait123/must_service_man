import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/parking_model.dart';

class ParkingCard extends StatelessWidget {
  final Parking parking;

  const ParkingCard({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.parkingDetails, extra: parking);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4FA),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Parking Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                parking.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Parking Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    parking.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3085),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Address
                  Text(
                    parking.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2B3085).withOpacity(0.5),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price per hour
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${LocaleKeys.EGP.tr()} ${parking.pricePerHour.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B3085),
                          ),
                        ),
                        TextSpan(
                          text: "/${LocaleKeys.hour.tr()}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2B3085),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Distance from me
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${parking.distanceInMinutes} ${LocaleKeys.min.tr()}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3085),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
