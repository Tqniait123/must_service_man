import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/static/constants.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';
import 'package:must_invest_service_man/features/home/presentation/widgets/user_widget.dart';
import 'package:must_invest_service_man/features/new_lists/presentation/widgets/filter_option_widget.dart';

class NewListScreen extends StatefulWidget {
  const NewListScreen({super.key});

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterId = 1;

  final List<Map<String, dynamic>> _filters = [
    {'id': 2, 'title': LocaleKeys.new_title.tr()},
    {'id': 3, 'title': LocaleKeys.current.tr()},
    {'id': 4, 'title': LocaleKeys.last.tr()},
  ];

  @override
  Widget build(BuildContext context) {
    final usersList = Constants.getRealisticFakeUsers();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  Text(
                    LocaleKeys.new_list.tr(),
                    style: context.titleLarge.copyWith(),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        iconAsset: AppIcons.cameraIc,
                        color: Color(0xffEAEAF3),
                        iconColor: AppColors.primary,
                        onPressed: () {},
                      ),
                      10.gap,
                      NotificationsButton(
                        color: Color(0xffEAEAF3),
                        iconColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
              40.gap,
              CustomTextFormField(
                controller: _searchController,
                backgroundColor: Color(0xffEAEAF3),
                hintColor: AppColors.primary.withValues(alpha: 0.4),
                isBordered: false,
                margin: 0,
                prefixIC: AppIcons.searchIc.icon(
                  color: AppColors.primary.withValues(alpha: 0.4),
                ),
                hint: LocaleKeys.search.tr(),
              ),
              20.gap,
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) => 10.gap,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilterId = filter['id'];
                        });
                      },
                      child: FilterOptionWidget(
                        title: filter['title'],
                        id: filter['id'],
                        isSelected: _selectedFilterId == filter['id'],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics:
                      const BouncingScrollPhysics(), // Add physics for better scrolling
                  shrinkWrap:
                      false, // Don't use shrinkWrap as we've set a height
                  padding:
                      EdgeInsets.zero, // Remove padding to avoid extra space
                  itemCount: usersList.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return UserWidget(user: usersList[index]);
                  },
                ),
              ),
              30.gap, // Add some padding at the bottom
            ],
          ),
        ).paddingHorizontal(20),
      ),
    );
  }
}
