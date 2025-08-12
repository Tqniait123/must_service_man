
// Gates Section Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/gate_info_widget.dart';

class GatesSection extends StatelessWidget {
  final UserModel user;

  const GatesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Since the response doesn't have explicit entry/exit gates,
    // we'll show the entrance information
    if (user.entrance == null) {
      return const SizedBox.shrink();
    }

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
                LocaleKeys.gate_information.tr(),
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.gap,
          Center(
            child: GateInfo(
              icon: Icons.login,
              title: LocaleKeys.entrance_gate.tr(),
              value: user.entrance!,
            ),
          ),
        ],
      ),
    );
  }
}
