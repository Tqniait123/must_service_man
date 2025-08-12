import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/text_style_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/adaptive_layout/custom_layout.dart';
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
                  String countText = LocaleKeys.new_list.tr();
                  if (state is CurrentUsersSuccess) {
                    countText = "${LocaleKeys.new_list.tr()} (${state.userListResponse.count})";
                  }
                  return Text(countText, style: context.bodyMedium.bold.s16.copyWith(color: AppColors.primary));
                },
              ),
              Text(
                LocaleKeys.see_more.tr(),
                style: context.bodyMedium.regular.s14.copyWith(color: AppColors.primary.withValues(alpha: 0.5)),
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
                          'Failed to load  users',
                          style: context.bodyMedium.regular.s16.copyWith(color: Colors.grey[600]),
                        ),
                        8.gap,
                        Text(
                          state.message,
                          style: context.bodySmall.regular.s14.copyWith(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                        24.gap,
                        ElevatedButton.icon(
                          onPressed: _refreshData,
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
