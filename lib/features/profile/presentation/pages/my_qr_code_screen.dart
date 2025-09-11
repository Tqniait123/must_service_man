import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/is_logged_in.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/services/qr_code_service.dart';
import 'package:must_invest_service_man/core/static/app_assets.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/features/auth/data/models/user.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCodeScreen extends StatefulWidget {
  final Employee? employee; // Add employee parameter

  const MyQrCodeScreen({super.key, this.employee});

  @override
  State<MyQrCodeScreen> createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  bool _isLoading = true;
  bool _isRegenerating = false;
  String _qrData = '';
  AppUser? currentEmployee;

  @override
  void initState() {
    super.initState();
    currentEmployee = context.user;
    _generateInitialQrCode();
  }

  Future<void> _generateInitialQrCode() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate QR code using the service
    _generateQrCode();

    setState(() {
      _isLoading = false;
    });
  }

  void _generateQrCode() {
    try {
      // Get employee info (you might need to get this from your auth service)
      final employeeId = currentEmployee?.id ?? 'EMP_${Random().nextInt(999999).toString().padLeft(6, '0')}';
      final employeeName = currentEmployee?.name ?? 'موظف الاستقبال';
      // final parkingLocation = currentEmployee?.workLocation ?? 'موقف النصر الرئيسي';
      // final shiftTime = _getCurrentShiftTime();

      // Generate QR code using ParkingQrService
      _qrData = ParkingQrService.generateEmployeeQr(
        employeeId: employeeId.toString(),
        employeeName: employeeName,
        parkingLocation: '',
        shiftTime: '',
      );
    } catch (e) {
      // Handle error
      print('Error generating QR code: $e');

      // Fallback to simple QR data
      _qrData =
          'must_invest_service_man://employee/${currentEmployee?.id ?? 'unknown'}?timestamp=${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  String _getCurrentShiftTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 6 && hour < 14) {
      return 'الوردية الصباحية (6:00 - 14:00)';
    } else if (hour >= 14 && hour < 22) {
      return 'الوردية المسائية (14:00 - 22:00)';
    } else {
      return 'الوردية الليلية (22:00 - 6:00)';
    }
  }

  Future<void> _regenerateQrCode() async {
    setState(() {
      _isRegenerating = true;
    });

    // Simulate regeneration delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate new QR code
    _generateQrCode();

    setState(() {
      _isRegenerating = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تجديد رمز الاستجابة السريعة بنجاح'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                Text(LocaleKeys.my_qr.tr(), style: context.titleLarge.copyWith()),
                NotificationsButton(color: Color(0xffEAEAF3), iconColor: AppColors.primary),
              ],
            ),

            // QR Code Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Employee Info Widget
                  _buildEmployeeInfoWidget(),
                  24.gap,

                  // QR Code Display
                  Center(child: _isLoading ? _buildLoadingWidget() : _buildQrCodeWidget()),

                  // Employee Details Display
                  if (!_isLoading) ...[16.gap, _buildEmployeeDetailsWidget()],
                ],
              ),
            ),
          ],
        ).paddingHorizontal(24),
      ),
      // bottomNavigationBar: Row(
      //   children: [
      //     Expanded(
      //       child: CustomElevatedButton(
      //         heroTag: 'cancel',
      //         onPressed: () {
      //           context.pop();
      //         },
      //         title: LocaleKeys.cancel.tr(),
      //         backgroundColor: Color(0xffF4F4FA),
      //         textColor: AppColors.primary.withValues(alpha: 0.5),
      //         isBordered: false,
      //       ),
      //     ),
      //     16.gap,
      //     Expanded(
      //       child: CustomElevatedButton(
      //         loading: _isRegenerating,
      //         onPressed: _isRegenerating ? null : _regenerateQrCode,
      //         title: _isRegenerating ? LocaleKeys.generating.tr() : LocaleKeys.re_generate.tr(),
      //       ),
      //     ),
      //   ],
      // ).paddingAll(30),
    );
  }

  Widget _buildEmployeeInfoWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.badge, color: Colors.white, size: 24),
          ),
          16.gap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'موظف معتمد',
                  style: context.titleMedium.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                4.gap,
                Text(
                  currentEmployee?.name ?? 'موظف الاستقبال',
                  style: context.bodyMedium.copyWith(color: Colors.green[700]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: Text('نشط', style: context.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                16.gap,
                Text(
                  'جاري إنشاء رمز الاستجابة السريعة...',
                  textAlign: TextAlign.center,
                  style: context.bodyMedium.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // QR Code Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: QrImageView(
            data: _qrData,
            version: QrVersions.auto,
            size: 250.0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: AppColors.primary),
            eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
            errorCorrectionLevel: QrErrorCorrectLevel.M,
            embeddedImage: AssetImage(AppImages.logo),
            embeddedImageStyle: QrEmbeddedImageStyle(size: Size(60, 60)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeDetailsWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work, color: AppColors.primary, size: 20),
              8.gap,
              Text(
                'معلومات العمل',
                style: context.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          12.gap,
          _buildInfoRow('الاسم:', currentEmployee?.name ?? 'موظف الاستقبال'),
          4.gap,
          // _buildInfoRow('المكان:', currentEmployee?.workLocation ?? 'موقف النصر الرئيسي'),
          4.gap,
          // _buildInfoRow('الوردية:', _getCurrentShiftTime()),
          4.gap,
          _buildInfoRow('الوقت:', DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.now())),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: context.bodySmall.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ),
        Expanded(child: Text(value, style: context.bodySmall.copyWith(color: Colors.grey[800]))),
      ],
    );
  }
}

// Add Employee model if it doesn't exist
class Employee {
  final String? id;
  final String? name;
  final String? workLocation;

  Employee({this.id, this.name, this.workLocation});
}
