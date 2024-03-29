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
      gnome-extension-manager
      adw-gtk3
      cinnamon.pix
      celluloid

      # GNOME Extensions to add
      screenshot-window-sizer
      rocketbar
      night-theme-switcher
      quick-settings-audio-devices-hider
      quick-settings-audio-devices-renamer
      quick-settings-audio-panel
      user-avatar-in-quick-settings
      auto-power-profile
      just-perfection
      appindicator
      panel-corners
      window-gestures
    ];

    # Packages to exclude from the GNOME desktop
    gnome.excludePackages = with pkgs; with gnome; [
      totem
      gnome-music
      gnome-maps
      gnome-shell-extensions
      epiphany
      gnome-connections
      loupe
      gnome-contacts
      gnome-tour
    ];

    # Aliases available when GNOME is the target desktop
    shellAliases = {
      upgrade = "pkexec nixos-rebuild switch --upgrade; echo 'Done!'";
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs ( old: {
          src = pkgs.fetchgit {
            url = "https://gitlab.gnome.org/vanvugt/mutter.git";
            # GNOME 45: triple-buffering-v4-45
            rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
            sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
          };
        } );
      });
    })
  ];
}
