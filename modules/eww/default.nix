{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.eww;
in {
  options.modules.eww = {enable = mkEnableOption "eww";};

  config = mkIf cfg.enable {
    # theres no programs.eww.enable here because eww looks for files in .config
    # thats why we have all the home.files

    # eww package
    home.packages = with pkgs; [
      feh
      picom
      playerctl
      dmenu
      wmctrl
      # rofi
      eww
      pamixer
      brightnessctl
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    # home.file.".config/eww/" = {
    #     source = ./eww-bar;
    #     recursive = true;
    #     executable = null;
    # };
  };
}
