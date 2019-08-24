.PHONY: dependencies
dependencies:
	docker-compose run --rm api bash -c "cd banking_umbrella && mix deps.get --force"

.PHONY: lint-elixir
lint-elixir:
	docker-compose run --rm api bash -c "cd banking_umbrella && mix credo"

.PHONY: migrate
migrate:
	docker-compose run --rm api bash -c "cd banking_umbrella && mix ecto.migrate"

.PHONY: run-dev
run-dev:
	docker-compose up