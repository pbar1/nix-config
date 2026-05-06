let
  userName = "Pierce Bartine";
  userEmail = "piercebartine@gmail.com";
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDim41ofReCgbmijkayBsFg5TlO9qqV8b6Y8Xcwnr49m github";
in
{
  programs.git.enable = true;
  programs.git.signing.format = "ssh";
  programs.git.signing.key = signingKey;
  programs.git.signing.signByDefault = true;
  programs.git.settings = {
    user.name = userName;
    user.email = userEmail;
  };
}
