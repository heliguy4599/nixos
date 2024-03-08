{ config, pkgs, ... }:

{
  services = {
    # Enable the GNOME Desktop Environment.
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  environment = {
    # Packages installed when GNOME is the target desktop
    systemPackages = with pkgs; with gnome; with gnomeExtensions; [
      gnome-tweaks

      # GNOME Extensions to add
      screenshot-window-sizer
      rocketbar
    ];

    # Packages to exclude from the GNOME desktop
    gnome.excludePackages = with pkgs; with gnome; [
      totem
      gnome-music
      gnome-maps
    ];

    # Aliases available when GNOME is the target desktop
    shellAliases = {
      upgrade = "pkexec nixos-rebuild switch --upgrade; echo 'Done!'";
    };
  };
}
