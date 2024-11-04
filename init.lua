minetest.register_node("barrier:barrier", {
    description = "Barrier",
    drawtype = "airlike",
    tiles = {""},
    alpha = 0,
    paramtype = "light",
    light_source = 0,
    use_texture_alpha = true,
    sunlight_propagates = true,
    walkable = true,
    pointable = false,
    buildable_to = true,
    drop = "",
    groups = {invisible = 1, cracky = 1, not_in_creative_inventory = 1},
    on_construct = function(pos) end,
    can_dig = function(pos, player)
        local wielded_item = player:get_wielded_item():get_name()
        return wielded_item == "barrier:barrier_item"
    end,
    on_blast = function() end
})

minetest.register_tool("barrier:barrier_item", {
    description = "Barrier",
    inventory_image = "barrier_barrier.png",
    liquids_pointable = true,
    tool_capabilities = {
    full_punch_interval = 0.9,
    max_drop_level=3,
    groupcaps={
        cracky = {times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=30, maxlevel=3},
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
        local node = minetest.get_node(pos)
        -- if the node is not air, return the itemstack
        if node.name ~= "air" then
            return itemstack
        end
        minetest.set_node(pos, {name = "barrier:barrier"})
        minetest.add_particle({
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
        minetest.add_particle({
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
	for _, player in ipairs(minetest.get_connected_players()) do
        local wielded_item = player:get_wielded_item():get_name()
        if wielded_item == "barrier:barrier_item" then
            local pos = player:get_pos()
            local radius = 10
            local nodes = minetest.find_nodes_in_area(
                {x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
                {x = pos.x + radius, y = pos.y + radius, z = pos.z + radius},
                {"barrier:barrier"}
            )
            show_barriers(nodes, player)
        end
	end
	minetest.after(1, cyclic_update)
end

minetest.after(1, cyclic_update)


