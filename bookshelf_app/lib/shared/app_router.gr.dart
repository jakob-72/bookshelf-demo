// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page.dart'
    as _i1;
import 'package:bookshelf_app/pages/login_page/login_page.dart' as _i2;
import 'package:bookshelf_app/pages/start_page/start_page.dart' as _i3;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.BookOverviewPage]
class BookOverviewRoute extends _i4.PageRouteInfo<void> {
  const BookOverviewRoute({List<_i4.PageRouteInfo>? children})
      : super(
          BookOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookOverviewRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.BookOverviewPage();
    },
  );
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i5.Key? key,
    bool unauthorized = false,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            unauthorized: unauthorized,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i2.LoginPage(
        key: args.key,
        unauthorized: args.unauthorized,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.unauthorized = false,
  });

  final _i5.Key? key;

  final bool unauthorized;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, unauthorized: $unauthorized}';
  }
}

/// generated route for
/// [_i3.StartPage]
class StartRoute extends _i4.PageRouteInfo<void> {
  const StartRoute({List<_i4.PageRouteInfo>? children})
      : super(
          StartRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.StartPage();
    },
  );
}
