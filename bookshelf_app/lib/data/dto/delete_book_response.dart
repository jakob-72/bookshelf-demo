sealed class DeleteBookResponse {
  void when({
    required void Function() deletedSuccessfully,
    required void Function() deleteBookNotFound,
    required void Function(String message) deleteBookError,
  }) {
    if (this is DeletedSuccessfully) {
      deletedSuccessfully();
    } else if (this is DeleteBookNotFound) {
      deleteBookNotFound();
    } else if (this is DeleteBookError) {
      deleteBookError((this as DeleteBookError).message);
    }
  }
}

class DeletedSuccessfully extends DeleteBookResponse {}

class DeleteUnauthorized extends DeleteBookResponse {}

class DeleteBookNotFound extends DeleteBookResponse {}

class DeleteBookError extends DeleteBookResponse {
  final String message;

  DeleteBookError(this.message);
}
