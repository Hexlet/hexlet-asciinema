FROM hex/base

RUN sudo apt-get update
RUN sudo apt-get install -yq php8.5
RUN sudo apt-get install -yq zip unzip php8.5-zip php8.5-curl php8.5-mbstring php8.5-xml

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_HOME=/home/hex/.config/composer
ENV PATH=$COMPOSER_HOME/vendor/bin:$PATH
