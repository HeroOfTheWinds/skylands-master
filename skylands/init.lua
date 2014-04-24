-- skylands 0.8 by HeroOfTheWinds
-- HeroOfTheWinds' modification of: flolands 0.3.0 by paramat.
-- For Minetest 0.4.3 or later.
-- Depends default.
-- Licenses: WTFPL for code

-- Parameters.

local ONGEN = true -- Enable floatlands generation (true/false).
local YMIN = 800 -- Approximate minimum altitude. Will be rounded down to chunk edge.
local YMAX = 16000 -- Approximate maximum altitude. Will be rounded up to chunk edge.
local XMIN = -16000 -- Approximate edges.
local XMAX = 16000 -- 
local ZMIN = -16000 -- 
local ZMAX = 16000 -- 

local RARBOT = 0.5 -- 0.5 -- Rarity at YMIN. 0.5 = very rare, 0.4 = scattered floatlands, 0 = 50% floatland area per chunk.
local RARTOP = 0 -- 0 -- Rarity at YMAX.--Consider increasing, 50% land is a bit ridiculous... no one would see the sun below irl
local VMID = 0.5 -- 0.5 -- Centre of y variation as a fraction of chunk height.
local VAMP = 24 -- 16 -- Amplitude of y variation.
local TGRAD = 32 -- 32 -- Noise gradient to create top surface. Controls height of top hills.
local BGRAD = 32 -- 32 -- Noise gradient to create bottom surface. Controls height of inverted hills.
local VOID = 10 -- 10 -- Void noise threshold. Controls size of central voids. 1 = large voids, 10 = no voids.
local FISEXP = 0.5 -- 0.5 -- Fissure expansion rate under surface.
local FISOFF = -0.01 -- -0.01 -- Fissure noise offset for noise2. Controls size of fissures and amount / size of fissure entrances at surface.
local ORECHA = 128 -- 512 = 8^3 -- 1/x chance of ore.
local DIACHA = 256 -- 6859 = 19^3 -- 1/x chance ore is diamond.
local MESCHA = 256 -- 5832 = 18^3 -- 1/x chance ore is stone_with_mese.
local BMECHA = 512 --1/x chance ore is mese block.
local GOLCHA = 64 -- 1/x chance ore is gold.
local COPCHA = 32 -- 1/x chance ore is copper.
local IROCHA = 3 -- 3 -- 1/x chance ore is iron. Remaining ore nodes are coal.
local GRACHA = 289 -- 289 = 17^2 -- 1/x chance of grass on surface sand.
local JUNCHA = 289 --chance of Junglegrass
local DRYCHA = 289 --chance of dry shrubs.
local CACCHA = 324 --chance of cactus.

--EXPERIMENTAL--
local GEN_BIOMES = true --change to false to disable the experimental biomes
local GEN_WATER = true --controls whether or not to generate lakes

local ISLTYPE = "" --variable to store what kind of island is being generated

local WATCHA = 12800 --80^2 * 2. (every two chunks, approx. May be too large.)  Chance of water/lakes appearing.  VERY EXPERIMENTAL.
local LAKE_MAX = 20 -- max radius of lakes
local LAKE_MIN = 8 -- minimum radius of lakes


-- 2D perlinB for biome generation
local SEEDDIFFB = -188900
local OCTAVESB = 1
local PERSISTENCEB = 0.25 --0.25 default
local SCALEB = 128  --the smaller the value, the smaller each biome is.  1=chaos of desert, snow, obsidian and grass. 128 = default.

local DEBUG = true  --If you don't want to clog up your debug logs, change this to FALSE

-- 3D perlin1 for structure and central voids.
local SEEDDIFF1 = 3683023852
local OCTAVES1 = 6 -- 
local PERSISTENCE1 = 0.6 -- 
local SCALE1 = 256 -- 


-- 3D perlin4 for structure and central voids. 207 / 128 = golden ratio.
local SEEDDIFF4 = 1390930295
local OCTAVES4 = 6 -- 
local PERSISTENCE4 = 0.6 -- 
local SCALE4 = 207 -- 

-- 3D perlin2 for fissures.
local SEEDDIFF2 = 9292091389
local OCTAVES2 = 4 -- 
local PERSISTENCE2 = 0.6 -- 
local SCALE2 = 32 -- 

