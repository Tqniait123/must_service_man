import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/static/app_assets.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';

class MyPointsCard extends StatelessWidget {
  const MyPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xff99ABC6).withValues(alpha: 0.3),
            spreadRadius: 0,
            blurRadius: 30,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff99ABC6).withValues(alpha: 0.2),
                          spreadRadius: 0,
                          blurRadius: 30,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(AppImages.sun, width: 30, height: 30),
                  ),
                  12.gap,
                  Column(
                    children: [
                      Text(
                        LocaleKeys.my_points.tr(),
                        style: context.bodyMedium.bold.s16,
                      ),
                      4.gap,
                      Text(
                        "12000 ${LocaleKeys.point.tr()}",
                        style: context.bodyMedium.s12.regular.copyWith(
                          color: AppColors.greyAF,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(
                    Icons.arrow_drop_up_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),
                  4.gap,
                  Text(
                    "+15%",
                    style: context.bodyMedium.s14.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 2, child: SizedBox(height: 44)),
              Expanded(
                child: CustomElevatedButton(
                  height: 44,
                  title: LocaleKeys.withdraw.tr(),
                  onPressed: () {
                    context.push(Routes.withdrawRequest);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Design 2: Minimalist Card with Accent
class MyPointsCardMinimal extends StatelessWidget {
  const MyPointsCardMinimal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: AppColors.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              16.gap,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.my_points.tr(),
                      style: context.bodyMedium.s14.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    4.gap,
                    Row(
                      children: [
                        Text(
                          "12,000",
                          style: context.bodyMedium.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        8.gap,
                        Text(
                          LocaleKeys.point.tr(),
                          style: context.bodyMedium.s14.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppColors.primary,
                      size: 14,
                    ),
                    2.gap,
                    Text(
                      "15%",
                      style: context.bodyMedium.s12.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.gap,
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push(Routes.withdrawRequest),
                child: Center(
                  child: Text(
                    LocaleKeys.withdraw.tr(),
                    style: context.bodyMedium.s14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
