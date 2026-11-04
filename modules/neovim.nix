{ pkgs, palette, ... }:

let
  # Palette base16 per mini.base16, derivata da theme/palette.nix.
  solitudeLua = ''
    local M = {}

    function M.setup()
      require("mini.base16").setup({
        palette = {
          base00 = "${palette.bg}",
          base01 = "${palette.surface}",
          base02 = "${palette.surface2}",
          base03 = "${palette.dim}",
          base04 = "${palette.muted}",
          base05 = "${palette.fg}",
          base06 = "${palette.accent}",
          base07 = "${palette.bright}",
          base08 = "${palette.red}",
          base09 = "${palette.orange}",
          base0A = "${palette.yellow}",
          base0B = "${palette.green}",
          base0C = "${palette.cyan}",
          base0D = "${palette.blue}",
          base0E = "${palette.magenta}",
          base0F = "${palette.brown}",
        },
        use_cterm = false,
      })
      vim.g.colors_name = "solitude"

      -- Bordi netti e fondo uniforme, come il resto del desktop.
      local set = vim.api.nvim_set_hl
      set(0, "WinSeparator", { fg = "${palette.dim}", bg = "${palette.bg}" })
      set(0, "FloatBorder", { fg = "${palette.dim}", bg = "${palette.bg}" })
      set(0, "NormalFloat", { bg = "${palette.bg}" })
      set(0, "CursorLine", { bg = "${palette.surface}" })
      set(0, "CursorLineNr", { fg = "${palette.accent}", bold = true })
    end

    return M
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      mini-nvim
      nvim-web-devicons
      lualine-nvim
      telescope-nvim
      oil-nvim
      gitsigns-nvim
      which-key-nvim
      blink-cmp
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];

    # Server LSP e dipendenze, disponibili solo dentro neovim.
    extraPackages = with pkgs; [
      nixd
      nixfmt
      lua-language-server
      bash-language-server
      ripgrep
      fd
      gcc
    ];

    initLua = builtins.readFile ../nvim/init.lua;
  };

  xdg.configFile."nvim/lua/solitude.lua".text = solitudeLua;
}
