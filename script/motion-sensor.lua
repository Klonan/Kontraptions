local MOTION_SENSOR_TIMEOUT = 60

local script_data =
{
  sensors = {},
  event_block = false,
  tick_updates = {}
}

--[[

on_script_trigger_effect

Called when a script trigger effect is triggered.

effect_id
:: string

    The effect_id specified in the trigger effect.
surface_index
:: uint

    The surface the effect happened on.
source_position
:: Position
Optional
source_entity
:: LuaEntity
Optional
target_position
:: Position
Optional
target_entity
:: LuaEntity
Optional
name
:: defines.events

    Identifier of the event
tick
:: uint

    Tick the event was generated.


]]

local init_pair = function(turret, combinator)
  turret.destructible = false

  local control_behavior = combinator.get_or_create_control_behavior()
  control_behavior.enabled = false

  local motion_sensor_data =
  {
    turret = turret,
    combinator = combinator,
    control_behavior = control_behavior,
    tick_of_last_trigger = 0
  }

  script_data.sensors[turret.unit_number] = motion_sensor_data
  script_data.sensors[combinator.unit_number] = motion_sensor_data

  script.register_on_entity_destroyed(turret)
  script.register_on_entity_destroyed(combinator)
end

local on_enemy_motion_sensor_created = function(event)
  --game.print("Motion sensor created")
  local turret = event.source_entity
  local combinator = turret.surface.create_entity
  {
    name = "enemy-invisible-combinator",
    position = turret.position,
    force = turret.force,
    direction = turret.direction
  }
  init_pair(turret, combinator)
end

local on_friendly_motion_sensor_created = function(event)
  --game.print("Friendly otion sensor created")
  local turret = event.source_entity
  local combinator = turret.surface.create_entity
  {
    name = "friendly-invisible-combinator",
    position = turret.position,
    force = turret.force,
    direction = turret.direction
  }
  init_pair(turret, combinator)
  turret.force = "enemy"
end

local add_to_tick_updates = function(unit_number, tick)
  local tick_of_action = tick + MOTION_SENSOR_TIMEOUT + 1
  local tick_updates = script_data.tick_updates[tick_of_action]
  if not tick_updates then
    tick_updates = {}
    script_data.tick_updates[tick_of_action] = tick_updates
  end
  tick_updates[unit_number] = true
end

local on_motion_sensor_triggered = function(event)
  --game.print("Motion sensor triggered")
  local turret = event.source_entity
  if not turret then return end
  local unit_number = turret.unit_number
  local motion_sensor_data = script_data.sensors[unit_number]
  local control_behavior = motion_sensor_data.control_behavior
  control_behavior.enabled = true
  motion_sensor_data.tick_of_last_trigger = event.tick
  add_to_tick_updates(unit_number, event.tick)
end

local on_enemy_motion_sensor_combinator_created = function(event)
  --game.print("Enemy motion sensor combinator created")

  local combinator = event.source_entity

  local turret = combinator.surface.create_entity
  {
    name = "enemy-motion-sensor",
    position = combinator.position,
    force = combinator.force,
    direction = combinator.direction
  }
  init_pair(turret, combinator)
end

local on_friendly_motion_sensor_combinator_created = function(event)
  --game.print("Friendly motion sensor combinator created")

  local combinator = event.source_entity

  local turret = combinator.surface.create_entity
  {
    name = "friendly-motion-sensor",
    position = combinator.position,
    force = "enemy",
    direction = combinator.direction
  }
  init_pair(turret, combinator)
end

local triggers =
{
  ["motion-sensor-triggered"] = on_motion_sensor_triggered,
  ["enemy-motion-sensor-created"] = on_enemy_motion_sensor_created,
  ["enemy-motion-sensor-combinator-created"] = on_enemy_motion_sensor_combinator_created,
  ["friendly-motion-sensor-created"] = on_friendly_motion_sensor_created,
  ["friendly-motion-sensor-combinator-created"] = on_friendly_motion_sensor_combinator_created
}

local on_script_trigger_effect = function(event)
  if script_data.event_block then return end

  script_data.event_block = true

  local effect_id = event.effect_id
  local trigger = triggers[effect_id]
  if trigger then
    trigger(event)
  end

  script_data.event_block = false
end

local on_player_rotated_entity = function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end

  local motion_sensor_data = script_data.sensors[entity.unit_number]
  if not motion_sensor_data then return end

  local other = (entity ~= motion_sensor_data.turret and motion_sensor_data.turret) or motion_sensor_data.combinator
  other.direction = entity.direction

end

local update = function(unit_number, tick)
  local motion_sensor_data = script_data.sensors[unit_number]
  if not motion_sensor_data then return end

  if motion_sensor_data.tick_of_last_trigger + MOTION_SENSOR_TIMEOUT < tick then
    motion_sensor_data.control_behavior.enabled = false
    motion_sensor_data.tick_of_last_trigger = 0
  end

end

local clear_motion_sensor_data = function(unit_number)
  --game.print("Motion sensor destroyed")
  if not unit_number then return end
  local motion_sensor_data = script_data.sensors[unit_number]
  if not motion_sensor_data then return end

  local turret = motion_sensor_data.turret
  local combinator = motion_sensor_data.combinator

  local other_unit_number

  if turret.valid then
    other_unit_number = turret.unit_number
    turret.destroy()
  end

  if combinator.valid then
    other_unit_number = combinator.unit_number
    combinator.destroy()
  end

  script_data.sensors[unit_number] = nil
  if other_unit_number then
    script_data.sensors[other_unit_number] = nil
  end

end

local on_tick = function(event)
  local tick = event.tick
  local tick_updates = script_data.tick_updates[tick]
  if not tick_updates then return end
  for unit_number, bool in pairs (tick_updates) do
    update(unit_number, tick)
  end
  script_data.tick_updates[event.tick] = nil
end

local on_entity_destroyed = function(event)
  clear_motion_sensor_data(event.unit_number)
end

local lib = {}

lib.events =
{
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.on_player_rotated_entity] = on_player_rotated_entity,
  [defines.events.on_entity_destroyed] = on_entity_destroyed,
  [defines.events.on_tick] = on_tick
}

lib.on_load = function()
  script_data = global.motion_sensor or script_data
end

lib.on_init = function()
  global.motion_sensor = global.motion_sensor or script_data
end

return lib