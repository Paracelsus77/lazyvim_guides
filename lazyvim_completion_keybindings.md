# Updated Neovim & LazyVim Keybindings & Completion Guide

This cheat sheet summarizes your completion shortcuts and keybinding configurations following the `blink.cmp` update.

---

## 1. Updated Popup Completion Controls

With `["<CR>"] = { "fallback" }` configured in `blink.cmp`, `<CR>` (Enter) **no longer confirms suggestions**. It now exclusively inserts a newline.

| Action | Keybinding | Mnemonic / Meaning | Behavior |
| :--- | :--- | :--- | :--- |
| **Move Down** | `<C-n>` or `<Down>` | **N**ext | Selects the next item down in the completion menu. |
| **Move Up** | `<C-p>` or `<Up>` | **P**revious | Selects the previous item up in the completion menu. |
| **Accept Completion** | `<C-y>` | **Y**es / **Y**ank | Confirms and inserts the currently highlighted suggestion. |
| **Dismiss / Cancel** | `<C-e>` | **E**xit / **E**rase | Closes the completion popup without modifying text. |
| **New Line** | `<CR>` *(Enter)* | Standard Return | Inserts a new line directly (Does **NOT** accept completion). |
| **New Line (Direct)** | `<S-CR>` | **S**hift + **E**nter | Bypasses completion popup and creates a new line. |

---

## 2. Keybinding Behavior Changes Summary

### What Changed?
* **`<CR>` (Enter Key):** Changed from *Confirm Completion* to *Fallback* (standard newline execution).
* **`import sounddevice as sd` + `<CR>`:** Typing `sd` and pressing Enter now leaves `sd` intact and moves your cursor to a new line.

### What Remained the Same?
* **`<C-y>`** remains the standard key to confirm completions when you *do* want to accept a suggestion.
* **`<C-n>` / `<C-p>`** continue to serve as the default list navigation shortcuts.
* **`<leader>` (`Space`)** and **`<localleader>` (`\`)** remain unchanged.

---

## 3. Active `blink.cmp` Configuration File

**File Location:** `~/.config/nvim/lua/plugins/completion.lua`

```lua
return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "fallback" }, -- Enter only creates a new line
      },
    },
  },
}
```

---

## 4. Leader Key Definitions

* **Global Leader (`<leader>`):** `Space` — Triggers general editor shortcuts (e.g., `<leader>ff` for file search).
* **Local Leader (`<localleader>`):** `\` *(Backslash)* — Triggers filetype-specific shortcuts.
