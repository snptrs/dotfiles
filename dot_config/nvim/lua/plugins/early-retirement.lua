return {
  'chrisgrieser/nvim-early-retirement',
  event = 'VeryLazy',
  opts = {
    -- If a buffer has been inactive for this many minutes, close it.
    retirementAgeMins = 60,

    -- When a file is deleted, for example via an external program, delete the
    -- associated buffer as well. Requires Neovim >= 0.10.
    -- (This feature is independent from the automatic closing)
    deleteBufferWhenFileDeleted = true,
  },
}
