// Bottom Button Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/pages/user_details_screen.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/parking_info_container.dart';

class UserDetailsBottomButton extends StatelessWidget {
  final UserModel user;
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(top: false, child: _buildButtonByUserData(context)),
    );
  }

  Widget _buildButtonByUserData(BuildContext context) {
    // Determine status based on user data
    // Since we don't have explicit status, we'll use available data to infer
    final hasStartTime = user.startTime != null;
    final hasDuration = user.duration != null;

    if (!hasStartTime) {
      // User hasn't entered yet
      return CustomElevatedButton(
        onPressed: onEnterParking,
        title: LocaleKeys.enter_parking.tr(),
        backgroundColor: Colors.green,
      );
    } else if (hasStartTime && hasDuration) {
      // User has entered and has duration (currently inside)
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
            parkingPrice: double.tryParse(user.cost ?? '0') ?? parkingPrice,
            pointsToRequest: user.points?.toInt() ?? pointsToRequest,
          ),
          12.gap,
          CustomElevatedButton(
            onPressed: onRequestPayment,
            title: LocaleKeys.request_payment.tr(),
            backgroundColor: AppColors.primary,
          ),
        ],
      );
    } else {
      // Default case - user has exited or unknown status
      return CustomElevatedButton(onPressed: null, title: LocaleKeys.session_ended.tr(), backgroundColor: Colors.grey);
    }
  }
}
