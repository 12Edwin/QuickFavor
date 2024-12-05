class ProfileEntity {
  final String uid;
  final String name;
  final String surname;
  final String lastname;
  final String email;
  final String curp;
  final String sex;
  final String role;
  final String phone;
  final DateTime createdAt;
  final String noCourier;
  final String? fcmToken;
  final int rejectedOrders;
  final String vehicleType;
  final String status;
  final String licensePlate;
  final DateTime lastUpdate;
  final String idPerson;
  final String faceUrl;
  final String ineUrl;
  final String plateUrl;
  final String brand;
  final String model;
  final String color;

  ProfileEntity({
    required this.uid,
    required this.name,
    required this.surname,
    required this.lastname,
    required this.email,
    required this.curp,
    required this.sex,
    required this.role,
    required this.phone,
    required this.createdAt,
    required this.noCourier,
    this.fcmToken,
    required this.rejectedOrders,
    required this.vehicleType,
    required this.status,
    required this.licensePlate,
    required this.lastUpdate,
    required this.idPerson,
    required this.faceUrl,
    required this.ineUrl,
    required this.plateUrl,
    required this.brand,
    required this.model,
    required this.color,
  });

  // Factory constructor to create an instance from JSON data
  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      uid: json['uid'],
      name: json['name'],
      surname: json['surname'],
      lastname: json['lastname'],
      email: json['email'],
      curp: json['curp'],
      sex: json['sex'],
      role: json['role'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      noCourier: json['no_courier'],
      fcmToken: json['fcm_token'],
      rejectedOrders: json['rejected_orders'],
      vehicleType: json['vehicle_type'],
      status: json['status'],
      licensePlate: json['license_plate'],
      lastUpdate: DateTime.parse(json['last_update']),
      idPerson: json['id_person'],
      faceUrl: json['face_url'],
      ineUrl: json['ine_url'],
      plateUrl: json['plate_url'],
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
    );
  }

  // Method to convert the instance to a Map (for example, to send as JSON)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'lastname': lastname,
      'email': email,
      'curp': curp,
      'sex': sex,
      'role': role,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'no_courier': noCourier,
      'fcm_token': fcmToken,
      'rejected_orders': rejectedOrders,
      'vehicle_type': vehicleType,
      'status': status,
      'license_plate': licensePlate,
      'last_update': lastUpdate.toIso8601String(),
      'id_person': idPerson,
      'face_url': faceUrl,
      'ine_url': ineUrl,
      'plate_url': plateUrl,
      'brand': brand,
      'model': model,
      'color': color,
    };
  }
}
