-- Nodes

minetest.register_node("skylands:stone", {
	description = "FLI Stone",
	tiles = {"default_stone.png"},
	is_ground_content = false, -- stops cavegen removing this node
	groups = {cracky=3},
	drop = "default:cobble",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("skylands:desertstone", {
	description = "FLI Desert Stone",
	tiles = {"default_desert_stone.png"},
	is_ground_content = false, -- stops cavegen removing this node
	groups = {cracky=3},
	drop = "default:desert_stone",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("skylands:obsidian", {
	description = "FLI Obsidian",
	tiles = {"default_obsidian.png"},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky=1,level=2},
	drop = "default:obsidian",
})
--NEW! Cinder for volcanic biomes
minetest.register_node("skylands:cinder", {
	description = "Cinder",
	tiles = {"skylands_cinder.png"},
	is_ground_content = true,
	groups = {crumbly=2, falling_node=1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.5},
		dug = {name="default_gravel_footstep", gain=1.0},
	}),
})
--NEW! Cinder block crafted from cinder
minetest.register_node("skylands:cinder_block", {
	description = "Cinder Block",
	tiles = {"skylands_cinder_block.png"},
	groups = {cracky=3, crumbly=1},
	sounds = default.node_sound_stone_defaults(),
})
--Craft to create cinder blocks from 4 cinders
minetest.register_craft({
	output = "skylands:cinder_block",
	recipe = {
		{"skylands:cinder", "skylands:cinder"},
		{"skylands:cinder", "skylands:cinder"}
	}
})
--moreblocks nodes - iron_stone redefined so that cavegen doesn't destroy
minetest.register_node("skylands:coal_stone", {
	description = "FLI Coal Stone",
	tiles = {"moreblocks_coal_stone.png"},
	--is_ground_content = false,
	groups = {cracky=3},
	drop = "moreblocks:coal_stone",
})

minetest.register_node("skylands:iron_stone", {
	description = "FLI Iron Stone",
	tiles = {"moreblocks_iron_stone.png"},
	is_ground_content = false,
	groups = {cracky=3},
	drop = "moreblocks:iron_stone",
})
--define special flame so that it does not expire
minetest.register_node("skylands:constant_flame", {
	description = "Fire",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 14,
	groups = {igniter=2,dig_immediate=3,hot=3},
	drop = '',
	walkable = false,
	buildable_to = true,
	damage_per_second = 4,
	
	after_place_node = function(pos, placer)
		fire.on_flame_add_at(pos)
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		fire.on_flame_remove_at(pos)
	end,
})

--Define the ores so that they propagate with the abm
minetest.register_node("skylands:stone_with_coal", {
	description = "Coal Ore",
	tiles = {"default_stone.png^default_mineral_coal.png"},
	is_ground_content = true,
	groups = {cracky=3, skyores=1},
	drop = 'default:coal_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("skylands:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_stone.png^default_mineral_iron.png"},
	is_ground_content = true,
	groups = {cracky=2, skyores=1},
	drop = 'default:iron_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("skylands:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"default_stone.png^default_mineral_copper.png"},
	is_ground_content = true,
	groups = {cracky=2, skyores=1},
	drop = 'default:copper_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("skylands:stone_with_mese", {
	description = "Mese Ore",
	tiles = {"default_stone.png^default_mineral_mese.png"},
	is_ground_content = true,
	groups = {cracky=1, skyores=1},
	drop = "default:mese_crystal",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("skylands:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"default_stone.png^default_mineral_gold.png"},
	is_ground_content = true,
	groups = {cracky=2, skyores=1},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})
	
minetest.register_node("skylands:stone_with_diamond", {
	description = "Diamond Ore",
	tiles = {"default_stone.png^default_mineral_diamond.png"},
	is_ground_content = true,
	groups = {cracky=1, skyores=1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("skylands:mineral_tin", {
	description = "Tin Ore",
	tiles = {"default_stone.png^moreores_mineral_tin.png"},
	groups = {cracky=3, skyores=1},
	sounds = default_stone_sounds,
	drop = "moreores:tin_lump"
})
minetest.register_node("skylands:mineral_silver", {
	description = "Silver Ore",
	tiles = {"default_stone.png^moreores_mineral_silver.png"},
	groups = {cracky=3, skyores=1},
	sounds = default_stone_sounds,
	drop = "moreores:silver_lump"
})
minetest.register_node("skylands:mineral_mithril", {
	description = "Mithril Ore",
	tiles = {"default_stone.png^moreores_mineral_mithril.png"},
	groups = {cracky=3, skyores=1},
	sounds = default_stone_sounds,
	drop = "moreores:mithril_lump"
})

--Skylands-specific ores

--Silicon

minetest.register_node("skylands:sky_silicon", {
	description = "Silicon ore",
	tiles = {"default_stone.png^skylands_mineral_silicon.png"},
	groups = {cracky = 3, stone = 1, skyores=1},
	drop = "mesecons_materials:silicon",
})

minetest.register_node("skylands:mineral_silicon", {
	description = "Silicon ore",
	tiles = {"default_stone.png^skylands_mineral_silicon.png"},
	groups = {cracky = 3, stone = 1},
	drop = "mesecons_materials:silicon",
})

--Cavorite

minetest.register_node("skylands:sky_cavorite", {
	description = "Cavorite ore",
	tiles = {"default_stone.png^skylands_mineral_cavorite.png"},
	groups = {cracky = 3, stone = 1, skyores=1},
	drop = "skylands:cavorite",
})

minetest.register_node("skylands:mineral_cavorite", {
	description = "Cavorite ore",
	tiles = {"default_stone.png^skylands_mineral_cavorite.png"},
	groups = {cracky = 3, stone = 1},
	drop = "skylands:cavorite",
})

--WaterShed rip-offs

minetest.register_node("skylands:acacialeaf", {
	description = "Acacia Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"skylands_acacialeaf.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, flammable=2, leaves=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("skylands:acaciatree", {
	description = "Acacia Tree",
	tiles = {"skylands_acaciatreetop.png", "skylands_acaciatreetop.png", "skylands_acaciatree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("skylands:needles", {
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"skylands_needles.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("skylands:pinetree", {
	description = "Pine Tree",
	tiles = {"skylands_pinetreetop.png", "skylands_pinetreetop.png", "skylands_pinetree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("skylands:icydirt", {
	description = "Icy Dirt",
	tiles = {"skylands_icydirt.png", "default_dirt.png", "default_dirt.png^skylands_icydirt_side.png"},
	is_ground_content = false,
	groups = {crumbly=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_snow_footstep", gain=0.15},
		dug = {name="default_snow_footstep", gain=0.45},
	}),
})

minetest.register_node("skylands:goldengrass", {
	description = "Golden Grass",
	drawtype = "plantlike",
	tiles = {"skylands_goldengrass.png"},
	inventory_image = "skylands_goldengrass.png",
	wield_image = "skylands_goldengrass.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

minetest.register_node("skylands:drygrass", {
	description = "Dry Grass",
	tiles = {"skylands_drygrass.png", "default_dirt.png", "default_dirt.png^skylands_drygrass_side.png"},
	is_ground_content = false,
	groups = {crumbly=1,soil=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.4},
	}),
})

minetest.register_node("skylands:permafrost", {
	description = "Permafrost",
	tiles = {"skylands_permafrost.png"},
	is_ground_content = false,
	groups = {crumbly=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("skylands:vine", {
	description = "Jungletree Vine",
	drawtype = "airlike",
	paramtype = "light",
	walkable = false,
	climbable = true,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	groups = {not_in_creative_inventory=1},
})

minetest.register_node("skylands:acaciawood", {
	description = "Acacia Wood Planks",
	tiles = {"skylands_acaciawood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("skylands:pinewood", {
	description = "Pine Wood Planks",
	tiles = {"skylands_pinewood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

-- Craftitem

minetest.register_craftitem("skylands:cavorite", {
	description = "Cavorite",
	inventory_image = "skylands_cavorite.png",
})

-- Crafting

minetest.register_craft({
	output = "skylands:acaciawood 4",
	recipe = {
		{"skylands:acaciatree"},
	}
})

minetest.register_craft({
	output = "skylands:pinewood 4",
	recipe = {
		{"skylands:pinetree"},
	}
})

