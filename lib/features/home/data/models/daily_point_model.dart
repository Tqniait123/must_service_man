class DailyPointModel {
  final int id;
  final String? userName;
  final String? userEmail;
  final String? userPhoto;
  final String? carName;
  final String? carColor;
  final String? metalPlate;
  final String? manufactureYear;
  final String? entryTime;
  final String? exitTime;
  final String? duration;
  final String? parkingName;
  final String? entrance;
  final String? cost;
  final double? points;
  final String? pointSource;
  final String? createdAt;

  DailyPointModel({
    required this.id,
    this.userName,
    this.userEmail,
    this.userPhoto,
    this.carName,
    this.carColor,
    this.metalPlate,
    this.manufactureYear,
    this.entryTime,
    this.exitTime,
    this.duration,
    this.parkingName,
    this.entrance,
    this.cost,
    this.points,
    this.pointSource,
    this.createdAt,
  });

  factory DailyPointModel.fromJson(Map<String, dynamic> json) {
    return DailyPointModel(
      id: json['id'] ?? 0,
      userName: json['user_name'],
      userEmail: json['user_email'],
      userPhoto: json['user_photo'],
      carName: json['car_name'],
      carColor: json['car_color'],
      metalPlate: json['metal_plate'],
      manufactureYear: json['manufacture_year'],
      entryTime: json['entry_time'],
      exitTime: json['exit_time'],
      duration: json['duration'],
      parkingName: json['parking_name'],
      entrance: json['entrance'],
      cost: json['cost'],
      points: json['points']?.toDouble(),
      pointSource: json['point_source'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'user_email': userEmail,
      'user_photo': userPhoto,
      'car_name': carName,
      'car_color': carColor,
      'metal_plate': metalPlate,
      'manufacture_year': manufactureYear,
      'entry_time': entryTime,
      'exit_time': exitTime,
      'duration': duration,
      'parking_name': parkingName,
      'entrance': entrance,
      'cost': cost,
      'points': points,
      'point_source': pointSource,
      'created_at': createdAt,
    };
  }

  // Fake factory method
  factory DailyPointModel.fake(int id) {
    return DailyPointModel(
      id: id,
      userName: "مستخدم $id",
      userEmail: "user$id@email.com",
      userPhoto: "https://picsum.photos/200?random=$id",
      carName: "تويوتا",
      carColor: "أحمر",
      metalPlate: "أ ب ج $id",
      manufactureYear: "٢٠١٩",
      entryTime: "٠٨:٣٠ ص",
      exitTime: "١٠:٣٠ ص",
      duration: "ساعتين",
      parkingName: "موقف وسط البلد",
      entrance: "بوابة $id",
      cost: "٥٠ ج.م",
      points: (id * 10).toDouble(),
      pointSource: "دخول موقف",
      createdAt: "٢٠٢٥-٠٩-٠٢",
    );
  }

  String get displayUserName => userName ?? 'مستخدم غير معروف';
  String get displayCarInfo => '${carName ?? 'غير محدد'} ${carColor ?? ''}';
  String get displayPlateNumber => metalPlate ?? 'غير متوفر';
  String get displayDuration => duration ?? 'غير متوفر';
  String get displayPoints => points?.toString() ?? '٠';
  String get displayEntrance => entrance ?? 'غير متوفر';
}

// Response wrapper for API
class DailyPointsResponse {
  final List<DailyPointModel> data;
  final String message;
  final int status;

  DailyPointsResponse({required this.data, required this.message, required this.status});

  factory DailyPointsResponse.fromJson(Map<String, dynamic> json) {
    return DailyPointsResponse(
      data: (json['data'] as List<dynamic>?)?.map((point) => DailyPointModel.fromJson(point)).toList() ?? [],
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  // Fake factory
  factory DailyPointsResponse.fake() {
    return DailyPointsResponse(
      data: List.generate(5, (index) => DailyPointModel.fake(index + 1)),
      message: "تم جلب البيانات بنجاح",
      status: 200,
    );
  }
}
