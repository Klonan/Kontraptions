local DETECTION_RANGE = 32

local util = require("util")

local y_offset =
{
  north = 0,
  east = 1,
  south = 2,
  west = 3
}

local sprite = function(direction, friendly)
  return
  {
    layers =
    {
      {
        filename = "__Kontraptions__/data/motion-sensor/motion-sensor.png",
        frame_count = 1,
        line_length = 1,
        scale = 0.5,
        width = 90,
        height = 220,
        x = friendly and 390 or 0,
        shift = {-0.05, -1},
        y = y_offset[direction] * 220
      },
      {
        filename = "__base__/graphics/entity/circuit-connector/hr-ccm-universal-04c-wire-sequence.png",
        frame_count = 1,
        height = 58,
        line_length = 1,
        scale = 0.5,
        width = 62,
        x = 6 * 62,
        shift = {-0.1, 0}
      },
      {
        filename = "__Kontraptions__/data/motion-sensor/motion-sensor.png",
        frame_count = 1,
        line_length = 1,
        scale = 0.5,
        width = 314-90,
        x = 90,
        height = 220,
        shift = {1, -1},
        y = y_offset[direction] * 220,
        draw_as_shadow = true
      }
    }
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

local enemy_motion_sensor =
{
  type = "turret",
  name = "enemy-motion-sensor",
  localised_name = {"enemy-motion-sensor"},
  localised_description = {"enemy-motion-sensor-description"},
  attack_target_mask = {"motion"},
  icon = "__Kontraptions__/data/motion-sensor/enemy-motion-sensor-icon.png",
  icon_size = 64,
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  is_military_target = false,
  flags = {"placeable-player", "player-creation", "not-blueprintable", "not-deconstructable"},
  --minable = {mining_time = 0.5, result = "enemy-motion-sensor"},
  max_health = 100,
  corpse = "small-remnants",
  collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
  selection_priority = 10,
  attack_parameters =
  {
    type = "projectile",
    cooldown = 60,
    range = DETECTION_RANGE,
    turn_range = 0.5,
    ammo_type =
    {
      category = "melee",
      energy_consumption = "50J",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            type = "script",
            effect_id = "motion-sensor-triggered"
          }
        }
      }
    }
  },
  base_picture =
  {
    north = sprite("north", false),
    east = sprite("east", false),
    south = sprite("south", false),
    west = sprite("west", false),
  },
  folded_animation = util.empty_sprite(),
  turret_base_has_direction = true,
  call_for_help_radius = 0,
  energy_source =
  {
    type = "void",
    buffer_capacity = "1kJ",
    usage_priority = "primary-input",
    input_flow_limit = "1kW",
    drain = "100W"
  },
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "enemy-motion-sensor-created"
      }
    }
  }
}

local enemy_item =
{
  type = "item",
  name = "enemy-motion-sensor",
  localised_name = {"enemy-motion-sensor"},
  icon = "__Kontraptions__/data/motion-sensor/enemy-motion-sensor-icon.png",
  icon_size = 64,
  stack_size = 10,
  place_result = "enemy-motion-sensor",
  subgroup = "circuit-network",
  order = "k[kontraptions]-b[enemy-motion-sensor]"
}

local enemy_invisible_combinator =
{
  type = "constant-combinator",
  name = "enemy-invisible-combinator",
  localised_name = {"enemy-motion-sensor"},
  icon = "__Kontraptions__/data/motion-sensor/enemy-motion-sensor-icon.png",
  icon_size = 64,
  flags = {"not-on-map", "player-creation"},
  is_military_target = false,
  minable = {mining_time = 0.5, result = "enemy-motion-sensor"},
  max_health = 100,
  collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  selection_priority = 100,
  item_slot_count = 1,
  sprites =
  {
    north = sprite("north", false),
    east = sprite("east", false),
    south = sprite("south", false),
    west = sprite("west", false)
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
  placeable_by = {item = "enemy-motion-sensor", count = 1},
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "enemy-motion-sensor-combinator-created"
      }
    }
  }
}

