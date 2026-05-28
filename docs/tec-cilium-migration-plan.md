# TEC Cilium Migration Plan

## Goal

Migrate TEC in place from k3s default Flannel/kube-router/kube-proxy networking to Cilium as:

- CNI
- NetworkPolicy engine
- kube-proxy replacement

This is a disruptive migration. Service downtime is acceptable. Data loss is not.

## Non-Goals

- Do not delete PVs.
- Do not delete hostPath data.
- Do not reinstall k3s.
- Do not add `kubectl` or `kubernetes-helm` packages.
- Do not add `--node-ip`.
- Do not add `--egress-selector-mode=cluster` unless a concrete issue requires it.
- Do not preserve k3s ServiceLB.

## Current Ground Truth

- TEC is a single-node k3s server.
- k3s currently runs Flannel VXLAN via `10-flannel.conflist`.
- k3s currently runs kube-proxy-style `KUBE-*` iptables service rules.
- k3s currently has kube-router network-policy iptables rules, despite no declared `NetworkPolicy` resources.
- `bpffs` is already mounted at `/sys/fs/bpf`.
- No live unmanaged pods were found during preflight discovery.
- Existing important data paths are hostPath and local-path PV data, not CNI-owned state.

## Nix Changes

TODO:

- Add Cilium as a k3s auto-deployed `HelmChart` manifest.
- Use OCI chart `oci://quay.io/cilium/charts/cilium`.
- Set chart version to `1.19.4`.
- Set `bootstrap = true`.
- Disable Flannel with `--flannel-backend=none`.
- Disable k3s network-policy with `--disable-network-policy`.
- Disable kube-proxy with `--disable-kube-proxy`.
- Disable ServiceLB with `--disable=servicelb`.
- Keep NixOS reverse-path firewall filtering strict, with a narrow bypass for Cilium pod veth traffic from `10.42.0.0/16` on `lxc+` interfaces and logging for reverse-path drops.
- Keep existing `--cluster-cidr=10.42.0.0/16`.
- Keep existing `--service-cidr=10.43.0.0/16`.
- Keep existing `--default-local-storage-path=/zssd/general/local-path-provisioner`.
- Keep existing `--secrets-encryption`.
- Keep existing `--disable=traefik`.
- Do not add Helm or kubectl packages.

## Cilium Values

TODO:

- Set `operator.replicas = 1`.
- Set `kubeProxyReplacement = true`.
- Set `k8sServiceHost = "10.0.0.54"`.
- Set `k8sServicePort = 6443`.
- Set pod CIDR pool to `10.42.0.0/16`.
- Set `cni.binPath = /opt/cni/bin`.
- Set `cni.confPath = /etc/cni/net.d`.
- Use `routingMode = tunnel` initially.
- Use `tunnelProtocol = vxlan` initially.

## Preflight

TODO:

- Confirm `k3s kubectl get nodes -o wide` shows only `tec`.
- Confirm no unmanaged pods exist.
- Confirm all important pods are controller-owned.
- Confirm current PVs and PVCs.
- Confirm `/zssd/general/config` is mounted.
- Confirm `/zssd/general/local-path-provisioner` is mounted.
- Confirm `/data/media` is mounted.
- Confirm `/data/torrents` is mounted.
- Build the TEC NixOS config without switching.

## Maintenance Window

TODO:

- Stop k3s.
- Back up `/var/lib/rancher/k3s/server/db`.
- Back up `/var/lib/rancher/k3s/server/manifests`.
- Snapshot or back up `zssd/general` before touching runtime/network state.
- Optionally snapshot or back up relevant `data/*` datasets.
- Run `k3s-killall.sh` to stop k3s-managed containers/runtime/network state.
- Remove stale Flannel CNI files from `/var/lib/rancher/k3s/agent/etc/cni/net.d`.
- Remove stale `/var/lib/rancher/k3s/agent/etc/flannel/net-conf.json`.
- Delete `flannel.1` if still present.
- Delete `cni0` if still present.
- Remove stale `KUBE-ROUTER` iptables and ip6tables rules.
- Remove stale `FLANNEL` iptables and ip6tables rules.
- Remove stale kube-proxy `KUBE-*` iptables and ip6tables rules.

