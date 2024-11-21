import 'package:bookshelf_app/data/local_storage.dart';

class LogoutUseCase {
  final LocalStorage storage;

  const LogoutUseCase({required this.storage});

  Future<void> logout() async => storage.deleteToken();
}
