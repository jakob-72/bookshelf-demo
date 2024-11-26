sealed class DeleteBookResponse {
  const DeleteBookResponse();

  void when({
    required void Function() success,
    required void Function() unauthorized,
    required void Function() notFound,
    required void Function(String message) error,
  }) {
    if (this is _Success) {
      success();
    } else if (this is _Unauthorized) {
      unauthorized();
    } else if (this is _NotFound) {
      notFound();
    } else if (this is _Error) {
      error((this as _Error).message);
    }
  }

  factory DeleteBookResponse.success() = _Success;

  factory DeleteBookResponse.unauthorized() = _Unauthorized;

  factory DeleteBookResponse.notFound() = _NotFound;

  factory DeleteBookResponse.error(String message) = _Error;
}

class _Success extends DeleteBookResponse {}

class _Unauthorized extends DeleteBookResponse {}

class _NotFound extends DeleteBookResponse {}

class _Error extends DeleteBookResponse {
  final String message;

  _Error(this.message);
}
