{ config, pkgs, lib, inputs, ... }:

{
  home.stateVersion = "25.11"; 
  home.username = "ash";
  home.homeDirectory = "/home/ash";

  ## for niri
  xdg.configFile."niri/config.kdl".source = ./niri.kdl;

  #for fonts
  fonts.fontconfig.enable = true;

  #cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  #fuzzel
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
	terminal = "${pkgs.foot}/bin/foot";
        prompt = "λ  ";
        layer = "overlay";
      };
      colors = {
        background = "1e1e2eff"; # Catppuccin Mocha-ish colors
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };


  programs.waybar.enable = true;
    
  # Essential packages for a working Wayland environment
  home.packages = with pkgs; [

    mako     
    swaylock 
    swayidle 
    wl-clipboard 
    libnotify
    brightnessctl
    xwayland-satellite
    power-profiles-daemon
    pavucontrol
    swaybg
  ];
}
