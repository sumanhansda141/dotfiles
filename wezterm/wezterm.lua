local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.window_close_confirmation = "NeverPrompt"
config.warn_about_missing_glyphs = false
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 15
config.window_background_opacity = 0.83
config.color_scheme = "Monokai (base16)"
config.colors = {
	background = "black",
}

config.enable_scroll_bar = true
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 12

return config
