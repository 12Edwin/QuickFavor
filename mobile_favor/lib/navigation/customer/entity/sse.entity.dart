class SSEMessage {
  final int code;
  final bool error;
  final String message;
  final SSEData data;

  SSEMessage({
    required this.code,
    required this.error,
    required this.message,
    required this.data,
  });

  factory SSEMessage.fromJson(Map<String, dynamic> json) {
    return SSEMessage(
      code: json['code'],
      error: json['error'],
      message: json['message'],
      data: SSEData.fromJson(json['data']),
    );
  }
}

class SSEData {
  final int timeout;
  final String status;

  SSEData({
    required this.timeout,
    required this.status,
  });

  factory SSEData.fromJson(Map<String, dynamic> json) {
    return SSEData(
      timeout: json['timeout'],
      status: json['status'],
    );
  }
}