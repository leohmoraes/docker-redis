NAME = airdock/redis
VERSION = dev-3.2

.PHONY: all clean build tag_latest release debug run run_client

all: build

clean:
	@CID=$(shell docker ps -a | awk '{ print $$1 " " $$2 }' | grep $(NAME) | awk '{ print $$1 }'); if [ ! -z "$$CID" ]; then echo "Removing container which reference $(NAME)"; for container in $(CID); do docker rm -f $$container; done; fi;
	@if docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then docker rmi -f $(NAME):$(VERSION); fi
	@if docker images $(NAME) | awk '{ print $$2 }' | grep -q -F latest; then docker rmi -f $(NAME):latest; fi


build: clean
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	@docker tag $(NAME):$(VERSION) $(NAME):latest

release: build tag_latest
	docker push $(NAME)
	@echo "Create a tag v-$(VERSION)"
	@git tag v-$(VERSION)
	@git push origin v-$(VERSION)

debug:
	docker run -t -i $(NAME):$(VERSION)

run:
	@echo "IPAddress =" $$(docker inspect --format '{{.NetworkSettings.IPAddress}}' $$(docker run -d -p 6379:6379 --name redis $(NAME):$(VERSION)))

run_client:
	docker run -it --rm --link redis:redis $(NAME):$(VERSION) bash -c 'redis-cli -h redis'
