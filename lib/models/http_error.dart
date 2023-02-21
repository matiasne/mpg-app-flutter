class HttpError implements Exception {
  int statusCode;
  String message;

  HttpError({
    required this.statusCode,
    required this.message,
  });


  static HttpError fromMap(Map<String, dynamic> map) {
    return HttpError(
      statusCode: map['statusCode'],
      message: map['message'],
    );
  }
}