## Activation

TODO:

- Activate the prebuilt NixOS generation.
- Wait for the k3s API to return.
- Watch Cilium `HelmChart` status.
- Wait for the Cilium DaemonSet to become available.
- Confirm Cilium reports kube-proxy replacement enabled.
- Confirm no Flannel CNI config is active.

## Workload Recycling

TODO:

- Restart all Deployments.
- Restart all StatefulSets.
- Restart DaemonSets except Cilium.
- Do not blindly delete unmanaged pods.
- Leave completed Job and CronJob pods alone unless cleanup is desired.

## Verification

TODO:

- Verify node `tec` is Ready.
- Verify expected pods are Running or Completed.
- Verify CoreDNS works.
- Verify ClusterIP service routing works.
- Verify NodePort service routing works.
- Verify Plex works on `10.0.0.54:32400`.
- Verify hostNetwork node-exporter still works.
- Verify hostPort behavior works where relevant.
- Verify CNPG webhook/API access.
- Verify local-path PVC pods mount data correctly.
- Verify qBittorrent/Gluetun still has `/dev/net/tun`.
- Verify no active Flannel CNI config remains.
- Verify kube-proxy and kube-router rules are gone or harmless leftovers only.
- Verify no `LoadBalancer` service advertises `10.0.0.54`; Cilium captures unrelated host TCP replies through that frontend.
- Verify no data-bearing paths were deleted or recreated unexpectedly.

## Rollback

TODO:

- If Cilium fails before workloads are recycled, revert NixOS to the previous generation.
- Restore Flannel/kube-proxy behavior by booting or switching back.
- Restart k3s.
- Only restore k3s state backup if the datastore or manifests are damaged.
- Do not restore over live PV or hostPath data unless explicitly required.

## Post-Migration Cleanup

TODO:

- Remove stale migration test resources.
- Decide later whether to add Cilium LB IPAM/L2 announcements.
- Decide later whether to add Hubble.
- Decide later whether to tune native routing or keep VXLAN.

## Outcome

The in-place migration to Cilium completed successfully.

- TEC is running k3s with Flannel, kube-proxy, kube-router network policy, and ServiceLB disabled.
- Cilium `1.19.4` is installed through the k3s `HelmChart` controller from `oci://quay.io/cilium/charts/cilium`.
- Cilium reports `KubeProxyReplacement: True` and uses the corrected k3s CNI paths, `/opt/cni/bin` and `/etc/cni/net.d`.
- NixOS reverse-path firewall filtering remains strict, with a narrow bypass for Cilium pod veth traffic from `10.42.0.0/16` on `lxc+` interfaces and logging for reverse-path drops.
- Immich and SMB were changed from `LoadBalancer` to `NodePort` so Cilium no longer installs `10.0.0.54` LoadBalancer frontends that capture unrelated host TCP replies.
- IPv4 SSH and TCP connectivity to `10.0.0.54` is restored for ports `22`, `2022`, `6443`, `32400`, and `32196`.
- Host egress to `1.1.1.1:443` and `ghcr.io` works.
- Pod egress to `10.43.0.1:443` and `1.1.1.1:443` works.
- Image pulls from GHCR work again.
- CoreDNS, local-path-provisioner, metrics-server, CNPG, monitoring, Immich, Cloudflared, Plex, qBittorrent, and the media workloads recovered.
- All Deployments, StatefulSets, and DaemonSets reported ready after recovery.
- No data-bearing paths, PVs, PVCs, or hostPath data were deleted.

The two material breakages during recovery were NixOS rpfilter dropping Cilium pod traffic and Cilium LoadBalancer handling of `10.0.0.54` interfering with normal host TCP replies. The rpfilter fix is intentionally scoped to Cilium pod veth traffic; reverse-path filtering remains active for other node ingress. Exploratory Cilium toggles for TCX and source-IP verification were removed; the final working Cilium config uses upstream defaults for those settings.
