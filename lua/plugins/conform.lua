return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
	},
	config = function()
		require("conform").setup({
			formatters = {
				csharpier = {
					command = "mise exec dotnet@9 -- " .. vim.fn.stdpath("data") .. "/mason/bin/csharpier",
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				markdown = { "prettier" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				cs = { "csharpier" },
			},
		})
	end,
}
