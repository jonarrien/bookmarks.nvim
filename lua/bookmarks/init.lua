local md5 = require("bookmarks.md5")
local l = require("bookmarks.list")

local b = {}

function b.setup(config)
    -- TODO: Add config
end

function b.add()
    local title = " [Bookmark name]: "
    local filename = vim.api.nvim_buf_get_name(0)
    local line = vim.api.nvim_eval("line('.')")

    vim.ui.input({ prompt = title, default = "" }, function(input)
        if input ~= nil then
            l.add(filename, line, input)
        end
    end)
end

function b.delete()
    local filename = vim.api.nvim_buf_get_name(0)
    local line = vim.api.nvim_eval("line('.')")
    local id = md5.sumhexa(string.format("%s:%s", filename, line))
    l.delete(id)
end

function b.delete_node(filename, line)
    local id = md5.sumhexa(string.format("%s:%s", filename, line))
    l.delete(id)
end

function b.list()
    l.load_data()
    return l.data
end

return b
