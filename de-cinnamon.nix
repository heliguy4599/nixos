{ config, pkgs, ... }:

{
  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Packages included only when Cinnamon is the target desktop
#   environment.systemPackages = with pkgs; [
#
#   ];

  environment.shellAliases = {
    upgrade = "pkexec nixos-rebuild switch --upgrade; echo 'Done!'";
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-kde
    libportal-gtk4
    libportal-gtk3
    libportal-qt5
    libportal
  ];
}
