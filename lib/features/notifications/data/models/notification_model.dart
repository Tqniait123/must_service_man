class NotificationModel {
  final String id;
  final String type;
  final NotificationData data;
  final String? readAt;
  final String createdAt;

  NotificationModel({required this.id, required this.type, required this.data, this.readAt, required this.createdAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'data': data.toJson(), 'read_at': readAt, 'created_at': createdAt};
  }
}

class NotificationData {
  final String ar;
  final String en;

  NotificationData({required this.ar, required this.en});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(ar: json['ar'] as String, en: json['en'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'ar': ar, 'en': en};
  }

  // Helper method to get localized message
  String getLocalizedMessage(String locale) {
    return locale == 'ar' ? ar : en;
  }
}
