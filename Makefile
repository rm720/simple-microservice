SHELL := /bin/bash
AWS_REGION := ap-southeast-2
AWS_ACCOUNT := 361769592688
ECR_REPO := simple-microservice
CLUSTER_NAME := simple-microservice-cluster

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
	docker build -t $(ECR_REPO) .

run:
	docker run -p 127.0.0.1:8080:8080 $(ECR_REPO)

# Get the service name from ECS
get-service:
	$(eval SERVICE_NAME := $(shell aws ecs list-services --cluster $(CLUSTER_NAME) --region $(AWS_REGION) --query 'serviceArns[0]' --output text | awk -F'/' '{print $$3}'))

git-update:
	git add .
	git commit -m "Update: $$(date +%Y-%m-%d_%H-%M-%S)"
	git push

deploy: get-service
	# Login to ECR
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com
	# Build and tag image
	docker build -t $(ECR_REPO) .
	docker tag $(ECR_REPO):latest $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO):latest
	# Push to ECR
	docker push $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO):latest
	# Force new deployment
	aws ecs update-service --cluster $(CLUSTER_NAME) --service $(SERVICE_NAME) --force-new-deployment --region $(AWS_REGION)
	# Wait for deployment to complete
	aws ecs wait services-stable --cluster $(CLUSTER_NAME) --services $(SERVICE_NAME) --region $(AWS_REGION)

all: install format lint test git-update deploy

clean:
	rm -rf .venv
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete