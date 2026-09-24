return {
  "brenoprata10/nvim-highlight-colors",
  event = "BufReadPre",
  opts = {
    render = "virtual", -- "background" | "foreground" | "virtual"
    virtual_symbol = "☭", -- "⚰" | "🂠" | "■" | 🂱"
    virtual_symbol_position = "inline", -- "inline" | "eol" | "eow"
    enable_tailwind = true,
  },
}
