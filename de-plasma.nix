{ config, pkgs, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # Packages included only when Plasma is the target desktop
  environment.systemPackages = with pkgs; with pkgs.kdePackages; [
    merkuro
    kmail
    kmail-account-wizard
    akonadi
    pimcommon
    kdepim-addons
    kalk
    kcalc
    partitionmanager
    libappindicator
    libappindicator-gtk2
    libappindicator-gtk3
    kde-rounded-corners
    adw-gtk3
    dragon
    papirus-icon-theme
  ];

  environment.shellAliases = {
    nixcon = "kwrite /etc/nixos/configuration.nix; pkexec nixos-rebuild switch && ( rm /home/heliguy/.cache/ksycoca6*; kbuildsycoca6; nohup plasmashell --replace & ); echo 'Done!'";
    upgrade = "pkexec nixos-rebuild switch --upgrade && ( rm /home/heliguy/.cache/ksycoca6*; kbuildsycoca6; nohup plasmashell --replace & ); echo 'Done!'";
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    libportal-gtk4
    libportal-gtk3
    libportal-qt5
    libportal
  ];

  security.pam.services.sddm.enableGnomeKeyring = true;
}
