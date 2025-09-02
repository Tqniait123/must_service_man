import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/services/di.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/loading/loading_widget.dart';
import 'package:must_invest_service_man/features/home/presentation/cubit/daily_points_cubit.dart';
import 'package:must_invest_service_man/features/home/presentation/widgets/daily_point_card.dart';

class DailyPointsScreen extends StatelessWidget {
  const DailyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyPointsCubit(sl())..getDailyPoints(),
      child: Scaffold(
        backgroundColor: const Color(0xffF4F4FA),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(LocaleKeys.daily_points_details.tr(), style: context.titleLarge.copyWith()),
                  const SizedBox(width: 51, height: 51),
                ],
              ).paddingHorizontal(24),
              24.gap,

              // Summary Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BlocBuilder<DailyPointsCubit, DailyPointsState>(
                  builder: (context, state) {
                    int totalPoints = 0;
                    int totalTransactions = 0;

                    if (state is DailyPointsSuccess) {
                      totalPoints = state.dailyPoints.fold(0, (sum, point) => sum + (point.points ?? 0).toInt());
                      totalTransactions = state.dailyPoints.length;
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.star_rounded, color: AppColors.primary, size: 24),
                              ),
                              12.gap,
                              Text(
                                totalPoints.toString(),
                                style: context.titleLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.gap,
                              Text(
                                LocaleKeys.total_points_today.tr(),
                                style: context.bodyMedium.s12.copyWith(color: AppColors.primary.withOpacity(0.7)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 60, color: AppColors.primary.withOpacity(0.1)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.receipt_long, color: AppColors.primary, size: 24),
                              ),
                              12.gap,
                              Text(
                                totalTransactions.toString(),
                                style: context.titleLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.gap,
                              Text(
                                LocaleKeys.total_transactions.tr(),
                                style: context.bodyMedium.s12.copyWith(color: AppColors.primary.withOpacity(0.7)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              32.gap,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.points_history.tr(),
                      style: context.bodyMedium.bold.s16.copyWith(color: AppColors.primary),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy', context.locale.languageCode).format(DateTime.now()),
                      style: context.bodyMedium.regular.s12.copyWith(color: AppColors.primary.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),

              16.gap,

              Expanded(
                child: BlocBuilder<DailyPointsCubit, DailyPointsState>(
                  builder: (context, state) {
                    if (state is DailyPointsLoading) {
                      return const Center(child: LoadingWidget());
                    }

                    if (state is DailyPointsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: context.colorScheme.error),
                            16.gap,
                            Text(
                              LocaleKeys.failed_to_load_points.tr(),
                              style: context.bodyLarge.copyWith(color: context.colorScheme.error),
                            ),
                            8.gap,
                            Text(
                              state.message,
                              style: context.bodyMedium.copyWith(color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                            24.gap,
                            ElevatedButton.icon(
                              onPressed: () {
                                DailyPointsCubit.get(context).getDailyPoints();
                              },
                              icon: const Icon(Icons.refresh),
                              label: Text(LocaleKeys.retry.tr()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is DailyPointsSuccess) {
                      if (state.dailyPoints.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_outlined, size: 64, color: Colors.grey[400]),
                              16.gap,
                              Text(
                                LocaleKeys.no_points_today.tr(),
                                style: context.bodyLarge.copyWith(color: Colors.grey[600]),
                              ),
                              8.gap,
                              Text(
                                LocaleKeys.points_will_appear_here.tr(),
                                style: context.bodyMedium.copyWith(color: Colors.grey[500]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await DailyPointsCubit.get(context).getDailyPoints();
                        },
                        color: AppColors.primary,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: state.dailyPoints.length,
                          separatorBuilder: (context, index) => 12.gap,
                          itemBuilder: (context, index) {
                            return DailyPointCard(dailyPoint: state.dailyPoints[index]);
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              30.gap,
            ],
          ),
        ),
      ),
    );
  }
}
