return {
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      -- nvim-cmp setup
      local cmp = require("cmp")
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      if cmp == nil then
        return
      end
      local lspkind = require("lspkind")

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end
      local luasnip = require("luasnip")
      local tabnine = require("cmp_tabnine.config")

      tabnine:setup({
        max_lines = 1000,
        max_num_results = 1,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        ignored_file_types = {
          -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
        show_prediction_strength = false,
      })

      local menu = {
        buffer = "[buffer]",
        keyword = "[LSP]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        luasnip = "[LuaSnip]",
        vsnip = "[VSnip]",
        dictionary = "[Dictionary]",
        path = "[Path]",
        cmp_tabnine = "[TabNine]",
      }
      cmp.setup({
        -- show source name in menu
        formatting = {
          format = function(entry, vim_item)
            -- if you have lspkind installed, you can use it like
            -- in the following line:
            vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" })
            vim_item.menu = menu[entry.source.name]
            if entry.source.name == "cmp_tabnine" then
              local detail = (entry.completion_item.labelDetails or {}).detail
              vim_item.kind = ""
              if detail and detail:find(".*%%.*") then
                vim_item.kind = vim_item.kind .. " " .. detail
              end

              if (entry.completion_item.data or {}).multiline then
                vim_item.kind = vim_item.kind .. " " .. "[ML]"
              end
            end
            local maxwidth = 80
            vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
            return vim_item
          end,
        },
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = false,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = true,
        },
        sorting = {
          priority_weight = 2.0,
          comparators = {
            require("cmp_tabnine.compare"), -- compare.score_offset, -- not good at all
            cmp.config.compare.locality,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            cmp.config.compare.offset,
            cmp.config.compare.order,
            -- compare.scopes, -- what?
            -- compare.sort_text,
            -- compare.kind,
            -- compare.length, -- useless
          },
        },

        -- https://www.reddit.com/r/neovim/comments/t7jl7p/cmp_autocomplete_in_golang_does_not_autoselect/
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- abort
          ["<C-c>"] = cmp.mapping.abort(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            -- https://github.com/golang/go/issues/40871
            -- https://github.com/hrsh7th/nvim-cmp/issues/706#issuecomment-1006260085
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lua" },
          { name = "cmp_tabnine", max_item_count = 1 },
          { name = "nvim_lsp" },
          { name = "keyword" },
        }, { { name = "neorg" } }, {
          { name = "buffer", max_item_count = 3 },
          { name = "path", max_item_count = 3, keyword_length = 3 },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.filetype("norg", {
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "dictionary", priority = 10, max_item_count = 5, keyword_length = 3 },
        }),
      })

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "dictionary", priority = 10, max_item_count = 5, keyword_length = 3 },
        }),
      })

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "buffer", max_item_count = 3 },
          { name = "dictionary", priority = 10, max_item_count = 5, keyword_length = 3 },
        }),
      })
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-under-comparator",
    },
  },
}
