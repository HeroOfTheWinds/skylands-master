-- skylands 2.0 by HeroOfTheWinds, based on floatindev 0.2.0 by paramat
-- For latest stable Minetest and back to 0.4.8
-- Depends default, fire, moreblocks?, moreores?
-- License: code WTFPL

-- Parameters

local YMIN = 700 -- Approximate realm limits.
local YMAX = 33000
local XMIN = -33000
local XMAX = 33000
local ZMIN = -33000
local ZMAX = 33000

local FLOW = 256 --for pools

local CHUINT = 1 -- Chunk interval for floatland layers
local WAVAMP = 16 -- Structure wave amplitude
local HISCAL = 24 -- Upper structure vertical scale
local LOSCAL = 24 -- Lower structure vertical scale
local HIEXP = 0.5 -- Upper structure density gradient exponent
local LOEXP = 0.5 -- Lower structure density gradient exponent
local CLUSAV = -0.4 -- Large scale variation average
local CLUSAM = 0.5 -- Large scale variation amplitude
local DIRTHR = 0.04 -- Dirt density threshold
local STOTHR = 0.08 -- Stone density threshold
local STABLE = 2 -- Minimum number of stacked stone nodes in column for dirt / sand on top

local APPCHA = 0.02 -- Appletree chance
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

-- 3D noise for floatlands

local np_float = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 277777979,
	octaves = 6,
	persist = 0.6
}

-- 3D noise for caves

local np_caves = {
	offset = 0,
	scale = 1,
	spread = {x=8, y=8, z=8},
	seed = -89000,
	octaves = 2,
	persist = 0.5
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
dofile(minetest.get_modpath("skylands").."/wheat.lua")

-- Functions

local function skylands_appletree(x, y, z, area, data)

	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	for j = -2, 4 do
		if j >= 1 then
			for i = -2, 2 do
			for k = -2, 2 do
				local vi = area:index(x + i, y + j + 1, z + k)
				if math.random(48) == 2 then
					data[vi] = c_apple
				elseif math.random(3) ~= 2 then
					data[vi] = c_leaves
				end
			end
			end
		end
		local vi = area:index(x, y + j, z)
		data[vi] = c_tree
	end
end

local function skylands_grass(data, vi)
	local c_grass1 = minetest.get_content_id("default:grass_1")
	local c_grass2 = minetest.get_content_id("default:grass_2")
	local c_grass3 = minetest.get_content_id("default:grass_3")
	local c_grass4 = minetest.get_content_id("default:grass_4")
	local c_grass5 = minetest.get_content_id("default:grass_5")
	local rand = math.random(5)
	if rand == 1 then
		data[vi] = c_grass1
	elseif rand == 2 then
		data[vi] = c_grass2
	elseif rand == 3 then
		data[vi] = c_grass3
	elseif rand == 4 then
		data[vi] = c_grass4
	else
		data[vi] = c_grass5
	end
end

local function skylands_wheat(data, vi)
	local c_wgrass1 = minetest.get_content_id("skylands:wheat_grass_1")
	local c_wgrass2 = minetest.get_content_id("skylands:wheat_grass_2")
	local c_wgrass3 = minetest.get_content_id("skylands:wheat_grass_3")
	local c_wgrass4 = minetest.get_content_id("skylands:wheat_grass_4")
	local c_wgrass5 = minetest.get_content_id("skylands:wheat_grass_5")
	local rand = math.random(5)
	if rand == 1 then
		data[vi] = c_wgrass1
	elseif rand == 2 then
		data[vi] = c_wgrass2
	elseif rand == 3 then
		data[vi] = c_wgrass3
	elseif rand == 4 then
		data[vi] = c_wgrass4
	else
		data[vi] = c_wgrass5
	end
end

local function skylands_flower(data, vi)
	local c_danwhi = minetest.get_content_id("flowers:dandelion_white")
	local c_danyel = minetest.get_content_id("flowers:dandelion_yellow")
	local c_rose = minetest.get_content_id("flowers:rose")
	local c_tulip = minetest.get_content_id("flowers:tulip")
	local c_geranium = minetest.get_content_id("flowers:geranium")
	local c_viola = minetest.get_content_id("flowers:viola")
	local rand = math.random(6)
	if rand == 1 then
		data[vi] = c_danwhi
	elseif rand == 2 then
		data[vi] = c_rose
	elseif rand == 3 then
		data[vi] = c_tulip
	elseif rand == 4 then
		data[vi] = c_danyel
	elseif rand == 5 then
		data[vi] = c_geranium
	else
		data[vi] = c_viola
	end
end

local function skylands_desertplant(data, vi)
	local c_cactus = minetest.get_content_id("default:cactus")
	local c_dry_shrub = minetest.get_content_id("default:dry_shrub")
	local rand = math.random(2)
	if rand == 1 then
		data[vi] = c_dry_shrub
	else
		data[vi] = c_cactus
	end
end

--function from highlandpools mod
function highlandpools_remtree(x, y, z, area, data)
	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	local c_air = minetest.get_content_id("air")
	for j = 1, 7 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y+j, z+k)
		if data[vi] == c_tree
		or data[vi] == c_apple
		or data[vi] == c_leaves then
			data[vi] = c_air
		end
	end
	end
	end
	for j = 1, 7 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y-j, z+k)
		if data[vi] == c_tree
		or data[vi] == c_apple
		or data[vi] == c_leaves then
			data[vi] = c_air
		end
	end
	end
	end
