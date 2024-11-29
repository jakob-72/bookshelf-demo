import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/data/dto/register_response.dart';
import 'package:bookshelf_app/domain/login_use_case.dart';
import 'package:bookshelf_app/domain/register_use_case.dart';
import 'package:bookshelf_app/pages/login_page/login_page.dart';
import 'package:bookshelf_app/pages/login_page/login_page_model.dart';
import 'package:bookshelf_app/pages/login_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'testable_widget_wrapper.dart';

class MockRouter extends Mock implements AppRouter {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late AppRouter router;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;
  late LoginPageModel model;
  late LoginPage loginPage;
  late Widget testSubject;

  setUp(() {
    router = MockRouter();
    loginUseCase = MockLoginUseCase();
    registerUseCase = MockRegisterUseCase();
    model = LoginPageModel();
    loginPage = const LoginPage();
    testSubject = TestableWidgetWrapper(
      testSubject: loginPage,
      providers: [
        ListenableProvider<AppRouter>.value(value: router),
        Provider<LoginUseCase>.value(value: loginUseCase),
        Provider<RegisterUseCase>.value(value: registerUseCase),
        StateNotifierProvider<LoginPageModel, LoginPageState>(
          create: (context) => model..read = context.read(),
        ),
      ],
    );
  });

  group('login', () {
    testWidgets('navigate to books overview page when login succeeds',
        (tester) async {
      when(() => loginUseCase.login('testUser', 'testPassword'))
          .thenAnswer((_) async => AuthResponse.success('testToken'));
      when(() => router.replace(const BookOverviewRoute()))
          .thenAnswer((_) async => null);
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // enter username and password and login
      await tester.enterText(find.byKey(LoginPage.usernameKey), 'testUser');
      await tester.enterText(find.byKey(LoginPage.passwordKey), 'testPassword');
      await tester.tap(find.byKey(LoginPage.loginKey));
      await tester.pumpAndSettle();

      verify(() => router.replace(const BookOverviewRoute())).called(1);
    });

    testWidgets('display form error when logging in with empty fields',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // submit empty fields
      await tester.tap(find.byKey(LoginPage.loginKey));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      verifyNever(() => loginUseCase.login(any(), any()));
      verifyZeroInteractions(router);
    });

    testWidgets('show snackbar with unauthorized error when login fails',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      when(() => loginUseCase.login('testUser', 'testPassword'))
          .thenAnswer((_) async => AuthResponse.unauthorized());

      // enter username and password and login
      await tester.enterText(find.byKey(LoginPage.usernameKey), 'testUser');
      await tester.enterText(find.byKey(LoginPage.passwordKey), 'testPassword');
      await tester.tap(find.byKey(LoginPage.loginKey));
      await tester.pumpAndSettle();

      expect(find.text('Username or password is incorrect'), findsOneWidget);
      verifyNever(() => router.replace(const BookOverviewRoute()));
    });

    testWidgets('show snackbar with error when login fails with another error',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      when(() => loginUseCase.login('testUser', 'testPassword'))
          .thenAnswer((_) async => AuthResponse.error('testError'));

      // enter username and password and login
      await tester.enterText(find.byKey(LoginPage.usernameKey), 'testUser');
      await tester.enterText(find.byKey(LoginPage.passwordKey), 'testPassword');
      await tester.tap(find.byKey(LoginPage.loginKey));
      await tester.pumpAndSettle();

      expect(find.text('testError'), findsOneWidget);
      verifyNever(() => router.replace(const BookOverviewRoute()));
    });
  });

  group('register', () {
    testWidgets(
        'perform login and navigate to overview page when register succeeds',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      when(() => registerUseCase.register('testUser', 'testPassword'))
          .thenAnswer((_) async => RegisterResponse.success());
      when(() => loginUseCase.login('testUser', 'testPassword'))
          .thenAnswer((_) async => AuthResponse.success('testToken'));
      when(() => router.replace(const BookOverviewRoute()))
          .thenAnswer((_) async => null);

      // enter username and password and register
      await tester.enterText(find.byKey(LoginPage.usernameKey), 'testUser');
      await tester.enterText(find.byKey(LoginPage.passwordKey), 'testPassword');
      await tester.tap(find.byKey(LoginPage.registerKey));
      await tester.pumpAndSettle();

      verify(() => router.replace(const BookOverviewRoute())).called(1);
    });

    testWidgets('display form error when registering with empty fields',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // submit empty fields
      await tester.tap(find.byKey(LoginPage.registerKey));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      verifyNever(() => registerUseCase.register(any(), any()));
      verifyNever(() => loginUseCase.login(any(), any()));
      verifyZeroInteractions(router);
    });

    testWidgets(
        'should display conflict error when register returns a conflict',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      when(() => registerUseCase.register('testUser', 'testPassword'))
          .thenAnswer((_) async => RegisterResponse.conflict());

      // enter username and password and register
      await tester.enterText(find.byKey(LoginPage.usernameKey), 'testUser');
      await tester.enterText(find.byKey(LoginPage.passwordKey), 'testPassword');
      await tester.tap(find.byKey(LoginPage.registerKey));
      await tester.pumpAndSettle();

      expect(find.text('Username already exists'), findsOneWidget);
      verifyNever(() => loginUseCase.login(any(), any()));
      verifyZeroInteractions(router);
    });

    testWidgets('should display error when register fails with another error',
        (tester) async {
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      when(() => registerUseCase.register('testUser', 'testPassword'))
          .thenAnswer((_) async => RegisterResponse.error('testError'));

      // enter username and password and register
      await tester.enterText(find.byKey(LoginPage.usernameKey), 'testUser');
      await tester.enterText(find.byKey(LoginPage.passwordKey), 'testPassword');
      await tester.tap(find.byKey(LoginPage.registerKey));
      await tester.pumpAndSettle();

      expect(find.text('testError'), findsOneWidget);
      verifyNever(() => loginUseCase.login(any(), any()));
      verifyZeroInteractions(router);
    });
  });
}
