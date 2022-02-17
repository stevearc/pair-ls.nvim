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

M.show_url = client.show_share_url

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
    command! PairUrl lua require('pair-ls').show_url()
    command! PairStop lua require('pair-ls').stop()
    ]])
end

return M
