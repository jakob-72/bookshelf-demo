import 'package:auto_route/auto_route.dart';
import 'package:bookshelf_app/data/dto/add_book_response.dart';
import 'package:bookshelf_app/data/dto/get_books_response.dart';
import 'package:bookshelf_app/data/models/book.dart';
import 'package:bookshelf_app/domain/add_book_use_case.dart';
import 'package:bookshelf_app/domain/get_books_use_case.dart';
import 'package:bookshelf_app/domain/logout_use_case.dart';
import 'package:bookshelf_app/pages/books_overview_page/add_book_dialog.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page.dart';
import 'package:bookshelf_app/pages/books_overview_page/book_overview_page_model.dart';
import 'package:bookshelf_app/pages/books_overview_page/state.dart';
import 'package:bookshelf_app/shared/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'testable_widget_wrapper.dart';

class MockRouter extends Mock implements AppRouter {}

class MockGetBooksUseCase extends Mock implements GetBooksUseCase {}

class MockAddBookUseCase extends Mock implements AddBookUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockPageRouteInfo extends Mock implements PageRouteInfo<dynamic> {}

void main() {
  late AppRouter router;
  late GetBooksUseCase getBooksUseCase;
  late AddBookUseCase addBookUseCase;
  late LogoutUseCase logoutUseCase;
  late BookOverviewPageModel model;
  late BookOverviewPage overviewPage;
  late Widget testSubject;

  setUpAll(() => registerFallbackValue(MockPageRouteInfo()));

  setUp(() {
    router = MockRouter();
    getBooksUseCase = MockGetBooksUseCase();
    addBookUseCase = MockAddBookUseCase();
    logoutUseCase = MockLogoutUseCase();
    model = BookOverviewPageModel();
    overviewPage = const BookOverviewPage();
    testSubject = TestableWidgetWrapper(
      testSubject: overviewPage,
      providers: [
        ListenableProvider<AppRouter>.value(value: router),
        Provider<GetBooksUseCase>.value(value: getBooksUseCase),
        Provider<AddBookUseCase>.value(value: addBookUseCase),
        Provider<LogoutUseCase>.value(value: logoutUseCase),
        StateNotifierProvider<BookOverviewPageModel, BooksOverviewPageState>(
          create: (context) => model..read = context.read,
        ),
      ],
    );
  });

  group('display books', () {
    testWidgets('display books when fetched successfully', (tester) async {
      final books = [
        Book(id: '1', title: 'test 1', author: 'test'),
        Book(id: '2', title: 'test 2', author: 'test'),
      ];
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success(books));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      expect(find.text('test 1'), findsOneWidget);
      expect(find.text('test 2'), findsOneWidget);
    });

    testWidgets('display message when empty list is fetched', (tester) async {
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success([]));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      expect(find.text('No books found'), findsOneWidget);
    });

    testWidgets('navigate to login page when unauthorized', (tester) async {
      when(() => router.replace(any())).thenAnswer((_) async => null);
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.unauthorized());

      // load page
      await tester.pumpWidget(testSubject);

      verify(() => router.replace(any())).called(1);
    });

    testWidgets('display error when fetch fails', (tester) async {
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.error('mocked error'));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      expect(find.text('mocked error'), findsOneWidget);
    });

    testWidgets('navigate to details page when book is clicked',
        (tester) async {
      final books = [
        Book(id: '1', title: 'test 1', author: 'test'),
        Book(id: '2', title: 'test 2', author: 'test'),
      ];
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success(books));
      when(() => router.push(any())).thenAnswer((_) async => null);

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      await tester.tap(find.text('test 1'));
      await tester.pumpAndSettle();

      verify(() => router.push(any())).called(1);
    });
  });

  group('add book', () {
    testWidgets('new book is displayed after added successfully',
        (tester) async {
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success([]));
      when(() => addBookUseCase.addBook(
              title: 'test 1', author: 'test', genre: 'genre', rating: 3))
          .thenAnswer((_) async => AddBookResponse.success(
                Book(id: '1', title: 'test 1', author: 'test'),
              ));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();
      // add book
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(AddBookDialog.titleKey), 'test 1');
      await tester.enterText(find.byKey(AddBookDialog.authorKey), 'test');
      await tester.enterText(find.byKey(AddBookDialog.genreKey), 'genre');
      await tester.enterText(find.byKey(AddBookDialog.ratingKey), '3');
      await tester.tap(find.byKey(AddBookDialog.submitKey));

      expect(find.text('test 1'), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
      expect(find.text('genre'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('navigate to login page when unauthorized', (tester) async {
      when(() => router.replace(any())).thenAnswer((_) async => null);
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success([]));
      when(() => addBookUseCase.addBook(
          title: 'test 1',
          author: 'test',
          genre: 'genre',
          rating: 3)).thenAnswer((_) async => AddBookResponse.unauthorized());

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();

      // add book
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(AddBookDialog.titleKey), 'test 1');
      await tester.enterText(find.byKey(AddBookDialog.authorKey), 'test');
      await tester.enterText(find.byKey(AddBookDialog.genreKey), 'genre');
      await tester.enterText(find.byKey(AddBookDialog.ratingKey), '3');
      await tester.tap(find.byKey(AddBookDialog.submitKey));

      verify(() => router.replace(any())).called(1);
    });

    testWidgets('display conflict message when add book results in conflict',
        (tester) async {
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success([]));
      when(() => addBookUseCase.addBook(
          title: 'test 1',
          author: 'test',
          genre: 'genre',
          rating: 3)).thenAnswer((_) async => AddBookResponse.conflict());

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();
      // add book
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(AddBookDialog.titleKey), 'test 1');
      await tester.enterText(find.byKey(AddBookDialog.authorKey), 'test');
      await tester.enterText(find.byKey(AddBookDialog.genreKey), 'genre');
      await tester.enterText(find.byKey(AddBookDialog.ratingKey), '3');
      await tester.tap(find.byKey(AddBookDialog.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('This Book already exists'), findsOneWidget);
    });

    testWidgets('display error message when add book results in error',
        (tester) async {
      when(() => getBooksUseCase.getBooks())
          .thenAnswer((_) async => GetBooksResponse.success([]));
      when(() => addBookUseCase.addBook(
              title: 'test 1', author: 'test', genre: 'genre', rating: 3))
          .thenAnswer((_) async => AddBookResponse.error('Mocked error'));

      // load page
      await tester.pumpWidget(testSubject);
      await tester.pumpAndSettle();
      // add book
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(AddBookDialog.titleKey), 'test 1');
      await tester.enterText(find.byKey(AddBookDialog.authorKey), 'test');
      await tester.enterText(find.byKey(AddBookDialog.genreKey), 'genre');
      await tester.enterText(find.byKey(AddBookDialog.ratingKey), '3');
      await tester.tap(find.byKey(AddBookDialog.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('Mocked error'), findsOneWidget);
    });
  });
}
