COMMIT = $(shell git rev-list --count --all)
BRANCH = $(shell git symbolic-ref -q HEAD | cut -b 12-)
VERSION = $(BRANCH)-$(shell git rev-parse --short HEAD)

.PHONY: all

all: docker

docker:
	@sudo docker build -t 'zentao:latest' -t 'zentao:$(VERSION)' .

run:
	@sudo docker-compose up -d zentao

clean:
	@sudo docker rm --force zentao
	@sudo docker rmi --force 'zentao:latest'