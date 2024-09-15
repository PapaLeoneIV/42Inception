COMPOSE_FILE := ./srcs/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

.PHONY: build up stop remove prune

build:
	$(DOCKER_COMPOSE) build

up: build
	$(DOCKER_COMPOSE) up

stop:
	@containers=$$(docker ps -aq); \
	if [ -z "$$containers" ]; then \
		echo "No containers to stop."; \
	else \
		docker stop $$containers; \
		echo "All containers stopped successfully."; \
	fi

remove:
	@containers=$$(docker ps -aq); \
	if [ -z "$$containers" ]; then \
		echo "No containers to remove."; \
	else \
		docker rm $$containers; \
		echo "All containers removed successfully."; \
	fi

# Remove stopped containers, unused networks, and dangling images
prune:
	docker system prune -f

fclean: stop remove prune
