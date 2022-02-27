local sprite =
{
  layers =
  {
    {
      filename = "__Kontraptions__/data/pollution-sensor/pollution-sensor.png",
      width = 32,
      height = 128,
      shift = {0, -46/64},
      scale = 0.5,
      repeat_count = 4,
      animation_speed = 0.33,
      frame_count = 1
    },
    {
      filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-2.png",
      priority = "high",
      width = 23,
      height = 15,
      frame_count = 4,
      shift = {-1/64, -94/64},
      scale = 0.5
    },
    {
      filename = "__Kontraptions__/data/pollution-sensor/pollution-sensor-shadow.png",
      width = 128,
      height = 32,
      shift = {50/64, 0},
      scale = 0.5,
      frame_count = 1,
      repeat_count = 4,
      draw_as_shadow = true
    },
  }
}

local pollution_sensor =
{
  type = "accumulator",
  name = "pollution-sensor",
  localised_name = {"pollution-sensor"},
  localised_description = {"pollution-sensor-description"},
  icon = "__Kontraptions__/data/pollution-sensor/pollution-sensor-icon.png",
  icon_size = 64,
  flags = {"placeable-neutral", "player-creation"},
  minable = {hardness = 0.2, mining_time = 0.5, result = "pollution-sensor"},
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
  charge_cooldown = 65000,
  discharge_cooldown = 65000,
  charge_light = {intensity = 0, size = 0},
  circuit_wire_max_distance = 12,
  default_output_signal = {type = "item", name = "pollution-sensor"},
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "pollution-sensor-created"
      }
    }
  },
  circuit_wire_connection_point = circuit_connector_definitions["programmable-speaker"].points,
  circuit_connector_sprites = circuit_connector_definitions["programmable-speaker"].sprites,
}

local pollution_sensor_item =
{
  type = "item",
  name = "pollution-sensor",
  icon = "__Kontraptions__/data/pollution-sensor/pollution-sensor-icon.png",
  icon_size = 64,
  subgroup = "circuit-network",
  order = "a[energy]-a[accumulator]",
  place_result = "pollution-sensor",
  stack_size = 10
}

local pollution_sensor_recipe =
{
  type = "recipe",
  name = "pollution-sensor",
  enabled = false,
  ingredients =
  {
    {"electronic-circuit", 10},
    {"iron-plate", 5},
    {"solar-panel", 1}
  },
  result = "pollution-sensor"
}

local pollution_sensor_technology =
{
  type = "technology",
  name = "pollution-sensor",
  localised_name = {"pollution-sensor"},
  localised_description = {"pollution-sensor-description"},
  icon = "__Kontraptions__/data/pollution-sensor/pollution-sensor-tech-icon.png",
  icon_size = 128,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "pollution-sensor"
    }
  },
  prerequisites = {"circuit-network"},
  unit =
  {
    count = 200,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1}
    },
    time = 30
  },
  order = "a-f-a"
}

data:extend
{
  pollution_sensor,
  pollution_sensor_item,
  pollution_sensor_recipe,
  pollution_sensor_technology
}