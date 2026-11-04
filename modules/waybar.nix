{ palette, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 28;
      spacing = 10;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "mpris" "network" "wireplumber" "memory" "cpu" "battery" "tray" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "I"; "2" = "II"; "3" = "III"; "4" = "IV"; "5" = "V";
          "6" = "VI"; "7" = "VII"; "8" = "VIII"; "9" = "IX";
        };
      };

      "hyprland/window" = {
        max-length = 40;
        separate-outputs = true;
      };

      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%A %d %B %Y}";
      };

      mpris = {
        format = "󰎆 {artist} - {title}";
        max-length = 40;
      };

      network = {
        format-wifi = "NET {essid}";
        format-ethernet = "NET eth";
        format-disconnected = "NET --";
      };

      wireplumber = {
        format = "VOL {volume}%";
        format-muted = "VOL mute";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      memory.format = "MEM {percentage}%";
      cpu.format = "CPU {usage}%";

      battery = {
        format = "BAT {capacity}%";
        format-charging = "BAT+ {capacity}%";
        states = { warning = 25; critical = 10; };
      };

      tray.spacing = 8;
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: ${palette.bg};
        color: ${palette.fg};
      }

      #workspaces button {
        padding: 0 8px;
        color: ${palette.dim};
        background: transparent;
      }

      #workspaces button.active {
        color: ${palette.bg};
        background: ${palette.accent};
      }

      #workspaces button.urgent { color: ${palette.red}; }

      #window { color: ${palette.muted}; }

      #clock { color: ${palette.accent}; }

      #mpris, #network, #wireplumber, #memory, #cpu, #battery, #tray {
        padding: 0 6px;
        color: ${palette.fg};
      }

      #battery.warning { color: ${palette.yellow}; }
      #battery.critical { color: ${palette.red}; }
    '';
  };
}
