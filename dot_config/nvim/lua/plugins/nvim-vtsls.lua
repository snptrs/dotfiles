return {
  {
    'yioneko/nvim-vtsls',
    config = function()
      require('vtsls').config {
        -- customize handlers for commands
        handlers = {
          source_definition = function(err, locations) end,
          file_references = function(err, locations) end,
          code_action = function(err, actions) end,
        },
        -- automatically trigger renaming of extracted symbol
        refactor_auto_rename = true,
        refactor_move_to_file = {
          -- If dressing.nvim is installed, telescope will be used for selection prompt. Use this to customize
          -- the opts for telescope picker.
          telescope_opts = function(items, default) end,
        },
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      }
    end,
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
