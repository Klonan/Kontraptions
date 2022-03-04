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

local lib = {}

lib.events =
{
  [defines.events.on_tick] = on_tick,
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect
}

lib.on_init = function()
  global.circuit_network_transceivers = global.circuit_network_transceivers or script_data
end

lib.on_load = function()
  script_data = global.circuit_network_transceivers or script_data
end

return lib
