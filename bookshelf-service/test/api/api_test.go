package api

import (
	"bookshelf-service/internal/api"
	"bookshelf-service/internal/domain"
	"bookshelf-service/internal/domain/dto"
	"bookshelf-service/internal/domain/models"
	"bookshelf-service/internal/shared"
	"github.com/stretchr/testify/assert"
	"io"
	"net/http"
	"strings"
	"testing"
)

const JwtSecret = "secret"
const JwtToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJlMjcyOTFjNC0xODhmLTRhY2EtYWE1Zi1kYzFkZmJmZWRmNzQiLCJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MzE0MDI3MDksImV4cCI6MTg4NjIzMTUwOX0.SDQnskZmG56Tq3Ysyw08TZXkNBpTrPsb1mPexRwRoDI"

func TestHealthEndpoint(t *testing.T) {
	provider := shared.Provider{}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/health", nil)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusOK, res.StatusCode)
	assert.Equal(t, http.StatusOK, res.StatusCode)
	assert.Equal(t, "OK", readResponseBody(res))
}

// ### GetBooks

func TestGetBooksEndpointSuccessfully(t *testing.T) {
	provider := shared.Provider{
		GetBooks: &MockedGetBooksUseCase{GetBooksFn: func(userId string, filter map[string]string) ([]models.Book, error) {
			return []models.Book{{
				ID:     "1",
				UserID: "1",
				Title:  "Test",
				Author: "Test",
				Genre:  "Test",
				Read:   false,
				Rating: 0,
			}}, nil
		}},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusOK, res.StatusCode)
	assert.JSONEq(t, `[{"id":"1","title":"Test","author":"Test","genre":"Test","read":false}]`, readResponseBody(res))
}

func TestGetBooksEndpointUnauthorized(t *testing.T) {
	provider := shared.Provider{}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books", nil)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnauthorized, res.StatusCode)
	assert.Equal(t, "missing or malformed JWT", readResponseBody(res))
}

func TestGetBooksEndpointWithInternalError(t *testing.T) {
	provider := shared.Provider{
		GetBooks: &MockedGetBooksUseCase{GetBooksFn: func(userId string, filter map[string]string) ([]models.Book, error) {
			return nil, &domain.UseCaseError{Code: domain.InternalError, Message: "internal error"}
		}},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusInternalServerError, res.StatusCode)
	assert.Equal(t, "internal error", readResponseBody(res))
}

// ### GetBook

func TestGetBookEndpointSuccessfully(t *testing.T) {
	provider := shared.Provider{
		GetBook: &MockedGetBookUseCase{GetBookFn: func(userId string, bookId string) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  "Test",
				Author: "Test",
				Genre:  "Test",
				Read:   true,
				Rating: 5,
			}, nil
		}},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books/1", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusOK, res.StatusCode)
	assert.JSONEq(t, `{"id":"1","title":"Test","author":"Test","genre":"Test","read":true,"rating":5}`, readResponseBody(res))
}
func TestGetBookEndpointUnauthorized(t *testing.T) {
	provider := shared.Provider{}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books/1", nil)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnauthorized, res.StatusCode)
	assert.Equal(t, "missing or malformed JWT", readResponseBody(res))
}
func TestGetBookEndpointNotFound(t *testing.T) {
	provider := shared.Provider{
		GetBook: &MockedGetBookUseCase{GetBookFn: func(userId string, bookId string) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.NotFound, Message: "book not found"}
		}},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books/1", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusNotFound, res.StatusCode)
	assert.Equal(t, "book not found", readResponseBody(res))
}
func TestGetBookEndpointWithInternalError(t *testing.T) {
	provider := shared.Provider{
		GetBook: &MockedGetBookUseCase{GetBookFn: func(userId string, bookId string) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.InternalError, Message: "internal error"}
		}},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("GET", "/books/1", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusInternalServerError, res.StatusCode)
	assert.Equal(t, "internal error", readResponseBody(res))
}

// ### CreateBook

