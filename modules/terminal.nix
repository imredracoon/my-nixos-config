{ palette, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-padding-x = 10;
      window-padding-y = 10;
      window-decoration = false;
      confirm-close-surface = false;

      background = palette.bg;
      foreground = palette.fg;
      cursor-color = palette.accent;
      selection-background = palette.surface2;
      selection-foreground = palette.bright;

      palette = [
        "0=${palette.surface}"
        "1=${palette.red}"
        "2=${palette.green}"
        "3=${palette.yellow}"
        "4=${palette.blue}"
        "5=${palette.magenta}"
        "6=${palette.cyan}"
        "7=${palette.fg}"
        "8=${palette.dim}"
        "9=${palette.red}"
        "10=${palette.green}"
        "11=${palette.yellow}"
        "12=${palette.blue}"
        "13=${palette.magenta}"
        "14=${palette.cyan}"
        "15=${palette.bright}"
      ];
    };
  };
}
