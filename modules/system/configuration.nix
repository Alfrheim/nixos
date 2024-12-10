{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "miniAlf"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Remove unecessary preinstalled packages
  services.xserver.desktopManager.xterm.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.leftwm.enable = true;

  services.xserver.displayManager.defaultSession = "none+leftwm";
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "alfrheim";

  programs.zsh.enable = true;

  programs.steam.enable = true;

  # Laptop-specific packages (the other ones are installed in `packages.nix`)

  # Install fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "Iosevka" "FiraMono" "Symbols"];})
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        monospace = ["Iosevka"];
        emoji = ["OpenMoji Color"];
      };
    };
  };

  # Wayland stuff: enable XDG integration, allow sway to use brillo
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-wlr
        # xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  services.globalprotect = {
    enable = true;
  };
  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = ["alfrheim"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Boot settings: clean /tmp/, latest kernel and enable bootloader
  # Set up locales (timezone and keyboard layout)
  time.timeZone = "Europe/Andorra";

  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ca_AD.utf8";
    LC_IDENTIFICATION = "ca_AD.utf8";
    LC_MEASUREMENT = "ca_AD.utf8";
    LC_MONETARY = "ca_AD.utf8";
    LC_NAME = "ca_AD.utf8";
    LC_NUMERIC = "ca_AD.utf8";
    LC_PAPER = "ca_AD.utf8";
    LC_TELEPHONE = "ca_AD.utf8";
    LC_TIME = "ca_AD.utf8";
  };
  # Set up user and enable sudo
  users.users.alfrheim = {
    isNormalUser = true;
    extraGroups = ["input" "wheel" "docker" "plugdev" "video" "networkmanager"];
    shell = pkgs.zsh;
  };

  # Set up networking and secure it
  networking = {
    networkmanager.enable = true;
    wireless.iwd.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [443 80];
      allowedUDPPorts = [443 80 44857];
      allowPing = false;
    };
  };

  # Security
  security = {
    sudo.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["alfrheim"];
          keepEnv = true;
          persist = true;
        }
      ];
    };

    # Extra security
    protectKernelImage = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
    };
  };

  # Do not touch
  system.stateVersion = "23.11";
}
