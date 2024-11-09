-- local port = os.getenv('GDScript_Port') or '6005'
-- local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
-- local pipe = '/home/nicholasmabe/gdtmp/godot.pipe'

-- vim.lsp.start({
--   name = 'Godot',
--   cmd = cmd,
--   root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
--   on_attach = function(client, bufnr)
--     vim.api.nvim_command([[echo serverstart(']] .. pipe .. [[')]])
--
--   end
-- })

-- require("lspconfig")["gdscript"].setup({
--     	name = "godot",
--     	cmd = vim.lsp.rpc.connect("127.0.0.1", "6005"),
--     })


