# nvim-clangd-hl
This plugin provides semantic highlighting for the nvim-lsp clangd client. 
It uses Semantic Tokens as described in the [LSP 3.16 Specification](https://microsoft.github.io/language-server-protocol/specifications/specification-3-16/#textDocument_semanticTokens)

# Installation
Install with your favourite plugin manager, then call `.on_attach()`, example:
```lua
:lua << EOF
    local clangd_on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require'nvim-clangd-hl'.on_attach()
    end

    local nvim_lsp = require('nvim_lsp')
    nvim_lsp.clangd.setup({
        on_attach = clangd_on_attach
    })
EOF
```

# Requirements
- Neovim nightly
- Clangd 11.0 rc1+ (Releases can be found here: https://github.com/clangd/clangd/releases)
