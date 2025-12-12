{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.rofi;
in {
  options.modules.rofi = {enable = mkEnableOption "rofi";};
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = false;
    };
    home.packages = with pkgs; [
      rofi
    ];

    home.file.".config/rofi/" = {
      source = ./rofi;
      recursive = true;
      executable = null;
    };
  };
}
