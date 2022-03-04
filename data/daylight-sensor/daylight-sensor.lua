local sprite =
{
  layers =
  {
    {
      filename = "__Kontraptions__/data/daylight-sensor/daylight-sensor.png",
      width = 64,
      height = 64,
      shift = {0, 0},
      scale = 0.5
    },
    {
      filename = "__base__/graphics/entity/small-lamp/hr-lamp-shadow.png",
      width = 76,
      height = 47,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = util.by_pixel(4, 4.75),
      draw_as_shadow = true,
      scale = 0.5
    }
  }
}

local daylight_sensor =
{
  type = "accumulator",
  name = "daylight-sensor",
  localised_name = {"daylight-sensor"},
  localised_description = {"daylight-sensor-description"},
  icon = "__Kontraptions__/data/daylight-sensor/daylight-sensor.png",
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
  circuit_wire_connection_point = circuit_connector_definitions["lamp"].points,
  circuit_connector_sprites = circuit_connector_definitions["lamp"].sprites,
  vehicle_impact_sound = sounds.generic_impact,
  open_sound = sounds.machine_open,
  close_sound = sounds.machine_close,
}

local daylight_sensor_item =
{
  type = "item",
  name = "daylight-sensor",
  icon = "__Kontraptions__/data/daylight-sensor/daylight-sensor.png",
  icon_size = 64,
  subgroup = "circuit-network",
  order = "a[energy]-a[accumulator]",
  place_result = "daylight-sensor",
  stack_size = 10
}

local daylight_sensor_recipe =
{
  type = "recipe",
  name = "daylight-sensor",
  enabled = false,
  ingredients =
  {
    {"electronic-circuit", 10},
    {"iron-plate", 5},
    {"solar-panel", 1}
  },
  result = "daylight-sensor"
}

local daylight_sensor_technology =
{
  type = "technology",
  name = "daylight-sensor",
  localised_name = {"daylight-sensor"},
  localised_description = {"daylight-sensor-description"},
  icon = "__Kontraptions__/data/daylight-sensor/daylight-sensor-tech-icon.png",
  icon_size = 128,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "daylight-sensor"
    }
  },
  prerequisites = {"circuit-network", "solar-energy"},
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
  daylight_sensor,
  daylight_sensor_item,
  daylight_sensor_recipe,
  daylight_sensor_technology
}