-- wheat grass

minetest.register_node("skylands:wheat_grass_1", {
	description = "Wheat Grass",
	drawtype = "plantlike",
	tiles = {"mapgen_wheat_grass_1.png"},
	-- use a bigger inventory image
	inventory_image = "mapgen_wheat_grass_3.png",
	wield_image = "mapgen_wheat_grass_3.png",
	waving = 1,
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = 2},
			{items = {'farming:wheat'}, rarity=7},
			{items = {''},},
		}
	},
	buildable_to = true,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1, waving=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("skylands:wheat_grass_"..math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("skylands:wheat_grass_" .. math.random(1,5) .. " "..itemstack:get_count()-(1-ret:get_count()))
	end,
})

minetest.register_node("skylands:wheat_grass_2", {
	description = "Wheat Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"mapgen_wheat_grass_2.png"},
	-- use a bigger inventory image
	inventory_image = "mapgen_wheat_grass_3.png",
	wield_image = "mapgen_wheat_grass_3.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	buildable_to = true,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1, waving=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = 2},
			{items = {'farming:wheat'}, rarity=7},
			{items = {''},},
		}
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("skylands:wheat_grass_"..math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("skylands:wheat_grass_" .. math.random(1,5) .. " "..itemstack:get_count()-(1-ret:get_count()))
	end,
})

minetest.register_node("skylands:wheat_grass_3", {
	description = "Wheat Grass",
	waving = 1,
	drawtype = "plantlike",
	tiles = {"mapgen_wheat_grass_3.png"},
	-- use a bigger inventory image
	inventory_image = "mapgen_wheat_grass_3.png",
	wield_image = "mapgen_wheat_grass_3.png",
	paramtype = "light",
	drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = 2},
			{items = {'farming:wheat'}, rarity=7},
			{items = {''},},
		}
	},
	walkable = false,
	is_ground_content = true,
	buildable_to = true,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1, waving=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("skylands:wheat_grass_"..math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("skylands:wheat_grass_" .. math.random(1,5) .. " "..itemstack:get_count()-(1-ret:get_count()))
	end,
})

minetest.register_node("skylands:wheat_grass_4", {
	description = "Wheat Grass",
	drawtype = "plantlike",
	tiles = {"mapgen_wheat_grass_4.png"},
	waving = 1,
	-- use a bigger inventory image
	inventory_image = "mapgen_wheat_grass_3.png",
	wield_image = "mapgen_wheat_grass_3.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = 2},
			{items = {'farming:wheat'}, rarity=7},
			{items = {''},},
		}
	},
	buildable_to = true,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1, waving=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("skylands:wheat_grass_"..math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("skylands:wheat_grass_" .. math.random(1,5) .. " "..itemstack:get_count()-(1-ret:get_count()))
	end,
})

minetest.register_node("skylands:wheat_grass_5", {
	description = "Wheat Grass",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"mapgen_wheat_grass_5.png"},
	-- use a bigger inventory image
	inventory_image = "mapgen_wheat_grass_3.png",
	wield_image = "mapgen_wheat_grass_3.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	buildable_to = true,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1, waving=1},
	sounds = default.node_sound_leaves_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = 2},
			{items = {'farming:wheat'}, rarity=7},
			{items = {''},},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("skylands:wheat_grass_"..math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("skylands:wheat_grass_" .. math.random(1,5) .. " "..itemstack:get_count()-(1-ret:get_count()))
	end,
})