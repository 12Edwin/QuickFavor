class CreateOrderEntity {
  final String id_customer;
  final CustomerDirection customer_direction;
  final List<CollectionPoints> collection_points;
  final List<Products> products;

  CreateOrderEntity({
    required this.id_customer,
    required this.customer_direction,
    required this.collection_points,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id_customer': id_customer,
      'customer_direction': customer_direction.toJson(),
      'collection_points': collection_points.map((e) => e.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
    };
    return data;
  }

  factory CreateOrderEntity.fromJson(Map<String, dynamic> json) {
    return CreateOrderEntity(
      id_customer: json['id_customer'],
      customer_direction: CustomerDirection.fromJson(json['customer_direction']),
      collection_points: List<CollectionPoints>.from(json['collection_points'].map((x) => CollectionPoints.fromJson(x))),
      products: List<Products>.from(json['products'].map((x) => Products.fromJson(x))),
    );
  }
}

class Products {
  final int id;
  final String name;
  final String description;
  final int amount;

  Products({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
    };
    return data;
  }

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
    );
  }
}

class CollectionPoints{
  final String name;
  final double lat;
  final double lng;

  CollectionPoints({
    required this.name,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
    return data;
  }

  factory CollectionPoints.fromJson(Map<String, dynamic> json) {
    return CollectionPoints(
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class CustomerDirection{
  final String name;
  final double lat;
  final double lng;

  CustomerDirection({
    required this.name,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
    return data;
  }

  factory CustomerDirection.fromJson(Map<String, dynamic> json) {
    return CustomerDirection(
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class SearchCourierEntity {
  final String no_order;
  final DeliveryPoint delivery_point;
  final int distance_km;

  SearchCourierEntity({
    required this.no_order,
    required this.delivery_point,
    required this.distance_km,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'no_order': no_order,
      'delivery_point': delivery_point.toJson(),
      'distance_km': distance_km,
    };
    return data;
  }

  factory SearchCourierEntity.fromJson(Map<String, dynamic> json) {
    return SearchCourierEntity(
      no_order: json['no_order'],
      delivery_point: DeliveryPoint.fromJson(json['delivery_point']),
      distance_km: json['distance_km'],
    );
  }
}

class DeliveryPoint {
  final double lat;
  final double lng;

  DeliveryPoint({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'lat': lat,
      'lng': lng,
    };
    return data;
  }

  factory DeliveryPoint.fromJson(Map<String, dynamic> json) {
    return DeliveryPoint(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class SSEOrderMessage {
  final int code;
  final bool error;
  final String message;
  final OrderStatus data;

  SSEOrderMessage({
    required this.code,
    required this.error,
    required this.message,
    required this.data,
  });

  factory SSEOrderMessage.fromJson(Map<String, dynamic> json) {
    return SSEOrderMessage(
      code: json['code'],
      error: json['error'],
      message: json['message'],
      data: OrderStatus.fromJson(json['data']),
    );
  }
}

class OrderStatus{
  final String status;
  final String order_created_at;

  OrderStatus({
    required this.status,
    required this.order_created_at,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      status: json['status'],
      order_created_at: json['order_created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'status': status,
      'order_created_at': order_created_at,
    };
    return data;
  }
}

class OrderPreviewEntity {
  final String no_order;
  final String order_created_at;
  final String? order_finished_at;
  final String status;
  final String? receipt_url;
  final double? cost;
  final String no_customer;
  final String customer_name;
  final String customer_surname;
  final String? customer_lastname;
  final String customer_email;
  final String customer_phone;
  final String? no_courier;
  final String? license_plate;
  final String? vehicle_type;
  final String? model;
  final String? color;
  final String? plate_url;
  final String? face_url;
  final int? rejected_orders;
  final String? courier_status;
  final String? courier_name;
  final String? courier_surname;
  final String? courier_lastname;
  final String? courier_email;
  final String? courier_phone;
  final String place_name;
  final double place_lat;
  final double place_lng;
  final List<Delivery>? deliveryPoints;
  final List<Prod>? products;

  OrderPreviewEntity({
    required this.no_order,
    required this.order_created_at,
    this.order_finished_at,
    required this.status,
    this.cost,
    this.receipt_url,
    required this.no_customer,
    required this.customer_name,
    required this.customer_surname,
    required this.customer_lastname,
    required this.customer_email,
    required this.customer_phone,
    this.no_courier,
    this.license_plate,
    this.vehicle_type,
    this.model,
    this.color,
    this.plate_url,
    this.face_url,
    this.rejected_orders,
    this.courier_status,
    this.courier_name,
    this.courier_surname,
    this.courier_lastname,
    this.courier_email,
    this.courier_phone,
    required this.place_name,
    required this.place_lat,
    required this.place_lng,
    this.deliveryPoints,
    this.products,
  });

  factory OrderPreviewEntity.fromJson(Map<String, dynamic> json) {
    return OrderPreviewEntity(
      no_order: json['no_order'],
      order_created_at: json['order_created_at'],
      order_finished_at: json['order_finished_at'],
      status: json['status'],
      cost: json['cost'] != null ? num.parse(json['cost'].toString()).toDouble(): null,
      receipt_url: json['receipt_url'],
      no_customer: json['no_customer'],
      customer_name: json['customer_name'],
      customer_surname: json['customer_surname'],
      customer_lastname: json['customer_lastname'],
      customer_email: json['customer_email'],
      customer_phone: json['customer_phone'],
      no_courier: json['no_courier'],
      license_plate: json['license_plate'],
      vehicle_type: json['vehicle_type'],
      model: json['model'],
      color: json['color'],
      plate_url: json['plate_url'],
      face_url: json['face_url'],
      rejected_orders: json['rejected_orders'] != null ? num.parse(json['rejected_orders'].toString()).toInt(): 0,
      courier_status: json['courier_status'],
      courier_name: json['courier_name'],
      courier_surname: json['courier_surname'],
      courier_lastname: json['courier_lastname'],
      courier_email: json['courier_email'],
      courier_phone: json['courier_phone'],
      place_name: json['place_name'],
      place_lat: json['place_lat'],
      place_lng: json['place_lng'],
      deliveryPoints: json['deliveryPoints'] == null ? [] : List<Delivery>.from(
          json['deliveryPoints'].map((x) => Delivery.fromJson(x))),
      products: json['products'] == null ? [] : List<Prod>.from(json['products'].map((x) => Prod.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'no_order': no_order,
      'order_created_at': order_created_at,
      'status': status,
      'no_customer': no_customer,
      'customer_name': customer_name,
      'customer_surname': customer_surname,
      'customer_lastname': customer_lastname,
      'customer_email': customer_email,
      'customer_phone': customer_phone,
      'place_name': place_name,
      'place_lat': place_lat,
      'place_lng': place_lng,
    };

    if (order_finished_at != null) {
      data['order_finished_at'] = order_finished_at;
    }
    if (cost != null) {
      data['cost'] = cost;
    }
    if (receipt_url != null) {
      data['receipt_url'] = receipt_url;
    }
    if (no_courier != null) {
      data['no_courier'] = no_courier;
    }
    if (license_plate != null) {
      data['license_plate'] = license_plate;
    }
    if (vehicle_type != null) {
      data['vehicle_type'] = vehicle_type;
    }
    if (model != null) {
      data['model'] = model;
    }
    if (color != null) {
      data['color'] = color;
    }
    if (plate_url != null) {
      data['plate_url'] = plate_url;
    }
    if (face_url != null) {
      data['face_url'] = face_url;
    }
    if (rejected_orders != null) {
      data['rejected_orders'] = rejected_orders;
    }
    if (courier_status != null) {
      data['courier_status'] = courier_status;
    }
    if (courier_name != null) {
      data['courier_name'] = courier_name;
    }
    if (courier_surname != null) {
      data['courier_surname'] = courier_surname;
    }
    if (courier_lastname != null) {
      data['courier_lastname'] = courier_lastname;
    }
    if (courier_email != null) {
      data['courier_email'] = courier_email;
    }
    if (courier_phone != null) {
      data['courier_phone'] = courier_phone;
    }
    if (deliveryPoints != null) {
      data['delivery_points'] = deliveryPoints!.map((x) => x.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((x) => x.toJson()).toList();
    }

    return data;
  }
}

class Delivery {
  final String name;
  final double lat;
  final double lng;

  Delivery({
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      name: json['name'],
      lat: num.parse(json['lat'].toString()).toDouble(),
      lng: num.parse(json['lng'].toString()).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
    return data;
  }
}

class Prod {
  final String name;
  final String description;
  final int amount;

  Prod({
    required this.name,
    required this.description,
    required this.amount,
  });

  factory Prod.fromJson(Map<String, dynamic> json) {
    return Prod(
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'amount': amount,
    };
    return data;
  }
}

class ChangeStateEntity {
  final String no_order;
  final String newStatus;
  final double? cost;
  final String? receipt;

  ChangeStateEntity({
    required this.no_order,
    required this.newStatus,
    this.cost,
    this.receipt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'no_order': no_order,
      'newStatus': newStatus,
    };
    if (cost != null) {
      data['cost'] = cost;
    }
    if (receipt != null) {
      data['receipt'] = receipt;
    }
    return data;
  }

  factory ChangeStateEntity.fromJson(Map<String, dynamic> json) {
    return ChangeStateEntity(
      no_order: json['no_order'],
      newStatus: json['newStatus'],
      cost: json['cost'],
      receipt: json['receipt'],
    );
  }
}