end

--function to remove flowers and grass
function highlandpools_remplant(x, y, z, area, data)
	local c_grass1 = minetest.get_content_id("default:grass_1")
	local c_grass2 = minetest.get_content_id("default:grass_2")
	local c_grass3 = minetest.get_content_id("default:grass_3")
	local c_grass4 = minetest.get_content_id("default:grass_4")
	local c_grass5 = minetest.get_content_id("default:grass_5")
	local c_wgrass1 = minetest.get_content_id("skylands:wheat_grass_1")
	local c_wgrass2 = minetest.get_content_id("skylands:wheat_grass_2")
	local c_wgrass3 = minetest.get_content_id("skylands:wheat_grass_3")
	local c_wgrass4 = minetest.get_content_id("skylands:wheat_grass_4")
	local c_wgrass5 = minetest.get_content_id("skylands:wheat_grass_5")
	local c_danwhi = minetest.get_content_id("flowers:dandelion_white")
	local c_danyel = minetest.get_content_id("flowers:dandelion_yellow")
	local c_rose = minetest.get_content_id("flowers:rose")
	local c_tulip = minetest.get_content_id("flowers:tulip")
	local c_geranium = minetest.get_content_id("flowers:geranium")
	local c_viola = minetest.get_content_id("flowers:viola")
	local c_cactus = minetest.get_content_id("default:cactus")
	local c_dry_shrub = minetest.get_content_id("default:dry_shrub")
	local c_golgrass = minetest.get_content_id("skylands:goldengrass")
	local c_jungrass = minetest.get_content_id("default:junglegrass")
	local c_air = minetest.get_content_id("air")
	local c_water = minetest.get_content_id("default:water_source")
	for j = 1, 7 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y+j, z+k)
		if data[vi] == c_grass1
		or data[vi] == c_grass2
		or data[vi] == c_grass3
		or data[vi] == c_grass4
		or data[vi] == c_grass5
		or data[vi] == c_wgrass1
		or data[vi] == c_wgrass2
		or data[vi] == c_wgrass3
		or data[vi] == c_wgrass4
		or data[vi] == c_wgrass5
		or data[vi] == c_golgrass
		or data[vi] == c_jungrass
		or data[vi] == c_danwhi
		or data[vi] == c_danyel
		or data[vi] == c_rose
		or data[vi] == c_tulip
		or data[vi] == c_geranium
		or data[vi] == c_viola
		or data[vi] == c_cactus
		or data[vi] == c_dry_shrub then
			data[vi] = c_air
		end
	end
	end
	end
	for j = 1, 7 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y-j, z+k)
		if data[vi] == c_grass1
		or data[vi] == c_grass2
		or data[vi] == c_grass3
		or data[vi] == c_grass4
		or data[vi] == c_grass5
		or data[vi] == c_wgrass1
		or data[vi] == c_wgrass2
		or data[vi] == c_wgrass3
		or data[vi] == c_wgrass4
		or data[vi] == c_wgrass5
		or data[vi] == c_golgrass
		or data[vi] == c_jungrass
		or data[vi] == c_danwhi
		or data[vi] == c_danyel
		or data[vi] == c_rose
		or data[vi] == c_tulip
		or data[vi] == c_geranium
		or data[vi] == c_viola
		or data[vi] == c_cactus
		or data[vi] == c_dry_shrub then
			data[vi] = c_air
		end
	end
	end
	end
