{
  pkgs,
  lib,
  config,
  helix-flake,
  pkgsUnstable,
  ...
}:
with lib; let
  cfg = config.modules.helix;
in {
  options.modules.helix = {enable = mkEnableOption "helix";};
  config = mkIf cfg.enable {
    # they broke this file, again...
    #home.file.".config/helix/languages.toml".source = ./config/languages.toml;
    home.packages = with pkgs;
      [
        jq
        lazygit
        gitui #terminal git manager aka Magit
        lf # terminal filemanager
        projectable #terminal file manager for projects
        zig
        lldb
        haskell-language-server
        gopls
        cmake-language-server
        zls
        android-file-transfer

        shfmt
        rustfmt
        broot
        rust-analyzer
        pyright
        # rnix-lsp
        kotlin-language-server
        sumneko-lua-language-server
        taplo-lsp
        taplo-cli
        yaml-language-server
        tree-sitter
        stylua
        black
        lua
        jdt-language-server
        #python-lsp-server
        omnisharp-roslyn
        #nix formating
        nixpkgs-review
        nix-index
        pkgsUnstable.nil
        pkgsUnstable.alejandra
      ]
      ++ (with pkgs.nodePackages; [
        bash-language-server
        vscode-json-languageserver
        typescript-language-server
        vscode-css-languageserver-bin
        vscode-html-languageserver-bin
        dockerfile-language-server-nodejs
        vue-language-server
        yaml-language-server
        node2nix
        markdownlint-cli2
        prettier
      ]);
    programs.helix = {
      enable = true;
      defaultEditor = true;
      package = helix-flake.packages.${pkgs.system}.default;
      #package = pkgsUnstable.helix;
      extraPackages = [
        pkgs.marksman
      ];

      languages = {
        language = [
          {
            name = "nix";
            formatter = {command = "alejandra";};
            auto-format = true;
          }
          {
            name = "jsonc";
            formatter = {
              command = "prettier";
              args = ["--parser" "json"];
            };
          }
          # {
          #   name = "scheme";
          #   formatter = {command = "alejandra";};
          #   auto-format = true;
          # }
        ];

        language-server.vscode-json-language-server = {
          command = "vscode-json-languageserver";
          args = ["--stdio"];
          config.provideFormatter = true;
          config.json.validate.enable = true;
        };
        # language-server.scheme-language-server = {
        # command = "${typescript-language-server}/bin/typescript-language-server";
        # args = ["--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"];
        # };
      };

      settings = {
        theme = "ayu_mirage";
        editor = {
          line-number = "relative";
          bufferline = "multiple";
          auto-pairs = true;
          true-color = true;
          cursorline = true;
          lsp.display-messages = true;

          idle-timeout = 50;
          # we need to wait for the future release
          completion-timeout = 50; # this one will substitute idle-timeout, that will still exists butwill be used for other UI timeouts
          jump-label-alphabet = "oeuidhtns;qjkxbmwvz',.pyfgcrl";

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides = {
            render = true;
            character = "│";
          };

          soft-wrap = {
            enable = true;
            max-wrap = 25;
            max-indent-retain = 0;
            wrap-indicator = "↪ ";
          };

          file-picker.hidden = false;

          statusline = {
            left = ["mode" "spinner"];
            center = ["file-name"];
            right = [
              "workspace-diagnostics"
              "diagnostics"
              "selections"
              "position"
              "total-line-numbers"
              "spacer"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];
            separator = "│";
          };
        };

        keys.normal = {
          esc = ["collapse_selection" "keep_primary_selection"];
          C-A-down = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          C-A-up = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          C-g = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
          space = {
            s = ":w";
            m = ":format";
            q = ":q!";
            space = "file_picker";
            n = ":new";
          };

          "'" = {
            m = ":pipe snippet-cli";
            t = ":sh just tests";
            r = ":sh just run";
            j = ":sh just --init";
          };

          # q.q = ":q!";
          C-j = [
            "move_line_down"
            "move_line_down"
            "move_line_down"
            "move_line_down"
            "move_line_down"
          ];
          C-k = [
            "move_line_up"
            "move_line_up"
            "move_line_up"
            "move_line_up"
            "move_line_up"
          ];
          C-e = "scroll_down";
          C-y = "scroll_up";
          C-c = ["toggle_comments" "move_visual_line_down"];
        };
        keys.select = {
          C-j = [
            "extend_line_down"
            "extend_line_down"
            "extend_line_down"
            "extend_line_down"
            "extend_line_down"
          ];
          C-k = [
            "extend_line_up"
            "extend_line_up"
            "extend_line_up"
            "extend_line_up"
            "extend_line_up"
          ];
        };
      };
    };
  };
}
