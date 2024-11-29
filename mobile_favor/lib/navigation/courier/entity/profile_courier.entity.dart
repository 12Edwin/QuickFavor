class ProfileCourierEntity {
  final String? uid;
  final String? name;
  final String? surname;
  final String? lastname;
  final String? email;
  final String? curp;
  final String? sex;
  final String? role;
  final String? phone;
  final DateTime? createdAt;
  final String? noCourier;
  final String? fcmToken;
  final int? rejectedOrders;
  final String? vehicleType;
  final String? status;
  final String? licensePlate;
  final DateTime? lastUpdate;
  final String? idPerson;
  final String? faceUrl;
  final String? ineUrl;
  final String? plateUrl;
  final String? brand;
  final String? model;
  final String? color;

  ProfileCourierEntity({
    this.uid,
    this.name,
    this.surname,
    this.lastname,
    this.email,
    this.curp,
    this.sex,
    this.role,
    this.phone,
    this.createdAt,
    this.noCourier,
    this.fcmToken,
    this.rejectedOrders,
    this.vehicleType,
    this.status,
    this.licensePlate,
    this.lastUpdate,
    this.idPerson,
    this.faceUrl,
    this.ineUrl,
    this.plateUrl,
    this.brand,
    this.model,
    this.color,
  });

  // Factory constructor to create an instance from JSON data
  factory ProfileCourierEntity.fromJson(Map<String, dynamic> json) {
    return ProfileCourierEntity(
      uid: json['uid'],
      name: json['name'],
      surname: json['surname'],
      lastname: json['lastname'],
      email: json['email'],
      curp: json['curp'],
      sex: json['sex'],
      role: json['role'],
      phone: json['phone'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      noCourier: json['no_courier'],
      fcmToken: json['fcm_token'],
      rejectedOrders: json['rejected_orders'],
      vehicleType: json['vehicle_type'],
      status: json['status'],
      licensePlate: json['license_plate'],
      lastUpdate: json['last_update'] != null
          ? DateTime.parse(json['last_update'])
          : null,
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
      'created_at': createdAt?.toIso8601String(),
      'no_courier': noCourier,
      'fcm_token': fcmToken,
      'rejected_orders': rejectedOrders,
      'vehicle_type': vehicleType,
      'status': status,
      'license_plate': licensePlate,
      'last_update': lastUpdate?.toIso8601String(),
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
