-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

Snacks.toggle({
  name = "AI suggestions",
  get = function()
    return vim.lsp.inline_completion.is_enabled()
  end,
  set = function(state)
    vim.lsp.inline_completion.enable(state)
    require("sidekick.nes").enable(state)
  end,
}):map("<leader>uA")
