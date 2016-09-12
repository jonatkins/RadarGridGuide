data:extend({

	{
		type = 'decorative',
		name = 'crosshair-radar-grid-guide',
		flags = {"placeable-neutral", "player-creation", "not-repairable"},
		icon = "__RadarGridGuide__/graphics/crosshair.png",
		order = 'z[crosshair-radarguide]',
		render_layer = "higher-object-above",
		
		pictures =
		{
			filename = "__RadarGridGuide__/graphics/crosshair.png",
			priority = "extra-high",
			width = 64,
			height = 64,
			shift = {0,0},
		},
	},

})
