import 'package:auto_route/auto_route.dart';
import 'package:bookshelf_app/data/dto/delete_book_response.dart';
import 'package:bookshelf_app/data/dto/get_book_response.dart';
import 'package:bookshelf_app/data/dto/update_book_response.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/delete_book_use_case.dart';
import 'package:bookshelf_app/domain/get_book_use_case.dart';
import 'package:bookshelf_app/domain/update_book_use_case.dart';
import 'package:bookshelf_app/pages/book_detail_page/book_detail_page.dart';
import 'package:bookshelf_app/pages/book_detail_page/book_detail_page_model.dart';
import 'package:bookshelf_app/pages/book_detail_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:bookshelf_app/shared/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'testable_widget_wrapper.dart';

class MockRouter extends Mock implements AppRouter {}

class MockGetBookUseCase extends Mock implements GetBookUseCase {}

class MockUpdateBookUseCase extends Mock implements UpdateBookUseCase {}

class MockDeleteBookUseCase extends Mock implements DeleteBookUseCase {}

class MockPageRouteInfo extends Mock implements PageRouteInfo<dynamic> {}

void main() {
  const bookId = '1';
  late AppRouter router;
  late GetBookUseCase getBookUseCase;
  late UpdateBookUseCase updateBookUseCase;
  late DeleteBookUseCase deleteBookUseCase;
  late BookDetailPageModel model;
  late BookDetailPage detailPage;
  late Widget testSubject;

  setUpAll(() => registerFallbackValue(MockPageRouteInfo()));

  setUp(() {
    router = MockRouter();
    getBookUseCase = MockGetBookUseCase();
    updateBookUseCase = MockUpdateBookUseCase();
    deleteBookUseCase = MockDeleteBookUseCase();
    model = BookDetailPageModel(bookId);
    detailPage = const BookDetailPage(bookId: bookId);
    testSubject = TestableWidgetWrapper(
      testSubject: detailPage,
      providers: [
        ListenableProvider<AppRouter>.value(value: router),
        Provider<GetBookUseCase>.value(value: getBookUseCase),
        Provider<UpdateBookUseCase>.value(value: updateBookUseCase),
        Provider<DeleteBookUseCase>.value(value: deleteBookUseCase),
        StateNotifierProvider<BookDetailPageModel, BookDetailPageState>(
          create: (context) => model..read = context.read,
        ),
      ],
    );
  });

  group('display book', () {
    testWidgets('display book after successful fetch', (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      expect(find.text('testTitle'), findsOneWidget);
      expect(find.text('testAuthor'), findsOneWidget);
    });

    testWidgets('display not found message when book is not found',
        (tester) async {
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.notFound());

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      expect(find.text('Book not found'), findsOneWidget);
    });

    testWidgets('display error message when error occurs', (tester) async {
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.error('mocked error'));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      expect(find.text('mocked error'), findsOneWidget);
    });

    testWidgets('navigate to login page when unauthorized', (tester) async {
      when(() =>
              router.pushAndPopUntil(any(), predicate: any(named: 'predicate')))
          .thenAnswer((_) async => null);
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.unauthorized());

      // load page
      await tester.pumpWidget(testSubject);

      verify(() =>
              router.pushAndPopUntil(any(), predicate: any(named: 'predicate')))
          .called(1);
    });
  });

  group('update book', () {
    testWidgets('navigate back to overview page when update succeeds',
        (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => updateBookUseCase.updateBook(book))
          .thenAnswer((_) async => UpdateBookResponse.success(book));
      when(() => router.pushAndPopUntil(const BookOverviewRoute(),
          predicate: any(named: 'predicate'))).thenAnswer((_) async => null);

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // update book
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      verify(() => router.pushAndPopUntil(const BookOverviewRoute(),
          predicate: any(named: 'predicate'))).called(1);
    });

    testWidgets('display error message when error occurs', (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => updateBookUseCase.updateBook(book))
          .thenAnswer((_) async => UpdateBookResponse.error('mocked error'));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // update book
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.text('mocked error'), findsOneWidget);
    });

    testWidgets('display not found message when book is not found',
        (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => updateBookUseCase.updateBook(book))
          .thenAnswer((_) async => UpdateBookResponse.notFound());

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // update book
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.text('Book not found'), findsOneWidget);
    });

    testWidgets('navigate to login page when unauthorized', (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => updateBookUseCase.updateBook(book))
          .thenAnswer((_) async => UpdateBookResponse.unauthorized());
      when(() =>
              router.pushAndPopUntil(any(), predicate: any(named: 'predicate')))
          .thenAnswer((_) async => null);

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // update book
      await tester.tap(find.text('Save Changes'));

      verify(() =>
              router.pushAndPopUntil(any(), predicate: any(named: 'predicate')))
          .called(1);
    });
  });

  group('delete book', () {
    testWidgets('navigate back to overview page when delete succeeds',
        (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => deleteBookUseCase.deleteBook(bookId))
          .thenAnswer((_) async => DeleteBookResponse.success());
      when(() => router.pushAndPopUntil(const BookOverviewRoute(),
          predicate: any(named: 'predicate'))).thenAnswer((_) async => null);

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // delete book
      await tester.tap(find.text('Delete Book'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));

      verify(() => router.pushAndPopUntil(const BookOverviewRoute(),
          predicate: any(named: 'predicate'))).called(1);
    });

    testWidgets('display not found message when book is not found',
        (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => deleteBookUseCase.deleteBook(bookId))
          .thenAnswer((_) async => DeleteBookResponse.notFound());

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // delete book
      await tester.tap(find.text('Delete Book'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Book not found'), findsOneWidget);
    });

    testWidgets('display error message when an error occurs', (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => deleteBookUseCase.deleteBook(bookId))
          .thenAnswer((_) async => DeleteBookResponse.error('mocked error'));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // delete book
      await tester.tap(find.text('Delete Book'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('mocked error'), findsOneWidget);
    });

    testWidgets('navigate to login page when unauthorized', (tester) async {
      final book = Book(id: bookId, title: 'testTitle', author: 'testAuthor');
      when(() => getBookUseCase.getBook(bookId))
          .thenAnswer((_) async => GetBookResponse.success(book));
      when(() => deleteBookUseCase.deleteBook(bookId))
          .thenAnswer((_) async => DeleteBookResponse.unauthorized());
      when(() =>
              router.pushAndPopUntil(any(), predicate: any(named: 'predicate')))
          .thenAnswer((_) async => null);

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // delete book
      await tester.tap(find.text('Delete Book'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));

      verify(() =>
              router.pushAndPopUntil(any(), predicate: any(named: 'predicate')))
          .called(1);
    });
  });
}
