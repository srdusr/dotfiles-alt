-----------------------------------------------------------
-- Neovim File Tree Configuration
-----------------------------------------------------------

--- To see mappings `g?` on nvim-tree
--- To see default mappings `:nvim-tree-default-mappings`

local icons = {
  webdev_colors = true,
  git_placement = 'signcolumn',
  modified_placement = 'after',
  padding = ' ',
  show = {
    file = true,
    folder = true,
    folder_arrow = true,
    git = true,
    modified = true,
  },

  glyphs = {
    default = '󰈔',
    symlink = '',
    folder = {
      arrow_open = '',
      arrow_closed = '',
      default = ' ',
      open = ' ',
      empty = ' ',
      empty_open = ' ',
      symlink = '',
      symlink_open = '',
    },

    git = {
      deleted = '',
      unmerged = '',
      untracked = '',
      unstaged = '',
      staged = '',
      renamed = '➜',
      ignored = '◌',
    },
  },
  web_devicons = {
    folder = {
      enable = true,
      color = true,
    },
  },
}

local renderer = {
  group_empty = true, -- default: true. Compact folders that only contain a single folder into one node in the file tree.
  highlight_git = false,
  full_name = false,
  highlight_opened_files = 'icon', -- "none" (default), "icon", "name" or "all"
  highlight_modified = 'icon',     -- "none", "name" or "all". Nice and subtle, override the open icon
  root_folder_label = ':~:s?$?/..?',
  indent_width = 2,
  indent_markers = {
    enable = true,
    inline_arrows = true,
    icons = {
      corner = '└',
      edge = '│',
      item = '│',
      bottom = '─',
      none = ' ',
    },
  },
  icons = icons,
}

local system_open = { cmd = 'zathura' }

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.15

local float = {
  enable = false,
  open_win_config = function()
    local screen_w = vim.opt.columns:get()
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
    local window_w = screen_w * WIDTH_RATIO
    local window_h = screen_h * HEIGHT_RATIO
    local window_w_int = math.floor(window_w)
    local window_h_int = math.floor(window_h)
    local center_x = (screen_w - window_w) / 2
    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
    return {
      border = 'rounded',
      relative = 'editor',
      row = center_y,
      col = center_x,
      width = window_w_int,
      height = window_h_int,
    }
  end,
}

local view = {
  cursorline = false,
  hide_root_folder = false,
  float = float,
  signcolumn = 'no',
  width = function()
    return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
  end,
  side = 'left',
}

