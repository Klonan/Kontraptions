local UPDATE_INTERVAL = 269

local script_data =
{
  transceivers = {},
  channels = {},
  update_schedule = {}
}

local add_to_update_schedule = function(unit_number)
  local update_index = unit_number % UPDATE_INTERVAL
  local update_list = script_data.update_schedule[update_index]
  if not update_list then
    update_list = {}
    script_data.update_schedule[update_index] = update_list
  end
  update_list[unit_number] = true
end

local transceiver_created = function(event)
  local entity = event.source_entity
  if not (entity and entity.valid) then return end

  game.print("HEUK")

  local electric_source = entity.surface.create_entity
  {
    name = "circuit-network-transciever-electric-source",
    position = entity.position,
    force = entity.force
  }
  electric_source.destructible = false
  electric_source.minable = false

  local transceiver_data =
  {
    entity = entity,
    channel = "",
    electric_source = electric_source,
    connected = false
  }
  script_data.transceivers[entity.unit_number] = transceiver_data
  add_to_update_schedule(entity.unit_number)
  script.register_on_entity_destroyed(entity)
end

local triggers =
{
  ["circuit-network-transceiver-created"] = transceiver_created
}

local on_script_trigger_effect = function(event)
  local trigger = triggers[event.effect_id]
  if trigger then
    trigger(event)
  end
end

local update_transceiver = function(unit_number)
  local transceiver_data = script_data.transceivers[unit_number]
  if not transceiver_data then return true end
  local entity = transceiver_data.entity
  if not (entity and entity.valid) then return true end
end

local on_tick = function(event)
  local update_index = event.tick % UPDATE_INTERVAL
  local update_list = script_data.update_schedule[update_index]
  if not update_list then return end

  for unit_number, bool in pairs(update_list) do
    if update_transceiver(unit_number) then
      update_list[unit_number] = nil
      if not next(update_list) then
        script_data.update_schedule[update_index] = nil
      end
    end
  end

end

local on_robot_built_entity = function(event)
  -- Fires AFTER the script creation trigger.
end


local transceiver_opened = function(entity, player)

  local transceiver_data = script_data.transceivers[unit_number]
  local relative_gui = player.gui.relative.transceiver_gui
  if not relative_gui then
    relative_gui = player.gui.relative.add
    {
      type = "frame",
      name = "transceiver_gui",
      caption = "Transceiver settings",
      direction = "vertical",
      anchor =
      {
        gui = defines.relative_gui_type.storage_tank_gui,
        name = entity.name,
        position = defines.relative_gui_position.bottom
      }
    }
  end
  relative_gui.clear()
  relative_gui.style.horizontally_stretchable = false
  local inner = relative_gui.add
  {
    type = "frame",
    direction = "vertical",
    style = "entity_frame"
  }
end

local on_gui_opened = function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if entity.name ~= "circuit-network-transceiver" then return end
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end
  transceiver_opened(entity, player)
end

local lib = {}

lib.events =
{
  [defines.events.on_gui_opened] = on_gui_opened,
  [defines.events.on_tick] = on_tick,
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.on_robot_built_entity] = on_robot_built_entity,
}

lib.on_init = function()
  global.circuit_network_transceivers = global.circuit_network_transceivers or script_data
end

lib.on_load = function()
  script_data = global.circuit_network_transceivers or script_data
end

return lib
