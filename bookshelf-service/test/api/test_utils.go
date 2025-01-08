package api

import (
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
)

// ### GetBooks

type MockedGetBooksUseCase struct {
	GetBooksFn func(userId string, search string) ([]models.Book, error)
}

func (m *MockedGetBooksUseCase) GetBooks(userId string, search string) ([]models.Book, error) {
	return m.GetBooksFn(userId, search)
}

// ### GetBook

type MockedGetBookUseCase struct {
	GetBookFn func(userId string, bookId string) (models.Book, error)
}

func (m *MockedGetBookUseCase) GetBook(userId string, bookId string) (models.Book, error) {
	return m.GetBookFn(userId, bookId)
}

// ### CreateBook

type MockedCreateBookUseCase struct {
	CreateBookFn func(userId string, book dto.CreateBookRequest) (models.Book, error)
}

func (m *MockedCreateBookUseCase) CreateBook(userId string, book dto.CreateBookRequest) (models.Book, error) {
	return m.CreateBookFn(userId, book)
}

// ### UpdateBook

type MockedUpdateBookUseCase struct {
	UpdateBookFn func(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error)
}

func (m *MockedUpdateBookUseCase) UpdateBook(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error) {
	return m.UpdateBookFn(userId, bookId, book)
}

// ### DeleteBook

type MockedDeleteBookUseCase struct {
	DeleteBookFn func(userId string, bookId string) error
}

func (m *MockedDeleteBookUseCase) DeleteBook(userId string, bookId string) error {
	return m.DeleteBookFn(userId, bookId)
}
