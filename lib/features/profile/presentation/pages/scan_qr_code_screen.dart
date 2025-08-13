import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/services/qr_code_service.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  MobileScannerController controller = MobileScannerController();
  bool _isScanning = true;
  bool _isProcessing = false;
  String? _scannedData;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && !_isProcessing && _isScanning) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        _handleScannedData(context, barcode.rawValue!);
      }
    }
  }

  Future<void> _handleScannedData(BuildContext context, String scannedData) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _scannedData = scannedData;
    });

    // Stop scanning
    await controller.stop();

    // Process the scanned data using new ParkingQR service
    await _processQrCodeWithParkingService(context, scannedData);

    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _processQrCodeWithParkingService(BuildContext context, String qrData) async {
    try {
      // Show processing indicator
      _showProcessingDialog();

      // Simulate processing delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Hide processing dialog
      Navigator.of(context).pop();

      // الموظف بيسكان QR اليوزر عشان يعرف بيانات العربية
      QrScanResult result = ParkingQrService.scanUserQr(qrData);

      if (result.isValid && result.userData != null) {
        _showUserDataBottomSheet(context, result.userData!);
      } else {
        _showErrorBottomSheet(result.error ?? LocaleKeys.qr_failed_to_process.tr());
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorBottomSheet('${LocaleKeys.qr_error_processing.tr()}: $e');
    }
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                16.gap,
                Text(LocaleKeys.processing.tr(), style: context.bodyMedium),
              ],
            ),
          ),
    );
  }

  // عرض بيانات اليوزر للموظف - Bottom Sheet
  void _showUserDataBottomSheet(BuildContext context, UserQrData userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder:
                  (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Handle bar
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          20.gap,

                          // Success Icon and Title
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
                                  ),
                                  child: Icon(Icons.qr_code_scanner, color: Colors.green, size: 40),
                                ),
                                16.gap,
                                Text(
                                  LocaleKeys.qr_car_data_found.tr(),
                                  style: context.titleLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                                8.gap,
                                Text(
                                  LocaleKeys.qr_client_car_details.tr(),
                                  style: context.bodyMedium.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          32.gap,

                          // User Badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.withOpacity(0.1), Colors.blue.withOpacity(0.05)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                                  child: Icon(Icons.person, color: Colors.white, size: 20),
                                ),
                                12.gap,
                                Text(
                                  LocaleKeys.qr_client_data.tr(),
                                  style: context.titleMedium.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          16.gap,

                          // User Information Cards
                          _buildModernInfoCard(
                            LocaleKeys.qr_client_name.tr(),
                            userData.userName,
                            Icons.person,
                            Colors.blue,
                          ),
                          8.gap,
                          _buildModernInfoCard(LocaleKeys.qr_client_id.tr(), userData.userId, Icons.badge, Colors.blue),
                          24.gap,

                          // Car Information Section
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.directions_car, color: Colors.white, size: 20),
                                ),
                                12.gap,
                                Text(
                                  LocaleKeys.qr_car_data.tr(),
                                  style: context.titleMedium.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          16.gap,

                          _buildModernInfoCard(
                            LocaleKeys.qr_car_type.tr(),
                            userData.carName,
                            Icons.car_rental,
                            Colors.green,
                          ),
                          8.gap,
                          _buildModernInfoCard(
                            LocaleKeys.qr_plate_number.tr(),
                            userData.metalPlate,
                            Icons.confirmation_number,
                            Colors.green,
                          ),
                          8.gap,
                          _buildModernInfoCard(LocaleKeys.qr_car_id.tr(), userData.carId, Icons.key, Colors.green),
                          if (userData.carColor != null) ...[
                            8.gap,
                            _buildModernInfoCard(
                              LocaleKeys.qr_car_color.tr(),
                              userData.carColor!,
                              Icons.palette,
                              Colors.green,
                            ),
                          ],

                          32.gap,

                          // Action Buttons
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                  title: LocaleKeys.qr_scan_another.tr(),
                                  height: 52,
                                  isFilled: false,
                                  isBordered: true,
                                  backgroundColor: Colors.transparent,
                                  textColor: Colors.grey[600],
                                  iconColor: Colors.grey[600],
                                  // icon: 'assets/icons/qr_code_scanner.svg', // Replace with your SVG path
                                  // iconType: IconType.leading,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _resumeScanning();
                                  },
                                ),
                              ),
                              16.gap,
                              Expanded(
                                child: CustomElevatedButton(
                                  title: LocaleKeys.qr_confirm_entry.tr(),
                                  height: 52,
                                  isFilled: true,
                                  backgroundColor: AppColors.primary,
                                  textColor: Colors.white,
                                  iconColor: Colors.white,
                                  // icon: 'assets/icons/check_circle.svg', // Replace with your SVG path
                                  // iconType: IconType.leading,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _handleUserCarEntry(userData);
                                  },
                                ),
                              ),
                            ],
                          ),
                          24.gap,
                        ],
                      ),
                    ),
                  ),
            ),
          ),
    );
  }

  // Error Bottom Sheet with modern design
  void _showErrorBottomSheet(String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.8,
              expand: false,
              builder:
                  (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Handle bar
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                          ),
                          20.gap,

                          // Error Icon and Title
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
                            ),
                            child: Icon(Icons.error_outline, color: Colors.red, size: 40),
                          ),
                          16.gap,

                          Text(
                            LocaleKeys.qr_scan_failed.tr(),
                            style: context.titleLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          8.gap,

                          Text(
                            LocaleKeys.qr_processing_error_occurred.tr(),
                            style: context.bodyMedium.copyWith(color: Colors.grey[600]),
                          ),
                          24.gap,

                          // Error Message Container
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red.withOpacity(0.2)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.red, size: 20),
                                    8.gap,
                                    Text(
                                      LocaleKeys.qr_error_details.tr(),
                                      style: context.bodyMedium.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                12.gap,
                                Text(
                                  message,
                                  style: context.bodyMedium.copyWith(color: Colors.red[700], height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          32.gap,

                          // Suggestions Container
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
                                    8.gap,
                                    Text(
                                      LocaleKeys.qr_suggestions.tr(),
                                      style: context.bodyMedium.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                12.gap,
                                _buildSuggestionItem(LocaleKeys.qr_suggestion_clear_code.tr()),
                                _buildSuggestionItem(LocaleKeys.qr_suggestion_good_lighting.tr()),
                                _buildSuggestionItem(LocaleKeys.qr_suggestion_adjust_distance.tr()),
                                _buildSuggestionItem(LocaleKeys.qr_suggestion_correct_type.tr()),
                              ],
                            ),
                          ),
                          32.gap,

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.pop();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.grey[300]!),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close, size: 20, color: Colors.grey[600]),
                                        8.gap,
                                        Text(
                                          LocaleKeys.cancel.tr(),
                                          style: context.bodyLarge.copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              16.gap,
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _resumeScanning();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.refresh, size: 20),
                                        8.gap,
                                        Text(
                                          LocaleKeys.try_again.tr(),
                                          style: context.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          24.gap,
                        ],
                      ),
                    ),
                  ),
            ),
          ),
    );
  }

  Widget _buildSuggestionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
          8.gap,
          Expanded(child: Text(text, style: context.bodySmall.copyWith(color: Colors.blue[700], height: 1.3))),
        ],
      ),
    );
  }

  Widget _buildModernInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          12.gap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.bodySmall.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                4.gap,
                Text(value, style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[800])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // معالجة دخول عربية اليوزر (للموظف)
  void _handleUserCarEntry(UserQrData userData) {
    // هنا الموظف يحفظ بيانات دخول العربية في الداتابيز
    print('🚗 الموظف: تم تأكيد دخول العربية');
    print('- صاحب العربية: ${userData.userName}');
    print('- نوع العربية: ${userData.carName}');
    print('- رقم اللوحة: ${userData.metalPlate}');
    print('- Car ID للداتابيز: ${userData.carId}');
    print('- User ID للداتابيز: ${userData.userId}');

    _showSuccessBottomSheet(
      title: LocaleKeys.qr_entry_success.tr(),
      message: '${LocaleKeys.qr_car_entry_success.tr()} ${userData.carName} ${LocaleKeys.qr_successfully.tr()}',
      icon: Icons.check_circle,
      color: Colors.green,
    );

    // TODO: هنا تقدر تضيف API call عشان تحفظ البيانات في الداتابيز
    // await _saveParkingEntryToDatabase(userData);
  }

  // Success Bottom Sheet
  void _showSuccessBottomSheet({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.7,
              expand: false,
              builder:
                  (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Handle bar
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                          ),
                          20.gap,

                          // Success Animation Container
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: color.withOpacity(0.2), blurRadius: 20, offset: Offset(0, 10)),
                              ],
                            ),
                            child: Icon(icon, color: color, size: 50),
                          ),
                          24.gap,

                          Text(
                            title,
                            style: context.titleLarge.copyWith(fontWeight: FontWeight.bold, color: color),
                            textAlign: TextAlign.center,
                          ),
                          12.gap,

                          Text(
                            message,
                            style: context.bodyLarge.copyWith(color: Colors.grey[600], height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                          32.gap,

                          // Success Details
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: color.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.schedule, color: color, size: 20),
                                12.gap,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.qr_completed_at.tr(),
                                        style: context.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
                                      ),
                                      4.gap,
                                      Text(
                                        DateFormat('HH:mm:ss - dd/MM/yyyy').format(DateTime.now()),
                                        style: context.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          32.gap,

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.home, size: 20),
                                  8.gap,
                                  Text(
                                    LocaleKeys.qr_back_to_home.tr(),
                                    style: context.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          24.gap,
                        ],
                      ),
                    ),
                  ),
            ),
          ),
    );
  }

  Future<void> _resumeScanning() async {
    setState(() {
      _isScanning = true;
      _scannedData = null;
    });
    await controller.start();
  }

  Future<void> _toggleFlash() async {
    await controller.toggleTorch();
    setState(() {
      _flashOn = !_flashOn;
    });
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
                Text(LocaleKeys.qr_scan_client_title.tr(), style: context.titleLarge.copyWith()),
                NotificationsButton(color: Color(0xffEAEAF3), iconColor: AppColors.primary),
              ],
            ).paddingHorizontal(24),

            16.gap,

            // Instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.green, size: 20),
                    12.gap,
                    Expanded(
                      child: Text(
                        LocaleKeys.qr_scan_instructions.tr(),
                        style: context.bodyMedium.copyWith(color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            16.gap,

            // QR Scanner Section
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MobileScanner(
                          controller: controller,
                          onDetect: (data) {
                            _onDetect(context, data);
                          },
                          overlayBuilder: (context, capture) {
                            return Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
                                            8.gap,
                                            Text(
                                              LocaleKeys.qr_client_qr.tr(),
                                              style: context.bodySmall.copyWith(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Flash toggle button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: _toggleFlash,
                            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                          ),
                        ),
                      ),

                      // Scanning indicator
                      if (_isProcessing)
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                16.gap,
                                Text(
                                  LocaleKeys.processing.tr(),
                                  style: context.bodyMedium.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            24.gap,

            // Scanning status
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isScanning ? AppColors.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isScanning ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.gap,
                  Text(
                    _isScanning ? LocaleKeys.qr_ready_to_scan.tr() : LocaleKeys.processing.tr(),
                    style: context.bodyMedium.copyWith(
                      color: _isScanning ? AppColors.primary : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            24.gap,
          ],
        ),
      ),
    );
  }
}
