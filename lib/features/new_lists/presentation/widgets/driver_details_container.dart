import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/detail_row_widget.dart';

// Driver Details Container Widget
class DriverDetailsContainer extends StatelessWidget {
  final User user;

  const DriverDetailsContainer({super.key, required this.user});

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
                LocaleKeys.driver_details.tr(),
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.gap,
          Row(
            children: [
              // Driver Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  user.photo ?? '',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 60,
                        width: 60,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey[500],
                        ),
                      ),
                ),
              ),
              16.gap,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(label: LocaleKeys.name.tr(), value: user.name),
                    6.gap,
                    DetailRow(label: LocaleKeys.email.tr(), value: user.email),
                    if (user.phoneNumber != null) ...[
                      6.gap,
                      DetailRow(
                        label: LocaleKeys.phone.tr(),
                        value: user.phoneNumber!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
