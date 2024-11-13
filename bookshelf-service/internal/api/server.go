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

// Initialize initializes the API server with the given provider and JWT secret
// Returns a new Fiber app instance
func Initialize(provider shared.Provider, jwtSecret string) *fiber.App {
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
		AllowMethods: "GET, POST, PUT, DELETE, OPTIONS",
	}))
	app.Use(jwtware.New(jwtware.Config{
		SigningKey: jwtware.SigningKey{Key: []byte(jwtSecret)},
		ErrorHandler: func(ctx *fiber.Ctx, err error) error {
			return ctx.Status(fiber.StatusUnauthorized).SendString(err.Error())
		},
	}))

	// Routes (authenticated)
	app.Get("/check", CheckToken)
	app.Get("/books", GetBooks)
	app.Post("/books", CreateBook)
	app.Put("/books/:id", UpdateBook)
	app.Delete("/books/:id", DeleteBook)

	return app
}

// Start starts the API server
func Start(app *fiber.App, addr string) error {
	return app.Listen(addr)
}
