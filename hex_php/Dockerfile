FROM hex/base

RUN sudo apt-add-repository ppa:ondrej/php
RUN sudo apt-get update
RUN sudo apt-get install -yq php
RUN sudo apt-get install -yq zip unzip php-zip php-curl php-mbstring php-xml

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
