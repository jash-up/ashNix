{ config, pkgs, inputs, lib, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
    ];
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "ashPC";

  # Enabling some ports
  networking.firewall.allowedTCPPorts = [ 8000 7000 7001 7100 ];
  networking.firewall.allowedUDPPorts = [ 6000 6001 7011 ];

  # Setting up flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Allowing certain unsafe packages
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];

  # Setting timezone
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
  };

  # Enable the X11 windowing system. 
  # This is REQUIRED for the "GNOME on Xorg" option to exist.
  #services.xserver.enable = true;

  # SDDM Configuration
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  #Gnome
  #services.desktopManager.gnome.enable = true;

  #KDE plasma
  #services.desktopManager.plasma6.enable = true;

  # some ssh auth thing between gnome and kde
  #programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  # KDE buffering stuff
  #environment.variables = {
  #  KWIN_DRM_DISABLE_TRIPLE_BUFFERING = "1";
  #};

  ## for sway

  #hardware graphics
  hardware.graphics.enable = true;

  #sway enabling
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraPackages = with pkgs; [
      swaybg
      wl-clipboard
      fuzzel
      foot
      i3status
      brightnessctl
    ];
  };

  security.polkit.enable = true;

  ## for hyprland
  #programs.hyprland.enable = true;

 
  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuSupport = true;
      #tcpListen = false;
    };
  };

  ## for niri
  programs.niri.enable = true;


  #Enabling ssh-agent. --Keep it disabled on gnome cuz of gnome ssh agent lol
  #programs.ssh.startAgent = true;

  #Enabling syncthing.
  services.syncthing = {
	enable = false;
	user = "ash";
	group = "users";
	dataDir = "/home/ash/.config/syncthing";
  };

  # Enabling NFS client - this opens it on boot, id otn want that
  #fileSystems."/mnt/ashShare" = {
  #  device = "192.168.0.181:/srv/nfs/ashShare";
  #  fsType = "nfs";
  #  options = [
  #    "nfsvers=4"
  #    "rw"
  #    #"x-systemd.automount" # this puts it after boot, still not very usefull
  #    "nofail"
  #    "_netdev"
  #    "noatime"
  #    "hard"
  #    "intr"
  #  ];
  #};

  # Making the nfs flake setting passwordless
  security.sudo.extraRules = [
    {
      users = [ "ash" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/mount";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/umount";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ]; 

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ash = {
    isNormalUser = true;
    uid = 1000;
    description = "Arnav Hiwarkar";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "kvm" "adbusers" ];
    packages = with pkgs; [
      thunderbird
    ];
  };
  # Install firefox.
  programs.firefox.enable = true;

  # Enabling openssh
  services.openssh.enable = true;

  # Enabling tailscale
  services.tailscale.enable = true;

  # smb server
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
	"server string" = "NixOS Server";
	"security" = "user";


      };

      "PDF's" = {
        "path" = "/home/ash/Study_server";
	"browseable" = "yes";
	"read only" = "no";
	"guest ok" = "no";
	"valid users" = "ash";
	"create mask" = "0644";
	"directory mask" = "0755";
      };
    };
  };

  ## enablingn avahi for ipad
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  
  environment.systemPackages = with pkgs; [
    neovim
    wget
    fastfetch
    keepassxc
    syncthing
    obsidian
    git
    cmatrix
    tmux
    kitty
    vlc
    transmission_4-gtk
    virt-manager
    gnomeExtensions.caffeine
    gnome-tweaks
    nemo
    ranger
    peaclock
    thunar
    gparted
    bat
    htop
    alacritty
    libreoffice-still
    calibre
    discord
    protonvpn-gui
    peaclock
    thunar
    gparted
    inetutils
    nfs-utils
    cava
    #jellyfin
    #jellyfin-web
    #jellyfin-ffmpeg
    jellyfin-media-player
    codeblocks
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ytui-music
    android-tools
    scrcpy
    metasploit
    nmap
    pdfcpu
    qpdf
    xorg.libX11
    xorg.libxkbfile
    obs-studio
    xkeyboard_config
    telegram-desktop
    pmbootstrap
    scrcpy
    android-tools
    cheese
    uxplay
    audacity
    kdePackages.okular
    kdePackages.dolphin
    nerdfetch
    prismlauncher
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}

