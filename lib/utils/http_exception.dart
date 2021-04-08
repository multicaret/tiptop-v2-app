class HttpException implements Exception {
  final String title;
  final String message;
  final Map<String, dynamic> errors;

  HttpException({this.title, this.message, this.errors});

  String getErrorsAsString() {
    /*${title}
     ${message}*/
    return "${getErrorsRendered()}";
  }

  @override
  String toString() {
    return title.toString() + ' ' + message.toString();
  }

  String getErrorsRendered() {
    var renderedErrors = '\n';
    if (errors == null) {
      return "";
    }
    errors.forEach((index, error) {
      renderedErrors += '\n- ' + error[0].toString();
    });
    return renderedErrors;
  }
}
