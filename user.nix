{ config, lib, inputs, ...}:

{
    imports = [
         ./modules/default.nix
         #./virtualisation.nix
         #./system-report-changes.nix
     ];
    config.modules = {
        # gui
        firefox.enable = false;
        foot.enable = false;
        eww.enable = true;
        polybar.enable = true;
        dunst.enable = true;
        hyprland.enable = true;
        wofi.enable = true;
        helix.enable = true;

        # cli
        nvim.enable = true;
        emacs.enable = true;
        zsh.enable = true;
        nushell.enable = true;
        git.enable = true;
        gpg.enable = true;
        direnv.enable = true;
        wezterm.enable = true;
        zellij.enable = false;
        alacritty.enable = true;
        rofi.enable = true;

        #work
        aws.enable = true;

        # system
        leftwm.enable = true;
        xdg.enable = false;
        packages.enable = true;
    };
}
