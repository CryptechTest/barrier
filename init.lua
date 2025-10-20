core.register_node("barrier:barrier", {
    description = "Barrier",
    drawtype = "airlike",
    tiles = {""},
    paramtype = "light",
    light_source = 0,
    use_texture_alpha = "clip",
    sunlight_propagates = true,
    walkable = true,
    pointable = false,
    buildable_to = true,
    drop = "",
    groups = {
        invisible = 1,
        level = 1,
        not_in_creative_inventory = 1
    },
    on_construct = function(pos) end,
    can_dig = function(pos, player)
        local wielded_item = player:get_wielded_item():get_name()
        return wielded_item == "barrier:barrier_item"
    end,
    sounds = {
        footstep = {name = "", gain = 0},
        dig = {name = "default_dig_cracky", gain = 1},
        dug = {name = "default_break_glass", gain = 1},
        place = {name = "", gain = 0},
    },
    on_blast = function() end
})

core.register_tool("barrier:barrier_item", {
    description = "Barrier",
    inventory_image = "barrier_barrier.png",
    liquids_pointable = true,
    tool_capabilities = {
    full_punch_interval = 0.9,
    groupcaps={
        invisible = {times={[1]=0.25}, uses=0, maxlevel=1},
        cracky = {times={[0]=5.0}, uses=0, maxlevel=0},
        snappy = {times={[0]=5.0}, uses=0, maxlevel=0},
        crumbly = {times={[0]=5.0}, uses=0, maxlevel=0},
        choppy = {times={[0]=5.0}, uses=0, maxlevel=0},
        fleshy = {times={[0]=5.0}, uses=0, maxlevel=0},
        oddly_breakable_by_hand = {times={[0]=5.0}, uses=0, maxlevel=0},
    },
    },
    pointabilities = {
        nodes = {
            ["barrier:barrier"] = true,
        }
    },
    on_place = function(itemstack, placer, pointed_thing)
        -- if the pointed_thing is not a node, return the itemstack
        if pointed_thing.type ~= "node" then
            return itemstack
        end
        local pos = pointed_thing.above
        local node = core.get_node(pos)
        -- if the node is not air, return the itemstack
        if node.name ~= "air" then
            return itemstack
        end
        core.set_node(pos, {name = "barrier:barrier"})
        core.add_particle({
            pos = pos,
            velocity = {x = 0, y = 0, z = 0},
            acceleration = {x = 0, y = 0, z = 0},
            expirationtime = 1.05,
            size = 8,
            collisiondetection = false,
            vertical = false,
            texture = "barrier_barrier.png",
            glow = 5,
            playername = placer:get_player_name()
        })
        return itemstack
    end,
})

local function show_barriers(nodes, player)
    if not nodes or #nodes == 0 then return end
    for n = 1, #nodes do
        core.add_particle({
            pos = nodes[n],
            velocity = {x = 0, y = 0, z = 0},
            acceleration = {x = 0, y = 0, z = 0},
            expirationtime = 1.05,
            size = 8,
            collisiondetection = false,
            vertical = false,
            texture = "barrier_barrier.png",
            glow = 5,
            playername = player:get_player_name()
        })
    end
end

local function cyclic_update()
	for _, player in ipairs(core.get_connected_players()) do
        local wielded_item = player:get_wielded_item():get_name()
        if wielded_item == "barrier:barrier_item" then
            local pos = player:get_pos()
            local radius = 10
            local nodes = core.find_nodes_in_area(
                {x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
                {x = pos.x + radius, y = pos.y + radius, z = pos.z + radius},
                {"barrier:barrier"}
            )
            show_barriers(nodes, player)
        end
	end
	core.after(1, cyclic_update)
end

core.after(1, cyclic_update)


