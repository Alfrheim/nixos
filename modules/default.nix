{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.stateVersion = "23.05";
  imports = [
    # gui
    ./firefox
    ./foot
    ./dunst
    ./hyprland
    ./wofi
    ./helix
    ./polybar
    ./leftwm
    ./rofi

    # cli
    ./nvim
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
