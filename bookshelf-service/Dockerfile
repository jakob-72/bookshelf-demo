# Start from the official Golang image for building
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install build dependencies for CGO
RUN apk add --no-cache gcc musl-dev

# Copy go mod files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
RUN CGO_ENABLED=1 go build -o bookshelf-service .

# Use a minimal image for running
FROM alpine:latest

# Set environment variables
ENV JWT_SECRET=secret

WORKDIR /app

# Copy the built binary from builder
COPY --from=builder /app/bookshelf-service .

# Expose port 8090
EXPOSE 8090

# Run the webserver
CMD ["./bookshelf-service"]
