package main

import (
	"bookshelf-service/internal/api"
	"bookshelf-service/internal/database"
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/shared"
	"log/slog"
	"os"
)

const PORT = ":8090"

func main() {
	slog.SetDefault(slog.New(slog.NewTextHandler(os.Stdout, nil)))

	jwtSecret := os.Getenv("JWT_SECRET")

	if err := database.InitDB(); err != nil {
		slog.Error("failed to initialize database", "error", err)
		os.Exit(1)
	}

	repository := database.NewRepository()
	provider := shared.Provider{
		GetBooks:   domain.NewGetBooksUseCase(repository),
		CreateBook: domain.NewCreateBookUseCase(repository),
		UpdateBook: domain.NewUpdateBookUseCase(repository),
		DeleteBook: domain.NewDeleteBookUseCase(repository),
	}
	if err := api.Start(provider, PORT, jwtSecret); err != nil {
		slog.Error("failed to start server", "error", err)
		os.Exit(1)
	}
}
