

local radar_range = 7;	--in chunks
local radar_offset = { x=0, y=0 }	--chunk of the central radar, in case 0,0 isn't where things start

local chunk_size = 32;

local check_per_tick = 90;
local tick_offset = 24;

function posToChunk(pos)
	return { x=math.floor(pos.x/chunk_size), y=math.floor(pos.y/chunk_size) }
end

function nearestRadarChunk(chunk)
	return { x=math.floor((chunk.x-radar_offset.x)/radar_range+0.5)*radar_range+radar_offset.x, y=math.floor((chunk.y-radar_offset.y)/radar_range+0.5)*radar_range+radar_offset.y }
end


function markChunk(chunk, surface)
	if not surface.valid then
		return
	end

	key = surface.name .. ':' .. chunk.x .. ',' .. chunk.y

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
		--TODO: if holdingRadar
		if true then
			chunk = posToChunk(player.position)
			radar_chunk = nearestRadarChunk(chunk)
			markChunk(radar_chunk, player.surface)
		end
	end
	
end



function onTick()
	if ((game.tick + tick_offset) % check_per_tick == 0) then
		updateRadarMarkers()
	end

end

script.on_event(defines.events.on_tick, onTick)
