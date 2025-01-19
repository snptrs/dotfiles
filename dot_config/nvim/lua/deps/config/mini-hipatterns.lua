return {
  conf = function()
    local hipatterns = require 'mini.hipatterns'

    -- Returns hex color group for matching short hex color.
    ---@param match string
    ---@return string
    local hex_color_short = function(_, match)
      local style = 'bg' -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
      local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
      local hex = string.format('#%s%s%s%s%s%s', r, r, g, g, b, b)
      return hipatterns.compute_hex_color_group(hex, style)
    end

    -- Returns hex color group for matching rgb() color.
    --
    ---@param match string
    ---@return string
    local rgb_color = function(_, match)
      local style = 'bg' -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
      local red, green, blue = match:match 'rgb%((%d+), ?(%d+), ?(%d+)%)'
      local hex = string.format('#%02x%02x%02x', red, green, blue)
      return hipatterns.compute_hex_color_group(hex, style)
    end

    -- Returns hex color group for matching rgba() color
    -- or false if alpha is nil or out of range.
    -- The use of the alpha value refers to a black background.
    --
    ---@param match string
    ---@return string|false
    local rgba_color = function(_, match)
      local style = 'bg' -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
      local red, green, blue, alpha = match:match 'rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)'
      alpha = tonumber(alpha)
      if alpha == nil or alpha < 0 or alpha > 1 then
        return false
      end
      local hex = string.format('#%02x%02x%02x', red * alpha, green * alpha, blue * alpha)
      return hipatterns.compute_hex_color_group(hex, style)
    end

    hipatterns.setup {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
        -- `#rgb`
        hex_color_short = { pattern = '#%x%x%x%f[%X]', group = hex_color_short },
        -- `rgb(255, 255, 255)`
        rgb_color = { pattern = 'rgb%(%d+, ?%d+, ?%d+%)', group = rgb_color },
        -- `rgba(255, 255, 255, 0.5)`
        rgba_color = {
          pattern = 'rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)',
          group = rgba_color,
        },
      },
    }
  end,
}
