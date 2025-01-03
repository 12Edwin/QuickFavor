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
  final String? plate_photo;
  final String? plateUrl;
  final int? rejectedOrders;
  final String? fcmToken;
  final String? uid;
  final String? brand; // Nuevo campo
  final String? model; // Nuevo campo
  final String? color; // Nuevo campo
  final String? description; // Nuevo campo

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
    this.plate_photo,
    this.plateUrl,
    this.rejectedOrders,
    this.fcmToken,
    this.uid,
    this.brand, // Nuevo campo
    this.model, // Nuevo campo
    this.color, // Nuevo campo
    this.description, // Nuevo campo
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
        plate_photo: json['plate_photo'],
        plateUrl: json['plate_url'], // Ajustado para coincidir con el JSON
        rejectedOrders: json['rejected_orders'],
        fcmToken: json['fcm_token'],
        uid: json['uid'],
        brand: json['brand'], // Nuevo campo
        model: json['model'], // Nuevo campo
        color: json['color'], // Nuevo campo
        description: json['description'] // Nuevo campo
        );
  }

  // Método toString para mejorar la visualización en los logs
  @override
  String toString() {
    return 'ProfileCourierEntity(name: $name, surname: $surname, email: $email, phone: $phone, vehicleType: $vehicleType, status: $status, brand: $brand, model: $model, color: $color, description: $description)';
  }

  // Método para convertir de ProfileCourierEntity a JSON
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
      'plate_photo': plate_photo,
      'rejected_orders': rejectedOrders,
      'fcm_token': fcmToken,
      'uid': uid,
      'brand': brand, // Nuevo campo
      'model': model, // Nuevo campo
      'color': color, // Nuevo campo
      'description': description // Nuevo campo
    };
  }

  // Método copyWith para crear una copia modificada
  ProfileCourierEntity copyWith({
    String? name,
    String? surname,
    String? lastname,
    String? email,
    String? curp,
    String? sex,
    String? role,
    String? phone,
    String? vehicleType,
    String? status,
    String? licensePlate,
    String? faceUrl,
    String? ineUrl,
    String? plate_photo,
    String? plateUrl,
    int? rejectedOrders,
    String? fcmToken,
    String? uid,
    String? brand,
    String? model,
    String? color,
    String? description,
  }) {
    return ProfileCourierEntity(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      curp: curp ?? this.curp,
      sex: sex ?? this.sex,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      licensePlate: licensePlate ?? this.licensePlate,
      faceUrl: faceUrl ?? this.faceUrl,
      ineUrl: ineUrl ?? this.ineUrl,
      plate_photo: plate_photo ?? this.plate_photo,
      rejectedOrders: rejectedOrders ?? this.rejectedOrders,
      fcmToken: fcmToken ?? this.fcmToken,
      uid: uid ?? this.uid,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      color: color ?? this.color,
      description: description ?? this.description,
    );
  }
}
