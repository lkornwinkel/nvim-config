local M = {}

local Path = require("plenary.path")
local log = require("log")

function M.get_program_from_launch_json()
    log:write("SUELZ")
    local launch_path = Path:new(vim.fn.getcwd(), ".vscode", "launch.json")
    if not launch_path:exists() then
        return nil
    end
    local ok, json = pcall(vim.fn.json_decode, launch_path:read())
    log:write(vim.inspect(json))
    if not ok or not json or not json.configurations then
        return nil
    end
    for _, config in ipairs(json.configurations or {}) do
        if config.type == "cppdbg" or config.type == "lldb" then
            if config.program then
                return config.program
            end
        end
    end
    return nil
end

return M
