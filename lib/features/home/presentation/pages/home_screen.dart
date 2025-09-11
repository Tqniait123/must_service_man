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
import 'package:must_invest_service_man/core/utils/widgets/scrolling_text.dart';
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

  Widget _buildExpandedCardsSection({
    required int currentCount,
    required int totalCapacity,
    required double screenWidth,
  }) {
    final cardWidth = (screenWidth - 72) / 2; // 72 = padding + gap
    final cardHeight = cardWidth * 0.85;
    final minHeight = 120.0;
    final finalHeight = math.max(cardHeight, minHeight);

    return SizedBox(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Points Card - Expanded
            Expanded(
              child: Container(
                height: finalHeight,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.035),
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
                            child: AppIcons.pointsIc.icon(color: AppColors.primary, height: screenWidth * 0.05),
                          ),
                          SizedBox(width: screenWidth * 0.025),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.my_points.tr(),
                                  style: context.bodyMedium.copyWith(
                                    fontSize: screenWidth * 0.03,
                                    color: AppColors.primary.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.005),
                                Row(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: screenWidth * 0.08,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => context.push(Routes.dailyPoints),
                          child: Center(
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
                  ],
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

            // Capacity Card - Expanded
            Expanded(
              child: Container(
                height: finalHeight,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.035),
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
                            child: Icon(Icons.local_parking, color: AppColors.primary, size: screenWidth * 0.05),
                          ),
                          SizedBox(width: screenWidth * 0.025),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ScrollingText(
                                  LocaleKeys.parking_capacity.tr(),
                                  style: context.bodyMedium.copyWith(
                                    fontSize: screenWidth * 0.03,
                                    color: AppColors.primary.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.005),
                                Text(
                                  "$currentCount / $totalCapacity",
                                  style: context.bodyMedium.copyWith(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: screenWidth * 0.02,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: totalCapacity > 0 ? (currentCount / totalCapacity).clamp(0.0, 1.0) : 0.0,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedCardsSection({
    required int currentCount,
    required int totalCapacity,
    required double screenWidth,
  }) {
    return SizedBox(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Points Card - Collapsed
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppIcons.pointsIc.icon(color: AppColors.primary, height: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.my_points.tr(),
                          style: context.bodyMedium.copyWith(
                            fontSize: 10,
                            color: AppColors.primary.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${context.user.points ?? '0'} ${LocaleKeys.point.tr()}",
                          style: context.bodyMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Capacity Card - Collapsed
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_parking, color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.parking_capacity.tr(),
                          style: context.bodyMedium.copyWith(
                            fontSize: 10,
                            color: AppColors.primary.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "$currentCount / $totalCapacity",
                          style: context.bodyMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
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
        scrollPhysics: const NeverScrollableScrollPhysics(),
        upperContent: UserHomeHeaderWidget(searchController: _searchController),
        children: [
          32.gap,
          // Points and Capacity Cards Row with NestedScrollView
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  // Points and Capacity Cards Section - Pinned
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: CardsHeaderDelegate(
                      minHeight: 60.0,
                      maxHeight: 160.0,
                      child: (context, shrinkOffset) {
                        return BlocBuilder<HomeCubit, HomeState>(
                          buildWhen:
                              (previous, current) =>
                                  current is CurrentUsersSuccess ||
                                  current is CurrentUsersLoading ||
                                  current is CurrentUsersError,
                          builder: (context, state) {
                            int currentCount = 0;
                            int totalCapacity = 100;
                            if (state is CurrentUsersSuccess) {
                              currentCount = state.userListResponse.count;
                            }

                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Determine which layout to show based on shrink offset
                                  shrinkOffset > 40
                                      ? _buildCollapsedCardsSection(
                                        currentCount: currentCount,
                                        totalCapacity: totalCapacity,
                                        screenWidth: MediaQuery.of(context).size.width,
                                      )
                                      : _buildExpandedCardsSection(
                                        currentCount: currentCount,
                                        totalCapacity: totalCapacity,
                                        screenWidth: MediaQuery.of(context).size.width,
                                      ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Current Users Header - Pinned
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: CurrentUsersHeaderDelegate(
                      height: 74.0,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            24.gap,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                              child: Row(
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
                                        countText =
                                            "${LocaleKeys.current_parking_users.tr()} (${state.userListResponse.count})";
                                      }
                                      return Text(
                                        countText,
                                        style: context.bodyMedium.bold.s12.copyWith(color: AppColors.primary),
                                      );
                                    },
                                  ),
                                  Text(
                                    LocaleKeys.see_more.tr(),
                                    style: context.bodyMedium.regular.s12.copyWith(
                                      color: AppColors.primary.withValues(alpha: 0.5),
                                    ),
                                  ).withPressEffect(
                                    onTap: () {
                                      context.push(Routes.newList);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: BlocConsumer<HomeCubit, HomeState>(
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
                        current is CurrentUsersLoading ||
                        current is CurrentUsersSuccess ||
                        current is CurrentUsersError,
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
                          CustomElevatedButton(onPressed: _refreshData, title: LocaleKeys.retry.tr()),
                        ],
                      ),
                    );
                  }

                  if (state is CurrentUsersSuccess) {
                    if (_filteredUsers.isEmpty && _searchController.text.isNotEmpty) {
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
                        separatorBuilder: (context, index) => 16.gap,
                        itemBuilder: (context, index) {
                          return UserWidget(user: _filteredUsers[index]);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          30.gap,
        ],
      ),
    );
  }
}

// Fixed delegate for the cards section
class CardsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext context, double shrinkOffset) child;

  CardsHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: math.max(minHeight, maxHeight - shrinkOffset), child: child(context, shrinkOffset));
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

// Fixed delegate for the current users header
class CurrentUsersHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  CurrentUsersHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
