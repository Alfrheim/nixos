{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.aws;

in {
    options.modules.aws = { enable = mkEnableOption "aws"; };
    config = mkIf cfg.enable {
        programs.password-store = {
            enable = true;  
            # settings = {
            #   PASSWORD_STORE_DIR ="~/.password-store/";
            #   PASSWORD_STORE_CLIP_TIME = "60";  
            # };
        };
        programs.awscli = {
            enable = true;
            settings = {  
                "default" = {
                    region = "eu-west-1";
                    output = "json";  
                };
            };
            credentials = {
                "default" = {
                    "credential_process" = "sh -c '${pkgs.pass}/bin/pass show Globick/awscli'";
                };
            };
        };
    };
}
