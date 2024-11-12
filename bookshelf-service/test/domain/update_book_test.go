package domain

import (
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

var TRUE = true

var ValidUpdateDTO = dto.UpdateBookRequest{
	Genre:  "Test",
	Read:   &TRUE,
	Rating: 4,
}

var InvalidUpdateDTO = dto.UpdateBookRequest{
	Rating: -1,
}

func TestUpdateBookSuccessfully(t *testing.T) {
	repository := &MockedRepository{
		UpdateBookFn: func(userId, bookId, title, author, genre string, read *bool, rating int) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: userId,
				Title:  title,
				Author: author,
				Genre:  genre,
				Read:   *read,
				Rating: rating,
			}, nil
		},
	}

	useCase := domain.NewUpdateBookUseCase(repository)

	book, err := useCase.UpdateBook("1", "1", ValidUpdateDTO)

	assert.NoError(t, err)
	assert.Equal(t, "1", book.ID)
	assert.Equal(t, "1", book.UserID)
	assert.Equal(t, "Test", book.Genre)
	assert.True(t, book.Read)
	assert.Equal(t, 4, book.Rating)
}

func TestUpdateBookWithInvalidData(t *testing.T) {
	repository := &MockedRepository{}

	useCase := domain.NewUpdateBookUseCase(repository)

	_, err := useCase.UpdateBook("1", "1", InvalidUpdateDTO)

	assert.Error(t, err)
	assert.Equal(t, "rating must be at least 1", err.Error())
}

func TestUpdateBookNotFound(t *testing.T) {
	repository := &MockedRepository{
		UpdateBookFn: func(userId, bookId, title, author, genre string, read *bool, rating int) (models.Book, error) {
			return models.Book{}, fmt.Errorf("book not found")
		},
	}

	useCase := domain.NewUpdateBookUseCase(repository)

	_, err := useCase.UpdateBook("1", "1", ValidUpdateDTO)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.NotFound, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "book not found", err.Error())
}

func TestUpdateBookWithError(t *testing.T) {
	repository := &MockedRepository{
		UpdateBookFn: func(userId, bookId, title, author, genre string, read *bool, rating int) (models.Book, error) {
			return models.Book{}, fmt.Errorf("internal error")
		},
	}

	useCase := domain.NewUpdateBookUseCase(repository)

	_, err := useCase.UpdateBook("1", "1", ValidUpdateDTO)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.InternalError, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "internal error", err.Error())
}
