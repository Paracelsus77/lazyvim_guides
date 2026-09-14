# Comprehensive Guide to Conceal in LazyVim

## Overview

In Neovim and **LazyVim**, **conceal** is a core buffer feature that hides or visually replaces syntax elements—such as Markdown code fence backticks (```), quotation marks, or TypeScript JSDoc annotations—to present a cleaner, document-like reading experience.

When working with Markdown files or TypeScript JSDoc comments containing embedded code blocks, Neovim's conceal mechanism often hides the surrounding backticks when your cursor is not directly on that line.

---

## Quick Toggle Keymap

LazyVim includes a built-in toggle keymap under the UI menu (`<leader>u`):

```text
<leader>uc
```

* **Default Key Combo:** `Space` -> `u` -> `c` (in Normal mode)
* **Action:** Toggles Neovim's `conceallevel` between `0` (off/show all) and `2` or `3` (on/hide concealed elements).
* **Cursor Exception:** By default in Neovim/LazyVim, when your cursor moves onto a line containing concealed text, the hidden characters will temporarily reveal themselves so you can edit them. When the cursor moves away, they conceal again. `<leader>uc` turns this behavior off entirely for the current buffer.

---

## Understanding `conceallevel`

Neovim controls conceal behavior through the `vim.opt.conceallevel` setting, which accepts integer values from `0` to `3`:

| Level | Behavior | Description |
| :---: | :--- | :--- |
| **`0`** | **Disabled** | Conceal is completely off. All raw backticks, syntax flags, quotes, and symbols are fully visible. |
| **`1`** | **Replace with Character** | Concealed text is replaced with a custom character (defined by treesitter/syntax highlight rules) or a single space. |
| **`2`** | **Hide Completely** | Concealed text is completely hidden, unless a custom replacement character has been specified by a plugin. *(LazyVim default for Markdown/JSDoc)* |
| **`3`** | **Strict Conceal** | Concealed text is hidden completely regardless of whether a replacement character is defined. |

---

## Managing `concealcursor`

Another related Neovim option is `concealcursor`. This option determines under which Neovim modes concealed text remains hidden even when the cursor is on that line.

```lua
-- Settings for conceallevel
vim.opt.conceallevel = 2

-- Define modes where text stays concealed even with cursor on line:
-- 'n' = Normal mode, 'v' = Visual mode, 'i' = Insert mode, 'c' = Command-line mode
vim.opt.concealcursor = "nc"
```

If you want concealed text to **reveal itself** in Normal mode whenever your cursor touches the line, set:

```lua
vim.opt.concealcursor = ""
```

---

## Permanent LazyVim Configuration

If you do not want backticks or syntax elements hidden automatically when opening TypeScript or Markdown files, you can configure your LazyVim options permanently.

### Option 1: Disable Globally Across All Filetypes

Add the following setting to your options file at `~/.config/nvim/lua/config/options.lua`:

```lua
-- Disable conceal globally in LazyVim
vim.opt.conceallevel = 0
```

### Option 2: Disable Only for TypeScript & Markdown Files

If you prefer to keep conceal active for other filetypes (like JSON or LaTeX) but disable it specifically for Markdown and TypeScript/TSX code, add an Autocmd in `~/.config/nvim/lua/config/autocmds.lua`:

```lua
local function set_no_conceal()
  vim.opt_local.conceallevel = 0
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = set_no_conceal,
})
```

---

## Plugins That Override Conceal Settings

In LazyVim, certain UI plugins control their own rendering and may override `conceallevel` automatically:

### 1. `render-markdown.nvim`

LazyVim often includes `render-markdown.nvim` for rich Markdown rendering inside Neovim. This plugin dynamically sets `conceallevel = 2`.

To configure `render-markdown.nvim` so it doesn't conceal backticks, edit or create `~/.config/nvim/lua/plugins/markdown.lua`:

```lua
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        -- Set to false if you don't want render-markdown to hide raw code block fences
        conceal = false,
      },
    },
  },
}
```

### 2. Neovim Treesitter

Treesitter parser rules specify which syntax nodes (such as JSDoc tags `@param` or code blocks) are marked as `@conceal`. If you want to customize Treesitter conceal highlights, you can disable conceal query captures in your plugin spec.
