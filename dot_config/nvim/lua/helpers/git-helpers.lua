local M = {}

M.compute_diff_path = function()
  local pattern = '^%+%+%+ b/(.*)$'
  for i = vim.fn.line '.', 1, -1 do
    local path = vim.fn.getline(i):match(pattern)
    if path ~= nil then
      return path
    end
  end
end

M.compute_diff_lnum = function()
  local i, offsets = vim.fn.line '.', { [' '] = 0, ['-'] = 0, ['+'] = 0 }
  while i > 0 do
    local prefix = vim.fn.getline(i):sub(1, 1)
    if not (prefix == ' ' or prefix == '-' or prefix == '+') then
      break
    end
    offsets[prefix] = offsets[prefix] + 1
    i = i - 1
  end

  local hunk_start_after = string.match(vim.fn.getline(i), '^@@ %-%d+,?%d* %+(%d+),?%d* @@')
  if hunk_start_after == nil then
    return
  end
  return math.max(1, tonumber(hunk_start_after) + offsets[' '] + offsets['+'] - 1)
end

M.edit_path_at_cursor = function()
  local path, lnum = M.compute_diff_path(), M.compute_diff_lnum()
  if not (path and lnum) then
    return vim.notify('Could not find both path and line', vim.log.levels.WARN)
  end
  vim.cmd('vertical split ' .. vim.fn.fnameescape(path))
  vim.api.nvim_win_set_cursor(0, { lnum, 0 })
end

return M
