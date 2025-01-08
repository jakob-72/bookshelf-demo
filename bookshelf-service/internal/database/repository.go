// Package database contains the database implementation (SQLite in this demo)
package database

import (
	"bookshelf-service/internal/domain/models"
	"fmt"
	"github.com/google/uuid"
)

// Repository is an interface that defines the methods to interact with the database
type Repository interface {
	GetBooks(userID string, search string) ([]models.Book, error)
	GetBookByID(userID, bookID string) (models.Book, error)
	GetBookByTitleAndAuthor(userID, title, author string) (models.Book, error)
	CreateBook(userID, title, author, genre string, read bool, rating int) (models.Book, error)
	UpdateBook(userID, bookID, title, author, genre string, read *bool, rating int) (models.Book, error)
	DeleteBook(userID, bookID string) error
}

type repository struct {
}

var searchableColumns = []string{"title", "author", "genre"}

// GetBooks retrieves books based on userID and search criteria
func (r *repository) GetBooks(userID string, search string) ([]models.Book, error) {
	db, err := GetConnection()
	if err != nil {
		return nil, err
	}

	var books []models.Book
	query := db.Where("user_id = ?", userID)
	if search != "" {
		wrappedSearch := "%" + search + "%"
		query = query.Where("title LIKE ? OR author LIKE ? OR genre LIKE ?", wrappedSearch, wrappedSearch, wrappedSearch)
	}
	query.Find(&books)
	return books, nil
}

// GetBookByID retrieves a book by its ID and userID
func (r *repository) GetBookByID(userID, bookID string) (models.Book, error) {
	db, err := GetConnection()
	if err != nil {
		return models.Book{}, err
	}

	var book models.Book
	db.Where("user_id = ?", userID).Where("id = ?", bookID).First(&book)
	if book.ID == "" {
		return models.Book{}, fmt.Errorf("book not found")
	}
	return book, nil
}

// GetBookByTitleAndAuthor retrieves a book by its title and author for a specific userID
func (r *repository) GetBookByTitleAndAuthor(userID, title, author string) (models.Book, error) {
	db, err := GetConnection()
	if err != nil {
		return models.Book{}, err
	}

	var book models.Book
	db.Where("user_id = ?", userID).Where("title = ?", title).Where("author = ?", author).First(&book)
	return book, nil
}

// CreateBook creates a new book for a specific userID
func (r *repository) CreateBook(userID, title, author, genre string, read bool, rating int) (models.Book, error) {
	db, err := GetConnection()
	if err != nil {
		return models.Book{}, err
	}

	book := models.Book{
		ID:     uuid.NewString(),
		UserID: userID,
		Title:  title,
		Author: author,
		Genre:  genre,
		Read:   read,
		Rating: rating,
	}

	db.Create(&book)
	return book, nil
}

// UpdateBook updates an existing book for a specific userID and bookID
func (r *repository) UpdateBook(userID, bookID, title, author, genre string, read *bool, rating int) (models.Book, error) {
	db, err := GetConnection()
	if err != nil {
		return models.Book{}, err
	}

	var existingBook models.Book
	db.Where("user_id = ?", userID).Where("id = ?", bookID).First(&existingBook)
	if existingBook.ID == "" {
		return models.Book{}, fmt.Errorf("book not found")
	}

	if title != "" {
		existingBook.Title = title
	}
	if author != "" {
		existingBook.Author = author
	}
	if genre != "" {
		existingBook.Genre = genre
	}
	if read != nil {
		existingBook.Read = *read
	}
	if rating != 0 {
		existingBook.Rating = rating
	}

	db.Save(&existingBook)
	return existingBook, nil
}

// DeleteBook deletes a book by its ID and userID
func (r *repository) DeleteBook(userID, bookID string) error {
	db, err := GetConnection()
	if err != nil {
		return err
	}

	var book models.Book
	db.Where("user_id = ?", userID).Where("id = ?", bookID).First(&book)
	if book.ID == "" {
		return fmt.Errorf("book not found")
	}

	db.Delete(&book)
	return nil
}

// NewRepository creates a new repository
func NewRepository() Repository {
	return &repository{}
}
