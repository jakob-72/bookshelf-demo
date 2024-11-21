import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:bookshelf_app/domain/register_use_case.dart';
import 'package:bookshelf_app/pages/login_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:state_notifier/state_notifier.dart';

final initialState = Idle();

class LoginPageModel extends StateNotifier<LoginPageState> with LocatorMixin {
  LoginPageModel() : super(initialState);

  AppRouter get router => read<AppRouter>();

  LoginUseCase get useCase => read<LoginUseCase>();

  RegisterUseCase get registerUseCase => read<RegisterUseCase>();

  Future<void> login(String username, String password) async {
    state = Loading();
    final result = await useCase.login(username, password);
    if (result is AuthSuccess) {
      state = Success();
    } else {
      String message = 'Username or password is incorrect';
      if (result is AuthError) {
        message = result.message;
      }
      state = Error(message);
    }
  }

  Future<void> register(String username, String password) async {
    state = Loading();
    final result = await registerUseCase.register(username, password);
    if (result is RegisterSuccess) {
      await login(username, password);
    } else if (result is RegisterConflict) {
      state = Error('Username already exists');
    } else if (result is AuthError) {
      state = Error(result.message);
    }
  }

  void navigateToBooksPage() => router.replace(const BookOverviewRoute());
}
