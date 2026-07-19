# HarnessVM

HarnessVM lets you quickly launch secure AI sandbox machines with graphical and terminal interfaces.

![HarnessVM logo](assets/logo.jpg)

## Why HarnessVM?

A full desktop lets agents control an entire sandboxed OS. They can run end-to-end tests and operate installed programs through MCP.

HarnessVM is designed as a thin layer with minimal code and overhead: one Bash script plus ready-made Lima, Docker Compose, and desktop configs.

The included setup runs an Ubuntu desktop in [Lima](https://lima-vm.io/) and is tested on Apple Silicon macOS. The host and guest can both be changed.

## Layout

- `harnessvm`: launcher
- `vm/`: Lima, Compose, and firewall
- `desktop/`: browser desktop image
- `harnesses/`: optional coding agents

## Start

Install Lima 2.1.2 or newer, then:

```sh
./harnessvm doctor
./harnessvm /path/to/project
```

The first run creates the VM and builds the image. HarnessVM then opens a private `127.0.0.1` URL.

Optional shell alias:

```sh
alias harnessvm='/absolute/path/to/HarnessVM/harnessvm'
```

## Options

```sh
harnessvm . --read-only
harnessvm . --mount ../other-project
harnessvm . --mount-ro ../docs
harnessvm . --harness codex --harness opencode
harnessvm . --persist .local
harnessvm . --allow 192.168.1.50:8080
harnessvm . --allow host.lima.internal:11434
harnessvm . --no-browser
```

Codex and Claude are loaded by default. The first `--harness` replaces that default; repeat it to load more. Available names are `codex`, `claude`, `opencode`, `pi`, `hermes`, and `qwen`.

`--no-browser` opens a shell at `/workspace` instead. Exiting the shell leaves the session running. Adding a new host path may restart Lima; HarnessVM asks first if another session is running.

## Add a harness

Add `harnesses/name.sh` and install the tool under `~/.name`. Selecting `--harness name` runs the script and keeps that directory between sessions.

Use `--persist .local` for anything installed directly into `~/.local`. Packages installed with `apt` are temporary; add them to `desktop/Dockerfile`.

Defaults can be changed in `config.env`:

```sh
HARNESSVM_HARNESSES=codex,claude
HARNESSVM_PERSIST_DIRS=.local
```

## Sessions

```sh
harnessvm list
harnessvm shell SESSION
harnessvm logs SESSION
harnessvm stop SESSION
harnessvm stop --all
```

A unique session prefix is enough. `delete` is an alias for `stop`.

Stopping a session removes its desktop home, packages, Docker data, and logs. Writable host mounts, selected harness data, and cached images remain.

## Access

- The desktop sees `/workspace`, explicit `/shares` mounts, and selected persistent directories.
- Changes inside writable mounts also change the host files.
- The browser listens only on `127.0.0.1`.
- Public internet works. Private addresses require an exact `--allow HOST:PORT`.
- `sudo` and Docker stay inside Lima. The host's Docker socket is not shared.

All sessions share one VM. Keep untrusted projects in a separate VM.

## Local models

HarnessVM is useful for testing agentic harnesses with on-device models such as Qwen and Gemma. Run them on the host with LM Studio, llama.cpp, or another OpenAI-compatible inference engine.

Allow the host's LM Studio port, then point Pi at PrismML's loaded `bonsai-27b` model:

```sh
harnessvm . --harness pi --allow host.lima.internal:1234 --no-browser
mkdir -p ~/.pi/agent
cp /opt/harnessvm/harnesses/pi-lm-studio.json ~/.pi/agent/models.json
pi --provider lmstudio --model bonsai-27b
```

For llama.cpp or another OpenAI-compatible engine, change `baseUrl` and the model ID in the example config.

## Configuration

```sh
cp config.env.example config.env
```

The file covers VM resources, harnesses, persistent directories, display settings, browser launch, and private-network exceptions. VM type, architecture, and disk size apply when the VM is created.

## Other platforms

- Linux: set `HARNESSVM_VM_TYPE=qemu`, the native `HARNESSVM_ARCH`, and `HARNESSVM_MOUNT_TYPE=9p`.
- Windows: use Bash with QEMU, then adjust path handling and the macOS `open` command. Lima's WSL2 driver is experimental.
- Other guests: change `vm/lima.yaml` and the base image in `desktop/Dockerfile`.

See Lima's [VM](https://lima-vm.io/docs/config/vmtype/) and [mount](https://lima-vm.io/docs/config/mount/) guides.

## Maintenance

```sh
harnessvm vm status
harnessvm vm logs
harnessvm vm stop
harnessvm prune
harnessvm vm delete
```

`vm delete` removes the VM, cached images, logins, and other persistent data.

## AI disclosure and disclaimer

HarnessVM is a proof of concept developed with AI assistance, including agentic coding tools. It may contain errors or unexpected behavior.

The software is provided as-is, without warranties or guarantees. Review it and use it at your own risk. The authors and contributors accept no liability for data loss, security incidents, damage, or other consequences.


## Author

Created by [Mohammad Tomaraei](https://www.linkedin.com/in/tomaraei/)

<a href="https://www.linkedin.com/in/tomaraei/">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/mt-darkmode.png">
    <source media="(prefers-color-scheme: light)" srcset="./assets/mt.png">
    <img alt="Mohammad Tomaraei" src="./assets/mt.png">
  </picture>
</a>
