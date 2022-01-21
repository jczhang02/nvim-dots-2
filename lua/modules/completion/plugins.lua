local completion = {}
local conf = require("modules.completion.config")

completion["neovim/nvim-lspconfig"] = {
    opt = true,
    event = "BufReadPre",
    config = conf.nvim_lsp
}
completion["creativenull/efmls-configs-nvim"] = {
    opt = false,
    requires = "neovim/nvim-lspconfig"
}
completion["williamboman/nvim-lsp-installer"] = {
    opt = true,
    after = "nvim-lspconfig"
}
completion["RishabhRD/nvim-lsputils"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.nvim_lsputils
}
completion["tami5/lspsaga.nvim"] = {opt = true, after = "nvim-lspconfig"}
completion["kosayoda/nvim-lightbulb"] = {
    opt = true,
    after = "nvim-lspconfig",
    config = conf.lightbulb
}
completion["ray-x/lsp_signature.nvim"] = {opt = true, after = "nvim-lspconfig"}

completion["lukas-reineke/format.nvim"] = {
    opt = true,
    cmd = {"Format", "FormatWrite"},
    config = conf.format
}

completion["hrsh7th/nvim-cmp"] = {
    config = conf.cmp,
    event = "InsertEnter",
    requires = {
        {"lukas-reineke/cmp-under-comparator"},
        {"quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp"},
        {"hrsh7th/cmp-buffer", after = "cmp-nvim-ultisnips"},
        {"hrsh7th/cmp-nvim-lsp", after = "cmp-buffer"},
        {"hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp"},
        {"hrsh7th/cmp-path", after = "cmp-nvim-lua"},
        {"f3fora/cmp-spell", after = "cmp-path"},
        -- {"hrsh7th/cmp-copilot", after = "cmp-spell"}
        {
            'tzachar/cmp-tabnine',
            run = './install.sh',
            after = 'cmp-spell',
            config = conf.tabnine
        }
        -- {
        --     "uga-rosa/cmp-dictionary",
        --     after = "cmp-tabnine",
        --     config = conf.dictionary
        -- }
    }
}

completion["SirVer/ultisnips"] = {
    after = "nvim-cmp",
    config = conf.ultisnips,
    requires = "honza/vim-snippets"
}

completion['flaviusbuffon/jc-snippet'] = {after = 'ultisnips'}

-- completion["L3MON4D3/LuaSnip"] = {
--     after = "nvim-cmp",
--     config = conf.luasnip,
--     requires = "rafamadriz/friendly-snippets"
-- }
completion["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = conf.autopairs
}
completion["github/copilot.vim"] = {opt = true, cmd = "Copilot"}

return completion
