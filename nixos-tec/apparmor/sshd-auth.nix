{ pkgs }:

# https://github.com/roddhjav/apparmor.d/blob/main/apparmor.d/groups/ssh/sshd-auth
''
  abi <abi/4.0>,

  include <tunables/global>

  @{exec_path} = ${pkgs.openssh}/libexec/sshd-auth
  profile sshd-auth @{exec_path} {
    include <abstractions/base>
    include <abstractions/nameservice-strict>

    capability dac_override,
    capability setgid,
    capability setuid,
    capability sys_chroot,

    network inet dgram,
    network inet stream,
    network inet6 dgram,
    network inet6 stream,
    network netlink raw,

    unix type=stream peer=(label=sshd-session),

    @{exec_path} mr,
    @{sbin}/sshd.hmac r,

    /etc/gss/mech.d/{,*} r,

    include if exists <local/sshd-auth>
  }
''
