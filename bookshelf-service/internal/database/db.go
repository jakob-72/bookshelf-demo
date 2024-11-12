// Package database contains the database implementation (SQLite in this demo)
package database

import (
	"bookshelf-service/internal/domain/models"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log/slog"
)

const dbName = "books.db"

// InitDB initializes the database and creates the table if it does not exist
func InitDB() error {
	db, err := GetConnection()
	if err != nil {
		return err
	}

	return db.AutoMigrate(&models.Book{})
}

// GetConnection is a convenience function to get a connection to the database
func GetConnection() (*gorm.DB, error) {
	db, err := gorm.Open(sqlite.Open(dbName), &gorm.Config{})
	if err != nil {
		slog.Error("failed to connect to database", "error", err)
		return nil, err
	}
	return db, nil
}
