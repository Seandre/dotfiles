return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard",
      transparent_mode = true,
      overrides = {
        Normal = { fg = "#ffffff", bg = "NONE" },
        NormalNC = { fg = "#ffffff", bg = "NONE" },
        SignColumn = { bg = "NONE" },
        EndOfBuffer = { fg = "#ffffff", bg = "NONE" },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
