local wezterm = require 'wezterm'
return {
  font = wezterm.font 'JetBrains Mono',
  --font = wezterm.font_with_fallback {
  --},
  --font = wezterm.font 'Fira Code',
  -- You can specify some parameters to influence the font selection;
  -- for example, this selects a Bold, Italic font variant.
  --font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true }),
  color_scheme = 'transparent',
}
