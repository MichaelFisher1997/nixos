# AGENTS.md

## Verification

- Main checks are:
  - `nix flake check`
  - `nixos-rebuild build --flake .#hypr-nix`
  - `nixos-rebuild build --flake .#hyprtop`
- Apply with:
  - `sudo nixos-rebuild switch --flake /home/micqdf/nixos/nix-config#hypr-nix`
  - `sudo nixos-rebuild switch --flake "path:/home/micqdf/nixos/nix-config#hyprtop"`
- For workflow edits, lint with:
  - `nix shell nixpkgs#actionlint -c actionlint .github/workflows/deploy.yml`

## Flake Gotcha

- New files under this repo must be tracked by Git before `nix flake check` or `nixos-rebuild build --flake .#...` can see them.
- This matters most when adding a new host or module. Temporary `git add` is enough; uncommitted is fine.

## Repo Shape

- `flake.nix` defines two hosts via `mkHost`:
  - `hypr-nix`
  - `hyprtop`
- Shared modules live in `modules/`; host-specific wiring lives in `hosts/<host>/default.nix` plus `vars.nix`.
- `specialArgs` passed to all modules are `vars`, `zen-browser`, and `unstable`.

## Host-Specific Rules

- `hypr-nix` uses the shared desktop/boot path:
  - `modules/core/boot.nix`
  - `modules/desktop/gnome.nix`
  - `modules/hardware/gpu-amd.nix`
- `hyprtop` is intentionally different:
  - BIOS/GRUB boot in `hosts/hyprtop/boot.nix`
  - Intel graphics via `modules/hardware/gpu-intel.nix`
  - host-local `hosts/hyprtop/gnome.nix`
  - `system.stateVersion = "23.11"`
- `modules/core/system.nix` sets `system.stateVersion = lib.mkDefault "25.11"`; older hosts should override it in the host file, not by editing the shared module.

## vars.nix Conventions

- Required per host: `hostName`, `user.name`, `user.description`, `user.groups`, `nfs.server`, `nfs.exportPath`.
- Optional per host:
  - `bluetooth.headsetMac`
  - `mounts.ssd2Uuid`
- `modules/hardware/bluetooth.nix` and `modules/services/nfs.nix` already guard those optional attrs with `lib.optionalAttrs`; omit absent hardware instead of inventing placeholder values.

## Networking Gotcha

- `modules/networking/default.nix` contains a hardcoded service that runs `nmcli device set enp8s0 managed yes`.
- That is correct for `hypr-nix`, but it is not generic. When adding another host, either override it or move that logic host-local if the NIC name differs.

## SSH / Deploy

- `modules/services/default.nix` configures the local user to prefer `~/.ssh/infra` for SSH via `programs.ssh.extraConfig`.
- The same module grants passwordless sudo only for `/run/current-system/sw/bin/nixos-rebuild`; the GitHub deploy workflow depends on that already being applied on the target machine.
- `.github/workflows/deploy.yml` deploys over Tailscale and expects repo secrets:
  - `DEPLOY_SSH_KEY`
  - `TAILSCALE_AUTHKEY`
- The workflow deploys from a clean checkout at `/home/micqdf/.local/share/nixos-deploy/nix-config`, not from the user’s working tree. Commit and push changes before relying on the workflow.

## Fresh Host Bootstrap

- A fresh NixOS install may not have `git` yet. Bootstrap the repo with:
  - `nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git -c git clone git@github.com:MichaelFisher1997/nixos.git ~/nixos/nix-config`
