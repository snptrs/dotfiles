return {
  setup = function()
    require('mini.visits').setup()
  end,
  keys = {
    {
      '<leader>vd',
      function()
        local picker = require 'mini.pick'
        local visits = require 'mini.visits'

        local remove_paths = function(items)
          for _, v in ipairs(items) do
            visits.remove_path(v)
          end

          picker.set_picker_items(visits.list_paths())
          return true
        end

        picker.setup {
          source = {
            items = visits.list_paths(),
            choose = function(item)
              return remove_paths { item }
            end,
            choose_marked = remove_paths,
          },
        }

        picker.start()
      end,
      desc = 'Delete path from mini.visits',
    },
  },
}
