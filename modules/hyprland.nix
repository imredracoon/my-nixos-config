{ palette, lib, ... }:

let
  h = c: builtins.substring 1 6 c;

  wallpaper = ../wallpapers/solitude.jpg;
  swaybgArgs =
    if builtins.pathExists wallpaper
    then "-i ${wallpaper} -m fill"
    else "-c ${palette.bg}";

  workspaceBinds = builtins.concatLists (builtins.genList (i:
    let n = toString (i + 1); in [
      "$mod, ${n}, workspace, ${n}"
      "$mod SHIFT, ${n}, movetoworkspace, ${n}"
    ]) 9);
in
{
  # Il pacchetto arriva da programs.hyprland (NixOS): qui gestiamo solo la config.
  # package = null evita versioni diverse tra modulo di sistema e home-manager.
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false; # la sessione e' gestita da uwsm

    settings = {
      "$mod" = "SUPER";

      # Surface Pro 7: 2736x1824. Scala 1.5 -> 1824x1216 logici.
      monitor = [ ",preferred,auto,1.5" ];

      exec-once = [
        "swaybg ${swaybgArgs}"
        "wl-paste --watch cliphist store"
        "uwsm app -- hyprpolkitagent"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(${h palette.accent})";
        "col.inactive_border" = "rgb(${h palette.surface2})";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 0.96;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
        shadow.enabled = false;
      };

      animations = {
        enabled = true;
        animation = [
          "windows, 1, 4, default, slide"
          "fade, 1, 4, default"
          "workspaces, 1, 4, default, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        background_color = "rgb(${h palette.bg})";
      };

      xwayland.force_zero_scaling = true;

      input = {
        kb_layout = "it";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      bind = [
        "$mod, Return, exec, uwsm app -- ghostty"
        "$mod, Space, exec, uwsm app -- fuzzel"
        "$mod, W, killactive"
        "$mod, F, fullscreen"
        "$mod, T, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, L, exec, loginctl lock-session"
        "$mod SHIFT, E, exec, uwsm stop"
        "$mod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        ", Print, exec, grim -g \"$(slurp)\" - | satty -f - --copy-command wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"
      ] ++ workspaceBinds;

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # tasti multimediali / luminosita' (wpctl da wireplumber, brightnessctl da pacman)
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
