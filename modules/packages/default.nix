{
  pkgs,
  lib,
  config,
  inputs,
  pkgsIdea,
  pkgsUnstable,
  ...
}:
with lib; let
  cfg = config.modules.packages;
  screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
  bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
  maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';
  # pkgsUnstable = import <nixpkgs-unstable> {config = { allowUnfree = true; }; };
  # pkgsUnstable = import inputs.pkgsUnstable {config = { allowUnfree = true; permittedInsecurePackages = ["electron-25.9.0"]; }; };
  # pkgsUnstable = import inputs.pkgsUnstable {config = { allowUnfree = true; permittedInsecurePackages = []; }; };
  # alfpkgs = import inputs.alfpkgs {config = { allowUnfree = true; permittedInsecurePackages = []; }; };
  # kftray = packages.kftray;
  # datagrip = pkgs.callPackage ../../derivations/datagrip.nix;
in {
  options.modules.packages = {enable = mkEnableOption "packages";};
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
    programs.tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 10000;
      keyMode = "vi";
      newSession = true;
      tmuxp.enable = false;
      tmuxinator.enable = false;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''
        # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"
        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        set -g status-position top
        set -s escape-time 0
      '';
    };
    home.packages = with pkgs; [
      # packages.kftray
      # rofi
      pkgsUnstable.atac #we use unstable instead of our package. We keep ours in case they stop updating
      kftray
      gnome.file-roller
      figlet # terminal banners
      steam
      arandr
      networkmanagerapplet
      brave
      fastfetch
      enpass
      zathura
      p7zip
      mplayer
      vlc
      openvpn
      redshift
      geoclue2 #redshift dependency
      blueman
      # spotify
      pkgsUnstable.youtube-music # so far the audio is not working, seems similar to the problem with microsoft edge
      ncspot
      pkgsUnstable.flameshot
      distrobox #pods of distros to run apps
      exercism

      just

      # wally-cli #for ergodox keyboard firmware
      pywal

      gnumake

      bashmount # to mount easy
      nnn

      pkgsUnstable.obsidian
      pkgsUnstable.logseq
      albert
      copyq
      feh
      gnomeExtensions.caffeine
      pasystray
      pulsemixer

      pamixer
      gxkb

      pavucontrol
      sysstat
      xorg.xkill
      xorg.xbacklight

      pkgsUnstable.tdesktop
      pkgsUnstable.signal-desktop
      pkgsUnstable.discord
      skypeforlinux
      pkgsUnstable.microsoft-edge #sound not working, can't find alsa, need to install throught .deb meanwhile

      jdk21
      soapui
      # datagrip
      pkgsIdea.jetbrains.datagrip
      xclip # for copy to clipboard
      kubectl
      kubectx
      pkgsUnstable.lens
      awscli2
      postgresql_15 # we need in order to make a copy of the db to the local one. Maybe we can put that into the shell file
      powershell

      niv
      procs
      bat
      bottom
      hyperfine
      bandwhich
      unzip

      qutebrowser
      nodejs

      #work
      #jetbrains.idea-ultimate
      pkgsIdea.jetbrains.idea-ultimate #version 2022.2.5
      jetbrains.idea-community
      google-chrome
      #jetbrains.rider
      #jetbrains.webstorm
      # jetbrains.datagrip
      #remmina
      pkgsUnstable.postman
      httpie

      appimage-run
      wmctrl

      ripgrep
      ffmpeg
      tealdeer
      btop
      fzf
      gnupg
      bat
      grim
      slurp
      slop
      imagemagick
      age
      libnotify
      python3
      lua
      zig
      mpv
      pqiv
      screen
      bandw
      maintenance
      # wf-recorder

      #thunar
      xfce.exo # thunar "open terminal here"
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      xfce.tumbler # thunar thumbnails
      xfce.xfce4-volumed-pulse
      xfce.xfconf # thunar save setting
    ];
  };
}
