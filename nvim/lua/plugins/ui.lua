return {
  {
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
    config = function()
			vim.g.sonokai_transparent_background = true
			vim.g.sonokai_enable_italic = true
			vim.g.sonokai_style = "andromeda"
			vim.cmd.colorscheme('sonokai')
		end
	},

  { "xiyaowong/transparent.nvim", event = "UIEnter" },
  
}
