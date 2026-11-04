{ pkgs, username, ... }:

{
  imports = [
    ./modules/hyprland.nix
    ./modules/session.nix
    ./modules/waybar.nix
    ./modules/launcher.nix
    ./modules/terminal.nix
    ./modules/neovim.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    packages = with pkgs; [
      # utility del desktop
      swaybg
      wl-clipboard
      cliphist
      grim
      slurp
      satty
      playerctl
      hyprpolkitagent

      # TUI per rete, bluetooth e audio
      impala
      bluetui
      wiremix

      # CLI
      git
      gh
      ripgrep
      fd
      fzf
      jq
      btop
      fastfetch

      # font
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];

    pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      gtk.enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
}
