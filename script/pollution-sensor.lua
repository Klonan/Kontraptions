local UPDATE_INTERVAL = 60
local EXPECTED_MAX = 150
local script_data =
{
  pollution_sensors = {}
}

local pollution_sensor_created = function(event)
  local entity = event.source_entity
  if not (entity and entity.valid) then return end

  local unit_number = entity.unit_number
  local update_index = unit_number % UPDATE_INTERVAL
  local update_list = script_data.pollution_sensors[update_index]
  if not update_list then
    update_list = {}
    script_data.pollution_sensors[update_index] = update_list
  end
  update_list[unit_number] = entity
end

local triggers =
{
  ["pollution-sensor-created"] = pollution_sensor_created
}

local on_script_trigger_effect = function(event)
  local effect_id = event.effect_id
  local trigger = triggers[effect_id]
  if trigger then
    trigger(event)
  end
end

local ceil = math.ceil
local on_tick = function(event)
  local update_index = event.tick % UPDATE_INTERVAL
  local update_list = script_data.pollution_sensors[update_index]
  if not update_list then return end
  for unit_number, sensor in pairs (update_list) do
    if sensor.valid then
      sensor.energy = ceil(sensor.surface.get_pollution(sensor.position) / EXPECTED_MAX * 100) + (math.random() * 0.01)
    else
      update_list[unit_number] = nil
      if not next(update_list) then
        script_data.pollution_sensors[update_index] = nil
      end
    end
  end
end

local lib = {}

lib.events =
{
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.on_tick] = on_tick
}

lib.on_init = function()
  global.pollution_sensor = global.pollution_sensor or script_data
end

lib.on_load = function()
  script_data = global.pollution_sensor or script_data
end

return lib