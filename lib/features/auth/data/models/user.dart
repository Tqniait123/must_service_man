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
  final String linkId;
  final bool? isOnline;

  final String? phoneNumber;
  final UserType type;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
    this.hasSubscription = false,
    this.address,
    required this.linkId,

    this.isOnline = false,
    this.phoneNumber,
    required this.type,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return json['type'] == UserType.user.name
        ? User.fromJson(json)
        : ParkingMan.fromJson(json);
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
    required super.linkId,
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
      linkId: json['link_id'],
      isOnline: json['is_online'],
      phoneNumber: json['phone_number'],
      cars:
          (json['cars'] as List<dynamic>?)
              ?.map((car) => Car.fromJson(car))
              .toList() ??
          [],
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
      'link_id': linkId,
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
  const ParkingMan({
    required super.id,
    required super.name,
    required super.email,
    super.photo,
    super.hasSubscription,
    super.address,
    required super.linkId,
    super.isOnline,
    super.phoneNumber,
  }) : super(type: UserType.parkingMan);

  factory ParkingMan.fromJson(Map<String, dynamic> json) {
    return ParkingMan(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      address: json['address'],
      linkId: json['link_id'],
      isOnline: json['is_online'],
      phoneNumber: json['phone_number'],
    );
  }
}

class Car {
  final String id;
  final String model;
  final String plateNumber;

  const Car({required this.id, required this.model, required this.plateNumber});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      model: json['model'],
      plateNumber: json['plate_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'model': model, 'plate_number': plateNumber};
  }
}
