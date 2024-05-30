{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.git;
  gitcontents = "sh -c '${pkgs.pass}/bin/pass show Globick/gitcredentials'";

  readSecret = path: builtins.readFile path; # We do that for the time being. Need to put properly in the secrets
in {
  options.modules.git = {enable = mkEnableOption "git";};
  config = mkIf cfg.enable {
    services.gpg-agent = {
      defaultCacheTtl = 86400;
      defaultCacheTtlSsh = 86400;
    };
    programs.git = {
      enable = true;
      userName = "Alfrheim";
      userEmail = "1399702+Alfrheim@users.noreply.github.com";
      # https://github.com/NobbZ/nixos-config/blob/8848aa0cc4d65d7960ec2c8535e33d212e6691d2/home/modules/profiles/development/default.nix#L70-L76
      includes = [
        {
          condition = "gitdir:~/Work/**";
          contents = {
            user.name = "marc-badia";
            user.email = readSecret /home/alfrheim/.globickemail;
          };
        }
      ];
      delta = {
        enable = true;
        options = {
          side-by-side = true;
          light = false;
          navigate = true;
        };
      };
      ignores = [
        ".envrc"
        ".direnv"
        ".idea"
      ];
      aliases = {
        br = "branch --color -v";
        cl = "clone";
        cm = "commit -m";
        ca = "commit --amend";
        ammend = "commit --amend -C HEAD";
        dc = "diff --cached";
        ds = "diff --staged";
        dh = "diff HEAD";
        co = "checkout";
        cob = "checkout -b";
        st = "status";
        rh = "reset HEAD --hard";
        undo = "reset --soft HEAD^";
        pl = "!git --no-pager log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative -n 20";
        graph = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold cyan)%h%C(reset) - %C(green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      };
      extraConfig = {
        pull.rebase = true;
        rebase.autosquash = true;
        push.autoSetupRemote = true;
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github-default" = {
          hostname = "github.com";
          user = "Alfrheim";
          extraOptions.IdentityFile = "~/.ssh/id_rsa";
        };
        codecommit-globick = lib.hm.dag.entryAfter ["github-default"] {
          host = "git-codecommit.*.amazonaws.com";
          hostname = "git-codecommit.eu-west-1.amazonaws.com";
          user = readSecret /home/alfrheim/.awsuser;
          extraOptions = {
            IdentityFile = "~/.ssh/codecommit_rsa";
            AddKeysToAgent = "yes";
          };
        };
        github-alfrheim = lib.hm.dag.entryAfter ["codecommit-globick"] {
          hostname = "github.com";
          user = "Alfrheim";
          extraOptions = {
            IdentityFile = "~/.ssh/id_ed25519";
            AddKeysToAgent = "yes";
          };
        };
      };
    };
  };
}
