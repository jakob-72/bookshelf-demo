// Package dto contains the data transfer objects of the application
package dto

// CreateBookRequest represents the data needed to add a new book
type CreateBookRequest struct {
	Title  string `json:"title" validate:"required" maxLength:"255"`
	Author string `json:"author" validate:"required" maxLength:"255"`
	Genre  string `json:"genre" maxLength:"255"`
	Read   bool   `json:"read"`
	Rating int    `json:"rating" min:"1" max:"5"`
}

// Validate validates the CreateBookRequest data
func (c CreateBookRequest) Validate() error {
	err := checkRequired(c)
	if err != nil {
		return err
	}
	return validate(c)
}
