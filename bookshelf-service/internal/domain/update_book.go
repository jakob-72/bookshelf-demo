// Package domain contains the business logic of the application
package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
)

// UpdateBookUseCase is the interface that provides the UpdateBook method
type UpdateBookUseCase interface {
	UpdateBook(userId string, bookId string, bookToUpdate dto.UpdateBookRequest) (models.Book, error)
}

type updateBookUseCase struct{}

func (useCase updateBookUseCase) UpdateBook(userId string, bookId string, bookToUpdate dto.UpdateBookRequest) (models.Book, error) {
	// validate the input
	err := bookToUpdate.Validate()
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    InvalidData,
			Message: err.Error(),
		}
	}

	// get the book from the database
	db, err := database.GetConnection()
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    ConnectionError,
			Message: err.Error(),
		}
	}

	// find the book by user-ID and book-ID
	var book models.Book
	db.Where("user_id = ?", userId).Where("id = ?", bookId).First(&book)
	if book.ID == "" {
		return models.Book{}, &UseCaseError{
			Code:    NotFound,
			Message: "book not found",
		}
	}

	// update the book in the database with non-zero values of the DTO
	if bookToUpdate.Title != "" {
		book.Title = bookToUpdate.Title
	}
	if bookToUpdate.Author != "" {
		book.Author = bookToUpdate.Author
	}
	if bookToUpdate.Genre != "" {
		book.Genre = bookToUpdate.Genre
	}
	if bookToUpdate.Read != nil {
		book.Read = *bookToUpdate.Read
	}
	if bookToUpdate.Rating != 0 {
		book.Rating = bookToUpdate.Rating
	}

	// save the updated book
	db.Save(&book)
	return book, nil
}

// NewUpdateBookUseCase creates an implementation of the UpdateBookUseCase
func NewUpdateBookUseCase() UpdateBookUseCase {
	return updateBookUseCase{}
}
