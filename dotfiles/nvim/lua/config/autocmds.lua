local highlight_group = vim.api.nvim_set_hl

-- Funkcja pomocnicza do usuwania tła
local function set_transparent(group)
  highlight_group(0, group, { bg = 'none' })
end

-- Lista grup, które mają być przezroczyste
local groups = {
  'Normal',
  'NormalNC',
  'NormalFloat',
  'FloatBorder', -- Główne okna
  'NeoTreeNormal',
  'NeoTreeNormalNC', -- Tło Neo-tree
  'NeoTreeEndOfBuffer', -- Puste miejsce w Neo-tree
  'NeoTreeWinSeparator', -- Linia oddzielająca
  'LineNr',
  'SignColumn', -- Pasek z numerami linii
}

-- Text width
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.textwidth = 80 -- Twarda granica 80 znaków
    vim.opt_local.formatoptions:remove 'l'
    vim.opt_local.formatoptions:append 't' -- Włącz auto-wrap tekstu
    vim.opt_local.formatoptions:append 'c' -- zawijanie komentarzy
    vim.opt_local.formatoptions:append 'r'
    vim.opt_local.wrapmargin = 0 -- Margines na 0
    vim.opt_local.linebreak = true -- Zawijaj całe słowa (nie tnij ich w połowie)
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    -- Jeśli używasz paska NvimTree lub Neo-tree i on też traci przezroczystość:
    vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.c', '*.cpp', '*.h', '*.hpp', '*.lua' },
  callback = function()
    vim.fn.matchadd('DiagnosticInfo', [[@\w\+]])
    vim.fn.matchadd('DiagnosticWarn', [=[\[in\]]=]) -- na żółto/pomarańczowo
    vim.fn.matchadd('DiagnosticOk', [=[\[out\]]=]) -- na zielono
    vim.fn.matchadd('DiagnosticInfo', [=[\[in,out\]]=]) -- na niebiesko
  end,
})
