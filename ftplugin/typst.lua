vim.bo.tabstop = 2      -- size of a hard tabstop (ts).
vim.bo.shiftwidth = 2   -- size of an indentation (sw).
vim.bo.expandtab = true -- always uses spaces instead of tab characters (et).
vim.bo.softtabstop = 2  -- number of spaces a <Tab> counts for. When 0, feature is off (sts).
vim.o.pumheight = 7
vim.opt.colorcolumn = "80"
vim.cmd('set fileformat=unix')


vim.g.typst_pdf_viewer = "evince"
-- vim.cmd("set lazyredraw")
-- vim.cmd("set nocursorline")
-- vim.cmd("set norelativenumber")
vim.cmd("set synmaxcol=80")


-- require('lspconfig').typst_lsp.setup {
-- 	settings = {
-- 		exportPdf = "never" -- Choose onType, onSave or never.
-- 		-- serverPath = "" -- Normally, there is no need to uncomment it.
-- 	}
-- }


require('lspconfig').ltex.setup({
	filetypes = { "vimwiki", "markdown", "md", "pandoc", "vimwiki.markdown.pandoc" }, --"typst"-- },
	flags = { debounce_text_changes = 300 },
	settings = {
		ltex = {
			-- language = "en"
			language = "fr"
		}
	},
})

require('lspconfig').tinymist.setup {
	offset_encoding = "utf-8",
}

require 'typst-preview'.setup {
	-- Setting this true will enable printing debug information with print()
	debug = false,

	-- This function will be called to determine the root of the typst project
	get_root = function(bufnr_of_typst_buffer)
		return vim.fn.getcwd()
	end,
}
