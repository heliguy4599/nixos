{ config, pkgs, ... }:

{
  services = {
    # Enable the Cinnamon Desktop Environment.
    xserver = {
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
    };
    
    power-profiles-daemon.enable = true;
  };

  environment = {
    # Packages installed when Cinnamon is the target desktop
    systemPackages = with pkgs; [
      gnome.gnome-system-monitor
      cinnamon.nemo-with-extensions
      xdotool
      gnome.gnome-software
      flameshot
      galculator
    ];

    # Packages to exclude from the Cinnamon desktop
    cinnamon.excludePackages = with pkgs; [
      cinnamon.nemo
      cinnamon.xviewer
      gnome.gnome-calculator
      hexchat
    ];

    # Aliases available when Cinnamon is the target desktop
    shellAliases = {
      upgrade = "pkexec nixos-rebuild switch --upgrade && ( nohup cinnamon --replace >/dev/null 2>&1 & ); echo 'Done!'";
    };
  };

  xdg.portal = {
    extraPortals = with pkgs; [
      # xdg-desktop-portal-kde
      xdg-desktop-portal-gnome
    ];
    config.x-cinnamon = {
      default = [
        "xapp"
        "gtk"
        "gnome"
      ];
      "org.freedesktop.impl.portal.OpenURI" = [
        "gnome"
      ];
    };
  };
}
