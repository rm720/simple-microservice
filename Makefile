install:
	python3.12 -m venv .venv
	source .venv/bin/activate && pip install --upgrade pip
	source .venv/bin/activate && pip install -r requirements.txt

format:
	source .venv/bin/activate && black .

lint:
	# source .venv/bin/activate && pylint --disable=R,C,W0012,C0103,CE0611,E1101,E1136,F0002,C0114,C0413,C0116 *.py mylib/*.py || true
	source .venv/bin/activate && ruff check *.py mylib/*.py

test:
	source .venv/bin/activate && python -m pytest -vv --cov=mylib --cov=main test*.py

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