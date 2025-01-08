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

// CheckToken checks the validity of the JWT token
// Success: 200 - Token is valid for this service
// Error: 401 - Unauthorized
func CheckToken(c *fiber.Ctx) error {
	_, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}
	return c.SendStatus(fiber.StatusOK)
}

// GetBooks returns all books for the user - Authenticated user is required
// Query parameters:
// search: string - Search for books by title, author or genre
// Success: 200 - Returns a list of books
// Error: 401 - Unauthorized
func GetBooks(c *fiber.Ctx) error {
	userId, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	useCase := Provider.GetBooks
	books, err := useCase.GetBooks(userId, c.Query("search"))
	if err != nil {
		return c.Status(handleError(err)).SendString(err.Error())
	}

	return c.JSON(books)
}

// GetBook returns a book for the user - Authenticated user is required
// Success: 200 - Returns the book
// Error: 401 - Unauthorized
// Error: 404 - Not Found - Book not found
func GetBook(c *fiber.Ctx) error {
	userId, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	bookId := c.Params("id")
	useCase := Provider.GetBook
	book, err := useCase.GetBook(userId, bookId)
	if err != nil {
		return c.Status(handleError(err)).SendString(err.Error())
	}

	return c.JSON(book)
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

// UpdateBook updates a book for the user - Authenticated user is required
// Success: 200 - Returns the updated book
// Error: 400 - Bad Request - Malformed request body
// Error: 401 - Unauthorized
// Error: 404 - Not Found - Book not found
func UpdateBook(c *fiber.Ctx) error {
	userId, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	bookId := c.Params("id")
	var body dto.UpdateBookRequest
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).SendString(err.Error())
	}

	useCase := Provider.UpdateBook
	book, err := useCase.UpdateBook(userId, bookId, body)
	if err != nil {
		return c.Status(handleError(err)).SendString(err.Error())
	}

	return c.JSON(book)
}

// DeleteBook deletes a book for the user - Authenticated user is required
// Success: 204 - No Content
// Error: 401 - Unauthorized
// Error: 404 - Not Found - Book not found
func DeleteBook(c *fiber.Ctx) error {
	userId, err := readUserIdFromClaims(c)
	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	bookId := c.Params("id")
	useCase := Provider.DeleteBook
	err = useCase.DeleteBook(userId, bookId)
	if err != nil {
		return c.Status(handleError(err)).SendString(err.Error())
	}

	return c.SendStatus(fiber.StatusNoContent)
}

// Preflight is a handler for preflight requests
// Success: 200 - OK
func Preflight(c *fiber.Ctx) error {
	return c.SendStatus(fiber.StatusOK)
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
		case domain.InternalError:
			return fiber.StatusInternalServerError
		case domain.AlreadyExists:
			return fiber.StatusConflict
		case domain.InvalidData:
			return fiber.StatusUnprocessableEntity
		default:
			return fiber.StatusInternalServerError
		}
	default:
		return fiber.StatusInternalServerError
	}
}
