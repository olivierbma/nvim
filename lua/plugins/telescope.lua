return {
	'nvim-telescope/telescope.nvim',
	version = '*',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local function filenameFirst(_, path)
			local tail = vim.fs.basename(path)
			local parent = vim.fs.dirname(path)
			if parent == "." then return tail end
			return string.format("%s\t\t%s", tail, parent)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "TelescopeResults",
			callback = function(ctx)
				vim.api.nvim_buf_call(ctx.buf, function()
					vim.fn.matchadd("TelescopeParent", "\t\t.*$")
					vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
				end)
			end,
		})

		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},

				theme = "dropdown",

				layout_strategy = 'vertical',
				layout_config = {
					vertical = { preview_height = 9, width = 0.9, height = 0.9, preview_cutoff = 0 },
					horizontal = { preview_height = 9, width = 0.9, height = 0.9 }
				},

				path_display = {
					filename_first = {
						reverse_directories = false
					}
				},

			},
			pickers = {

				git_status = { path_display = filenameFirst, },
				find_files = { path_display = filenameFirst, },


				lsp_document_symbols = {

					layout_strategy = 'vertical',

				}
			},
		}

		pcall(require('telescope').load_extension, 'fzf')


		require('telescope').setup({
			defaults = {
				file_ignore_patterns = {
					"build",
					"zig-out",
					"zig-cache",
					"%.class",
					"^./.git/",
					"^node_modules/",
					"^target/",
					"^dist/"
				}
			}
		}
		)

		vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
			{ desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
			{ desc = '[ ] Find existing buffers' })
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
			{ desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
		vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols,
			{ desc = '[S]earch [O]utline' })

		vim.keymap.set('n', '<leader>sm', require('telescope.builtin').man_pages,
			{ desc = '[S]earch [M]an pages' })
	end
}
