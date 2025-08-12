class UserModel {
  final int id;
  final String? parking;
  final User? user;
  final Car? car;
  final String? entrance;
  final String? startTime;
  final String? duration;
  final String? cost;
  final double? points;

  UserModel({
    required this.id,
    this.parking,
    this.user,
    this.car,
    this.entrance,
    this.startTime,
    this.duration,
    this.cost,
    this.points,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      parking: json['parking'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      entrance: json['entrance'],
      startTime: json['start_time'],
      duration: json['duration'],
      cost: json['cost'],
      points: json['points']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parking': parking,
      'user': user?.toJson(),
      'car': car?.toJson(),
      'entrance': entrance,
      'start_time': startTime,
      'duration': duration,
      'cost': cost,
      'points': points,
    };
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? city;
  final String? image;
  final String? photo; // For list response
  final int? approved;
  final NationalId? nationalId;
  final DrivingLicense? drivingLicense;
  final double? points;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.city,
    this.image,
    this.photo,
    this.approved,
    this.nationalId,
    this.drivingLicense,
    this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      city: json['city'],
      image: json['image'],
      photo: json['photo'],
      approved: json['approved'],
      nationalId: json['national_id'] != null ? NationalId.fromJson(json['national_id']) : null,
      drivingLicense: json['driving_license'] != null ? DrivingLicense.fromJson(json['driving_license']) : null,
      points: json['points']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'image': image,
      'photo': photo,
      'approved': approved,
      'national_id': nationalId?.toJson(),
      'driving_license': drivingLicense?.toJson(),
      'points': points,
    };
  }
}

class Car {
  final int? id;
  final String? name;
  final String? color;
  final String? carPhoto;
  final License? license;
  final String? metalPlate;
  final String? manufactureYear;
  final String? approved;

  Car({
    this.id,
    this.name,
    this.color,
    this.carPhoto,
    this.license,
    this.metalPlate,
    this.manufactureYear,
    this.approved,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      carPhoto: json['car photo'],
      license: json['license'] != null ? License.fromJson(json['license']) : null,
      metalPlate: json['metal plate'],
      manufactureYear: json['manufacture year'],
      approved: json['approved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'car photo': carPhoto,
      'license': license?.toJson(),
      'metal plate': metalPlate,
      'manufacture year': manufactureYear,
      'approved': approved,
    };
  }
}

class NationalId {
  final String? front;
  final String? back;

  NationalId({this.front, this.back});

  factory NationalId.fromJson(Map<String, dynamic> json) {
    return NationalId(front: json['front'], back: json['back']);
  }

  Map<String, dynamic> toJson() {
    return {'front': front, 'back': back};
  }
}

class DrivingLicense {
  final String? front;

  DrivingLicense({this.front});

  factory DrivingLicense.fromJson(Map<String, dynamic> json) {
    return DrivingLicense(front: json['front']);
  }

  Map<String, dynamic> toJson() {
    return {'front': front};
  }
}

class License {
  final String? front;
  final String? back;
  final String? expiryDate;

  License({this.front, this.back, this.expiryDate});

  factory License.fromJson(Map<String, dynamic> json) {
    return License(front: json['front'], back: json['back'], expiryDate: json['expiry date']);
  }

  Map<String, dynamic> toJson() {
    return {'front': front, 'back': back, 'expiry date': expiryDate};
  }
}

// Response wrapper classes
class UserDetailResponse {
  final UserModel data;
  final String message;
  final int status;

  UserDetailResponse({required this.data, required this.message, required this.status});

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailResponse(
      data: UserModel.fromJson(json['data']),
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}

class UserListResponse {
  final int count;
  final List<UserModel> users;
  // final String message;
  // final int status;

  UserListResponse({required this.count, required this.users});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      count: json['count'] ?? 0,
      users: (json['users'] as List<dynamic>?)?.map((user) => UserModel.fromJson(user)).toList() ?? [],
      // message: json['message'] ?? '',
      // status: json['status'] ?? 0,
    );
  }
}
