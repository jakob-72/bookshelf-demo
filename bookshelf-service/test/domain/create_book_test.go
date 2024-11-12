package domain

import (
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

var ValidDTO = dto.CreateBookRequest{
	Title:  "Test",
	Author: "Test",
	Genre:  "Test",
}

var InvalidDTO = dto.CreateBookRequest{
	Title:  "",
	Rating: 10,
}

func TestCreateBookSuccessfully(t *testing.T) {
	repository := &MockedRepository{
		GetBookByTitleAndAuthorFn: func(userId, title, author string) (models.Book, error) {
			return models.Book{}, nil
		},
		CreateBookFn: func(userID string, title string, author string, genre string, read bool, rating int) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  title,
				Author: author,
				Genre:  genre,
				Read:   read,
				Rating: rating,
			}, nil
		},
	}

	useCase := domain.NewCreateBookUseCase(repository)

	book, err := useCase.CreateBook("1", ValidDTO)

	assert.NoError(t, err)
	assert.Equal(t, "1", book.ID)
	assert.Equal(t, "1", book.UserID)
	assert.Equal(t, "Test", book.Title)
	assert.Equal(t, "Test", book.Author)
	assert.Equal(t, "Test", book.Genre)
	assert.False(t, book.Read)
	assert.Equal(t, 0, book.Rating)
}

func TestCreateBookWithInvalidData(t *testing.T) {
	repository := &MockedRepository{}

	useCase := domain.NewCreateBookUseCase(repository)

	_, err := useCase.CreateBook("1", InvalidDTO)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.InvalidData, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "title is required", err.(*domain.UseCaseError).Message)
}

func TestCreateBookWithExistingBook(t *testing.T) {
	repository := &MockedRepository{
		GetBookByTitleAndAuthorFn: func(userId, title, author string) (models.Book, error) {
			return models.Book{
				ID: "1",
			}, nil
		},
		CreateBookFn: func(userID string, title string, author string, genre string, read bool, rating int) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  title,
				Author: author,
				Genre:  genre,
				Read:   read,
				Rating: rating,
			}, nil
		},
	}

	useCase := domain.NewCreateBookUseCase(repository)

	_, err := useCase.CreateBook("1", ValidDTO)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.AlreadyExists, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "Book already exists", err.(*domain.UseCaseError).Message)
}

func TestCreateBookWithInternalError(t *testing.T) {
	repository := &MockedRepository{
		GetBookByTitleAndAuthorFn: func(userId, title, author string) (models.Book, error) {
			return models.Book{}, nil
		},
		CreateBookFn: func(userID string, title string, author string, genre string, read bool, rating int) (models.Book, error) {
			return models.Book{}, fmt.Errorf("error occurred while creating a book")
		},
	}

	useCase := domain.NewCreateBookUseCase(repository)

	_, err := useCase.CreateBook("1", ValidDTO)

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.InternalError, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "error occurred while creating a book", err.(*domain.UseCaseError).Message)
}