local friendly_motion_sensor =
{
  type = "turret",
  name = "friendly-motion-sensor",
  localised_name = {"friendly-motion-sensor"},
  localised_description = {"friendly-motion-sensor-description"},
  attack_target_mask = {"motion"},
  is_military_target = false,
  icon = "__Kontraptions__/data/motion-sensor/friendly-motion-sensor-icon.png",
  icon_size = 64,
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  flags = {"placeable-player", "player-creation", "not-blueprintable", "not-deconstructable"},
  --minable = {mining_time = 0.5, result = "enemy-motion-sensor"},
  max_health = 100,
  corpse = "small-remnants",
  collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
  selection_priority = 10,
  resistances =
  {
    {
      type = "fire",
      percent = 100
    }
  },
  attack_parameters =
  {
    type = "projectile",
    cooldown = 60,
    range = DETECTION_RANGE,
    min_range = 1.5,
    turn_range = 0.4,
    ammo_type =
    {
      category = "melee",
      energy_consumption = "50J",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            type = "script",
            effect_id = "motion-sensor-triggered"
          }
        }
      }
    }
  },
  base_picture =
  {
    north = sprite("north", true),
    east = sprite("east", true),
    south = sprite("south", true),
    west = sprite("west", true)
  },
  folded_animation = util.empty_sprite(),
  turret_base_has_direction = true,
  call_for_help_radius = 0,
  energy_source =
  {
    type = "void",
    buffer_capacity = "1kJ",
    usage_priority = "primary-input",
    input_flow_limit = "1kW",
    drain = "100W"
  },
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "friendly-motion-sensor-created"
      }
    }
  }
}

local friendly_item =
{
  type = "item",
  name = "friendly-motion-sensor",
  localised_name = {"friendly-motion-sensor"},
  icon = "__Kontraptions__/data/motion-sensor/friendly-motion-sensor-icon.png",
  icon_size = 64,
  stack_size = 10,
  place_result = "friendly-motion-sensor",
  subgroup = "circuit-network",
  order = "k[kontraptions]-a[motion-sensor]"
}

local friendly_invisible_combinator =
{
  type = "constant-combinator",
  name = "friendly-invisible-combinator",
  localised_name = {"friendly-motion-sensor"},
  icon = "__Kontraptions__/data/motion-sensor/friendly-motion-sensor-icon.png",
  icon_size = 64,
  flags = {"not-on-map", "player-creation"},
  is_military_target = false,
  minable = {mining_time = 0.5, result = "friendly-motion-sensor"},
  max_health = 100,
  collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  selection_priority = 100,
  item_slot_count = 1,
  sprites =
  {
    north = sprite("north", true),
    east = sprite("east", true),
    south = sprite("south", true),
    west = sprite("west", true)
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
  placeable_by = {item = "friendly-motion-sensor", count = 1},
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "friendly-motion-sensor-combinator-created"
      }
    }
  }
}

local enemy_recipe =
{
  type = "recipe",
  name = "enemy-motion-sensor",
  localised_name = {"enemy-motion-sensor"},
  enabled = false,
  ingredients =
  {
    {"electronic-circuit", 10},
    {"battery", 4},
    {"steel-plate", 2}
  },
  result = "enemy-motion-sensor"
}

local friendly_recipe =
{
  type = "recipe",
  name = "friendly-motion-sensor",
  localised_name = {"friendly-motion-sensor"},
  enabled = false,
  ingredients =
  {
    {"electronic-circuit", 10},
    {"battery", 4},
    {"steel-plate", 2}
  },
  result = "friendly-motion-sensor"
}

local motion_sensor_technology =
{
  type = "technology",
  name = "motion-sensor",
  localised_name = {"motion-sensor"},
  icon = "__Kontraptions__/data/motion-sensor/motion-sensor-tech-icon.png",
  icon_size = 128,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "enemy-motion-sensor"
    },
    {
      type = "unlock-recipe",
      recipe = "friendly-motion-sensor"
    }
  },
  prerequisites = {"circuit-network", "battery"},
  unit =
  {
    count = 150,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1}
    },
    time = 30
  },
  order = "a-d-a"
}

local target_mask =
{
  name = "motion",
  type = "trigger-target-type"
}

data:extend
{
  enemy_motion_sensor,
  enemy_item,
  enemy_invisible_combinator,
  friendly_motion_sensor,
  friendly_item,
  friendly_invisible_combinator,
  enemy_recipe,
  friendly_recipe,
  motion_sensor_technology,
  target_mask
}
