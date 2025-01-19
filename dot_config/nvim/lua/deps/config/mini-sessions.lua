return {
  config = function()
    local cwd = vim.fn.getcwd()
    local project_name = cwd:match '^.+/(.+)$'

    -- close bad buffers (neo-tree, trouble, etc) to avoid saving them in the session
    -- otherwise, loading the session would open them with the wrong size
    local close_bad_buffers = function()
      local buffer_numbers = vim.api.nvim_list_bufs()
      for _, buffer_number in pairs(buffer_numbers) do
        local buffer_type = vim.api.nvim_buf_get_option(buffer_number, 'buftype')
        local buffer_file_type = vim.api.nvim_buf_get_option(buffer_number, 'filetype')

        if buffer_type == 'nofile' or buffer_file_type == 'norg' then
          vim.api.nvim_buf_delete(buffer_number, { force = true })
        end
      end
    end

    local count_open_file_buffers = function()
      local count = 0
      for _, buffer_number in pairs(vim.api.nvim_list_bufs()) do
        local buffer_name = vim.api.nvim_buf_get_name(buffer_number)
        local buffer_file_type = vim.api.nvim_buf_get_option(buffer_number, 'filetype')

        if buffer_name ~= '' and buffer_file_type ~= 'norg' then
          count = count + 1
        end
      end
      return count
    end

    local minisessions = require 'mini.sessions'
    minisessions.setup {
      autoread = false,
      autowrite = true,
      file = '',
      force = { read = false, write = true, delete = false },
      hooks = {
        pre = { read = nil, write = close_bad_buffers, delete = nil },
        post = { read = nil, write = nil, delete = nil },
      },
      verbose = { read = false, write = true, delete = true },
    }

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        close_bad_buffers()
        local number_of_open_buffers = count_open_file_buffers()
        if number_of_open_buffers > 0 then
          minisessions.write(project_name)
        end
      end,
    })

    vim.keymap.set('n', '<leader>sl', function()
      MiniSessions.select()
    end, { desc = 'List sessions' })
    vim.keymap.set('n', '<leader>ss', function()
      MiniSessions.read(project_name)
    end, { desc = 'Load current project session' })
  end,
}
