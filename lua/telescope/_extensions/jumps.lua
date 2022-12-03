local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
	error 'This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)'
end

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local make_entry = require "telescope.make_entry"


function show_changes(opts)
	local jumps = require "jumps".jumps_changes
	local userchangelist = jumps

  local jumplist = userchangelist or {}

  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
    if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
      table.insert(sorted_jumplist, jumplist[i])
    end
  end

  pickers
  .new(opts, {
    prompt_title = "Jumplist",
    finder = finders.new_table {
      results = sorted_jumplist,
      entry_maker = make_entry.gen_from_quickfix(opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  })
  :find()
end

return telescope.register_extension {
	exports = {
		changes = show_changes,
	},
}
