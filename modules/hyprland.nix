{ palette, ... }:

let
  h = c: builtins.substring 1 6 c;

  wallpaper = ../wallpapers/solitude.jpg;
  swaybgArgs =
    if builtins.pathExists wallpaper
    then "-i ${wallpaper} -m fill"
    else "-c ${palette.bg}";
in
{
  # Il pacchetto arriva da programs.hyprland (NixOS): qui gestiamo solo la config.
  # package = null evita versioni diverse tra modulo di sistema e home-manager.
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false; # la sessione e' gestita da uwsm

    # Config nativa Lua (~/.config/hypr/hyprland.lua). Il modulo di home-manager
    # traduce `settings` in chiamate hl.<nome>(...), ma non gestisce variabili,
    # cicli e opzioni dei bind: per questo la config e' scritta come Lua in extraConfig.
    configType = "lua";

    extraConfig = ''
      local mod = "SUPER"

      -- Surface Pro 7: 2736x1824. Scala 1.5 -> 1824x1216 logici.
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.5 })

      hl.env("XCURSOR_SIZE", "24")

      hl.on("hyprland.start", function()
        hl.exec_cmd("swaybg ${swaybgArgs}")
        hl.exec_cmd("wl-paste --watch cliphist store")
        hl.exec_cmd("uwsm app -- hyprpolkitagent")
      end)

      hl.config({
        general = {
          gaps_in = 4,
          gaps_out = 10,
          border_size = 2,
          layout = "dwindle",
          col = {
            active_border = "rgb(${h palette.accent})",
            inactive_border = "rgb(${h palette.surface2})",
          },
        },
        decoration = {
          rounding = 0,
          active_opacity = 1.0,
          inactive_opacity = 0.96,
          blur = { enabled = true, size = 6, passes = 2 },
          shadow = { enabled = false },
        },
        animations = { enabled = true },
        dwindle = { pseudotile = true, preserve_split = true },
        misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          background_color = "rgb(${h palette.bg})",
        },
        xwayland = { force_zero_scaling = true },
        input = {
          kb_layout = "it",
          follow_mouse = 1,
          touchpad = { natural_scroll = true },
        },
      })

      -- Applicazioni
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("uwsm app -- ghostty"))
      hl.bind(mod .. " + space", hl.dsp.exec_cmd("uwsm app -- fuzzel"))
      hl.bind(mod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"))
      hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

      -- Finestre
      hl.bind(mod .. " + W", hl.dsp.window.close())
      hl.bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Workspace
      for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      -- Screenshot
      hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty -f - --copy-command wl-copy]]))
      hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

      -- Tasti multimediali e luminosita'
      local media = { locked = true, repeating = true }
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), media)
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), media)
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), media)
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    '';
  };
}
