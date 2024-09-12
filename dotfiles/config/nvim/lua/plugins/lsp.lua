return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "williamboman/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver",
          "pyright",
          "gopls",
          "tailwindcss-language-server",
          "typescript-language-server",
          "css-lsp",
          "vue",
        },
        automatic_installation = true,
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- css-lsp
      lspconfig.cssls.setup({
        cmd = { "css-languageserver", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
      })

      -- vue vetur
      lspconfig.vuels.setup({
        cmd = { "vls" },
        filetypes = { "vue" },
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
      })

      lspconfig.eslint.setup({
        settings = {
          disableRuleComment = {
            enable = false,
            location = "separateLine",
          },
          showDocumentation = {
            enable = true,
          },
          workingDirectories = {
            mode = "auto",
          },
          validate = "on",
          problems = {
            shortenToSingleLine = true,
          },
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
      })

      -- tailwindcss
      lspconfig.tailwindcss.setup({
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "typescript", "vue" },
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidConfigPath = "error",
          invalidScreen = "error",
          invalidTailwindDirective = "error",
          invalidVariant = "error",
          recommendedVariantOrder = "warning",
        },
        validate = true,
      })

      -- tsserver
      lspconfig.tsserver.setup({
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
        single_file_support = false,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "literal",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      --- html
      lspconfig.html.setup({
        cmd = { "html-languageserver", "--stdio" },
        filetypes = { "html" },
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
      })

      --- lua_ls
      lspconfig.lua_ls.setup({
        -- enabled = false,
        single_file_support = true,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              workspaceWord = true,
              callSnippet = "Both",
            },
            misc = {
              parameters = {
                -- "--log-level=trace",
              },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
            doc = {
              privateName = { "^_" },
            },
            type = {
              castNumberToInteger = true,
            },
            diagnostics = {
              disable = { "incomplete-signature-doc", "trailing-space" },
              -- enable = false,
              groupSeverity = {
                strong = "Warning",
                strict = "Warning",
              },
              groupFileStatus = {
                ["ambiguity"] = "Opened",
                ["await"] = "Opened",
                ["codestyle"] = "None",
                ["duplicate"] = "Opened",
                ["global"] = "Opened",
                ["luadoc"] = "Opened",
                ["redefined"] = "Opened",
                ["strict"] = "Opened",
                ["strong"] = "Opened",
                ["type-check"] = "Opened",
                ["unbalanced"] = "Opened",
                ["unused"] = "Opened",
              },
              unusedLocalExclude = { "_*" },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      })

      -- yamlls
      lspconfig.yamlls.setup({
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml" },
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      })

      -- 配置快捷键
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(keys, {
        {
          "gd",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_definitions({ reuse_win = false })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
      })
    end,
    opts = {
      inlayHints = { enable = true },
      setup = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(keys, {
        {
          "gd",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_definitions({ reuse_win = false })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
      })
    end,
  },
}
