import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/gate_info_widget.dart';

// Gates Section Widget
class GatesSection extends StatelessWidget {
  final User user;

  const GatesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.entryGate == null && user.exitGate == null) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.entryGate != null)
                GateInfo(
                  icon: Icons.login,
                  title: LocaleKeys.entry_gate.tr(),
                  value: user.entryGate!,
                ),
              if (user.exitGate != null)
                GateInfo(
                  icon: Icons.logout,
                  title: LocaleKeys.exit_gate.tr(),
                  value: user.exitGate!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
