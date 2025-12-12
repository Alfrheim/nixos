{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.polybar;
in {
  options.modules.polybar = {enable = mkEnableOption "polybar";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      polybar
      feh
      picom
      playerctl
      dmenu
      wmctrl
      # rofi
      pamixer
      brightnessctl
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka-term
    ];

    home.file.".config/polybar/forest/" = {
      source = ./forest;
      recursive = true;
      executable = null;
    };
  };
}
