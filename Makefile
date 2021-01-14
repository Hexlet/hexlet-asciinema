build:
	docker build ./hexbase -t hex/base
	docker build ./hex_node -t hex/node
	# docker build ./hex_nvm -t hex/nvm
	docker build ./hex_php -t hex/php

base:
	docker run -it hex/base /bin/bash

node:
	docker run -it hex/node /bin/bash

php:
	docker run -it hex/php /bin/bash
