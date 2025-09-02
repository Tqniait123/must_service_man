// Gates Section Widget
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/user_model.dart';

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.withOpacity(0.1), Colors.indigo.withOpacity(0.05)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigo.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.sensors, color: Colors.white, size: 20),
                ),
                12.gap,
                Text(
                  LocaleKeys.gate_access_information.tr(),
                  style: context.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Gate Information Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: _buildGateInfoCard(
                    icon: Icons.login,
                    gateName: LocaleKeys.entry_gate.tr(),
                    gateValue: user.entrance!,
                    gateStatus: LocaleKeys.active_gate.tr(),
                    color: Colors.green,
                  ),
                ),

                20.gap,

                // Connection line
                Container(
                  height: 2,
                  width: 30,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green, Colors.indigo])),
                ),

                20.gap,

                Expanded(
                  child: _buildGateInfoCard(
                    icon: Icons.logout,
                    gateName: LocaleKeys.exit_gate.tr(),
                    gateValue: '---',
                    gateStatus: LocaleKeys.standby_mode.tr(),
                    color: Colors.indigo,
                    isDisabled: true,
                  ),
                ),
              ],
            ),
          ),

          // Additional gate information
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.indigo, size: 18),
                12.gap,
                Expanded(
                  child: Text(
                    LocaleKeys.gate_system_note.tr(),
                    style: TextStyle(fontSize: 12, color: Colors.indigo[700], fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGateInfoCard({
    required IconData icon,
    required String gateName,
    required String gateValue,
    required String gateStatus,
    required Color color,
    bool isDisabled = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDisabled ? Colors.grey[300]! : color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: isDisabled ? Colors.grey.withOpacity(0.1) : color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gate icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDisabled ? Colors.grey[200] : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: isDisabled ? Colors.grey[600] : color),
          ),

          16.gap,

          // Gate name
          Text(
            gateName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDisabled ? Colors.grey[600] : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          8.gap,

          // Gate value
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDisabled ? Colors.grey[100] : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              gateValue,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDisabled ? Colors.grey[600] : color),
              textAlign: TextAlign.center,
            ),
          ),

          8.gap,

          // Gate status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: isDisabled ? Colors.grey[400] : color, shape: BoxShape.circle),
              ),
              6.gap,
              Text(
                gateStatus,
                style: TextStyle(
                  fontSize: 10,
                  color: isDisabled ? Colors.grey[600] : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
