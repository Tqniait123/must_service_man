import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

class UpdateProfileParams {
  final String name;
  final String? phone;
  final String? countryCode;
  final PlatformFile? image;

  UpdateProfileParams({required this.name, this.phone, this.countryCode, this.image});

  /// Convert to FormData for multipart requests
  Future<FormData> toFormData() async {
    final Map<String, dynamic> fields = {};

    // Add required text fields
    fields['name'] = name;

    // Add optional file fields
    if (image != null) {
      fields['image'] = await _createMultipartFile(image!, 'image');
    }

    // Add optional text fields
    if (phone != null) {
      fields['phone'] = phone;
    }
    if (countryCode != null) {
      fields['country_code'] = countryCode;
    }

    return FormData.fromMap(fields);
  }

  /// Helper method to create MultipartFile from PlatformFile using path
  Future<MultipartFile> _createMultipartFile(PlatformFile file, String fieldName) async {
    // Use fromPath if file has a path (mobile/desktop), otherwise use fromBytes (web)
    if (file.path != null) {
      return await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
        contentType: _getContentType(file.extension),
      );
    } else {
      // Fallback to bytes for web platform
      return MultipartFile.fromBytes(file.bytes!, filename: file.name, contentType: _getContentType(file.extension));
    }
  }

  /// Get content type based on file extension
  MediaType? _getContentType(String? extension) {
    if (extension == null) return null;

    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'svg':
        return MediaType('image', 'svg+xml');
      default:
        return MediaType('image', 'jpeg'); // Default fallback
    }
  }

  /// Validation method
  bool isValid() {
    return name.isNotEmpty;
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (name.isEmpty) {
      errors.add('Name is required');
    }

    return errors;
  }

  @override
  String toString() {
    return 'UpdateProfileParams{name: $name, image: ${image?.name}}';
  }
}
