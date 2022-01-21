local config = {}

function config.nvim_lsp() require("modules.completion.lsp") end

function config.lightbulb()
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
end

function config.cmp()
    vim.cmd [[highlight CmpItemAbbrDeprecated guifg=#D8DEE9 guibg=NONE gui=strikethrough]]
    vim.cmd [[highlight CmpItemKindSnippet guifg=#BF616A guibg=NONE]]
    vim.cmd [[highlight CmpItemKindUnit guifg=#D08770 guibg=NONE]]
    vim.cmd [[highlight CmpItemKindProperty guifg=#A3BE8C guibg=NONE]]
    vim.cmd [[highlight CmpItemKindKeyword guifg=#EBCB8B guibg=NONE]]
    vim.cmd [[highlight CmpItemAbbrMatch guifg=#5E81AC guibg=NONE]]
    vim.cmd [[highlight CmpItemAbbrMatchFuzzy guifg=#5E81AC guibg=NONE]]
    vim.cmd [[highlight CmpItemKindVariable guifg=#8FBCBB guibg=NONE]]
    vim.cmd [[highlight CmpItemKindInterface guifg=#88C0D0 guibg=NONE]]
    vim.cmd [[highlight CmpItemKindText guifg=#81A1C1 guibg=NONE]]
    vim.cmd [[highlight CmpItemKindFunction guifg=#B48EAD guibg=NONE]]
    vim.cmd [[highlight CmpItemKindMethod guifg=#B48EAD guibg=NONE]]

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    local has_any_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
                   vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                       col, col):match("%s") == nil
    end
    local press = function(key)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true,
                                                             true), "n", true)
    end
    vim.cmd [[packadd cmp-nvim-ultisnips]]
    local cmp = require("cmp")
    local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')
    cmp.setup {
        sorting = {
            comparators = {
                cmp.config.compare.offset, cmp.config.compare.exact,
                cmp.config.compare.score, require("cmp-under-comparator").under,
                cmp.config.compare.kind, cmp.config.compare.sort_text,
                cmp.config.compare.length, cmp.config.compare.order
            }
        },
        formatting = {
            format = function(entry, vim_item)
                local lspkind_icons = {
                    Text = "",
                    Method = "",
                    Function = "",
                    Constructor = "",
                    Field = "",
                    Variable = "",
                    Class = "ﴯ",
                    Interface = "",
                    Module = "",
                    Property = "ﰠ",
                    Unit = "",
                    Value = "",
                    Enum = "",
                    Keyword = "",
                    Snippet = "",
                    Color = "",
                    File = "",
                    Reference = "",
                    Folder = "",
                    EnumMember = "",
                    Constant = "",
                    Struct = "",
                    Event = "",
                    Operator = "",
                    TypeParameter = ""
                }
                -- load lspkind icons
                vim_item.kind = string.format("%s %s",
                                              lspkind_icons[vim_item.kind],
                                              vim_item.kind)

                vim_item.menu = ({
                    cmp_tabnine = "[TN]",
                    buffer = "[BUF]",
                    orgmode = "[ORG]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[LUA]",
                    path = "[PATH]",
                    tmux = "[TMUX]",
                    -- luasnip = "[SNIP]",
                    spell = "[SPELL]",
                    ultisnips = "[USP]"
                })[entry.source.name]

                return vim_item
            end
        },
        -- You can set mappings if you want
        mapping = {
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-q>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close()
            }),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
            }),
            --             ["<Tab>"] = cmp.mapping(function(fallback)
            --                 cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            --             end, {"i", "s"}),
            --             ["<S-Tab>"] = cmp.mapping(function(fallback)
            --                 cmp_ultisnips_mappings.jump_backwards(fallback)
            --             end, {"i", "s"}),
            --
            ["<Tab>"] = cmp.mapping({
                i = function(fallback)
                    if cmp.get_selected_entry() == nil and
                        vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                        press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    elseif has_any_words_before() then
                        press("<Tab>")
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if cmp.get_selected_entry() == nil and
                        vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                        press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
                    elseif has_any_words_before() then
                        press("<Tab>")
                    else
                        fallback()
                    end
                end
            }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, {'i', 's'}),

            ["<C-h>"] = cmp.mapping(function(fallback)
                if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    press("<ESC>:call UltiSnips#JumpBackwards()<CR>")
                else
                    fallback()
                end
            end, {"i", "s"}),
            ["<C-l>"] = cmp.mapping(function(fallback)
                if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    press("<ESC>:call UltiSnips#JumpForwards()<CR>")
                else
                    fallback()
                end
            end, {"i", "s"})
        },

        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end
        },

        -- You should specify your *installed* sources.

        sources = {
            {name = "nvim_lsp"}, {name = "nvim_lua"}, {name = "ultisnips"},
            {name = "buffer"}, {name = "path"}, {name = "spell"},
            {name = "tmux"}, {name = "orgmode"}, -- {name = "copilot"},
            {name = 'cmp_tabnine'}
            -- {
            --     name = 'dictionary',
            --     max_item_count = 3,
            --     keyword_length = 2,
            -- }
        }

    }
end

function config.ultisnips()
    vim.g.UltiSnipsRemoveSelectModeMappings = 0
    vim.g.UltiSnipsEditSplit = 'vertical'
    vim.g.UltiSnipsJumpForwardTrigger = "<C-l>"
    vim.g.UltiSnipsJumpBackwardTrigger = "<C-h>"
end

-- function config.luasnip()
--     require("luasnip").config.set_config {
--         history = true,
--         updateevents = "TextChanged,TextChangedI"
--     }
--     require("luasnip/loaders/from_vscode").load()
-- end
--
function config.tabnine()
    local tabnine = require('cmp_tabnine.config')
    tabnine:setup({max_line = 1000, max_num_results = 20, sort = true})
end

-- function config.dictionary()
--     vim.opt.dictionary:append("/usr/share/dict/words")
-- end

function config.autopairs()
    require("nvim-autopairs").setup {}

    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done",
                 cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
    cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
end

function config.nvim_lsputils()
    if vim.fn.has('nvim-0.5.1') == 1 then
        vim.lsp.handlers['textDocument/codeAction'] =
            require'lsputil.codeAction'.code_action_handler
        vim.lsp.handlers['textDocument/references'] =
            require'lsputil.locations'.references_handler
        vim.lsp.handlers['textDocument/definition'] =
            require'lsputil.locations'.definition_handler
        vim.lsp.handlers['textDocument/declaration'] =
            require'lsputil.locations'.declaration_handler
        vim.lsp.handlers['textDocument/typeDefinition'] =
            require'lsputil.locations'.typeDefinition_handler
        vim.lsp.handlers['textDocument/implementation'] =
            require'lsputil.locations'.implementation_handler
        vim.lsp.handlers['textDocument/documentSymbol'] =
            require'lsputil.symbols'.document_handler
        vim.lsp.handlers['workspace/symbol'] =
            require'lsputil.symbols'.workspace_handler
    else
        local bufnr = vim.api.nvim_buf_get_number(0)

        vim.lsp.handlers['textDocument/codeAction'] =
            function(_, _, actions)
                require('lsputil.codeAction').code_action_handler(nil, actions,
                                                                  nil, nil, nil)
            end

        vim.lsp.handlers['textDocument/references'] =
            function(_, _, result)
                require('lsputil.locations').references_handler(nil, result, {
                    bufnr = bufnr
                }, nil)
            end

        vim.lsp.handlers['textDocument/definition'] =
            function(_, method, result)
                require('lsputil.locations').definition_handler(nil, result, {
                    bufnr = bufnr,
                    method = method
                }, nil)
            end

        vim.lsp.handlers['textDocument/declaration'] = function(_, method,
                                                                result)
            require('lsputil.locations').declaration_handler(nil, result, {
                bufnr = bufnr,
                method = method
            }, nil)
        end

        vim.lsp.handlers['textDocument/typeDefinition'] = function(_, method,
                                                                   result)
            require('lsputil.locations').typeDefinition_handler(nil, result, {
                bufnr = bufnr,
                method = method
            }, nil)
        end

        vim.lsp.handlers['textDocument/implementation'] = function(_, method,
                                                                   result)
            require('lsputil.locations').implementation_handler(nil, result, {
                bufnr = bufnr,
                method = method
            }, nil)
        end

        vim.lsp.handlers['textDocument/documentSymbol'] =
            function(_, _, result, _, bufn)
                require('lsputil.symbols').document_handler(nil, result,
                                                            {bufnr = bufn}, nil)
            end

        vim.lsp.handlers['textDocument/symbol'] =
            function(_, _, result, _, bufn)
                require('lsputil.symbols').workspace_handler(nil, result,
                                                             {bufnr = bufn}, nil)
            end
    end
end

function config.format()
    require("format").setup {
        ["*"] = {
            {cmd = {"sed -i 's/[ \t]*$//'"}} -- remove trailing whitespace
        },
        c = {
            {
                cmd = {
                    function(file)
                        return string.format("clang-format -i -style=Google %s",
                                             file)
                    end
                }
            }
        },
        cpp = {
            {
                cmd = {
                    function(file)
                        return string.format("clang-format -i -style=Google %s",
                                             file)
                    end
                }
            }
        },
        tex = {
            {
                cmd = {
                    function(file)
                        return string.format(
                                   "latexindent -c /home/jczhang/.texcrufts/ -w -d %s",
                                   file)
                    end
                }
            }
        },
        bib = {
            {
                cmd = {
                    function(file)
                        return string.format(
                                   "latexindent -c /home/jczhang/.texcrufts/ -w -d %s",
                                   file)
                    end
                }
            }
        }
    }
end

return config
