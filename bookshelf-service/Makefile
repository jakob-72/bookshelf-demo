export JWT_SECRET=secret

.PHONY: default
default: help

.PHONY: format
format: ## Format the code
	@go fmt ./...

.PHONY: clean
clean: ## Clean up the project
	@rm -rf bin
	@rm -f books.db
	@go clean -testcache

.PHONY: test
test: ## Run the tests
	@go test ./...

.PHONY: build
build: ## Build the application
	go build -ldflags "$(GO_LDFLAGS)" -o bin/bookshelf-service main.go

.PHONY: run
run: ## Run the application
	@go run main.go

.PHONY: help
help: ## Shows this help
	@echo 'Usage: make <target>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^([a-z+A-Z_-]+)(\\:a-z+A-Z_-]+)?:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ''
