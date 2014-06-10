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