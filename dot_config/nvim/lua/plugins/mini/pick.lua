return {
  keys = {
    {
      "<leader>ff",
      function() require("mini.pick").builtin.files() end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function() require("mini.pick").builtin.grep_live() end,
      desc = "Grep files",
    },
    {
      "<leader>fr",
      function() require("mini.pick").builtin.resume() end,
      desc = "Resume find",
    },
    {
      "<space><space>",
      function() require("mini.pick").builtin.buffers() end,
      desc = "Open buffers"
    },
    {
      "gd",
      function()
        require("mini.extra").pickers.lsp({ scope = "definition" })
      end,
      desc = "Goto definition",
    },
    {
      "gr",
      function()
        require("mini.extra").pickers.lsp({ scope = "references" })
      end,
      desc = "Goto references"
    },
    {
      "gD",
      function()
        require("mini.extra").pickers.lsp({ scope = "declaration" })
      end,
      desc = "Goto declaration"
    },
    {
      "gT",
      function()
        require("mini.extra").pickers.lsp({ scope = "type_definition" })
      end,
      desc = "Goto type definition"
    },
  },

  setup = function()
    require('mini.pick').setup({
      options = {
        content_from_bottom = false,
      },
      window = {
        config = function()
          local height = math.floor(0.618 * vim.o.lines)
          local width = math.floor(0.618 * vim.o.columns)
          return {
            anchor = 'NW',
            height = height,
            width = width,
            row = math.floor(0.5 * (vim.o.lines - height)),
            col = math.floor(0.5 * (vim.o.columns - width)),
          }
        end
      }
    })
  end
}
