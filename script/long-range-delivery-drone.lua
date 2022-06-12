local DEPOT_UPDATE_INTERVAL = 30
local DRONE_MAX_UPDATE_INTERVAL = 300
local DRONE_SPEED = 0.5
local DRONE_NAME = "long-range-delivery-drone"
local MAX_DELIVERY_STACKS = 5
local MIN_DELIVERY_STACKS = 1
local script_data =
{
  request_depots = {},
  depots = {},
  drones = {},
  drone_update_schedule = {}
}

local ceil = math.ceil
local floor = math.floor
local min = math.min
local atan2 = math.atan2
local tau = 2 * math.pi

local distance_squared = function(a, b)
  local dx = a.x - b.x
  local dy = a.y - b.y
  return dx * dx + dy * dy
end

local stack_sizes_cache = {}
local get_stack_size = function(item_name)
  local stack_size = stack_sizes_cache[item_name]
  if not stack_size then
    stack_size = game.item_prototypes[item_name].stack_size
    stack_sizes_cache[item_name] = stack_size
  end
  return stack_size
end

local add_to_depots = function(self, list)
  local force_name = self.entity.force.name
  local force_depots = list[force_name]
  if not force_depots then
    force_depots = {}
    list[force_name] = force_depots
  end

  local surface_name = self.entity.surface.name
  local surface_depots = force_depots[surface_name]
  if not surface_depots then
    surface_depots = {}
    force_depots[surface_name] = surface_depots
  end

  surface_depots[self.unit_number] = self
end

get_depots = function(surface, force, list)
  local force_depots = list[force.name]
  return force_depots and force_depots[surface.name]
end

local entity_say = function(entity, text, tint)
  if entity.valid then
    entity.surface.create_entity
    {
      name = "flying-text",
      position = entity.position,
      text = text,
      color = tint
    }
  end
end

local Drone = {}
Drone.metatable = {__index = Drone}
Drone.new = function(entity)
  local self =
  {
    entity = entity,
    unit_number = entity.unit_number,
    scheduled = {},
    inventory = entity.get_inventory(defines.inventory.car_trunk),
  }
  script.register_on_entity_destroyed(entity)
  Drone.load(self)
  script_data.drones[self.unit_number] = self
  return self
end

Drone.say = function(self, text, tint)
  entity_say(self.entity, text, tint)
end

Drone.load = function(self)
  setmetatable(self, Drone.metatable)
end

Drone.get_orientation_to_position = function(self, position)
  local origin = self.entity.position
  local dx = position.x - origin.x
  local dy = position.y - origin.y
  local orientation = (atan2(dy, dx) / tau) + 0.25
  if orientation < 0 then
    orientation = orientation + 1
  elseif orientation > 1 then
    orientation = orientation - 1
  end
  return orientation
end

Drone.get_distance = function(self, position)
  local origin = self.entity.position
  local dx = position.x - origin.x
  local dy = position.y - origin.y
  return (dx * dx + dy * dy) ^ 0.5
end

Drone.get_time_to_next_update = function(self)
  local distance = self:get_distance(self.delivery_target.position)
  local time = distance / DRONE_SPEED
  local ticks = floor(time * 0.5)
  if ticks < 1 then
    return 1
  end
  return min(ticks, DRONE_MAX_UPDATE_INTERVAL)
end

local add_to_drone_update_schedule = function(drone, tick)
  local scheduled = script_data.drone_update_schedule
  local scheduled_drone = scheduled[tick]
  if not scheduled_drone then
    scheduled_drone = {}
    scheduled[tick] = scheduled_drone
  end
  scheduled_drone[drone.unit_number] = true
end

Drone.deliver_to_target = function(self)
  --self:say("DONE")
  self.entity.speed = 0
  local target = self.delivery_target
  local source_inventory = self.inventory
  local source_scheduled = self.scheduled
  local target_inventory = target.inventory
  local target_scheduled = target.scheduled
  for name, count in pairs(source_scheduled) do
    local removed = source_inventory.remove({name = name, count = count})
    if removed > 0 then
      target_inventory.insert({name = name, count = removed})
    end
    source_scheduled[name] = nil
    if target_scheduled[name] then
      target_scheduled[name] = target_scheduled[name] - count
      if target_scheduled[name] <= 0 then
        target_scheduled[name] = nil
      end
    end
  end
  script_data.drones[self.unit_number] = nil
  self.entity.destroy()
