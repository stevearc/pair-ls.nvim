local M = {}

M.make_position_param = function(bufnr, lnum, col, offset_encoding)
  local row = lnum - 1
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, true)[1]
  if not line then
    return { line = 0, character = 0 }
  end

  local ok, ret_col = pcall(vim.lsp.util._str_utfindex_enc, line, col, offset_encoding)
  -- The end range can be off the line
  if not ok then
    ret_col = vim.lsp.util._str_utfindex_enc(line, col - 1, offset_encoding)
  end
  return { line = row, character = ret_col }
end

return M
