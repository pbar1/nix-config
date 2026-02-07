{ pkgs, ... }:

{
  cat = "bat";
  copy = if pkgs.stdenv.isDarwin then "pbcopy" else "wl-copy --trim-newline";
  l = "eza --header --all --long --git";
  ls = "eza";
  tree = "eza --tree";
  yktog = "ykman config usb --list | grep --quiet OTP && ykman config usb --force --disable=otp || ykman config usb --force --enable=otp";
}
