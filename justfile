default:
    echo 'Hello, world!'

build:
     sudo nixos-rebuild switch --flake ".#miniAlf" --impure
     notify-send "build finished!"

build-trace:
     sudo nixos-rebuild switch --flake ".#miniAlf" --impure --show-trace

update:
     sudo nix-channel --update
     nix flake update
     notify-send "nix update done!"

clean:
     sudo nix-collect-garbage -d
     sudo nix-store --optimise
     notify-send "nix clean done!"

remove-old:
     sudo nix-collect-garbage --delete-older-than 2d
     notify-send "nix clean garbage done!"
