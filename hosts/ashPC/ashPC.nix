{ config, pkgs, ... }:

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
  i18n.defaultLocale = "en_IN";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Setting up plex
  services.plex = {
	enable = false;
	openFirewall = true;

  };

  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuSupport = true;
      #tcpListen = false;
    };
  };

  #systemd.services.plexmediaserver.wantedBy = [ ];

  #hardware.opengl.enable = true;
  #services.xserver.videoDrivers = [ "intel" ];

  #users.users.plex.extraGroups = [
  #	"video"
  #];

  #Enabling ssh-agent. --Keep it disabled on gnome cuz of gnome ssh agent lol
  #programs.ssh.startAgent = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  #Enabling syncthing.
  services.syncthing = {
	enable = true;
	user = "ash";
	group = "users";
	dataDir = "/home/ash/.config/syncthing";
  };

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ash = {
    isNormalUser = true;
    description = "Arnav Hiwarkar";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "kvm" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Enabling openssh
  services.openssh.enable = true;
  
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
      ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
