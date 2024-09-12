# Define variables
COMPOSE_FILE := ./srcs/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

# Targets
.PHONY: build up stop remove prune

# Build Docker images
build:
	$(DOCKER_COMPOSE) build

# Start Docker services in the background
up: build
	$(DOCKER_COMPOSE) up -d

# Stop all running Docker containers
stop:
	@containers=$$(docker ps -aq); \
	if [ -z "$$containers" ]; then \
		echo "No containers to stop."; \
	else \
		docker stop $$containers; \
		echo "All containers stopped successfully."; \
	fi

# Remove all Docker containers
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
