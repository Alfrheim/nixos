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
        # lsp-ai
        scls
        android-file-transfer
        black
        broot
        cmake-language-server
        gitui #terminal git manager aka Magit
        gopls
        haskell-language-server
        jdt-language-server
        jq
        kotlin-language-server
        lazygit
        lf # terminal filemanager
        lldb_18
        lua
        pkgsUnstable.markdown-oxide
        #nix formating
        nix-index
        nixpkgs-review
        omnisharp-roslyn
        pkgsUnstable.alejandra
        pkgsUnstable.nil
        projectable #terminal file manager for projects
        pyright
        #python-lsp-server
        # rnix-lsp
        rust-analyzer
        rustfmt
        shfmt
        stylua
        sumneko-lua-language-server
        taplo-cli
        taplo-lsp
        tree-sitter
        yaml-language-server
        zig
        zls
        fish-lsp
        clojure-lsp
        hyprls
        postgres-lsp
        semgrep
      ]
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        markdownlint-cli2
        node2nix
        prettier
        typescript-language-server
        vscode-langservers-extracted
        vscode-json-languageserver
        vue-language-server
        yaml-language-server
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
          {
            name = "html";
            formatter = {
              command = "prettier";
              args = ["--parser" "html"];
            };
          }
          {
            name = "markdown";
            formatter = {
              command = "prettier";
              args = ["--parser" "markdown"];
            };
            roots = ["."];
            language-servers = ["scls" "marksman" "markdown-oxide"];
          }
          {
            name = "rust";
            language-servers = ["scls" "rust-analyzer"];
          }
          {
            name = "clojure";
            formatter = {
              command = "clojure-lsp";
              args = ["format"];
            };
            language-servers = ["scls" "clojure-lsp"];
          }
          {
            name = "java";
            language-servers = ["scls" "jdtls"];
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

        language-server.jdtls = {
          command = "jdtls";
          args = ["--jvm-arg=-javaagent:/home/alfrheim/Programs/lombok.jar"];
        };
        language-server.scls = {
          command = "simple-completion-language-server";
          config = {
            max_completion_items = 20; # set max completion results len for each group: words, snippets, unicode-input
            snippets_first = true; # completions will return before snippets by default
            snippets_inline_by_word_tail = false; # suggest snippets by WORD tail, for example text `xsq|` become `x^2|` when snippet `sq` has body `^2`
            feature_words = true; # enable completion by word
            feature_snippets = true; # enable snippets
            feature_unicode_input = true; # enable "unicode input"
            feature_paths = true; # enable path completion
            feature_citations = false; # enable citation completion (only on `citation` feature enabled)
          };
          environment = {
            RUST_LOG = "info,simple-completion-language-server=info";
            LOG_FILE = "/tmp/completion.log";
          };
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
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
          };
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
          ret = ["goto_word"];
          x = ["extend_line_below"];
          X = ["extend_line_above"];
          space = {
            # s = ":w";
            f = ":format";
            q = ":q!";
            space = "file_picker";
            n = ":new";
            m = {
              d = "@xs\\[ \\]<ret>c[x]<esc><ret>";
              u = "@xs\\[x\\]<ret>c[ ]<esc><ret>";
              n = "@i- [ ] _personal_ ChangeMe";
              # c = ["extend_to_line_bounds" "select_regex" "\[ \]" "replace" "\[x\]"];
              t = ":pipe LC_TIME=en_US.UTF-8 date +\"%a %b %d\"";
            };
          };

          "'" = {
            m = ":pipe snippet-cli";
            d = ":sh just deploy";
            b = ":sh just build";
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
