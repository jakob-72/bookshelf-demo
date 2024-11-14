import 'package:bookshelf_app/domain/check_token_use_case.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';

class StartPageModel {
  final AppRouter router;
  final CheckTokenUseCase useCase;

  StartPageModel({required this.router, required this.useCase});

  Future<void> onStart() async {
    if (await useCase.hasValidToken()) {
      router.replace(const BookOverviewRoute());
    } else {
      router.replace(const LoginRoute());
    }
  }
}
