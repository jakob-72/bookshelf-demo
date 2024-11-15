import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/data/dto/auth_response.dart';
import 'package:bookshelf_app/pages/login_page/login_page_model.dart';
import 'package:bookshelf_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  final bool unauthorized;

  const LoginPage({super.key, this.unauthorized = false});

  @override
  Widget build(BuildContext context) => Consumer<LoginPageModel>(
        builder: (BuildContext context, LoginPageModel model, Widget? _) {
          if (unauthorized) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text('You need to login to access this page'),
                ),
                duration: Duration(milliseconds: 2500),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login', style: headline1),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: LoginForm(model: model),
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class LoginForm extends StatefulWidget {
  final LoginPageModel model;

  const LoginForm({super.key, required this.model});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 640,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: _inputDecoration('Username'),
              ),
              const Gap(16),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: _inputDecoration('Password'),
              ),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isLoading) {
                      return;
                    }
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() => isLoading = true);
                    final result = await widget.model.login(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    setState(() => isLoading = false);
                    if (result is AuthResponseSuccess) {
                      widget.model.navigateToBooksPage();
                    } else {
                      String message = 'Username or password is incorrect';
                      if (result is AuthResponseInternalError) {
                        message = result.message;
                      }
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                            child: Text(message),
                          ),
                          duration: const Duration(milliseconds: 2500),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        label: Text(label),
        hintText: label,
        labelStyle: const TextStyle(color: Colors.white),
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.grey[350]),
        focusColor: Colors.grey[400],
        hoverColor: Colors.grey[400],
      );
}
