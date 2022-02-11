local default_config = {
  -- The pair-ls command to run
  cmd = { "pair-ls", "lsp", "-port", "8080" },

  -- The function configures the root directory for the server
  root_dir = function(fname)
    return vim.loop.cwd()
  end,

  -- Pass a function here to run custom logic on attach
  on_attach = function(client, bufnr) end,

  -- See :help vim.lsp.start_client
  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = nil,
  },
}

local M = vim.deepcopy(default_config)

M.update = function(opts)
  local newconf = vim.tbl_deep_extend("force", default_config, opts or {})
  for k, v in pairs(newconf) do
    M[k] = v
  end
end

return M
