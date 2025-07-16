{
  pkgs,
  lib,
  config,
  inputs,
  pkgsIdea,
  zen-browser-flake,
  pkgsUnstable,
  ...
}:
with lib; let
  cfg = config.modules.packages;
  screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
  bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
  maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';
  # pkgsUnstable = import <nixpkgs-unstable> {config = { allowUnfree = true; }; };
  pkgsUnstable = import inputs.pkgsUnstable {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = ["electron-25.9.0" "electron-27.3.11"];
    };
  };
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
    gtk.cursorTheme = {
      package = pkgs.catppuccin-cursors.latteBlue;
      name = "latteBlue";
    };
    home.pointerCursor = let
      getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 48;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${pkgs.fetchzip {
            url = url;
            hash = hash;
          }} $out/share/icons/${name}
        '';
      };
    in
      getFrom
      "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
      "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
      "Fuchsia-Pop";
    home.packages = with pkgs; [
      # emacs
      # packages.kftray
      # rofi
      # yai #TUI for AI, need token
      # catppuccin-cursors.latteBlue
      pkgsUnstable.atac #we use unstable instead of our package. We keep ours in case they stop updating
      pkgsUnstable.ollama
      # kftray
      # pkgsUnstable.warp-terminal
      zen-browser-flake
      pkgsUnstable.zed-editor
      file-roller
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
      # ncspot
      pkgsUnstable.youtube-music # so far the audio is not working, seems similar to the problem with microsoft edge
      pkgsUnstable.flameshot
      distrobox #pods of distros to run apps
      exercism

      just

      # wally-cli #for ergodox keyboard firmware
      pywal

      gnumake

      nnn

      # podman

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
      #pkgsUnstable.microsoft-edge #sound not working, can't find alsa, need to install throught .deb meanwhile

      jdk21
      pkgsUnstable.soapui
      # datagrip
      pkgsIdea.jetbrains.datagrip
      xclip # for copy to clipboard
      kubectl
      kubectx
      pkgsUnstable.lens

      # TUI tools
      k9s # lens alternative
      xh # httpie / curl alternative
      bashmount # to mount easy
      ytermusic #youtube music TUI
      yazi # file manager
      slumber # httpclient
      serie # git log --graph but prettier
      gobang # sql IDE
      jwt-cli # jwt decoder
      pkgsUnstable.jwtinfo
      logss #logs viewer
      rainfrog # datagrip tui

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

      # CLOJURE
      boot
      clojure
      leiningen
      babashka
      # graalvm-ce

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