end


--watershed functions
function skylands_pinetree(x, y, z, area, data)
	local c_wspitree = minetest.get_content_id("skylands:pinetree")
	local c_wsneedles = minetest.get_content_id("skylands:needles")
	local c_snowblock = minetest.get_content_id("default:snowblock")
	for j = -4, 14 do
		if j == 3 or j == 6 or j == 9 or j == 12 then
			for i = -2, 2 do
			for k = -2, 2 do
				if math.abs(i) == 2 or math.abs(k) == 2 then
					if math.random(7) ~= 2 then
						local vil = area:index(x + i, y + j, z + k)
						data[vil] = c_wsneedles
						local vila = area:index(x + i, y + j + 1, z + k)
						data[vila] = c_snowblock
					end
				end
			end
			end
		elseif j == 4 or j == 7 or j == 10 then
			for i = -1, 1 do
			for k = -1, 1 do
				if not (i == 0 and j == 0) then
					if math.random(11) ~= 2 then
						local vil = area:index(x + i, y + j, z + k)
						data[vil] = c_wsneedles
						local vila = area:index(x + i, y + j + 1, z + k)
						data[vila] = c_snowblock
					end
				end
			end
			end
		elseif j == 13 then
			for i = -1, 1 do
			for k = -1, 1 do
				if not (i == 0 and j == 0) then
					local vil = area:index(x + i, y + j, z + k)
					data[vil] = c_wsneedles
					local vila = area:index(x + i, y + j + 1, z + k)
					data[vila] = c_wsneedles
					local vilaa = area:index(x + i, y + j + 2, z + k)
					data[vilaa] = c_snowblock
				end
			end
			end
		end
		local vit = area:index(x, y + j, z)
		data[vit] = c_wspitree
	end
	local vil = area:index(x, y + 15, z)
	local vila = area:index(x, y + 16, z)
	local vilaa = area:index(x, y + 17, z)
	data[vil] = c_wsneedles
	data[vila] = c_wsneedles
	data[vilaa] = c_snowblock
end

function skylands_jungletree(x, y, z, area, data)
	local c_juntree = minetest.get_content_id("default:jungletree")
	local c_wsjunleaf = minetest.get_content_id("default:jungleleaves")
	local c_vine = minetest.get_content_id("skylands:vine")
	local top = math.random(17,23)
	local branch = math.floor(top * 0.6)
	for j = -5, top do
		if j == top or j == top - 1 or j == branch + 1 or j == branch + 2 then
			for i = -2, 2 do -- leaves
			for k = -2, 2 do
				local vi = area:index(x + i, y + j, z + k)
				if math.random(5) ~= 2 then
					data[vi] = c_wsjunleaf
				end
			end
			end
		elseif j == top - 2 or j == branch then -- branches
			for i = -1, 1 do
			for k = -1, 1 do
				if math.abs(i) + math.abs(k) == 2 then
					local vi = area:index(x + i, y + j, z + k)
					data[vi] = c_juntree
				end
			end
			end
		end
		if j >= 0 and j <= top - 3 then -- climbable nodes
			for i = -1, 1 do
			for k = -1, 1 do
				if math.abs(i) + math.abs(k) == 1 then
					local vi = area:index(x + i, y + j, z + k)
					data[vi] = c_vine
				end
			end
			end
		end
		if j <= top - 3 then -- trunk
			local vi = area:index(x, y + j, z)
			data[vi] = c_juntree
		end
	end
