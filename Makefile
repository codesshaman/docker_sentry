name = Sentry

NO_COLOR=\033[0m	# Color Reset
COLOR_OFF='\e[0m'       # Color Off
OK_COLOR=\033[32;01m	# Green Ok
ERROR_COLOR=\033[31;01m	# Error red
WARN_COLOR=\033[33;01m	# Warning yellow
RED='\e[1;31m'          # Red
GREEN='\e[1;32m'        # Green
YELLOW='\e[1;33m'       # Yellow
BLUE='\e[1;34m'         # Blue
PURPLE='\e[1;35m'       # Purple
CYAN='\e[1;36m'         # Cyan
WHITE='\e[1;37m'        # White
UCYAN='\e[4;36m'        # Cyan
USER_ID = $(shell id -u)
ifneq (,$(wildcard .env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif


all:
	@printf "Launch configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml up -d

help:
	@echo -e "$(OK_COLOR)==== All commands of ${name} configuration ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- make				: Launch configuration"
	@echo -e "$(WARN_COLOR)- make build			: Building configuration"
	@echo -e "$(WARN_COLOR)- make config			: Create docker-compose config"
	@echo -e "$(WARN_COLOR)- make con			: Connect to the container"
	@echo -e "$(WARN_COLOR)- make down			: Stopping configuration"
	@echo -e "$(WARN_COLOR)- make env			: Create .env-file"
	@echo -e "$(WARN_COLOR)- make key			: Generate sentry secret key"
	@echo -e "$(WARN_COLOR)- make git			: Set user name and email to git"
	@echo -e "$(WARN_COLOR)- make logs			: Show dash logs"
	@echo -e "$(WARN_COLOR)- make migrate			: Create migrations"
	@echo -e "$(WARN_COLOR)- make net			: Create network"
	@echo -e "$(WARN_COLOR)- make push			: Push changes to the github"
	@echo -e "$(WARN_COLOR)- make ps			: View configuration"
	@echo -e "$(WARN_COLOR)- make user			: Create sentry user"
	@echo -e "$(WARN_COLOR)- make re			: Rebuild dash configuration"
	@echo -e "$(WARN_COLOR)- make clean			: Cleaning configuration$(NO_COLOR)"

build:
	@printf "$(YELLOW)==== Building configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --build

config:
	@printf "$(ERROR_COLOR)==== View ${name} config ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml config

con:
	@printf "$(ERROR_COLOR)==== Connect to container... ====$(NO_COLOR)\n"
	@docker exec -it ${SENTRY_API_NAME} bash

down:
	@printf "$(ERROR_COLOR)==== Stopping configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml down

env:
	@printf "$(ERROR_COLOR)==== Create environment file for ${name}... ====$(NO_COLOR)\n"
	@if [ -f .env ]; then \
		rm .env; \
	fi; \
	cp .env.example .env;

git:
	@printf "$(YELLOW)==== Set user name and email to git for ${name} repo... ====$(NO_COLOR)\n"
	@bash ./scripts/gituser.sh

key:
	@printf "$(YELLOW)==== Set secret key for ${name} repo... ====$(NO_COLOR)\n"
	@bash ./scripts/sentry_key.sh

logs:
	@printf "$(YELLOW)==== ${name} logs... ====$(NO_COLOR)\n"
	@docker logs ${SENTRY_API_NAME}

migrate:
	@printf "$(YELLOW)==== ${name} migrations... ====$(NO_COLOR)\n"
	@docker exec -it ${SENTRY_API_NAME} sentry upgrade

net:
	@printf "$(YELLOW)==== Создание сети для конфигурации ${name}... ====$(NO_COLOR)\n"
	@docker network create \
	  --driver=bridge \
	  --subnet=$(SENTRY_ADDR) \
	  --gateway=$(SENTRY_GATE) \
	  $(SENTRY_NET)

push:
	@bash ./scripts/push.sh

re:
	@printf "$(OK_COLOR)==== Rebuild dash... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml down
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build

ps:
	@printf "$(BLUE)==== View configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml ps

user:
	@printf "$(ERROR_COLOR)==== Create user... ====$(NO_COLOR)\n"
	@docker exec -it ${SENTRY_API_NAME} sentry createuser

clean: 
	@printf "$(ERROR_COLOR)==== Cleaning configuration ${name}... ====$(NO_COLOR)\n"
	@yes | docker system prune -a
# 	@scripts/clean.sh

fclean: down
	@printf "$(ERROR_COLOR)==== Total clean of all configurations docker ====$(NO_COLOR)\n"
	@yes | docker system prune -a
	# Uncommit if necessary:
	# @docker stop $$(docker ps -qa)
	# @docker system prune --all --force --volumes
	# @docker network prune --force
	# @docker volume prune --force

.PHONY	: all help build down logs re refl repa reps ps clean fclean
