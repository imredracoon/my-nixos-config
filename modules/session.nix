{ palette, ... }:

let
  h = c: builtins.substring 1 6 c;
in
{
  # Richiede security.pam.services.hyprlock nella config di sistema.
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
      };

      background = [{
        color = "rgb(${h palette.bg})";
      }];

      input-field = [{
        size = "300, 48";
        position = "0, -80";
        halign = "center";
        valign = "center";
        outline_thickness = 2;
        rounding = 0;
        dots_center = true;
        fade_on_empty = false;
        placeholder_text = "";
        outer_color = "rgb(${h palette.dim})";
        inner_color = "rgb(${h palette.surface})";
        font_color = "rgb(${h palette.fg})";
        check_color = "rgb(${h palette.yellow})";
        fail_color = "rgb(${h palette.red})";
      }];

      label = [{
        text = "$TIME";
        position = "0, 80";
        halign = "center";
        valign = "center";
        font_size = 72;
        font_family = "JetBrainsMono Nerd Font";
        color = "rgb(${h palette.accent})";
      }];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      background-color = palette.surface;
      text-color = palette.fg;
      border-color = palette.dim;
      border-size = 2;
      border-radius = 0;
      padding = "12";
      margin = "10";
      default-timeout = 5000;
      "urgency=high" = {
        border-color = palette.red;
      };
    };
  };
}
