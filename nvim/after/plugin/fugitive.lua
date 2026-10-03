function IsFugitiveFile(name)
    local prefix = "fugitive://"
    return string.sub(name, 1, #prefix) == prefix
end

function ToggleFugitive()
    local was_fugitive_open = false

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if IsFugitiveFile(vim.api.nvim_buf_get_name(buf)) then
            was_fugitive_open = true
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    if was_fugitive_open == false then
        vim.cmd.Git()
    else
        GoToMainWindow()
    end
end

vim.keymap.set("n", "<leader>gs", ToggleFugitive)
vim.keymap.set("n", "<leader>gm", function()
    vim.cmd.Git("mergetool")
end)
