# Tec NixOS Audit

This note is focused on future incidents in the same class as the ZFS key
ordering failure: places where the `tec` configuration depends on mutable
external state, unstable upstream defaults, or live activation behavior that
Nix does not fully model.

## Current Incident Class

The ZFS key issue was a latent undeclared dependency. The config depended on
`/keys` being mounted before encrypted ZFS pool import, but that relationship
was not encoded in systemd. There is no evidence that NixOS removed a prior
guarantee. The system appears to have been relying on boot timing that happened
to work until an upgrade changed enough of the startup behavior to expose it.

The `fileSystems."/keys".fsType` issue was separate. It blocked evaluation
until `/keys` was declared as `ext4`, but it was not the root cause of the
runtime pool import race.

The `boot.zfs.forceImportRoot` warning was also separate. `tec` does not have a
ZFS root pool, and the current config explicitly sets it to `false`.

## Findings

### `tec` Tracks `nixpkgs-unstable`

Evidence:

- `flake.nix` sets `nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"`.
- `nixosConfigurations.tec` uses that same input.

Risk:

One flake update can change the kernel, ZFS, systemd, dbus, K3s, OpenSSH,
firewall behavior, and other host-critical components together. For a host
running both storage and Kubernetes, that is a large blast radius.

Proposed direction:

Give `tec` its own stable or separately pinned Nixpkgs input, or explicitly pin
the highest-risk components.

### ZFS Uses the Default Linux Package Set

Evidence:

- `nixos-tec/hardware-configuration.nix` sets `boot.kernelPackages =
  pkgs.linuxPackages`.
- Evaluated at the time of the incident: Linux `6.18.25`, ZFS `2.4.1`, module
  package `zfs-kernel-2.4.1-6.18.25`.

Risk:

ZFS is an out-of-tree kernel module. Build failures are usually caught, but
runtime/import regressions can still be severe. Following the default latest
kernel package set increases the chance of crossing a ZFS compatibility edge
during a routine flake update.

Proposed direction:

Pin `tec` to a conservative kernel line, likely an LTS-compatible package set,
instead of following `pkgs.linuxPackages`.

### K3s Upgrades Are Implicit

Evidence:

- `nixos-tec/default.nix` enables `services.k3s`.
- `services.k3s.package` is not pinned.
- Evaluated at the time of the incident: `k3s 1.35.2+k3s1`.

Risk:

K3s moves whenever Nixpkgs moves. Kubernetes upgrades can change API behavior,
embedded containerd behavior, storage behavior, CNI behavior, and bundled
component behavior.

Proposed direction:

Pin `services.k3s.package`, or pin the entire `tec` Nixpkgs input and upgrade
K3s deliberately.

### `task tec` Uses `switch`

Evidence:

- `Taskfile.yml` runs `nixos-rebuild switch --sudo --flake ~/nix-config#tec`.

Risk:

`switch` is convenient for low-risk changes, but it is the wrong default for
kernel, ZFS, systemd, dbus, and K3s changes. During the incident, NixOS itself
recommended `nixos-rebuild boot` because of a dbus implementation switch
inhibitor.

Proposed direction:

Make `task tec` default to `nixos-rebuild boot`, and reserve live switching for
an explicit lower-level task.

### K3s Lifecycle Is Not Graceful Enough for This Host

Evidence:

- The rendered `k3s.service` has `KillMode=process`.
- Evaluated `services.k3s.gracefulNodeShutdown.enable = false`.
- During recovery, stopping K3s left container processes running.

Risk:

Live service changes and manual stops can leave workloads or container runtime
processes behind. That makes recovery less predictable and can hide which
generation or runtime state is actually active.

Proposed direction:

Enable K3s graceful node shutdown, and treat K3s/runtime changes as reboot
events rather than live switches.

### Firewall Exposure Is Broader Than the Hand-Written List

Evidence:

- `nixos-tec/default.nix` explicitly opens TCP `2022`, `6443`, `10250`, and
  `32400`.
- Evaluated firewall state also includes TCP `22` and UDP `60000-61000`.
- `22` comes from OpenSSH opening the firewall.
- The UDP range comes from Mosh opening the firewall.

Risk:

The effective firewall is broader than the local list suggests. Also, the
`10250` comment says "Kubernetes - Metrics Server", but `10250` is the kubelet
HTTPS port. In-cluster metrics-server generally does not require exposing that
port to the LAN.

Proposed direction:

Make implicit firewall openings explicit in the config, and remove `10250`
unless an external client truly needs direct kubelet access.

### Storage Health Checks Are Under-Modeled

Evidence:

- `smartmontools` is installed as a package.
- Evaluated `services.smartd.enable = false`.
- Evaluated `services.zfs.autoScrub.enable = false`.
- Evaluated `services.zfs.zed.enableMail = false`.
- Evaluated `services.zfs.trim.enable = true`.

Risk:

The host can suffer disk or ZFS degradation without Nix declaring routine
health checks or notifications. This is not the same class as the boot ordering
incident, but it is a high-impact storage-host gap.

Proposed direction:

Enable ZFS scrubs, SMART monitoring, and a notification path for storage
events.

### Boot Generation Retention Is Unbounded

Evidence:

- Evaluated `boot.loader.systemd-boot.configurationLimit = null`.
- Nix GC is weekly with `--delete-older-than=30d`.

Risk:

Frequent host updates can leave many boot entries and kernels around until GC.
If `/boot` fills, rebuilds or bootloader updates can fail at the worst time.

Proposed direction:

Set a bounded `boot.loader.systemd-boot.configurationLimit`, likely around `10`
or `20`.

## Suggested Priority

1. Pin or stabilize the `tec` Nixpkgs input.
2. Make `task tec` use `nixos-rebuild boot` by default.
3. Pin the kernel package set and K3s package.
4. Remove unnecessary kubelet firewall exposure.
5. Enable storage health checks and alerting.
6. Configure graceful K3s shutdown behavior.
7. Bound systemd-boot generation retention.
