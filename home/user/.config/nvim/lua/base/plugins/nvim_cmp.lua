local border_opts = {
  border = "single",
  winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function setup_cmp()
    local cmp = require("cmp")

    cmp.setup({
      completion = {
        autocomplete = false
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
      },

      window = {
        completion = cmp.config.window.bordered(border_opts),
        documentation = cmp.config.window.bordered(border_opts),
      },

      sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        }, {
        }),
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
end

local function setup_lspconfig()
  local nvim_lsp = require("lspconfig")


  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches

  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

  nvim_lsp.clangd.setup {
    capabilities = capabilities,
  }
end

return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = setup_cmp,
        keys = {
            
        },
    },
    {
        'neovim/nvim-lspconfig',
        config = setup_lspconfig,
        keys = {
          
        },
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = 'hrsh7th/nvim-cmp',
        config = function()
            local ls = require("luasnip")

            vim.g.snips_author = 'thek4n'
            vim.g.snips_email = 'thek4n@yandex.com'
            vim.g.snips_github = 'https://github.com/thek4n'


            local function jump(val)
                return function()
                    ls.jump(val)
                end
            end


            local map = vim.keymap.set
            map({'i', 's'}, '<C-n>', jump(1))
            map({'i', 's'}, '<C-p>', jump(-1))


            local luasnip_loaders = require("luasnip.loaders.from_snipmate")

            luasnip_loaders.lazy_load()
        end
    },
    {
        'honza/vim-snippets'
    },
}
