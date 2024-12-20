# bookshelf_app

Frontend/App for the bookshelf demo. This app is a simple frontend that allows users to manage their books.
It is written in flutter and can be built for Android, iOS, and web.

This app features the following pages/screens:

- `StartPage`: A short-lived splash screen that checks if the user is authenticated.
- `LoginPage`: A simple login screen that allows users to authenticate with the auth-service.
- `BookOverviewPage`: The main screen that displays all books for the authenticated user and allows the user to add a
  new book.
- `BookDetailPage`: A screen that displays the details of a single book and allows the user to edit or delete it.

## Development

To run the app locally, you need to have Flutter installed (https://flutter.dev/docs/get-started/install).

Then you can execute `make run` to start the app on your desired platform.

Run `make` or `make help` to see all available commands.

## About Deployment

This app can be built for Android, iOS, and web.
It is designed to be used with the bookshelf-service and auth-service and requires correct configuration of the
base URLs.

As a web-frontend it can be deployed as a static site on a CDN or as a single-page application on a web server.
For mobile platforms, it can be released via the respective app stores.
