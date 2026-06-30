return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    options = {
      mode = "buffers",
      always_show_bufferline = false,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diagnostics_dict)
        local s = ""
        for name, count in pairs(diagnostics_dict) do
          if count > 0 then
            local symbol = name == "error" and "E" or name == "warning" and "W" or "I"
            s = s .. " " .. symbol .. ":" .. count
          end
        end
        return s
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
      show_buffer_close_icons = true,
      show_close_icon = false,
      color_icons = true,
      separator_style = "slant",
    },
  },
}
