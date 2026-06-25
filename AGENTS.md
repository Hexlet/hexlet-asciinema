# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Docker images for recording asciinema terminal casts in a consistent style for Hexlet
educational content. A base Ubuntu image (`hexbase`) installs asciinema + shared dev
tooling; per-language images layer on top of it, each adding one language runtime and its
package manager.

## Commands

- `make build` — build all images (base, node, php, python). This is also the only CI step.
- `make build-base` / `make build-node` / `make build-php` / `make build-python` — build a single image.
- `make base` — run the base image interactively in bash.
- `make node` / `make php` / `make python` — run a language image interactively; these just delegate to `make base IMAGE=<name>`.

`make <name>` runs `docker run --rm -it` and mounts `hexbase/.config` into the container at
`/home/hex/.config`, so asciinema auth/config persists on the host across container runs.

There are no tests or linters. CI (`.github/workflows/main.yml`) only runs `make build` on
push/PR to `main`.

## Architecture

- Images are named `hex/<lang>`. Every language image starts `FROM hex/base`, so `hexbase`
  is the single place for shared setup: the `hex` non-root sudo user, Moscow timezone,
  asciinema installed via pip, and the copied `.bashrc` / `.gitconfig` / `.vimrc`.
- `hexbase/Dockerfile` copies those dotfiles to BOTH `/root` and `/home/hex` — keep both
  in sync when changing shell/git/vim config.
- Each language image adds exactly one toolchain: `hex_node` (Node 18 via NodeSource),
  `hex_nvm` (nvm + LTS Node), `hex_php` (PHP via ppa:ondrej/php + Composer + zip/curl/mbstring/xml),
  `hex_python` (Poetry with `POETRY_VIRTUALENVS_IN_PROJECT=true`).
- `hex_nvm` is a separate image and is NOT built by `make build`. If it should be part of
  the standard flow, add a `build-nvm` target and a run target.

## Conventions

- Adding a language: create `hex_<lang>/Dockerfile` `FROM hex/base`, add a `build-<lang>`
  target (and wire it into the `build` aggregate), and add a `<lang>:` run target that
  delegates to `make base IMAGE=<lang>`.
- `hexbase/.config/asciinema/install-id` holds the asciinema auth token and is gitignored —
  never commit it. Running `asciinema auth` inside a container writes it to the mounted volume.
