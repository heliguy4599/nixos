{ config, pkgs, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # Packages included only when Plasma is the target desktop
  environment.systemPackages = with pkgs; with pkgs.kdePackages; [
    pimcommon
    kdepim-addons
    kcalc
    partitionmanager
    adw-gtk3
    dragon
    papirus-icon-theme
    gnome.gnome-calendar
  ];

  # environment.plasma6.excludePackages = with pkgs; [
  #   libsForQt5.ksshaskpass
  # ];

  environment.shellAliases = {
    upgrade = "pkexec nixos-rebuild switch --upgrade && ( rm /home/heliguy/.cache/ksycoca6*; kbuildsycoca6; nohup plasmashell --replace >/dev/null 2>&1 & ); echo 'Done!'";
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    libportal-gtk4
    libportal-gtk3
    libportal-qt5
    libportal
  ];
}
