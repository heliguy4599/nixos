{ config, pkgs, ... }:

{
  services = {
    # Enable the KDE Plasma Desktop Environment.
    xserver = {
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };
  };

  environment = {
    # Packages installed when Plasma is the target desktop
    systemPackages = with pkgs; with pkgs.kdePackages; [
      pimcommon
      kdepim-addons
      kcalc
      partitionmanager
      adw-gtk3
      dragon
      papirus-icon-theme
      gnome.gnome-calendar
      xwaylandvideobridge
    ];

    # Packages to exclude from the Plasma desktop
    # plasma6.excludePackages = with pkgs; [
    #
    # ];

    # Aliases available when Plasma is the target desktop
    shellAliases = {
      upgrade = "pkexec nixos-rebuild switch --upgrade && ( rm /home/heliguy/.cache/ksycoca6*; kbuildsycoca6; nohup plasmashell --replace >/dev/null 2>&1 & ); echo 'Done!'";
    };
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
}
