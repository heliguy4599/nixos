{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Packages included only when GNOME is the target desktop
  environment.systemPackages = with pkgs; with gnome; [
    gnome-tweaks
  ];

  environment = {
    shellAliases = {
      nixcon = "xed /etc/nixos/configuration.nix; pkexec nixos-rebuild switch; echo 'Done!'";
      upgrade = "pkexec nixos-rebuild switch --upgrade; echo 'Done!'";
    };
    gnome.excludePackages = with pkgs; with gnome; [
      totem
      gnome-music
      gnome-maps
    ];
  };
}
