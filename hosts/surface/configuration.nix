{ pkgs, username, hostname, ... }:

{
  # Generato sulla macchina con:
  #   nixos-generate-config --show-hardware-config > hosts/surface/hardware-configuration.nix
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.networkmanager = {
    enable = true;
    # Il Marvell 88W8897 del Surface perde spesso la connessione col risparmio energetico attivo.
    wifi.powersave = false;
  };

  # Swap compressa in RAM: niente partizione di swap da creare in installazione.
  zramSwap.enable = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "it_IT.UTF-8";
  console.keyMap = "it";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  # Hyprland a livello di sistema: driver GL, portali e sessione uwsm.
  # Il pacchetto lo fornisce questo modulo; home-manager gestisce solo la config.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Senza questo hyprlock non puo' verificare la password.
  security.pam.services.hyprlock = { };
  security.polkit.enable = true;

  # Login manager minimale (niente GDM/SDDM).
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Regole udev per brightnessctl (l'utente e' nel gruppo "video").
  services.udev.packages = [ pkgs.brightnessctl ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    git
    brightnessctl
    wireplumber # wpctl per i tasti volume
  ];

  system.stateVersion = "25.11";
}
