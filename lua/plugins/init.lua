return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" }, -- format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { import = "nvchad.blink.lazyspec" },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua --
        "lua-language-server",
        "stylua",

        -- Web (HTML / CSS / JS / TS) --
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "eslint-lsp",
        "prettier",

        -- Python --
        "pyright",
        "ruff",

        -- C / C++ --
        "clangd",
        "clang-format",

        -- Go --
        "gopls",
        "golangci-lint",

        -- Rust --
        "rust-analyzer",

        -- Shell --
        "bash-language-server",
        "shellcheck",
        "shfmt",

        -- Data formats --
        "yaml-language-server",
        "yamllint",
        "json-lsp",
        "taplo",

        -- Markdown --
        "marksman",
        "markdownlint-cli2",

        -- Graphql --
        "graphql-language-service-cli",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "cpp",
        "python",
        "go",
        "rust",
        "json",
        "yaml",
        "bash",
        "markdown",
        "markdown_inline",
        "dart",
        "graphql",
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        yaml = { "yamllint" },
        markdown = { "markdownlint" },
        go = { "golangcilint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { delay = 0 },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)

      wk.add {
        -- Group Icons
        { "<leader>g", group = "Git", icon = "󰊢" },
        { "<leader>f", group = "Find", icon = "󰈞" },
        { "<leader>t", group = "Themes", icon = "󱊖" },
        { "<leader>w", group = "Workspace", icon = "󰖯" },
        { "<leader>s", group = "Split", icon = "󱂬" },
        { "<leader>r", group = "Replace", icon = "󰑐" },
        { "<leader>c", group = "Code", icon = "", mode = { "n", "v", "x" } },
        { "<leader>/", desc = "Comment", icon = "󰅺", mode = { "v", "x" } },
        { "<leader>o", group = "Opencode", icon = "󱚣", mode = { "n", "v", "x" } },
        { "<leader>m", desc = "Format", icon = "󰉼", mode = { "v", "x" } },

        -- Sub Group Icons
        { "<leader>sv", desc = "Split Vertical", icon = "" },
        { "<leader>sh", desc = "Split Horizontal", icon = "" },
        { "<leader>cv", desc = "Manage venv", icon = "" },
        { "<leader>ca", desc = "Code action", icon = "󱐋", mode = { "v", "x" } },
        { "<leader>gd", desc = "Diff explorer", icon = "" },
        { "<leader>gD", desc = "Diff current file", icon = "" },
        { "<leader>gy", desc = "Diff history", icon = "󰋚" },
        { "<leader>gY", desc = "Current file history", icon = "󰋚" },
        { "<leader>gq", desc = "Close diff", icon = "󰅖" },
        { "<leader>ot", desc = "Toggle opencode", icon = "󱚣" },
        { "<leader>os", desc = "Select session", icon = "" },
        { "<leader>oy", desc = "Send selection", icon = "󱚣", mode = { "v", "x" } },

        -- Direct Action Icons
        { "<leader>m", desc = "Format", icon = "󰉼" },
        { "<leader>b", desc = "New buffer", icon = "󰝒" },
        { "<leader>x", desc = "Close buffer", icon = "󰅖" },
        { "<leader>e", desc = "Explorer", icon = "󰙅" },
        { "<leader>y", desc = "Yazi", icon = "󰇥" },
        { "<leader>/", desc = "Comment", icon = "󰅺" },
        { "<leader>d", desc = "Diagnostics", icon = "󱖫" },
        { "<leader>p", desc = "Pick window", icon = "󰆟" },

        -- Force-hide the old groups
        { "<leader>ma", hidden = true },
        { "<leader>w", hidden = true },
      }
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            {
              icon = "󰦛",
              key = "s",
              desc = "Restore session",
              action = function()
                local persistence = require "persistence"
                if vim.fn.filereadable(persistence.current()) == 0 then
                  vim.notify("No session found for this directory", vim.log.levels.WARN, { title = "Persistence" })
                else
                  persistence.load()
                end
              end,
            },
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":lua Snacks.dashboard.pick('files')",
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            {
              icon = "󰒲 ",
              key = "L",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      explorer = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        filter = (function()
          local seen = {}
          return function(notif)
            local key = notif.msg
            local now = vim.uv.now()
            if seen[key] and (now - seen[key]) < 2000 then
              return false -- suppress duplicate within 2 seconds
            end
            seen[key] = now
            return true
          end
        end)(),
      },
      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["<C-l>"] = { "focus_preview", mode = { "i", "n" } },
              ["<C-j>"] = { "list_down", mode = { "i", "n" } },
              ["<C-k>"] = { "list_up", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<C-j>"] = { "list_down", mode = { "n" } },
              ["<C-k>"] = { "list_up", mode = { "n" } },
            },
          },
          preview = {
            minimal = false,
            keys = {
              ["<C-h>"] = { "focus_list", mode = { "n" } },
              ["<C-j>"] = { "preview_scroll_down", mode = { "n" } },
              ["<C-k>"] = { "preview_scroll_up", mode = { "n" } },
            },
          },
        },
        sources = {
          files = { frecency = true },
          recent = { frecency = true },
          explorer = {
            layout = { preview = true },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      select = { enabled = true },
    },
  },

  {
    "nvzone/volt",
    lazy = true,
  },

  {
    "nvzone/floaterm",
    config = function()
      require("floaterm").setup()
    end,
    lazy = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {},
  },

  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup {}
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },

  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    opts = {
      open_for_directories = false,
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    ft = "python",
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_change = true,
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },

  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "folke/snacks.nvim" },
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = "snacks",
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        file_history = { layout = "diff2_horizontal" },
      },
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
        },
        ft = { "markdown", "opencode_output" },
      },
      "folke/snacks.nvim",
    },
    lazy = true,
    keys = { "<leader>ot", "<leader>os", { "<leader>oy", mode = "v" } },
    config = function()
      require("opencode").setup {
        preferred_picker = "snacks",
        preferred_completion = "blink",
        default_global_keymaps = false,
        keymap = {
          editor = {
            ["<leader>ot"] = { "toggle" },
            ["<leader>os"] = { "select_session" },
            ["<leader>oy"] = { "add_visual_selection", mode = { "v" } },
          },
        },
      }
    end,
  },

  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {
      smear_between_buffers = false,
      smear_between_neighbor_lines = true,
      smear_to_cmd = false,

      min_horizontal_distance_smear = 1,
      min_vertical_distance_smear = 1,

      smear_insert_mode = true,
      vertical_bar_cursor_insert_mode = true,

      stiffness = 0.8,
      trailing_stiffness = 0.7,
      damping = 0.9,
      trailing_exponent = 1,

      stiffness_insert_mode = 0.9,
      trailing_stiffness_insert_mode = 0.9,
      damping_insert_mode = 0.95,

      never_draw_over_target = true,
      particles_enabled = false,
    },
  },
}
