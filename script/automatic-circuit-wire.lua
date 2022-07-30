
local wire_types =
{
  defines.wire_type.red,
  defines.wire_type.green
}

local connect_if_circuit_network = function(source, target)
  for k, wire_type in pairs(wire_types) do
    local circuit_network = source.get_circuit_network(wire_type)
    if circuit_network then
      target.connect_neighbour({wire = wire_type, target_entity = source})
    end
  end
end

local connect_circuit_neighbours = function(electric_pole)
  local neighbours = electric_pole.neighbours

  if next(neighbours["red"]) then return end
  if next(neighbours["green"]) then return end

  for k, neighbour in pairs(neighbours["copper"]) do
    connect_if_circuit_network(neighbour, electric_pole)
  end
end

local on_built_entity = function(event)
  local entity = event.created_entity
  if not (entity and entity.valid) then return end

  if entity.type ~= "electric-pole" then return end

  if not entity.force.technologies["automatic-circuit-wire"].researched then return end

  connect_circuit_neighbours(entity)

end

local lib = {}

lib.events =
{
  [defines.events.on_built_entity] = on_built_entity,
  [defines.events.on_robot_built_entity] = on_built_entity
}

return lib