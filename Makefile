# Makefile

.PHONY: setup up down clear front-up front-log front-build

setup: 
	@echo "Creating .env from .env.example"
	@if [ ! -f .env ]; then cp .env.example .env; fi
	@echo "Initializing submodules..."
	git submodule update --init --recursive
	@echo "Building docker images..."
	docker compose build

# 起動
up: 
	docker compose up -d

# 停止
down:
	docker compose down

# リセット
clear:
	docker compose down --rmi all --volumes --remove-orphans

# フロントエンドコンテナの起動
front-up:
	docker compose up -d frontend

# フロントエンドのログを見る
front-log:
	docker compose logs -f frontend

# フロントエンドを再ビルドして起動（ライブラリ追加時など）
front-build:
	docker compose up -d --build frontend