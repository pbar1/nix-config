''
  abi <abi/4.0>,

  include <tunables/global>

  profile kata-cloud-hypervisor /nix/store/*-cloud-hypervisor-*/bin/cloud-hypervisor flags=(attach_disconnected) {
    include <abstractions/base>

    /nix/store/** mr,
    /nix/store/*-kata-images-*/share/kata-containers/*.image rk,
    /dev/{kvm,vhost-net,vhost-vsock,net/tun} rw,
    /sys/devices/system/cpu/{,**} r,
    /sys/kernel/mm/transparent_hugepage/{,**} r,
    /sys/fs/cgroup/{,**} r,
    @{PROC}/{cpuinfo,meminfo,sys/vm/overcommit_memory} r,

    owner /run/vc/vm/{,**} rwk,

    network unix stream,
    network unix dgram,
    signal (receive) peer=unconfined,
    signal (send,receive) peer=kata-cloud-hypervisor,
    ptrace (readby) peer=unconfined,
  }
''
