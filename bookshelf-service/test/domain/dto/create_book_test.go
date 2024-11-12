package dto

import (
	"bookshelf-service/internal/domain/dto"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestValidDTO(t *testing.T) {
	book := dto.CreateBookRequest{
		Title:  "Test",
		Author: "Test",
		Genre:  "Test",
		Read:   true,
		Rating: 5,
	}

	err := book.Validate()

	assert.NoError(t, err)
}

func TestValidDTOWithOnlyRequiredFields(t *testing.T) {
	book := dto.CreateBookRequest{
		Title:  "Test",
		Author: "Test",
	}

	err := book.Validate()

	assert.NoError(t, err)
}

func TestDTOWithMissingRequiredField(t *testing.T) {
	book := dto.CreateBookRequest{
		Author: "",
		Genre:  "",
		Read:   false,
		Rating: 0,
	}

	err := book.Validate()

	assert.Error(t, err)
	assert.ErrorContains(t, err, "title is required")
}

func TestDTOWithInvalidRating(t *testing.T) {
	book1 := dto.CreateBookRequest{
		Title:  "Test",
		Author: "Test",
		Genre:  "Test",
		Read:   true,
		Rating: -1,
	}
	book2 := dto.CreateBookRequest{
		Title:  "Test",
		Author: "Test",
		Genre:  "Test",
		Read:   true,
		Rating: 6,
	}

	err1 := book1.Validate()
	err2 := book2.Validate()

	assert.Error(t, err1)
	assert.Error(t, err2)
	assert.ErrorContains(t, err1, "rating must be at least 1")
	assert.ErrorContains(t, err2, "rating must be at most 5")
}

func TestDTOWithExceedingTitle(t *testing.T) {
	book := dto.CreateBookRequest{
		Title: "###################################################################################################################################" +
			"######################################################################################################################################",
		Author: "Test",
	}

	err := book.Validate()

	assert.Error(t, err)
	assert.ErrorContains(t, err, "title must not exceed 255 characters")
}
