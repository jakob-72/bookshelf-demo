// Package domain contains the business logic of the application
package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
)

// CreateBookUseCase is the interface that provides the CreateBook method
type CreateBookUseCase interface {
	CreateBook(userId string, book dto.CreateBookRequest) (models.Book, error)
}

type createBookUseCase struct {
	repository database.Repository
}

func (useCase *createBookUseCase) CreateBook(userId string, bookToCreate dto.CreateBookRequest) (models.Book, error) {
	// validate the input
	err := bookToCreate.Validate()
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    InvalidData,
			Message: err.Error(),
		}
	}

	// check if the book already exists
	book, err := useCase.repository.GetBookByTitleAndAuthor(userId, bookToCreate.Title, bookToCreate.Author)
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    InternalError,
			Message: err.Error(),
		}
	}
	if book.ID != "" {
		return models.Book{}, &UseCaseError{
			Code:    AlreadyExists,
			Message: "Book already exists",
		}
	}

	// create the book in the database
	book, err = useCase.repository.CreateBook(userId, bookToCreate.Title, bookToCreate.Author, bookToCreate.Genre, bookToCreate.Read, bookToCreate.Rating)
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    InternalError,
			Message: err.Error(),
		}
	}
	return book, nil
}

// NewCreateBookUseCase creates an implementation of the CreateBookUseCase
func NewCreateBookUseCase(repository database.Repository) CreateBookUseCase {
	return &createBookUseCase{repository}
}