end

Drone.cleanup = function(self)
  if self.delivery_target then
    local source_scheduled = self.scheduled
    local target_scheduled = self.delivery_target.scheduled
    for name, count in pairs(source_scheduled) do
      source_scheduled[name] = nil
      target_scheduled[name] = (target_scheduled[name] or count) - count
      if target_scheduled[name] <= 0 then
        target_scheduled[name] = nil
      end
    end
  end
end

Drone.update = function(self)

  if not self.entity.valid then
    self:cleanup()
    return true
  end

  local target = self.delivery_target
  if not target then
    error("NO target?")
  end
  if not target.entity.valid then
    script_data.drones[self.unit_number] = nil
    self.entity.die()
    return
  end
  --self:say("HI")

  if self:get_distance(target.position) < 0.5 then
    self:deliver_to_target()
    return
  end

  self.entity.orientation = self:get_orientation_to_position(target.position)
  self.entity.speed = DRONE_SPEED
  add_to_drone_update_schedule(self, game.tick + self:get_time_to_next_update())
end

local Depot = {}
Depot.metatable = {__index = Depot}
Depot.new = function(entity)
  local self =
  {
    entity = entity,
    unit_number = entity.unit_number,
    position = entity.position,
    scheduled = {},
    inventory = entity.get_inventory(defines.inventory.chest)
  }
  script.register_on_entity_destroyed(entity)
  Depot.load(self)
  add_to_depots(self, script_data.depots)
  return self
end

Depot.load = function(self)
  setmetatable(self, Depot.metatable)
end

Depot.say = function(self, text)
  entity_say(self.entity, text, {r = 0, g = 1, b = 1})
end

Depot.get_available_capacity = function(self, item_name)
  local stacks = MAX_DELIVERY_STACKS
  for name, count in pairs(self.scheduled) do
    if name ~= item_name then
      stacks = stacks - ceil(count / get_stack_size(name))
    end
  end
  return floor(stacks * (get_stack_size(item_name)) - (self.scheduled[item_name] or 0))
end

Depot.update_logistic_filters = function(self)
  local slot_index = 1

  if next(self.scheduled) then
    self.entity.set_request_slot({name = DRONE_NAME, count = 1}, slot_index)
    slot_index = slot_index + 1
    for name, count in pairs(self.scheduled) do
      self.entity.set_request_slot({name = name, count = count}, slot_index)
      slot_index = slot_index + 1
    end
  end

  for i = slot_index, self.entity.request_slot_count do
    self.entity.clear_request_slot(i)
  end
end

Depot.delivery_requested = function(self, request_depot, item_name, item_count)
  if (self.delivery_target and self.delivery_target ~= request_depot) then
    error("Trying to schedule a delivery to another target")
  end

  if not self.delivery_target then
    self.delivery_target = request_depot
  end

  item_count = min(item_count, self:get_available_capacity(item_name))

  local scheduled = self.scheduled
  scheduled[item_name] = (scheduled[item_name] or 0) + item_count
  self:update_logistic_filters()
  return item_count
end


Depot.can_handle_request = function(self, request_depot)
  if self.delivery_target and self.delivery_target ~= request_depot then
    return false
  end

  local inventory_count = self:get_inventory_count(DRONE_NAME)
  if inventory_count > 0 then
    return true
  end

  local network_count = self:get_network_count(DRONE_NAME)
  if network_count > 0 then
    return true
  end

  return false
end

Depot.get_inventory_count = function(self, item_name)
  return self.inventory.get_item_count(item_name) - (self.scheduled[item_name] or 0)
end

Depot.get_network_count = function(self, item_name)
  local network = self.entity.logistic_network
  return (network and network.get_item_count(item_name)) or 0
end

