{
  description = "NixOS configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    pkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };

    nixpkgs-idea2022-2-5.url = "github:nixos/nixpkgs/1ed91531b68f820ba026e3cb8fd1e6ed40d64ee1";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      miniAlf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ./modules/system/configuration.nix
          ./configuration.nix
          # ./derivations/default.nix
          {
            nix = {
              settings.experimental-features = ["nix-command" "flakes"];
            };
          }
          {
            nixpkgs.config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];
            nixpkgs.config.packageOverrides = pkgs: {
              soapui = pkgs.callPackage ./derivations/soapui.nix {};
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alfrheim = import ./user.nix;
              extraSpecialArgs = {
                inherit inputs;
                helix-flake = inputs.helix;
                pkgsUnstable = import inputs.pkgsUnstable {
                  config.allowUnfree = true;
                  permittedInsecurePackages = [];
                };
                pkgsIdea = import inputs.nixpkgs-idea2022-2-5 {
                  config.allowUnfree = true;
                };
              };
            };
            nixpkgs.overlays = [
              (final: prev: {
                zsa-udev-rules = prev.zsa-udev-rules.overrideAttrs (old: rec {
                  version = "2.1.3";
                  src = final.fetchFromGitHub {
                    owner = "zsa";
                    repo = "wally";
                    rev = "623a50d0e0b90486e42ad8ad42b0a7313f7a37b3";
                    sha256 = "sha256-meR2V7T4hrJFXFPLENHoAgmOILxxynDBk0BLqzsAZvQ=";
                  };
                });
              })
            ];

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
            # home-manager.extraSpecialArgs = { inherit inputs; helix-flake = inputs.helix; };
          }
        ];
      };
    };
  };
}
