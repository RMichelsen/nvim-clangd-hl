local vim = vim
local M = {}

local token_kinds = {
    "Variable",
    "LocalVariable",
    "Parameter",
    "Function",
    "Method",
    "StaticMethod",
    "Field",
    "StaticField",
    "Class",
    "Enum",
    "EnumConstant",
    "Typedef",
    "DependentType",
    "DependentName",
    "Namespace",
    "TemplateParameter",
    "Concept",
    "Primitive",
    "Macro",
    "InactiveCod"
}

local token_kind_to_highlight_group = {
    ["Variable"] = "Normal",
    ["LocalVariable"] = "Normal",
    ["Parameter"] = "Normal",
    ["Function"] = "Function",
    ["Method"] = "Function",
    ["StaticMethod"] = "Function",
    ["Field"] = "Identifier",
    ["StaticField"] = "Identifier",
    ["Class"] = "Structure",
    ["Enum"] = "Structure",
    ["EnumConstant"] = "Constant",
    ["Typedef"] = "Typedef",
    ["DependentType"] = "Type",
    ["DependentName"] = "Type",
    ["Namespace"] = "Type",
    ["TemplateParameter"] = "Identifier",
    ["Concept"] = "Type",
    ["Primitive"] = "Constant",
    ["Macro"] = "Macro",
    ["InactiveCod"] = "Normal",
}

function M.get_highlight_callback(bufnr)
    return function(_, _, result, _)
        local win = vim.api.nvim_get_current_win()
        local column = vim.api.nvim_win_get_cursor(win)[1]
        local column_count = vim.api.nvim_win_get_height(win)

        local line = 0
        local start = 0
        local data = result["data"]
        local data_size = table.getn(data)

        local i = 1
        while (i <= data_size) do
            local delta_line = data[i]
            local delta_start = data[i + 1]
            local length = data[i + 2]
            local token_kind = token_kinds[data[i + 3] + 1]

            line = line + delta_line
            if delta_line == 0 then
                start = start + delta_start
            else
                start = delta_start
            end

            if line > (column - column_count) and line < (column + column_count) then
                vim.api.nvim_buf_add_highlight(
                    bufnr,
                    -1,
                    token_kind_to_highlight_group[token_kind],
                    line,
                    start,
                    start + length
                )
            end

            i = i + 5
        end
    end
end

M.on_attach = function(_, _)
    local bufnr = vim.api.nvim_get_current_buf()
    local callback = function()
        local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
        vim.lsp.buf_request(
            bufnr,
            "textDocument/semanticTokens/full",
            params,
            M.get_highlight_callback(bufnr)
        )
    end
    vim.api.nvim_buf_attach(bufnr, false, {
        on_lines = callback
    })
    callback()
end

return M
