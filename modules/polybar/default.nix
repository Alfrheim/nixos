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
      (nerdfonts.override {fonts = ["JetBrainsMono" "IosevkaTerm"];})
    ];

    home.file.".config/polybar/forest/" = {
      source = ./forest;
      recursive = true;
      executable = null;
    };
  };
}
