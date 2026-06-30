-- Remove LazyVim Mappings
-- vim.keymap.del("n", "<leader>`")
-- vim.keymap.del("n", "<leader>|")
-- vim.keymap.del("n", "<leader>-")
-- vim.keymap.del("n", "<leader>L")
-- vim.keymap.del("n", "<leader>l")
-- vim.keymap.del("n", "<leader>K")
-- vim.keymap.del("n", "<leader>snt")
-- vim.keymap.del("n", "<leader>st")
-- vim.keymap.del("n", "<leader><Tab>[")
-- vim.keymap.del("n", "<leader><Tab>]")
-- vim.keymap.del("n", "<leader><Tab>d")
-- vim.keymap.del("n", "<leader><Tab>l")
-- vim.keymap.del("n", "<leader><Tab>o")
-- vim.keymap.del("n", "<leader><Tab>f")
-- vim.keymap.del("n", "<leader><Tab><tab>")
-- vim.keymap.del("i", ",")
-- vim.keymap.del("i", ".")
-- vim.keymap.del("i", ";")
-- vim.keymap.del("n", "<leader>fn")
-- vim.keymap.del("n", "<leader>ft")
-- vim.keymap.del("n", "<leader>xl")
-- vim.keymap.del("n", "<leader>xq")
-- vim.keymap.del("n", "<leader>fT")
-- vim.keymap.del("n", "<leader>gl")
-- vim.keymap.del("n", "<C-F>")
-- vim.keymap.del("n", "<C-B>")
-- 
local map = LazyVim.safe_keymap_set

----------------------------------------------------------------------------
--                           Shift Navigation Section
-------------------------------------------------------------------------------

