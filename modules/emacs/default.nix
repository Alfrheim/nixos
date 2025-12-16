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
      # extraPackages = epkgs: [epkgs.magit];
    };
    home.packages = with pkgs; [
      python311Packages.pytest
      libtool
      cmake
      cargo
      rustc
      nixfmt-classic
      pipenv
      shellcheck
      isort
      fd
      clj-kondo
      clojure-lsp
      cljfmt
      neil
      (nerdfonts.override {fonts = ["SourceCodePro" "NerdFontsSymbolsOnly"];})
    ];
  };
}
