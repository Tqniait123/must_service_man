import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/loading/loading_widget.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/home/presentation/cubit/cubit/user_details_cubit_cubit.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/car_details_container.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/driver_details_container.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/gates_section.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/payment_widgets.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/user_details_bottom_buttons.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/user_header_widget.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/user_status_container.dart';

enum PaymentRequestStatus { none, pending, accepted, declined }

class UserDetails extends StatefulWidget {
  final int userId;
  const UserDetails({super.key, required this.userId,});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  PaymentRequestStatus paymentStatus = PaymentRequestStatus.none;
  int parkingDuration = 3; // hours - example data
  double parkingPrice = 45.50; // example price
  int pointsToRequest = 2000; // example points

  @override
  void initState() {
    super.initState();
    context.read<UserDetailsCubit>().getUserDetails(widget.userId);
  }

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
              child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
                builder: (context, state) {
                  if (state is UserDetailsLoading) {
                    return const Center(child: LoadingWidget());
                  }

                  if (state is UserDetailsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                          16.gap,
                          Text(
                            LocaleKeys.error_occurred.tr(),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          8.gap,
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          24.gap,
                          ElevatedButton(
                            onPressed: () {
                              context.read<UserDetailsCubit>().getUserDetails(widget.userId);
                            },
                            child: Text(LocaleKeys.retry.tr()),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is UserDetailsSuccess) {
                    return _buildUserDetailsContent(state.userModel);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<UserDetailsCubit, UserDetailsState>(
        builder: (context, state) {
          if (state is UserDetailsSuccess) {
            return UserDetailsBottomButton(
              user: state.userModel,
              paymentStatus: paymentStatus,
              parkingDuration: parkingDuration,
              parkingPrice: parkingPrice,
              pointsToRequest: pointsToRequest,
              onEnterParking: _handleEnterParking,
              onRequestPayment: _handleRequestPayment,
              onShowPaymentStatus: _showPaymentStatusBottomSheet,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUserDetailsContent(UserModel user) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          20.gap,

          DriverDetailsContainer(user: user),

          // User Status Container
          15.gap,

          // Car Details Container
          CarDetailsContainer(user: user),

          15.gap,
          UserStatusContainer(user: user),

          // Driver Details Container
          20.gap,

          // Gates Section
          GatesSection(user: user),
          100.gap, // Space for bottom button
        ],
      ),
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
