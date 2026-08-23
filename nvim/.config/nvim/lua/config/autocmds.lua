-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- WORKAROUND: neo-tree.nvim commit b5dc51b "fix(commands): handle newlines in
-- filenames when opening (#2059)" (2026-07-29) changed how neo-tree opens a
-- file on <CR>: it now does `vim.fn.bufadd(path)` + `:buffer <n>` instead of
-- `:edit <path>`. Vim's built-in "reuse the empty unnamed buffer" behavior
-- only triggers on `:edit`, not `:buffer`, so the initial [No Name] buffer
-- from `nvim .` is left behind and bufferline shows it as a stray extra tab.
-- Delete leftover empty/unmodified/window-less buffers whenever a real file
-- buffer is entered. If a future neo-tree release restores :edit-based
-- opening (or exposes a config knob for this), this autocmd is safe to
-- delete.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("neotree_noname_cleanup", { clear = true }),
  desc = "Clean up leftover [No Name] buffers left by neo-tree's bufadd-based file opening",
  callback = function(args)
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
        buf ~= args.buf
        and vim.api.nvim_buf_get_name(buf) == ""
        and vim.bo[buf].buftype == ""
        and not vim.bo[buf].modified
        and #vim.fn.win_findbuf(buf) == 0
      then
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end,
})

-- Persist whatever colorscheme is active (e.g. picked via <leader>uC) so it
-- survives restart. plugins/all-themes.lua reads this file to pick the
-- startup colorscheme instead of a hardcoded name.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("persist_colorscheme", { clear = true }),
  desc = "Save the active colorscheme to disk for next startup",
  callback = function()
    local name = vim.g.colors_name
    if not name or name == "" then
      return
    end
    local file = io.open(vim.fn.stdpath("state") .. "/theme", "w")
    if file then
      file:write(name)
      file:close()
    end
  end,
})
