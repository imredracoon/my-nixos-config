{ palette, ... }:

let
  # fuzzel vuole RRGGBBAA senza "#"
  c = col: (builtins.substring 1 6 col) + "ff";
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        prompt = "'> '";
        width = 40;
        lines = 10;
        horizontal-pad = 20;
        vertical-pad = 14;
        inner-pad = 8;
      };
      colors = {
        background = c palette.bg;
        text = c palette.fg;
        match = c palette.accent;
        selection = c palette.surface2;
        selection-text = c palette.bright;
        selection-match = c palette.accent;
        border = c palette.dim;
      };
      border = {
        width = 2;
        radius = 0;
      };
    };
  };
}