end

function skylands_acaciatree(x, y, z, area, data)
	local c_wsactree = minetest.get_content_id("skylands:acaciatree")
	local c_wsacleaf = minetest.get_content_id("skylands:acacialeaf")
	for j = -3, 6 do
		if j == 6 then
			for i = -4, 4 do
			for k = -4, 4 do
				if not (i == 0 or k == 0) then
					if math.random(7) ~= 2 then
						local vil = area:index(x + i, y + j, z + k)
						data[vil] = c_wsacleaf
					end
				end
			end
			end
		elseif j == 5 then
			for i = -2, 2, 4 do
			for k = -2, 2, 4 do
				local vit = area:index(x + i, y + j, z + k)
				data[vit] = c_wsactree
			end
			end
		elseif j == 4 then
			for i = -1, 1 do
			for k = -1, 1 do
				if math.abs(i) + math.abs(k) == 2 then
					local vit = area:index(x + i, y + j, z + k)
					data[vit] = c_wsactree
				end
			end
			end
		else
			local vit = area:index(x, y + j, z)
			data[vit] = c_wsactree
		end
	end
end


--vars for it moreblocks and moreores are installed
local mblocks = false
local mores = false



-- On generated function

minetest.register_on_generated(function(minp, maxp, seed)
	
	if (minetest.get_modpath("moreblocks")) then
		--let the generator know it can use moreblocks
		mblocks = minetest.get_modpath("moreblocks")
	end
	if (minetest.get_modpath("moreores")) then
		mores = minetest.get_modpath("moreores")
	end

	if minp.x < XMIN or maxp.x > XMAX
	or minp.y < YMIN or maxp.y > YMAX
	or minp.z < ZMIN or maxp.z > ZMAX then
		return
	end
	local chulay = math.floor((minp.y + 32) / 80) -- chunk layer number, 0 = surface chunk
	if math.fmod(chulay, CHUINT) ~= 0 then -- if chulay / CHUINT has a remainder
		return
	end

	local t1 = os.clock()
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z
	
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
	
	--watershed nodes for more biomes
	local c_icydirt = minetest.get_content_id("skylands:icydirt")
	local c_drygrass = minetest.get_content_id("skylands:drygrass")
	local c_permafrost = minetest.get_content_id("skylands:permafrost")
	
	local sidelen = x1 - x0 + 1
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
				local flomid = chumid + nvals_wave[nixz] * WAVAMP
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
								biome = 7 -- desert
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
						
						if y > flomid and density < STOTHR and stable[si] >= STABLE then
							--if nvals_biome[nixz] > 0.15 and nvals_biome[nixz] <= 0.65 then -- fine materials
							if biome == 7 then
								data[vi] = c_desand
								dirt[si] = dirt[si] + 1
							elseif biome == 4 or biome == 8 then --dry grassland or savanna
								if density < DIRTHR then
									data[vi] = c_drygrass
								else
									data[vi] = c_dirt
								end
								dirt[si] = dirt[si] + 1
							
							--snow biome
							elseif biome == 2 then --nvals_biome[nixz] < -0.45 then
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
							else
								if density < DIRTHR then
									data[vi] = c_grass
								else
									data[vi] = c_dirt
								end
								dirt[si] = dirt[si] + 1
							end
						else
							if biome == 7 then--nvals_biome[nixz] > 0.15 and nvals_biome[nixz] <= 0.65 then -- stone
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
							elseif biome == 2 then--nvals_biome[nixz] < -0.45 then
								if mblocks then
									data[vi] = c_ironstone
								else
									data[vi] = c_flistone
								end
							elseif math.random() < ORECHA then
								local osel = math.random(35)
								if osel >= 34 then
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
							biome = 7 -- desert
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
								
				
					if biome == 7 then --desert
						if dirt[si] >= 2 and math.random() < CACCHA then
							skylands_desertplant(data, vi)
						end
						dirt[si] = 0
					elseif nvals_biome[nixz] > 0.65 then --volcano
						if math.random() < FIRCHA then
							data[vi] = c_fire
						end
						dirt[si] = 0
					elseif biome == 5 then --grassland
						if dirt[si] >= 2 and math.random() < (APPCHA * 0.5) then
							skylands_appletree(x, y, z, area, data)
						elseif math.random() < FLOCHA then
							skylands_flower(data, vi)
						elseif math.random() < GRACHA then
							skylands_grass(data, vi)
						end
						dirt[si] = 0
					elseif biome == 10 then --wheat field
						skylands_wheat(data, vi)
						dirt[si] = 0
					elseif biome == 6 then --deciduous forest
						if dirt[si] >= 2 and math.random() < APPCHA then
							skylands_appletree(x, y, z, area, data)
						end
						dirt[si] = 0
					elseif biome == 4 then -- drylands
						if dirt[si] >= 2 and math.random() < GRACHA then
							data[vi] = c_dryshrub
						end
						dirt[si] = 0
					elseif biome == 3 then --taiga
						if dirt[si] >= 2 and math.random() < PINCHA then
							skylands_pinetree(x, y, z, area, data)
						end
						dirt[si] = 0
					elseif biome == 2 then --snowy plains
						if dirt[si] >= 2 and math.random() < SPINCHA then
							skylands_pinetree(x, y, z, area, data)
						end
						dirt[si] = 0
					elseif biome == 8 then --savanna
						if dirt[si] >= 2 and math.random() < ACACHA then
							skylands_acaciatree(x, y, z, area, data)
						elseif dirt[si] >= 2 and math.random() < GRACHA then
							data[vi] = c_golgrass
						end
						dirt[si] = 0
					elseif biome == 9 then --rainforest
						if dirt[si] >= 2 and math.random() < JUNTCHA then
							skylands_jungletree(x, y, z, area, data)
						elseif math.random() < JUNGCHA then
							data[vi] = c_jungrass
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
			nixz = nixz - 80
		end
		nixz = nixz + 80
	end
	
	--pools code
	local y0 = minp.y
	if y0 < YMIN or y0 > YMAX then
		return
	end
	
	local t1 = os.clock()
	local x0 = minp.x
	local z0 = minp.z
	print ("[highlandpools] chunk ("..x0.." "..y0.." "..z0..")")
	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local sidelen = x1 - x0 -- actually sidelen - 1
	
	--local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	--local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	--local data = vm:get_data()
	
	local c_ignore = minetest.get_content_id("ignore")
	local c_watsour = minetest.get_content_id("default:water_source")
	local c_lavasour = minetest.get_content_id("default:lava_source")
	local c_ice = minetest.get_content_id("default:ice")
	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	
	for xcen = x0 + 8, x1 - 7, 8 do
	for zcen = z0 + 8, z1 - 7, 8 do
		local yasurf = false -- y of above surface node
		local fluidtype = "water" --type of fluid to fill in
		for y = y1, 2, -1 do
			local vi = area:index(xcen, y, zcen)
			local c_node = data[vi]
			if y == y1 and c_node ~= c_air then -- if top node solid
				break
			elseif c_node == c_watsour then
				break
			elseif c_node == c_grass then
				yasurf = y + 1
				fluidtype = "water"
				break
			elseif c_node == c_snow then
				yasurf = y + 1
				fluidtype = "ice"
				break
			elseif c_node == c_cinder then
				yasurf = y + 1
				fluidtype = "lava"
				break
			elseif c_node == c_gravel then
				yasurf = y + 1
				fluidtype = "lava"
				break
			elseif c_node == c_obsidian then
				yasurf = y + 1
				fluidtype = "lava"
				break
			end
		end
		if yasurf then
			local abort = false
			for ser = 1, 80 do
				local vi = area:index(xcen + ser, yasurf, zcen)
				local c_node = data[vi]
				if xcen + ser == x1 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			for ser = 1, 80 do
				local vi = area:index(xcen - ser, yasurf, zcen)
				local c_node = data[vi]
				if xcen - ser == x0 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			for ser = 1, 80 do
				local vi = area:index(xcen, yasurf, zcen + ser)
				local c_node = data[vi]
				if zcen + ser == z1 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			for ser = 1, 80 do
				local vi = area:index(xcen, yasurf, zcen - ser)
				local c_node = data[vi]
				if zcen - ser == z0 then
					abort = true
				elseif c_node ~= c_air
				and c_node ~= c_tree
				and c_node ~= c_leaves
				and c_node ~= c_apple then
					break
				end
			end
			if abort then
				break
			end
			
			local vi = area:index(xcen, yasurf, zcen)
			if fluidtype == "water" then
				data[vi] = c_watsour
			elseif fluidtype == "lava" then
				data[vi] = c_lavasour
			elseif fluidtype == "ice" then
				data[vi] = c_ice
			end
			local flab = false -- flow abort
			for flow = 1, FLOW do
				for z = z0, z1 do
					for x = x0, x1 do
						local vif = area:index(x, yasurf, z)
						if data[vif] == c_watsour or data[vif] == c_lavasour or data[vif] == c_ice then
							if x == x0 or x == x1 or z == z0 or z == z1 then
								flab = true -- if water at chunk edge abort flow
								break
							else -- flow water
								local vie = area:index(x + 1, yasurf, z)
								local viw = area:index(x - 1, yasurf, z)
								local vin = area:index(x, yasurf, z + 1)
								local vis = area:index(x, yasurf, z - 1)
								if data[vie] == c_tree then
									highlandpools_remtree(x + 1, yasurf, z, area, data)
									if fluidtype == "water" then
										data[vie] = c_watsour
									elseif fluidtype == "lava" then
										data[vie] = c_lavasour
									elseif fluidtype == "ice" then
										data[vie] = c_ice
									end
								elseif data[vie] == c_air
								or data[vie] == c_apple
								or data[vie] == c_fire
								or data[vie] == c_leaves then
									highlandpools_remplant(x + 1, yasurf, z, area, data)
									if fluidtype == "water" then
										data[vie] = c_watsour
									elseif fluidtype == "lava" then
										data[vie] = c_lavasour
									elseif fluidtype == "ice" then
										data[vie] = c_ice
									end
								end
								if data[viw] == c_tree then
									highlandpools_remtree(x - 1, yasurf, z, area, data)
									if fluidtype == "water" then
										data[viw] = c_watsour
									elseif fluidtype == "lava" then
										data[viw] = c_lavasour
									elseif fluidtype == "ice" then
										data[viw] = c_ice
									end
								elseif data[viw] == c_air
								or data[viw] == c_apple
								or data[viw] == c_fire
								or data[viw] == c_leaves then
									highlandpools_remplant(x + 1, yasurf, z, area, data)
									if fluidtype == "water" then
										data[viw] = c_watsour
									elseif fluidtype == "lava" then
										data[viw] = c_lavasour
									elseif fluidtype == "ice" then
										data[viw] = c_ice
									end
								end
								if data[vin] == c_tree then
									highlandpools_remtree(x, yasurf, z + 1, area, data)
									if fluidtype == "water" then
										data[vin] = c_watsour
									elseif fluidtype == "lava" then
										data[vin] = c_lavasour
									elseif fluidtype == "ice" then
										data[vin] = c_ice
									end
								elseif data[vin] == c_air
								or data[vin] == c_apple
								or data[vin] == c_fire
								or data[vin] == c_leaves then
									highlandpools_remplant(x + 1, yasurf, z, area, data)
									if fluidtype == "water" then
										data[vin] = c_watsour
									elseif fluidtype == "lava" then
										data[vin] = c_lavasour
									elseif fluidtype == "ice" then
										data[vin] = c_ice
									end
								end
								if data[vis] == c_tree then
									highlandpools_remtree(x, yasurf, z - 1, area, data)
									if fluidtype == "water" then
										data[vis] = c_watsour
									elseif fluidtype == "lava" then
										data[vis] = c_lavasour
									elseif fluidtype == "ice" then
										data[vis] = c_ice
									end
								elseif data[vis] == c_air
								or data[vis] == c_apple
								or data[vis] == c_fire
								or data[vis] == c_leaves then
									highlandpools_remplant(x + 1, yasurf, z, area, data)
									if fluidtype == "water" then
										data[vis] = c_watsour
									elseif fluidtype == "lava" then
										data[vis] = c_lavasour
									elseif fluidtype == "ice" then
										data[vis] = c_ice
									end
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
			if flab then -- erase water from this y level
				for z = z0, z1 do
				for x = x0, x1 do
					local vi = area:index(x, yasurf, z)
					if data[vi] == c_watsour then
						data[vi] = c_air
					end
					if data[vi] == c_lavasour then
						data[vi] = c_air
					end
					if data[vi] == c_ice then
						data[vi] = c_air
					end
				end
				end
			else -- flow downwards add dirt
				for z = z0, z1 do
				for x = x0, x1 do
					local vi = area:index(x, yasurf, z)
					if data[vi] == c_watsour or data[vif] == c_lavasour then
						for y = yasurf - 1, y0, -1 do
							local viu = area:index(x, y, z)
							if data[viu] == c_air then
								if fluidtype == "water" or fluidtype == "ice" then
									data[viu] = c_watsour
								elseif fluidtype == "lava" then
									data[viu] = c_lavasour
								end
							elseif data[viu] == c_grass or data[viu] == c_snow then
								data[viu] = c_dirt
								break
							elseif data[viu] == c_cinder or data[viu] == c_gravel then
								data[viu] = c_fliobsidian
								break
							else
								highlandpools_remplant(x + 1, yasurf, z, area, data)
								break
							end
						end
					end
				end
				end
			end
		end
	end
	end
	
	vm:set_data(data)
	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map(data)
	local chugent = math.ceil((os.clock() - t1) * 1000)
	print ("[skylands] "..chugent.." ms")
end)

