package domain

import (
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/domain/models"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGetBooksSuccessfully(t *testing.T) {
	repository := &MockedRepository{
		GetBooksFn: func(userID string, search string) ([]models.Book, error) {
			return []models.Book{
				{
					ID:     "1",
					UserID: "1",
					Title:  "Test",
					Author: "Test",
					Genre:  "Test",
					Read:   false,
					Rating: 0,
				},
			}, nil
		},
	}
	useCase := domain.NewGetBooksUseCase(repository)

	books, err := useCase.GetBooks("1", "")

	assert.NoError(t, err)
	assert.Len(t, books, 1)
}

func TestGetBooksWithError(t *testing.T) {
	repository := &MockedRepository{
		GetBooksFn: func(userID string, search string) ([]models.Book, error) {
			return nil, fmt.Errorf("error connecting to the database")
		},
	}
	useCase := domain.NewGetBooksUseCase(repository)

	_, err := useCase.GetBooks("1", "")

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.InternalError, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "error connecting to the database", err.(*domain.UseCaseError).Message)
}
