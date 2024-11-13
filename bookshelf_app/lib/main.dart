import 'package:bookshelf_app/pages/start_page/start_page_model.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final router = AppRouter();

  runApp(App(
    router: router,
  ));
}

class App extends StatelessWidget {
  final AppRouter router;

  const App({super.key, required this.router});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ListenableProvider<AppRouter>.value(value: router),
          Provider<StartPageModel>.value(value: StartPageModel()),
        ],
        child: MaterialApp.router(
          title: 'Bookshelf',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            scaffoldBackgroundColor: Colors.grey[850],
            useMaterial3: true,
          ),
          routerConfig: router.config(),
        ),
      );
}
