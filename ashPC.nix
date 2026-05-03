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
  networking.firewall.allowedTCPPorts = [ 8000 7000 7001 7100 8384 ];
  networking.firewall.allowedUDPPorts = [ 6000 6001 7011 ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" "drm_vkms" "vkms" ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
  '';

  #sunshine
  services.sunshine = {
    enable = true;
    autoStart=true;
    capSysAdmin=true;
    openFirewall=true;
    #cursor=enabled;
  };



  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
      obs-vaapi # For hardware-accelerated encoding (highly recommended)
    ];
  };

  # Enable v4l2loopback module
  #boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  #boot.kernelModules = [ "v4l2loopback" ];

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

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Setting timezone
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";  
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #hardware graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime-legacy1
      intel-vaapi-driver
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # enabling steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    #extraArgs = "-no-cef-sandbox";
    #extraPackages = with pkgs; [
    #  intel-media-driver
    #  vaapiIntel
    #];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/ash/.steam/root/compatibilitytools.d";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
  };

  security.polkit.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuSupport = true;
      #tcpListen = false;
    };
  };

  ## for niri
  #programs.niri.enable = true;

  #portal setup for wayland compositors
  #xdg.portal = {
  #  enable = true;
  #  extraPortals = with pkgs; [
  #    xdg-desktop-portal-gtk
  #  ];
  #  config = {
  #    niri = {
  #      default = lib.mkForce [ "gtk" ];
  #      "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "gtk" ];
  #    };
  #    common = {
  #      default = lib.mkForce [ "gtk" ];
  #    };
  #  };
  #}; 
 

  #gnome keyring
  services.gnome.gnome-keyring.enable = false;

  services.dbus.enable = true;

  #PAM
  #security.pam.services.sddm.enableGnomeKeyring = true;
  #security.pam.services.swaylock = {};

  #power-profiles
  services.power-profiles-daemon.enable = true;
  
  #thermald
  #services.thermald.enable = true;


  #Enabling ssh-agent. --Keep it disabled on gnome cuz of gnome ssh agent lol
  #programs.ssh.startAgent = true;

  #Enabling syncthing.
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "ash";
    dataDir = "/home/ash/.config/syncthing"; # Store config in your home
    configDir = "/home/ash/.config/syncthing";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ash = {
    isNormalUser = true;
    uid = 1000;
    description = "Arnav Hiwarkar";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "kvm" "adbusers" "video" ];
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

  ##system hfonts for nerdconfgd
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  #systemd.user.services.keepassxc = {
  #  description = "KeePassXC passwod manager";
  #  wantedBy = [ "default.target" ];
  #  serviceConfig = {
  #    ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
  #    Restart = "always";
  #  };
  #};

  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    fastfetch
    proton-vpn
    obsidian
    discord
    cmatrix
    tmux
    vlc
    transmission_4-gtk
    nemo
    ranger
    peaclock
    gparted
    bat
    htop
    libreoffice-still
    calibre
    cava
    qpdf
    #obs-studio
    telegram-desktop
    audacity
    feh
    google-chrome
    github-copilot-cli
    anki-bin
    android-tools
    zathura
    uxplay
    virt-manager
    inetutils
    nfs-utils
    kdePackages.okular
    prismlauncher
    brightnessctl
    libsecret
    keepassxc
    gnome-boxes
    ladybird
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    alacritty
    brave
    brave-search-cli 
    #python312
    #python312Packages.pip
    android-tools
    metasploit
    scrcpy
    nmap
    #texliveFull
    kdiskmark
    handbrake
    droidcam
    v4l-utils
  ];

  hardware.acpilight.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

}
