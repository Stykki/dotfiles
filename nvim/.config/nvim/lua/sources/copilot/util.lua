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

--- Convert a byte column to a utf-16 character column
--- @param line string
--- @param byte_col integer 0-indexed byte column
--- @return integer
function M.to_utf16_col(line, byte_col)
    local ok, col = pcall(vim.str_utfindex, line, "utf-16", byte_col, false)
    return ok and col or byte_col
end

--- Convert a utf-16 character column to a byte column
--- @param line string
--- @param char_col integer 0-indexed utf-16 column
--- @return integer
function M.to_byte_col(line, char_col)
    local ok, col = pcall(vim.str_byteindex, line, "utf-16", char_col, false)
    return ok and col or math.min(char_col, #line)
end

--- Make sure a Copilot text edit never removes buffer text that the suggestion
--- doesn't put back. Copilot commonly reports a range covering the whole current
--- line, while `insertText` only contains the text up to (and after) the cursor.
--- Applying that range verbatim wipes out unrelated trailing text, e.g. the
--- `} />` after the cursor in a JSX attribute.
--- @param range lsp.Range
--- @param insert_text string
--- @return lsp.Range
function M.clamp_range_to_cursor(range, insert_text)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_line, cursor_byte = cursor[1] - 1, cursor[2]
    local line = vim.api.nvim_get_current_line()
    local cursor_char = M.to_utf16_col(line, cursor_byte)

    -- Only a range ending after the cursor on the cursor's line can delete
    -- text the user is not currently completing
    if range["end"].line ~= cursor_line or range["end"].character <= cursor_char then
        return range
    end

    -- Text between the cursor and the end of the replaced range
    local suffix = line:sub(cursor_byte + 1, M.to_byte_col(line, range["end"].character))

    -- The suggestion reproduces that text, so replacing it is safe
    if suffix == "" or vim.endswith(insert_text, suffix) then
        return range
    end

    range["end"] = { line = cursor_line, character = cursor_char }
    return range
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

    local cursor = vim.api.nvim_win_get_cursor(0)

    for _, completion in ipairs(completions) do
        -- Never trust the range blindly: keep it from eating text after the cursor
        local range = completion.range
            or {
                start = { line = cursor[1] - 1, character = cursor[2] },
                ["end"] = { line = cursor[1] - 1, character = cursor[2] },
            }
        range = M.clamp_range_to_cursor(vim.deepcopy(range), completion.insertText)

        local dedented_text = M.deindent(completion.insertText)

        table.insert(items, {
            label = dedented_text,
            kind_name = kind_name,
            kind_icon = kind_icon,
            kind_hl = kind_hl,
            textEdit = {
                newText = completion.insertText,
                range = range,
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
