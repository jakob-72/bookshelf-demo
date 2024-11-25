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
    result.when(
      authSuccess: (_) => state = Success(),
      unauthorized: (_) => state = Error('Username or password is incorrect'),
      authError: (error) => state = Error(error),
    );
  }

  Future<void> register(String username, String password) async {
    state = Loading();
    final result = await registerUseCase.register(username, password);
    result.when(
      registerSuccess: (_) => state = Success(),
      registerConflict: (_) => state = Error('Username already exists'),
      registerError: (error) => state = Error(error.message),
    );
  }

  void navigateToBooksPage() => router.replace(const BookOverviewRoute());
}
