-- Owijanie tekstu
return {
  'kylechui/nvim-surround',
  version = '*',
  event = 'VeryLazy',
  -- Zamiast 'config = function...', używamy 'opts'
  opts = {
    surrounds = {
      -- Definiujemy klawisz 'l' (LaTeX Command)
      ['l'] = {
        add = function()
          local config = require 'nvim-surround.config'
          local cmd = config.get_input 'LaTeX Command: '
          if cmd then
            -- Zwraca: { { "\komenda{" }, { "}" } }
            return { { '\\' .. cmd .. '{' }, { '}' } }
          end
        end,
      },
      -- Opcjonalnie: Naprawa klawisza 'f' (Function), żeby też używał klamer {} zamiast ()
      ['f'] = {
        add = function()
          local config = require 'nvim-surround.config'
          local cmd = config.get_input 'Function: '
          if cmd then
            return { { '\\' .. cmd .. '{' }, { '}' } }
          end
        end,
      },
    },
  },
}
-- Użycie: Zaznaczyć v. Shift + s, $, (, {, l (funkcja)
