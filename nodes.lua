-- Nodes

local OLDSTYLE = false --variable to toggle color of heavengrass

-- REDEFINITIONS --

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

-- UNIQUE NODES --

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

if OLDSTYLE == true then
	--gold heaven grass for heaven biome... rich soil
	minetest.register_node("skylands:heaven_grass", {
		description = "Dirt with Heaven Grass",
		tiles = {"skylands_heavengrass.png", "default_dirt.png", "default_dirt.png^skylands_heavengrass_side.png"},
		is_ground_content = true,
		groups = {crumbly=3,soil=1},
		drop = 'skylands:rich_dirt',
		sounds = default.node_sound_dirt_defaults({
			footstep = {name="default_grass_footstep", gain=0.25},
		}),
	})
else
	--gold heaven grass for heaven biome... rich soil
	minetest.register_node("skylands:heaven_grass", {
		description = "Dirt with Heaven Grass",
		tiles = {"skylands_heavengrass2.png", "skylands_rich_dirt.png", "skylands_rich_dirt.png^skylands_heavengrass_side2.png"},
		is_ground_content = true,
		groups = {crumbly=3,soil=1},
		drop = 'skylands:rich_dirt',
		sounds = default.node_sound_dirt_defaults({
			footstep = {name="default_grass_footstep", gain=0.25},
		}),
	})
end

minetest.register_node("skylands:rich_dirt", {
	description = "Rich Dirt",
	tiles = {"skylands_rich_dirt.png"},
	is_ground_content = true,
	groups = {crumbly=3,soil=1},
	sounds = default.node_sound_dirt_defaults(),
})

--golden leaves for heaven trees
minetest.register_node("skylands:golden_leaves", {
	description = "Golden Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"skylands_goldleaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'skylands:golden_sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'skylands:golden_leaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

--golden apples
minetest.register_node("skylands:golden_apple", {
	description = "Golden Apple",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"skylands_golden_apple.png"},
	inventory_image = "skylands_golden_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	on_use = minetest.item_eat(4),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name="skylands:golden_apple", param2=1})
		end
	end,
})

--white stone for Heaven biome
minetest.register_node("skylands:white_stone", {
	description = "White Stone",
	tiles = {"skylands_white_stone.png"},
	is_ground_content = false,
	groups = {cracky=3},
	drop = "skylands:white_cobble",
})

minetest.register_node("skylands:white_cobble", {
	description = "White Cobblestone",
	tiles = {"skylands_white_cobble.png"},
	is_ground_content = false,
	groups = {cracky=3},
})

minetest.register_node("skylands:white_stone_brick", {
	description = "White Stone Brick",
	tiles = {"skylands_white_stone_brick.png"},
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
})
--Craft to create white stone brick from 4 white stone blocks
minetest.register_craft({
	output = "skylands:white_stone_brick",
	recipe = {
		{"skylands:white_stone", "skylands:white_stone"},
		{"skylands:white_stone", "skylands:white_stone"}
	}
})
--smelt some white stone from white cobble
minetest.register_craft({
	type = "cooking",
	output = "skylands:white_stone",
	recipe ="skylands:white_cobble"
})

--quartz blocks for heaven biome
minetest.register_node("skylands:quartz", {
	description = "Quartz",
	tiles = {"skylands_quartz.png"},
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
})

--quartz pillars for heaven biome
minetest.register_node("skylands:quartz_pillar", {
	description = "Quartz Pillar",
	tiles = {"skylands_quartz.png", "skylands_quartz.png", "skylands_quartz_pillar.png"},
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
})

--recipe for quartz pillars
minetest.register_craft({
	output = "skylands:quartz_pillar 3",
	recipe = {
		{"skylands:quartz"},
		{"skylands:quartz"},
		{"skylands:quartz"}
	}
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

-- ORES --

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
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'skylands:acacia_sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'skylands:acacialeaf'},
			}
		}
	},
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
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'skylands:pine_sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'skylands:needles'},
			}
		}
	},
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

--hacky schematic placers

minetest.register_node("skylands:s_pillar", {
	description = "A Hack like you should know what this does...",
	tiles = {"skylands_quartz_pillar.png"},
	groups = {crumbly=3, schema=1},
})

minetest.register_node("skylands:s_parthenon", {
	description = "A Hack like you should know what this does...",
	tiles = {"skylands_quartz.png"},
	groups = {crumbly=3, schema=1},
})

--spring water

minetest.register_node("skylands:spring_flowing", {
	description = "Flowing Spring of Healing",
	inventory_image = minetest.inventorycube("skylands_spring.png"),
	drawtype = "flowingliquid",
	tiles = {"skylands_spring.png"},
	special_tiles = {
		{
			image="skylands_spring_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
		{
			image="skylands_spring_flowing_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.8}
		},
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "skylands:spring_flowing",
	liquid_alternative_source = "skylands:spring",
	liquid_viscosity = 1,
	post_effect_color = {a=64, r=100, g=100, b=0},
	groups = {water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, freezes=1, melt_around=1},
})

minetest.register_node("skylands:spring", {
	description = "Spring of Healing",
	inventory_image = minetest.inventorycube("skylands_spring.png"),
	drawtype = "liquid",
	tiles = {
		{name="skylands_spring_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name="skylands_spring_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0},
			backface_culling = false,
		}
	},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "skylands:spring_flowing",
	liquid_alternative_source = "skylands:spring",
	liquid_viscosity = 1,
	post_effect_color = {a=64, r=100, g=100, b=0},
	groups = {water=3, liquid=3, puts_out_fire=1, freezes=1},
})

--SAPLINGS--

minetest.register_node("skylands:pine_sapling", {
	description = "Pine Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"skylands_pine_sapling.png"},
	inventory_image = "skylands_pine_sapling.png",
	wield_image = "skylands_pine_sapling.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("skylands:acacia_sapling", {
	description = "Acacia Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"skylands_acacia_sapling.png"},
	inventory_image = "skylands_acacia_sapling.png",
	wield_image = "skylands_acacia_sapling.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("skylands:golden_sapling", {
	description = "Golden Tree Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"skylands_golden_sapling.png"},
	inventory_image = "skylands_golden_sapling.png",
	wield_image = "skylands_golden_sapling.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
})