// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:bookshelf_app/data/models/book.dart' as _i7;
import 'package:bookshelf_app/pages/book_detail_page/book_detail_page.dart'
    as _i1;
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page.dart'
    as _i2;
import 'package:bookshelf_app/pages/login_page/login_page.dart' as _i3;
import 'package:bookshelf_app/pages/start_page/start_page.dart' as _i4;
import 'package:flutter/material.dart' as _i6;

/// generated route for
/// [_i1.BookDetailPage]
class BookDetailRoute extends _i5.PageRouteInfo<BookDetailRouteArgs> {
  BookDetailRoute({
    _i6.Key? key,
    required _i7.Book book,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          BookDetailRoute.name,
          args: BookDetailRouteArgs(
            key: key,
            book: book,
          ),
          initialChildren: children,
        );

  static const String name = 'BookDetailRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookDetailRouteArgs>();
      return _i1.BookDetailPage(
        key: args.key,
        initialBook: args.book,
      );
    },
  );
}

class BookDetailRouteArgs {
  const BookDetailRouteArgs({
    this.key,
    required this.book,
  });

  final _i6.Key? key;

  final _i7.Book book;

  @override
  String toString() {
    return 'BookDetailRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i2.BookOverviewPage]
class BookOverviewRoute extends _i5.PageRouteInfo<void> {
  const BookOverviewRoute({List<_i5.PageRouteInfo>? children})
      : super(
          BookOverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookOverviewRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.BookOverviewPage();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i6.Key? key,
    bool unauthorized = false,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            unauthorized: unauthorized,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i3.LoginPage(
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

  final _i6.Key? key;

  final bool unauthorized;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, unauthorized: $unauthorized}';
  }
}

/// generated route for
/// [_i4.StartPage]
class StartRoute extends _i5.PageRouteInfo<void> {
  const StartRoute({List<_i5.PageRouteInfo>? children})
      : super(
          StartRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.StartPage();
    },
  );
}
