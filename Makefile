# Makefile

.PHONY: setup up down clear

setup: 
	@echo "Initializing submodules..."
	git submodule update --init --recursive
	@echo "Building docker images..."
	docker compose build

# 起動
up: 
	docker compose down -d

# 停止
down:
	docker compose down

# リセット
clear:
	docker compose down --rmi all --volumes --remove-orphans