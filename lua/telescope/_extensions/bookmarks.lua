local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

local bookmarks = require("bookmarks")
local picker = require("bookmarks.picker")

local function telescope_bookmarks(opts)
    local items = {}
    for _, bookmark in pairs(bookmarks.list()) do
      table.insert(items, bookmark)
    end

    opts = opts or {}
    picker.show(items, opts or {})
end

return telescope.register_extension({
    exports = {
        bookmarks = telescope_bookmarks
    }
})
