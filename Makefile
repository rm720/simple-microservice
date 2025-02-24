install:
	pip install --upgrade pip &&\
	pip install -r requirements.txt
format:
	black .
lint:
	pylint --disable=R,C hello.py
test:
	python -m pytest -v test hello.py
deploy:
	#deploy commands

all: install lint test deploy