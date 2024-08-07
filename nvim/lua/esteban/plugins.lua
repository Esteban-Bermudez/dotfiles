local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'

  -- Mapper
  use { "gregorias/nvim-mapper",
    config = function()
      require("nvim-mapper").setup {}
      require("esteban.plugins.nvim-mapper")
    end,
    before = "telescope.nvim"
  }

  -- Theme
  if vim.loop.os_uname().sysname == "Darwin" then
    use 'cormacrelf/dark-notify'
    require('dark_notify').run()
  end

  use { "catppuccin/nvim", as = "catppuccin" }
  require("catppuccin").setup({
    transparent_background = true,
    background = {
      light = "latte",
      dark = "mocha",
    },
  })
  vim.cmd.colorscheme "catppuccin"

  -- Github Copilot
  use 'github/copilot.vim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require("esteban.plugins.telescope")
    end,
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require('esteban.plugins.treesitter')
    end
  }

  -- LSP Zero
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      --- Uncomment the two plugins below if you want to manage the language servers from neovim
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },

    },
    config = function()
      require('esteban.plugins.lsp-zero')
    end

  }

  -- Nvim Tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("nvim-tree").setup()
    end
  }

  -- Vim Plugins
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'christoomey/vim-tmux-navigator'
  use 'm4xshen/autoclose.nvim'
  require("autoclose").setup()


  -- Git Signs
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('esteban.plugins.gitsigns')
    end
  }

  -- Status Line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('esteban.plugins.lualine')
    end
  }

  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
