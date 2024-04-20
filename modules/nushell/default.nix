{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.nushell;
in {
  options.modules.nushell = {enable = mkEnableOption "nushell";};

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nushell
    ];
    programs.nushell = {
      enable = true;
    };

    programs.starship = {
      enable = true;
      # enableNushellIntegration = true;
      settings = {
        git_status = {
          disabled = false;
        };
        nix_shell = {
          format = "via [$symbol]($style)";
        };
      };
    };
  };
}
