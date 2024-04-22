{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {enable = mkEnableOption "zsh";};

  config = mkIf cfg.enable {
    # home.file."Programs/kubectl" = {
    #   source = ../../Programs/kubectl;
    #   executable = true;
    # };
    home.packages = [
      pkgs.zsh
      pkgs.grc
    ];
    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
      "$HOME/.nix-profile/bin" #binaries for non-nixOS
    ];

    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      git = true;
      icons = true;
      # enableAliases = true; # we need to remove some aliases created in zsh
      # enableFishIntegration = true;
      # enableNushellIntegration = true;
      # enableZshIntegration = true;
      extraOptions = [
        "-a"
        "--group-directories-first"
      ];
    };

    programs.fish = {
      # We can't use fish a default system shell
      # https://nixos.wiki/wiki/Fish
      enable = true;
      shellAbbrs = {
        vim = "nvim";
        cat = "bat --paging=never --style=plain";
        ls = "eza -a --icons";
        tree = "eza --tree --icons";
        ll = "ls -l";
        ".." = "cd ..";
        l = "eza";
        #l="ls  --color=auto -la";
        #grep="grep -i --color=auto";
        df = "df -H";
        du = "du -ch";
        grep = "rg";
        # diff = "colordiff";
        meminfo = "free -m -l -t";
        pscpu3 = "ps auxf | sort -nr -k 3 | head -3";
        rm = "rm --interactive --verbose --force --recursive";
        mv = "mv --interactive --verbose";
        cp = "cp --verbose --recursive";
        mkdir = "mkdir -pv";
        ifconfig = "ip -s -c -h a";
        tryPerformance = "hyperfine";
        lepton = "appimage-run ~/bin/Lepton-1.10.0.AppImage --no-sandbox";
        epicgames = "appimage-run ~/bin/Heroic-2.5.1.AppImage --no-sandbox";
        # idea = "sh ~/Programs/idea-IU-222.4554.10/bin/idea.sh";
        # datagrip = "sh ~/Programs/DataGrip-2022.2.5/bin/datagrip.sh";
        top = "btm";
        alfDisk = "lsblk -e7 -o name,label,size,fstype,fsuse%,mountpoint";
        diff = "delta --side-by-side";
        g = "git";
        awseksdev = "aws eks describe-cluster --name EksTicketDevV1| jq '.cluster.resourcesVpcConfig.publicAccessCidrs' | egrep --color -A 2 -B 2  (wget -qO- ifconfig.me)";
        awsekspre = "aws eks describe-cluster --name EksGlobickCorev1 | jq '.cluster.resourcesVpcConfig.publicAccessCidrs' | egrep --color -A 2 -B 2  (wget -qO- ifconfig.me)'";
        awsekspro = "aws eks describe-cluster --name EksGlobickCorev1PROD | jq '.cluster.resourcesVpcConfig.publicAccessCidrs' | egrep --color -A 2 -B 2  (wget -qO- ifconfig.me)";
        copy = "xclip -sel c < ";
        # template = "nix flake init --template 'github:alfrheim/nix-templates#$argv'";
      };
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "aws";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-aws";
            rev = "e53a1de3f826916cb83f6ebd34a7356af8f754d1";
            sha256 = "l17v/aJ4PkjYM8kJDA0zUo87UTsfFqq+Prei/Qq0DRA=";
          };
        }
      ];
      functions = {
        nixify = "
          nix flake init --template github:alfrheim/nix-templates#$argv;
        ";
        whatsmyip = "
          echo 'executing: wget -qO- ifconfig.me'
          set result (wget -qO- ifconfig.me)
          echo $result | xclip -selection clipboard
          echo $result
        ";
        ggbranch = "
          echo (read)|read branch
          for i in cc*
             echo $i
             cd $i
             git co $branch
             ..
           end
          ";
        ggreset = "
          for i in cc*
             echo $i
             cd $i
             git rh
             ..
           end
          ";
      };
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true; # Auto suggest options and highlights syntact, searches in history for options
      syntaxHighlighting.enable = true;
      history.size = 10000;
      history.share = false; # all terminals share the history, not individual history for terminal
      enableCompletion = true;
      autocd = true;
      cdpath = ["~/Work" "~/Projects" "~/tmp"];
      shellAliases = {
        vim = "nvim";
        cat = "bat --paging=never --style=plain";
        ls = "eza -a --icons";
        tree = "eza --tree --icons";
        ll = "ls -l";
        ".." = "cd ..";
        l = "eza";
        #l="ls  --color=auto -la";
        #grep="grep -i --color=auto";
        df = "df -H";
        du = "du -ch";
        grep = "rg";
        diff = "colordiff";
        meminfo = "free -m -l -t";
        pscpu3 = "ps auxf | sort -nr -k 3 | head -3";
        rm = "rm --interactive --verbose --force --recursive";
        mv = "mv --interactive --verbose";
        cp = "cp --verbose --recursive";
        mkdir = "mkdir -pv";
        ifconfig = "ip -s -c -h a";
        tryPerformance = "hyperfine";
        lepton = "appimage-run ~/bin/Lepton-1.10.0.AppImage --no-sandbox";
        epicgames = "appimage-run ~/bin/Heroic-2.5.1.AppImage --no-sandbox";
        idea = "sh ~/Programs/idea-IU-222.4554.10/bin/idea.sh";
        datagrip = "sh ~/Programs/DataGrip-2022.2.5/bin/datagrip.sh";
        top = "btop";
        #gitCleanBranches = "git branch | grep -v \"master\" | xargs git branch -D"; #better to keep this one like this now, cleans al branches local and remote
        clearCaches = "sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'";
      };
      initExtraFirst = ''
        nixify() {
        if [ ! -e ./.envrc ]; then
        echo "use nix" > .envrc
        direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
        cat > default.nix <<'EOF'
        with (import <nixpkgs> {});
        mkShell {
          buildInputs = [
            bashInteractive
          ];
        }
        EOF
        ${EDITOR:-vim} default.nix
        fi
        }
        flakify() {
        if [ ! -e flake.nix ]; then
        nix flake new -t github:nix-community/nix-direnv .
        elif [ ! -e .envrc ]; then
        echo "use flake" > .envrc
        direnv allow
        fi
        ${EDITOR:-vim} flake.nix
        }
      '';

      oh-my-zsh = {
        # Extra plugins for zsh
        enable = true;
        plugins = ["git" "aliases" "rust"];
        theme = "norm";
      };

      initExtra = ''
        # Spaceship
        #source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        eval "$(zoxide init zsh)"
        eval "$(starship init zsh)"
        autoload -U promptinit; promptinit
        # neofetch
        fastfetch
        fish
      ''; # Zsh theme
    };

    programs.fzf = rec {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultCommand = "rg --files --no-ignore --hidden --follow --glob '!.git/*'";
      defaultOptions = [
        "--height=40%"
        "--reverse"
      ];
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        git_status = {
          disabled = false;
        };
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        nix_shell = {
          format = "via [$symbol]($style)";
        };
      };
    };
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    /*
    programs.zsh = {
    enable = true;

    # directory to put config files in
    dotDir = ".config/zsh";

    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    # .zshrc
    initExtra = ''
    PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b |.%F{red}?) %f"

    export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
    export ZK_NOTEBOOK_DIR="~/stuff/notes";
    export DIRENV_LOG_FORMAT="";
    bindkey '^ ' autosuggest-accept

    edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
    ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
    '';

    # basically aliases for directories:
    # `cd ~dots` will cd into ~/.config/nixos
    dirHashes = {
    dots = "$HOME/.config/nixos";
    stuff = "$HOME/stuff";
    media = "/run/media/$USER";
    junk = "$HOME/stuff/other";
    };

    # Tweak settings for history
    history = {
    save = 1000;
    size = 1000;
    path = "$HOME/.cache/zsh_history";
    };

    # Set some aliases
    shellAliases = {
    c = "clear";
    mkdir = "mkdir -vp";
    rm = "rm -rifv";
    mv = "mv -iv";
    cp = "cp -riv";
    cat = "bat --paging=never --style=plain";
    ls = "exa -a --icons";
    tree = "exa --tree --icons";
    nd = "nix develop -c $SHELL";
    rebuild = "doas nixos-rebuild switch --flake $NIXOS_CONFIG_DIR --fast; notify-send 'Rebuild complete\!'";
    };

    # Source all plugins, nix-style
    plugins = [
    {
    name = "auto-ls";
    src = pkgs.fetchFromGitHub {
    owner = "notusknot";
    repo = "auto-ls";
    rev = "62a176120b9deb81a8efec992d8d6ed99c2bd1a1";
    sha256 = "08wgs3sj7hy30x03m8j6lxns8r2kpjahb9wr0s0zyzrmr4xwccj0";
    };
    }
    ];
    };
    */
  };
}
