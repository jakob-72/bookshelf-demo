.PHONY: default
default: help

.PHONY: auth
auth: ## Run the auth service
	@cd auth-service && make run

.PHONY: books
books: ## Run the bookshelf service
	@cd bookshelf-service && make run

.PHONY: app
app: ## Run the app
	@cd bookshelf_app && make run

.PHONY: help
help: ## Shows help message
	@echo 'Usage: make <target>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^([a-z+A-Z_-]+)(\\:a-z+A-Z_-]+)?:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ''
