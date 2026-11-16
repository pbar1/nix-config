abi <abi/3.0>,

#include <tunables/global>

profile smartctl-exporter flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>

  capability sys_rawio,
  network inet stream,
  network inet6 stream,
  network unix stream,

  /bin/smartctl_exporter rix,
  /usr/sbin/smartctl rix,
  /lib/** mr,
  /usr/lib/** mr,
  /usr/share/smartmontools/** r,
  /etc/{passwd,group,nsswitch.conf,hosts,resolv.conf,gai.conf,localtime,smart_drivedb.h} r,
  /var/lib/smartmontools/drivedb/drivedb.h r,

  /dev/smartctl/wwn-0x50014ee2bec4207c r,
  /dev/smartctl/wwn-0x50014ee2be7b716f r,
  /dev/smartctl/wwn-0x50014ee2696e30d3 r,
  /dev/smartctl/wwn-0x5002538870004962 r,

  @{PROC}/ r,
  @{PROC}/@{pid}/** r,
  @{PROC}/{stat,meminfo,uptime,loadavg} r,
  @{PROC}/sys/kernel/{osrelease,random/boot_id} r,
  /sys/devices/system/cpu/{online,possible,present} r,
  /sys/kernel/mm/transparent_hugepage/hpage_pmd_size r,
  /sys/fs/cgroup/** r,

  signal (send,receive) peer=smartctl-exporter,
  signal (receive) peer=unconfined,
  signal (receive) peer=runc,
  signal (receive) peer=cri-containerd.apparmor.d,
  ptrace (read,readby) peer=smartctl-exporter,

  deny /dev/{mem,kmem,port} rwklm,
  deny /dev/cpu/** rwklm,
  deny @{PROC}/kcore rwklm,
  deny mount,
  deny umount,
}
