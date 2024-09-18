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
        "codespell",
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "williamboman/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "pyright",
          "gopls",
          "tailwindcss",
          "cssls",
          "eslint",
          "volar",
          "html",
          "lua_ls",
          "yamlls",
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

      -- vue volar
      lspconfig.volar.setup({
        cmd = { "vue-language-server", "--stdio" },
        filetypes = { "vue" },
        init_options = {
          typescript = {
            tsdk = "",
          },
        },
        root_dir = lspconfig.util.root_pattern("package.json", ".git"),
        on_new_config = function(new_config, new_root_dir)
          local util = require("luwei.util")
          if
            new_config.init_options
            and new_config.init_options.typescript
            and new_config.init_options.typescript.tsdk == ""
          then
            new_config.init_options.typescript.tsdk = util.get_typescript_server_path(new_root_dir)
          end
        end,
      })

      lspconfig.eslint.setup({
        single_file_support = false,
        root_dir = function(filename)
          if string.find(filename, "node_modules/") then
            return nil
          end
          return require("luwei.util").get_eslint_root_path()
        end,
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
          format = true,
          problems = {
            shortenToSingleLine = true,
          },
          experimental = {
            useFlatConfig = true,
          },
        },
        on_new_config = function(new_config)
          local util = require("luwei.util")
          local new_eslint_config = util.get_new_eslint_config()

          if new_eslint_config then
            new_config.settings.options = {
              overrideConfigFile = new_eslint_config,
            }
          else
            local old_eslint_config = util.get_old_eslint_config()
            new_config.settings.options = {
              overrideConfigFile = old_eslint_config,
            }
          end
        end,
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

      -- ts_ls
      lspconfig.ts_ls.setup({
        init_options = { hostInfo = "neovim" },
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
        single_file_support = true,
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
}
