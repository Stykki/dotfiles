-- Copilot source for blink.cmp
-- Embedded from fang2hou/blink-copilot with modifications

local source = require("sources.copilot.source")

local M = {}

--- Default configuration
--- @class CopilotSourceConfig
--- @field max_completions integer Max suggestions to show (default: 3)
--- @field max_attempts integer Max cycling attempts to fetch more (default: 4)
--- @field kind_name string|false Label in completion menu (default: "Copilot")
--- @field kind_icon string|false Icon for Copilot suggestions (default: " ")
--- @field kind_hl string|false Highlight group for the icon (default: "BlinkCmpKindCopilot")
--- @field debounce integer|false Ms before triggering, false for instant (default: 75)
--- @field auto_refresh { backward: boolean, forward: boolean } Re-fetch on cursor move
M.defaults = {
    max_completions = 3,
    max_attempts = 4,
    kind_name = "Copilot",
    kind_icon = " ",
    kind_hl = "BlinkCmpKindCopilot",
    debounce = 75,
    auto_refresh = {
        backward = true,
        forward = true,
    },
}

--- Create a new instance of the Copilot completion provider
--- @param opts CopilotSourceConfig|nil
function M.new(opts)
    local config = vim.tbl_deep_extend("force", M.defaults, opts or {})
    local src = source:new(config)

    -- Re-detect client when LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
            src:detect_client()
        end,
    })

    return src
end

return M
