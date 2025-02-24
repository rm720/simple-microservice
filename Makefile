install:
	pip install --upgrade pip &&\
	pip install -r requirements.txt
format:
	black .
lint:
	pylint --disable=R,C mylib/*.py
test:
	python -m pytest -vv --cov=mylib test*.py
build:
	#build container
deploy:
	#deploy commands

all: install lint test deploy