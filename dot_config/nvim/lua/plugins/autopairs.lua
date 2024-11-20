return {
  {
    'windwp/nvim-autopairs',
    config = true,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = false, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
    },
  },
}
