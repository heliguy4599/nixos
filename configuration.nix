# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # DESKTOP_SWITCHER_SCRIPT_REPLACE_NEXT_LINE
      /etc/nixos/de-gnome.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  users.users.heliguy = {
    isNormalUser = true;
    description = "Heliguy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Try to fix Flatpaks
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };

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
  system.stateVersion = "23.11"; # Did you read the comment?

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # Boot list
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
    initrd.kernelModules = [ "amdgpu" ];
  };
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # Environment list
  environment = {
    shellAliases = {
      flt = "flattool";
      installed = "nix-store -q --references /var/run/current-system/sw | cut -d'-' -f2- | grep -i";
      nixcon = "codium /etc/nixos/";
      switch = "sudo nixos-rebuild switch";
    };
    sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
    };
    localBinInPath = true;
  };
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # System list
  system = {
    autoUpgrade.enable = true;
    autoUpgrade.operation = "boot";
    fsPackages = [ pkgs.bindfs ];
  };
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # Programs list
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Add deps for random binaries here
      ];
    };
    git.enable = true;
#    seahorse.enable = true;
#    ssh.askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  };
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # Custom SystemD services list
  # systemd.user.services = {
  #   auto_power_profiles = {
  #     enable = true;
  #     description = "Heli's service to change power profiles depending on battery state";
  #     serviceConfig.ExecStart = "%h/.local/bin/auto_power_profiles.sh";
  #     serviceConfig.User = "heliguy";
  #     wantedBy = [ "default.target" ];
  #   };
  # };
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # Services list
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      videoDrivers = [ "amdgpu" ];
      xkb = { # Configure keymap in X11
        layout = "us";
        variant = "";
      };
    };
    input-remapper.enable = true;
    supergfxd.enable = true;
    flatpak.enable = true;
    printing.enable = true; # Enable CUPS to print documents.
    fwupd.enable = true; # Enable Firmware Upgrading
    # gnome.gnome-keyring.enable = true;
  };
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  # Packages list - available in every desktop
  environment.systemPackages = with pkgs; [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
      withTTS = true;
    })
    wget
    gnome.geary
    gparted
    brave
    vscodium #-fhs
    distrobox
    podman
    python3
    meson
    flatpak-builder
    prismlauncher
    filezilla
    android-tools
    android-studio
    gnome.dconf-editor
    davinci-resolve
    mangohud
    ninja
    glib
    gettext
    cmake
    pkg-config
    blueprint-compiler
    gtk3
    gtk4
    desktop-file-utils
    gnome.gnome-boxes
    gnome-builder
    gobject-introspection
    gobject-introspection-unwrapped
    xorg.xeyes
    gnome-firmware
    deja-dup
    # inotify-tools
  ];
  # <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Misc options
  nixpkgs.config.allowUnfree = true;
  fonts.fontDir.enable = true;
  virtualisation.containers.enable = true;
  xdg.portal.enable = true;
  nix.gc.automatic = true;

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