func TestCreateBookSuccessfully(t *testing.T) {
	provider := shared.Provider{
		CreateBook: &MockedCreateBookUseCase{CreateBookFn: func(userId string, book dto.CreateBookRequest) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  "Test",
				Author: "Test",
				Genre:  "Test",
				Read:   false,
				Rating: 0,
			}, nil
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("POST", "/books", strings.NewReader(`{"title":"Test","author":"Test","genre":"Test"}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusCreated, res.StatusCode)
	assert.JSONEq(t, `{"id":"1","title":"Test","author":"Test","genre":"Test","read":false}`, readResponseBody(res))
}

func TestCreateBookUnauthorized(t *testing.T) {
	provider := shared.Provider{}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("POST", "/books", strings.NewReader(`{"title":"Test","author":"Test","genre":"Test"}`))
	req.Header.Add("Content-Type", "application/json")
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnauthorized, res.StatusCode)
	assert.Equal(t, "missing or malformed JWT", readResponseBody(res))
}

func TestCreateBookWithMalformedData(t *testing.T) {
	provider := shared.Provider{
		CreateBook: &MockedCreateBookUseCase{CreateBookFn: func(userId string, book dto.CreateBookRequest) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  "Test",
				Author: "Test",
				Genre:  "Test",
				Read:   false,
				Rating: 0,
			}, nil
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("POST", "/books", strings.NewReader(`{">>`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusBadRequest, res.StatusCode)
	assert.Equal(t, "unexpected end of JSON input", readResponseBody(res))
}

func TestCreateBookWithInvalidData(t *testing.T) {
	provider := shared.Provider{
		CreateBook: &MockedCreateBookUseCase{CreateBookFn: func(userId string, book dto.CreateBookRequest) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.InvalidData, Message: "author is required"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("POST", "/books", strings.NewReader(`{"title":"Test"}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnprocessableEntity, res.StatusCode)
	assert.Equal(t, "author is required", readResponseBody(res))
}

func TestCreateBookWithInternalError(t *testing.T) {
	provider := shared.Provider{
		CreateBook: &MockedCreateBookUseCase{CreateBookFn: func(userId string, book dto.CreateBookRequest) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.InternalError, Message: "internal error"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("POST", "/books", strings.NewReader(`{"title":"Test","author":"Test"}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusInternalServerError, res.StatusCode)
	assert.Equal(t, "internal error", readResponseBody(res))
}

// ### UpdateBook

func TestUpdateBookSuccessfully(t *testing.T) {
	provider := shared.Provider{
		UpdateBook: &MockedUpdateBookUseCase{UpdateBookFn: func(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  "Test",
				Author: "Test",
				Genre:  "Test",
				Read:   true,
				Rating: 5,
			}, nil
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("PUT", "/books/1", strings.NewReader(`{"read":true,"rating":5}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusOK, res.StatusCode)
	assert.JSONEq(t, `{"id":"1","title":"Test","author":"Test","genre":"Test","read":true,"rating":5}`, readResponseBody(res))
}

func TestUpdateBookUnauthorized(t *testing.T) {
	provider := shared.Provider{}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("PUT", "/books/1", strings.NewReader(`{"read":true,"rating":5}`))
	req.Header.Add("Content-Type", "application/json")
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnauthorized, res.StatusCode)
	assert.Equal(t, "missing or malformed JWT", readResponseBody(res))
}

func TestUpdateBookWithMalformedData(t *testing.T) {
	provider := shared.Provider{
		UpdateBook: &MockedUpdateBookUseCase{UpdateBookFn: func(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error) {
			return models.Book{
				ID:     "1",
				UserID: "1",
				Title:  "Test",
				Author: "Test",
				Genre:  "Test",
				Read:   true,
				Rating: 5,
			}, nil
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("PUT", "/books/1", strings.NewReader(`>>...`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusBadRequest, res.StatusCode)
	assert.Equal(t, "invalid character '>' looking for beginning of value", readResponseBody(res))
}

func TestUpdateBookWithInvalidData(t *testing.T) {
	provider := shared.Provider{
		UpdateBook: &MockedUpdateBookUseCase{UpdateBookFn: func(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.InvalidData, Message: "rating must be between 1 and 5"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("PUT", "/books/1", strings.NewReader(`{"rating":8}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnprocessableEntity, res.StatusCode)
	assert.Equal(t, "rating must be between 1 and 5", readResponseBody(res))
}

func TestUpdateBookNotFound(t *testing.T) {
	provider := shared.Provider{
		UpdateBook: &MockedUpdateBookUseCase{UpdateBookFn: func(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.NotFound, Message: "book not found"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("PUT", "/books/1", strings.NewReader(`{"read":true,"rating":5}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusNotFound, res.StatusCode)
	assert.Equal(t, "book not found", readResponseBody(res))
}

func TestUpdateBookWithInternalError(t *testing.T) {
	provider := shared.Provider{
		UpdateBook: &MockedUpdateBookUseCase{UpdateBookFn: func(userId string, bookId string, book dto.UpdateBookRequest) (models.Book, error) {
			return models.Book{}, &domain.UseCaseError{Code: domain.InternalError, Message: "internal error"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("PUT", "/books/1", strings.NewReader(`{"read":true,"rating":5}`))
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusInternalServerError, res.StatusCode)
	assert.Equal(t, "internal error", readResponseBody(res))
}

// ### DeleteBook

func TestDeleteBookSuccessfully(t *testing.T) {
	provider := shared.Provider{
		DeleteBook: &MockedDeleteBookUseCase{DeleteBookFn: func(userId string, bookId string) error {
			return nil
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("DELETE", "/books/1", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusNoContent, res.StatusCode)
	assert.Equal(t, "", readResponseBody(res))
}

func TestDeleteBookUnauthorized(t *testing.T) {
	provider := shared.Provider{}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("DELETE", "/books/1", nil)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusUnauthorized, res.StatusCode)
	assert.Equal(t, "missing or malformed JWT", readResponseBody(res))
}

func TestDeleteBookNotFound(t *testing.T) {
	provider := shared.Provider{
		DeleteBook: &MockedDeleteBookUseCase{DeleteBookFn: func(userId string, bookId string) error {
			return &domain.UseCaseError{Code: domain.NotFound, Message: "book not found"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("DELETE", "/books/1", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusNotFound, res.StatusCode)
	assert.Equal(t, "book not found", readResponseBody(res))
}

func TestDeleteBookWithInternalError(t *testing.T) {
	provider := shared.Provider{
		DeleteBook: &MockedDeleteBookUseCase{DeleteBookFn: func(userId string, bookId string) error {
			return &domain.UseCaseError{Code: domain.InternalError, Message: "internal error"}
		},
		},
	}
	app := api.Initialize(provider, JwtSecret)

	req, _ := http.NewRequest("DELETE", "/books/1", nil)
	req.Header.Add("Authorization", "Bearer "+JwtToken)
	res, err := app.Test(req)

	assert.NoError(t, err)
	assert.Equal(t, http.StatusInternalServerError, res.StatusCode)
	assert.Equal(t, "internal error", readResponseBody(res))
}

func readResponseBody(res *http.Response) string {
	buf := new(strings.Builder)
	_, _ = io.Copy(buf, res.Body)
	return buf.String()
}
