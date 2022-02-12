local UPDATE_INTERVAL = (25000 * 0.2) / 100
local script_data =
{
  daylight_sensors = {}
}

local daylight_sensor_created = function(event)
  local entity = event.source_entity
  if not (entity and entity.valid) then return end

  local surface_index = entity.surface.index
  local surface_list = script_data.daylight_sensors[surface_index]
  if not surface_list then
    surface_list = {}
    script_data.daylight_sensors[surface_index] = surface_list
  end
  surface_list[entity.unit_number] = entity
end

local triggers =
{
  ["daylight-sensor-created"] = daylight_sensor_created
}

local on_script_trigger_effect = function(event)
  local effect_id = event.effect_id
  local trigger = triggers[effect_id]
  if trigger then
    trigger(event)
  end
end
local floor = math.floor
local get_daylight = function(surface)
  local daytime = surface.daytime
  if daytime < surface.dusk then return 100 end
  if daytime < surface.evening then
    return floor((1 - ((daytime - surface.dusk) / (surface.evening - surface.dusk))) * 100)
  end
  if daytime < surface.morning then
    return 0
  end
  if daytime < surface.dawn then
    return floor(((daytime - surface.morning) / (surface.dawn - surface.morning)) * 100)
  end
  return 100
end

local on_tick = function(event)
  if event.tick % UPDATE_INTERVAL ~= 0 then return end
  local surfaces = game.surfaces
  for surface_id, sensors in pairs (script_data.daylight_sensors) do
    local surface = surfaces[surface_id]
    if not surface and surface.valid then
      script_data.daylight_sensors[surface_id] = nil
      return
    end
    local surface_daylight = get_daylight(surface)
    for unit_number, sensor in pairs (sensors) do
      if sensor.valid then
        sensor.energy = surface_daylight
      else
        sensors[unit_number] = nil
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
  global.daylight_sensor = global.daylight_sensor or script_data
end

lib.on_load = function()
  script_data = global.daylight_sensor or script_data
end

return lib