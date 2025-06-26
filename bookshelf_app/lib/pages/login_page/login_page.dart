import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/pages/login_page/login_page_model.dart';
import 'package:bookshelf_app/pages/login_page/state.dart';
import 'package:bookshelf_app/shared/extensions.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  static const usernameKey = Key('username');
  static const passwordKey = Key('password');
  static const loginKey = Key('login');
  static const registerKey = Key('register');

  final bool unauthorized;

  const LoginPage({super.key, this.unauthorized = false});

  @override
  Widget build(BuildContext context) => Builder(
    builder: (_) {
      if (unauthorized) {
        context.showSnackbar('Please login to continue');
      }
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login', style: headline1),
              Gap(16),
              Padding(padding: EdgeInsets.all(8), child: LoginForm()),
            ],
          ),
        ),
      );
    },
  );
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      StateNotifierProvider<LoginPageModel, LoginPageState>(
        create: (_) => LoginPageModel(),
        builder: (context, _) {
          final model = context.read<LoginPageModel>();
          final state = context.watch<LoginPageState>();
          if (state is Loading) {
            return const CircularProgressIndicator();
          }

          if (state is Success) {
            model.navigateToBooksPage();
          } else if (state is Error) {
            context.showSnackbar(state.message);
          }

          return ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 400, maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: LoginPage.usernameKey,
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (_) => _login(model),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    decoration: inputDecoration('Username'),
                  ),
                  const Gap(16),
                  TextFormField(
                    key: LoginPage.passwordKey,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    onFieldSubmitted: (_) => _login(model),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: inputDecoration('Password'),
                  ),
                  const Gap(16),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: LoginPage.loginKey,
                          onPressed: () => _login(model),
                          style: primaryButton,
                          child: const Text('Login'),
                        ),
                      ),
                      const Gap(16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: LoginPage.registerKey,
                          onPressed: () => _register(model),
                          style: secondaryButton,
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

  void _login(LoginPageModel model) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    model.login(_usernameController.text, _passwordController.text);
  }

  void _register(LoginPageModel model) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    model.register(_usernameController.text, _passwordController.text);
  }

  @override
  dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
