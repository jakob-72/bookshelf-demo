import 'package:auto_route/annotations.dart';
import 'package:bookshelf_app/pages/start_page/start_page_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

@RoutePage()
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) => Consumer<StartPageModel>(
        builder: (BuildContext context, StartPageModel model, Widget? _) =>
            Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const Gap(16),
                CircularProgressIndicator(
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      );
}
