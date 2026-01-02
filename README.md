This is my nixOS flake repo for using on my systems.

Things to note and do ig
1. Install new system with nix
2. open the configuration.nix file in /etc/nixos and 

add this line in the config: nix.settings.experimental-features = [ "nix-command" "flakes" ];

and add these programs: 
gnomeExtensions.caffeine (if you're on gnome, it helps cuz it takes time sometimes to install)
git
neovim

3. then rebuild system and you'll have flakes! and the programs
nixos-rebuild switch

4. Then in the home directory, clone the repo(yea, clone it, so that the hardware.nix file isnt an issue, but since its mine i can directly build tbh, for other systems clone it and add the hardware-configuration.nix file properly in its host.

Then in the flake folder run the flake rebuild
nixos-rebuild switch --flake (directory where flake is stored)#(hostname of the system you want to deploy)

eg: nixos-rebuild switch --flake ./#ashPC
    nixos-rebuild switch --flake ./#sash

5. Or if the systems hardware.nix is there, you can directly build from github, which is true in my case

nixos-rebuild switch --flake github:jash-up/nixFlake#ashPC
nixos-rebuild switch --flake github:jash-up/nixFlake#sash



---

Next, 
I want to look into the hardware-configuration.nix file and see to it that it doesn't interfere with the repo and how it works.
And I want to set up my hyprland and home-manager on this flake.
I wont be using hyprland for a while now so I won't do it now.
But later, probably in a few months I'll set up hyprland dot files as well as home manager.

#got the thing on ashPC and currently cloned on sash
#got it working on sash lesgooii