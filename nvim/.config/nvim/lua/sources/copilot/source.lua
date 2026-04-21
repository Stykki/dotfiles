-- Copilot completion source for blink.cmp

local util = require("sources.copilot.util")

--- @class CopilotSource
--- @field config CopilotSourceConfig
--- @field client vim.lsp.Client|nil
--- @field context CompletionContext
--- @field debounce_timer uv_timer_t|nil
local M = {}

--- Create a new source instance
--- @param opts CopilotSourceConfig
--- @return CopilotSource
function M:new(opts)
    self:detect_client()
    self:reset(0)

    local config = vim.deepcopy(opts)
    config.max_attempts = config.max_attempts or config.max_completions + 1

    -- Allow disabling kind_name/kind_icon/kind_hl by setting to false
    for _, k in pairs({ "kind_name", "kind_icon", "kind_hl" }) do
        if config[k] == false then
            config[k] = nil
        end
    end

    return setmetatable({ config = config }, { __index = self })
end

--- Detect the Copilot LSP client
function M:detect_client()
    if self.client and not self.client:is_stopped() then
        return
    end

    local lsp_clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/inlineCompletion" })
    for _, client in ipairs(lsp_clients) do
        if string.find(string.lower(client.name), "copilot") then
            self.client = client
            self.is_copilot_enabled = function()
                local copilot_lua_ok, clt = pcall(require, "copilot.client")
                return (copilot_lua_ok and clt and not clt.is_disabled()) or (vim.g.copilot_enabled ~= 0)
            end
            break
        end
    end
end

--- Reset the completion context
--- @param ts integer Timestamp
function M:reset(ts)
    util.cancel_request(self.client, self.context and self.context.first_req_id)
    util.cancel_request(self.client, self.context and self.context.cycling_req_id)

    --- @class CompletionContext
    self.context = {
        cache = {},
        completions = {},
        state = nil,
        first_req_id = nil,
        cycling_req_id = nil,
        start_ts = ts,
    }
end

--- Add new completions, deduplicating by label
--- @param items blink.cmp.CompletionItem[]
--- @return blink.cmp.CompletionItem[]
function M:add_new_completions(items)
    local new_completions = {}

    for _, item in ipairs(items) do
        if #self.context.completions < self.config.max_completions then
            if not self.context.cache[item.label] then
                self.context.cache[item.label] = true
                table.insert(self.context.completions, item)
                table.insert(new_completions, item)
            end
        end
    end

    return new_completions
end

--- Get completions from Copilot
--- @param ctx blink.cmp.Context
--- @param resolve fun(response: blink.cmp.CompletionResponse): nil
function M:get_completions(ctx, resolve)
    if not self.client or not self.is_copilot_enabled() then
        return
    end

    -- Return cached results if context unchanged
    local current_state = { bufnr = ctx.bufnr, id = ctx.id, cursor = ctx.cursor }
    if vim.deep_equal(current_state, self.context.state) then
        resolve({
            is_incomplete_forward = self.config.auto_refresh.forward,
            is_incomplete_backward = self.config.auto_refresh.backward,
            items = self.context.completions,
        })
        return
    end

    local now = util.timestamp()

    -- Debounce if configured
    if self.config.debounce ~= false and type(self.config.debounce) == "number" then
        local since = now - self.context.start_ts
        if since < self.config.debounce then
            if self.debounce_timer then
                self.debounce_timer:stop()
            end
            self.debounce_timer = vim.defer_fn(function()
                self.debounce_timer = nil
                self:get_completions(ctx, resolve)
            end, self.config.debounce)
            return
        end
    end

    self:reset(now)

    -- Use coroutine for async LSP requests
    coroutine.wrap(function()
        local co = coroutine.running()
        local lsp_params = util.get_lsp_params()

        --- @type lsp.Handler
        local function handle_lsp_response(err, response)
            coroutine.resume(co, not err and response and response.items)
        end

        --- @param is_initial boolean
        local function send_request(is_initial)
            local success, req_id = util.get_completions_from_lsp(self.client, lsp_params, handle_lsp_response)

            if success then
                if is_initial then
                    self.context.first_req_id = req_id
                else
                    self.context.cycling_req_id = req_id
                end
            end
            return success
        end

        local function process_and_resolve()
            local lsp_items = coroutine.yield()
            if self.context.start_ts ~= now or not lsp_items or #lsp_items == 0 then
                return
            end

            local blink_items = util.lsp_completion_items_to_blink_items(
                lsp_items,
                self.config.kind_name,
                self.config.kind_icon,
                self.config.kind_hl
            )

            resolve({
                is_incomplete_forward = self.config.auto_refresh.forward,
                is_incomplete_backward = self.config.auto_refresh.backward,
                items = self:add_new_completions(vim.deepcopy(blink_items)),
            })
        end

        -- Initial request
        if send_request(true) then
            process_and_resolve()
            self.context.first_req_id = nil
            self.context.state = current_state
        end

        -- Cycling requests for more completions
        lsp_params = util.to_cycling_lsp_params(lsp_params)
        local attempts = 0
        while
            now == self.context.start_ts
            and #self.context.completions < self.config.max_completions
            and attempts < self.config.max_attempts
        do
            attempts = attempts + 1
            if send_request(false) then
                process_and_resolve()
                self.context.cycling_req_id = nil
            end
        end
    end)()
end

return M