-- 2D perlin3 for y variation.
local SEEDDIFF3 = 6412875374
local OCTAVES3 = 3 -- 
local PERSISTENCE3 = 0.5 -- 
local SCALE3 = 256 -- 

-- Stuff.

skylands = {}

local yminq = 80 * math.floor((YMIN + 32) / 80) - 32 -- minp.y of bottom chunk layer.
local ymaxq = 80 * math.floor((YMAX + 32) / 80) - 32 -- minp.y of top chunk layer.


-- On generated function.

if ONGEN then
	minetest.register_on_generated(function(minp, maxp, seed)
		
		if minp.y >= yminq and minp.y <= ymaxq
		and minp.x >= XMIN and maxp.x <= XMAX
		and minp.z >= ZMIN and maxp.z <= ZMAX then
			local env = minetest.env
			local perlin1 = env:get_perlin(SEEDDIFF1 + minp.y * 92375, OCTAVES1, PERSISTENCE1, SCALE1)
			local perlin2 = env:get_perlin(SEEDDIFF2 + minp.y * 68568, OCTAVES2, PERSISTENCE2, SCALE2)
			local perlin3 = env:get_perlin(SEEDDIFF3 + minp.y * 16583, OCTAVES3, PERSISTENCE3, SCALE3)
			local perlin4 = env:get_perlin(SEEDDIFF4 + minp.y * 52948, OCTAVES4, PERSISTENCE4, SCALE4)
			local x0 = minp.x
			local y0 = minp.y
			local z0 = minp.z
			local x1 = maxp.x
			local y1 = maxp.y
			local z1 = maxp.z
			local midy = y0 + (y1 - y0) * VMID
			local rar = RARBOT + (y0 - yminq) / (ymaxq - yminq) * (RARTOP - RARBOT)
			local topgrad = TGRAD * (rar + 1)
			local botgrad = BGRAD * (rar + 1)
			
			
			for x = x0, x1 do -- for each plane do
			if DEBUG then
				print ("[skylands] "..x - x0.." ("..x0.." "..y0.." "..z0..")")
			end
			for z = z0, z1 do -- for each column do
				local noise3 = perlin3:get2d({x=x,y=z})
				local pmidy = midy + noise3 / 1.5 * VAMP
				
				for y = y0, y1 do -- for each node do
					
					local perlinB = env:get_perlin(SEEDDIFFB, OCTAVESB, PERSISTENCEB, SCALEB)
					
					if GEN_BIOMES == true then
						
						if perlinB:get2d({x=x,y=z}) > 0.65 then
							ISLTYPE = "desert"
						elseif perlinB:get2d({x=x,y=z}) < -0.65 then--see if it's a snow island
							ISLTYPE = "snow"
						elseif perlinB:get2d({x=x,y=z}) > -0.65 and  perlinB:get2d({x=x,y=z}) < -0.15 then--see if it's a volcanic island
							ISLTYPE = "volcano"
						else
							ISLTYPE = ""
						end
					end
					
					local offset = 0
					if y > pmidy then
						offset = ((y - pmidy) / topgrad) ^ 0.5
					else
						offset = ((pmidy - y) / botgrad) ^ 0.5
					end
					local noise1 = perlin1:get3d({x=x,y=y,z=z})
					local noise4 = perlin4:get3d({x=x,y=y,z=z})
					local noise1off = (noise1 + noise4) / 2 - offset - rar
					if noise1off > 0 and noise1off < VOID then -- if skyland
						local noise2 = perlin2:get3d({x=x,y=y,z=z})
						if math.abs(noise2) - noise1off * FISEXP + FISOFF > 0 then -- if no fissure
							if math.random(ORECHA) ~= 3 then
								if ISLTYPE == "desert" then
									env:add_node({x=x,y=y,z=z},{name="default:desert_stone"})
								elseif ISLTYPE == "volcano" then
									env:add_node({x=x,y=y,z=z},{name="default:obsidian"})
								else
									env:add_node({x=x,y=y,z=z},{name="default:stone"})
								end
							else
								--triple chance of diamond in volcano biomes
								if ISLTYPE == "volcano" then
									if math.random(DIACHA) == 4 then
										env:add_node({x=x,y=y,z=z},{name="default:stone_with_diamond"})
									elseif math.random(DIACHA) == 5 then
										env:add_node({x=x,y=y,z=z},{name="default:stone_with_diamond"})
									end
								end
								if math.random(DIACHA) == 3 then
									env:add_node({x=x,y=y,z=z},{name="default:stone_with_diamond"})
								elseif math.random(BMECHA) == 3 then
									env:add_node({x=x,y=y,z=z},{name="default:mese"})
								elseif math.random(MESCHA) == 3 then
									env:add_node({x=x,y=y,z=z},{name="default:stone_with_mese"})
								elseif math.random(GOLCHA) == 3 then
									if ISLTYPE == "volcano" then
										return
									end
									env:add_node({x=x,y=y,z=z},{name="default:stone_with_gold"})
								elseif math.random(COPCHA) == 3 then
									if ISLTYPE == "volcano" then
										return
									end
									env:add_node({x=x,y=y,z=z},{name="default:stone_with_copper"})
								elseif math.random(IROCHA) == 3 then
									env:add_node({x=x,y=y,z=z},{name="default:stone_with_iron"})
								else
									env:add_node({x=x,y=y,z=z},{name="default:stone_with_coal"})
								end
							end
						end
					end
				end
				
			end
			
			end
			if DEBUG then
				print ("[skylands] Surface ("..x0.." "..y0.." "..z0..")")
			end
			
			for x = x0, x1 do
			for z = z0, z1 do -- for each column do
				
				if GEN_BIOMES == true then
				--make a desert island?
					local perlinB = env:get_perlin(SEEDDIFFB, OCTAVESB, PERSISTENCEB, SCALEB)
					
					if perlinB:get2d({x=x,y=z}) > 0.65 then
						ISLTYPE = "desert"
					elseif perlinB:get2d({x=x,y=z}) < -0.65 then--see if it's a snow island
						ISLTYPE = "snow"
					elseif perlinB:get2d({x=x,y=z}) > -0.65 and  perlinB:get2d({x=x,y=z}) < -0.15 then--see if it's a volcanic island
						ISLTYPE = "volcano"
					else
						ISLTYPE = ""
					end
				end
				------
				local ground_y = nil
				for y = y1, y0, -1 do
					if env:get_node({x=x,y=y,z=z}).name ~= "air" then
						ground_y = y
						break
					end
				end
				if ground_y then
					if env:get_node({x=x,y=ground_y-1,z=z}).name ~= "air"
					and env:get_node({x=x,y=ground_y-2,z=z}).name ~= "air" then
					if env:get_node({x=x,y=ground_y-1,z=z}).name ~= "default:water_source"
					and env:get_node({x=x,y=ground_y-2,z=z}).name ~= "default:water_source" then
					if env:get_node({x=x,y=ground_y-1,z=z}).name ~= "default:lava_source"
					and env:get_node({x=x,y=ground_y-2,z=z}).name ~= "default:lava_source" then
						if ISLTYPE == "snow" then
							env:add_node({x=x,y=ground_y,z=z},{name="default:dirt_with_snow"})
						elseif ISLTYPE == "desert" then
							env:add_node({x=x,y=ground_y,z=z},{name="default:desert_sand"})
							if math.random(DRYCHA) == 3 then
								env:add_node({x=x,y=ground_y+1,z=z},{name="default:dry_shrub"})
							end
							if math.random(CACCHA) == 3 then
								--make the cactus 2 blocks high by default
								env:add_node({x=x,y=ground_y+1,z=z},{name="default:cactus"})
								env:add_node({x=x,y=ground_y+2,z=z},{name="default:cactus"})
								--potentially make it one block taller
								if math.random(4) == 3 then
									env:add_node({x=x,y=ground_y+3,z=z},{name="default:cactus"})
								end
							end
						else
							if ISLTYPE == "volcano" then
								env:add_node({x=x,y=ground_y,z=z},{name="default:gravel"})
							else
								env:add_node({x=x,y=ground_y,z=z},{name="default:dirt_with_grass"})
								if math.random(GRACHA) == 3 then
									env:add_node({x=x,y=ground_y+1,z=z},{name="default:grass_3"})
								end
								if math.random(JUNCHA) == 3 then
									env:add_node({x=x,y=ground_y+1,z=z},{name="default:junglegrass"})
								end
							end
							
							if GEN_WATER == true then
							--HERE IT IS
							--THE DREADED....
							--LAKE GENERATION CODE
							--PREPARE TO COMENT OUT IF IT'S TERRIBLE
							if math.random(WATCHA) == 3 then
								print ("[skylands] Attempting to create lake at ("..x.." "..ground_y.." "..z..")")
								local L_RAD = math.random(LAKE_MIN, LAKE_MAX)
								
								--figure out depth
								local L_DEP = L_RAD
								--proportion the height of the rim to the width of the pool
								local L_RIM = 1
								if L_RAD <= LAKE_MAX then
									L_RIM = 4
								end
								if L_RAD <= 15 then
									L_RIM = 3
								end
								if L_RAD <= 10 then
									L_RIM = 2
								end
								if L_RAD <= 5 then
									L_RIM = 1
								end
																		
								--store current position
								local HERE = {x=x,y=ground_y,z=z}
								--add ground in a hemispherical formation
								for x=-L_RAD-1,L_RAD+1 do
        						for y=-L_DEP-1,0 do
        						for z=-L_RAD-1,L_RAD+1 do
            						if x*x+y*y+z*z <= (L_RAD+1) * (L_RAD+1) + (L_RAD+1) then
                						local np={x=x+HERE.x,y=y+HERE.y,z=z+HERE.z}
                						
                						if ISLTYPE == "volcano" then
                							if( minetest.get_modpath("moreblocks") ~= nil ) then
                								env:add_node(np,{name="moreblocks:coal_stone"})
                							else
                								env:add_node(np,{name="default:stone"})
                							end
                						else
                							env:add_node(np,{name="default:dirt"})
                						end
                					end
            					end
        						end
        						end
        						--remove the 'lid'
        						for x=-L_RAD,L_RAD do
       							for y=-L_DEP,0 do
        						for z=-L_RAD,L_RAD do
        							if x*x+y*y+z*z <= (L_RAD) * (L_RAD) + (L_RAD)then
        								local np={x=x+HERE.x,y=y+HERE.y,z=z+HERE.z}
        								env:remove_node(np)
        							end
        						end
        						end
        						end
								--add water in a hemispherical formation
								for x=-L_RAD,L_RAD do
        						for y=-L_DEP,-L_RIM do
        						for z=-L_RAD,L_RAD do
            						if x*x+y*y+z*z <= (L_RAD) * (L_RAD) + (L_RAD) then
                						local np={x=x+HERE.x,y=y+HERE.y,z=z+HERE.z}
                						if DEBUG then
                							if ISLTYPE == "volcano" then
                								print ("[skylands] placed lava at ("..np.x..", "..np.y..", "..np.z..")")
                							else
                								print ("[skylands] placed water at ("..np.x..", "..np.y..", "..np.z..")")
                							end
                						end
                						if ISLTYPE == "volcano" then
                							env:add_node(np,{name="default:lava_source"})
                						else
                							env:add_node(np,{name="default:water_source"})
                						end
                					end
            					end
        						end
        						end
								--
								--
								--end
							end
							--END THE NIGHTMARE
							--REALLY.
							end
						end
						if env:get_node({x=x,y=ground_y-3,z=z}).name ~= "air"
						and env:get_node({x=x,y=ground_y-4,z=z}).name ~= "air" then
							if env:get_node({x=x,y=ground_y-3,z=z}).name ~= "default:water_source"
							and env:get_node({x=x,y=ground_y-4,z=z}).name ~= "default:water_source" then
								if ISLTYPE == "desert" then
									env:add_node({x=x,y=ground_y-1,z=z},{name="default:desert_sand"})
								else
									if ISLTYPE == "volcano" then
										if( minetest.get_modpath("moreblocks") ~= nil ) then
                							env:add_node({x=x,y=ground_y,z=z},{name="moreblocks:coal_stone"})
                						else
											env:add_node({x=x,y=ground_y,z=z},{name="default:gravel"})
										end
									else
										env:add_node({x=x,y=ground_y-1,z=z},{name="default:dirt"})
									end
								end
							end
						end
					end
					end
				end
				--nixz = nixz - 80 --Rewind
			end
			--nixz=nixz + 80 --fast forward
			end
		end
	end
	end)
end
