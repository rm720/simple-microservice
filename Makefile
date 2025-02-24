install:
	python3.12 -m venv .venv
	source .venv/bin/activate && pip install --upgrade pip
	source .venv/bin/activate && pip install -r requirements.txt

format:
	source .venv/bin/activate && black .

lint:
	source .venv/bin/activate && pylint --disable=R,C *.py mylib/*.py || true

test:
	source .venv/bin/activate && python -m pytest -vv --cov=mylib --cov=main test*.py

build:
	#build container

deploy:
	#deploy commands

all: install format lint test deploy

clean:
	rm -rf .venv
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete