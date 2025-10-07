return {
  -- Fast and feature-rich surround actions with Ruby-specific enhancements
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      -- Custom Ruby-specific surround patterns
      custom_surroundings = {
        -- Ruby do..end blocks
        d = {
          input = { "do%s*().-()%s*end", "^()%s*do%s*().-()%s*end%s*()$" },
          output = { left = "do\n  ", right = "\nend" },
        },
        -- Ruby def..end functions  
        f = {
          input = { "def%s+[%w_!?]+[^e]*().-()%s*end", "^()%s*def%s+[%w_!?]+[^e]*().-()%s*end%s*()$" },
          output = function()
            local name = vim.fn.input("Function name: ")
            if name == "" then name = "method_name" end
            return { left = "def " .. name .. "\n  ", right = "\nend" }
          end,
        },
        -- Ruby class..end
        c = {
          input = { "class%s+[%w:_]+[^e]*().-()%s*end", "^()%s*class%s+[%w:_]+[^e]*().-()%s*end%s*()$" },
          output = function()
            local name = vim.fn.input("Class name: ")
            if name == "" then name = "ClassName" end
            return { left = "class " .. name .. "\n  ", right = "\nend" }
          end,
        },
        -- Ruby module..end
        m = {
          input = { "module%s+[%w:_]+[^e]*().-()%s*end", "^()%s*module%s+[%w:_]+[^e]*().-()%s*end%s*()$" },
          output = function()
            local name = vim.fn.input("Module name: ")
            if name == "" then name = "ModuleName" end
            return { left = "module " .. name .. "\n  ", right = "\nend" }
          end,
        },
        -- Ruby if..end conditionals
        i = {
          input = { "if%s+[^e]*().-()%s*end", "^()%s*if%s+[^e]*().-()%s*end%s*()$" },
          output = function()
            local condition = vim.fn.input("Condition: ")
            if condition == "" then condition = "condition" end
            return { left = "if " .. condition .. "\n  ", right = "\nend" }
          end,
        },
        -- Ruby begin..end exception blocks
        b = {
          input = { "begin%s*().-()%s*end", "^()%s*begin%s*().-()%s*end%s*()$" },
          output = { left = "begin\n  ", right = "\nend" },
        },
        -- Ruby lambda blocks
        l = {
          input = { "lambda%s*{%s*().-()%s*}", "^()%s*lambda%s*{%s*().-()%s*}%s*()$" },
          output = function()
            local args = vim.fn.input("Lambda args (|x, y|): ")
            if args ~= "" and not args:match("^|.*|$") then
              args = "|" .. args .. "|"
            end
            return { left = "lambda { " .. args .. " ", right = " }" }
          end,
        },
        -- Ruby block with parameters (for yield, each, etc.)
        y = {
          input = { "{%s*|[^|]*|%s*().-()%s*}", "^()%s*{%s*|[^|]*|%s*().-()%s*}%s*()$" },
          output = function()
            local params = vim.fn.input("Block parameters: ")
            if params ~= "" and not params:match("^|.*|$") then
              params = "|" .. params .. "|"
            end
            return { left = "{ " .. params .. " ", right = " }" }
          end,
        },
      },
      -- Keymaps (gs prefix to avoid conflicts)
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local opts = LazyVim.opts("mini.surround")
      local mappings = {
        { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete Surrounding" },
        { opts.mappings.find, desc = "Find Right Surrounding" },
        { opts.mappings.find_left, desc = "Find Left Surrounding" },
        { opts.mappings.highlight, desc = "Highlight Surrounding" },
        { opts.mappings.replace, desc = "Replace Surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    config = function(_, opts)
      require("mini.surround").setup(opts)
      
      -- Ruby-specific autocmd for better integration
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "ruby", "eruby" },
        callback = function()
          -- Set up Ruby-specific which-key descriptions
          local wk = require("which-key")
          wk.add({
            { "gs", group = "surround" },
            { "gsa", desc = "Add surround" },
            { "gsad", desc = "Add do..end block" },
            { "gsaf", desc = "Add def..end function" },
            { "gsac", desc = "Add class..end" },
            { "gsam", desc = "Add module..end" },
            { "gsai", desc = "Add if..end" },
            { "gsab", desc = "Add begin..end" },
            { "gsal", desc = "Add lambda block" },
            { "gsay", desc = "Add block with params" },
          }, { buffer = 0 })
        end,
      })
    end,
  },
}
