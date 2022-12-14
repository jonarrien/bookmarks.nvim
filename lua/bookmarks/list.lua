local md5 = require("bookmarks.md5")

local l = {
    data = {},
    path_sep = "/",
    data_dir = string.format("%s/bookmarks", vim.fn.stdpath("data")),
    data_filename = nil,
    loaded_data = false,
    cwd = nil,
}

local function project_path()
    local cwd = vim.api.nvim_eval("getcwd()")
    local file = string.gsub(cwd, l.path_sep, "_") .. ".json"
    return string.format("%s%s%s", l.data_dir, l.path_sep, file)
end

function compare_updated_at(a,b)
  return a.updated_at < b.updated_at
end

function l.setup(opts)
    local os_name = vim.loop.os_uname().sysname
    l.is_windows = os_name == "Windows" or os_name == "Windows_NT"
    if l.is_windows then
        l.path_sep = "\\"
    end

    print("Setting up bookmarks...")
    print(opts)
end

function l.load_data()
    local cwd = project_path()

    if l.cwd ~= nil and cwd ~= l.cwd then -- maybe change session
        l.save()
        l.data = {}
        l.loaded_data = false
    end

    if l.loaded_data == true then
        return
    end

    if not vim.loop.fs_stat(l.data_dir) then
        assert(os.execute("mkdir " .. l.data_dir))
    end

    if not vim.loop.fs_stat(cwd) then
        print("No bookmarks file")
        l.data = {}
        l.loaded_data = false
        return
    end

    local f = assert(io.open(cwd, "rb"))
    local content = f:read("*all")
    f:close()

    local parsed = vim.json.decode(content or "[]")
    l.data = parsed
    l.loaded_data = true
    table.sort(parsed, compare_updated_at)
end

function l.add(filename, line, description)
    l.load_data()

    local id = md5.sumhexa(string.format("%s:%s", filename, line))
    local now = os.time()

    if l.data[id] ~= nil then
        if description ~= nil then
            l.data[id].description = description
            l.data[id].updated_at = now
        end
    else
        l.data[id] = {
            filename = filename,
            id = id,
            line = line,
            description = description or "",
            updated_at = now,
            freq = 1
        }
    end

    l.save()
end

function l.save()
    if not vim.loop.fs_stat(l.data_dir) then
        assert(os.execute("mkdir " .. l.data_dir))
    end

    local cwd = vim.api.nvim_eval("getcwd()")
    local file = string.gsub(cwd, l.path_sep, "_") .. ".json"
    local path = string.format("%s%s%s", l.data_dir, l.path_sep, file)

    local out = assert(io.open(path, "w"))
    out:write(vim.json.encode(l.data or {}))
    out:close()
end

function l.delete(id)
  l.data[id] = nil
  l.save()
end

return l

