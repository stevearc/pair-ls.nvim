local client = require("pair-ls.client")
local config = require("pair-ls.config")
local M = {}

M.start = function()
  vim.cmd([[aug PairLS
      au!
      autocmd BufReadPost * unsilent lua require('pair-ls.client').try_add()
      aug END]])
  client.try_add()
end

M.stop = function()
  vim.cmd([[aug PairLS
      au!
      aug END]])
  client.stop()
end

M.setup = function(conf)
  config.update(conf)
  vim.cmd([[
    command! Pair lua require('pair-ls').start()
    command! PairStop lua require('pair-ls').stop()
    ]])
end

return M
