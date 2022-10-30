local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions = require("bookmarks.actions")

local displayer = entry_display.create {
  separator = " ",
  items = {
    { width = 1 },
    { width = 25 },
    { width = 50 },
    { width = 10 },
    { width = 8 },
  },
}

local make_display = function(entry)
  local line = vim.fn.fnamemodify(entry.filename, ':p:~:.') .. ":" .. entry.lnum
  local date = os.date('%Y-%m-%d', entry.updated_at)
  local time = os.date('%H:%M:%S', entry.updated_at)

  return displayer({
    { entry.icon, "ErrorMsg" },
    { entry.description, "Normal" },
    { line, "Comment" },
    { date, "Label" },
    { time, "Operator" },
  })
end

local entry_maker = function (entry)
  return {
    icon = "", --
    filename = entry.filename,
    lnum = entry.line,
    description = entry.description,
    updated_at = entry.updated_at,
    value = entry.description,
    ordinal = entry.description,
    display = make_display,
  }
end

local p = {}

function p.show(items, opts)
    pickers.new(opts, {
        prompt_title = " Bookmarks",
        finder = finders.new_table({
            results = items,
            entry_maker = entry_maker
        }),
        previewer = conf.grep_previewer(opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(_, map)
            map("i", "<cr>", actions.open)
            map("i", "<C-t>", actions.open_in_tab)
            map("i", "<C-s>", actions.split)
            map("i", "<C-v>", actions.vsplit)
            map("i", "<C-x>", actions.delete)
            return true
        end,
    }):find()
end

return p
