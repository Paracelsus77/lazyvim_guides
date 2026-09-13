return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "fallback" }, -- Enter will only insert a newline
      },
    },
  },
}
