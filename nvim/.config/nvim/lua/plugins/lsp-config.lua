return {
  -- Configure notifications to persist longer so error messages don't disappear
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 7000, -- 7 seconds instead of default 5
      stages = "fade_in_slide_out",
      render = "default",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
}