--generate ore clusters
minetest.register_abm({
	nodenames = {"group:skyores"},
	--neighbors = {"group:stone"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--variable to store name of node to place
		local orename = ""
		--variable to determine how large of a cluster to create
		local orerad = 1
		--determine above variables
		if node.name == "skylands:stone_with_coal" then
			orename = "default:stone_with_coal"
			orerad = 2
		end
		if node.name == "skylands:stone_with_iron" then
			orename = "default:stone_with_iron"
			orerad = 1
		end
		if node.name == "skylands:stone_with_gold" then
			orename = "default:stone_with_gold"
			orerad = 1
		end
		if node.name == "skylands:stone_with_mese" then
			orename = "default:stone_with_mese"
			orerad = 1
		end
		if node.name == "skylands:stone_with_diamond" then
			orename = "default:stone_with_diamond"
			orerad = 1
		end
		if node.name == "skylands:stone_with_copper" then
			orename = "default:stone_with_copper"
			orerad = 1
		end
		if node.name == "skylands:mineral_tin" then
			orename = "moreores:mineral_tin"
			orerad = 1
		end
		if node.name == "skylands:mineral_silver" then
			orename = "moreores:mineral_silver"
			orerad = 1
		end
		if node.name == "skylands:mineral_mithril" then
			orename = "moreores:mineral_mithril"
			orerad = 1
		end
		--in a cube of length orerad*2
		for x = -orerad, orerad do
		for y = -orerad, orerad do
		for z = -orerad, orerad do
			--store new position
			local np = {x=x+pos.x,y=y+pos.y,z=z+pos.z}
			--on random chance, spread.
			if math.random(6) == 1 then --needs balancing
				--only affect stone nodes
				targ = minetest.get_node(np)
				if targ.name == "skylands:stone" then
					minetest.set_node(np, {name=orename})
				end
			end
		end
		end 
		end
		--ensure this node dies so as to stop the abm
		minetest.set_node(pos, {name=orename})
	end,
})