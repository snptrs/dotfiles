return {
  -- Autocompletion
  -- 'hrsh7th/nvim-cmp',
  -- 'yioneko/nvim-cmp',
  'iguanacucumber/magazine.nvim',
  name = 'nvim-cmp', -- Otherwise highlighting gets messed up
  enabled = false,
  -- branch = 'perf-up',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',

    -- To automatically add () after function insertion
    'windwp/nvim-autopairs',
    { 'jackieaskins/cmp-emmet', build = 'npm run release' },
    {
      'roobert/tailwindcss-colorizer-cmp.nvim',
      -- optionally, override the default options:
      opts = {
        color_square_width = 2,
      },
    },
  },
  config = function()
    -- [[ Configure nvim-cmp ]]
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load { paths = { '~/.config/nvim/lua/snippets' } }
    luasnip.config.setup {}

    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    cmp.setup {
      performance = {
        -- debounce = 250,
        -- max_view_entries = 40,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
        -- keyword_length = 2,
      },
      window = {
        completion = {
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None,CursorLine:PmenuSel',
          col_offset = -3,
          side_padding = 0,
        },
        documentation = cmp.config.window.bordered {
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
        },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local tw_item = require('tailwindcss-colorizer-cmp').formatter(entry, vim_item)
          if tw_item.kind == 'XX' then
            return tw_item
          end
          local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, vim_item)
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          kind.kind = ' ' .. (strings[1] or '') .. ' '
          kind.menu = '    (' .. (strings[2] or '') .. ')'

          return kind
        end,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<CR>'] = cmp.mapping {
        --   i = function(fallback)
        --     if cmp.visible() and cmp.get_active_entry() then
        --       cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = false }
        --     else
        --       fallback()
        --     end
        --   end,
        --   s = cmp.mapping.confirm { select = true },
        -- },
        -- ['<S-CR>'] = cmp.mapping.confirm {
        --   behavior = cmp.ConfirmBehavior.Replace,
        --   select = false,
        -- },
        ['<C-n>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-p>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'copilot', priority = 10 },
        { name = 'nvim_lsp', priority = 8 },
        { name = 'path', priority = 9 },
        -- { name = 'luasnip', priority = 5 },
        -- { name = 'emmet', priority = 4 },
      },
      sorting = {
        priority_weight = 1,
        comparators = {
          -- compare.score_offset, -- not good at all
          cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
          cmp.config.compare.order,
          cmp.config.compare.kind,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.offset,
          -- compare.scopes, -- what?
          -- compare.sort_text,
          -- compare.exact,
          -- compare.length, -- useless
        },
      },
    }
  end,
}
