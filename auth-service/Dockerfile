# Use the official Rust image as the build environment
FROM rust:latest as builder

WORKDIR /usr/src/app

# Copy the source code
COPY . .

# Build the application in release mode
RUN cargo build --release

# Use a minimal base image for running with newer GLIBC
FROM debian:bookworm-slim

# Install required system dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JWT_SECRET=secret
ENV JWT_VALIDITY_SECONDS=3600

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/target/release/auth-service /app/auth-service

# Expose the application port
EXPOSE 8091

# Run the binary
CMD ["./auth-service"]
