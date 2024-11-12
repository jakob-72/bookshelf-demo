package domain

import (
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
	"github.com/google/uuid"
)

// CreateBookUseCase is the interface that provides the CreateBook method
type CreateBookUseCase interface {
	CreateBook(userId string, book dto.CreateBookRequest) (models.Book, error)
}

type createBookUseCase struct{}

func (useCase createBookUseCase) CreateBook(userId string, bookToCreate dto.CreateBookRequest) (models.Book, error) {
	// validate the input
	err := bookToCreate.Validate()
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    InvalidData,
			Message: err.Error(),
		}
	}

	// get a connection to the database
	db, err := database.GetConnection()
	if err != nil {
		return models.Book{}, &UseCaseError{
			Code:    ConnectionError,
			Message: err.Error(),
		}
	}

	// check if the book already exists
	var books []models.Book
	db.Where("user_id = ?", userId).Where("title = ?", bookToCreate.Title).Where("author = ?", bookToCreate.Author).Find(&books)
	if len(books) > 0 {
		return models.Book{}, &UseCaseError{
			Code:    AlreadyExists,
			Message: "book already exists",
		}
	}

	// create the book in the database
	book := models.Book{
		ID:     uuid.NewString(),
		UserID: userId,
		Title:  bookToCreate.Title,
		Author: bookToCreate.Author,
		Genre:  bookToCreate.Genre,
	}

	db.Create(&book)

	return book, nil
}

// NewCreateBookUseCase creates an implementation of the CreateBookUseCase
func NewCreateBookUseCase() CreateBookUseCase {
	return createBookUseCase{}
}
