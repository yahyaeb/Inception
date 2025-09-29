# Default: run docker compose up -d
up:
	docker compose up -d --build

# Down: stop and remove containers
down:
	docker compose down

# Clean: stop, remove containers, and delete volumes (DATA LOSS)
clean:
	docker compose down -v

# (Optional) show logs
logs:
	docker compose logs -f

# (Optional) restart stack
restart:
	docker compose down && docker compose up -d --build

# Alias: running `make` will call `make up`
.PHONY: up down clean logs restart
.DEFAULT_GOAL := up
