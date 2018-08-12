include .env

.PHONY: help

default: help

# Colors
COLOR_END ?= \033[0m
COLOR_RED ?= \033[31m
COLOR_GREEN ?= \033[32m
COLOR_YELLOW ?= \033[33m
COLOR_CYAN ?= \033[36m
# Inverted, i.e. colored backgrounds
COLOR_IRED ?= \033[0;30;41m
COLOR_IGREEN ?= \033[0;30;42m
COLOR_IYELLOW ?= \033[0;30;43m
COLOR_ICYAN ?= \033[0;30;46m

HELP_FUNC = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${COLOR_CYAN}$$_:${COLOR_END}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${COLOR_YELLOW}$$_->[0]${COLOR_END}$$sep${COLOR_GREEN}$$_->[1]${COLOR_END}\n"; \
    }; \
    print "\n"; }

help: ##@Miscellaneous Show this help.
	@perl -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

build: ##@Docker Build the container.
	docker build -t $(PROJECT_NAME) --build-arg PAREVIEW_VERSION=$(VERSION) .

release: build publish ##@Docker Make a release by building and publishing the `{VERSION}` and `latest` tagged containers to docker hub

publish: publish-latest publish-version ##@Docker Publish the `{VERSION}` and `latest` tagged containers to docker hub

publish-latest: ##@Docker Publish the `latest` tagged containers to docker hub
	@echo 'publish latest to $(PROJECT_NAME)'
	docker push $(PROJECT_NAME):latest

publish-version: ##@Docker Publish the `{VERSION}` tagged containers to docker hub
	@echo 'publish $(VERSION) to $(PROJECT_NAME)'
	docker push $(PROJECT_NAME):$(VERSION)

tag: tag-latest tag-version ##@Docker Generate container tags for the `{VERSION}` and `latest` tags

tag-latest: ##@Docker Generate container `latest` tag
	@echo 'create tag latest'
	docker tag $(PROJECT_NAME) $(PROJECT_NAME):latest

tag-version: ##@Docker Generate container `{VERSION}` tag
	@echo 'create tag $(VERSION)'
	docker tag $(PROJECT_NAME) $(PROJECT_NAME):$(VERSION)

