data:extend({

	-- graphics for four corners
	{
		type = 'simple-entity-with-owner',
		name = 'top-left-radar-grid-guide',
		flags = {"not-on-map"},
		order = 'z[top-left-radarguide]',
		render_layer = "higher-object-above",
		
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
		flags = {"not-on-map"},
		order = 'z[top-right-radarguide]',
		render_layer = "higher-object-above",
		
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
		flags = {"not-on-map"},
		order = 'z[bottom-left-radarguide]',
		render_layer = "higher-object-above",
		
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
		flags = {"not-on-map"},
		order = 'z[bottom-right-radarguide]',
		render_layer = "higher-object-above",
		
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
