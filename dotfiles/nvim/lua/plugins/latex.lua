return {
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_syntax_conceal = {
        math_bounds = 0,
        greek = 1,
        math_symbols = 1,
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
    config = function()
      local has_ls, ls = pcall(require, 'luasnip')
      if not has_ls then
        return
      end

      local s = ls.snippet
      local i = ls.insert_node
      local f = ls.function_node
      local rep = require('luasnip.extras').rep
      local fmt = require('luasnip.extras.fmt').fmt

      local function sanitize_label(args)
        local text = args[1][1] or ''
        text = text:lower()
        local replacements = {
          ['ą'] = 'a',
          ['ć'] = 'c',
          ['ę'] = 'e',
          ['ł'] = 'l',
          ['ń'] = 'n',
          ['ó'] = 'o',
          ['ś'] = 's',
          ['ź'] = 'z',
          ['ż'] = 'z',
          ['Ą'] = 'a',
          ['Ć'] = 'c',
          ['Ę'] = 'e',
          ['Ł'] = 'l',
          ['Ń'] = 'n',
          ['Ó'] = 'o',
          ['Ś'] = 's',
          ['Ź'] = 'z',
          ['Ż'] = 'z',
          [' '] = '_',
          [','] = '',
          ['%.'] = '',
          [':'] = '',
          ['%('] = '',
          ['%)'] = '',
          ['"'] = '',
          ["'"] = '',
        }
        for k, v in pairs(replacements) do
          text = text:gsub(k, v)
        end
        return text:gsub('[^a-z0-9%-_]', '')
      end

      -- Headings snippets
      local headings = {
        { trig = 'part', cmd = 'part', lbl = 'part' },
        { trig = 'cha', cmd = 'chapter', lbl = 'cha' },
        { trig = 'sec', cmd = 'section', lbl = 'sec' },
        { trig = 'sub', cmd = 'subsection', lbl = 'sub' },
        { trig = 'ssub', cmd = 'subsubsection', lbl = 'ssub' },
        { trig = 'par', cmd = 'paragraph', lbl = 'par' },
      }

      for _, val in ipairs(headings) do
        ls.add_snippets('tex', {
          s(
            { trig = val.trig, dscr = 'Auto ' .. val.cmd .. ' fold inline', priority = 2000 },
            fmt(
              [[
              \{}{{{}}} \label{{{}:{}}} % (fold)

              {}
              % {} {} (end)
              ]],
              {
                f(function()
                  return val.cmd
                end),
                i(1, 'title'),
                f(function()
                  return val.lbl
                end),
                f(sanitize_label, { 1 }),
                i(0),
                f(function()
                  return val.cmd
                end),
                rep(1),
              }
            )
          ),
        })
      end

      -- Figures and tables snippets
      local floats = {
        { trig = 'fig', env = 'figure', lbl = 'fig', content = '\\centering\n\t\\includegraphics[width=0.8\\linewidth]{filename}' },
        { trig = 'tab', env = 'table', lbl = 'tab', content = '\\centering\n\t\\begin{tabular}{c c}\n\t\tA & B \\\\\n\t\\end{tabular}' },
      }

      for _, val in ipairs(floats) do
        ls.add_snippets('tex', {
          s(
            { trig = val.trig, dscr = 'Auto ' .. val.env .. ' fold inline', priority = 2000 },
            fmt(
              [[
              \begin{{{}}} % (fold)
                  {}
                  \caption{{{}}} \label{{{}:{}}}
              \end{{{}}}
              {}
              % {} {} (end)
              ]],
              {
                f(function()
                  return val.env
                end),
                i(1, val.content),
                i(2, 'Desc'),
                f(function()
                  return val.lbl
                end),
                f(sanitize_label, { 2 }),
                f(function()
                  return val.env
                end),
                i(0),
                f(function()
                  return val.env
                end),
                rep(2),
              }
            )
          ),
        })
      end
    end,
  },
}
