// Package api contains the API server implementation
package api

import (
	"bookshelf-service/internal/shared"
	jwtware "github.com/gofiber/contrib/jwt"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/healthcheck"
	slogfiber "github.com/samber/slog-fiber"
	"log/slog"
)

// Provider holds the reference to a `shared.Provider` instance
var Provider shared.Provider

// Start starts the API server
func Start(provider shared.Provider, addr string, jwtSecret string) error {
	app := fiber.New()
	Provider = provider

	// Middleware
	app.Use(slogfiber.New(slog.Default()))
	app.Use(healthcheck.New(healthcheck.Config{
		LivenessEndpoint:  "/health",
		ReadinessEndpoint: "/ready",
	}))
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowMethods: "GET, POST, PUT, DELETE",
	}))
	app.Use(jwtware.New(jwtware.Config{
		SigningKey: jwtware.SigningKey{Key: []byte(jwtSecret)},
	}))

	// Routes (authenticated)
	app.Get("/books", GetBooks)
	app.Post("/books", CreateBook)
	app.Put("/books/:id", UpdateBook)

	// Start server
	return app.Listen(addr)
}
