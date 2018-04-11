build:
	docker-compose build

build-no-cache:
	docker-compose build --no-cache

test: build
	docker-compose run integration py.test tests

dev: build
	docker-compose run integration bash