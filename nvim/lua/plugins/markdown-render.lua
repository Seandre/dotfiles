return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function(_, opts)
      opts.code = vim.tbl_deep_extend("force", opts.code or {}, {
        border = "none",
        disable_background = { "diff" },
        width = "block",
      })
    end,
    config = function(_, opts)
      require("render-markdown").setup(opts)

      local function apply_neutral_backgrounds()
        local code_bg = "#1f1f1f"
        local heading_bg = "#242424"
        local selection_bg = "#2b2b2b"

        vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = code_bg })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = code_bg })
        vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { bg = code_bg })

        for _, group in ipairs({
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        }) do
          vim.api.nvim_set_hl(0, group, { bg = heading_bg, bold = true })
        end

        vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = selection_bg, bold = true })
      end

      apply_neutral_backgrounds()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("MarkdownCodeBlockBackground", { clear = true }),
        callback = apply_neutral_backgrounds,
      })

      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },
}
