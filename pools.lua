--pools code
local FLOW = 256


function skylands:gen_pool(lakepoints, area, data, x0, z0, x1, z1)
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_watsour = minetest.get_content_id("default:water_source")
	local c_lavasour = minetest.get_content_id("default:lava_source")
	local c_spring = minetest.get_content_id("skylands:spring")
	local c_ice = minetest.get_content_id("default:ice")
	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	local c_gapple = minetest.get_content_id("skylands:golden_apple")
	local c_gleaves = minetest.get_content_id("skylands:golden_leaves")
	local c_dirt = minetest.get_content_id("default:dirt")
	local c_snow = minetest.get_content_id("default:dirt_with_snow")
	local c_cinder = minetest.get_content_id("skylands:cinder")
	local c_gravel = minetest.get_content_id("default:gravel")
	local c_obsidian = minetest.get_content_id("skylands:obsidian")
	local c_hvngrass = minetest.get_content_id("skylands:heaven_grass")
	local c_rich = minetest.get_content_id("skylands:rich_dirt")
	
	local sidelen = x1 - x0 -- actually sidelen - 1


	--for xcen = x0 + 8, x1 - 7, 8 do
	--for zcen = z0 + 8, z1 - 7, 8 do
	for _, p in pairs(lakepoints) do --for index, point in table do
		--print("there are points. This is "..minetest.pos_to_string(p)..".")
		local xcen = p.x
		local yasurf = p.y -- y of above surface node
		local zcen = p.z
		local surf = false
		
		local ftype = "water"
		--for y = y1, 2, -1 do
			local vi = area:index(xcen, yasurf - 1, zcen)
			local c_node = data[vi]
			--if y == y1 and c_node ~= c_air then -- if top node solid
				--break
			if c_node == c_watsour then
				break
			elseif c_node == c_grass then
				ftype = "water"
				surf = true
			elseif c_node == c_snow then
				ftype = "ice"
				surf = true
			elseif c_node == c_cinder then
				ftype = "lava"
				surf = true
			elseif c_node == c_gravel then
				ftype = "lava"
				surf = true
			elseif c_node == c_obsidian then
				ftype = "lava"
				surf = true
			elseif c_node == c_hvngrass then
				ftype = "spring"
				surf = true
			end
		--end
		if surf then
			--print("now proceeding")
			local abort = false
			for ser = 1, 80 do
				--print("x+")
				local vi = area:index(xcen + ser, yasurf, zcen)
				local c_node = data[vi]
				if xcen + ser == x1 then
					--print("Abort x+")
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple
				and c_node ~= c_gapple
				and c_node ~= c_gleaves then
					--print("found x+ edge")
					break
				end
			end
			for ser = 1, 80 do
				--print("x-")
				local vi = area:index(xcen - ser, yasurf, zcen)
				local c_node = data[vi]
				if xcen - ser == x0 then
					--print("Abort x-")
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple
				and c_node ~= c_gapple
				and c_node ~= c_gleaves then
					--print("found x-")
					break
				end
			end
			for ser = 1, 80 do
				--print("y+")
				local vi = area:index(xcen, yasurf, zcen + ser)
				local c_node = data[vi]
				if zcen + ser == z1 then
					--print("abort y+")
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple
				and c_node ~= c_gapple
				and c_node ~= c_gleaves then
					--print("y+ found")
					break
				end
			end
			for ser = 1, 80 do
				--print("y-")
				local vi = area:index(xcen, yasurf, zcen - ser)
				local c_node = data[vi]
				if zcen - ser == z0 then
					--print("y- aborted")
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple
				and c_node ~= c_gapple
				and c_node ~= c_gleaves then
					--print("y- found")
					break
				end
			end
			local flab = false
			if abort then
				--print("aborted?!")
				flab = true
			end
			
			--create an easy, clean reference for the current fluid type
			local c_fluid = c_watsour
			local c_under = c_watsour
			if ftype == "lava" then
				c_fluid = c_lavasour
				c_under = c_lavasour
			elseif ftype == "ice" then
				c_fluid = c_ice
				c_under = c_watsour
			elseif ftype == "spring" then
				c_fluid = c_spring
				c_under = c_spring
			end
			
			local vi = area:index(xcen, yasurf, zcen)
			data[vi] = c_fluid
			--local flab = false -- flow abort
			--print("wow, made it to here")
			for flow = 1, FLOW do
				for z = z0, z1 do
					for x = x0, x1 do
						local vif = area:index(x, yasurf, z)
						if data[vif] == c_fluid then
							if x == x0 or x == x1 or z == z0 or z == z1 then
								flab = true -- if water at chunk edge abort flow
								break
							else -- flow water
								local vie = area:index(x + 1, yasurf, z)
								local viw = area:index(x - 1, yasurf, z)
								local vin = area:index(x, yasurf, z + 1)
								local vis = area:index(x, yasurf, z - 1)
								if data[vie] == c_tree then
									skylands:remtree(x + 1, yasurf, z, area, data)
									data[vie] = c_fluid
								elseif data[vie] == c_air
								or data[vie] == c_apple
								or data[vie] == c_leaves
								or data[vie] == c_gapple
								or data[vie] == c_gleaves then
									data[vie] = c_fluid
								end
								if data[viw] == c_tree then
									skylands:remtree(x - 1, yasurf, z, area, data)
									data[viw] = c_fluid
								elseif data[viw] == c_air
								or data[viw] == c_apple
								or data[viw] == c_leaves
								or data[vie] == c_gapple
								or data[vie] == c_gleaves then
									data[viw] = c_fluid
								end
								if data[vin] == c_tree then
									skylands:remtree(x, yasurf, z + 1, area, data)
									data[vin] = c_fluid
								elseif data[vin] == c_air
								or data[vin] == c_apple
								or data[vin] == c_leaves
								or data[vie] == c_gapple
								or data[vie] == c_gleaves then
									data[vin] = c_fluid
								end
								if data[vis] == c_tree then
									skylands:remtree(x, yasurf, z - 1, area, data)
									data[vis] = c_fluid
								elseif data[vis] == c_air
								or data[vis] == c_apple
								or data[vis] == c_leaves
								or data[vie] == c_gapple
								or data[vie] == c_gleaves then
									data[vis] = c_fluid
								end
							end
						end
					end
					if flab then
						break
					end
				end
				if flab then
					break
				end
			end
			
			
			--end
			
			
			if flab then -- erase water from this y level
				for z = z0, z1 do
				for x = x0, x1 do
					local vi = area:index(x, yasurf, z)
					if data[vi] == c_fluid then
						data[vi] = c_air
					end
				end
				end
				--print("no basin found at "..minetest.pos_to_string(p)..".")
			else -- flow downwards add dirt
				for z = z0, z1 do
				for x = x0, x1 do
					local vi = area:index(x, yasurf, z)
					if data[vi] == c_fluid then
						for y = yasurf - 1, yasurf - 15, -1 do
							local viu = area:index(x, y, z)
							if data[viu] == c_air then
								data[viu] = c_under
							elseif data[viu] == c_grass then
								data[viu] = c_dirt
								break
							elseif data[viu] == c_hvngrass then
								data[viu] = c_rich
							else
								break
							end
						end
					end
				end
				end
			end
		end
	end
	--end
	--end
end