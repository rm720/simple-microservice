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
	aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 361769592688.dkr.ecr.ap-southeast-2.amazonaws.com
	docker build -t simple-microservice .
	docker tag simple-microservice:latest 361769592688.dkr.ecr.ap-southeast-2.amazonaws.com/simple-microservice:latest
	docker push 361769592688.dkr.ecr.ap-southeast-2.amazonaws.com/simple-microservice:latest

all: install format lint test deploy

clean:
	rm -rf .venv
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete