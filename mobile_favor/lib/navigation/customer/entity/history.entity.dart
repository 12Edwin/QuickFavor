class HistoryItemEntity{
  final String no_order;
  final String status;
  final String created_at;
  final int products;

  HistoryItemEntity({
    required this.no_order,
    required this.status,
    required this.created_at,
    required this.products,
  });

  factory HistoryItemEntity.fromJson(Map<String, dynamic> json){
    return HistoryItemEntity(
      no_order: json['no_order'],
      status: json['status'],
      created_at: json['created_at'],
      products: json['products'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'no_order': no_order,
      'status': status,
      'created_at': created_at,
      'products': products,
    };
  }
}