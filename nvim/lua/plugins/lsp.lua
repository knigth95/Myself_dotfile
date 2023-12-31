return {
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
    -- use commit
    dependencies = {
      "j-hui/fidget.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "glepnir/lspsaga.nvim",
      "onsails/lspkind.nvim",
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      "folke/neodev.nvim",
    },
    config = function()
      require("lsp_config")
    end,
  },
  { "williamboman/mason.nvim", event = "VeryLazy" },
  { "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
  { "glepnir/lspsaga.nvim", commit = "b7b4777", event = "VeryLazy" },
  { "onsails/lspkind.nvim", event = "VeryLazy" },
}
