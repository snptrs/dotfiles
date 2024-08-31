return {
  'chrisgrieser/nvim-early-retirement',
  event = 'VeryLazy',
  opts = {
    -- If a buffer has been inactive for this many minutes, close it.
    retirementAgeMins = 60,
  },
}
