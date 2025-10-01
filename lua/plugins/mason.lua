return {
    "mason-org/mason.nvim",
    opts = {
        ensure_installed = {
            "clangd",
            "codelldb",
            "clang-format",
        },
        auromatic_installation = true,
    },
}
