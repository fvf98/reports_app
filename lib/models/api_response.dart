class APIResponse<T> {
  T data;
  String message;
  bool error;

  APIResponse({this.data, this.message, this.error = false});
}
