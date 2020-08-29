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

function M.handle_highlight_response(_, _, result, _)
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

        vim.api.nvim_buf_add_highlight(0, -1, token_kind_to_highlight_group[token_kind], line, start, start + length)
        i = i + 5
    end
end

function M.send_highlight_request()
    local params = { textDocument = { uri = vim.uri_from_bufnr(0) } }
    vim.lsp.buf_request(0, "textDocument/semanticTokens/full", params, M.handle_highlight_response)
end

M.on_attach = function(_, _)
    vim.api.nvim_buf_attach(0, false, {
        on_lines = M.send_highlight_request
    })
end

return M
