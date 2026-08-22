-- Prefer whichever formatter a project has actually configured (oxfmt >
-- biome > prettier, checked in that order) for js/jsx/ts/tsx/css. Falls back
-- to conform's stock prettier setup (LazyVim's `formatting.prettier` extra,
-- left at its own defaults) when none of these project configs exist -
-- that's the most widely used and documented formatting path for these
-- filetypes in Neovim.
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      local util = require("conform.util")

      local function oxfmt_root(ctx)
        return vim.fs.root(ctx.dirname, ".oxfmtrc.json")
      end

      local biome_files = { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" }
      local function biome_root(ctx)
        return vim.fs.root(ctx.dirname, biome_files)
      end

      opts.formatters = opts.formatters or {}

      opts.formatters.oxfmt = {
        command = util.from_node_modules("oxfmt"),
        args = { "--stdin-filepath", "$FILENAME" },
        cwd = function(_, ctx)
          return oxfmt_root(ctx)
        end,
        condition = function(_, ctx)
          return oxfmt_root(ctx) ~= nil
        end,
      }

      -- `biome` is conform's built-in formatter (format-only, no lint/import
      -- sort); it just needs a condition gating it to biome-configured
      -- projects that don't also have an oxfmt config.
      opts.formatters.biome = {
        condition = function(_, ctx)
          return oxfmt_root(ctx) == nil and biome_root(ctx) ~= nil
        end,
      }

      -- Keep whatever condition the prettier extra already set up, but only
      -- as the last resort: skip it once oxfmt or biome has claimed the
      -- project.
      local orig_prettier = opts.formatters.prettier --[[@as conform.FormatterConfigOverride?]]
      opts.formatters.prettier = vim.tbl_deep_extend("force", orig_prettier or {}, {
        condition = function(self, ctx)
          if oxfmt_root(ctx) or biome_root(ctx) then
            return false
          end
          if orig_prettier and orig_prettier.condition then
            return orig_prettier.condition(self, ctx)
          end
          return true
        end,
      })

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact", "css" }) do
        local ft_formatters = (opts.formatters_by_ft[ft] or {}) --[[@as conform.FiletypeFormatterInternal]]
        table.insert(ft_formatters, 1, "biome")
        table.insert(ft_formatters, 1, "oxfmt")
        opts.formatters_by_ft[ft] = ft_formatters
      end
    end,
  },
}
