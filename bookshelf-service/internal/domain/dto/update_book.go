package dto

// UpdateBookRequest represents the data needed to update a book
type UpdateBookRequest struct {
	Title  string `json:"title" maxLength:"255"`
	Author string `json:"author" maxLength:"255"`
	Genre  string `json:"genre" maxLength:"255"`
	Read   *bool  `json:"read"`
	Rating int    `json:"rating" min:"1" max:"5"`
}

// Validate validates the UpdateBookRequest data
func (c UpdateBookRequest) Validate() error {
	return validate(c)
}
