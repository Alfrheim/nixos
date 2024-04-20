{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.wezterm;
in {
  options.modules.wezterm = {enable = mkEnableOption "wezterm";};
  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = ''
        -- $ figlet Wezterm
        -- __        __       _
        -- \ \      / /__ ___| |_ ___ _ __ _ __ ___
        --  \ \ /\ / / _ \_  / __/ _ \ '__| '_ ` _ \
        --   \ V  V /  __// /| ||  __/ |  | | | | | |
        --    \_/\_/ \___/___|\__\___|_|  |_| |_| |_|
        --
        -- wezterm conig

         local config = {}
         if wezterm.config_builder then config = wezterm.config_builder() end

         config.font = wezterm.font_with_fallback{"IosevkaTerm Nerd Font", "Fira Code", "JetBrains Mono"}
         -- https://wezfurlong.org/wezterm/config/font-shaping.html#advanced-font-shaping-options
         -- https://github.com/ryanoasis/nerd-fonts/tree/2.1.0/patched-fonts/Iosevka
         config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", "zero", "ss01", "cv05", "type"}
         config.font_size = 16.0
         config.color_scheme = "Ayu Mirage"
           -- color_scheme = "Tomorrow Night"
         config.hide_tab_bar_if_only_one_tab = true
         -- config.default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" }
         config.keys = {
           {key="\\", mods="SHIFT|CTRL|ALT", action=wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
           {key="-", mods="SHIFT|CTRL|ALT", action=wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
           {key="h", mods="SHIFT|CTRL|ALT", action=wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
           {key="v", mods="SHIFT|CTRL|ALT", action=wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
           {key="m", mods="SUPER", action=wezterm.action.DisableDefaultAssignment },
         }
         return config
      '';
    };
    home.packages = with pkgs; [
    ];
    # home.file.".config/wezterm/wezterm.lua".source = ./wezterm.lua;
  };
}
