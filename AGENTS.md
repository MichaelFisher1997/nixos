# AGENTS.md - NixOS Configuration

This is a NixOS system configuration repository managed with Nix Flakes.

## Build / Deploy Commands

```bash
# Build and switch to new configuration (applies changes to running system)
sudo nixos-rebuild switch --flake .#hypr-nix

# Build without switching (dry-run to verify config compiles)
nixos-rebuild build --flake .#hypr-nix

# Check flake evaluates without errors
nix flake check

# Update all flake inputs
nix flake update

# Update a single input
nix flake lock --update-input nixpkgs

# View changes before applying
nixos-rebuild build --flake .#hypr-nix && nixos-rebuild switch --flake .#hypr-nix
```

There are no tests or lint commands. Validation is done via `nixos-rebuild build` and `nix flake check`.

## Repository Structure

```
.
├── flake.nix                  # Flake entrypoint - defines inputs, outputs, host configs
├── flake.lock                 # Pinned input versions
├── hosts/
│   └── hypr-nix/
│       ├── default.nix        # Host module imports (aggregates all modules)
│       ├── vars.nix           # Host-specific variables (user, NFS, Bluetooth, mounts)
│       └── hardware-configuration.nix  # Auto-generated hardware config (do not edit manually)
└── modules/
    ├── core/                  # Boot, nix settings, users, locale, system, fonts
    ├── desktop/               # GNOME, Hyprland
    ├── gaming/                # Steam, GameMode
    ├── hardware/              # GPU (AMD), audio (PipeWire), Bluetooth
    ├── networking/            # NetworkManager, Tailscale, firewall
    ├── packages/              # System-wide packages
    └── services/              # Docker, Sunshine, NFS, Thunar, printing, Flatpak, SSH
```

## Architecture & Conventions

### Flake Structure

- **Inputs**: `nixpkgs` (nixos-25.11), `nixpkgs-unstable`, `zen-browser`
- **Output**: Single host `hypr-nix` at `nixosConfigurations.hypr-nix`
- **specialArgs**: `vars`, `zen-browser`, `unstable` are passed to all modules
- Host variables are imported from `hosts/<host>/vars.nix` and passed as `specialArgs.vars`

### Module Pattern

Every module follows the standard NixOS module pattern:

```nix
{ pkgs, ... }:  # Only destructure arguments you actually use
{
  # Configuration options here
}
```

Common argument sets by module type:
- **Core modules**: `{ pkgs, ... }`, `{ vars, ... }`, `{ lib, pkgs, ... }`
- **Modules using vars**: `{ pkgs, vars, ... }`, `{ pkgs, vars, lib, unstable, ... }`
- **Simple modules**: `{ ... }:` when no arguments are needed

### Variable System (`vars.nix`)

Host-specific values are centralized in `hosts/<host>/vars.nix`:
- `hostName` - machine hostname
- `user.name`, `user.description`, `user.groups` - user account details
- `nfs.server`, `nfs.exportPath` - NFS mount configuration
- `bluetooth.headsetMac` - Bluetooth device addresses
- `mounts.ssd2Uuid` - filesystem UUIDs

Access via `vars.` prefix (e.g., `vars.user.name`, `vars.nfs.server`).

### Using Unstable Packages

To use a package from `nixpkgs-unstable`, reference it through the `unstable` specialArg:

```nix
{ pkgs, unstable, ... }:
{
  services.tailscale.package = unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
}
```

## Code Style Guidelines

### Nix Formatting

- **2-space indentation** throughout
- Attribute sets: opening brace on same line as assignment
- Lists: opening bracket on same line, items on separate lines for long lists, inline for short ones
- Use `with pkgs;` for package lists: `environment.systemPackages = with pkgs; [ git vim ];`

### Function Arguments

- Always use the module function form `{ args, ... }:`
- Use `{ ... }:` ellipsis pattern to accept additional arguments without error
- **Only destructure arguments you use** - do not add unused arguments
- Order: `pkgs` first, then `lib`, `vars`, `unstable`, `config` as needed

```nix
# Good - only needed args
{ pkgs, ... }:

# Good - multiple args when needed
{ pkgs, vars, lib, unstable, ... }:

# Bad - unused arguments
{ pkgs, lib, config, vars, ... }:
```

### Imports & Module Organization

- Group imports by category (core, desktop, hardware, services, etc.)
- Use relative paths: `../../modules/category/module.nix`
- One concern per module file
- `default.nix` in each module directory can aggregate multiple related settings

### Attribute Sets & Options

- Use dot notation for nested config: `boot.loader.systemd-boot.enable = true;`
- Group related options under their parent attribute when possible
- Use `lib.mkForce` to override defaults, `lib.mkDefault` for sensible defaults
- String interpolation with `${}` for variables: `"${vars.nfs.server}:${vars.nfs.exportPath}"`

### Systemd Services

When defining custom systemd services:
- Always include `description`
- Specify `wantedBy`, `after`, `wants` as appropriate
- Use `Type = "oneshot"` for run-once tasks with `RemainAfterExit = true`
- Reference packages explicitly: `${pkgs.bluez}/bin/bluetoothctl`

### Filesystems & Mounts

- Use UUID-based mounts: `/dev/disk/by-uuid/${vars.mounts.ssd2Uuid}`
- Include `nofail` for external/removable mounts
- Use systemd automount for network filesystems: `x-systemd.automount`, `x-systemd.idle-timeout`

### Firewall Rules

- Keep port ranges grouped: `allowedUDPPortRanges = [{ from = 47998; to = 48000; }]`
- Individual ports in lists: `allowedTCPPorts = [ 47984 47989 47990 48010 ];`

## Adding a New Module

1. Create the module file in the appropriate `modules/<category>/` directory
2. Follow the `{ pkgs, ... }:` pattern (or include other args as needed)
3. Add the import to the host's `hosts/<host>/default.nix`
4. Build-test with `nixos-rebuild build --flake .#hypr-nix`
5. Apply with `sudo nixos-rebuild switch --flake .#hypr-nix`

## Adding a New Host

1. Create `hosts/<hostname>/` directory
2. Generate hardware config: `nixos-generate-config --dir hosts/<hostname>`
3. Create `hosts/<hostname>/vars.nix` with host-specific variables
4. Create `hosts/<hostname>/default.nix` importing desired modules
5. Add the new `nixosConfigurations` entry in `flake.nix`

## Important Notes

- **Never edit `hardware-configuration.nix`** - it is auto-generated
- **hardware-configuration.nix is tracked in git** despite being auto-generated - only regenerate if hardware changes
- The `vars.nix` file contains MAC addresses and UUIDs - these are host-specific and not secrets
- When modifying boot/kernel config, always test with `nixos-rebuild build` before switching
- `nixpkgs.config.allowUnfree = true` is set globally in `modules/packages/default.nix`
- GNOME is the primary desktop; Hyprland is also available as a compositor option
