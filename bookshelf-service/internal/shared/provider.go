// Package shared contains resources that are shared across the application
package shared

import "bookshelf-service/internal/domain"

// Provider is a struct that contains all the use cases that are required by the application
type Provider struct {
	GetBooks   domain.GetBooksUseCase
	CreateBook domain.CreateBookUseCase
	UpdateBook domain.UpdateBookUseCase
	DeleteBook domain.DeleteBookUseCase
}
