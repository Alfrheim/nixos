{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.emacs;
in {
  options.modules.emacs = {enable = mkEnableOption "emacs";};
  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
    };
    home.packages = with pkgs; [
      (nerdfonts.override {fonts = ["SourceCodePro"];})
    ];
  };
}
