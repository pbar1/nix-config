{ pkgs, ... }:

{
  # TODO: K3s containerd checks for /sbin/apparmor_parser to enable AppArmor
  systemd.tmpfiles.rules = [
    "d /sbin 0755 root root -"
    "L+ /sbin/apparmor_parser - - - - ${pkgs.apparmor-parser}/bin/apparmor_parser"
  ];

  security.apparmor.enable = true;

  security.apparmor.policies.plex.state = "complain";
  security.apparmor.policies.plex.profile = ''
    abi <abi/4.0>,

    include <tunables/global>
    profile plex flags=(attach_disconnected,mediate_deleted) {
      include <abstractions/base>
      include <abstractions/nameservice>
      include <abstractions/openssl>
      include <abstractions/ssl_certs>

      network inet stream,
      network inet6 stream,
      network inet dgram,
      network inet6 dgram,
      network netlink raw,
      network netlink dgram,
      network unix stream,
      network unix dgram,

      / r,
      /{bin,sbin,usr/bin,usr/sbin,usr/local/bin,usr/local/sbin}/{,**} r,
      /{lib,lib64,usr/lib,usr/lib64,usr/libexec,usr/local/lib}/{,**} r,
      /usr/lib/plexmediaserver/{,**} mrix,
      /{sbin,usr/sbin}/ldconfig ix,
      /{sbin,usr/sbin}/ldconfig.real ix,

      /etc/{passwd,group,hosts,hostname,resolv.conf,nsswitch.conf,localtime} r,
      /etc/ssl/{,**} r,
      /usr/share/zoneinfo/{,**} r,
      @{PROC}/ r,
      @{PROC}/{self,thread-self}/** r,
      @{PROC}/[0-9]*/{,**} r,
      @{PROC}/{cpuinfo,meminfo,stat,uptime,version,loadavg,mounts,filesystems} r,
      @{PROC}/net/{,**} r,
      @{PROC}/sys/{kernel,net}/{,**} r,
      @{sys}/ r,
      @{sys}/{class,devices,fs/cgroup}/{,**} r,

      /dev/ r,
      /dev/{null,zero,full} rw,
      /dev/{random,urandom} r,
      /dev/shm/{,**} rwkl,

      /config/{,**} rwkl,
      "/config/Library/Application Support/Plex Media Server/Codecs/**" m,
      "/config/Library/Application Support/Plex Media Server/Codecs/**/EasyAudioEncoder" ix,
      /transcode/{,**} rwkl,
      /run/{,lock/{,**},systemd/{,container}} rwkl,
      /{tmp,var/tmp}/{,**} rwkl,
      /{movies,tv,audiobooks,music,youtube}/{,**} r,
    }
  '';
}
