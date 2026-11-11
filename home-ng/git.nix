let
  userName = "Pierce Bartine";
  userEmail = "piercebartine@gmail.com";
  signingKey = (import ../data/ssh-keys.nix).opGit;
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
