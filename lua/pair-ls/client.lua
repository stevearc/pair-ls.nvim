local config = require("pair-ls.config")
local util = require("pair-ls.util")
local M = {}

local client, id

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
    on_init = function(new_client, _initialize_result)
      client = new_client
    end,
    on_exit = function()
      id = nil
      client = nil
    end,
    cmd = config.cmd,
    flags = config.flags,
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
  local params = vim.lsp.util.make_position_params()
  if string.match(mode, "^[vV]") then
    local offset_encoding = vim.lsp.util._get_offset_encoding(0)
    -- This is the best way to get the visual selection at the moment
    -- https://github.com/neovim/neovim/pull/13896
    local _, start_lnum, start_col, _ = unpack(vim.fn.getpos("v"))
    local _, end_lnum, end_col, _, _ = unpack(vim.fn.getcurpos())
    params.range = {
      start = util.make_position_param(0, start_lnum, start_col, offset_encoding),
      ["end"] = util.make_position_param(0, end_lnum, end_col, offset_encoding),
    }
  end
  client.notify("experimental/cursor", params)
end

M.stop = function()
  if id then
    vim.lsp.stop_client(id)
  end
end

return M