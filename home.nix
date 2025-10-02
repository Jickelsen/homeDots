{ config, pkgs, ... }:

{
  home.username = "jickel";
  home.homeDirectory = "/home/jickel";

  home.stateVersion = "25.05";

  home.packages = [
    pkgs.hello #just a test
  ];


  wayland.windowManager.hyprland = {
    enable = false; # We still need to add the plugin configuration manually for now
    package = null;  # don’t reinstall
    extraConfig = ''
      # Plugins Configuration
      source = ~/.config/hypr/plugin-split-monitor-workspace.conf
      source = ~/.config/hypr/plugin-hyprspace.conf
    '';
  };

  home.file = let
    dots = "${config.home.homeDirectory}/Code/homeDots"; 
    link = path: config.lib.file.mkOutOfStoreSymlink "${dots}/${path}";
    linkForce = path: {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/${path}";
      force = true;
    };
  in {
      ".config/hypr/autostart.conf" = linkForce "hypr/autostart.conf";
      ".config/hypr/bindings.conf" = linkForce "hypr/bindings.conf";
      ".config/hypr/envs.conf" = linkForce "hypr/envs.conf";
      ".config/hypr/hypridle.conf" = linkForce "hypr/hypridle.conf";
      ".config/hypr/hyprlock.conf" = linkForce "hypr/hyprlock.conf";
      ".config/hypr/input.conf" = linkForce "hypr/input.conf";

      # Hyprland plugins
      ".config/hypr/plugin-hyprspace.conf" = linkForce "hypr/plugin-hyprspace.conf";
      ".config/hypr/plugin-split-monitor-workspace.conf" = linkForce "hypr/plugin-split-monitor-workspace.conf";
      ".config/waybar/config.jsonc" = linkForce "waybar/config.jsonc";

        
      # Cool screensaver
      ".config/omarchy/branding/screensaver.txt" = linkForce "omarchy/branding/screensaver.txt";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG desktop integration
  targets.genericLinux.enable = true;
  xdg.enable = true;
  xdg.mime.enable = true;
}
