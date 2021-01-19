IMAGE?=base

build: build-base build-node
	# docker build ./hex_nvm -t hex/nvm
	# docker build ./hex_php -t hex/php
build-base:
	docker build ./hexbase -t hex/base
build-node:
	docker build ./hex_node -t hex/node

#run

base:
	docker run --rm -it \
		--name hexlet_asciinema \
		-v $(CURDIR)/hexbase/.config:/home/hex/.config \
		hex/$(IMAGE) /bin/bash
node:
	make base IMAGE=node
