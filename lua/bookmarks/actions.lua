local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local bookmarks = require("bookmarks")

local a = {}

function a.open(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd(":e "..entry.filename) -- Open file
    vim.cmd(":"..entry.lnum)       -- Select to line
end

function a.open_in_tab(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd(":tabnew "..entry.filename) -- Open file
    vim.cmd(":"..entry.lnum)            -- Select line
end

function a.split(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd(":split "..entry.filename) -- Open file
    vim.cmd(":"..entry.lnum)           -- Select line
end

function a.vsplit(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd(":vsplit "..entry.filename) -- Open file
    vim.cmd(":"..entry.lnum)            -- Select line
end

function a.delete(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    entry.valid = false
    bookmarks.delete_node(entry.filename, entry.lnum)
    -- TODO: Refresh instead of closing
    actions.close(prompt_bufnr)
end

return a
