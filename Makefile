SHELL := /bin/bash

install:
	python3.12 -m venv .venv
	. .venv/bin/activate && pip install --upgrade pip
	. .venv/bin/activate && pip install -r requirements.txt

format:
	. .venv/bin/activate && black .

lint:
	. .venv/bin/activate && ruff check *.py mylib/*.py

test:
	. .venv/bin/activate && python -m pytest -vv --cov=mylib --cov=main test*.py

build:
	#build container
	docker build -t deploy-fastapi .

run:
	#run container
	docker run -p 127.0.0.1:8080:8080 deploy-fastapi

deploy:
	#deploy commands

all: install format lint test deploy

clean:
	rm -rf .venv
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete