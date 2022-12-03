# Jumps-Section

# Features
- Support Telescope
- Show change list for section(such as function or class or define or enum or struct)
- Not add the lists when you change text in same section
- TODO: preview, fast jump, support lualine

## Installation

```lua
require('packer').startup(function()
    use {
      'guyuehuanyu/jumps-section.nvim',
      config = function() require('jumps') end
    }
end)
```

## Usage

```lua
Telescope jumps changes
```

## Mapping

```lua
["<leader>lc"] = { "<cmd> Telescope jumps changes<CR>", desc = "List change jumps" },
maps.n["<leader>lc"] = { "<cmd> Telescope jumps changes<CR>", desc = "List change jumps" },
```
