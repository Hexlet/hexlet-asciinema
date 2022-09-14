IMAGE?=base

build: build-base build-node build-php build-python

build-base:
	docker build ./hexbase -t hex/base
build-node:
	docker build ./hex_node -t hex/node
build-php:
	docker build ./hex_php -t hex/php
build-python:
	docker build ./hex_python -t hex/python

base:
	docker run --rm -it \
		--name hexlet_asciinema \
		-v $(CURDIR)/hexbase/.config:/home/hex/.config \
		hex/$(IMAGE) /bin/bash

node:
	make base IMAGE=node

php:
	make base IMAGE=php

python:
	make base IMAGE=python

