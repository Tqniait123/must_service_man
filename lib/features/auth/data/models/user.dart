enum UserType { user, parkingMan }

enum ParkingStatus {
  newEntry, // لسه هيدخل
  inside, // حالياً جوا
  exited, // خرج
}

sealed class AppUser {
  final int id;
  final String name;
  final String? photo;
  final String email;
  final bool hasSubscription;
  final String? address;
  final bool? isOnline;
  final bool? isActivated;

  final String? phoneNumber;
  final UserType type;
  // final List<Car> cars;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
    this.hasSubscription = false,
    this.address,

    this.isOnline = false,
    this.phoneNumber,
    required this.type,
    // required this.cars,
    this.isActivated = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return json['type'] == UserType.user.name ? User.fromJson(json) : ParkingMan.fromJson(json);
  }
}

class User extends AppUser {
  final List<Car> cars;
  final ParkingStatus? status;
  final String? entryGate;
  final String? exitGate;

  const User({
    required super.id,
    required super.name,
    required super.email,
    super.photo,
    super.hasSubscription,
    super.address,
    super.isOnline,
    super.phoneNumber,
    this.cars = const [],
    this.status,
    this.entryGate,
    this.exitGate,
  }) : super(type: UserType.user);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      address: json['address'],
      isOnline: json['is_online'],
      phoneNumber: json['phone_number'],
      // type: json['type'] == 'user' ? UserType.user : UserType.parkingMan,
      cars: (json['cars'] as List<dynamic>?)?.map((car) => Car.fromJson(car)).toList() ?? [],
      status: _parseParkingStatus(json['status']),
      entryGate: json['entry_gate'],
      exitGate: json['exit_gate'],
    );
  }

  static ParkingStatus? _parseParkingStatus(String? status) {
    switch (status) {
      case 'new':
        return ParkingStatus.newEntry;
      case 'inside':
        return ParkingStatus.inside;
      case 'exited':
        return ParkingStatus.exited;
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
      'address': address,
      'is_online': isOnline,
      'phone_number': phoneNumber,
      'cars': cars.map((e) => e.toJson()).toList(),
      'status': status?.name,
      'entry_gate': entryGate,
      'exit_gate': exitGate,
    };
  }
}

class ParkingMan extends AppUser {
  final String? phone;
  final String? points;
  final String? entranceGate;
  final String? exitGate;
  final bool? approved;

  const ParkingMan({
    required super.id,
    required super.name,
    required super.email,

    super.photo,
    super.hasSubscription,
    super.address,

    super.isOnline,
    super.phoneNumber,
    this.phone,
    this.points,
    this.entranceGate,
    this.exitGate,
    this.approved
  }) : super(type: UserType.parkingMan);

  factory ParkingMan.fromJson(Map<String, dynamic> json) {
    return ParkingMan(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['image'],
      address: json['address'],
      isOnline: json['is_online'],
      phoneNumber: json['phone_number'],
      phone: json['phone'],
      points: json['points']?.toString(),
      entranceGate: json['entrance_gate'],
      exitGate: json['exit_gate'],
           approved: json['approved'] != null ? json['approved'] == 1 : null,


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
      'address': address,
      'is_online': isOnline,
      'phone_number': phoneNumber,
      'phone': phone,
      'points': points,
      'entrance_gate': entranceGate,
      'exit_gate': exitGate,
    };
  }
}

class Car {
  final String id;
  final String model;
  final String plateNumber;

  const Car({required this.id, required this.model, required this.plateNumber});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(id: json['id'], model: json['model'], plateNumber: json['plate_number']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'model': model, 'plate_number': plateNumber};
  }
}

class UserWithMessage {
  final ParkingMan user;
  final String message;

  UserWithMessage({required this.user, required this.message});
}


// /// User model for the example
// class User {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String? image;
//   final List<PointsRecord> points;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     this.image,
//     required this.points,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       image: json['image'],
//       points:
//           json['points'] is List
//               ? (json['points'] as List)
//                   .map((point) => PointsRecord.fromJson(point))
//                   .toList()
//               : [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'image': image,
//       'points': points.map((point) => point.toJson()).toList(),
//     };
//   }
// }

// /// Points record model
// class PointsRecord {
//   final String parking;
//   final int points;
//   final int equivalentMoney;
//   final String status;
//   final String date;

//   PointsRecord({
//     required this.parking,
//     required this.points,
//     required this.equivalentMoney,
//     required this.status,
//     required this.date,
//   });

//   factory PointsRecord.fromJson(Map<String, dynamic> json) {
//     return PointsRecord(
//       parking: json['parking'] ?? '',
//       points: json['points'] ?? 0,
//       equivalentMoney: json['equivalent money'] ?? 0,
//       status: json['status'] ?? '',
//       date: json['date'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'parking': parking,
//       'points': points,
//       'equivalent money': equivalentMoney,
//       'status': status,
//       'date': date,
//     };
//   }
// }

// /// User data wrapper
// class UserData {
//   final User user;
//   final String accessToken;

//   UserData({required this.user, required this.accessToken});

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       user: User.fromJson(json['user']),
//       accessToken: json['access_token'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'user': user.toJson(), 'access_token': accessToken};
//   }
// }
