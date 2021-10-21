#
# Makefile to manage the containers.
# Author: Adrian Novegil <adrian.novegiltoledo@altran.com>
#
#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RED := $(shell tput -Txterm setaf 1)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

PROJECT_NAME=observability-sandbox
COMPOSE_COMMAND=docker-compose --project-name=$(PROJECT_NAME)
DOCKER_NETWORK=observabilitysandbox

.DEFAULT_GOAL:=help

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

confirm:
	@( read -p "$(RED)Are you sure? [y/N]$(RESET): " sure && case "$$sure" in [yY]) true;; *) false;; esac )

create-network:
ifeq ($(shell docker network ls | grep ${DOCKER_NETWORK} | wc -l),0)
	echo "Creating docker network ${DOCKER_NETWORK}"
	@docker network create ${DOCKER_NETWORK}
endif

.PHONY: help build up start stop restart logs status ps down clean

build: ## Build the Docker images
	@$(COMPOSE_COMMAND) build

up: create-network ## Start all or c=<name> containers in foreground
	@$(COMPOSE_COMMAND) up

start: create-network ## Start all or c=<name> containers in background
	@$(COMPOSE_COMMAND) up -d

stop: ## Stop all or c=<name> containers
	@$(COMPOSE_COMMAND) stop

restart: stop start ## Restart all or c=<name> containers

logs: ## Show logs for all or c=<name> containers
	@$(COMPOSE_COMMAND) logs --tail=100

status: ## Show status of containers
	@$(COMPOSE_COMMAND) ps

ps: status ## Alias of status

down: confirm ## Clean all data
	@$(COMPOSE_COMMAND) down
	@docker network rm ${DOCKER_NETWORK} | true

clean: down ## Alias of down
