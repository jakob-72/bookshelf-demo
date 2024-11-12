// Package domain contains the business logic of the application
package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
	"strings"
)

// UpdateBookUseCase is the interface that provides the UpdateBook method
type UpdateBookUseCase interface {
	UpdateBook(userId string, bookId string, bookToUpdate dto.UpdateBookRequest) (models.Book, error)
}

type updateBookUseCase struct {
	repository database.Repository
}

func (useCase *updateBookUseCase) UpdateBook(userId string, bookId string, bookToUpdate dto.UpdateBookRequest) (models.Book, error) {
	// validate the input
	err := bookToUpdate.Validate()
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    InvalidData,
			Message: err.Error(),
		}
	}

	book, err := useCase.repository.UpdateBook(userId, bookId, bookToUpdate.Title, bookToUpdate.Author, bookToUpdate.Genre, bookToUpdate.Read, bookToUpdate.Rating)
	if err != nil {
		if strings.Contains(err.Error(), "not found") {
			return models.Book{}, &UseCaseError{
				Code:    NotFound,
				Message: "book not found",
			}
		}
		return models.Book{}, &UseCaseError{
			Code:    InternalError,
			Message: err.Error(),
		}
	}
	return book, nil
}

// NewUpdateBookUseCase creates an implementation of the UpdateBookUseCase
func NewUpdateBookUseCase(repository database.Repository) UpdateBookUseCase {
	return &updateBookUseCase{repository}
}
