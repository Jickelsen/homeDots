{ config, lib, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system-manager.allowAnyDistro = true;

    environment = {
      etc = {
          "kanata/swerty.kbd".source  = ./kanata/swerty.kbd;
      };
    };

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      # settings.trusted-users = [ "jickel" ]; # No reason to add this yet
    };

    systemd.services = {
      kanata-service = {
        description = "Kanata Service";
        enable = true;
        requires=[ "local-fs.target" ];
        after=[ "local-fs.target" ];
        serviceConfig = {
          RemainAfterExit = true;
          ExecStartPre="/usr/bin/modprobe uinput";
          ExecStart="/usr/bin/kanata -c /etc/kanata/swerty.kbd";
          Restart= "always";
        };
        wantedBy = [ "sysinit.target" ];
      };
    };
  };
}
