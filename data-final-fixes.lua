--HACK: there's no way to access radar properties at run-time in control.lua, but they are available to the data-*.lua scripts
--so, use this file to capture the required data, and create a dummy entity prototype that has a string that *can* be read in control.lua

local radar_ranges = {}


for _,data in pairs(data.raw['radar']) do
	if data.max_distance_of_nearby_sector_revealed then
		radar_ranges[data.name] = data.max_distance_of_nearby_sector_revealed
	end
end


--dummy entity. occupies the global namespace, so needs to be unique

data:extend({

	{
		type = "flying-text",
		name = "RADAR_GRID_GUIDE:RANGE_DATA_HACK",
		time_to_live = 0,
		speed = 1,
		order = serpent.dump(radar_ranges),
	}

})

