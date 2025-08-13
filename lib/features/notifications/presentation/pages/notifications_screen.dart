import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/services/di.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/loading/loading_widget.dart';
import 'package:must_invest_service_man/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:must_invest_service_man/features/notifications/presentation/widgets/notification_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(sl())..getNotifications(),
      child: Scaffold(
        backgroundColor: Color(0xffF4F4FA),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  Text(LocaleKeys.notifications.tr(), style: context.titleLarge.copyWith()),
                  const SizedBox(width: 51, height: 51),
                ],
              ),
              64.gap,
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return Center(child: LoadingWidget());
                    } else if (state is NotificationsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
                            16.gap,
                            Text(
                              state.message,
                              style: context.bodyLarge.copyWith(color: context.colorScheme.error),
                              textAlign: TextAlign.center,
                            ),
                            24.gap,
                            ElevatedButton(
                              onPressed: () {
                                NotificationsCubit.get(context).getNotifications();
                              },
                              child: Text(LocaleKeys.retry.tr()),
                            ),
                          ],
                        ),
                      );
                    } else if (state is NotificationsSuccess) {
                      if (state.notifications.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 64,
                                color: context.colorScheme.onSurface.withOpacity(0.5),
                              ),
                              16.gap,
                              Text(
                                LocaleKeys.noNotificationsFound.tr(),
                                style: context.bodyLarge.copyWith(
                                  color: context.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await NotificationsCubit.get(context).getNotifications();
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.notifications.length,
                          itemBuilder: (context, index) {
                            return NotificationWidget(notification: state.notifications[index]);
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ).paddingHorizontal(24),
        ),
      ),
    );
  }
}
