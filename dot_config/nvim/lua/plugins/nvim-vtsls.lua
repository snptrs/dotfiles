return {
  {
    'yioneko/nvim-vtsls',
    enabled = true,
    keys = {
      {
        'gD',
        function()
          require('vtsls').commands.goto_source_definition(0)
        end,
        desc = 'Goto Source Definition',
      },
      {
        'gR',
        function()
          require('vtsls').commands.file_references(0)
        end,
        desc = 'File References',
      },
      {
        '<leader>co',
        function()
          require('vtsls').commands.organize_imports(0)
        end,
        desc = 'Organize Imports',
      },
      {
        '<leader>cs',
        function()
          require('vtsls').commands.sort_imports(0)
        end,
        desc = 'Sort Imports',
      },
      {
        '<leader>cM',
        function()
          require('vtsls').commands.add_missing_imports(0)
        end,
        desc = 'Add missing imports',
      },
      {
        '<leader>cu',
        function()
          require('vtsls').commands.remove_unused_imports(0)
        end,
        desc = 'Remove unused imports',
      },
      {
        '<leader>cD',
        function()
          require('vtsls').commands.fix_all(0)
        end,
        desc = 'Fix all diagnostics',
      },
      {
        '<leader>cV',
        function()
          require('vtsls').commands.select_ts_version(0)
        end,
        desc = 'Select TS workspace version',
      },
    },
  },
}
