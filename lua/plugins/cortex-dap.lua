return {
    "jedrzejboczar/nvim-dap-cortex-debug",
    requires = "mfussenegger/nvim-dap",
    config = function()
        require("dap-cortex-debug").setup({
            debug = false, -- log debug messages
            -- path to cortex-debug extension, supports vim.fn.glob
            -- by default tries to guess: mason.nvim or VSCode extensions
            extension_path = "/home/lars/opt/cortex-debug/extension",
            lib_extension = "so", -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
            node_path = "/usr/bin/node", -- path to node.js executable
            dapui = true, -- register nvim-dap-ui elements
            dapui_rtt = true, -- register nvim-dap-ui RTT element
            -- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
            dap_vscode_filetypes = { "c", "cpp" },
            rtt = {
                buftype = "Terminal", -- 'Terminal' or 'BufTerminal' for terminal buffer vs normal buffer
            },
        })
    end,
}
