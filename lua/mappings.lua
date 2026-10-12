require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Remove NvChad defaults
pcall(nomap, "n", "<leader>h") -- Horizontal term
pcall(nomap, "n", "<leader>v") -- Vertical term
pcall(nomap, "n", "<leader>n") -- Line number
pcall(nomap, "n", "<leader>rn") -- Relative number
pcall(nomap, "n", "<leader>ra") -- Old rename
pcall(nomap, "n", "<leader>ds") -- Loclist diagnostics
pcall(nomap, "n", "<leader>pt") -- Pick hidden term
pcall(nomap, "n", "<leader>D") -- Type definition
pcall(nomap, "n", "<leader>ca") -- Old code action
pcall(nomap, "n", "<leader>ch") -- LSP help
pcall(nomap, "n", "<leader>cm") -- Default LSP implementation
pcall(nomap, "n", "<leader>ma") -- Old marks
pcall(nomap, "n", "<leader>gt") -- Old git status
pcall(nomap, "n", "<leader>fm") -- Old general format (replaced by <leader>m)
pcall(nomap, "n", "<C-n>") -- Unmap default NvimTree toggle
pcall(nomap, "n", "<leader>w") -- Workspaces
pcall(nomap, "v", "<leader>fm") -- Remove NvChad visual format default

-- Editor custom mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "q", "<Nop>", { desc = "Disable macro recording" })
map({ "n", "v", "o" }, "E", "$", { desc = "Go to end of line" })
map({ "n", "v", "o" }, "B", "^", { desc = "Go to start of line" })
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("v", "n", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "N", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Whichkey mappings
--
-- Code
map({ "n", "x" }, "<leader>ca", function()
  require("tiny-code-action").code_action()
end, { desc = "Code Action" })

vim.api.nvim_create_user_command("Error", function()
  vim.diagnostic.setqflist {
    severity = vim.diagnostic.severity.ERROR,
  }
  vim.cmd "copen"
end, {
  desc = "Show LSP errors in quickfix",
})

vim.api.nvim_create_user_command("Warning", function()
  vim.diagnostic.setqflist()
  vim.cmd "copen"
end, {})

-- Replace
map("n", "<leader>rn", function()
  require "nvchad.lsp.renamer"()
end, { desc = "Rename Node (LSP)" })

map("n", "<leader>rp", function()
  require("grug-far").open()
end, { desc = "Replace project" })

map("n", "<leader>rf", function()
  require("grug-far").open { prefills = { paths = vim.fn.expand "%" } }
end, { desc = "Replace file" })

map("n", "<leader>rw", function()
  require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } }
end, { desc = "Replace word" })

-- Buffers
map("n", "<leader>b", "<cmd> enew <CR>", { desc = "Create buffer" })

-- File explorer
map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Explorer" })
map("n", "<leader>y", "<cmd>Yazi<CR>", { desc = "Yazi" })

vim.api.nvim_create_user_command("CopyPath", function()
  local path = vim.fn.fnamemodify(vim.fn.expand "%:p", ":~")
  vim.fn.setreg("+", path)
  vim.notify("Copied path: " .. path)
end, { desc = "Copy current file path" })

-- Comments
map("n", "<leader>/", "gcc", { desc = "Comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "Comment toggle", remap = true })

-- Handle git errors
local function git_action(action)
  return function()
    vim.fn.system "git rev-parse --is-inside-work-tree"
    if vim.v.shell_error == 0 then
      action()
    else
      vim.notify("Not a git repository.", vim.log.levels.WARN, { title = "Git" })
    end
  end
end

-- Git
map(
  "n",
  "<leader>gb",
  git_action(function()
    Snacks.picker.git_branches()
  end),
  { desc = "Git branch" }
)
map(
  "n",
  "<leader>gf",
  git_action(function()
    Snacks.picker.git_files()
  end),
  { desc = "Git files" }
)
map(
  "n",
  "<leader>ga",
  git_action(function()
    Snacks.picker.git_stash()
  end),
  { desc = "Git stash" }
)
map(
  "n",
  "<leader>gl",
  git_action(function()
    Snacks.lazygit()
  end),
  { desc = "Lazygit" }
)
map("n", "<leader>gh", "<cmd> Gitsigns preview_hunk_inline <CR>", { desc = "Git hunk" })
map("n", "]c", "<cmd>Gitsigns nav_hunk next<CR>", { desc = "Next hunk" })
map("n", "[c", "<cmd>Gitsigns nav_hunk prev<CR>", { desc = "Prev hunk" })

-- Diff
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diff explorer" })
map("n", "<leader>gD", "<cmd>DiffviewOpen -- %<CR>", { desc = "Diff current file" })
map("n", "<leader>gy", "<cmd>DiffviewFileHistory<CR>", { desc = "Diff history" })
map("n", "<leader>gY", "<cmd>DiffviewFileHistory %<CR>", { desc = "Current file history" })
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diff" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer" })

