GIT_COMMIT       := $$(git rev-parse HEAD)
GIT_COMMIT_SHORT := $$(git rev-parse --short HEAD)
GIT_TAG          := $$(git describe --exact-match)

REPOSITORY ?= panta/rsync-time-backup
TAG        ?= ${GIT_TAG}
IMAGE      := $(REPOSITORY):$(TAG)
LATEST     := $(REPOSITORY):latest

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

.PHONY: all
all: build push

.PHONY: build
build:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Building $(IMAGE)"
	@docker build --rm -t $(IMAGE) .
	@docker tag $(IMAGE) ${LATEST}

.PHONY: push
push:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Pushing $(REPOSITORY):$(TAG)"
	@docker push $(REPOSITORY)
