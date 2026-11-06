
-include .env
export

PODMAN_COMPOSE	=	podman-compose
DOCKER_COMPOSE	=	docker-compose 
RUNTIME_PODMAN	=	podman
RUNTIME_DOCKER	=	docker 
SERVICE	?= db-central
FILE ?= ./sql/crear.sql

.PHONY: podman-up docker-up podman-down docker-down podman-stats docker-stats

podman-up: 
	@echo "==> Iniciando contenedores.."
	$(PODMAN_COMPOSE) up -d --force-recreate
	@echo "==> Incializacion completa!"

docker-up:
	@echo "==> Iniciando contenedores.."
	$(DOCKER_COMPOSE) up -d --force-recreate
	@echo "==> Inicializacion completa!"

podman-down:
	@echo "Deteniendo contenedores..."
	$(PODMAN_COMPOSE) down
	@echo "==> Hecho!"

docker-down:
	@ehco "Deteniendo contenedores"
	$(DOCKER_COMPOSE) down 
	@echo "==> Hecho!"

docker-stats:
	$(RUNTIME_DOCKER) stats $(SERVICE) --no-stream

podman-stats:
	@if $(RUNTIME_PODMAN) ps -q -f name=$(SERVICE) | grep -q . ; then \
		$(RUNTIME_PODMAN) stats $(SERVICE) --no-stream; \
	else \
		echo "Contenedo $(SERVICE) no esta en ejecucion!"; \
	fi

podman-psql:
	$(RUNTIME_PODMAN) exec -it -e PGPASSWORD='$(POSTGRES_PASSWORD)' $(SERVICE) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

podman-initablas:
	$(RUNTIME_PODMAN) exec -i $(SERVICE) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
