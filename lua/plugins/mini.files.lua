return {
	"nvim-mini/mini.files",
	dependencies = {
		"nvim-mini/mini.icons",
	},
	config = function()
		require("mini.files").setup({})
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesWindowOpen",
			callback = function(args)
				local win_id = args.data.win_id

				local config = vim.api.nvim_win_get_config(win_id)
				config.border = "single"
				vim.api.nvim_win_set_config(win_id, config)
			end,
		})

		vim.keymap.set("n", "<leader>`", ":lua MiniFiles.open()<CR>", { desc = "Open Mini Files" })
	end,
}
