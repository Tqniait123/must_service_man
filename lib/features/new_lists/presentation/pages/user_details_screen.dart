import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
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

enum PaymentRequestStatus { none, pending, accepted, declined }

class UserDetails extends StatefulWidget {
  final int userId;
  const UserDetails({super.key, required this.userId});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  PaymentRequestStatus paymentStatus = PaymentRequestStatus.none;
  int parkingDuration = 3; // hours - example data
  double parkingPrice = 45.50; // example price
  int pointsToRequest = 2000; // example points

  Timer? _timer;
  String _elapsedTime = '';

  @override
  void initState() {
    super.initState();
    context.read<UserDetailsCubit>().getUserDetails(widget.userId);
  }

  void _startTimer(DateTime startTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final duration = now.difference(startTime);

      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

      setState(() {
        _elapsedTime = '$hours:$minutes:$seconds';
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _isUserCurrentlyInside(UserModel user) {
    return user.startTime != null && user.startTime!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsSuccess && _isUserCurrentlyInside(state.userModel)) {
              try {
                final formatter = DateFormat('dd-MM-yyyy hh:mm a', 'en_US');
                final startTime = formatter.parse(state.userModel.startTime!);
                if (_timer == null) {
                  _startTimer(startTime);
                }
              } catch (e) {
                log('Error parsing startTime: $e');
              }
            }

            return Column(
              children: [
                // Header
                SizedBox(height: 70, child: UserDetailsHeader()),

                // Sticky counter
                if (state is UserDetailsSuccess && _isUserCurrentlyInside(state.userModel))
                  Container(
                    width: double.infinity,
                    // margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.9),
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        children: [
                          // Status indicator with pulse animation
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.greenAccent.withOpacity(0.6), blurRadius: 8, spreadRadius: 2),
                              ],
                            ),
                          ),

                          16.gap,

                          // Icon with better styling
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.schedule_rounded, color: Colors.white, size: 20),
                          ),

                          12.gap,

                          // Status text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LocaleKeys.currently_inside.tr(),
                                  style: context.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Enhanced timer display
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_outlined, color: Colors.white.withOpacity(0.9), size: 16),
                                6.gap,
                                Text(
                                  _elapsedTime.isEmpty ? '00:00:00' : _elapsedTime,
                                  style: context.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFeatures: [const FontFeature.tabularFigures()],
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Content
                Expanded(child: _buildContent(state)),
              ],
            );
          },
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

  Widget _buildContent(UserDetailsState state) {
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
            Text(LocaleKeys.error_occurred.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            8.gap,
            Text(state.message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
  }

  Widget _buildUserDetailsContent(UserModel user) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          20.gap,
          DriverDetailsContainer(user: user),
          15.gap,
          CarDetailsContainer(user: user),
          15.gap,
          GatesSection(user: user),
          100.gap,
        ],
      ),
    );
  }

  void _handleEnterParking() {
    setState(() {});
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
