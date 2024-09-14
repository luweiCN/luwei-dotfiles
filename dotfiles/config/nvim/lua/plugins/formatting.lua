return {
  "stevearc/conform.nvim",
  opts = function(_)
    local formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      go = { "goimports", "gofmt" },
      -- You can also customize some of the format options for the filetype
      rust = { "rustfmt", lsp_format = "fallback" },
      -- You can use a function here to determine the formatters dynamically
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format" }
        else
          return { "isort", "black" }
        end
      end,
      javascript = { "eslint_d", "prettier" },
      typescript = { "eslint_d", "prettier" },
      typescriptreact = { "eslint_d", "prettier" },
      javascriptreact = { "eslint_d", "prettier" },
      vue = { "eslint_d", "prettier" },
      less = { "prettier" },
      sass = { "prettier" },
      css = { "prettier" },
      -- Use the "*" filetype to run formatters on all filetypes.
      ["*"] = { "codespell" },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ["_"] = { "trim_whitespace", "prettier" },
    }

    local formatters = {}
    formatters.prettier = {
      command = function()
        return "prettier"
      end,
      args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
      stdin = true,
      lsp_format = "fallback",
      condition = function()
        return not require("luwei/util").has_eslint_config()
      end,
    }

    formatters.eslint_d = {
      command = "eslint_d",
      args = function()
        local old_eslint_config = require("luwei/util").get_old_eslint_config()
        if old_eslint_config then
          return {
            "--fix-to-stdout",
            "--stdin",
            "--config",
            old_eslint_config,
            "--stdin-filename",
            vim.api.nvim_buf_get_name(0),
          }
        end
        return { "--fix-to-stdout", "--stdin", "--stdin-filename", vim.api.nvim_buf_get_name(0) }
      end,
      cwd = function()
        return require("luwei/util").get_eslint_root_path() or vim.fn.getcwd()
      end,
      condition = function()
        return require("luwei/util").has_eslint_config()
      end,
      required_cwd = true,
      stdin = true,
      lsp_format = "fallback",
    }

    return {
      formatters_by_ft = formatters_by_ft,
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters = formatters,
    }
  end,
}
