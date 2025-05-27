import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/flipped_for_lcale.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/utils/widgets/scrolling_text.dart';
import 'package:must_invest_service_man/features/all/notifications/data/models/notification_model.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              12.gap,
              Expanded(
                child: Row(
                  children: [
                    AppIcons.notificationLabelIc.svg().flippedForLocale(
                      context,
                    ),
                    12.gap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: context.bodyMedium.semiBold.s16,
                          ),
                          4.gap,
                          Row(
                            children: [
                              Expanded(
                                child: ScrollingText(
                                  notification.description,
                                  style: context.bodyMedium.regular.s10
                                      .copyWith(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                ),
                              ),
                              8.gap,
                              Text(
                                notification.date,
                                style: context.bodyMedium.regular.s10.copyWith(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 20.gap,
              // MoneyText(
              //   amount: notification.transactionAmount.toString(),
              //   amountTextSize: 16,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
