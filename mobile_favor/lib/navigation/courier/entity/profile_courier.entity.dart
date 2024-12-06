class ProfileCourierEntity {
  final String? name;
  final String? surname;
  final String? lastname;
  final String? email;
  final String? curp;
  final String? sex;
  final String? role;
  final String? phone;
  final String? vehicleType;
  final String? status;
  final String? licensePlate;
  final String? faceUrl;
  final String? ineUrl;
  final String? plateUrl;
  final int? rejectedOrders;
  final String? fcmToken;
  final String? uid;

  ProfileCourierEntity({
    this.name,
    this.surname,
    this.lastname,
    this.email,
    this.curp,
    this.sex,
    this.role,
    this.phone,
    this.vehicleType,
    this.status,
    this.licensePlate,
    this.faceUrl,
    this.ineUrl,
    this.plateUrl,
    this.rejectedOrders,
    this.fcmToken,
    this.uid,
  });

  // Método para convertir de JSON a ProfileCourierEntity
  factory ProfileCourierEntity.fromJson(Map<String, dynamic> json) {
    return ProfileCourierEntity(
      name: json['name'],
      surname: json['surname'],
      lastname: json['lastname'],
      email: json['email'],
      curp: json['curp'],
      sex: json['sex'],
      role: json['role'],
      phone: json['phone'],
      vehicleType: json['vehicle_type'],
      status: json['status'],
      licensePlate: json['license_plate'],
      faceUrl: json['face_url'],
      ineUrl: json['ine_url'],
      plateUrl: json['plate_url'],
      rejectedOrders: json['rejected_orders'],
      fcmToken: json['fcm_token'],
      uid: json['uid'],
    );
  }

  // Sobrescribir el método toString para mejorar la visualización en los logs
  @override
  String toString() {
    return 'ProfileCourierEntity(name: $name, surname: $surname, email: $email, phone: $phone, vehicleType: $vehicleType, status: $status)';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'lastname': lastname,
      'email': email,
      'curp': curp,
      'sex': sex,
      'role': role,
      'phone': phone,
      'vehicle_type': vehicleType,
      'status': status,
      'license_plate': licensePlate,
      'face_url': faceUrl,
      'ine_url': ineUrl,
      'plate_url': plateUrl,
      'rejected_orders': rejectedOrders,
      'fcm_token': fcmToken,
      'uid': uid,
    };
  }
}
