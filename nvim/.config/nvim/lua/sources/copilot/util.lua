-- Utility functions for Copilot blink.cmp source

local M = {}

--- Trigger kind for inline completion requests
--- @enum TriggerKind
local trigger_kind = {
    inline_invoked = 1,
    inline_automatic = 2,
}

--- Cancel a pending LSP request
--- @param client vim.lsp.Client|nil
--- @param req_id integer|nil
function M.cancel_request(client, req_id)
    if client and req_id then
        client:cancel_request(req_id)
    end
end

--- Build LSP params for inline completion request
--- @return table
function M.get_lsp_params()
    return vim.tbl_deep_extend("force", vim.lsp.util.make_position_params(0, "utf-16"), {
        formattingOptions = {
            insertSpaces = vim.bo.expandtab,
            tabSize = vim.fn.shiftwidth(),
        },
        context = {
            triggerKind = trigger_kind.inline_automatic,
        },
    })
end

--- Convert params to cycling request (for fetching more completions)
--- @param params table
--- @return table
function M.to_cycling_lsp_params(params)
    return vim.tbl_deep_extend("force", params, {
        context = {
            triggerKind = trigger_kind.inline_invoked,
        },
    })
end

--- Send inline completion request to Copilot LSP
--- @param client vim.lsp.Client
--- @param params table
--- @param cb lsp.Handler
--- @return boolean success
--- @return integer|nil request_id
function M.get_completions_from_lsp(client, params, cb)
    return client:request("textDocument/inlineCompletion", params, cb)
end

--- Get length of the first line of text
--- @param text string
--- @param sep string|nil
--- @return integer
function M.length_of_first_line(text, sep)
    sep = sep or (text:find("\r") and "\r" or "\n") or "\n"

    if not string.find(text, "[\r|\n]") then
        return #text
    end

    local matched = string.match(text, "([^" .. sep .. "]+)")
    return matched and #matched or #text
end

--- Remove common indentation from text for cleaner display
--- @param text string
--- @return string
function M.deindent(text)
    local lines = vim.split(text, "\n")

    -- Find first and last non-empty lines
    local start_idx, end_idx = 1, #lines
    while start_idx <= #lines and lines[start_idx] == "" do
        start_idx = start_idx + 1
    end
    if start_idx > #lines then
        return ""
    end
    while end_idx >= 1 and lines[end_idx] == "" do
        end_idx = end_idx - 1
    end

    lines = vim.list_slice(lines, start_idx, end_idx)

    -- Find common indent prefix
    local indents = {}
    for _, line in ipairs(lines) do
        if line ~= "" then
            local indent = line:match("^%s*")
            table.insert(indents, indent)
        end
    end
    if #indents == 0 then
        return table.concat(lines, "\n")
    end

    local common_prefix = indents[1]
    for i = 2, #indents do
        local current_indent = indents[i]
        local min_len = math.min(#common_prefix, #current_indent)
        local new_prefix = ""
        for j = 1, min_len do
            if common_prefix:sub(j, j) == current_indent:sub(j, j) then
                new_prefix = new_prefix .. common_prefix:sub(j, j)
            else
                break
            end
        end
        common_prefix = new_prefix
        if common_prefix == "" then
            break
        end
    end

    -- Remove common prefix from all lines
    local processed_lines = {}
    for _, line in ipairs(lines) do
        if line == "" then
            table.insert(processed_lines, "")
        else
            local processed_line = line:gsub("^" .. vim.pesc(common_prefix), "", 1)
            table.insert(processed_lines, processed_line)
        end
    end

    return table.concat(processed_lines, "\n")
end

--- Transform Copilot LSP completion items to blink.cmp format
--- @param completions table[]
--- @param kind_name string|nil
--- @param kind_icon string|nil
--- @param kind_hl string|nil
--- @return blink.cmp.CompletionItem[]
function M.lsp_completion_items_to_blink_items(completions, kind_name, kind_icon, kind_hl)
    local items = {}

    for _, completion in ipairs(completions) do
        -- Update range end to first line length
        completion.range["end"].character = M.length_of_first_line(completion.insertText)

        local dedented_text = M.deindent(completion.insertText)

        table.insert(items, {
            label = dedented_text,
            kind_name = kind_name,
            kind_icon = kind_icon,
            kind_hl = kind_hl,
            textEdit = {
                newText = completion.insertText,
                range = completion.range,
            },
            documentation = {
                kind = "markdown",
                value = string.format("```%s\n%s\n```", vim.bo.filetype, dedented_text),
            },
        })
    end

    return items
end

--- Get current timestamp in milliseconds
--- @return integer
function M.timestamp()
    return math.floor(vim.uv.hrtime() / 1e6)
end

return M
