# pair-ls.nvim

Neovim plugin for pair-ls

- [Requirements](#requirements)
- [Installation](#installation)
- [Setup](#setup)
- [Commands](#commands)

## Requirements

- Neovim 0.5+
- [pair-ls](https://github.com/stevearc/pair-ls)

pair-ls.nvim does _not_ require the use of nvim-lspconfig.

# Installation

pair-ls.nvim supports all the usual plugin managers

<details>
  <summary>Packer</summary>

```lua
require('packer').startup(function()
    use {'stevearc/pair-ls.nvim'}
end)
```

</details>

<details>
  <summary>Paq</summary>

```lua
require "paq" {
    {'stevearc/pair-ls.nvim'};
}
```

</details>

<details>
  <summary>vim-plug</summary>

```vim
Plug 'stevearc/pair-ls.nvim'
```

</details>

<details>
  <summary>dein</summary>

```vim
call dein#add('stevearc/pair-ls.nvim')
```

</details>

<details>
  <summary>Pathogen</summary>

```sh
git clone --depth=1 https://github.com/stevearc/pair-ls.nvim.git ~/.vim/bundle/
```

</details>

<details>
  <summary>Neovim native package</summary>

```sh
git clone --depth=1 https://github.com/stevearc/pair-ls.nvim.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/pair-ls/start/pair-ls.nvim
```

</details>

## Setup

Note that the default `cmd` will only work with static site WebRTC connections.
See the [pair-ls](https://github.com/stevearc/pair-ls) repo for for more ways to
share.

```lua
-- Call the setup function
require("pair-ls").setup({
  -- The pair-ls command to run
  cmd = { "pair-ls", "lsp" },

  -- The function configures the root directory for the server
  root_dir = function(fname, util)
    return util.root_pattern(".git", ".hg")(fname) or vim.loop.cwd()
  end,

  -- Pass a function here to run custom logic on attach
  on_attach = function(client, bufnr) end,

  -- See :help vim.lsp.start_client
  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = nil,
  },
})
```

## Commands

| Command       | description                                |
| ------------- | ------------------------------------------ |
| `Pair`        | Start the pair-ls server                   |
| `PairUrl`     | Show the sharing URL                       |
| `PairConnect` | Initiate or respond to a WebRTC connection |
| `PairStop`    | Stop the pair-ls server                    |
