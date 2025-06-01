import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomBackButton(),
                  Text(
                    LocaleKeys.details.tr(),
                    style: context.titleLarge.copyWith(),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        iconAsset: AppIcons.cameraIc,
                        color: const Color(0xffEAEAF3),
                        iconColor: AppColors.primary,
                        onPressed: () {},
                      ),
                      10.gap,
                      NotificationsButton(
                        color: const Color(0xffEAEAF3),
                        iconColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      39.gap,
                      // User Profile image
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.user.photo ?? '',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      30.gap,
                      // User Name and Status
                      Column(
                        children: [
                          Text(
                            widget.user.name,
                            style: context.titleLarge.copyWith(),
                          ),
                          5.gap,
                          if (widget.user.status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(widget.user.status!),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(widget.user.status!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // User Contact Info
                      20.gap,
                      _InfoCard(
                        icon: Icons.email,
                        title: 'Email',
                        value: widget.user.email,
                      ),
                      if (widget.user.phoneNumber != null) ...[
                        10.gap,
                        _InfoCard(
                          icon: Icons.phone,
                          title: 'Phone',
                          value: widget.user.phoneNumber!,
                        ),
                      ],
                      if (widget.user.address != null) ...[
                        10.gap,
                        _InfoCard(
                          icon: Icons.location_on,
                          title: 'Address',
                          value: widget.user.address!,
                        ),
                      ],
                      // Parking Gates Info
                      if (widget.user.entryGate != null ||
                          widget.user.exitGate != null) ...[
                        20.gap,
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.user.entryGate != null)
                                _GateInfo(
                                  icon: Icons.login,
                                  title: 'Entry Gate',
                                  value: widget.user.entryGate!,
                                ),
                              if (widget.user.exitGate != null)
                                _GateInfo(
                                  icon: Icons.logout,
                                  title: 'Exit Gate',
                                  value: widget.user.exitGate!,
                                ),
                            ],
                          ),
                        ),
                      ],
                      // User's Cars
                      if (widget.user.cars.isNotEmpty) ...[
                        20.gap,
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registered Cars',
                                style: context.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              10.gap,
                              ...widget.user.cars.map(
                                (car) => _CarCard(car: car),
                              ),
                            ],
                          ),
                        ),
                      ],
                      20.gap,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).paddingHorizontal(20),
      ),
    );
  }

  Color _getStatusColor(ParkingStatus status) {
    switch (status) {
      case ParkingStatus.newEntry:
        return Colors.blue;
      case ParkingStatus.inside:
        return Colors.green;
      case ParkingStatus.exited:
        return Colors.grey;
    }
  }

  String _getStatusText(ParkingStatus status) {
    switch (status) {
      case ParkingStatus.newEntry:
        return 'New Entry';
      case ParkingStatus.inside:
        return 'Inside Parking';
      case ParkingStatus.exited:
        return 'Exited';
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          12.gap,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).paddingHorizontal(16);
  }
}

class _GateInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _GateInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.primary),
        5.gap,
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CarCard extends StatelessWidget {
  final Car car;

  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car, color: AppColors.primary),
          ),
          12.gap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.plateNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...[
                  4.gap,
                  Text(
                    car.model,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
