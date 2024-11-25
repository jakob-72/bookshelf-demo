package domain

import (
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/domain/models"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGetBookSuccessfully(t *testing.T) {
	// Arrange
	bookId := "1"
	repository := &MockedRepository{
		GetBookByIDFn: func(userId, bookID string) (models.Book, error) {
			return models.Book{ID: bookId, Title: "Test Book"}, nil
		},
	}
	useCase := domain.NewGetBookUseCase(repository)

	book, err := useCase.GetBook("1", bookId)

	assert.NoError(t, err)
	assert.Equal(t, bookId, book.ID)
	assert.Equal(t, "Test Book", book.Title)
}

func TestGetBookNotFound(t *testing.T) {
	bookId := "1"
	repository := &MockedRepository{
		GetBookByIDFn: func(userId, bookID string) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{
				Code:    domain.NotFound,
				Message: "book not found",
			}
		},
	}
	useCase := domain.NewGetBookUseCase(repository)

	_, err := useCase.GetBook("1", bookId)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.NotFound, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "book not found", err.(*domain.UseCaseError).Message)
}

func TestGetBookError(t *testing.T) {
	bookId := "1"
	repository := &MockedRepository{
		GetBookByIDFn: func(userId, bookID string) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{
				Code:    domain.InternalError,
				Message: "error connecting to the database",
			}
		},
	}
	useCase := domain.NewGetBookUseCase(repository)

	_, err := useCase.GetBook("1", bookId)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.InternalError, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "error connecting to the database", err.(*domain.UseCaseError).Message)
}
