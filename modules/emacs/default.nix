{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.emacs;

in {
    options.modules.emacs = { enable = mkEnableOption "emacs"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            emacs
            (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
        ];

    };
}
