install:
	#install commands
format:
	#black or yapf
lint:
	#flake8 or pylint
test:
	#pytest
deploy:
	#deploy commands
all: install lint test deploy