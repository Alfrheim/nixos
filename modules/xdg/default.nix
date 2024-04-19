{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
                    xdg-desktop-portal
	];
        xdg.userDirs = {
            enable = true;
            documents = "$HOME/stuff/other/";
            download = "$HOME/stuff/other/";
            videos = "$HOME/stuff/other/";
            music = "$HOME/stuff/music/";
            pictures = "$HOME/stuff/pictures/";
            desktop = "$HOME/stuff/other/";
            publicShare = "$HOME/stuff/other/";
            templates = "$HOME/stuff/other/";
        };
    };
}