local api = require('nvim-tree.api')
local function on_attach(bufnr)
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local mappings = {
    ['<C-]>'] = { api.tree.change_root_to_node, 'CD' },
    ['<C-e>'] = { api.node.open.replace_tree_buffer, 'Open: In Place' },
    ['<C-k>'] = { api.node.show_info_popup, 'Info' },
    ['<C-r>'] = { api.fs.rename_sub, 'Rename: Omit Filename' },
    ['<C-t>'] = { api.node.open.tab, 'Open: New Tab' },
    ['<C-v>'] = { api.node.open.vertical, 'Open: Vertical Split' },
    ['<C-x>'] = { api.node.open.horizontal, 'Open: Horizontal Split' },
    ['<BS>'] = { api.node.navigate.parent_close, 'Close Directory' },
    -- ["<CR>"] = { api.node.open.edit, "Open" },
    ['<Tab>'] = { api.node.open.preview, 'Open Preview' },
    ['>'] = { api.node.navigate.sibling.next, 'Next Sibling' },
    ['<'] = { api.node.navigate.sibling.prev, 'Previous Sibling' },
    ['.'] = { api.node.run.cmd, 'Run Command' },
    ['-'] = { api.tree.change_root_to_parent, 'Up' },
    ['a'] = { api.fs.create, 'Create' },
    ['bmv'] = { api.marks.bulk.move, 'Move Bookmarked' },
    ['B'] = { api.tree.toggle_no_buffer_filter, 'Toggle No Buffer' },
    ['c'] = { api.fs.copy.node, 'Copy' },
    -- ["C"] = { api.tree.toggle_git_clean_filter, "Toggle Git Clean" },
    ['[c'] = { api.node.navigate.git.prev, 'Prev Git' },
    [']c'] = { api.node.navigate.git.next, 'Next Git' },
    ['d'] = { api.fs.remove, 'Delete' },
    ['D'] = { api.fs.trash, 'Trash' },
    ['E'] = { api.tree.expand_all, 'Expand All' },
    ['e'] = { api.fs.rename_basename, 'Rename: Basename' },
    [']e'] = { api.node.navigate.diagnostics.next, 'Next Diagnostic' },
    ['[e'] = { api.node.navigate.diagnostics.prev, 'Prev Diagnostic' },
    ['F'] = { api.live_filter.clear, 'Clean Filter' },
    ['f'] = { api.live_filter.start, 'Filter' },
    ['g?'] = { api.tree.toggle_help, 'Help' },
    ['gy'] = { api.fs.copy.absolute_path, 'Copy Absolute Path' },
    ['H'] = { api.tree.toggle_hidden_filter, 'Toggle Dotfiles' },
    ['I'] = { api.tree.toggle_gitignore_filter, 'Toggle Git Ignore' },
    ['J'] = { api.node.navigate.sibling.last, 'Last Sibling' },
    ['K'] = { api.node.navigate.sibling.first, 'First Sibling' },
    ['m'] = { api.marks.toggle, 'Toggle Bookmark' },
    -- ["o"] = { api.node.open.edit, "Open" },
    ['O'] = { api.node.open.no_window_picker, 'Open: No Window Picker' },
    ['p'] = { api.fs.paste, 'Paste' },
    ['P'] = { api.node.navigate.parent, 'Parent Directory' },
    ['q'] = { api.tree.close, 'Close' },
    ['r'] = { api.fs.rename, 'Rename' },
    ['R'] = { api.tree.reload, 'Refresh' },
    ['s'] = { api.node.run.system, 'Run System' },
    ['S'] = { api.tree.search_node, 'Search' },
    ['U'] = { api.tree.toggle_custom_filter, 'Toggle Hidden' },
    ['W'] = { api.tree.collapse_all, 'Collapse' },
    ['x'] = { api.fs.cut, 'Cut' },
    ['y'] = { api.fs.copy.filename, 'Copy Name' },
    ['Y'] = { api.fs.copy.relative_path, 'Copy Relative Path' },
    ['<2-LeftMouse>'] = { api.node.open.edit, 'Open' },
    ['<2-RightMouse>'] = { api.tree.change_root_to_node, 'CD' },

    -- Mappings migrated from view.mappings.list
    ['l'] = { api.node.open.edit, 'Open' },
    ['<CR>'] = { api.node.open.edit, 'Open' },
    ['o'] = { api.node.open.edit, 'Open' },
    ['h'] = { api.node.navigate.parent_close, 'Close Directory' },
    ['v'] = { api.node.open.vertical, 'Open: Vertical Split' },
    ['C'] = { api.tree.change_root_to_node, 'CD' },
  }
  for keys, mapping in pairs(mappings) do
    vim.keymap.set('n', keys, mapping[1], opts(mapping[2]))
  end
end
api.events.subscribe(api.events.Event.FileCreated, function(file)
  vim.cmd('edit' .. file.fname)
end)

require('nvim-tree').setup({
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  hijack_cursor = true,
  disable_netrw = true,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  --ignore_buffer_on_setup = false,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    update_root = true,
    ignore_list = {},
  },
  root_dirs = {},
  prefer_startup_root = true,
  --hijack_directories = {
  --  enable = false,
  --},
  --respect_buf_cwd = false,
  sync_root_with_cwd = true,
  --reload_on_bufenter = false,
  view = view,
  system_open = system_open,
  renderer = renderer,
  on_attach = on_attach,
  notify = {
    threshold = vim.log.levels.ERROR,
  },
  git = { ignore = false },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = '⚑',
      info = '􀅳',
      warning = '▲',
      error = '',
    },
  },
  trash = {
    cmd = 'gio trash',
    require_confirm = true,
  },
  modified = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },
  filters = {
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = {},
    exclude = {},
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    remove_file = {
      close_window = true,
    },
    open_file = {
      quit_on_open = false,
      eject = true,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
        exclude = {
          filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
          buftype = { 'nofile', 'terminal', 'help' },
        },
      },
    },
  },
})

