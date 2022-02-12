local sprite =
{
  filename = "__base__/graphics/entity/accumulator/hr-accumulator.png",
  priority = "extra-high",
  width = 124,
  height = 103,
  shift = {0, 0},
  scale = 0.25
}

local daylight_sensor =
{
  type = "accumulator",
  name = "daylight-sensor",
  icon = "__base__/graphics/icons/accumulator.png",
  icon_size = 64,
  flags = {"placeable-neutral", "player-creation"},
  minable = {hardness = 0.2, mining_time = 0.5, result = "daylight-sensor"},
  max_health = 150,
  corpse = "small-remnants",
  collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  energy_source =
  {
    type = "void",
    buffer_capacity = "100J",
    usage_priority = "tertiary",
    input_flow_limit = "0W",
    output_flow_limit = "0W",
    render_no_power_icon = false,
    render_no_network_icon = false
  },
  picture = sprite,
  charge_animation = sprite,
  discharge_animation = sprite,
  charge_cooldown = 0,
  discharge_cooldown = 0,
  charge_light = {intensity = 0, size = 0},
  circuit_wire_max_distance = 12,
  default_output_signal = {type = "item", name = "solar-panel"},
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "daylight-sensor-created"
      }
    }
  },
}

local daylight_sensor_item =
{
  type = "item",
  name = "daylight-sensor",
  icon = "__base__/graphics/icons/accumulator.png",
  icon_size = 64,
  subgroup = "energy",
  order = "a[energy]-a[accumulator]",
  place_result = "daylight-sensor",
  stack_size = 50
}

data:extend
{
  daylight_sensor,
  daylight_sensor_item
}