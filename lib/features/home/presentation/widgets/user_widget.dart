import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/flipped_for_lcale.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/long_press_effect.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';

class UserWidget extends StatelessWidget {
  final User user;

  const UserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(color: Color(0xffF4F4FA), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Container(
                    //   width: 80,
                    //   height: 80,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //     image: DecorationImage(
                    //       image:
                    //           user.photo != null
                    //               ? NetworkImage(user.photo!)
                    //               : NetworkImage(
                    //                 Constants.placeholderProfileImage,
                    //               ),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: context.textTheme.bodyMedium?.s16.bold.copyWith(color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   // user.address ?? '',
                          //   user.phone ?? '',
                          //   style: context.textTheme.bodyMedium?.s12.regular
                          //       .copyWith(
                          //         color: AppColors.primary.withValues(
                          //           alpha: 0.5,
                          //         ),
                          //       ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconButton(
                height: 30,
                width: 30,
                radius: 10,
                color: Color(0xffE2E4FF),
                iconAsset: AppIcons.arrowIc,
                onPressed: () {},
              ).flippedForLocale(context),
            ],
          ),
          const SizedBox(height: 16),

          // if (user.cars.isNotEmpty)
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       ...user.cars.map(
          //         (car) => Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 4.0),
          //           child: Row(
          //             children: [
          //               AppIcons.outlinedCarIcsvg.icon(),
          //               const SizedBox(width: 8),
          //               Text(
          //                 "${car.model} - ${car.id}",
          //                 style: context.textTheme.bodyMedium?.s14.regular
          //                     .copyWith(color: AppColors.primary),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    ).withPressEffect(onTap: () => context.push(Routes.userDetails, extra: user), onLongPress: () {});
  }
}
