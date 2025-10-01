return {
    {
        "stevearc/conform.nvim",
        dependencies = { "mason.nvim" },
        lazy = true,
        cmd = "ConformInfo",
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format({ formatters = { "clang_format" }, timeout_ms = 3000 })
                end,
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
        },
        init = function()
            -- Install the conform formatter on VeryLazy
            LazyVim.on_very_lazy(function()
                LazyVim.format.register({
                    name = "conform.nvim",
                    priority = 100,
                    primary = true,
                    format = function(buf)
                        local opts = LazyVim.opts("conform.nvim")
                        require("conform").format(LazyVim.merge({}, opts.format, { bufnr = buf }))
                    end,
                    sources = function(buf)
                        local ret = require("conform").list_formatters(buf)
                        ---@param v conform.FormatterInfo
                        return vim.tbl_map(function(v)
                            return v.name
                        end, ret)
                    end,
                })
            end)
        end,
        opts = {
            -- LazyVim will use these options when formatting with the conform.nvim formatter
            default_format_opts = {
                timeout_ms = 3000,
                async = false, -- not recommended to change
                quiet = false, -- not recommended to change
                lsp_format = "fallback", -- not recommended to change
            },
            formatters_by_ft = {
                lua = { "stylua" },
                fish = { "fish_indent" },
                sh = { "shfmt" },
                cpp = { "clang_format" },
                cmake = { "cmake_format" },
            },

            -- The options you set here will be merged with the builtin formatters.
            -- You can also define any custom formatters here.
            ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
            formatters = {
                clang_format = {
                    prepend_args = { "--style=file:/home/lars/.clang-format" },
                },
            },
        },
    },
}
