import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';

class NotificationsButton extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  const NotificationsButton({super.key, this.color, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "notifications",
      child: CustomIconButton(
        iconAsset: AppIcons.notificationsIc,
        iconColor: iconColor,
        color: color ?? Color(0xff6468AC),
        onPressed: () {
          context.push(Routes.notifications);
        },
      ),
    );
  }
}
