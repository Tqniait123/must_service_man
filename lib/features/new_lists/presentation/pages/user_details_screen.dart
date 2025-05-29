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
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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

                  Row(
                    children: [
                      CustomIconButton(
                        iconAsset: AppIcons.cameraIc,
                        color: Color(0xffEAEAF3),
                        iconColor: AppColors.primary,
                        onPressed: () {},
                      ),
                      10.gap,
                      NotificationsButton(
                        color: Color(0xffEAEAF3),
                        iconColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    39.gap,

                    // Rounded Parking image
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            widget.user.photo ?? '',
                            height: 100, // Decreased height
                            width: 100, // Decreased width
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    30.gap,
                    // Parking Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.user.name,
                              style: context.titleLarge.copyWith(),
                            ),
                            // Parking Address
                            10.gap,
                            Text(
                              widget.user.address ?? '',
                              style: context.bodyMedium.s12.regular.copyWith(
                                color: AppColors.primary.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    30.gap,
                    // Parking Details
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                      '''
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
''',
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
