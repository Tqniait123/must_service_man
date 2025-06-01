import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/pages/user_details_screen.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/parking_info_container.dart';

// Bottom Button Widget
class UserDetailsBottomButton extends StatelessWidget {
  final User user;
  final PaymentRequestStatus paymentStatus;
  final int parkingDuration;
  final double parkingPrice;
  final int pointsToRequest;
  final VoidCallback onEnterParking;
  final VoidCallback onRequestPayment;
  final VoidCallback onShowPaymentStatus;

  const UserDetailsBottomButton({
    super.key,
    required this.user,
    required this.paymentStatus,
    required this.parkingDuration,
    required this.parkingPrice,
    required this.pointsToRequest,
    required this.onEnterParking,
    required this.onRequestPayment,
    required this.onShowPaymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(top: false, child: _buildButtonByStatus(context)),
    );
  }

  Widget _buildButtonByStatus(BuildContext context) {
    switch (user.status) {
      case ParkingStatus.newEntry:
        return CustomElevatedButton(
          onPressed: onEnterParking,
          title: LocaleKeys.enter_parking.tr(),
          backgroundColor: Colors.green,
        );

      case ParkingStatus.inside:
        if (paymentStatus == PaymentRequestStatus.pending) {
          return CustomElevatedButton(
            onPressed: onShowPaymentStatus,
            title: LocaleKeys.payment_pending.tr(),
            backgroundColor: Colors.orange,
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Parking info
            ParkingInfoContainer(
              parkingDuration: parkingDuration,
              parkingPrice: parkingPrice,
              pointsToRequest: pointsToRequest,
            ),
            12.gap,
            CustomElevatedButton(
              onPressed: onRequestPayment,
              title: LocaleKeys.request_payment.tr(),
              backgroundColor: AppColors.primary,
            ),
          ],
        );

      case ParkingStatus.exited:
      default:
        return CustomElevatedButton(
          onPressed: null,
          title: LocaleKeys.already_exited.tr(),
          backgroundColor: Colors.grey,
        );
    }
  }
}
