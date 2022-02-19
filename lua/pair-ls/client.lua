local config = require("pair-ls.config")
local util = require("pair-ls.util")
local M = {}

local client, id, share_url

local should_attach = function(bufnr)
  if
    vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "" or vim.api.nvim_buf_get_name(bufnr) == ""
  then
    return false
  end

  return true
end

M.try_add = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not should_attach(bufnr) then
    return false
  end

  id = id or M.start_client(vim.api.nvim_buf_get_name(bufnr))
  if not id then
    return
  end

  local did_attach = vim.lsp.buf_is_attached(bufnr, id) or vim.lsp.buf_attach_client(bufnr, id)
  if not did_attach then
    vim.notify(string.format("pair-ls failed to attach to buffer %d", bufnr), vim.log.levels.ERROR)
  end

  return did_attach
end

M.is_attached = function(bufnr)
  return vim.lsp.buf_is_attached(bufnr or 0, id)
end

M.get_id = function()
  return id
end

M.get_client = function()
  return client
end

local message_type_map = {
  Error = vim.log.levels.ERROR,
  Warning = vim.log.levels.WARN,
  Info = vim.log.levels.INFO,
  Log = vim.log.levels.DEBUG,
}
local handlers = {
  ["window/showMessage"] = function(_err, result, context, _config)
    local client_id = context.client_id
    if client_id ~= id then
      return
    end
    local message_type = result.type
    local message = result.message
    if not client then
      vim.notify("PairLS client has shut down after receiving the message", vim.log.levels.ERROR)
    end
    if message_type == vim.lsp.protocol.MessageType.Error then
      vim.notify("PairLS: " .. message, vim.log.levels.ERROR)
    else
      local message_type_name = vim.lsp.protocol.MessageType[message_type]
      -- Special case if we're receiving the share url
      if string.gmatch(message, "^Sharing: ") then
        share_url = string.sub(message, 9)
        M.show_share_url()
      else
        vim.notify(string.format("PairLS: %s", message), message_type_map[message_type_name])
      end
    end
    return result
  end,
}

M.start_client = function(fname)
  local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
    experimental = {
      cursor = {
        position = true,
      },
    },
  })
  local lsp_conf = {
    name = "pair-ls",
    root_dir = config.root_dir(fname),
    capabilities = capabilities,
    handlers = handlers,
    on_init = function(new_client, _initialize_result)
      client = new_client
    end,
    on_exit = function()
      id = nil
      client = nil
      share_url = nil
    end,
    cmd = config.cmd,
    flags = config.flags,
    -- Add this after Neovim client supports multiple servers with different
    -- offset encodings: https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L1812
    -- offset_encoding = "utf-8",
    on_attach = vim.schedule_wrap(function(_, bufnr)
      if bufnr == vim.api.nvim_get_current_buf() then
        M.setup_buffer(bufnr)
      elseif vim.api.nvim_buf_is_valid(bufnr) then
        vim.cmd(
          string.format(
            [[autocmd BufEnter <buffer=%d> ++once unsilent lua require("pair-ls.client").setup_buffer(%d)]],
            bufnr,
            bufnr
          )
        )
      end
    end),
  }

  id = vim.lsp.start_client(lsp_conf)

  if not id then
    vim.notify("Failed to start pair-ls", vim.log.levels.ERROR)
  end

  return id
end

M.setup_buffer = function(bufnr)
  if not client then
    vim.notify(
      string.format("unable to set up buffer %d (client not active)", bufnr),
      vim.log.levels.WARN
    )
    return
  end

  M.send_cursor_pos()
  vim.cmd([[aug PairLSBuffer
      au! * <buffer>
      autocmd CursorMoved,CursorMovedI <buffer> lua require('pair-ls.client').send_cursor_pos()
      " Defer so that we can send the actual cursor position instead of {1, 0}
      autocmd BufEnter <buffer> lua vim.defer_fn(require('pair-ls.client').send_cursor_pos, 10)
      aug END]])

  config.on_attach(client, bufnr)
end

M.send_cursor_pos = function()
  if not client then
    return
  end
  local mode = vim.api.nvim_get_mode().mode
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  if string.match(mode, "^[vV]") then
    -- This is the best way to get the visual selection at the moment
    -- https://github.com/neovim/neovim/pull/13896
    local _, start_lnum, start_col, _ = unpack(vim.fn.getpos("v"))
    local _, end_lnum, end_col, _, _ = unpack(vim.fn.getcurpos())
    params.range = {
      start = util.make_position_param(0, start_lnum, start_col, client.offset_encoding),
      ["end"] = util.make_position_param(0, end_lnum, end_col, client.offset_encoding),
    }
  end
  client.notify("experimental/cursor", params)
end

M.connect_to_peer = function(token)
  if not client then
    vim.notify("PairLS not running", vim.log.levels.ERROR)
    return
  end
  local params = {
    token = token,
  }
  client.request("experimental/connectToPeer", params, function(err, result, context, _config)
    if err then
      vim.notify(tostring(err), vim.log.levels.ERROR)
      return
    end
    if result then
      local value = result.url or result.token
      vim.fn.setreg("", value)
      vim.fn.setreg("+", value)
      print(value)
      vim.notify("PairLS: token copied", vim.log.levels.INFO)
    end
  end)
end

M.show_share_url = function()
  if share_url == nil then
    vim.notify("PairLS has no sharing URL", vim.log.levels.ERROR)
  else
    vim.fn.setreg("", share_url)
    vim.fn.setreg("+", share_url)
    vim.notify(string.format("PairLS: %s", share_url), vim.log.levels.INFO)
  end
end

M.stop = function()
  if id then
    vim.lsp.stop_client(id)
  end
end

return M
