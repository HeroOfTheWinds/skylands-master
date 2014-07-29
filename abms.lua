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
		if node.name == "skylands:sky_silicon" then
			orename = "skylands:mineral_silicon"
			orerad = 1
		end
		if node.name == "skylands:sky_cavorite" then
			orename = "skylands:mineral_cavorite"
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

--this should fix lake errors...
minetest.register_abm({
	nodenames = {"group:flora"},
	neighbors = {"group:water", "group:lava", "default:ice"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.remove_node(pos)
	end,
})

--grab schematics
local parthenon = minetest.get_modpath("skylands").."/schems/parthenon.mts"
local pillar = minetest.get_modpath("skylands").."/schems/pillar.mts"

--place pillars in heaven
minetest.register_abm({
	nodenames = {"skylands:s_pillar"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.place_schematic(pos, pillar, 0, {}, true)
	end,
})

--place parthenons in heaven
minetest.register_abm({
	nodenames = {"skylands:s_parthenon"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		npos = {x=pos.x,y=pos.y-7,z=pos.z}
		minetest.place_schematic(npos, parthenon, "random", {}, true)
	end,
})

--healing effect of springs
minetest.register_abm({
	nodenames = {"skylands:spring", "skylands:spring_flowing"},
	interval = 10.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, 1)
		local _,obj
		for _,obj in ipairs(all_objects) do
			if obj:is_player() then
				if obj:get_hp() < 20 then
					obj:set_hp(obj:get_hp() + 4)
				end
			end
		end
	end,
})

--heaven grass to and from rich_dirt
minetest.register_abm({
	nodenames = {"skylands:rich_dirt"},
	interval = 2,
	chance = 200,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if nodedef and (nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none"
				and (minetest.get_node_light(above) or 0) >= 13 then
			minetest.set_node(pos, {name = "skylands:heaven_grass"})
		end
	end
})

minetest.register_abm({
	nodenames = {"skylands:heaven_grass"},
	interval = 2,
	chance = 20,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef
				and not ((nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "skylands:rich_dirt"})
		end
	end
})

minetest.register_abm({
	nodenames = {"skylands:drygrass"},
	interval = 2,
	chance = 20,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef
				and not ((nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "default:dirt"})
		end
	end
})

minetest.register_abm({
	nodenames = {"skylands:icydirt"},
	interval = 2,
	chance = 20,
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef
				and not ((nodedef.sunlight_propagates or nodedef.paramtype == "light")
				and nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "default:dirt"})
		end
	end
})

--SAPLING GROWTH--

-- Pine sapling

minetest.register_abm({
	nodenames = {"skylands:pine_sapling"},
	interval = 59,
	chance = 3,
	action = function(pos, node)
		local x = pos.x
		local y = pos.y
		local z = pos.z
		local vm = minetest.get_voxel_manip()
		local pos1 = {x=x-2, y=y-4, z=z-2}
		local pos2 = {x=x+2, y=y+17, z=z+2}
		local emin, emax = vm:read_from_map(pos1, pos2)
		local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
		local data = vm:get_data()
		skylands:pinetree(x, y, z, area, data)
		vm:set_data(data)
		vm:write_to_map()
		vm:update_map()
	end,
})

-- Acacia sapling

minetest.register_abm({
	nodenames = {"skylands:acacia_sapling"},
	interval = 61,
	chance = 3,
	action = function(pos, node)
		local x = pos.x
		local y = pos.y
		local z = pos.z
		local vm = minetest.get_voxel_manip()
		local pos1 = {x=x-4, y=y-3, z=z-4}
		local pos2 = {x=x+4, y=y+6, z=z+4}
		local emin, emax = vm:read_from_map(pos1, pos2)
		local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
		local data = vm:get_data()
		skylands:acaciatree(x, y, z, area, data)
		vm:set_data(data)
		vm:write_to_map()
		vm:update_map()
	end,
})

-- Golden Tree sapling

minetest.register_abm({
	nodenames = {"skylands:golden_sapling"},
	interval = 61,
	chance = 3,
	action = function(pos, node)
		local x = pos.x
		local y = pos.y
		local z = pos.z
		local vm = minetest.get_voxel_manip()
		local pos1 = {x=x-4, y=y-3, z=z-4}
		local pos2 = {x=x+4, y=y+6, z=z+4}
		local emin, emax = vm:read_from_map(pos1, pos2)
		local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
		local data = vm:get_data()
		skylands:goldentree(x, y, z, area, data)
		vm:set_data(data)
		vm:write_to_map()
		vm:update_map()
	end,
})