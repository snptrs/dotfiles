return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  cmd = 'Telescope',
  keys = {
    {
      '<leader><space>',
      function()
        require('telescope.builtin').buffers { sort_mru = true }
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = '[/] Fuzzily search in current buffer',
    },
    { '<leader>?', require('telescope.builtin').oldfiles, desc = '[?] Find recently opened files' },
    {
      '<leader>ff',
      function()
        require('telescope.builtin').find_files {
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '--no-ignore',
            '--ignore-file',
            '/Users/seanpeters/.config/nvim/.rg-ignore',
          },
        }
      end,
      desc = '[F]ind [F]iles',
    },
    { '<leader>fh', require('telescope.builtin').help_tags, desc = '[F]ind [H]elp' },
    { '<leader>fw', require('telescope.builtin').grep_string, desc = '[F]ind current [W]ord' },
    { '<leader>fg', require('telescope.builtin').live_grep, desc = '[F]ind by [G]rep' },
    {
      '<leader>fo',
      "<cmd>lua require('telescope.builtin').live_grep({ grep_open_files = true })<cr>",
      silent = true,
      desc = '[F]ind by grep in [O]pen files',
    },
    { '<leader>fd', require('telescope.builtin').diagnostics, desc = '[F]ind [D]iagnostics' },
    { '<leader>fr', require('telescope.builtin').resume, desc = '[F]ind [R]esume' },
    { '<leader>gf', require('telescope.builtin').git_files, desc = 'Search [G]it [F]iles' },
    { '<leader>gb', require('telescope.builtin').git_branches, desc = 'Search [G]it [B]ranches' },
    { '<leader>gs', require('telescope.builtin').git_status, desc = 'Search [G]it [S]tatus' },
    { '<leader>gc', require('telescope.builtin').git_commits, desc = 'Search [G]it [C]ommits' },
    { '<leader>fG', '<cmd>LiveGrepGitRoot<cr>', desc = '[F]ind by [G]rep on Git Root' },
  },
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    local telescopeActions = require 'telescope.actions'
    local action_layout = require 'telescope.actions.layout'

    local select_one_or_multi = function(prompt_bufnr)
      local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format('%s %s', 'edit', j.path))
          end
        end
      else
        require('telescope.actions').select_default(prompt_bufnr)
      end
    end

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-t>'] = require('trouble.sources.telescope').add,
            ['<C-q>'] = telescopeActions.smart_send_to_qflist + telescopeActions.open_qflist,
            ['<M-p>'] = action_layout.toggle_preview,
            ['<C-u>'] = false,
            -- ['<esc>'] = telescopeActions.close,
          },
          n = {
            ['<C-t>'] = require('trouble.sources.telescope').add,
            ['l'] = telescopeActions.select_default,
            ['<C-q>'] = telescopeActions.smart_send_to_qflist + telescopeActions.open_qflist,
            ['<M-p>'] = action_layout.toggle_preview,
          },
        },
        preview = {
          ls_short = true,
          filesize_limit = 0.3, -- MB
        },
      },
      pickers = {
        find_files = {
          layout_config = {
            preview_width = 0.4,
          },
          mappings = {
            i = {
              ['<CR>'] = select_one_or_multi,
            },
            n = {
              ['<CR>'] = select_one_or_multi,
            },
          },
        },
        live_grep = {
          layout_config = {
            preview_width = 0.4,
          },
        },
        buffers = {
          initial_mode = 'insert',
          layout_config = {
            preview_width = 0.5,
          },
          mappings = {
            i = {
              ['<C-b>'] = telescopeActions.delete_buffer,
            },
            n = {
              ['<C-b>'] = telescopeActions.delete_buffer,
            },
          },
        },
        help_tags = {
          layout_config = {
            preview_width = 0.6,
          },
        },
        git_status = {
          layout_config = {
            preview_width = 0.6,
          },
        },
        git_commits = {
          layout_config = {
            preview_width = 0.6,
          },
        },
      },
      extensions = {
        file_browser = {
          hijack_netrw = true,
          display_stat = false,
          initial_mode = 'insert',
          preview = {
            ls_short = true,
          },
          theme = 'dropdown',
          layout_config = {
            height = 0.5,
          },
        },
      },
    }

    require('telescope').load_extension 'file_browser'

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    -- Telescope live_grep in git root
    -- Function to find the git root directory based on the current buffer's path
    local function find_git_root()
      -- Use the current buffer's path as the starting point for the git search
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      -- If the buffer is not associated with a file, return nil
      if current_file == '' then
        current_dir = cwd
      else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      -- Find the Git root directory from the current file's path
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
    end

    -- Custom live_grep function to search in git root
    local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        require('telescope.builtin').live_grep {
          search_dirs = { git_root },
        }
      end
    end

    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
  end,
}
