# Nix Config AGENTS.md

This is a Nix flake that tracks my Nix configuration for a few devices. It
uses nix-darwin for macOS, Home Manager for some home configuration as a
nix-darwin module, and nixvim for Neovim configuration for a standalone `nvim`
package build. It also manages a homelab config using NixOS.

## Directories

- `darwin/`: This is arguably the most important. It has my personal machine
  config from `nix-darwin`, and it includes a `home-manager` module to import
  the stuff in `home/`. This is run with `task mac`.
- `home/`: This is my home directory configuration. It is config for a
  `home-manager` module. This is currently only used by the macOS stuff.
- `home-ng/`: This is a prior version of the home directory stuff that is only
  used by the `nixos-tec/` stuff. Don't pay any attention to this.
- `keyboard/`: This only has my Kanata keyboard config. It can be pretty much ignored.
- `nixos/`: This is my old NixOS config. It's not actively maintained, and it
  can't be tested, but it isn't high risk of breakage.
- `nixos-tec/`: This is my homelab config. This is the HIGHEST risk for
  breakage. We cannot break this, and it cannot be used for destructive
  testing.
- `packages/`: This has packages that I want to expose within the flake as top
  level packages. It currently only includes my Nixvim config for Neovim, which
  is consumed in the `home/` config.
- `scripts/`: This just includes some arbitrary scripts. This can safely be
  ignored.

## Files

- `Taskfile.yml`: This is the entrypoint. We must call the tasks in this file
  to do any actions. For example, `task mac` which enacts the nix-darwin config.
- `flake.nix`: This is the Nix flake root. This is the Nix file that fans out
  into all the rest.

## Coding Standards

We MUST write clean code. We do not write AI slop here:

- Code should not be overly verbose and complex if a simple solution would suffice.
- Comments should be used sparingly. For example, to show intent of _why_ instead
  of _what_. Self-explanatory code should not be commented. If there are existing
  comments on a line or block of code, they should be maintained and not arbitrarily
  deleted.
- We prefer the flat, non-nested style of Nix code. Curly brackets are the enemy.
  We write code with the style of `foo.bar.baz = ...` rather than nesting things
  within blocks of curly brackets. We do this because we want things to be supremely
  greppable. We do not go overboard on this, and end it at the point where the module
  doesn't expose any more config options. The Neovim config in this repo is a good
  example of how we write code.
