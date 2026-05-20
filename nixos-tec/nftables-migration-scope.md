# TEC nftables Migration Scope

Date: 2026-05-20

## Summary

Migrating TEC's NixOS host firewall to nftables looks feasible, but it is not a
simple one-option flip. The config diff should be small, but the operational
risk is moderate because Cilium and k3s still install iptables-nft compatibility
rules that must not be flushed or shadow-dropped.

The realistic goal is "NixOS host firewall managed by native nftables," not
"no iptables anywhere."

## Current State

- `networking.nftables.enable = false`.
- Host `iptables` and `ip6tables` already use the nft backend:
  `iptables v1.8.13 (nf_tables)`.
- Native `nft` is not installed in the current TEC system closure.
- `nftables.service` is absent/inactive.
- k3s has kube-proxy disabled.
- k3s/kubelet still creates some iptables-nft compatibility chains, including
  `KUBE-FIREWALL` and canary chains.
- Cilium is healthy with kube-proxy replacement enabled.
- Cilium still uses iptables-nft compatibility rules for parts of its datapath.
- Gluetun uses iptables inside the qBittorrent pod network namespace, not in the
  host namespace.

## Live Cilium State

Observed Cilium status included:

```text
KubeProxyReplacement: True
Host firewall: Disabled
Routing: Network: Tunnel [vxlan] Host: Legacy
Attach Mode: TCX
Device Mode: veth
Masquerading: IPTables [IPv4: Enabled, IPv6: Disabled]
Hubble: Ok
```

Cilium host iptables-nft compatibility rules currently include:

- mangle rules for proxy marks and DNS TPROXY.
- raw table NOTRACK rules for VXLAN and proxy traffic.
- filter table Cilium feeder chains.
- nat table masquerade/SNAT rules.

These are expected and should not be flushed by the NixOS nftables service.

## Main Risk

TEC has:

```nix
system.stateVersion = "22.05";
```

With that state version, enabling nftables would default:

```nix
networking.nftables.flushRuleset = true;
```

That would flush the whole host nft ruleset on firewall start/reload. Since
Cilium and k3s are already using iptables-nft compatibility tables in the same
host nft ruleset, that could wipe Cilium/k3s netfilter rules until they
reconcile.

Any migration must explicitly set:

```nix
networking.nftables.flushRuleset = false;
```

## Component Impact

### Gluetun

Risk: low.

Gluetun uses iptables inside the qBittorrent pod network namespace:

```text
iptables v1.8.11 (nf_tables)
```

Host nftables migration should not flush or manage that namespace. Gluetun is
not a blocker for migrating the host firewall to nftables.

### Cilium

Risk: medium.

Cilium currently still depends on iptables-nft compatibility rules for:

- pod egress masquerading.
- proxy traffic accepts.
- DNS TPROXY.
- VXLAN NOTRACK.
- Cilium feeder chains.

Native NixOS nftables can coexist with those rules, but it must not flush the
full ruleset and must not block Cilium-marked proxy traffic or Cilium-managed
pod paths.

### k3s

Risk: low to medium.

kube-proxy is disabled, which lowers risk. k3s/kubelet still creates
iptables-nft compatibility chains such as `KUBE-FIREWALL`. Those should be left
alone.

### NixOS Firewall

Risk: medium.

The current custom firewall hooks use iptables-only options:

```nix
networking.firewall.extraCommands
networking.firewall.extraStopCommands
```

Those options are incompatible with the nftables firewall backend. They need to
be replaced with nftables-native rules.

## Current Custom Rules To Port

Current iptables-specific custom rules are:

```nix
${pkgs.iptables}/bin/iptables -t mangle -C nixos-fw-rpfilter -i lxc+ -s 10.42.0.0/16 -m comment --comment "Cilium pod veth rpfilter bypass" -j RETURN 2>/dev/null \
  || ${pkgs.iptables}/bin/iptables -t mangle -I nixos-fw-rpfilter 1 -i lxc+ -s 10.42.0.0/16 -m comment --comment "Cilium pod veth rpfilter bypass" -j RETURN
${pkgs.iptables}/bin/iptables -C nixos-fw -i lxc+ -s 10.42.0.0/16 -p tcp --dport 4244 -m comment --comment "Cilium Hubble peer from pods" -j nixos-fw-accept 2>/dev/null \
  || ${pkgs.iptables}/bin/iptables -I nixos-fw 3 -i lxc+ -s 10.42.0.0/16 -p tcp --dport 4244 -m comment --comment "Cilium Hubble peer from pods" -j nixos-fw-accept
```

These exist for:

- allowing Cilium pod veth traffic through NixOS reverse-path filtering.
- allowing Hubble relay pods to reach the Cilium agent Hubble peer listener on
  `10.0.0.54:4244`.

## Likely nftables Config Shape

Approximate migration shape:

```nix
networking.nftables.enable = true;
networking.nftables.flushRuleset = false;

networking.firewall.extraCommands = "";
networking.firewall.extraStopCommands = "";

networking.firewall.extraReversePathFilterRules = ''
  iifname "lxc*" ip saddr 10.42.0.0/16 accept comment "Cilium pod veth rpfilter bypass"
'';

networking.firewall.extraInputRules = ''
  meta mark & 0xf00 == 0x200 accept comment "Cilium proxy traffic"
  iifname "lxc*" ip saddr 10.42.0.0/16 tcp dport 4244 accept comment "Cilium Hubble peer from pods"
'';
```

Also keep:

```nix
networking.firewall.filterForward = false;
```

Do not enable forward filtering unless Cilium's forwarding path is deliberately
modeled in nftables.

## Validation Checklist

After a migration, verify:

- `nft list ruleset` shows the NixOS `inet nixos-fw` table.
- `iptables-save` still shows Cilium/k3s compatibility chains.
- `nftables.service` is active.
- `firewall.service` is healthy.
- `k3s.service` remains active.
- Node remains `Ready`.
- Cilium reports `Cilium: Ok` and `KubeProxyReplacement: True`.
- Hubble reports `Hubble: Ok`.
- `hubble-relay` and `hubble-ui` are ready.
- Pod egress to external TCP works.
- Pod DNS works.
- Pod to Kubernetes API works.
- Hubble relay can connect to `hubble-peer.kube-system.svc.cluster.local:443`.
- qBittorrent WebUI still works through Cloudflared.
- qBittorrent/Gluetun VPN path still works.
- Plex on `32400` remains reachable.
- SSH on `22` remains reachable.
- Eternal Terminal on `2022` remains reachable.
- Kubernetes API on `6443` remains reachable.
- No new `rpfilter drop:` kernel logs appear for expected pod traffic.

## Recommended Safe Path

1. Build locally first with `nixos-rebuild build --flake .#tec` or equivalent.
2. Confirm NixOS' nft syntax check passes.
3. Apply during an acceptable disruption window.
4. Immediately verify both native nftables and iptables-nft compatibility state.
5. Verify Cilium, Hubble, qBittorrent/Gluetun, pod egress, DNS, SSH, ET, Plex,
   and API access.
6. Reboot-test only after the live switch is stable.

## Difficulty

- Config change difficulty: small.
- Validation difficulty: moderate.
- Operational risk: medium.

Treat this as a controlled migration with rollback ready, not as a casual
cleanup.
