FROM hex/base

USER hex
WORKDIR /home/hex

RUN sudo apt-add-repository ppa:ondrej/php
RUN sudo apt-get update && sudo apt-get install -y php
# additional extensions for php
RUN sudo apt-get update && sudo apt-get install -y zip unzip php-zip php-curl php-mbstring php-xml

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --filename=composer #--install-dir=/usr/local/bin
RUN sudo mv composer /usr/local/bin
RUN php -r "unlink('composer-setup.php');"
RUN echo 'PATH=$PATH:~/.composer/vendor/bin' >> ~/.bashrc
