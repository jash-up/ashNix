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
  networking.hostName = "sash";

  # Enabling flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enabling networking
  networking.networkmanager.enable = true;

  # Allowing unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allowing unsafe packages(some)
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];

  # Timezone
  time.timeZone = "Asia/Kolkata";

  # Locales and shit
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

  # Enabling X11 windowing server
  services.xserver.enable = true;

  # Setting up plex
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      #qemuSupport = true;
      #tcpListen = false;
    };
  };

  # Enabling GDM
  services.displayManager.gdm.enable = true;
  
  # Enabling gnome
  services.desktopManager.gnome.enable = true;

  # Syncthing
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

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    fastfetch
    cmatrix
    keepassxc
    #syncthing  # I probably dont need this cuz we enables it as a services up top, same thing with firefox ig
    obsidian
    git
    gnome-boxes
    tmux
    bat
    htop
    kitty
    alacritty
    libreoffice-still
    vlc
    calibre
    discord
    kdePackages.kdenlive
    transmission_4-gtk
    virt-manager
    qemu
    gnomeExtensions.caffeine
    gnome-tweaks
    protonvpn-gui
    nemo
    ranger
    qutebrowser
    telegram-desktop
    fzf
    eza
    gimp2-with-plugins
    handbrake
    tor
    freecad
    wireshark
    nmap
    aircrack-ng
    metasploit
    burpsuite
    hashcat
    #john
    ffmpeg_7-full
    peaclock
    inetutils
    thunar
    gparted
    cowsay
  ];

  # Check the proper system state version
  system.stateVersion = "25.11";

}
