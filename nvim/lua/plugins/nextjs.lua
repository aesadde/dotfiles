return {
  -- Faster, monorepo-aware TS server. Pairs with the `lang.typescript` extra.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = { maxTsServerMemory = 8192 },
              preferences = { importModuleSpecifier = "non-relative" },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
            },
          },
        },
        tailwindcss = {
          -- Tailwind v4 lives in CSS; make sure LSP scans common class-name patterns.
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { "cn\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
              },
            },
          },
        },
      },
    },
  },

  -- package.json: show latest versions, outdated highlights, <leader>cp menu.
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    event = { "BufRead package.json" },
    config = true,
  },

  -- Vitest/Jest test runner. Pick whichever your apps/* use.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
    },
    opts = function()
      return { adapters = { require("neotest-vitest") } }
    end,
  },

  -- Debugger for Next.js (node + chrome). Requires `dap.core` extra enabled.
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
    },
  },

  -- Treesitter languages this stack actually uses.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = {
      "typescript", "tsx", "javascript", "json", "jsonc",
      "css", "html", "prisma", "sql", "yaml", "toml", "markdown", "markdown_inline",
    } },
  },

  -- Optional: AI inline. Skip if you prefer Claude Code only.
  -- { "github/copilot.vim", event = "InsertEnter" },
}
