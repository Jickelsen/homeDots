{
  description = "Home Manager configuration of jickel";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # Define user configurations for different devices
      userConfigs = {
        # Primary user configuration
        jickel = {
          username = "jickel";  # Replace with your username
          homeDirectory = "/home/jickel";  # Replace with your home path
        };

        # Add more configurations as needed
        # work = {
        #   username = "<work-username>";
        #   homeDirectory = "/home/<work-username>";
        # };
      };

      mkHomeConfig = name: config:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            {
              home = {
                inherit (config) username homeDirectory;
                stateVersion = "25.05";
              };

              # Protect Omarchy-managed directories
              home.file.".config/omarchy".enable = false;
              home.file.".config/hypr".enable = false;
              home.file.".config/alacritty".enable = false;
              home.file.".config/btop/themes".enable = false;
            }
          ];
        };

    in
    {
      homeConfigurations = builtins.mapAttrs mkHomeConfig userConfigs;
    };
}
