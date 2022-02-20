local sprite = function()
  return
  {
    filename = "__base__/graphics/entity/wooden-chest/hr-wooden-chest.png",
    priority = "extra-high",
    width = 62,
    height = 72,
    shift = util.by_pixel(0.5, -2),
    scale = 0.5
  }
end

local connection_point = function()
  return
  {
    wire =
    {
      red = {-26/64, -5/64},
      green = {-22/64, -21/64},
    },
    shadow =
    {
      red = {0, 0},
      green = {0, 0}
    }
  }
end

local pressure_plate =
{
  type = "constant-combinator",
  name = "pressure-plate",
  icon = "__base__/graphics/icons/constant-combinator.png",
  icon_size = 64,
  flags = {"placeable-neutral", "player-creation", "not-rotatable"},
  minable = {hardness = 0.2, mining_time = 0.5, result = "pressure-plate"},
  max_health = 50,
  corpse = "small-remnants",
  collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
  collision_mask = {"item-layer", "object-layer", "water-tile"},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  item_slot_count = 20,

  sprites =
  {
    north = sprite(),
    east = sprite(),
    south = sprite(),
    west = sprite()
  },
  activity_led_sprites =
  {
    north = util.empty_sprite(),
    east = util.empty_sprite(),
    south = util.empty_sprite(),
    west = util.empty_sprite()
  },
  activity_led_light =
  {
    intensity = 0,
    size = 0
  },
  activity_led_light_offsets =
  {
    {0, 0},
    {0, 0},
    {0, 0},
    {0, 0}
  },
  circuit_wire_connection_points =
  {
    connection_point(),
    connection_point(),
    connection_point(),
    connection_point()
  },
  circuit_wire_max_distance = DETECTION_RANGE,

}

local item =
{
  type = "item",
  name = "pressure-plate",
  icon = "__base__/graphics/icons/constant-combinator.png",
  icon_size = 64,
  subgroup = "circuit-network",
  order = "a[combinators]-a[constant-combinator]",
  place_result = "pressure-plate",
  stack_size = 10
}

data:extend
{
  pressure_plate,
  item
}