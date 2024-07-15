return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    -- document existing key chains
    require('which-key').register {
      { '<leader>c', group = '[C]ode' },
      { '<leader>c_', hidden = true },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>d_', hidden = true },
      { '<leader>g', group = '[G]it' },
      { '<leader>g_', hidden = true },
      { '<leader>gd', group = '[D]iff' },
      -- { '<leader>gd_', hidden = true },
      { '<leader>h', group = 'More git' },
      -- { '<leader>h_', hidden = true },
      { '<leader>r', group = '[R]ename' },
      { '<leader>r_', hidden = true },
      { '<leader>s', group = '[S]earch' },
      { '<leader>s_', hidden = true },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>w_', hidden = true },
      { '<leader>x', group = 'Trouble' },
      { '<leader>x_', hidden = true },
    }
  end,
}
