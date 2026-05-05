{ pkgs }:

# https://github.com/roddhjav/apparmor.d/blob/main/apparmor.d/groups/ssh/sftp-server
''
  abi <abi/4.0>,

  include <tunables/global>

  @{exec_path} = ${pkgs.openssh}/libexec/sftp-server
  profile sftp-server @{exec_path} {
    include <abstractions/base>
    include <abstractions/nameservice-strict>

    capability dac_read_search,
    capability dac_override,

    @{exec_path} mr,

    # For scp
    owner @{user_download_dirs}/{,**} rwl,
    owner @{user_sync_dirs}/{,**} rwl,

    include if exists <local/sftp-server>
  }
''
