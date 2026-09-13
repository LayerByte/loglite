local project_name = "Loglite"
local project_focus = "Simple log filtering utility."

local function read_file(path)
    local handle, err = io.open(path, "rb")
    if not handle then
        return nil, err
    end
    local data = handle:read("*a")
    handle:close()
    return data
end

local function split_lines(text)
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

local function filter_log(path, keyword)
    local data, err = read_file(path)
    if not data then error(err) end
    local count = 0
    for _, line in ipairs(split_lines(data)) do
        if not keyword or line:lower():find(keyword:lower(), 1, true) then
            print(line)
            count = count + 1
        end
    end
    print("Matched lines: " .. count)
end

local function printable_strings(path)
    local data, err = read_file(path)
    if not data then error(err) end
    for value in data:gmatch("[%g ]%g%g%g+") do
        print(value)
    end
end

local function file_index(path)
    local command
    if package.config:sub(1, 1) == "\\" then
        command = 'dir "' .. path .. '" /b'
    else
        command = 'find "' .. path .. '" -maxdepth 1 -type f'
    end
    local handle = io.popen(command)
    if not handle then error("could not list directory") end
    for line in handle:lines() do
        print(line)
    end
    handle:close()
end

local function usage()
    print(project_name .. " - " .. project_focus)
    print("Usage: lua main.lua <log|strings|index> <path> [keyword]")
end

local mode = arg[1]
local path = arg[2]
local keyword = arg[3]

local ok, err = pcall(function()
    if not mode or not path then
        usage()
    elseif mode == "log" then
        filter_log(path, keyword)
    elseif mode == "strings" then
        printable_strings(path)
    elseif mode == "index" then
        file_index(path)
    else
        error("unknown mode")
    end
end)

if not ok then
    io.stderr:write("Error: " .. tostring(err) .. "\n")
    os.exit(1)
end
