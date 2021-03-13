class HttpException implements Exception {
  final String title;
  final String message;

  HttpException({this.title, this.message});

  @override
  String toString() {
    return title.toString() + ' ' + message.toString();
  }
}
