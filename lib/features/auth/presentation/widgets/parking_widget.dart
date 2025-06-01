import 'package:flutter/material.dart';
import 'package:must_invest_service_man/features/auth/data/models/parking_model.dart';

class ParkingCard extends StatelessWidget {
  final Parking parking;
  final bool isSelected;
  final VoidCallback onTap;

  const ParkingCard({
    super.key,
    required this.parking,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDE3FE) : const Color(0xFFF4F4FA),
          borderRadius: BorderRadius.circular(15),
          border:
              isSelected
                  ? Border.all(color: const Color(0xFF2B3085), width: 0.5)
                  : null,
        ),
        duration: const Duration(milliseconds: 200),
        child: Row(
          children: [
            // Parking Image
            Hero(
              tag: '${parking.id}-${parking.imageUrl}',
              child: ClipRRect(
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
            ),
            const SizedBox(width: 12),

            // Parking Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    parking.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B3085),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