Depot.transfer_package = function(self, drone)

  local source_inventory = self.inventory
  local source_scheduled = self.scheduled
  local drone_inventory = drone.inventory
  local drone_scheduled = drone.scheduled
  for name, count in pairs(source_scheduled) do
    local removed = source_inventory.remove({name = name, count = count})
    if removed > 0 then
      drone_inventory.insert({name = name, count = removed})
    end
    source_scheduled[name] = nil
    drone_scheduled[name] = count
  end
  self:update_logistic_filters()

end

Depot.send_drone = function(self)

  local target = self.delivery_target
  if not target then
    error("No target?")
  end

  local removed = self.inventory.remove({name = DRONE_NAME, count = 1})
  if removed == 0 then
    return
  end

  local entity = self.entity.surface.create_entity
  {
    name = DRONE_NAME,
    position = self.position,
    force = self.entity.force
  }

  local drone = Drone.new(entity)
  self:transfer_package(drone)

  drone.delivery_target = target
  self.delivery_target = nil

  drone:update()

end

Depot.cleanup = function(self)

  if self.delivery_target then
    local source_scheduled = self.scheduled
    local target_scheduled = self.delivery_target.scheduled
    for name, count in pairs(source_scheduled) do
      target_scheduled[name] = (target_scheduled[name] or count) - count
      if target_scheduled[name] <= 0 then
        target_scheduled[name] = nil
      end
      source_scheduled[name] = nil
    end
  end
end

Depot.update = function(self)
  if not self.entity.valid then
    self:cleanup()
    return true
  end
  --self:say("Hello")
  if not self.delivery_target then
    return
  end
  if not self.delivery_target.entity.valid then
    self.delivery_target = nil
    local scheduled = self.scheduled
    for name, count in pairs(scheduled) do
      scheduled[name] = nil
    end
    self:update_logistic_filters()
    return
  end
  local scheduled = self.scheduled
  local inventory = self.inventory
  local all_fulfilled = true
  for name, count in pairs(self.scheduled) do
    local has_count = inventory.get_item_count(name)
    if has_count < count then
      all_fulfilled = false
      break
    end
  end
  if all_fulfilled then
    self:send_drone()
  end
  --self:say("All fulfilled! Send it!")

end

local Request_depot = {}
Request_depot.metatable = {__index = Request_depot}

Request_depot.new = function(entity)
  local self =
  {
    entity = entity,
    unit_number = entity.unit_number,
    position = entity.position,
    scheduled = {},
    inventory = entity.get_inventory(defines.inventory.chest)
  }
  script.register_on_entity_destroyed(entity)
  Request_depot.load(self)
  add_to_depots(self, script_data.request_depots)
  return self
end

Request_depot.load = function(self)
  setmetatable(self, Request_depot.metatable)
end

Request_depot.say = function(self, text)
  entity_say(self.entity, text, {r = 1, g = 0.5, b = 0})
end

Request_depot.get_closest = function(self, depots)
  local closest_depot = nil
  local closest_distance = math.huge
  local position = self.position
  for k, depot in pairs(depots) do
    local distance = distance_squared(position, depot.position)
    if distance < closest_distance then
      closest_depot = depot
      closest_distance = distance
    end
  end
  return closest_depot
end

local table_insert = table.insert
Request_depot.try_to_schedule_delivery = function(self, item_name, item_count)
  local depots = get_depots(self.entity.surface, self.entity.force, script_data.depots)
  if not depots then return end


  --self:say("Trying to schedule: " .. item_name .. " " .. item_count)

  local stack_size = get_stack_size(item_name)

  local request_count = min(item_count, stack_size * MAX_DELIVERY_STACKS)

  local depots_with_item = {}
  local depots_that_can_request_item = {}
  local depots_that_can_request_some_items = {}

  for k, depot in pairs (depots) do
    if depot:can_handle_request(self) then
      local capacity = depot:get_available_capacity(item_name)
      --depot:say("              "..capacity)
      if capacity >= stack_size * MIN_DELIVERY_STACKS then
        local inventory_count = depot:get_inventory_count(item_name)
        if inventory_count >= request_count then
          table_insert(depots_with_item, depot)
        else
          local network_count = depot:get_network_count(item_name)
          if network_count >= request_count then
            table_insert(depots_that_can_request_item, depot)
          elseif network_count >= stack_size * MIN_DELIVERY_STACKS then
            table_insert(depots_that_can_request_some_items, depot)
          end
        end
      end
    end
  end

  local closest = self:get_closest(depots_with_item) or self:get_closest(depots_that_can_request_item) or self:get_closest(depots_that_can_request_some_items)
  if not closest then
    return
  end

  local scheduled_count = closest:delivery_requested(self, item_name, item_count)

  local scheduled = self.scheduled
  scheduled[item_name] = (scheduled[item_name] or 0) + scheduled_count

