minetest.register_craftitem("skylands:cavorite_handle", {
	description = "Cavorite Tool Handle",
	inventory_image = "skylands_cavorite_handle.png",
})

minetest.register_craftitem("skylands:hallowed_air", {
	description = "Hallowed Air",
	inventory_image = "skylands_hallowed_air.png",
})

minetest.register_craftitem("skylands:cavorite_jar", {
	description = "Cavorite Jar",
	inventory_image = "skylands_cavorite_jar.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if (minetest.find_node_near(user:getpos(), 6, {"skylands:quartz_pillar"}) and user:getpos().y >= 8000) then
			return "skylands:hallowed_air"
		end	
		return "skylands:cavorite_jar"
	end,
})

minetest.register_craftitem("skylands:holy_hilt", {
	description = "Holy Sword Hilt",
	inventory_image = "skylands_holy_hilt.png",
})

--
-- HERE IT IS
-- THE HOLY AIR SWORD!!!!
--
minetest.register_tool("skylands:air_sword", {
	description = "Air Sword",
	inventory_image = "skylands_tool_airsword.png",
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=0.2, [2]=0.1, [3]=0.05}, uses=999, maxlevel=3},
		},
		damage_groups = {fleshy=999},
	}
})

--
-- Picks
--

minetest.register_tool("skylands:cavorite_pick_wood", {
	description = "Cavorite-Enhanced Wooden Pickaxe",
	inventory_image = "skylands_cavorite_tool_woodpick.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=1.10}, uses=8, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("skylands:cavorite_pick_stone", {
	description = "Cavorite-Enhanced Stone Pickaxe",
	inventory_image = "skylands_cavorite_tool_stonepick.png",
	tool_capabilities = {
		full_punch_interval = 0.87,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=1.33, [3]=0.8}, uses=15, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("skylands:cavorite_pick_steel", {
	description = "Cavorite-Enhanced Steel Pickaxe",
	inventory_image = "skylands_cavorite_tool_steelpick.png",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=2.67, [2]=1.07, [3]=0.53}, uses=15, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("skylands:cavorite_pick_bronze", {
	description = "Cavorite-Enhanced Bronze Pickaxe",
	inventory_image = "skylands_cavorite_tool_bronzepick.png",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=2.67, [2]=1.07, [3]=0.53}, uses=23, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("skylands:cavorite_pick_mese", {
	description = "Cavorite-Enhanced Mese Pickaxe",
	inventory_image = "skylands_cavorite_tool_mesepick.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=1.6, [2]=0.8, [3]=0.40}, uses=15, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})
minetest.register_tool("skylands:cavorite_pick_diamond", {
	description = "Cavorite-Enhanced Diamond Pickaxe",
	inventory_image = "skylands_cavorite_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=1.33, [2]=0.67, [3]=0.33}, uses=23, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})

--
-- Shovels
--

minetest.register_tool("skylands:cavorite_shovel_wood", {
	description = "Cavorite-Enhanced Wooden Shovel",
	inventory_image = "skylands_cavorite_tool_woodshovel.png",
	wield_image = "skylands_cavorite_tool_woodshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=2.00, [2]=1.07, [3]=0.40}, uses=7, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("skylands:cavorite_shovel_stone", {
	description = "Cavorite-Enhanced Stone Shovel",
	inventory_image = "skylands_cavorite_tool_stoneshovel.png",
	wield_image = "skylands_cavorite_tool_stoneshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.93,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=1.20, [2]=0.80, [3]=0.33}, uses=15, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("skylands:cavorite_shovel_steel", {
	description = "Cavorite-Enhanced Steel Shovel",
	inventory_image = "skylands_cavorite_tool_steelshovel.png",
	wield_image = "skylands_cavorite_tool_steelshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.73,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.00, [2]=0.60, [3]=0.27}, uses=22, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("skylands:cavorite_shovel_bronze", {
	description = "Cavorite-Enhanced Bronze Shovel",
	inventory_image = "skylands_cavorite_tool_bronzeshovel.png",
	wield_image = "skylands_cavorite_tool_bronzeshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.73,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=1.00, [2]=0.60, [3]=0.27}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("skylands:cavorite_shovel_mese", {
	description = "Cavorite-Enhanced Mese Shovel",
	inventory_image = "skylands_cavorite_tool_meseshovel.png",
	wield_image = "skylands_cavorite_tool_meseshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=0.80, [2]=0.40, [3]=0.20}, uses=15, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("skylands:cavorite_shovel_diamond", {
	description = "Cavorite-Enhanced Diamond Shovel",
	inventory_image = "skylands_cavorite_tool_diamondshovel.png",
	wield_image = "skylands_cavorite_tool_diamondshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=0.73, [2]=0.33, [3]=0.20}, uses=23, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})

--
-- Axes
--

minetest.register_tool("skylands:cavorite_axe_wood", {
	description = "Cavorite-Enhanced Wooden Axe",
	inventory_image = "skylands_cavorite_tool_woodaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=2.00, [3]=1.33}, uses=7, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})
minetest.register_tool("skylands:cavorite_axe_stone", {
	description = "Cavorite-Enhanced Stone Axe",
	inventory_image = "skylands_cavorite_tool_stoneaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=2.00, [2]=1.33, [3]=1.00}, uses=15, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
})
minetest.register_tool("skylands:cavorite_axe_steel", {
	description = "Cavorite-Enhanced Steel Axe",
	inventory_image = "skylands_cavorite_tool_steelaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=1.67, [2]=0.93, [3]=0.67}, uses=15, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("skylands:cavorite_axe_bronze", {
	description = "Cavorite-Enhanced Bronze Axe",
	inventory_image = "skylands_cavorite_tool_bronzeaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=1.67, [2]=0.93, [3]=0.67}, uses=15, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
})
minetest.register_tool("skylands:cavorite_axe_mese", {
	description = "Cavorite-Enhanced Mese Axe",
	inventory_image = "skylands_cavorite_tool_meseaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=1.47, [2]=0.67, [3]=0.40}, uses=15, maxlevel=3},
		},
		damage_groups = {fleshy=6},
	},
})
minetest.register_tool("skylands:cavorite_axe_diamond", {
	description = "Cavorite-Enhanced Diamond Axe",
	inventory_image = "skylands_cavorite_tool_diamondaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=1.40, [2]=0.60, [3]=0.33}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=7},
	},
})

--
-- Swords
--

minetest.register_tool("skylands:cavorite_sword_wood", {
	description = "Cavorite-Enhanced Wooden Sword",
	inventory_image = "skylands_cavorite_tool_woodsword.png",
	tool_capabilities = {
		full_punch_interval = 0.67,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.07, [3]=0.27}, uses=7, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	}
})
minetest.register_tool("skylands:cavorite_sword_stone", {
	description = "Cavorite-Enhanced Stone Sword",
	inventory_image = "skylands_cavorite_tool_stonesword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=0.93, [3]=0.27}, uses=15, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	}
})
minetest.register_tool("skylands:cavorite_sword_steel", {
	description = "Cavorite-Enhanced Steel Sword",
	inventory_image = "skylands_cavorite_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.53,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.67, [2]=0.8, [3]=0.23}, uses=15, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	}
})
minetest.register_tool("skylands:cavorite_sword_bronze", {
	description = "Cavorite-Enhanced Bronze Sword",
	inventory_image = "skylands_cavorite_tool_bronzesword.png",
	tool_capabilities = {
		full_punch_interval = 0.53,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.67, [2]=0.8, [3]=0.23}, uses=30, maxlevel=2},
		},
		damage_groups = {fleshy=6},
	}
})
minetest.register_tool("skylands:cavorite_sword_mese", {
	description = "Cavorite-Enhanced Mese Sword",
	inventory_image = "skylands_cavorite_tool_mesesword.png",
	tool_capabilities = {
		full_punch_interval = 0.47,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.33, [2]=0.67, [3]=0.23}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	}
})
minetest.register_tool("skylands:cavorite_sword_diamond", {
	description = "Cavorite-Enhanced Diamond Sword",
	inventory_image = "skylands_cavorite_tool_diamondsword.png",
	tool_capabilities = {
		full_punch_interval = 0.47,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.27, [2]=0.60, [3]=0.20}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	}
})

---
--- Crafting
---

--cavorite jar, used to hold hallowed air
minetest.register_craft({
	output = "skylands:cavorite_jar",
	recipe = {
		{"skylands:cavorite", "", "skylands:cavorite"},
		{"skylands:cavorite", "", "skylands:cavorite"},
		{"skylands:cavorite", "skylands:cavorite", "skylands:cavorite"},
	}
})

--holy sword hilt, only possible hilt for the air sword
minetest.register_craft({
	output = "skylands:holy_hilt",
	recipe = {
		{"default:diamond", "skylands:cavorite", "default:diamond"},
		{"", "default:gold_ingot", ""},
		{"", "default:diamond", ""},
	}
})

--The Holy Air Sword
minetest.register_craft({
	output = "skylands:air_sword",
	recipe = {
		{"skylands:hallowed_air"},
		{"skylands:hallowed_air"},
		{"skylands:holy_hilt"},
	}
})

--cavorite handle, base of all tool upgrades
minetest.register_craft({
	output = "skylands:cavorite_handle",
	recipe = {
		{"skylands:cavorite"},
		{"skylands:cavorite"},
	}
})

--tool upgrade recipes
minetest.register_craft({
	output = "skylands:cavorite_pick_wood",
	recipe = {
		{"default:pick_wood"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_pick_stone",
	recipe = {
		{"default:pick_stone"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_pick_steel",
	recipe = {
		{"default:pick_steel"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_pick_bronze",
	recipe = {
		{"default:pick_bronze"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_pick_mese",
	recipe = {
		{"default:pick_mese"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_pick_diamond",
	recipe = {
		{"default:pick_diamond"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_shovel_wood",
	recipe = {
		{"default:shovel_wood"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_shovel_stone",
	recipe = {
		{"default:shovel_stone"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_shovel_steel",
	recipe = {
		{"default:shovel_steel"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_shovel_bronze",
	recipe = {
		{"default:shovel_bronze"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_shovel_mese",
	recipe = {
		{"default:shovel_mese"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_shovel_diamond",
	recipe = {
		{"default:shovel_diamond"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_axe_wood",
	recipe = {
		{"default:axe_wood"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_axe_stone",
	recipe = {
		{"default:axe_stone"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_axe_steel",
	recipe = {
		{"default:axe_steel"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_axe_bronze",
	recipe = {
		{"default:axe_bronze"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_axe_mese",
	recipe = {
		{"default:axe_mese"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_axe_diamond",
	recipe = {
		{"default:axe_diamond"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_sword_wood",
	recipe = {
		{"default:sword_wood"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_sword_stone",
	recipe = {
		{"default:sword_stone"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_sword_steel",
	recipe = {
		{"default:sword_steel"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_sword_bronze",
	recipe = {
		{"default:sword_bronze"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_sword_mese",
	recipe = {
		{"default:sword_mese"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

minetest.register_craft({
	output = "skylands:cavorite_sword_diamond",
	recipe = {
		{"default:sword_diamond"},
		{"skylands:cavorite_handle"},
		{"skylands:cavorite_handle"},
	}
})

--check to add wear to crafts when previous tool was worn
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if string.find(itemstack:get_name(), "cavorite") and (itemstack:get_name() ~= "skylands:cavorite_jar") and (itemstack:get_name() ~= "skylands:cavorite_handle") then --either cavorite_handle or a cavorite tool
		local wear = 0 --store wear
		local old_tool = false --store old tool used
		--loop through old crafting grid to find old tool
		for i = 1, 9 do
			slot = old_craft_grid[i]
			if string.find(slot:get_name(), "default") then
				old_tool = slot --this is the tool, since it's name contains "default"
			end
		end
		if old_tool:get_wear() == 0 then --tool has no wear, so give one with no wear
			return
		else
			--tool has wear, so apply it to the new one.
			wear = old_tool:get_wear()
			return {name=itemstack:get_name(), count=1, wear=wear, metadata=""}
		end
	end
end)