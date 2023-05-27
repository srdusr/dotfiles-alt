local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

-- To see mappings `g?` on nvim-tree
-- To see default mappings `:nvim-tree-default-mappings`

nvim_tree.setup({
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  git = {
  enable = true,
  ignore = false,
  timeout = 500,
},
  renderer = {
    root_folder_modifier = ":t",
    indent_markers = {
      enable = true,
    },
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    width = 30,
    --height = 30,
    side = "left",
    --mappings = {
    --  list = {
    --    { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
    --    { key = "h", cb = tree_cb("close_node") },
    --    { key = "v", cb = tree_cb("vsplit") },
    --    { key = "u", action = "dir_up" },
    --  },
    --},
  },
  trash = {
    cmd = "gio trash",
    require_confirm = true,
  },
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})
-- Highlight Groups
vim.api.nvim_command("highlight NvimTreeNormal guibg=none")
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
--vim.api.nvim_command("highlight NvimTreeWindowPicker ")
--vim.api.nvim_command("highlight NvimTreeNormal ")
--vim.api.nvim_command("highlight NvimTreeEndOfBuffer ")     --(NonText)
--vim.api.nvim_command("highlight NvimTreeCursorLine ")      --(CursorLine)
--vim.api.nvim_command("highlight NvimTreeCursorLineNr ")    --(CursorLineNr)
--vim.api.nvim_command("highlight NvimTreeLineNr ")          --(LineNr)
--vim.api.nvim_command("highlight NvimTreeWinSeparator ")    --(WinSeparator)
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
