import 'package:auto_route/auto_route.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: BookOverviewRoute.page),
        AutoRoute(page: BookDetailRoute.page),
      ];
}
