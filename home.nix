{ config, pkgs, lib, inputs, ... }:

{
  home.stateVersion = "25.11"; 
  home.username = "ash";
  home.homeDirectory = "/home/ash";

  #for fonts
  fonts.fontconfig.enable = true;

  #fuzzel
  #programs.fuzzel = {
  #  enable = true;
  #  settings = {
  #    main = {
  #      font = "JetBrainsMono Nerd Font:size=12";
  #	terminal = "${pkgs.foot}/bin/foot";
  #      prompt = "λ  ";
  #      layer = "overlay";
  #    };
  #    colors = {
  #      background = "1e1e2eff"; # Catppuccin Mocha-ish colors
  #      text = "cdd6f4ff";
  #      match = "f38ba8ff";
  #      selection = "585b70ff";
  #      selection-text = "cdd6f4ff";
  #      border = "b4befeff";
  #    };
  #    border = {
  #      width = 2;
  #      radius = 10;
  #    };
  #  };
  #};

  home.packages = with pkgs; [
    #inputs.zen-browser.packages."${system}".default
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "jash-up";
      user.email = "asharnav2008@gmail.com";
      init.defaultBranch = "main";
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
    };

    #delta.enable = true;
  };

  programs.delta.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "*" = {
        extraOptions = {
          "HashKnownHosts" = "yes";
        };
      };
    };
  };

  targets.genericLinux.enable = true;

  # syncthng
  #services.syncthing = {
  #  enable = true;
    #user = "ash";
    #group = "users";
    #dataDir = "/home/ash/.config/syncthing";
  #};
}
