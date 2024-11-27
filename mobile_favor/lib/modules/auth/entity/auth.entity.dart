class LoginEntity {
  final String email;
  final String password;

  LoginEntity({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    return LoginEntity(
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegisterCourierEntity {
  final String name;
  final String surname;
  final String? lastname;
  final String CURP;
  final String sex;
  final String phone;
  final String vehicle_type;
  final String? brand;
  final String? model;
  final String? license_plate;
  final String? color;
  final String? plate_photo;
  final String face_photo;
  final String INE_photo;
  final String email;
  final String password;

  RegisterCourierEntity({
    required this.name,
    required this.surname,
    this.lastname,
    required this.CURP,
    required this.sex,
    required this.phone,
    required this.vehicle_type,
    this.brand,
    this.model,
    this.license_plate,
    this.color,
    this.plate_photo,
    required this.face_photo,
    required this.INE_photo,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'surname': surname,
      'CURP': CURP,
      'sex': sex,
      'phone': phone,
      'vehicle_type': vehicle_type,
      'face_photo': face_photo,
      'INE_photo': INE_photo,
      'email': email,
      'password': password,
    };

    if (lastname != null) data['lastname'] = lastname;
    if (brand != null) data['brand'] = brand;
    if (model != null) data['model'] = model;
    if (license_plate != null) data['license_plate'] = license_plate;
    if (color != null) data['color'] = color;
    if (plate_photo != null) data['plate_photo'] = plate_photo;

    return data;
  }

  factory RegisterCourierEntity.fromJson(Map<String, dynamic> json) {
    return RegisterCourierEntity(
      name: json['name'],
      surname: json['surname'],
      lastname: json['lastname'],
      CURP: json['CURP'],
      sex: json['sex'],
      phone: json['phone'],
      vehicle_type: json['vehicle_type'],
      brand: json['brand'],
      model: json['model'],
      license_plate: json['license_plate'],
      color: json['color'],
      plate_photo: json['plate_photo'],
      face_photo: json['face_photo'],
      INE_photo: json['INE_photo'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegisterCustomerEntity {
  final String name;
  final String surname;
  final String? lastname;
  final String CURP;
  final String sex;
  final String phone;
  final String direction;
  final double lat;
  final double lng;
  final String email;
  final String password;

  RegisterCustomerEntity({
    required this.name,
    required this.surname,
    this.lastname,
    required this.CURP,
    required this.sex,
    required this.phone,
    required this.direction,
    required this.lat,
    required this.lng,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'surname': surname,
      'CURP': CURP,
      'sex': sex,
      'phone': phone,
      'direction': direction,
      'lat': lat,
      'lng': lng,
      'email': email,
      'password': password,
    };

    if (lastname != null) data['lastname'] = lastname;

    return data;
  }
}