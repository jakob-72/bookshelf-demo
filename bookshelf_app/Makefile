.PHONY: default
default: help

.PHONY: clean
clean: ## Clean the project
	@flutter clean

.PHONY: format
format: ## Format the code
	@dart format .

.PHONY: analyze
analyze: ## Analyze the code
	@dart analyze .

.PHONY: test
test: ## Run tests
	@flutter test

.PHONY: run
run: ## Run the application
	@flutter pub get
	@dart run build_runner build --delete-conflicting-outputs
	@flutter run

.PHONY: help
help: ## Shows help message
	@echo 'Usage: make <target>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^([a-z+A-Z_-]+)(\\:a-z+A-Z_-]+)?:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ''
