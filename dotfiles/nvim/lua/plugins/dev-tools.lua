return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  --Doxygen
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },

    keys = {
      {
        '<leader>nc',
        function()
          require('neogen').generate { type = 'func' }
        end,
        desc = 'Doxygen: Function',
      },
      {
        '<leader>nf',
        function()
          local filename = vim.fn.expand '%:t'
          local date = os.date '%Y-%m-%d'
          local year = os.date '%Y'

          -- local author = vim.fn.system('git config user.name'):gsub('\n', '')
          local author = 'Michał Sadecki'
          local email = vim.fn.system('git config user.email'):gsub('\n', '')

          local header = {
            '/**',
            ' * @file ' .. filename,
            ' * @author ' .. author .. ' (' .. email .. ')',
            ' * @brief ',
            ' * @version 0.1',
            ' * @date ' .. date,
            ' *',
            ' * @copyright Copyright (c) ' .. year .. ' ' .. author,
            ' */',
            '',
          }

          vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
        end,
        desc = 'Doxygen: File header',
      },
    },

    config = function()
      require('neogen').setup {
        snippet_engine = 'luasnip',
        languages = {
          c = {
            template = {
              annotation_convention = 'doxygen',
            },
          },
          cpp = {
            template = {
              annotation_convention = 'doxygen',
            },
          },
        },
      }
    end,
  },
  -- Lazygit
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
}
