import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/is_logged_in.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/adaptive_layout/custom_layout.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/long_press_effect.dart';
import 'package:must_invest_service_man/features/home/presentation/cubit/home_cubit.dart';
import 'package:must_invest_service_man/features/home/presentation/cubit/home_state.dart';
import 'package:must_invest_service_man/features/home/presentation/widgets/home_user_header_widget.dart';
import 'package:must_invest_service_man/features/home/presentation/widgets/user_widget.dart';

class HomeParkingMan extends StatefulWidget {
  const HomeParkingMan({super.key});

  @override
  State<HomeParkingMan> createState() => _HomeParkingManState();
}

class _HomeParkingManState extends State<HomeParkingMan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredUsers = [];
  List<dynamic> _allUsers = [];

  @override
  void initState() {
    super.initState();
    // Load current users in parking when screen initializes
    context.read<HomeCubit>().getCurrentUsersInParking();

    // Add listener to search controller for filtering
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers =
            _allUsers.where((user) {
              final userName = user.user?.name?.toLowerCase() ?? '';
              final userEmail = user.user?.email?.toLowerCase() ?? '';
              final carName = user.car?.name?.toLowerCase() ?? '';
              final metalPlate = user.car?.metalPlate?.toLowerCase() ?? '';
              final entrance = user.entrance?.toLowerCase() ?? '';

              return userName.contains(query) ||
                  userEmail.contains(query) ||
                  carName.contains(query) ||
                  metalPlate.contains(query) ||
                  entrance.contains(query);
            }).toList();
      }
    });
  }

  void _refreshData() {
    context.read<HomeCubit>().getCurrentUsersInParking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomLayout(
        withPadding: true,
        patternOffset: const Offset(-100, -200),
        spacerHeight: 35,
        topPadding: 70,
        scrollType: ScrollType.nonScrollable,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        upperContent: UserHomeHeaderWidget(searchController: _searchController),
        scrollPhysics: const NeverScrollableScrollPhysics(),
        children: [
          32.gap,
          // Points and Capacity Cards Row
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen:
                (previous, current) =>
                    current is CurrentUsersSuccess || current is CurrentUsersLoading || current is CurrentUsersError,
            builder: (context, state) {
              int currentCount = 0;
              int totalCapacity = 100; // Default capacity - you may need to get this from API
              if (state is CurrentUsersSuccess) {
                currentCount = state.userListResponse.count;
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate responsive dimensions
                  final screenWidth = MediaQuery.of(context).size.width;
                  final cardWidth = (screenWidth - 48) / 2; // 48 = horizontal padding + gap
                  final cardHeight = cardWidth * 0.85; // Aspect ratio 1:0.85

                  // Minimum height for small screens
                  final minHeight = 120.0;
                  final finalHeight = math.max(cardHeight, minHeight);

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Points Card
                        Expanded(
                          child: Container(
                            height: finalHeight,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04, // 4% of screen width
                              vertical: screenWidth * 0.035, // 3.5% of screen width
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(screenWidth * 0.02),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: AppIcons.pointsIc.icon(
                                          color: AppColors.primary,
                                          height: screenWidth * 0.05,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.025),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                LocaleKeys.my_points.tr(),
                                                style: context.bodyMedium.copyWith(
                                                  fontSize: screenWidth * 0.03,
                                                  color: AppColors.primary.withOpacity(0.7),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: screenWidth * 0.005),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    context.user.points ?? '0',
                                                    style: context.bodyMedium.copyWith(
                                                      fontSize: screenWidth * 0.045,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                  SizedBox(width: screenWidth * 0.01),
                                                  Text(
                                                    LocaleKeys.point.tr(),
                                                    style: context.bodyMedium.copyWith(
                                                      fontSize: screenWidth * 0.025,
                                                      color: AppColors.primary.withOpacity(0.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    height: screenWidth * 0.08,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => context.push(Routes.dailyPoints),
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              LocaleKeys.details.tr(),
                                              style: context.bodyMedium.copyWith(
                                                fontSize: screenWidth * 0.03,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: screenWidth * 0.03),

                        // Capacity Card
                        Expanded(
                          child: Container(
                            height: finalHeight,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenWidth * 0.035,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(screenWidth * 0.02),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.local_parking,
                                          color: AppColors.primary,
                                          size: screenWidth * 0.05,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.025),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                LocaleKeys.parking_capacity.tr(),
                                                style: context.bodyMedium.copyWith(
                                                  fontSize: screenWidth * 0.03,
                                                  color: AppColors.primary.withOpacity(0.7),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: screenWidth * 0.005),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "$currentCount / $totalCapacity",
                                                style: context.bodyMedium.copyWith(
                                                  fontSize: screenWidth * 0.045,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Capacity progress bar
                                      Container(
                                        height: screenWidth * 0.02,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor:
                                              totalCapacity > 0 ? (currentCount / totalCapacity).clamp(0.0, 1.0) : 0.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          24.gap,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen:
                    (previous, current) =>
                        current is CurrentUsersSuccess ||
                        current is CurrentUsersLoading ||
                        current is CurrentUsersError,
                builder: (context, state) {
                  String countText = LocaleKeys.current_parking_users.tr();
                  if (state is CurrentUsersSuccess) {
                    countText = "${LocaleKeys.current_parking_users.tr()} (${state.userListResponse.count})";
                  }
                  return Text(countText, style: context.bodyMedium.bold.s12.copyWith(color: AppColors.primary));
                },
              ),
              Text(
                LocaleKeys.see_more.tr(),
                style: context.bodyMedium.regular.s12.copyWith(color: AppColors.primary.withValues(alpha: 0.5)),
              ).withPressEffect(
                onTap: () {
                  context.push(Routes.newList);
                },
              ),
            ],
          ),
          16.gap,
          Expanded(
            child: BlocConsumer<HomeCubit, HomeState>(
              listenWhen: (previous, current) => current is CurrentUsersSuccess || current is CurrentUsersError,
              listener: (context, state) {
                if (state is CurrentUsersSuccess) {
                  setState(() {
                    _allUsers = state.userListResponse.users;
                    _filteredUsers = _allUsers;
                  });
                } else if (state is CurrentUsersError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: LocaleKeys.retry.tr(),
                        textColor: Colors.white,
                        onPressed: _refreshData,
                      ),
                    ),
                  );
                }
              },
              buildWhen:
                  (previous, current) =>
                      current is CurrentUsersLoading || current is CurrentUsersSuccess || current is CurrentUsersError,
              builder: (context, state) {
                if (state is CurrentUsersLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (state is CurrentUsersError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                        16.gap,
                        Text(
                          LocaleKeys.failed_to_load_users.tr(),
                          style: context.bodyMedium.regular.s16.copyWith(color: Colors.grey[600]),
                        ),
                        8.gap,
                        Text(
                          state.message,
                          style: context.bodySmall.regular.s14.copyWith(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                        24.gap,
                        CustomElevatedButton(
                          onPressed: _refreshData,
                          // icon: Icons.refresh,
                          title: LocaleKeys.retry.tr(),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CurrentUsersSuccess) {
                  if (_filteredUsers.isEmpty && _searchController.text.isNotEmpty) {
                    // Show no search results
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          16.gap,
                          Text(
                            LocaleKeys.no_results_found.tr(),
                            style: context.bodyMedium.regular.s16.copyWith(color: Colors.grey[600]),
                          ),
                          8.gap,
                          Text(
                            LocaleKeys.try_adjusting_search_terms.tr(),
                            style: context.bodySmall.regular.s14.copyWith(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filteredUsers.isEmpty) {
                    // Show no users in parking
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_parking_outlined, size: 64, color: Colors.grey[400]),
                          16.gap,
                          Text(
                            LocaleKeys.no_users_currently_in_parking.tr(),
                            style: context.bodyMedium.regular.s16.copyWith(color: Colors.grey[600]),
                          ),
                          8.gap,
                          Text(
                            LocaleKeys.users_will_appear_when_enter.tr(),
                            style: context.bodySmall.regular.s14.copyWith(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _refreshData(),
                    color: AppColors.primary,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: false,
                      padding: EdgeInsets.zero,
                      itemCount: _filteredUsers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return UserWidget(user: _filteredUsers[index]);
                      },
                    ),
                  );
                }

                // Default fallback - shouldn't reach here
                return const SizedBox.shrink();
              },
            ),
          ),
          30.gap,
        ],
      ),
    );
  }
}
