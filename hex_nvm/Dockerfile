FROM hex/base

USER hex
WORKDIR /home/hex

RUN sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install --lts && nvm install-latest-npm
