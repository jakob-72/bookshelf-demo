// Package models contains the domain models of the application
package models

// Book represents a book in the application and database
type Book struct {
	ID     string `json:"id" gorm:"primarykey"`
	UserID string `json:"userId"`
	Title  string `json:"title"`
	Author string `json:"author"`
	Genre  string `json:"genre"`
	Read   bool   `json:"read"`
	Rating int    `json:"rating,omitempty"`
}
