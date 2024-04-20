{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.alacritty;
in {
  options.modules.alacritty = {enable = mkEnableOption "alacritty";};
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
    };
    home.file.".config/alacritty/alacritty.yml" = {
      source = ./alacritty.yml;
      recursive = false;
      executable = null;
    };
  };
}
