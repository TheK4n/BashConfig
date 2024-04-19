local function get_virtual_env()
    return vim.fs.basename(os.getenv("VIRTUAL_ENV"))
end

function GET_FORMATTED_VIRTUAL_ENV()
    if vim.bo.filetype == 'python' then
        return "<" .. get_virtual_env() .. ">"
    end
    return ""
end

function DETECT_INDENT_TYPE()
    if vim.bo.expandtab then
        return vim.bo.shiftwidth .. " spaces"
    else
        return vim.bo.shiftwidth / vim.bo.tabstop .. " tabs (" .. vim.bo.tabstop .. ")"
    end
end

local function is_absolute_path(path)
    return string.sub(path, 1, 1) == '/' or string.sub(path, 1, 1) == '~'
end

return {
    {
        "folke/twilight.nvim",
        cmd = "Twilight"
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
    },
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    component_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {
                        {
                            'vim.fn.getcwd()',
                            fmt = function(str)
                                local res = str

                                res = str:gsub(os.getenv("HOME"), "~")

                                return res
                            end,
                            color = { fg = 'white', gui='bold' },
                            padding = { left = 1, right = 0 }
                        },
                        {
                            'filename',
                            fmt = function(str)
                                local res = str

                                if is_absolute_path(res) then
                                    res = " " .. res
                                else
                                    res = "/" .. res
                                end

                                return res
                            end,
                            file_status = true,
                            path = 1,
                            padding = { left = 0, right = 1 }
                        },
                    },
                    lualine_x = {'GET_FORMATTED_VIRTUAL_ENV()', 'DETECT_INDENT_TYPE()', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'},
                },
            })
        end,
        dependencies = { 'kyazdani42/nvim-web-devicons' },
    },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local colorscheme = require("nightfox")
            colorscheme.compile()
            colorscheme.setup()
            vim.cmd.colorscheme("nightfox")
        end
    },
    {
        'ellisonleao/gruvbox.nvim',
        lazy = true,
    },
    {
        'xiyaowong/transparent.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require("transparent").setup({
                exclude_groups = {'CursorLine'},
            })
        end
    },
    {
        'lukas-reineke/virt-column.nvim',
        lazy = true,
        config = function()
            require("virt-column").setup({
                virtcolumn = '81'
            })
        end
    },
    {
        'norcalli/nvim-colorizer.lua',
        lazy = true,
        config = function()
            require('colorizer').setup()
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = { enabled = false },
            })
        end,
        main = "ibl"
    },
    {
        'karb94/neoscroll.nvim',
        config = function()
            require('neoscroll').setup({
                mappings = {'<C-u>', '<C-d>', '<C-b>',
                    '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
                respect_scrolloff = false,
            })
        end
    },
    {
        'folke/which-key.nvim',
        lazy = true,
        config = function()
            require("which-key").setup()
        end
    },
}