-- Formatting
map("n", "<leader>m", function()
  require("conform").format { lsp_format = "fallback" }
end, { desc = "Format file" })

-- Find (Snacks Picker)
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fa", function()
  Snacks.picker.files { hidden = true, ignored = true, follow = true }
end, { desc = "Find all files" })
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Grep project" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Find oldfiles" })
map("n", "<leader>fz", function()
  Snacks.picker.lines()
end, { desc = "Find in current buffer" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help page" })
map("n", "<leader>fm", function()
  Snacks.picker.marks()
end, { desc = "Find marks" })
map("n", "<leader>ft", function()
  Snacks.picker.todo_comments()
end, { desc = "Find todo" })

-- Terminal: VS Code-style bottom panel
local function terminal_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      return win
    end
  end
end

local function terminal_windows()
  local windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      table.insert(windows, win)
    end
  end
  return windows
end

local function terminal_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      table.insert(buffers, buf)
    end
  end
  return buffers
end

local function code_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.bo[buf].filetype
    local is_explorer = filetype == "snacks_explorer" or filetype == "NvimTree"

    if vim.bo[buf].buftype == "" and not is_explorer then
      return win
    end
  end
end

local function focus_code_window()
  local win = code_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  else
    -- Preserve the normal window-navigation fallback when no code buffer exists.
    vim.cmd("wincmd k")
  end
end

local function open_terminal()
  local win = terminal_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert")
    return
  end

  local buffers = terminal_buffers()
  vim.cmd("botright 15split")
  if #buffers > 0 then
    vim.api.nvim_win_set_buf(0, buffers[1])
    for index = 2, #buffers do
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, buffers[index])
    end
  else
    vim.cmd("terminal")
  end
  vim.cmd("startinsert")
end

local function new_terminal_vertical()
  vim.cmd("vsplit")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end

local function toggle_terminal()
  local windows = terminal_windows()
  if #windows > 0 then
    -- Hide every terminal window; buffers and running processes stay alive.
    for _, win in ipairs(windows) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_hide(win)
      end
    end
    focus_code_window()
  else
    open_terminal()
  end
end

-- Open/focus the terminal below the current code window.
map("n", "<C-j>", open_terminal, { desc = "Focus bottom terminal" })
map({ "n", "t" }, "<A-f>", toggle_terminal, { desc = "Hide/show bottom terminal" })
map("n", "<leader>tv", new_terminal_vertical, { desc = "New terminal beside current" })

-- Move between the code window and the bottom terminal.
map("n", "<C-k>", focus_code_window, { desc = "Focus code window" })
map("t", "<C-k>", function()
  vim.cmd("stopinsert")
  focus_code_window()
end, { desc = "Focus code window" })

-- Leave terminal insert mode with <Esc>.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf })
        vim.keymap.set("n", "<Esc>", "i", { buffer = args.buf })
      end
    end)
  end,
})

-- Splits
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>p", function()
  local win = Snacks.picker.util.pick_win {
    filter = function(win)
      local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      return ft == "snacks_explorer" or ft == "snacks_picker_list" or vim.api.nvim_win_get_config(win).relative == ""
    end,
  }

  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  end
end, { desc = "Pick window" })

-- Override NvChad default buffer-local actions
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.schedule(function()
      pcall(vim.keymap.del, "n", "<leader>ra", { buffer = args.buf })
      pcall(vim.keymap.del, "n", "<leader>D", { buffer = args.buf })
    end)
  end,
})
