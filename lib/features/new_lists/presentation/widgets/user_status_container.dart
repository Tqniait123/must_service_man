
// User Status Container Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/detail_row_widget.dart';

class UserStatusContainer extends StatelessWidget {
  final UserModel user;

  const UserStatusContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              10.gap,
              Text(
                LocaleKeys.parking_information.tr(),
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.gap,
          if (user.parking != null) ...[
            DetailRow(
              label: LocaleKeys.parking_name.tr(),
              value: user.parking!
            ),
            8.gap,
          ],
          if (user.entrance != null) ...[
            DetailRow(
              label: LocaleKeys.entrance.tr(),
              value: user.entrance!
            ),
            8.gap,
          ],
          if (user.startTime != null) ...[
            DetailRow(
              label: LocaleKeys.start_time.tr(),
              value: user.startTime!
            ),
            8.gap,
          ],
          if (user.duration != null) ...[
            DetailRow(
              label: LocaleKeys.duration.tr(),
              value: user.duration!
            ),
            8.gap,
          ],
          if (user.cost != null) ...[
            DetailRow(
              label: LocaleKeys.cost.tr(),
              value: "${user.cost!} ${LocaleKeys.currency.tr()}"
            ),
            8.gap,
          ],
          if (user.points != null) ...[
            DetailRow(
              label: LocaleKeys.earned_points.tr(),
              value: user.points!.toStringAsFixed(0)
            ),
          ],
        ],
      ),
    );
  }
}
