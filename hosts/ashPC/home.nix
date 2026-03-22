{ config, pkgs, lib, inputs, ... }:

{
  home.stateVersion = "25.11"; 
  home.username = "ash";
  home.homeDirectory = "/home/ash";

  ## for niri
  xdg.configFile."niri/config.kdl".source = ./niri.kdl;

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      # Set your modifier key (Mod4 is the 'Super/Windows' key)
      modifier = "Mod4";
      
      # Use foot as a lightweight, fast Wayland terminal
      terminal = "${pkgs.foot}/bin/foot"; 
      
      # Basic startup commands
      startup = [
        { command = "${pkgs.mako}/bin/mako"; } # Notification daemon
        { command = "${pkgs.waybar}/bin/waybar"; } # Status bar
      ];

      # Simple keybindings to get you started
      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${pkgs.bemenu}/bin/bemenu-run";
        "${modifier}+q" = "kill";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'";
      };

      # Configure your output (Resolution/Refresh Rate)
      # 'output "*" bg #282828 solid_color' sets a simple background
      bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
    };
  };

  # Essential packages for a working Wayland environment
  home.packages = with pkgs; [
    foot       # Terminal
    bemenu     # Launcher
    mako       # Notifications
    waybar     # Status bar
    swaylock   # Screen locker
    swayidle   # Idle daemon
    wl-clipboard # Copy/paste utilities
  ];



}
