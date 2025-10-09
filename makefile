up:
	sudo mkdir -p ./data/{mariadb,wordpress,nginx}
	@./srcs/requirements/tools/setup.sh
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

clean:
	rm -rf ./data
	docker compose -f ./srcs/docker-compose.yml down -v

restart:
	docker compose -f ./srcs/docker-compose.yml down && docker compose -f ./srcs/docker-compose.yaml up -d --build

.PHONY: up down clean logs restart
.DEFAULT_GOAL := up