local api = require('nvim-tree.api')
local event = api.events.Event
api.events.subscribe(event.TreeOpen, function(_)
  vim.cmd([[setlocal statuscolumn=\ ]])
  vim.cmd([[setlocal cursorlineopt=number]])
  vim.cmd([[setlocal fillchars+=vert:🮇]])
  vim.cmd([[setlocal fillchars+=horizup:🮇]])
  vim.cmd([[setlocal fillchars+=vertright:🮇]])
end)

local function open_nvim_tree(data)
  vim.cmd.cd(data.file:match('(.+)/[^/]*$'))
  local directory = vim.fn.isdirectory(data.file) == 1
  if not directory then
    return
  end
  require('nvim-tree.api').tree.open()
end
vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

-- Highlight Groups
vim.api.nvim_command('highlight NvimTreeNormal guibg=none')

--vim.api.nvim_command("highlight NvimTreeSymlink ")
--vim.api.nvim_command("highlight NvimTreeSymlinkFolderName ")   --(Directory)
--vim.api.nvim_command("highlight NvimTreeFolderName ")          --(Directory)
--vim.api.nvim_command("highlight NvimTreeRootFolder ")
--vim.api.nvim_command("highlight NvimTreeFolderIcon ")
--vim.api.nvim_command("highlight NvimTreeOpenedFolderIcon ")    --(NvimTreeFolderIcon)
--vim.api.nvim_command("highlight NvimTreeClosedFolderIcon ")    --(NvimTreeFolderIcon)
--vim.api.nvim_command("highlight NvimTreeFileIcon ")
--vim.api.nvim_command("highlight NvimTreeEmptyFolderName ")     --(Directory)
--vim.api.nvim_command("highlight NvimTreeOpenedFolderName ")    --(Directory)
--vim.api.nvim_command("highlight NvimTreeExecFile ")
--vim.api.nvim_command("highlight NvimTreeOpenedFile ")
--vim.api.nvim_command("highlight NvimTreeModifiedFile ")
--vim.api.nvim_command("highlight NvimTreeSpecialFile ")
--vim.api.nvim_command("highlight NvimTreeImageFile ")
--vim.api.nvim_command("highlight NvimTreeIndentMarker ")
--vim.api.nvim_command("highlight NvimTreeLspDiagnosticsError ")         --(DiagnosticError)
--vim.api.nvim_command("highlight NvimTreeLspDiagnosticsWarning ")       --(DiagnosticWarn)
--vim.api.nvim_command("highlight NvimTreeLspDiagnosticsInformation ")   --(DiagnosticInfo)
--vim.api.nvim_command("highlight NvimTreeLspDiagnosticsHint ")          --(DiagnosticHint)
--vim.api.nvim_command("highlight NvimTreeGitDirty ")
--vim.api.nvim_command("highlight NvimTreeGitStaged ")
--vim.api.nvim_command("highlight NvimTreeGitMerge ")
--vim.api.nvim_command("highlight NvimTreeGitRenamed ")
--vim.api.nvim_command("highlight NvimTreeGitNew ")
--vim.api.nvim_command("highlight NvimTreeGitDeleted ")
--vim.api.nvim_command("highlight NvimTreeGitIgnored ")      --(Comment)
--vim.api.nvim_command("highlight NvimTreeNormal ")
--vim.api.nvim_command("highlight NvimTreeEndOfBuffer ")     --(NonText)
--vim.api.nvim_command("highlight NvimTreeCursorColumn ")    --(CursorColumn)
--vim.api.nvim_command("highlight NvimTreeFileDirty ")       --(NvimTreeGitDirty)
--vim.api.nvim_command("highlight NvimTreeFileStaged ")      --(NvimTreeGitStaged)
--vim.api.nvim_command("highlight NvimTreeFileMerge ")       --(NvimTreeGitMerge)
--vim.api.nvim_command("highlight NvimTreeFileRenamed ")     --(NvimTreeGitRenamed)
--vim.api.nvim_command("highlight NvimTreeFileNew ")         --(NvimTreeGitNew)
--vim.api.nvim_command("highlight NvimTreeFileDeleted ")     --(NvimTreeGitDeleted)
--vim.api.nvim_command("highlight NvimTreeFileIgnored ")     --(NvimTreeGitIgnored)
--vim.api.nvim_command("highlight NvimTreeLiveFilterPrefix ")
--vim.api.nvim_command("highlight NvimTreeLiveFilterValue ")
--vim.api.nvim_command("highlight NvimTreeBookmark ")
