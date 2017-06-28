.PHONY: test docker push

IMAGE            ?= 971383676178.dkr.ecr.us-east-1.amazonaws.com/kube-aws-autoscaler
VERSION          ?= $(shell git describe --tags --always --dirty)
TAG              ?= 0.9.3
GITHEAD          = $(shell git rev-parse --short HEAD)
GITURL           = $(shell git config --get remote.origin.url)
GITSTATU         = $(shell git status --porcelain || echo "no changes")

default: docker

test:
	tox

docker: scm-source.json
	docker build --build-arg "VERSION=$(VERSION)" -t "$(IMAGE):$(TAG)" .
	@echo 'Docker image $(IMAGE):$(TAG) can now be used.'

push: docker
	docker push "$(IMAGE):$(TAG)"

scm-source.json: .git
	@echo '{"url": "$(GITURL)", "revision": "$(GITHEAD)", "author": "$(USER)", "status": "$(GITSTATUS)"}' > scm-source.json

