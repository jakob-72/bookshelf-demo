// Package domain contains the business logic of the application
package domain

const (
	InternalError = iota
	NotFound
	AlreadyExists
	InvalidData
)

// UseCaseError is a custom error type that represents errors that occur in the domain layer while operating the database
type UseCaseError struct {
	Code    int
	Message string
}

func (e *UseCaseError) Error() string {
	return e.Message
}
