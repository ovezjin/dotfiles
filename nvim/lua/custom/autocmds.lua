-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Big file
vim.filetype.add {
  pattern = {
    ['.*'] = {
      function(path, buf)
        return vim.bo[buf].filetype ~= 'bigfile' and path and vim.fn.getfsize(path) > vim.g.bigfile_size and 'bigfile' or nil
      end,
    },
  },
}

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'bigfile',
  pattern = 'bigfile',
  callback = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ''
    end)
  end,
})
