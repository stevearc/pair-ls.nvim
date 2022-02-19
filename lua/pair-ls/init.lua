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

M.connect = function(token)
  token = string.gsub(token, "^%s*(.-)%s*$", "%1")
  client.connect_to_peer(token)
end

M.setup = function(conf)
  config.update(conf)
  vim.cmd([[
    command! -bar Pair lua require('pair-ls').start()
    command! -bar PairUrl lua require('pair-ls').show_url()
    command! -bar PairStop lua require('pair-ls').stop()
    command! -bar -nargs=? PairConnect call luaeval("require('pair-ls').connect(_A)", <q-args>)
    ]])
end

return M
