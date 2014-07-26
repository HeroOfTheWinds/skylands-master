-- skylands 4.0 by HeroOfTheWinds, based on floatindev 0.2.0 by paramat
-- For latest stable Minetest and back to 0.4.8
-- Depends default, fire, stairs, moreblocks?, moreores?, mesecons?
-- License: code WTFPL

-- Parameters

local YMIN = 700 -- Approximate realm limits.
local YMAX = 33000
local XMIN = -33000
local XMAX = 33000
local ZMIN = -33000
local ZMAX = 33000

local CHUINT = 4 -- Chunk interval for floatland layers
local WAVAMP = 24 --16 -- Structure wave amplitude
local HISCAL = 128 --24 -- Upper structure vertical scale
local LOSCAL = 128 --24 -- Lower structure vertical scale
local HIEXP = 0.33 -- Upper structure density gradient exponent
local LOEXP = 0.33 -- Lower structure density gradient exponent
local CLUSAV = -0.4 -- Large scale variation average
local CLUSAM = 0.5 -- Large scale variation amplitude
local DIRTHR = 0.04 -- Dirt density threshold
local SANTHR = 0.05 -- Sandstone density threshold
local STOTHR = 0.08 -- Stone density threshold
local STABLE = 2 -- Minimum number of stacked stone nodes in column for dirt / sand on top

local APPCHA = 0.035 -- Appletree chance
local PINCHA = 0.015 -- Pine tree chance
local SPINCHA = 0.01 -- Pine tree chance for snow plains
local ACACHA = 0.01 -- Acacia tree chance
local JUNTCHA = 0.04 -- Jungle tree chance
local FLOCHA = 0.02 -- Flower chance
local GRACHA = 0.11 -- Grass chance
local CACCHA = 0.02 -- Cactus chance
local JUNGCHA = 0.2 -- Junglegrass chance
local FIRCHA = 0.03 -- Fire chance
local LAKCHA = 0.002
local ORECHA = 1 / (6 * 6 * 6)
local PILCHA = 0.002
local PARCHA = 0.0001

local HEAVEN = 8000 --altitude at which "heaven" islands begin appearing
local HEAVINT = 800 --interval between "heaven" layers; also determines layer width

-- 3D noise for floatlands

local np_float = {
	offset = 0,
	scale = 1,
	spread = {x=384, y=256, z=384},
	seed = 277777979,
	octaves = 6,
	persist = 0.67--6
}

-- 3D noise for caves

local np_caves = {
	offset = 0,
	scale = 1,
	spread = {x=16, y=16, z=16},
	seed = -89000,
	octaves = 2,--2
	persist = 0.5--0.5
}

-- 3D noise for large scale floatland size/density variation

local np_cluster = {
	offset = 0,
	scale = 1,
	spread = {x=2048, y=2048, z=2048},
	seed = 23,
	octaves = 1,
	persist = 0.5
}

-- 2D noise for wave

local np_wave = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = -400000000089,
	octaves = 3,
	persist = 0.5
}

-- 2D noise for biome

local np_biome = {
	offset = 0,
	scale = 1,
	spread = {x=250, y=250, z=250},
	seed = 9130,
	octaves = 3,
	persist = 0.5
}

-- 3D noise for temperature

local np_temp = {
	offset = 0,
	scale = 1,
	spread = {x=512, y=512, z=512},
	seed = 9130,
	octaves = 3,
	persist = 0.5
}

-- 3D noise for humidity

local np_humid = {
	offset = 0,
	scale = 1,
	spread = {x=512, y=512, z=512},
	seed = -55500,
	octaves = 3,
	persist = 0.5
}

-- Stuff

skylands = {}

dofile(minetest.get_modpath("skylands").."/nodes.lua")
dofile(minetest.get_modpath("skylands").."/stairs.lua")
dofile(minetest.get_modpath("skylands").."/wheat.lua")
dofile(minetest.get_modpath("skylands").."/abms.lua")
dofile(minetest.get_modpath("skylands").."/functions.lua")
dofile(minetest.get_modpath("skylands").."/pools.lua")



--vars for if mesecons, moreblocks and moreores are installed
local mblocks = false
local mores = false
local mcons = false


-- On generated function

