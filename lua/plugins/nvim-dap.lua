return {
    "mfussenegger/nvim-dap",

    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "nvim-telescope/telescope-dap.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
    },

    keys = {
        {
            "<leader>dB",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Breakpoint Condition",
        },
        {
            "<leader>db",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
        },
        {
            "<leader>dc",
            function()
                require("dap").continue()
            end,
            desc = "Run/Continue",
        },
        {
            "<leader>da",
            function()
                require("dap").continue({ before = get_args })
            end,
            desc = "Run with Args",
        },
        {
            "<leader>dC",
            function()
                require("dap").run_to_cursor()
            end,
            desc = "Run to Cursor",
        },
        {
            "<leader>dg",
            function()
                require("dap").goto_()
            end,
            desc = "Go to Line (No Execute)",
        },
        {
            "<leader>di",
            function()
                require("dap").step_into()
            end,
            desc = "Step Into",
        },
        {
            "<leader>dj",
            function()
                require("dap").down()
            end,
            desc = "Down",
        },
        {
            "<leader>dk",
            function()
                require("dap").up()
            end,
            desc = "Up",
        },
        {
            "<leader>dl",
            function()
                require("dap").run_last()
            end,
            desc = "Run Last",
        },
        {
            "<leader>do",
            function()
                require("dap").step_out()
            end,
            desc = "Step Out",
        },
        {
            "<leader>dO",
            function()
                require("dap").step_over()
            end,
            desc = "Step Over",
        },
        {
            "<leader>dP",
            function()
                require("dap").pause()
            end,
            desc = "Pause",
        },
        {
            "<leader>dr",
            function()
                require("dap").repl.toggle()
            end,
            desc = "Toggle REPL",
        },
        {
            "<leader>ds",
            function()
                require("dap").session()
            end,
            desc = "Session",
        },
        {
            "<leader>dt",
            function()
                require("dap").terminate()
            end,
            desc = "Terminate",
        },
        {
            "<leader>dw",
            function()
                require("dap.ui.widgets").hover()
            end,
            desc = "Widgets",
        },
        {
            "<leader>du",
            function()
                require("dapui").toggle()
            end,
            desc = "Toggle DapUI",
        },
    },

    config = function()
        local dap = require("dap")
        local dapvt = require("nvim-dap-virtual-text")
        local telescope_dap = require("telescope").load_extension("dap")
        local nio = require("nio")
        local launch_json = require("launch_json")

        dapvt.setup()

        vim.keymap.set("n", "<leader>dc", function()
            dap.continue()
        end, { desc = "Continue" })
        vim.keymap.set("n", "<leader>df", function()
            telescope_dap.frames()
        end, { desc = "Frames" })

        vim.keymap.set("n", "<leader>dv", function()
            telescope_dap.variables()
        end, { desc = "Variables" })

        local function open()
            nio.run(function()
                require("dapui").open()
            end)
        end

        local function close()
            nio.run(function()
                require("dapui").close()
            end)
        end

        local dapui = require("dapui")
        dapui.setup()

        dap.listeners.after.event_initialized["dapui_config"] = open
        dap.listeners.before.event_terminated["dapui_config"] = close
        dap.listeners.before.event_exited["dapui_config"] = close

        require("mason-nvim-dap").setup({
            ensure_installed = { "codelldb", "python", "jsdebugadapter" },
            automatic_installation = true,
            handlers = {},
        })

        dap.adapters.lldb = {
            type = "executable",
            command = "lldb-dap-20", -- or 'lldb' if installed differently
            name = "lldb",
        }

        dap.configurations.cpp = {
            {
                name = "Launch from launch.json",
                type = "lldb",
                request = "launch",
                program = launch_json.get_program_from_launch_json(),
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            },
        }

        dap.adapters["cortex-debug"] = {
            type = "executable",
            command = "/usr/bin/node",
            args = { "/home/lars/opt/cortex-debug/extension/dist/debugadapter.js" },
        }

        dap.configurations.c = {
            {
                name = "Cortex Debug",
                type = "cortex-debug",
                request = "launch",
                servertype = "openocd",
                cwd = "/home/lars/dev/github/stm32_uart",
                executable = "/home/lars/dev/github/stm32_uart/build/debug/stm32_uart.elf",
                program = "/home/lars/dev/github/stm32_uart/build/debug/stm32_uart.elf",
                --device = "STM32F446RETx",
                configFiles = { "interface/stlink.cfg", "target/stm32f4x.cfg" },
                toolchainPath = "/home/lars/opt/STM32CubeCLT/GNU-tools-for-STM32/bin",
                toolchainPrefix = "arm-none-eabi",
                --                preLaunchCommands = {
                --                    "source [find target/stm32f4x.cfg]",
                --                    "reset halt",
                --                    "flash write_image erase build/debug/stm32_uart.elf",
                --                    "reset halt",
                --                },
                --                postLaunchCommands = { "reset halt" },
                svdFile = "/home/lars/opt/STM32CubeCLT/STMicroelectronics_CMSIS_SVD/STM32F446.svd",
                showDevDebugOutput = true,
            },
        }
    end,
}
