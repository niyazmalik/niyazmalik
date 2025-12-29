-- ============================================================================
-- SUPPRESS DEPRECATION WARNINGS
-- ============================================================================
vim.deprecate = function() end

-- ============================================================================
-- PLUGIN MANAGER (lazy.nvim)
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS
-- ============================================================================

require("lazy").setup({

    -- =========================================================================
    -- Snippets
    -- =========================================================================
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },

    -- =========================================================================
    -- Telescope
    -- =========================================================================
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")

            require("telescope").setup({
                defaults = {
                    mappings = {
                        n = { ["q"] = actions.close },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true, -- Show hidden files like .env
                        -- fd (faster) or find to exclude folders at scan time
                        find_command = { 
                            "rg", 
                            "--files", 
                            "--hidden", 
                            "--glob", "!**/.git/*",
                            "--glob", "!**/node_modules/*",
                            "--glob", "!**/dist/*",
                            "--glob", "!**/.next/*",
                            "--glob", "!**/build/*",
                        },
                    },
                },
            })

            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep)
            vim.keymap.set("n", "<leader>fb", builtin.buffers)
            vim.keymap.set("n", "<leader>fh", builtin.help_tags)
        end,
    },

    -- =========================================================================
    -- Autopairs
    -- =========================================================================
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- =========================================================================
    -- Treesitter
    -- =========================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "typescript",
                    "javascript",
                    "json",
                    "lua",
                },
                highlight = { enable = true },
            })
        end,
    },

    -- =========================================================================
    -- LSP + Mason
    -- =========================================================================
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = { "ts_ls" },
                handlers = {
                    function(server)
                        lspconfig[server].setup({
                            capabilities = capabilities,
                            on_attach = function(client)
                                -- Disable formatting (use prettier instead)
                                client.server_capabilities.documentFormattingProvider = false
                                client.server_capabilities.documentRangeFormattingProvider = false
                            end,
                        })
                    end,
                },
            })
        end,
    },

    -- =========================================================================
    -- Formatting with Prettier
    -- =========================================================================
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            
            null_ls.setup({
                sources = {
                    -- Prettier formatting
                    null_ls.builtins.formatting.prettier.with({
                        extra_filetypes = { "json", "jsonc" },
                    }),
                },
            })
            
            -- Manual format with Alt+p
            vim.keymap.set("n", "<A-p>", vim.lsp.buf.format, { desc = "Format with Prettier" })
        end,
    },

    -- =========================================================================
    -- Git Integration
    -- =========================================================================
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    -- Navigation
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, buffer = bufnr})

                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, buffer = bufnr})

                    -- Actions
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr })
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr })
                    vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, { buffer = bufnr })
                end
            })
        end,
    },

    -- =========================================================================
    -- Autocomplete
    -- =========================================================================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                -- Reduce duplicates
                duplicates = {
                    nvim_lsp = 1,
                    luasnip = 1,
                    buffer = 1,
                    path = 1,
                },
                -- Better styling with borders
                window = {
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    }),
                },
                -- Show source in menu
                formatting = {
                    format = function(entry, vim_item)
                        -- Show where suggestion came from
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- Alt+j/k navigation
                    ["<A-j>"] = cmp.mapping.select_next_item(),
                    ["<A-k>"] = cmp.mapping.select_prev_item(),
                    
                    -- Confirm selection
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip", priority = 750 },
                    { name = "buffer", priority = 500 },
                    { name = "path", priority = 250 },
                }),
            })
        end,
    },
})
