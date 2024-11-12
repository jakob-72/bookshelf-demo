// Package domain contains the business logic of the application
package domain

import (
	"bookshelf-service/internal/database"
	"strings"
)

// DeleteBookUseCase is an interface that defines the use case for deleting a book
type DeleteBookUseCase interface {
	DeleteBook(userId, bookId string) error
}

type deleteBookUseCase struct {
	repository database.Repository
}

func (u *deleteBookUseCase) DeleteBook(userId, bookId string) error {
	err := u.repository.DeleteBook(userId, bookId)
	if err != nil {
		if strings.Contains(err.Error(), "not found") {
			return &UseCaseError{
				Code:    NotFound,
				Message: "book not found",
			}
		}
		return &UseCaseError{
			Code:    InternalError,
			Message: err.Error(),
		}
	}

	return nil
}

// NewDeleteBookUseCase creates a new DeleteBookUseCase
func NewDeleteBookUseCase(repository database.Repository) DeleteBookUseCase {
	return &deleteBookUseCase{
		repository: repository,
	}
}
