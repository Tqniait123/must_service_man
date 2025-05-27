import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/features/home/data/models/parking_model.dart';

class ParkingDetailsScreen extends StatefulWidget {
  final Parking parking;
  const ParkingDetailsScreen({super.key, required this.parking});

  @override
  State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  Text(
                    LocaleKeys.details.tr(),
                    style: context.titleLarge.copyWith(),
                  ),
                  NotificationsButton(
                    color: Color(0xffEAEAF3),
                    iconColor: AppColors.primary,
                  ),
                ],
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    22.gap,

                    // Rounded Parking image
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(widget.parking.imageUrl),
                        ),
                        Positioned(
                          bottom: -20,
                          child: FloatingActionButton(
                            onPressed: () {
                              // context.push(
                              //   Routes.routing,
                              //   extra: widget.parking,
                              // );
                            },
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.my_location_rounded,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    30.gap,
                    // Parking Name
                    Text(
                      widget.parking.title,
                      style: context.titleLarge.copyWith(),
                    ),
                    // Parking Address
                    10.gap,
                    Text(
                      widget.parking.address,
                      style: context.bodyMedium.s12.regular.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    30.gap,
                    // Parking Details
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomDetailsInfo(
                              title: '500 m away',
                              icon: AppIcons.outlinedLocationIc,
                            ),
                            32.gap,
                            CustomDetailsInfo(
                              title: '7 mins',
                              icon: AppIcons.outlinedClockIc,
                            ),
                          ],
                        ),
                        15.gap,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomDetailsInfo(
                              title: '200 \$',
                              icon: AppIcons.outlinedPriceIc,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Parking Description
                    30.gap,
                    Text(
                      widget.parking.information,
                      style: context.bodyMedium.s12.regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).paddingHorizontal(20),
      ),
    );
  }
}

class CustomDetailsInfo extends StatelessWidget {
  final String title;
  final String icon;
  const CustomDetailsInfo({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          icon.icon(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B3085),
            ),
          ),
        ],
      ),
    );
  }
}
