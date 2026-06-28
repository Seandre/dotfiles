return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    win = {
      no_overlap = true,
      padding = { 1, 2 },
      title = false,
      title_pos = "center",
      zindex = 1000,
      bo = {},
      wo = {
        winblend = 15,
      },
    },
    layout = {
      width = { min = 20 },
      spacing = 6,
    },
    delay = 100,
    preset = "modern",
    spec = {
      {
        { "<leader>a", "", group = "A.I.", icon = { icon = " ", color = "azure" } },
        mode = { "n", "v" },
        { "<Tab>", group = "Test" },
        { "<leader>x", group = "Debug", icon = { icon = " ", color = "red" } },
        { "<leader>c", group = "Code" },
        { "<leader>dt", group = "Trouble" },
        { "<leader>S", group = "TS Surround", icon = { icon = "󰐅 ", color = "azure" }, hidden = true },
        { "<leader>n", group = "Notif/Notes", icon = { icon = "󰵙 ", color = "yellow" }, hidden = false },
        { "<leader>m", group = "Markdown", icon = { icon = "󱦹 ", color = "azure" } },
        { "<leader>g", group = "Git", icon = { icon = "󰊤 ", color = "azure" } },
        { "<leader>gs", group = "Stage/Search", icon = { icon = "󰊤 " } },
        { "<leader>gsu", group = "Unstage", icon = { icon = " " } },
        { "<leader>gp", group = "Preview", icon = { icon = " " } },
        { "<leader>gr", group = "Reset", icon = { icon = " " } },
        { "<leader>gb", group = "Blame", icon = { icon = " ", color = "azure" } },
        { "<leader>gd", group = "Diff", icon = { icon = " ", color = "azure" } },
        { "<leader>q", group = "Quit/session" },
        { "<leader>s", group = "Search", icon = { icon = " ", color = "orange" } },
        { "<leader>u", group = "Toggle", icon = { icon = "󰙵 ", color = "azure" } },
        { "<leader>d", group = "Diagnostics", icon = { icon = "󰓙 ", color = "azure" } },
        { "<leader>mf", group = "Folds", icon = { icon = " " } },
        { "<leader>h", group = "home", icon = { icon = " " } },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "gs", group = "Surround" },
        { "z", group = "Fold/Spelling" },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        -- valid colors are: `azure`, `blue`, `cyan`, `green`, `grey`, `orange`, `purple`, `red`, `yellow`
        { "gx", desc = "Open with system app" },
        { "<leader>e", desc = " NeoTree", icon = { icon = "󰙅 ", color = "yellow" } },
        { "<leader>y", desc = " Yank History", icon = { icon = " ", color = "azure" } },
        { "<leader>0", desc = " Transparency", icon = { icon = " ", color = "azure" }, hidden = true },
        { "<leader>j", desc = " References", icon = { icon = " ", color = "purple" } },
        { "<leader>?", desc = " Buffer Keymaps", icon = { icon = "  ", color = "azure", hidden = true } },
        { "<leader><leader>", desc = " Search Buffers", icon = { icon = " ", color = "azure" } },
        { "<leader>/", desc = " Grep Buffer", icon = { icon = "󰮗 ", color = "azure" } },
        { "<leader>t", desc = "Tests", icon = { icon = " ", color = "red" }, hidden = false },
        { "<leader>k", desc = " Peek Def", icon = { icon = " ", color = "red" }, hidden = false },
        { "<leader>.", desc = " Scratch Buffer", icon = { icon = " ", color = "red" }, hidden = false },

        { "<leader>gg", desc = " LazyGit", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gf", desc = " LazyGit File History", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gm", desc = " Commit Messsge", icon = { icon = " ", color = "azure" } },
        { "<leader>gG", desc = " Git Graph", icon = { icon = " ", color = "azure" } },

        { "<leader>aa", desc = "Toggle ", icon = { icon = " ", color = "yellow" } },
        { "<leader>am", desc = "Select Model ", icon = { icon = " ", color = "yellow" } },
        { "<leader>aq", desc = "Prompt Actions", icon = { icon = " ", color = "yellow" } },
        { "<leader>ap", desc = "Quick Chat", icon = { icon = " ", color = "yellow" } },
        { "<leader>ax", desc = "Clear", icon = { icon = " ", color = "yellow" } },

        { "<leader>gl", group = "Golang", icon = { icon = " ", color = "blue" }, hidden = false },
        { "<leader>glj", desc = "Add JSON Tag", icon = { icon = " ", color = "blue" } },
        { "<leader>glJ", desc = "Rm JSON Tag", icon = { icon = " ", color = "blue" } },
        { "<leader>glt", group = "Test", icon = { icon = " ", color = "blue" }, hidden = false },
        { "<leader>glta", desc = "Add Test for Function", icon = { icon = " ", color = "blue" } },
        { "<leader>gltA", desc = "Generate All Tests", icon = { icon = " ", color = "blue" } },
        { "<leader>glg", desc = "Get Package", icon = { icon = " ", color = "blue" } },
        { "<leader>glT", desc = "Go Tidy", icon = { icon = " ", color = "blue" } },
        { "<leader>gls", desc = "Go Sync", icon = { icon = " ", color = "blue" } },
        { "<leader>gle", desc = "Handle Err", icon = { icon = " ", color = "blue" } },

        { "<localleader>d", group = "Database", icon = { icon = "󱦹 ", color = "yellow" }, mode = "x" },

        { "<leader>p", desc = " Void Paste", icon = { icon = "󱦹 ", color = "brown" }, mode = { "n", "x" } },

        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>z", hidden = true },

        { "<leader>q", hidden = true },
        { "<leader>D", hidden = true },
      },
    },
  },
  keys = {
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
}
