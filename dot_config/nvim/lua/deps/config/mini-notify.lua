local M = {}

function M.config()
  local get_icon = function(level)
    local icons = {
      INFO = ' ',
      WARN = ' ',
      ERROR = ' ',
    }
    return icons[level] or icons['INFO']
  end

  local notify_filter = function(notif_arr)
    local filter = function(notif)
      if notif.msg:match 'lua_ls' or notif.msg:match 'vtsls: Analyzing' then
        return false
      end
      -- Keep others
      return true
    end
    notif_arr = vim.tbl_filter(filter, notif_arr)
    ---@diagnostic disable-next-line: undefined-global
    return MiniNotify.default_sort(notif_arr)
  end

  require('mini.notify').setup {
    lsp_progress = {
      enable = true,
    },
    content = {
      format = function(notification)
        return string.format(' %s | %s', get_icon(notification.level), notification.msg)
      end,
      sort = notify_filter,
    },
  }

  local opts = {
    ERROR = {
      duration = 5000,
    },
  }
  vim.notify = require('mini.notify').make_notify(opts)

  vim.keymap.set('n', '<leader>nh', function()
    MiniNotify.show_history()
  end, { desc = 'Notification history' })

  vim.keymap.set('n', '<leader>nc', function()
    MiniNotify.clear()
  end, { desc = 'Clear notifications' })
end

return M
