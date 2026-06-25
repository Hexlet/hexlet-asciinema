# Recording demos (automated)

This file documents how to record an asciinema demo **reproducibly and non-interactively**,
so the same cast can be regenerated on demand instead of being hand-typed live.

The idea: a small **driver script** simulates human typing and runs the demo commands. It is
executed under `asciinema rec -c` **inside a `hex/<lang>` image**, which produces a `.cast`.
That cast is then converted to an animated `.gif` with [`agg`](https://github.com/asciinema/agg).
Because the whole demo is a script, re-running it gives the same recording every time.

> For a quick one-off, you can still record interactively: `make <lang>` drops you into a
> shell where you run `asciinema rec` by hand. This document is about the scripted flow.

The example below records the `hexlet-path-size` Go utility — the one verified case. The flow
is the same for any `hex/<lang>`; only the toolchain and the offline-dependency handling
differ (see [Gotchas](#gotchas)).

## Prerequisites

- The target image is built: `make build-base` then `make build-go`.
- Host tools: `asciinema` and `agg` (the cast → gif converter).
- The project's dependencies are pre-fetched on the host, so the container can build
  **offline** — see [Gotchas](#gotchas). For Go: run `go mod download` in the project once.

## Step 1 — Write the demo driver script

Save this as `demo.sh` somewhere on the host (e.g. a scratch directory). The `run()` helper
prints the Hexlet prompt, "types" the command character by character, then executes it.

```bash
#!/bin/bash
# Demo driver for hexlet-path-size. Runs INSIDE a hex/go container,
# under `asciinema rec`. Simulates a human typing each command.
set -e

PS1_STR=$'\033[01;34m~/hexlet-path-size\033[00m$ '

# Print a command char-by-char (typing illusion), then execute it.
run() {
  local cmd="$1"
  printf '%s' "$PS1_STR"
  for (( i=0; i<${#cmd}; i++ )); do
    printf '%s' "${cmd:$i:1}"
    sleep 0.035
  done
  sleep 0.4
  printf '\n'
  eval "$cmd"
  sleep 1.0
}

# Sources are mounted read-only at /src; build in a writable workdir.
cp -r /src ~/hexlet-path-size
cd ~/hexlet-path-size

# A small self-contained sample tree, so the output is meaningful.
mkdir -p sample/docs sample/img sample/.cache
head -c 900  /dev/urandom > sample/readme.md
head -c 1500 /dev/urandom > sample/docs/report.pdf
head -c 800  /dev/urandom > sample/docs/notes.txt
head -c 4096 /dev/urandom > sample/img/photo.jpg
head -c 200  /dev/urandom > sample/.cache/tmp.bin

clear
sleep 0.6

run 'go build -o bin/hexlet-path-size ./cmd/hexlet-path-size'
run './bin/hexlet-path-size --help'
run './bin/hexlet-path-size sample'
run './bin/hexlet-path-size sample -r'
run './bin/hexlet-path-size sample -r -H'
run './bin/hexlet-path-size sample -r -a -H'

sleep 1.5
```

Tune the typing speed (`sleep 0.035`) and pauses to taste. Keep `PS1_STR` matching the
Hexlet prompt from `.bashrc` (`\033[01;34m\w\033[00m$`) so the recording looks consistent.

## Step 2 — Record inside the container

Point `SCRATCH` at the host directory holding `demo.sh` (the `.cast` is written there too),
and `PROJECT` at the project being demoed.

```bash
SCRATCH=/path/to/scratch          # holds demo.sh, receives demo.cast
PROJECT=/path/to/go_path_size_project

chmod 777 "$SCRATCH"              # see Gotchas: must be writable by container uid

docker run --rm \
  -e TERM=xterm-256color -e GOPROXY=off -e GOFLAGS=-mod=mod \
  -v "$HOME/go/pkg/mod":/home/hex/go/pkg/mod:ro \
  -v "$PROJECT/code":/src:ro \
  -v "$SCRATCH":/demo \
  hex/go \
  asciinema rec -q -i 1.5 --cols 92 --rows 26 -c "bash /demo/demo.sh" /demo/demo.cast
```

Flag by flag:

- `-c "bash /demo/demo.sh"` — run the driver instead of an interactive shell; asciinema stops
  when it exits.
- `-i 1.5` — cap idle gaps to 1.5 s. A compile step (`go build`) produces no output for a
  while, which asciinema sees as idle; without this the cast can balloon to ~2 minutes.
- `--cols 92 --rows 26` — fix the terminal geometry so the gif has predictable dimensions.
- `-q` — quiet; suppresses the upload/confirmation prompts.
- `-e TERM=...`, `-e GOPROXY=off`, the module-cache mount — see [Gotchas](#gotchas).

## Step 3 — Convert the cast to a GIF

```bash
agg --theme monokai --font-size 16 --cols 92 --rows 26 "$SCRATCH/demo.cast" "$SCRATCH/demo.gif"
```

Use the same `--cols/--rows` as the recording. `--theme` and `--font-size` are cosmetic.

## Step 4 — (optional) Upload to asciinema.org

To publish the cast and get a shareable link:

```bash
asciinema auth          # one-time; writes the token to the mounted .config (see below)
asciinema upload "$SCRATCH/demo.cast"
```

Per `AGENTS.md`, `asciinema auth` run inside a container writes
`hexbase/.config/asciinema/install-id` (gitignored — never commit it). Running with
`make <lang>` mounts that config, so auth persists across runs.

## Gotchas

These are the non-obvious failures encountered while building this flow:

- **`TERM` must be set.** Pass `-e TERM=xterm-256color`. Without it, `clear` (and any TUI
  command) errors with "TERM environment variable not set", and under `set -e` that aborts
  the whole driver — you get a near-empty cast.

- **The output directory must be writable by the container user.** Inside the images the
  `hex` user is **uid 1001**. A host scratch dir owned by your uid with mode `700` is not
  writable by `hex`, and asciinema fails with "directory ... is not writable". Fix with
  `chmod 777` on the mounted output dir (or otherwise align uids).

- **Offline dependencies.** The container often cannot reach package registries
  (proxy.golang.org, npm, Packagist, PyPI), so an in-container build hangs on download.
  Pre-fetch on the host and mount the cache, forcing the tool offline:
  - **Go** (verified): `go mod download` on the host, then mount
    `~/go/pkg/mod` → `/home/hex/go/pkg/mod:ro` and set `GOPROXY=off` (with `GOFLAGS=-mod=mod`).
  - **node / php / python** (same principle, adapt accordingly): mount the host package cache
    (`~/.npm`, Composer's `~/.cache/composer`, pip/Poetry cache) into the corresponding
    location in the container, or vendor the dependencies into the mounted source, and enable
    that tool's offline flag (e.g. `npm ci --offline`, `composer install --no-interaction`,
    `poetry install` against a populated cache).

- **Cap idle time.** Use `asciinema rec -i <seconds>` so silent compile/install pauses don't
  bloat the recording. `-i 1.5` keeps demos tight.

## Where the outputs go

The `.cast` and `.gif` belong with the exercise/project being demoed — for Hexlet projects
that is usually its `__data__/assets/` directory, and the gif is referenced from the
project's README. This repository only provides the images and this recipe; finished
recordings are not stored here.
