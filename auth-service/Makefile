export JWT_SECRET=secret
export JWT_VALIDITY_SECONDS=3600

.PHONY: default
default: help

.PHONY: check
check: ## Check the code for errors
	@cargo check

.PHONY: format
format: ## Format the code
	@cargo fmt

.PHONY: clean
clean: ## Clean the project
	@cargo clean

.PHONY: test
test: ## Run the tests
	@cargo test

.PHONY: lint
lint: ## Run the linter
	@cargo clippy

.PHONY: build
build: ## Build the application in release mode
	@cargo build --release

.PHONY: run
run: ## Run the application
	@cargo run

.PHONY: help
help: ## Shows this help
	@echo 'Usage: make <target>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^([a-z+A-Z_-]+)(\\:a-z+A-Z_-]+)?:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ''
