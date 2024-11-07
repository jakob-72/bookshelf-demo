# Auth-Service

A simple authentication service written in Rust using Actix-web.
In our Demo, this service is used to register and authenticate users.

This service features the following endpoints:

- `POST /register` - Register a new user. For Demo purposes,
  there is no Role-based access control, but the service can be easily extended to include it.
- `POST /login` - Login a user and return a JWT token when the credentials are correct.
- `GET /logout/{userId}` - For demo purposes, this endpoint does nothing. In a real-world scenario, this endpoint would
  invalidate the JWT token.

## IAM

The service uses a simple in-memory database to store user information for demonstration.
Since the IAM is a freely implementable trait, it can be easily swapped out for a real database,
or implemented as connector to a third-party IAM service like Keycloak, AWS Cognito etc. without changing the rest of
the service.

## Development

Run `make run` to start the service locally on port 8091.

Run `make` or `make help` to see all available commands.

## About Deployment

When the in-memory store is swapped out, to make it stateless and to enable horizontal scaling, this service could be a
good candidate to run as a serverless function on e.g. AWS Lambda or Google Cloud Functions.

It could also be deployed as a containerized microservice using e.g. Kubernetes.
