# Notes

Updated Fish on macOS, may need to fix some files:

```
fish: upgraded to version 4.3:
* Color variables are no longer set in universal scope by default.
  Migrated them to global variables set in ~/.config/fish/conf.d/fish_frozen_theme.fish
  To restore syntax highlighting in other fish sessions, please restart them.
* The fish_key_bindings variable is no longer set in universal scope by default.
  Migrated it to a global variable set in  ~/.config/fish/conf.d/fish_frozen_key_bindings.fish
See also the release notes (type `help relnotes`).
```
