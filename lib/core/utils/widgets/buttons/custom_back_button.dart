import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/flipped_for_lcale.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.onTap, this.color = const Color(0xffEAEAF3), this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'back',
      child: CustomIconButton(
        iconAsset: AppIcons.arrowIc,
        iconColor:
            iconColor ??
            (color == AppColors.primary.withValues(alpha: 0.4)
                ? Colors.black
                : AppColors.primary.withValues(alpha: 0.4)),
        color: color ?? Colors.transparent,
        boxShadow: const BoxShadow(color: Color(0x07000000), blurRadius: 4, offset: Offset(0, 3), spreadRadius: 0),
        onPressed: () {
          if (onTap != null) {
            onTap!();
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
              log('CustomBackButton: Navigator.pop executed');
            } else {
              log('CustomBackButton: Cannot pop, maybe root screen?');
            }
          }
        },
      ).flippedForLocale(context, reverse: true),
    );
  }
}
