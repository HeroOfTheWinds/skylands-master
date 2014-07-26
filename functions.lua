skylands = {}

-- Functions

function skylands:appletree(x, y, z, area, data)

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

function skylands:goldentree(x, y, z, area, data)

	local c_tree = minetest.get_content_id("default:tree")
	local c_gapple = minetest.get_content_id("skylands:golden_apple")
	local c_gleaves = minetest.get_content_id("skylands:golden_leaves")
	for j = -2, 4 do
		if j >= 1 then
			for i = -2, 2 do
			for k = -2, 2 do
				local vi = area:index(x + i, y + j + 1, z + k)
				if math.random(48) == 2 then
					data[vi] = c_gapple
				elseif math.random(3) ~= 2 then
					data[vi] = c_gleaves
				end
			end
			end
		end
		local vi = area:index(x, y + j, z)
		data[vi] = c_tree
	end
end

function skylands:grass(data, vi)
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

function skylands:wheat(data, vi)
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

function skylands:flower(data, vi)
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

function skylands:desertplant(data, vi)
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
function skylands:remtree(x, y, z, area, data)
	local c_tree = minetest.get_content_id("default:tree")
	local c_apple = minetest.get_content_id("default:apple")
	local c_leaves = minetest.get_content_id("default:leaves")
	local c_jtree = minetest.get_content_id("default:jungletree")
	local c_jleaves = minetest.get_content_id("default:jungleleaves")
	local c_vine = minetest.get_content_id("skylands:vine")
	local c_gapple = minetest.get_content_id("skylands:golden_apple")
	local c_gleaves = minetest.get_content_id("skylands:golden_leaves")
	local c_air = minetest.get_content_id("air")
	for j = 1, 23 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y+j, z+k)
		if data[vi] == c_tree
		or data[vi] == c_apple
		or data[vi] == c_leaves
		or data[vi] == c_jtree
		or data[vi] == c_vine
		or data[vi] == c_jleaves
		or data[vi] == c_gapple
		or data[vi] == c_gleaves then
			data[vi] = c_air
		end
	end
	end
	end
	for j = 1, 23 do
	for i = -2, 2 do
	for k = -2, 2 do
		local vi = area:index(x+i, y-j, z+k)
		if data[vi] == c_tree
		or data[vi] == c_apple
		or data[vi] == c_leaves
		or data[vi] == c_jtree
		or data[vi] == c_vine
		or data[vi] == c_jleaves
		or data[vi] == c_gapple
		or data[vi] == c_gleaves then
			data[vi] = c_air
		end
	end
	end
	end
end

--function to remove flowers and grass
function skylands:remplant(x, y, z, area, data)
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
function skylands:pinetree(x, y, z, area, data)
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

function skylands:jungletree(x, y, z, area, data)
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

function skylands:acaciatree(x, y, z, area, data)
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
