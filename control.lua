
local radar_guide_mode = {
	never = 0,
	when_placing = 1,
	always = 2,
}

local default_radar_grid = 7;	--in chunks. default radar range = 3, grid = (range*2)+1
local default_radar_offset = { x=0, y=0 }	--chunk of the central radar, in case 0,0 isn't where things start
local default_guide_mode = radar_guide_mode.always

local radar_entity_ranges = nil;

--see data-final-fixes.lua for more details
function getRadarRange(name)
	if radar_entity_ranges == nil then
		radar_entity_ranges = loadstring(game.entity_prototypes["RADAR_GRID_GUIDE:RANGE_DATA_HACK"].order)()
	end

	return radar_entity_ranges[name]
end


local chunk_size = 32;

local check_per_tick = 30;
local tick_offset = 24;


function modeToString(mode)
	if mode == radar_guide_mode.never then
		return "never"
	elseif mode == radar_guide_mode.when_placing then
		return "when placing"
	elseif mode == radar_guide_mode.always then
		return "always"
	else
		return "unknown("..mode..")"
	end
end

function posToChunk(pos)
	return { x=math.floor(pos.x/chunk_size), y=math.floor(pos.y/chunk_size) }
end

function nearestRadarChunk(player,chunk)
	local radar_offset = getPlayerData(player,"radar-offset", default_radar_offset)
	local radar_grid = getPlayerData(player,"radar-grid", default_radar_grid)
	return { x=math.floor((chunk.x-radar_offset.x)/radar_grid+0.5)*radar_grid+radar_offset.x, y=math.floor((chunk.y-radar_offset.y)/radar_grid+0.5)*radar_grid+radar_offset.y }
end

function isRadar(name)
	local proto = game.entity_prototypes[name]
	if proto and proto.type == "radar" then
		return true
	end
	return false
end

function isPlayerHoldingRadar(player)
	local held = player.cursor_stack
	if held and held.valid and held.valid_for_read  then
		-- is it a radar?
		if isRadar(held.name) then
			return true
		end

		-- is it a blueprint containing a radar?
		if held.type == "blueprint" and held.is_blueprint_setup() then
			local bp = held.get_blueprint_entities()
			for _, bpentity in pairs(bp) do
				if isRadar(bpentity.name) then
					return true
				end
			end
		end
	end

	return false
end

function markChunk(chunk, surface)
	if not surface.valid then
		return
	end

	local key = surface.name .. ':' .. chunk.x .. ',' .. chunk.y

	if global.marked_chunks[key] == nil then
		pos_tl = { x = chunk.x * chunk_size, y = chunk.y * chunk_size }

		data = {}
		data.tl = surface.create_entity({ name = 'top-left-radar-grid-guide', position = {x=pos_tl.x, y=pos_tl.y} })
		data.tr = surface.create_entity({ name = 'top-right-radar-grid-guide', position = {x=pos_tl.x+chunk_size, y=pos_tl.y} })
		data.bl = surface.create_entity({ name = 'bottom-left-radar-grid-guide', position = {x=pos_tl.x, y=pos_tl.y+chunk_size} })
		data.br = surface.create_entity({ name = 'bottom-right-radar-grid-guide', position = {x=pos_tl.x+chunk_size, y=pos_tl.y+chunk_size} })
		
		global.marked_chunks[key] = data;
	end
end

function clearAllMarks()
	for _, data in pairs(global.marked_chunks) do
		if data.tl.valid then
			data.tl.destroy()
		end
		if data.tr.valid then
			data.tr.destroy()
		end
		if data.bl.valid then
			data.bl.destroy()
		end
		if data.br.valid then
			data.br.destroy()
		end
	end
	global.marked_chunks = {}
end


function updateRadarMarkers()
	if global.marked_chunks == nil then
		global.marked_chunks = {}
	end

	clearAllMarks()
	
	for _, player in pairs(game.players) do

		-- show the guide dependant on the user mode
		local mode = getPlayerData(player, "radar-mode", default_radar_mode)
		local show = false
		if mode == radar_guide_mode.always then
			show = true
		elseif mode == radar_guide_mode.when_placing and isPlayerHoldingRadar(player) then
			show = true
		end

		-- always show the guide when hovering over a radar
		if player.selected and player.selected.type == "radar" then
			show = true
		end

		if show then
			chunk = posToChunk(player.position)
			radar_chunk = nearestRadarChunk(player,chunk)
			markChunk(radar_chunk, player.surface)
		end
	end
	
end

function getPlayerData(player,key,default)
	if global.player_config then
		if global.player_config[player.name] then
			if global.player_config[player.name][key] ~= nil then
				return global.player_config[player.name][key]
			end
		end
	end
	return default
end

function setPlayerData(player,key,value)
	if global.player_config == nil then
		global.player_config = {}
	end
	if global.player_config[player.name] == nil then
		global.player_config[player.name] = {}
	end
	global.player_config[player.name][key] = value
end

function onHotkey(event)
	local player = event.player_index and game.players[event.player_index] or nil

	if player then

		if player.selected and player.selected.type == "radar" then
			-- if a radar is selected when the key is pressed, take radar position and range for future grid guides

			local chunk = posToChunk(player.selected.position)
			--range = radar_proto.max_distance_of_nearby_sector_revealed
			local range = getRadarRange(player.selected.name)

			local grid = range*2 + 1

			player.print("Radar Grid Guide: center position reconfigured to chunk ("..chunk.x..","..chunk.y.."), with a range of ±"..range.." chunks - grid size "..grid.." chunks")

			setPlayerData(player, "radar-offset", chunk)
			setPlayerData(player, "radar-grid", grid)
		else
			-- no radar selected, switch the guide mode

			local mode = getPlayerData(player, "radar-mode", default_guide_mode)
			if mode == radar_guide_mode.never then mode=radar_guide_mode.when_placing
			elseif mode == radar_guide_mode.when_placing then mode = radar_guide_mode.always
			else mode = radar_guide_mode.never
			end

			player.print("Radar Grid Guide: mode switched to: "..modeToString(mode))

			setPlayerData(player, "radar-mode", mode)
		end

	end

	--finally update markers to apply any changes instantly
	updateRadarMarkers()

end

function onTick()
	local need_update = false
	--TODO: change to monitor changes to player positions, and only update wwhen they move far enough
	if ((game.tick + tick_offset) % check_per_tick == 0) then
		need_update = true
	end

	-- there's no 'on_selection_changed' event fired when player.selected changes - fake something close to that here
	for _,player in pairs(game.players) do
		last_sel_radar = getPlayerData(player,"selected-radar",false)
		this_sel_radar = player.selected and player.selected.type == 'radar'
		if last_sel_radar ~= this_sel_radar then
			need_update = true
			setPlayerData(player, "selected-radar", this_sel_radar)
		end
	end

	if need_update then
		updateRadarMarkers()
	end
end

function onOtherEvent()
	updateRadarMarkers()
end

script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_player_cursor_stack_changed, onOtherEvent)
script.on_event("radar-grid-guide-hotkey", onHotkey)
