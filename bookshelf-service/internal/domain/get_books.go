// Package domain contains the business logic of the application
package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/models"
)

// GetBooksUseCase is the interface that provides the GetBooks method
type GetBooksUseCase interface {
	GetBooks(userId string, filter map[string]string) ([]models.Book, error)
}

type getBooksUseCase struct {
	repository database.Repository
}

func (useCase *getBooksUseCase) GetBooks(userId string, filter map[string]string) ([]models.Book, error) {
	books, err := useCase.repository.GetBook(userId, filter)
	if err != nil {
		return nil, &UseCaseError{
			Code:    InternalError,
			Message: err.Error(),
		}
	}

	return books, nil
}

// NewGetBooksUseCase creates an implementation of the GetBooksUseCase
func NewGetBooksUseCase(repository database.Repository) GetBooksUseCase {
	return &getBooksUseCase{repository}
}
