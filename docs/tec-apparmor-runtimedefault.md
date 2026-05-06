# tec AppArmor RuntimeDefault failure

## Summary

New pods on `tec` can fail during container creation when kubelet/containerd
tries to use the implicit Kubernetes `RuntimeDefault` AppArmor profile.

Observed pod:

```text
kube-system/restarter-daily-29632920-f2r5v
```

Observed failure:

```text
failed to create containerd container: load apparmor profile /tmp/cri-containerd.apparmor.d591196244: parser error("Found reference to variable HOMEDIRS, but is never declared"): exit status 1
```

The generated profile was captured on `tec` at:

```text
/tmp/aa-copy-capture
```

It is a containerd generated profile named `cri-containerd.apparmor.d`.
The file is not pod-specific; the suffix is random and regenerated on each
attempt.

## Captured Profile

The captured profile is 51 lines. Its relevant preamble is:

```apparmor
@{PROC}=/proc/

profile cri-containerd.apparmor.d flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>
  ...
}
```

The captured profile does not reference `@{HOMEDIRS}` directly. The only
include in the generated profile is `<abstractions/base>`.

## Failure Chain

NixOS materializes AppArmor config like this:

```text
/etc/apparmor.d -> /etc/static/apparmor.d -> /nix/store/...-apparmor.d
```

The NixOS AppArmor module builds that directory from:

```nix
security.apparmor.policies
security.apparmor.includes
```

It also writes `/etc/apparmor/parser.conf`:

```text
skip-cache
cache-loc /var/cache/apparmor
Include /etc/apparmor.d
Include /nix/store/...-apparmor-profiles-4.1.7/etc/apparmor.d
```

`security.apparmor.packages = [ pkgs.apparmor-profiles ]` comes from
nixpkgs' `nixos/modules/security/apparmor/profiles.nix`.

On `tec`, `/etc/apparmor.d/abstractions/base` is a NixOS wrapper generated
from `security.apparmor.includes."abstractions/base"`. It includes the upstream
profile package base abstraction:

```apparmor
include "/nix/store/...-apparmor-profiles-4.1.7/etc/apparmor.d/abstractions/base"
```

That upstream `abstractions/base` references tunable variables:

```apparmor
owner @{HOME}/.Private/ r,
owner @{HOME}/.Private/** mrixwlk,
owner @{HOMEDIRS}/.ecryptfs/*/.Private/ r,
owner @{HOMEDIRS}/.ecryptfs/*/.Private/** mrixwlk,
```

`@{HOMEDIRS}` and `@{HOME}` are declared by `tunables/home`, which is normally
included through:

```apparmor
include <tunables/global>
```

The generated RuntimeDefault profile does not include `<tunables/global>`
before the profile block, so those variables are undefined when
`<abstractions/base>` is expanded.

## Important Parser Behavior

This parses successfully:

```apparmor
include <tunables/global>

profile aa-nix-test-preamble flags=(attach_disconnected,mediate_deleted) {
  include <abstractions/base>
}
```

This does not parse:

```apparmor
profile aa-nix-test-inside flags=(attach_disconnected,mediate_deleted) {
  include <tunables/global>
  include <abstractions/base>
}
```

The parser reports a syntax error when `tunables/global` is included inside a
profile body, because the tunables files contain variable assignments. That
means adding `include <tunables/global>` to NixOS'
`security.apparmor.includes."abstractions/base"` wrapper would not fix this
containerd profile; containerd includes `base` inside the profile body.

Patching only the `@{HOMEDIRS}` references is also insufficient. A temporary
test that replaced those with literal `/home` paths then failed on another
missing tunable, `@{pid}`. The correct fix needs the normal tunables preamble,
not a one-off replacement for a single variable.

## Why `/sbin/apparmor_parser` Exists

`nixos-tec/apparmor/default.nix` currently creates:

```nix
systemd.tmpfiles.rules = [
  "d /sbin 0755 root root -"
  "L+ /sbin/apparmor_parser - - - - ${pkgs.apparmor-parser}/bin/apparmor_parser"
];
```

This is needed because k3s' embedded containerd checks for
`/sbin/apparmor_parser` to decide whether AppArmor support is available. Having
`apparmor_parser` in `PATH` is not enough for that detection path. Before this
symlink existed, container creation failed earlier with:

```text
failed to generate apparmor spec opts: apparmor is not supported
```

With the symlink in place, containerd detects AppArmor and tries to load its
generated RuntimeDefault profile. That exposes the current parser failure.

## Likely Fixes

The clean fix is in containerd/k3s: its generated RuntimeDefault AppArmor
profile should include the normal AppArmor tunables preamble before the profile
block:

```apparmor
include <tunables/global>

profile cri-containerd.apparmor.d flags=(attach_disconnected,mediate_deleted) {
  include <abstractions/base>
  ...
}
```

A local NixOS workaround is possible because `tec` already owns the
`/sbin/apparmor_parser` compatibility path. Instead of symlinking it directly
to `${pkgs.apparmor-parser}/bin/apparmor_parser`, use a wrapper that:

1. Detects profile arguments matching `/tmp/cri-containerd.apparmor.*`.
2. Copies the generated profile to a temporary file.
3. Prepends `include <tunables/global>` to the temporary copy.
4. Invokes the real `${pkgs.apparmor-parser}/bin/apparmor_parser` with the
   rewritten path and otherwise preserves all original arguments.
5. Passes through all non-containerd AppArmor parser invocations unchanged.

That workaround is narrowly targeted at containerd's generated RuntimeDefault
profiles and keeps the k3s hardcoded `/sbin/apparmor_parser` detection working.
