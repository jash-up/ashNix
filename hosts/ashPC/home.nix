{ config, pkgs, lib, ... }:

{
  #sate verson
  home.stateVersion = "25.11";

  home.username = "ash";
  home.homeDirectory = "/home/ash";

  
  #user packages
  home.packages = with pkgs; [
    # add user packages
  ];

  # sway dotfiles
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      menu = "fuzzel";

      #keybinds
      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
	"${modifier}+d" = "exec ${menu}";
	"${modifier}+q" = "kill";
	"${modifier}+Shift+e" = "exec swaymsg exit";
      };

      #satus bar
      bars = [ 
        { statusCommand = "${pkgs.i3status}/bin/i3status"; }
      ];
    };
  };

}
