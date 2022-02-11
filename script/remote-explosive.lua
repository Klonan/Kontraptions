local UNPRIMED_UPDATE_INTERVAL = 100
local script_data =
{
  remote_explosives = {},
  unprimed_remote_explosives = {},
}

local direction_offsets =
{
  [defines.direction.north] = {x = 0, y = -1},
  [defines.direction.east] = {x = 1, y = 0},
  [defines.direction.south] = {x = 0, y = 1},
  [defines.direction.west] = {x = -1, y = 0},
}

local opposite_direction = function(direction)
  return (direction + defines.direction.south) % (defines.direction.south * 2)
end

local get_position = function(entity, opposite)
  local position = entity.position
  local direction = entity.direction
  if opposite then
    direction = opposite_direction(direction)
  end
  local offset = direction_offsets[direction]
  position.x = position.x + offset.x
  position.y = position.y + offset.y
  return position
end

local add_to_unprimed_update = function(unit_number, remote_explosive)
  local bucket_index = unit_number % UNPRIMED_UPDATE_INTERVAL
  local unprimed_bucket = script_data.unprimed_remote_explosives[bucket_index]
  if not unprimed_bucket then
    unprimed_bucket = {}
    script_data.unprimed_remote_explosives[bucket_index] = unprimed_bucket
  end
  unprimed_bucket[unit_number] = remote_explosive
end


local remote_explosive_created = function(event)
  --game.print("Remote explosive created")
  local entity = event.source_entity
  if not (entity and entity.valid) then return end

  entity.active = false
  entity.rotatable = false
  script.register_on_entity_destroyed(entity)

  local turret = entity.surface.create_entity
  {
    name = "remote-explosive-turret",
    position = get_position(entity),
    force = "enemy",
    direction = opposite_direction(entity.direction)
  }
  turret.destructible = false
  turret.active = false
  turret.rotatable = false
  turret.minable = false

  local pipe = entity.surface.create_entity
  {
    name = "invisible-pump",
    position = get_position(entity, true),
    force = entity.force,
    direction = entity.direction
  }

  pipe.destructible = false
  pipe.rotatable = false
  pipe.active = false
  pipe.minable = false

  local remote_explosive =
  {
    pump = entity,
    turret = turret,
    pipe = pipe
  }

  local unit_number = entity.unit_number

  script_data.remote_explosives[unit_number] = remote_explosive
  add_to_unprimed_update(unit_number, remote_explosive)

end

local is_pump_connected_to_circuit_network = function(pump)
  local control_behavior = pump.get_control_behavior()
  if not control_behavior then return end

  if control_behavior.connect_to_logistic_network then
    return true
  end

  if control_behavior.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.pump) then
    return true
  end

  if control_behavior.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.pump) then
    return true
  end
end

local unprime_explosive = function(unit_number)
  local remote_explosive = script_data.remote_explosives[unit_number]
  add_to_unprimed_update(unit_number, remote_explosive)
  local turret = remote_explosive.turret
  turret.clear_fluid_inside()
  turret.active = false

  local pipe = remote_explosive.pipe
  pipe.clear_fluid_inside()
  pipe.active = false

  local pump = remote_explosive.pump
  pump.clear_fluid_inside()
  pump.active = false

end

local remote_explosive_triggered = function(event)
  --game.print("Remote explosive triggered")
  local pump = event.target_entity
  if not (pump and pump.valid) then return end

  if not is_pump_connected_to_circuit_network(pump) then
    unprime_explosive(pump.unit_number)
    return
  end

  pump.die()

end

local prime_explosive = function(remote_explosive)
  --game.print("Explosive primed")
  local pipe = remote_explosive.pipe
  pipe.fluidbox[1] = {name = "water", amount = 1}
  pipe.active = true

  local turret = remote_explosive.turret
  turret.active = true

  local pump = remote_explosive.pump
  pump.active = true
end

local unprimed_update = function(unit_number)
  --game.print("Unprimed update")
  -- return true if it should be removed from the update list
  local remote_explosive = script_data.remote_explosives[unit_number]
  if not remote_explosive then return true end

  local pump = remote_explosive.pump
  if not is_pump_connected_to_circuit_network(pump) then
    --game.print("Not connected")
    return
  end

  local control_behavior = pump.get_control_behavior()
  if not control_behavior then
    --game.print("No control behavior")
    return
  end

  prime_explosive(remote_explosive)
  return true

end

local triggers =
{
  ["remote-explosive-created"] = remote_explosive_created,
  ["remote-explosive-triggered"] = remote_explosive_triggered
}

local on_script_trigger_effect = function(event)
  local effect_id = event.effect_id
  local trigger = triggers[effect_id]
  if trigger then
    trigger(event)
  end
end

local on_tick = function(event)
  local bucket_index = event.tick % UNPRIMED_UPDATE_INTERVAL
  local bucket = script_data.unprimed_remote_explosives[bucket_index]
  if not bucket then return end
  for unit_number, bool in pairs(bucket) do
    if unprimed_update(unit_number) then
      bucket[unit_number] = nil
    end
  end
  if not next(bucket) then
    script_data.unprimed_remote_explosives[bucket_index] = nil
  end
end

local on_entity_destroyed = function(event)
  local unit_number = event.unit_number
  local explosive = script_data.remote_explosives[unit_number]
  if not explosive then return end

  local pipe = explosive.pipe
  if (pipe and pipe.valid) then
    pipe.destroy()
  end
  local turret = explosive.turret
  if (turret and turret.valid) then
    turret.destroy()
  end
  script_data.remote_explosives[unit_number] = nil
end

local lib = {}

lib.events =
{
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.on_player_rotated_entity] = on_player_rotated_entity,
  [defines.events.on_entity_destroyed] = on_entity_destroyed,
  [defines.events.on_tick] = on_tick
}

lib.on_init = function()
  global.remote_explosive = global.remote_explosive or script_data
end

lib.on_load = function()
  script_data = global.remote_explosive or script_data
end

return lib