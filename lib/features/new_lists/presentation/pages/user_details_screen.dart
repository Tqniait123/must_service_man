import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/payment_widgets.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/user_header_widget.dart';

enum PaymentRequestStatus { none, pending, accepted, declined }

class UserDetails extends StatefulWidget {
  final UserModel user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  PaymentRequestStatus paymentStatus = PaymentRequestStatus.none;
  int parkingDuration = 3; // hours - example data
  double parkingPrice = 45.50; // example price
  int pointsToRequest = 2000; // example points

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            UserDetailsHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    20.gap,

                    // DriverDetailsContainer(user: widget.user),

                    // // User Status Container
                    // 15.gap,

                    // // Car Details Container
                    // CarDetailsContainer(user: widget.user),

                    // 15.gap,
                    // UserStatusContainer(user: widget.user),

                    // // Driver Details Container
                    // 20.gap,

                    // // Gates Section
                    // GatesSection(user: widget.user),
                    100.gap, // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: UserDetailsBottomButton(
      //   user: widget.user,
      //   paymentStatus: paymentStatus,
      //   parkingDuration: parkingDuration,
      //   parkingPrice: parkingPrice,
      //   pointsToRequest: pointsToRequest,
      //   onEnterParking: _handleEnterParking,
      //   onRequestPayment: _handleRequestPayment,
      //   onShowPaymentStatus: _showPaymentStatusBottomSheet,
      // ),
    );
  }

  void _handleEnterParking() {
    // Handle enter parking logic
    setState(() {
      // Update status if needed
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.parking_entry_granted.tr())));
  }

  void _handleRequestPayment() {
    setState(() {
      paymentStatus = PaymentRequestStatus.pending;
    });
    _showPaymentStatusBottomSheet();
  }

  void _showPaymentStatusBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => PaymentStatusBottomSheet(
            paymentStatus: paymentStatus,
            parkingDuration: parkingDuration,
            parkingPrice: parkingPrice,
            pointsToRequest: pointsToRequest,
            onStatusChanged: (newStatus) {
              setState(() {
                paymentStatus = newStatus;
              });
            },
          ),
    );
  }
}