-- better up/down
-- map({ "n", "x" }, "k", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
-- map({ "n", "x" }, "l", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Remap j; for navigation/o-pending
-- map({ "n", "x", "o" }, "j", "<Left>", { desc = "Right", silent = true })
-- map("o", "k", "<Down>", { desc = "Down", silent = true })
-- map("o", "l", "<Up>", { desc = "Up", silent = true })
-- map({ "n", "x", "o" }, ";", "<Right>", { desc = "Left", silent = true })

-- Move Lines
-- map("n", "<A-l>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
-- map("i", "<A-l>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
-- map("n", "<A-k>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
-- map("i", "<A-k>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- map("v", "<A-l>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
-- map("v", "<A-k>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })

-- Terminal Mappings
-- map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-k>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-l>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-;>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-------------------------------------------------------------------------------
--                           Buffer Section
-------------------------------------------------------------------------------

local last_editor_buffer

local function is_editor_buffer(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "neo-tree"
end

local function remember_editor_buffer()
  local buf = vim.api.nvim_get_current_buf()
  if is_editor_buffer(buf) then
    last_editor_buffer = buf
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("UserLastEditorBuffer", { clear = true }),
  callback = remember_editor_buffer,
})

local function close_editor_buffer()
  local current_buf = vim.api.nvim_get_current_buf()
  local target_buf = is_editor_buffer(current_buf) and current_buf or nil

  if not target_buf and last_editor_buffer and is_editor_buffer(last_editor_buffer) then
    target_buf = last_editor_buffer
  end

  if not target_buf then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if is_editor_buffer(buf) then
        target_buf = buf
        break
      end
    end
  end

  if not target_buf then
    vim.notify("No editor buffer to close", vim.log.levels.INFO)
    return
  end

  Snacks.bufdelete(target_buf)
end

map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<leader>bc", close_editor_buffer, { desc = "Close Buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close Other Buffers" })

-------------------------------------------------------------------------------
--                           Misc/Util Section
-------------------------------------------------------------------------------

-- Highlights
for i = 1, 9 do
  map("v", "h" .. i, ":<c-u>HSHighlight " .. i .. "<CR>", {
    noremap = true,
    silent = true,
  })
end

map("v", "h0", ":<c-u>HSRmHighlight<CR>", {
  noremap = true,
  silent = true,
})

-- Add ctrl backspace
map("i", "<C-BS>", "<ESC>dbi")

-- Save
map("n", "<S-CR>", "<cmd>w<cr>")

-- Better alternate buffer
map("n", "L", "<C-^>", { noremap = true, silent = true })

-- No right ctrl on the macbook :(
map("n", "Q", "<C-Z>", { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])

-- Definition mappings
map("n", "<leader>j", "<cmd>Lspsaga finder tyd+ref+def<CR>", { desc = "Get References" })
map("n", "gk", "<cmd>Glance definitions<cr>", { desc = "Peek Definition" })
map("n", "<leader>k", "<cmd>Glance definitions<cr>", { desc = "Peek Definition" })
map("n", "gR", "<cmd>Glance references<cr>", { desc = "Glance References" })

map("n", "dm", [[:lua DeleteMark()<CR>]], { desc = "Delete Mark x" })

function DeleteMark()
  local mark = vim.fn.nr2char(vim.fn.getchar())
  vim.cmd("delmarks " .. mark)
end

-- Search current word / selection with built-in Vim behavior.
map("n", "*", "*", { desc = "Search word under cursor" })

-- Center when finding
map("n", "n", "nzzzv", { desc = "Next find and center" })
map("n", "N", "Nzzzv", { desc = "Prev find and center" })

-- Keep cursor in place when joining
map("n", "J", "mzJ`z:delm z<cr>")

-- Add a line up or down in normal mode
map("n", "go", "mzo<ESC>`z:delm z<cr><down>")
map("n", "gO", "mzO<ESC>`z:delm z<cr><up>")

-- Easier marks
map("n", "'", "<cmd>WhichKey `<cr>")

-- Matching Bracket
map({ "n", "x" }, "M", "%")
map({ "n", "x" }, "gC", "M")
map({ "n", "x" }, "zm", "M")

-- Easier case switching
map("n", "U", "~<Left>")

-- Better end and beginning
map({ "n", "x", "o" }, "-", "zH^", { noremap = true, silent = true })
map({ "n", "x", "o" }, "+", "$", { noremap = true, silent = true })

map({ "n", "x", "o" }, "gj", "zH^", { noremap = true, silent = true, desc = "Go to Beginnning" })
map({ "n", "x", "o" }, "g;", "$", { noremap = true, silent = true, desc = "Go to End" })

-------------------------------------------------------------------------------
--                           Diagnostics Section
-------------------------------------------------------------------------------

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROsR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Diagnostics
map("n", "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
map("n", "<leader>dN", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Cursor Diagnostics" })

map("n", "<leader>da", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All Diagnostics" })
map("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })

-------------------------------------------------------------------------------
--                           Windows Section
-------------------------------------------------------------------------------

-- Resize with arrows
map("n", "<Up>", "<cmd>resize +3<cr>", { desc = "Increase Window Height" })
map("n", "<Down>", "<cmd>resize -3<cr>", { desc = "Decrease Window Height" })
map("n", "<Right>", "<cmd>vertical resize +3<cr>", { desc = "Increase Window Width" })
map("n", "<Left>", "<cmd>vertical resize -3<cr>", { desc = "Increase Window Width" })

-- Window arrangement
map("n", "<leader>wj", "<C-w>H", { desc = "Move Left" })
map("n", "<leader>wk", "<C-w>J", { desc = "Move Bottom" })
map("n", "<leader>wl", "<C-w>K", { desc = "Move Top" })
map("n", "<leader>w;", "<C-w>L", { desc = "Move Right" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize" })

-------------------------------------------------------------------------------
--                           Toggle Section
-------------------------------------------------------------------------------

-- Toggle Transparency
map("n", "<leader>0", "<cmd>TransparentToggle<CR>", { desc = "Transparency" })

-- Toggle ZenMode
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Transparency" })

-------------------------------------------------------------------------------
--                           Database Section
-------------------------------------------------------------------------------

map(
  "n",
  "<localleader>do",
  "<cmd>tabnew<cr><cmd>DBUIToggle<CR>",
  { desc = "Open Database" }
)
map("n", "<localleader>du", "<cmd>DBUIToggle<CR>", { desc = "Toggle Database" })
map("n", "<localleader>df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find Buffer" })

-------------------------------------------------------------------------------
--                           Markdown Section
-------------------------------------------------------------------------------

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "which_key_ignore" })

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
map("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, { desc = "[P]Toggle fold" })

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file
  -- doesn't have them set
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt.foldtext = ""
  else
    vim.opt.foldmethod = "indent"
    vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  end
  vim.opt.foldlevel = 99
end

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- Keymap for unfolding markdown headings of level 2 or above
map("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
end, { desc = "Unfold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 1 or above
map("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
map("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
map("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
map("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "Fold all headings level 4 or above" })

-------------------------------------------------------------------------------
--                           Vim Defaults Section
-------------------------------------------------------------------------------

local function del(modes, lhs)
  for _, mode in ipairs(type(modes) == "table" and modes or { modes }) do
    pcall(vim.keymap.del, mode, lhs)
  end
end

-- Keep the LazyVim/plugin setup, but restore built-in Vim editing motions.
for _, key in ipairs({
  "j",
  "k",
  "<Down>",
  "<Up>",
  "n",
  "N",
  "<",
  ">",
}) do
  del({ "n", "x", "o" }, key)
end

for _, key in ipairs({
  "s",
  "S",
  "R",
}) do
  del({ "n", "x", "o" }, key)
end
del("o", "r")
del("c", "<C-s>")

for _, key in ipairs({
  "<Esc>",
  ",",
  ".",
  ";",
  "<C-s>",
  "<A-j>",
  "<A-k>",
  "<S-Tab>",
  "<Tab>",
}) do
  del({ "i", "s" }, key)
end

for _, key in ipairs({
  "<C-h>",
  "<C-j>",
  "<C-k>",
  "<C-l>",
  "<C-Up>",
  "<C-Down>",
  "<C-Left>",
  "<C-Right>",
  "<A-j>",
  "<A-k>",
  "<S-h>",
  "<S-l>",
  "<C-s>",
  "<S-CR>",
  "L",
  "Q",
  "gk",
  "g;",
  "gC",
  "go",
  "gO",
  "zm",
  "dm",
  "*",
  "|",
  "J",
  "'",
  "M",
  "U",
  "-",
  "+",
  "<CR>",
  "<Up>",
  "<Down>",
  "<Left>",
  "<Right>",
  "gco",
  "gcO",
}) do
  del("n", key)
end

for _, key in ipairs({
  "*",
  "M",
  "gC",
  "zm",
  "-",
  "+",
  "<A-j>",
  "<A-k>",
}) do
  del("x", key)
end

for _, key in ipairs({
  "-",
  "+",
  "gk",
  "g;",
}) do
  del("o", key)
end
