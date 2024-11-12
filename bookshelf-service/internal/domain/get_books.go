// Package domain contains the business logic of the application
package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/models"
	"fmt"
	"slices"
)

// GetBooksUseCase is the interface that provides the GetBooks method
type GetBooksUseCase interface {
	GetBooks(userId string, filter map[string]string) ([]models.Book, error)
}

type getBooksUseCase struct{}

var filterableColumns = []string{"title", "author", "genre", "read", "rating"}

func (useCase getBooksUseCase) GetBooks(userId string, filter map[string]string) ([]models.Book, error) {
	db, err := database.GetConnection()
	if err != nil {
		return nil, &UseCaseError{
			Code:    ConnectionError,
			Message: err.Error(),
		}
	}

	var books []models.Book
	query := db.Where("user_id = ?", userId)
	for key, value := range filter {
		if slices.Contains(filterableColumns, key) {
			query = query.Where(fmt.Sprintf("%s = ?", key), value)
		}
	}
	query.Find(&books)

	return books, nil
}

// NewGetBooksUseCase creates an implementation of the GetBooksUseCase
func NewGetBooksUseCase() GetBooksUseCase {
	return getBooksUseCase{}
}