minetest.register_on_generated(function(minp, maxp, seed)
	
	mblocks = minetest.get_modpath("moreblocks")
	mores = minetest.get_modpath("moreores")
	mcons = minetest.get_modpath("mesecons")

	if minp.x < XMIN or maxp.x > XMAX
	or minp.y < YMIN or maxp.y > YMAX
	or minp.z < ZMIN or maxp.z > ZMAX then
		return
	end
	
	local t1 = os.clock()
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z
	
	local sidelen = (x1 - x0 + 1)
	local chulay = math.floor((minp.y + 32) / sidelen) -- chunk layer number, 0 = surface chunk
   	local tercen = (math.floor(chulay / CHUINT) * CHUINT + CHUINT / 2) * sidelen - 32 -- terrain centre of this layer
	
	
	print ("[skylands] chunk minp ("..x0.." "..y0.." "..z0..")")
	
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()
	
	local c_air = minetest.get_content_id("air")
	local c_stodiam = minetest.get_content_id("skylands:stone_with_diamond")
	local c_stomese = minetest.get_content_id("skylands:stone_with_mese")
	local c_stogold = minetest.get_content_id("skylands:stone_with_gold")
	local c_stocopp = minetest.get_content_id("skylands:stone_with_copper")
	local c_stoiron = minetest.get_content_id("skylands:stone_with_iron")
	local c_stocoal = minetest.get_content_id("skylands:stone_with_coal")
	local c_grass = minetest.get_content_id("default:dirt_with_grass")
	local c_golgrass = minetest.get_content_id("skylands:goldengrass")
	local c_jungrass = minetest.get_content_id("default:junglegrass")
	local c_dryshrub = minetest.get_content_id("default:dry_shrub")
	local c_dirt = minetest.get_content_id("default:dirt")
	local c_desand = minetest.get_content_id("default:desert_sand")
	local c_sand = minetest.get_content_id("default:sand")
	local c_stosand = minetest.get_content_id("default:sandstone")
	--Newly added
	local c_snow = minetest.get_content_id("default:dirt_with_snow")
	local c_fliobsidian = minetest.get_content_id("skylands:obsidian")
	local c_mese = minetest.get_content_id("default:mese")
	local c_gravel = minetest.get_content_id("default:gravel")
	local c_cinder = minetest.get_content_id("skylands:cinder")
	local c_cindblock = minetest.get_content_id("skylands:cinder_block")
	local c_fire = minetest.get_content_id("skylands:constant_flame")
	--moreblocks
	local c_coalstone = minetest.get_content_id("skylands:coal_stone")
	local c_ironstone = minetest.get_content_id("skylands:iron_stone")
	--moreores
	local c_stotin = minetest.get_content_id("skylands:mineral_tin")
	local c_stomithril = minetest.get_content_id("skylands:mineral_mithril")
	local c_stosilver = minetest.get_content_id("skylands:mineral_silver")

	local c_flistone = minetest.get_content_id("skylands:stone")
	local c_flidestone = minetest.get_content_id("skylands:desertstone")
	
	local c_stocav = minetest.get_content_id("skylands:sky_cavorite")
	local c_stosil = minetest.get_content_id("skylands:sky_silicon")
	
	--watershed nodes for more biomes
	local c_icydirt = minetest.get_content_id("skylands:icydirt")
	local c_drygrass = minetest.get_content_id("skylands:drygrass")
	local c_permafrost = minetest.get_content_id("skylands:permafrost")
	
	--Heaven biome nodes
	local c_stowhite = minetest.get_content_id("skylands:white_stone")
	local c_richdirt = minetest.get_content_id("skylands:rich_dirt")
	local c_hvngrass = minetest.get_content_id("skylands:heaven_grass")
	local c_pillar = minetest.get_content_id("skylands:s_pillar")
	local c_parthenon = minetest.get_content_id("skylands:s_parthenon")
	
	
	local chulens = {x=sidelen, y=sidelen, z=sidelen}
	local minposxyz = {x=x0, y=y0, z=z0}
	local minposxz = {x=x0, y=z0}
	
	local nvals_float = minetest.get_perlin_map(np_float, chulens):get3dMap_flat(minposxyz)
	local nvals_caves = minetest.get_perlin_map(np_caves, chulens):get3dMap_flat(minposxyz)
	local nvals_cluster = minetest.get_perlin_map(np_cluster, chulens):get3dMap_flat(minposxyz)
	
	local nvals_wave = minetest.get_perlin_map(np_wave, chulens):get2dMap_flat(minposxz)
	local nvals_biome = minetest.get_perlin_map(np_biome, chulens):get2dMap_flat({x=x0+150, y=z0+50})
	
	local nvals_temp = minetest.get_perlin_map(np_temp, chulens):get3dMap_flat(minposxyz)
	local nvals_humid = minetest.get_perlin_map(np_humid, chulens):get3dMap_flat(minposxyz)
	
	local lakepoints = {}  --table to store points to scan for lake generation
	local li = 1 --index for lakepoints
	
	local nixyz = 1
	local nixz = 1
	local stable = {}
	local dirt = {}
	local chumid = y0 + sidelen / 2
	for z = z0, z1 do -- for each xy plane progressing northwards
		for x = x0, x1 do
			local si = x - x0 + 1
			dirt[si] = 0
			local nodename = minetest.get_node({x=x,y=y0-1,z=z}).name
			if nodename == "air"
			or nodename == "default:water_source"
			or nodename == "default:lava_source" then
				stable[si] = 0
			else -- all else including ignore in ungenerated chunks
				stable[si] = STABLE
			end
		end
		for y = y0, y1 do -- for each x row progressing upwards
			local vi = area:index(x0, y, z)
			for x = x0, x1 do -- for each node do
				local si = x - x0 + 1
				local flomid = tercen + nvals_wave[nixz] * WAVAMP -- y of floatland middle
				local grad
				if y > flomid then
					grad = ((y - flomid) / HISCAL) ^ HIEXP
				else
					grad = ((flomid - y) / LOSCAL) ^ LOEXP
				end
				local density = nvals_float[nixyz] - grad + CLUSAV + nvals_cluster[nixyz] * CLUSAM
				if density > 0 and density < 0.7 then -- if floatland shell
					if nvals_caves[nixyz] - density > -0.7 then -- if no cave
					
						n_temp = nvals_temp[nixyz]
						n_humid = nvals_humid[nixyz]
						local biome = false
						if n_temp < -0.35 then
							if n_humid < -0.35 then
								biome = 1 -- tundra
							elseif n_humid > 0.35 then
								biome = 3 -- taiga
							else
								biome = 2 -- snowy plains
							end
						elseif n_temp > 0.35 then
							if n_humid < -0.35 then
								if n_humid < -0.50 then
									biome = 7 -- desert
								else
									biome = 11 --sand(stone) borderland
								end
							elseif n_humid > 0.35 then
								biome = 9 -- rainforest
							else
								biome = 8 -- savanna
							end
						else
							if n_humid < -0.35 then
								biome = 4 -- dry grassland
							elseif n_humid > 0.35 then
								if n_humid > 0.55 and n_humid < 0.75 then
									biome = 10 -- wheat field
								else
									biome = 6 -- deciduous forest
								end
							else
								biome = 5 -- grassland
							end
						end
						
						--NOT FULLY IMPLEMENTED, UNCOMMENT ONLY IF YOU WANT A SHODDY PREVIEW!
						if y >= HEAVEN then
							--print((math.floor((y-HEAVEN)/1000) * 1000 / HEAVINT))
							if math.fmod((math.floor((y-HEAVEN)/1000) * 1000 / HEAVINT), 2) == 0 then  --can you math?
								biome = 12 --heaven
							end
						end
						
						if y > flomid and density < STOTHR and stable[si] >= STABLE then
							if biome == 7 then
								data[vi] = c_desand
								dirt[si] = dirt[si] + 1
							elseif biome == 11 then --sand border
								if density < SANTHR then
									data[vi] = c_sand --make sand
								else
									data[vi] = c_stosand --or sandstone
								end
								dirt[si] = dirt[si] + 1
							elseif biome == 4 or biome == 8 then --dry grassland or savanna
								if density < DIRTHR then
									data[vi] = c_drygrass
								else
									data[vi] = c_dirt
								end
								dirt[si] = dirt[si] + 1
							
							--snow biome
							elseif biome == 2 then
								if density < DIRTHR then
									data[vi] = c_snow
								else
									data[vi] = c_dirt
								end
								dirt[si] = dirt[si] + 1
							elseif biome == 1 then --tundra
								if density < DIRTHR then
									data[vi] = c_permafrost
								else
									data[vi] = c_permafrost
								end
								dirt[si] = dirt[si] + 1
							elseif biome == 3 then --taiga
								if density < DIRTHR then
									data[vi] = c_icydirt
								else
									data[vi] = c_dirt
								end
								dirt[si] = dirt[si] + 1
							--volcano biome
							elseif nvals_biome[nixz] > 0.65 then
								if density < DIRTHR then
									if nvals_biome[nixz] > 0.80 then
										data[vi] = c_cinder
									else
										data[vi] = c_gravel
									end
								else
									if nvals_biome[nixz] > 0.80 then
										data[vi] = c_cindblock
									else
										if mblocks == true then
											data[vi] = c_coalstone
										else
											data[vi] = c_flistone
										end
									end
								end
								dirt[si] = dirt[si] + 1
							elseif biome == 12 then
								if density < DIRTHR then
									data[vi] = c_hvngrass
								else
									data[vi] = c_richdirt
								end
								dirt[si] = dirt[si] + 1
							else
								if density < DIRTHR then
									data[vi] = c_grass
								else
									data[vi] = c_dirt
								end
								dirt[si] = dirt[si] + 1
							end
						else
							if biome == 7 then -- stone
								data[vi] = c_flidestone
							elseif nvals_biome[nixz] > 0.65 then
								if nvals_biome[nixz] > 0.80 then
									data[vi] = c_fliobsidian
								else
									if mblocks then
										data[vi] = c_coalstone
									else
										data[vi] = c_fliobsidian
									end
								end
							elseif biome == 12 then
								data[vi] = c_stowhite
							elseif biome == 2 then
								if mblocks then
									data[vi] = c_ironstone
								else
									data[vi] = c_flistone
								end
							elseif math.random() < ORECHA then
								local osel = math.random(40)
								if osel >= 38 then
									if mcons then
										data[vi] = c_stosil
									else
										data[vi] = c_stoiron
									end
								elseif osel >= 36 then
									data[vi] = c_stocav
								elseif osel >= 34 then
									if mores then
										if osel == 35 then
											data[vi] = c_mese
										else
											data[vi] = c_stodiam
										end
									else
										data[vi] = c_stodiam
									end
								elseif osel >= 31 then
									data[vi] = c_stomese
								elseif osel >= 28 then
									if mores then
										if osel == 30 then
											data[vi] = c_stomithril
										else
											data[vi] = c_stogold
										end
									else
										data[vi] = c_stogold
									end
								elseif osel >= 19 then
									data[vi] = c_stocopp
								elseif osel >= 10 then
									if mores then
										if osel >= 16 then
											data[vi] = c_stotin
										else
											data[vi] = c_stoiron
										end
									else
										data[vi] = c_stoiron
									end
								else
									data[vi] = c_stocoal
								end
							else
								data[vi] = c_flistone
							end
							stable[si] = stable[si] + 1
						end
						
						
						
					else -- cave
						stable[si] = 0
					end
				elseif y > flomid and density < 0 and dirt[si] >= 1 then -- node above surface dirt

					n_temp = nvals_temp[nixyz]
					n_humid = nvals_humid[nixyz]
					local biome = false
					if n_temp < -0.35 then
						if n_humid < -0.35 then
							biome = 1 -- tundra
						elseif n_humid > 0.35 then
							biome = 3 -- taiga
						else
							biome = 2 -- snowy plains
						end
					elseif n_temp > 0.35 then
						if n_humid < -0.35 then
							if n_humid < -0.50 then
									biome = 7 -- desert
								else
									biome = 11 --sand(stone) borderland
								end
						elseif n_humid > 0.35 then
							biome = 9 -- rainforest
						else
							biome = 8 -- savanna
						end
					else
						if n_humid < -0.35 then
							biome = 4 -- dry grassland
						elseif n_humid > 0.35 then
							if n_humid > 0.55 and n_humid < 0.75 then
								biome = 10 --wheat field
							else
								biome = 6 -- deciduous forest
							end
						else
							biome = 5 -- grassland
						end
					end
					--NOT FULLY IMPLEMENTED, UNCOMMENT ONLY IF YOU WANT A SHODDY PREVIEW!
					if y >= HEAVEN then
						if math.fmod((math.floor((y-HEAVEN)/1000) * 1000 / HEAVINT), 2) == 0 then  --can you math?
							biome = 12 --heaven
						end
					end
					
					if nvals_biome[nixz] <= 0.65 then --not volcano
					if biome == 7 or biome == 11 then --desert
						if dirt[si] >= 2 and math.random() < CACCHA then
							skylands:desertplant(data, vi)
						end
						dirt[si] = 0
					elseif biome == 5 then --grassland
						lakepoints[li] = {x=x,y=y,z=z}
						li = li + 1
						if dirt[si] >= 2 and math.random() < (APPCHA * 0.5) then
							skylands:appletree(x, y, z, area, data)
						elseif math.random() < FLOCHA then
							skylands:flower(data, vi)
						elseif math.random() < GRACHA then
							skylands:grass(data, vi)
						end
						dirt[si] = 0
					elseif biome == 12 then --heaven
						ppos = {x=x,y=y,z=z}
						lakepoints[li] = {x=x,y=y,z=z}
						li = li + 1
						if dirt[si] >= 2 and math.random() < (APPCHA * 0.7) then
							skylands:goldentree(x, y, z, area, data)
						elseif math.random() < FLOCHA then
							skylands:flower(data, vi)
						elseif math.random() < GRACHA then
							skylands:grass(data, vi)
						elseif math.random() < PILCHA then
							data[vi] = c_pillar
						elseif math.random() < PARCHA then
							data[vi] = c_parthenon
						end
						dirt[si] = 0
					elseif biome == 10 then --wheat field
						skylands:wheat(data, vi)
						dirt[si] = 0
					elseif biome == 6 then --deciduous forest
						lakepoints[li] = {x=x,y=y,z=z}
						li = li + 1
						if dirt[si] >= 2 and math.random() < APPCHA then
							skylands:appletree(x, y, z, area, data)
						end
						dirt[si] = 0
					elseif biome == 4 then -- drylands
						if dirt[si] >= 2 and math.random() < GRACHA then
							data[vi] = c_dryshrub
						end
						dirt[si] = 0
					elseif biome == 3 then --taiga
						if dirt[si] >= 2 and math.random() < PINCHA then
							skylands:pinetree(x, y, z, area, data)
						end
						dirt[si] = 0
					elseif biome == 2 then --snowy plains
						lakepoints[li] = {x=x,y=y,z=z}
						li = li + 1
						if dirt[si] >= 2 and math.random() < SPINCHA then
							skylands:pinetree(x, y, z, area, data)
						end
						dirt[si] = 0
					elseif biome == 8 then --savanna
						if dirt[si] >= 2 and math.random() < ACACHA then
							skylands:acaciatree(x, y, z, area, data)
						elseif dirt[si] >= 2 and math.random() < GRACHA then
							data[vi] = c_golgrass
						end
						dirt[si] = 0
					elseif biome == 9 then --rainforest
						lakepoints[li] = {x=x,y=y,z=z}
						li = li + 1
						if dirt[si] >= 2 and math.random() < JUNTCHA then
							skylands:jungletree(x, y, z, area, data)
						elseif math.random() < JUNGCHA then
							data[vi] = c_jungrass
						end
						dirt[si] = 0
					end	
					else --volcano
						--skylands:remtree(x, y, z, area, data)
						--data[vi] = c_air
						lakepoints[li] = {x=x,y=y,z=z}
						li = li + 1
						if math.random() < FIRCHA then
							data[vi] = c_fire
						end
						dirt[si] = 0					
					end
				else -- atmosphere
					stable[si] = 0
				end
				nixyz = nixyz + 1
				nixz = nixz + 1
				vi = vi + 1
			end
			nixz = nixz - sidelen
		end
		nixz = nixz + sidelen
	end
	
	skylands:gen_pool(lakepoints, area, data, x0, z0, x1, z1)
	
	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
	local chugent = math.ceil((os.clock() - t1) * 1000)
	print ("[skylands] "..chugent.." ms")
end)
