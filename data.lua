data:extend({

	-- graphics for four corners
	{
		type = 'simple-entity-with-owner',
		name = 'top-left-radar-grid-guide',
		order = 'z[top-left-radarguide]',

		flags = {"not-blueprintable", "not-deconstructable"},
		render_layer = "explosion",
		map_color = {r=1, g=1, b=1, a=0.8},
		selectable_in_game = false,
		mined_sound = nil,
		minable = nil,
		collision_box = nil,
		selection_box = nil,
		collision_mask = {},

		pictures =
		{
			filename = "__RadarGridGuide__/graphics/top-left.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			shift = {1,1},
		},
	},

	{
		type = 'simple-entity-with-owner',
		name = 'top-right-radar-grid-guide',
		order = 'z[top-right-radarguide]',

		flags = {"not-blueprintable", "not-deconstructable"},
		render_layer = "explosion",
		map_color = {r=1, g=1, b=1, a=0.8},
		selectable_in_game = false,
		mined_sound = nil,
		minable = nil,
		collision_box = nil,
		selection_box = nil,
		collision_mask = {},

		pictures =
		{
			filename = "__RadarGridGuide__/graphics/top-right.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			shift = {-1,1},
		},
	},

	{
		type = 'simple-entity-with-owner',
		name = 'bottom-left-radar-grid-guide',
		order = 'z[bottom-left-radarguide]',

		flags = {"not-blueprintable", "not-deconstructable"},
		render_layer = "explosion",
		map_color = {r=1, g=1, b=1, a=0.8},
		selectable_in_game = false,
		mined_sound = nil,
		minable = nil,
		collision_box = nil,
		selection_box = nil,
		collision_mask = {},

		pictures =
		{
			filename = "__RadarGridGuide__/graphics/bottom-left.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			shift = {1,-1},
		},
	},

	{
		type = 'simple-entity-with-owner',
		name = 'bottom-right-radar-grid-guide',
		order = 'z[bottom-right-radarguide]',

		flags = {"not-blueprintable", "not-deconstructable"},
		render_layer = "explosion",
		map_color = {r=1, g=1, b=1, a=0.8},
		selectable_in_game = false,
		mined_sound = nil,
		minable = nil,
		collision_box = nil,
		selection_box = nil,
		collision_mask = {},

		pictures =
		{
			filename = "__RadarGridGuide__/graphics/bottom-right.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			shift = {-1,-1},
		},
	},

	-- hotkey to toggle mode
	{
		type = "custom-input",
		name = "radar-grid-guide-hotkey",
		key_sequence = "CONTROL + G",
		consuming = "script-only",
	},


})
