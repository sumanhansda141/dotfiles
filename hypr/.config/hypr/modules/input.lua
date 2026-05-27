---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us,us",
		kb_variant = "dvorak",
		kb_model = "",
		kb_options = "ctrl:swapcaps,grp:win_space_toggle,shift:both_capslock",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
