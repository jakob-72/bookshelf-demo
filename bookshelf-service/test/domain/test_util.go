package domain

import "bookshelf-service/internal/domain/models"

type MockedRepository struct {
	GetBooksFn                func(userId string, filter map[string]string) ([]models.Book, error)
	GetBookByIDFn             func(userId, bookID string) (models.Book, error)
	GetBookByTitleAndAuthorFn func(userId, title, author string) (models.Book, error)
	CreateBookFn              func(userId, title, author, genre string, read bool, rating int) (models.Book, error)
	UpdateBookFn              func(userId, bookID, title, author, genre string, read *bool, rating int) (models.Book, error)
	DeleteBookFn              func(userId, bookID string) error
}

func (m *MockedRepository) GetBooks(userId string, filter map[string]string) ([]models.Book, error) {
	return m.GetBooksFn(userId, filter)
}

func (m *MockedRepository) GetBookByID(userId, bookID string) (models.Book, error) {
	return m.GetBookByIDFn(userId, bookID)
}

func (m *MockedRepository) GetBookByTitleAndAuthor(userId, title, author string) (models.Book, error) {
	return m.GetBookByTitleAndAuthorFn(userId, title, author)
}

func (m *MockedRepository) CreateBook(userId, title, author, genre string, read bool, rating int) (models.Book, error) {
	return m.CreateBookFn(userId, title, author, genre, read, rating)
}

func (m *MockedRepository) UpdateBook(userId, bookID, title, author, genre string, read *bool, rating int) (models.Book, error) {
	return m.UpdateBookFn(userId, bookID, title, author, genre, read, rating)
}

func (m *MockedRepository) DeleteBook(userId, bookID string) error {
	return m.DeleteBookFn(userId, bookID)
}
