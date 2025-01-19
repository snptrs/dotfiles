deps.later(function()
  deps.add {
    source = 'chrisgrieser/nvim-early-retirement',
  }
  ---@diagnostic disable-next-line: missing-fields
  require('early-retirement').setup {
    -- If a buffer has been inactive for this many minutes, close it.
    retirementAgeMins = 60,
    deleteBufferWhenFileDeleted = true,
  }
end)
