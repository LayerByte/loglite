local filters = {}

function filters.contains(line, keyword)
    if not keyword or keyword == "" then
        return true
    end
    return line:lower():find(keyword:lower(), 1, true) ~= nil
end

return filters
