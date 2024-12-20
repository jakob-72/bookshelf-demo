# Bookshelf Demo

A simple demo application that demonstrates how to build a distributed full-stack application with Flutter, Go and Rust.

## Architecture

```mermaid
graph TD
    A[bookshelf_app] -->|requests| B[bookshelf-service]
    A -->|requests| C[auth-service]
    C -->|uses| db1[(IAM)]
    B -->|uses| db2[(Books DB)]
```

The `bookshelf_app` is the client-facing Flutter application that provides a UI for users to authenticate and
manage their books. The `bookshelf-service` is a Go Microservice that provides the business logic for managing books.
The `auth-service` is a Rust Microservice that connects to IAM providers and provides user authentication.

## Development

### Prerequisites

- [Go](https://golang.org/dl/) must be installed
- [Rust](https://www.rust-lang.org/tools/install) must be installed
- [Flutter](https://flutter.dev/docs/get-started/install) must be installed

### Running the application

1. Start the `auth-service`: `make auth`
2. Start the `bookshelf-service`: `make books`
3. Start the `bookshelf_app`: `make app`
