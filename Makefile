install:
	pip install --no-deps --upgrade pip &&\
	pip install --no-deps -r requirements.txt
format:
	black .
lint:
	pylint --disable=R,C hello.py
test:
	python -m pytest -v test hello.py
deploy:
	#deploy commands

all: install lint test deploy