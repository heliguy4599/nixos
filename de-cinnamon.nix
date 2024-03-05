{ config, pkgs, ... }:

{
  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Packages included only when Cinnamon is the target desktop
  environment.systemPackages = with pkgs; [
    gnome.gnome-system-monitor
    cinnamon.nemo-with-extensions
  ];

  environment.cinnamon.excludePackages = with pkgs; [
    cinnamon.nemo-with-extensions
  ];

  environment.shellAliases = {
    upgrade = "pkexec nixos-rebuild switch --upgrade && ( nohup cinnamon --replace >/dev/null 2>&1 & ); echo 'Done!'";
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-kde
    libportal-gtk4
    libportal-gtk3
    libportal-qt5
    libportal
  ];

  services.power-profiles-daemon.enable = true;
}
