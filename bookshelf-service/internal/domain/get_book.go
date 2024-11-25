package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/models"
	"strings"
)

type GetBookUseCase interface {
	GetBook(userId, bookId string) (models.Book, error)
}

type getBookUseCase struct {
	repository database.Repository
}

func (useCase *getBookUseCase) GetBook(userId, bookId string) (models.Book, error) {
	book, err := useCase.repository.GetBookByID(userId, bookId)
	if err != nil {
		if strings.Contains(err.Error(), "not found") {
			return models.Book{}, &UseCaseError{
				Code:    NotFound,
				Message: err.Error(),
			}
		}
		return models.Book{}, &UseCaseError{
			Code:    InternalError,
			Message: err.Error(),
		}
	}

	return book, nil
}

func NewGetBookUseCase(repository database.Repository) GetBookUseCase {
	return &getBookUseCase{repository}
}
