class NotificationEntity {
  final int amount;
  final String created_at;
  final String type;
  final String status;
  final String order_id;

  NotificationEntity({
    required this.amount,
    required this.created_at,
    required this.type,
    required this.status,
    required this.order_id,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      amount: json['amount'],
      created_at: json['created_at'],
      type: json['type'],
      status: json['status'],
      order_id: json['order_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'created_at': created_at,
      'type': type,
      'status': status,
      'order_id': order_id,
    };
  }

}


class AcceptFavorEntity {
  final String order_id;
  final String courier_id;
  final Location location;

  AcceptFavorEntity({
    required this.order_id,
    required this.courier_id,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'courier_id': courier_id,
      'location': location.toJson(),
    };
  }

  factory AcceptFavorEntity.fromJson(Map<String, dynamic> json) {
    return AcceptFavorEntity(
      order_id: json['order_id'],
      courier_id: json['courier_id'],
      location: Location.fromJson(json['location']),
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}