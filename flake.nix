{
  description = "NixOS configuration";
  # Need to learn from:
  # https://github.com/Misterio77/nix-config/tree/main
  # https://github.com/Misterio77/nix-starter-configs

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    pkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix/master";
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };

    nixpkgs-idea2022-2-5.url = "github:nixos/nixpkgs/1ed91531b68f820ba026e3cb8fd1e6ed40d64ee1";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "i686-linux"
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forEachSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forEachSystems (pkgs: import ./pkgs {inherit pkgs;});
    overlays = import ./overlays {inherit inputs;};
    nixosConfigurations = {
      miniAlf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            nix = {
              settings.experimental-features = ["nix-command" "flakes"];
            };
          }
          {
            nixpkgs.config.permittedInsecurePackages = [
              "electron-25.9.0"
              "electron-27.3.11"
            ];
            # nixpkgs.config.packageOverrides = pkgs: {
            # soapui = pkgs.callPackage ./derivations/soapui.nix {};
            # };
            nixpkgs.config.packageOverrides = pkgs: {
              roam = pkgs.callPackage ./derivations/roam.nix {};
              helium = pkgs.callPackage ./derivations/helium.nix {};
            };
          }
          {
            nixpkgs.overlays = [
              outputs.overlays.unstable-packages
              outputs.overlays.additions
              outputs.overlays.modifications
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alfrheim = import ./user.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                helix-flake = inputs.helix;
                zen-browser-flake = inputs.zen-browser.packages.x86_64-linux.default;
                pkgsUnstable = import inputs.pkgsUnstable {
                  config.allowUnfree = true;
                };
                pkgsIdea = import inputs.nixpkgs-idea2022-2-5 {
                  config.allowUnfree = true;
                };
              };
            };
          }
        ];
      };
      silverAlf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            nix = {
              settings.experimental-features = ["nix-command" "flakes"];
            };
          }
          {
            nixpkgs.config.permittedInsecurePackages = [
              "electron-25.9.0"
              "electron-27.3.11"
            ];
            # nixpkgs.config.packageOverrides = pkgs: {
            # soapui = pkgs.callPackage ./derivations/soapui.nix {};
            # };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alfrheim = import ./user.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                helix-flake = inputs.helix;
                pkgsUnstable = import inputs.pkgsUnstable {
                  config.allowUnfree = true;
                };
                pkgsIdea = import inputs.nixpkgs-idea2022-2-5 {
                  config.allowUnfree = true;
                };
              };
            };
            nixpkgs.overlays = [
              outputs.overlays.unstable-packages
              outputs.overlays.additions
              outputs.overlays.modifications
            ];
          }
        ];
      };
    };
  };
}
