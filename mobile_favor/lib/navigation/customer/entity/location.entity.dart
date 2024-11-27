class UpdateLocationEntity{
  final String no_courier;
  final double lat;
  final double lng;


  UpdateLocationEntity({
    required this.no_courier,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'no_courier': no_courier,
      'lat': lat,
      'lng': lng,
    };
  }

  factory UpdateLocationEntity.fromJson(Map<String, dynamic> json) {
    return UpdateLocationEntity(
      no_courier: json['no_courier'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}