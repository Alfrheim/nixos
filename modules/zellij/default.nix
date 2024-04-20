{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.zellij;
in {
  options.modules.zellij = {enable = mkEnableOption "zellij";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zellij
    ];

    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
