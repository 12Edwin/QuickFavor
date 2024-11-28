class ErrorData {
  final String type;
  final String msg;
  final String path;
  final String location;

  ErrorData({
    required this.type,
    required this.msg,
    required this.path,
    required this.location,
  });

  factory ErrorData.fromJson(Map<String, dynamic> json) {
    return ErrorData(
      type: json['type'],
      msg: json['msg'],
      path: json['path'],
      location: json['location'],
    );
  }
}

class ResponseEntity {
  final int code;
  final bool error;
  final String message;
  final dynamic data;

  ResponseEntity({
    required this.code,
    required this.error,
    required this.message,
    this.data,
  });

  factory ResponseEntity.fromJson(Map<String, dynamic> json) {
    print(json);
    return ResponseEntity(
      code: json['code'],
      error: json['error'],
      message: json['message'],
      data: json['data'],
    );
  }
}

ResponseEntity getErrorMessages(ResponseEntity response) {
  final errors = (response.data as List)
      .map((error) => ErrorData.fromJson(error).msg)
      .toList();
  print(errors);
  return ResponseEntity(
    code: response.code,
    error: true,
    message: errors.isNotEmpty ? errors[0] : 'Unknown error',
    data: null,
  );
}