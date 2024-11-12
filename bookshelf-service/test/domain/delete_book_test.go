package domain

import (
	"bookshelf-service/internal/domain"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestDeleteBookSuccessfully(t *testing.T) {
	repository := &MockedRepository{
		DeleteBookFn: func(userId, bookId string) error {
			return nil
		},
	}

	useCase := domain.NewDeleteBookUseCase(repository)

	err := useCase.DeleteBook("1", "1")

	assert.NoError(t, err)
}

func TestDeleteBookNotFound(t *testing.T) {
	repository := &MockedRepository{
		DeleteBookFn: func(userId, bookId string) error {
			return fmt.Errorf("book not found")
		},
	}

	useCase := domain.NewDeleteBookUseCase(repository)

	err := useCase.DeleteBook("1", "1")

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.NotFound, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "book not found", err.Error())
}

func TestDeleteBookWithError(t *testing.T) {
	repository := &MockedRepository{
		DeleteBookFn: func(userId, bookId string) error {
			return fmt.Errorf("internal error")
		},
	}

	useCase := domain.NewDeleteBookUseCase(repository)

	err := useCase.DeleteBook("1", "1")

	assert.Error(t, err)
	assert.IsType(t, &domain.UseCaseError{}, err)
	assert.Equal(t, domain.InternalError, err.(*domain.UseCaseError).Code)
	assert.Equal(t, "internal error", err.Error())
}
