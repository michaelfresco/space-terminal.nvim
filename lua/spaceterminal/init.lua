local M = {}

M.styles_list = { 'default', 'darker' }

---Change spaceterminal option (vim.g.spaceterminal_config.option)
---It can't be changed directly by modifying that field due to a Neovim lua bug with global variables (spaceterminal_config is a global variable)
---@param opt string: option name
---@param value any: new value
function M.set_options(opt, value)
    local cfg = vim.g.spaceterminal_config
    cfg[opt] = value
    vim.g.spaceterminal_config = cfg
end

---Apply the colorscheme (same as ':colorscheme spaceterminal')
function M.colorscheme()
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
    vim.o.termguicolors = true
    vim.g.colors_name = "spaceterminal"
    require('spaceterminal.highlights').setup()
    require('spaceterminal.terminal').setup()
end

---Toggle between spaceterminal styles ('default' <-> 'darker')
function M.toggle()
    local list = vim.g.spaceterminal_config.toggle_style_list
    local current = vim.g.spaceterminal_config.style
    -- advance to the style after the current one (wrapping around), so the
    -- first keypress always switches regardless of the stored index
    local index = 1
    for i, name in ipairs(list) do
        if name == current then index = i end
    end
    index = index + 1
    if index > #list then index = 1 end
    M.set_options('style', list[index])
    M.set_options('toggle_style_index', index)
    vim.api.nvim_command('colorscheme spaceterminal')
end

local default_config = {
    -- Main options --
    style = 'default',    -- choose between 'default' and 'darker'
    toggle_style_key = nil,
    toggle_style_list = M.styles_list,
    transparent = false,     -- don't set background
    term_colors = true,      -- if true enable the terminal
    ending_tildes = false,    -- show the end-of-buffer tildes
    cmp_itemkind_reverse = false,    -- reverse item kind highlights in cmp menu

    -- Changing Formats --
    code_style = {
        comments = 'none',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },

    -- Lualine options --
    lualine = {
        transparent = false, -- center bar (c) transparency
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Related --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl for diagnostics
        background = true,    -- use background color for virtual text
    },
}

---Setup spaceterminal.nvim options, without applying colorscheme
---@param opts table: a table containing options
function M.setup(opts)
    if not vim.g.spaceterminal_config or not vim.g.spaceterminal_config.loaded then    -- if it's the first time setup() is called
        vim.g.spaceterminal_config = vim.tbl_deep_extend('keep', vim.g.spaceterminal_config or {}, default_config)
        M.set_options('loaded', true)
        M.set_options('toggle_style_index', 0)
    end
    if opts then
        vim.g.spaceterminal_config = vim.tbl_deep_extend('force', vim.g.spaceterminal_config, opts)
        if opts.toggle_style_list then    -- this table cannot be extended, it has to be replaced
            M.set_options('toggle_style_list', opts.toggle_style_list)
        end
    end
    if vim.g.spaceterminal_config.toggle_style_key then
      vim.api.nvim_set_keymap('n', vim.g.spaceterminal_config.toggle_style_key, '<cmd>lua require("spaceterminal").toggle()<cr>', { noremap = true, silent = true })
    end
end

function M.load()
  vim.api.nvim_command('colorscheme spaceterminal')
end

return M
