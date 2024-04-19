{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "23.05";
    imports = [
        # gui
        ./firefox
        ./foot
        ./eww
        ./dunst
        ./hyprland
        ./wofi
        ./helix
        ./polybar
        ./leftwm
        ./rofi

        # cli
        ./nvim
        ./emacs
        ./zsh
        ./nushell
        ./git
        ./gpg
        ./direnv
        ./wezterm
        ./zellij
        ./alacritty

        #work
        ./aws

        # system
        ./xdg
	    ./packages
    ];
}
