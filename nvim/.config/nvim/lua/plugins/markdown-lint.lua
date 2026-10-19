-- Disable noisy markdownlint rules globally, regardless of any per-project
-- markdownlint config. Rules live in ../../.markdownlint.jsonc and are passed
-- as the `--config` base config to markdownlint-cli2, both for the linter
-- (nvim-lint, source of the warnings) and the conform formatter (autofix).
-- markdownlint-cli2 requires --config's basename to be one of its supported
-- config filenames, hence the leading dot.
local global_config = vim.fn.stdpath("config") .. "/.markdownlint.jsonc"

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", global_config },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", global_config },
        },
      },
    },
  },
}