end

Request_depot.update = function(self)
  local entity = self.entity
  if not entity.valid then
    return
  end
  --self:say("Hello")
  local point = entity.get_logistic_point()
  if not point then
    return
  end


  local inventory = self.inventory
  local scheduled = self.scheduled
  --self:say(serpent.block(scheduled))
  for slot_index = 1, entity.request_slot_count do
    local request = entity.get_request_slot(slot_index)
    if request then
      local name = request.name
      local scheduled_count = scheduled[name] or 0
      local container_count = inventory.get_item_count(name)
      local needed = request.count - (container_count + scheduled_count)
      if needed > 0 then
        self:try_to_schedule_delivery(name, needed)
      end
    end
  end

end

local depot_created = function(event)
  --game.print("Depot created")
  local entity = event.source_entity
  if not (entity and entity.valid) then
    return
  end
  local depot = Depot.new(entity)
  depot:say("Hello")
end

local request_depot_created = function(event)
  --game.print("Request depot created")
  local entity = event.source_entity
  if not (entity and entity.valid) then
    return
  end
  local depot = Request_depot.new(entity)
  depot:say("Hello")
end

local triggers =
{
  ["long-range-delivery-drone-depot-created"] = depot_created,
  ["long-range-delivery-drone-request-depot-created"] = request_depot_created,
}

local on_script_trigger_effect = function(event)
  local effect_id = event.effect_id
  local trigger = triggers[effect_id]
  if trigger then
    trigger(event)
  end
end

local update_depots = function(tick)
  if tick % DEPOT_UPDATE_INTERVAL ~= 0 then return end

  for force_name, force_depots in pairs(script_data.depots) do
    for surface_name, surface_depots in pairs(force_depots) do
      for unit_number, depot in pairs(surface_depots) do
        if depot:update() then
          surface_depots[unit_number] = nil
        end
      end
    end
  end

  for force_name, force_depots in pairs(script_data.request_depots) do
    for surface_name, surface_depots in pairs(force_depots) do
      for unit_number, depot in pairs(surface_depots) do
        if depot:update() then
          surface_depots[unit_number] = nil
        end
      end
    end
  end
end

local update_drones = function(tick)

  local drones_to_update = script_data.drone_update_schedule[tick]
  if not drones_to_update then return end
  local drones = script_data.drones
  for unit_number, bool in pairs (drones_to_update) do
    local drone = drones[unit_number]
    if drone then
      if drone:update() then
        drones[unit_number] = nil
      end
    end
  end
  script_data.drone_update_schedule[tick] = nil
end

local on_tick = function(event)
  update_depots(event.tick)
  update_drones(event.tick)
end

local lib = {}

lib.events =
{
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.on_tick] = on_tick
}

lib.on_init = function()
  global.long_range_delivery_drone = global.long_range_delivery_drone or script_data
end

lib.on_load = function()
  script_data = global.long_range_delivery_drone or script_data

  for force_name, force_depots in pairs(script_data.depots) do
    for surface_name, surface_depots in pairs(force_depots) do
      for unit_number, depot in pairs(surface_depots) do
        Depot.load(depot)
      end
    end
  end

  for force_name, force_depots in pairs(script_data.request_depots) do
    for surface_name, surface_depots in pairs(force_depots) do
      for unit_number, request_depot in pairs(surface_depots) do
        Request_depot.load(request_depot)
      end
    end
  end

  for unit_number, drone in pairs(script_data.drones) do
    Drone.load(drone)
  end

end

return lib
