--local status, icons = pcall(require, "nvim-web-devicons")
--if (not status) then return end
--icons.setup {
require'nvim-web-devicons'.setup {
  override = {
    zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  };
  color_icons = true;
  },
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  --default = true
}
