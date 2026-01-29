vim.opt.syntax = "on"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.title = true

-- 임시 파일 비활성화
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true  -- undo 히스토리는 유지 (선택)
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.fileencoding = "utf-8"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.wo.signcolumn = "yes"
vim.opt.textwidth = 119
vim.opt.colorcolumn = "120"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ruler = true
vim.opt.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·"
vim.opt.list = true
vim.opt.updatetime = 300

-- Autocommands
local autocmd = vim.api.nvim_create_autocmd

-- 저장 시 trailing whitespace 제거
autocmd('BufWritePre', {
  pattern = '',
  callback = function() vim.cmd([[%s/\s\+$//e]]) end
})

-- 외부에서 파일 변경 시 자동 reload
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- 파일 변경 알림
autocmd('FileChangedShellPost', {
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.WARN)
  end,
})
