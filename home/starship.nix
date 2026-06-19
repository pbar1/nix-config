{ lib, ... }:

{
  programs.starship.enable = true;
  programs.starship.settings = {
    format = lib.strings.concatStrings [
      "$username"
      "$hostname"
      "$directory"
      "$shell"
      "$shlvl"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_status"
      "$nix_shell"
      "$python"
      "$terraform"
      "$kubernetes"
      "$cmd_duration"
      "$custom"
      "$status"
      "$jobs"
      "$battery"
      "$time"
      "$line_break"
      "$character"
    ];

    fill = {
      disabled = true;
      symbol = " ";
    };

    username = {
      disabled = false;
      format = "[$user]($style)@";
      show_always = false;
    };

    hostname = {
      disabled = false;
      format = "[$hostname]($style):";
      ssh_only = true;
    };

    directory = {
      disabled = false;
      format = "[$path]($style)[$read_only]($read_only_style)";
    };

    shell = {
      disabled = false;
      format = " [$indicator]($style)";
      bash_indicator = "bash";
      zsh_indicator = "zsh";
      fish_indicator = ""; # Default
      powershell_indicator = "posh";
      ion_indicator = "ion";
      elvish_indicator = "elvish";
      tcsh_indicator = "tcsh";
      xonsh_indicator = "xonsh";
      unknown_indicator = "unknown";
    };

    shlvl = {
      disabled = false;
      format = "↓[$shlvl]($style) ";
    };

    git_branch = {
      disabled = true;
      format = "[$symbol $branch]($style)";
      symbol = "";
      truncation_length = 10;
      truncation_symbol = "…";
      only_attached = false;
    };

    git_commit = {
      disabled = true;
      format = " [$hash $tag]($style)";
    };

    git_status.disabled = true;

    nix_shell = {
      disabled = false;
      format = " [$symbol $name$state]($style)";
      symbol = "❄️";
      style = "bold white";
      pure_msg = "(pure)";
      impure_msg = "";
    };

    python = {
      disabled = false;
      format = " [$symbol $version]($style)";
      symbol = "";
    };

    terraform = {
      disabled = false;
      format = " [$symbol $workspace]($style)";
      symbol = "▰";
    };

    kubernetes = {
      disabled = true;
      format = " [$symbol $context:$namespace]($style)";
      symbol = "☸";
      style = "bold blue";
    };

    status = {
      disabled = false;
      symbol = "⚠";
      format = " [$symbol $common_meaning$signal_name$maybe_int]($style)";
    };

    cmd_duration = {
      disabled = false;
      format = " [$duration]($style)";
    };

    character = {
      success_symbol = "[♪]()";
      error_symbol = "[ø](red)";
      vicmd_symbol = "[♫](blue)";
    };
  };
}
