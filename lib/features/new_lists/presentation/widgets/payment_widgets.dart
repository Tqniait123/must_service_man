import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/pages/user_details_screen.dart';

// Payment Status Bottom Sheet Widget
class PaymentStatusBottomSheet extends StatefulWidget {
  final PaymentRequestStatus paymentStatus;
  final int parkingDuration;
  final double parkingPrice;
  final int pointsToRequest;
  final Function(PaymentRequestStatus) onStatusChanged;

  const PaymentStatusBottomSheet({
    super.key,
    required this.paymentStatus,
    required this.parkingDuration,
    required this.parkingPrice,
    required this.pointsToRequest,
    required this.onStatusChanged,
  });

  @override
  State<PaymentStatusBottomSheet> createState() =>
      _PaymentStatusBottomSheetState();
}

class _PaymentStatusBottomSheetState extends State<PaymentStatusBottomSheet> {
  late PaymentRequestStatus currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.paymentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          20.gap,

          // Icon and title
          PaymentStatusIcon(status: currentStatus),
          16.gap,

          PaymentStatusTitle(status: currentStatus),
          8.gap,

          PaymentStatusMessage(status: currentStatus),

          if (currentStatus == PaymentRequestStatus.pending) ...[
            24.gap,
            // Payment details
            PaymentDetailsContainer(
              parkingDuration: widget.parkingDuration,
              parkingPrice: widget.parkingPrice,
              pointsToRequest: widget.pointsToRequest,
            ),
            24.gap,

            // Simulate buttons for testing
            PaymentSimulationButtons(
              onAccept: () {
                setState(() {
                  currentStatus = PaymentRequestStatus.accepted;
                });
                widget.onStatusChanged(currentStatus);
              },
              onDecline: () {
                setState(() {
                  currentStatus = PaymentRequestStatus.declined;
                });
                widget.onStatusChanged(currentStatus);
              },
            ),
          ] else ...[
            24.gap,
            CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onStatusChanged(PaymentRequestStatus.none);
              },
              title: LocaleKeys.close.tr(),
              backgroundColor: AppColors.primary,
            ),
          ],

          24.gap,
        ],
      ),
    );
  }
}

// Payment Status Icon Widget
class PaymentStatusIcon extends StatelessWidget {
  final PaymentRequestStatus status;

  const PaymentStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Icon(
      status == PaymentRequestStatus.pending
          ? Icons.pending_actions
          : status == PaymentRequestStatus.accepted
          ? Icons.check_circle
          : Icons.cancel,
      size: 64,
      color:
          status == PaymentRequestStatus.pending
              ? Colors.orange
              : status == PaymentRequestStatus.accepted
              ? Colors.green
              : Colors.red,
    );
  }
}

// Payment Status Title Widget
class PaymentStatusTitle extends StatelessWidget {
  final PaymentRequestStatus status;

  const PaymentStatusTitle({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      _getPaymentStatusTitle(),
      style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  String _getPaymentStatusTitle() {
    switch (status) {
      case PaymentRequestStatus.pending:
        return LocaleKeys.payment_request_sent.tr();
      case PaymentRequestStatus.accepted:
        return LocaleKeys.payment_accepted.tr();
      case PaymentRequestStatus.declined:
        return LocaleKeys.payment_declined.tr();
      default:
        return '';
    }
  }
}

// Payment Status Message Widget
class PaymentStatusMessage extends StatelessWidget {
  final PaymentRequestStatus status;

  const PaymentStatusMessage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      _getPaymentStatusMessage(),
      style: TextStyle(color: Colors.grey[600], fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  String _getPaymentStatusMessage() {
    switch (status) {
      case PaymentRequestStatus.pending:
        return LocaleKeys.waiting_for_user_response.tr();
      case PaymentRequestStatus.accepted:
        return LocaleKeys.payment_accepted_message.tr();
      case PaymentRequestStatus.declined:
        return LocaleKeys.payment_declined_message.tr();
      default:
        return '';
    }
  }
}

// Payment Details Container Widget
class PaymentDetailsContainer extends StatelessWidget {
  final int parkingDuration;
  final double parkingPrice;
  final int pointsToRequest;

  const PaymentDetailsContainer({
    super.key,
    required this.parkingDuration,
    required this.parkingPrice,
    required this.pointsToRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          PaymentDetailRow(
            label: LocaleKeys.duration.tr(),
            value: LocaleKeys.hours_format.tr(
              namedArgs: {'hours': parkingDuration.toString()},
            ),
          ),
          8.gap,
          PaymentDetailRow(
            label: LocaleKeys.amount.tr(),
            value: LocaleKeys.currency_format.tr(
              namedArgs: {'amount': parkingPrice.toStringAsFixed(2)},
            ),
          ),
          8.gap,
          PaymentDetailRow(
            label: LocaleKeys.points_required.tr(),
            value: LocaleKeys.points_format.tr(
              namedArgs: {'points': pointsToRequest.toString()},
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Detail Row Widget
class PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const PaymentDetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

// Payment Simulation Buttons Widget
class PaymentSimulationButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const PaymentSimulationButtons({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: onDecline,
            title: LocaleKeys.simulate_decline.tr(),
            backgroundColor: Colors.red,
          ),
        ),
        12.gap,
        Expanded(
          child: CustomElevatedButton(
            onPressed: onAccept,
            title: LocaleKeys.simulate_accept.tr(),
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
