# asciinema recorder

Docker images for recording asciinema in the same style. Each language has its own image, using the base one with Ubuntu.

## Usage

By default, askinems are recorded to an anonymous account, from which you can retrieve the recording to your account by clicking on the links for a few days. To avoid having to do it manually every time, you can use the `asciinema auth` command to authenticate your account, and the resulting id will be saved into *hexbase/.config/asciinema/install-id*, which will be used for further reference. That file contains the key that will send the recordings immediately to the account linked to it. You can read more about the key in the documentation: <https://asciinema.org/docs/usage>

Commands:

* `make build` will build the base and language images;
* `make <name>` will start one of the built images. The names of the images can be found in the *Makefile*.

---

[![Hexlet Ltd. logo](https://raw.githubusercontent.com/Hexlet/assets/master/images/hexlet_logo128.png)](https://hexlet.io/pages/about?utm_source=github&utm_medium=link&utm_campaign=hexlet-cv)

This repository is created and maintained by the team and the community of Hexlet, an educational project. [Read more about Hexlet](https://hexlet.io/pages/about?utm_source=github&utm_medium=link&utm_campaign=hexlet-cv).

See most active contributors on [hexlet-friends](https://friends.hexlet.io/).
