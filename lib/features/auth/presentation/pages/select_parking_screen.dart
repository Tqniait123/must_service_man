import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/config/routes/routes.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/adaptive_layout/custom_layout.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';
import 'package:must_invest_service_man/core/utils/widgets/logo_widget.dart';
import 'package:must_invest_service_man/features/auth/data/models/parking_model.dart';
import 'package:must_invest_service_man/features/auth/presentation/widgets/parking_widget.dart';

class SelectParkingScreen extends StatefulWidget {
  const SelectParkingScreen({super.key});

  @override
  State<SelectParkingScreen> createState() => _SelectParkingScreenState();
}

class _SelectParkingScreenState extends State<SelectParkingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  List<Parking> parkingList = [];
  String? selectedParkingId;
  @override
  void initState() {
    parkingList = Parking.getFakeArabicParkingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomLayout(
        withPadding: true,
        patternOffset: const Offset(-150, -200),
        spacerHeight: 35,
        topPadding: 70,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        scrollType: ScrollType.nonScrollable,
        upperContent: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: LogoWidget(type: LogoType.svg)),
              27.gap,
              Text(
                LocaleKeys.select_your_parking.tr(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        children: [
          Form(
            key: _formKey,
            child: Hero(
              tag: "form",
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _searchController,
                      margin: 0,
                      hint: LocaleKeys.search.tr(),
                      title: LocaleKeys.search.tr(),
                    ),

                    19.gap,
                  ],
                ),
              ),
            ),
          ),
          10.gap,
          Expanded(
            child: ListView.separated(
              physics:
                  const BouncingScrollPhysics(), // Add physics for better scrolling
              shrinkWrap: false, // Don't use shrinkWrap as we've set a height
              padding: EdgeInsets.zero, // Remove padding to avoid extra space
              itemCount: parkingList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return ParkingCard(
                  parking: parkingList[index],
                  isSelected: selectedParkingId == parkingList[index].id,
                  onTap: () {
                    setState(() {
                      selectedParkingId = parkingList[index].id;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomElevatedButton(
        heroTag: 'button',

        title: LocaleKeys.submit.tr(),
        onPressed: () {
          context.push(Routes.homeUser);
        },
      ).paddingOnly(left: 30, right: 30, bottom: 30),
    );
  }
}
