
local M = {}
M.jumps_changes = {}

vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI", "TextYankPost"}, {
  callback = function()
    local one = {
      lnum = vim.fn.line("."),
      bufnr = vim.fn.bufnr(),
      col = 0,
      coladd = 0,
      type = "",
      --filename = vim.fn.expand("%:p")
    }
    local match_index = 0
    local func_enum_class = false

    local parsers = require "nvim-treesitter.parsers"
    local query = require("nvim-treesitter.query")
    local ts_utils = require "nvim-treesitter.ts_utils"
    local ts_locals = require "nvim-treesitter.locals"
    local get_node_text
    if vim.treesitter.query and vim.treesitter.query.get_node_text then
      get_node_text = vim.treesitter.query.get_node_text
    end

    curr_node = ts_utils.get_node_at_cursor()
    if (curr_node) then
      local index_node = curr_node
      local curr_type = curr_node:type()
      if (curr_type == "function_definition" or curr_type == "enum_specifier" or curr_type == "class_specifier" or curr_type == "struct_specifier") then
        one.funline = one.lnum
        one.type = section_type
        for k, v in pairs(M.jumps_changes) do
          if (one.funline == v.funline and one.bufnr == v.bufnr) then
            v.lnum = one.lnum
            match_index = k
            break
          end
        end

        one.text =  vim.fn.getbufline(one.bufnr, one.lnum)[1]
        if match_index > 0 then
          table.remove(M.jumps_changes, match_index)
        end
        table.insert(M.jumps_changes, one)
        return
      end
      while(index_node:parent())
      do
        print("curr_node = ", curr_node:type())
        index_node = index_node:parent()
        print("parent node = ", index_node:type())
        local section_type = index_node:type()
        if (section_type == "function_definition" or section_type == "enum_specifier" or section_type == "class_specifier" or section_type == "struct_specifier") then
          func_enum_class = true
          local start_row, start_col, end_row, end_col = index_node:range()
          one.funline = start_row + 1
          one.type = section_type
          for k, v in pairs(M.jumps_changes) do
            if (one.funline == v.funline and one.bufnr == v.bufnr) then
              v.lnum = one.lnum
              match_index = k
              break
            end
          end
          one.text =  vim.fn.getbufline(one.bufnr, start_row + 1)[1]
          if match_index > 0 then
            table.remove(M.jumps_changes, match_index)
          end
          table.insert(M.jumps_changes, one)
          return
        end
        --print(start_row, name_node:type())
      end

      if (func_enum_class == false) then
        if (curr_type == "type_identifier" or curr_type == "preproc_include" or curr_type == "preproc_def" or curr_type == "preproc_if") then
          one.type = curr_type
          for k, v in pairs(M.jumps_changes) do
            if (one.type == v.type and one.bufnr == v.bufnr) then
              v.lnum = one.lnum
              match_index = k
              break
            end
          end

          one.text =  vim.fn.getbufline(one.bufnr, one.lnum)[1]
          if match_index > 0 then
            table.remove(M.jumps_changes, match_index)
          end
          table.insert(M.jumps_changes, one)
        end
      end

    end
    --print(vim.inspect(userchangelist))
    --vim.pretty_print(userchangelist)

  end
  
})

return M
