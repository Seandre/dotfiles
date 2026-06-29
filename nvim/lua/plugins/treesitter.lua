return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = false, -- set to `false` to disable one of the mappings
        node_incremental = "<leader><leader>",
        node_decremental = "<bs>",
        scope_incremental = "<tab>",
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
