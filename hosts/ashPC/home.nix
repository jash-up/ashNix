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

  #default apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "application/pdf" = "org.kde.okular.desktop";
      "image/png" = "feh.desktop";
      "text/plain" = "nvim.desktop";
    };
  };

  programs.waybar.enable = true;

  #swaylock
  programs.swaylock = {
    enable = true;
    # Use swaylock-effects for blur, clock, and fade features
    package = pkgs.swaylock-effects; 
    
    settings = {
      # --- General ---
      image = builtins.toString /home/ash/ashNix/hosts/ashPC/sources/nasa1.png;
      scaling = "fill";
      color = "1e1e2e";             # Background color if no image/blur is used
      font = "JetBrains Mono Nerd Font"; # Make sure you have this installed!
      show-failed-attempts = true;
      indicator-caps-lock = true;
      
      # --- Effects (swaylock-effects only) ---
      clock = true;
      timestr = "%I:%M %p";
      datestr = "%A, %B %d";
      effect-blur = "7x5";          # Blurs the screen underneath
      fade-in = 0.2;                # Smooth fade in transition
      
      # --- Indicator Circle Dimensions ---
      indicator-radius = 120;
      indicator-thickness = 15;
      
      # --- Colors ---
      # Transparent inside
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";

      # Ring colors (Catppuccin Mocha inspired)
      ring-color = "b4befe";        # Lavender default ring
      ring-clear-color = "f5e0dc";  # Rosewater when clearing
      ring-caps-lock-color = "fab387"; # Peach for caps lock
      ring-ver-color = "89b4fa";    # Blue when verifying
      ring-wrong-color = "f38ba8";  # Red on wrong password

      # Text colors
      text-color = "cdd6f4";
      text-clear-color = "f5e0dc";
      text-caps-lock-color = "fab387";
      text-ver-color = "89b4fa";
      text-wrong-color = "f38ba8";

      # Remove the ugly lines between ring and inside
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      separator-color = "00000000";
    };
  };
    
  # Essential packages for a working Wayland environment
  home.packages = with pkgs; [
    mako     
    #swaylock 
    swayidle 
    wl-clipboard 
    libnotify
    xwayland-satellite
    power-profiles-daemon
    pavucontrol
    swaybg
    nomacs
    nautilus
    #brightnessctl
    anki-bin
    #checkra1n
  ];
}
