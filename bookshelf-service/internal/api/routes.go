// Package api contains the API server implementation
package api

import (
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/domain/dto"
	"errors"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v5"
	"log/slog"
)

// GetBooks returns all books for the user - Authenticated user is required
// Success: 200 - Returns a list of books
// Error: 401 - Unauthorized
func GetBooks(c *fiber.Ctx) error {
	userId, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	useCase := Provider.GetBooks
	books, err := useCase.GetBooks(userId, c.Queries())
	if err != nil {
		return c.Status(handleError(err)).SendString(err.Error())
	}

	return c.JSON(books)
}

// CreateBook creates a new book for the user - Authenticated user is required
// Success: 201 - Returns the created book
// Error: 400 - Bad Request - Malformed request body
// Error: 401 - Unauthorized
// Error: 409 - Conflict - Book already exists
func CreateBook(c *fiber.Ctx) error {
	userId, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	var body dto.CreateBookRequest
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).SendString(err.Error())
	}

	useCase := Provider.CreateBook
	book, err := useCase.CreateBook(userId, body)
	if err != nil {
		return c.Status(handleError(err)).SendString(err.Error())
	}

	return c.Status(fiber.StatusCreated).JSON(book)
}

func readUserIdFromClaims(c *fiber.Ctx) (string, error) {
	user := c.Locals("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userId, ok := claims["sub"].(string)
	if !ok {
		slog.Error("invalid jwt claims", "claims", claims)
		return "", fmt.Errorf("invalid jwt claims")
	}
	return userId, nil
}

func handleError(err error) int {
	var databaseError *domain.UseCaseError
	switch {
	case errors.As(err, &databaseError):
		var dbe *domain.UseCaseError
		errors.As(err, &dbe)
		switch dbe.Code {
		case domain.NotFound:
			return fiber.StatusNotFound
		case domain.ConnectionError:
			return fiber.StatusInternalServerError
		case domain.AlreadyExists:
			return fiber.StatusConflict
		default:
			return fiber.StatusInternalServerError
		}
	default:
		return fiber.StatusInternalServerError
	}
}
