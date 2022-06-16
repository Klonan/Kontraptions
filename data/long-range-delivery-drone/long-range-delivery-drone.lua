local depot =
{
  type = "logistic-container",
  name = "long-range-delivery-drone-depot",
  localised_name = {"long-range-delivery-drone-depot"},
  icon = "__base__/graphics/icons/logistic-chest-requester.png",
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-player", "player-creation"},
  minable = {mining_time = 1, result = "long-range-delivery-drone-depot"},
  max_health = 350,
  corpse = "requester-chest-remnants",
  dying_explosion = "requester-chest-explosion",
  collision_box = {{-0.85, -0.85}, {0.85, 0.85}},
  selection_box = {{-1, -1}, {1, 1}},
  resistances =
  {
    {
      type = "fire",
      percent = 90
    },
    {
      type = "impact",
      percent = 60
    }
  },
  fast_replaceable_group = "container",
  inventory_size = 80,
  logistic_mode = "requester",
  open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.43 },
  close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 },
  opened_duration = 10,
  animation =
  {
    layers =
    {
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-requester.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        frame_count = 7,
        shift = util.by_pixel(0, -2),
        scale = 1
      },
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 46,
        repeat_count = 7,
        shift = util.by_pixel(12, 4.5),
        draw_as_shadow = true,
        scale = 1
      }
    }
  },
  circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
  circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
  circuit_wire_max_distance = 10,
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "long-range-delivery-drone-depot-created"
      }
    }
  }
}

local depot_item =
{
  type = "item",
  name = "long-range-delivery-drone-depot",
  icon = depot.icon,
  icon_size = depot.icon_size, icon_mipmaps = depot.icon_mipmaps,
  flags = {},
  subgroup = "logistic-network",
  order = "a[long-range-delivery-drone-depot]",
  place_result = "long-range-delivery-drone-depot",
  stack_size = 10
}

local depot_recipe =
{
  type = "recipe",
  name = "long-range-delivery-drone-depot",
  enabled = true,
  ingredients =
  {
    {"steel-chest", 1},
    {"advanced-circuit", 5},
    {"processing-unit", 5}
  },
  result = "long-range-delivery-drone-depot"
}

local request_depot =
{
  type = "logistic-container",
  name = "long-range-delivery-drone-request-depot",
  localised_name = {"long-range-delivery-drone-request-depot"},
  icon = "__base__/graphics/icons/logistic-chest-requester.png",
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-player", "player-creation"},
  minable = {mining_time = 1, result = "long-range-delivery-drone-request-depot"},
  max_health = 350,
  corpse = "requester-chest-remnants",
  dying_explosion = "requester-chest-explosion",
  collision_box = {{-0.85, -0.85}, {0.85, 0.85}},
  selection_box = {{-1, -1}, {1, 1}},
  resistances =
  {
    {
      type = "fire",
      percent = 90
    },
    {
      type = "impact",
      percent = 60
    }
  },
  fast_replaceable_group = "container",
  inventory_size = 80,
  logistic_mode = "requester",
  open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.43 },
  close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 },
  opened_duration = 10,
  animation =
  {
    layers =
    {
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-requester.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        frame_count = 7,
        shift = util.by_pixel(0, -2),
        tint = {r = 1, g = 0.5, b = 0.5, a = 1},
        scale = 1
      },
      {

        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 46,
        repeat_count = 7,
        shift = util.by_pixel(12, 4.5),
        draw_as_shadow = true,
        scale = 1,
      }
    }
  },
  circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
  circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
  circuit_wire_max_distance = 10,
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "long-range-delivery-drone-request-depot-created"
      }
    }
  }
}

local request_depot_item =
{
  type = "item",
  name = "long-range-delivery-drone-request-depot",
  icon = request_depot.icon,
  icon_size = request_depot.icon_size, icon_mipmaps = request_depot.icon_mipmaps,
  flags = {},
  subgroup = "logistic-network",
  order = "a[long-range-delivery-drone-request-depot]",
  place_result = "long-range-delivery-drone-request-depot",
  stack_size = 10
}

local request_depot_recipe =
{
  type = "recipe",
  name = "long-range-delivery-drone-request-depot",
  enabled = true,
  ingredients =
  {
    {"steel-chest", 1},
    {"advanced-circuit", 5},
    {"processing-unit", 5}
  },
  result = "long-range-delivery-drone-request-depot"
}

local delivery_drone =
{
  type = "car",
  name = "long-range-delivery-drone",
  localised_name = {"long-range-delivery-drone"},
  icon = "__base__/graphics/icons/car.png",
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-neutral", "player-creation", "placeable-off-grid", "not-flammable"},
  --minable = {mining_time = 0.4, result = "car"},
  mined_sound = {filename = "__core__/sound/deconstruct-medium.ogg",volume = 0.8},
  max_health = 500,
  corpse = "car-remnants",
  dying_explosion = "car-explosion",
  alert_icon_shift = util.by_pixel(0, -13),
  energy_per_hit_point = 1000000,
  collision_box = {{0, 0}, {0, 0}},
  collision_mask = {},
  selection_box = {{-0.7, -1}, {0.7, 1}},
  effectivity = 1,
  braking_power = "200kW",
  energy_source =
  {
    type = "void"
  },
  consumption = "150kW",
  friction = 0.000000001,
  poop_light =
  {
    {
      type = "oriented",
      minimum_darkness = 0.3,
      picture =
      {
        filename = "__core__/graphics/light-cone.png",
        priority = "extra-high",
        flags = { "light" },
        scale = 2,
        width = 200,
        height = 200
      },
      shift = {-0.6, -14},
      size = 2,
      intensity = 0.6,
      color = {r = 0.92, g = 0.77, b = 0.3}
    },
    {
      type = "oriented",
      minimum_darkness = 0.3,
      picture =
      {
        filename = "__core__/graphics/light-cone.png",
        priority = "extra-high",
        flags = { "light" },
        scale = 2,
        width = 200,
        height = 200
      },
      shift = {0.6, -14},
      size = 2,
      intensity = 0.6,
      color = {r = 0.92, g = 0.77, b = 0.3}
    }
  },
  render_layer = "air-object",
  poop_light_animation =
  {
    filename = "__base__/graphics/entity/car/car-light.png",
    priority = "low",
    blend_mode = "additive",
    draw_as_glow = true,
    width = 102,
    height = 84,
    line_length = 8,
    direction_count = 64,
    shift = util.by_pixel(0 + 2, -8 + 3),
    repeat_count = 2
  },
  poop_animation =
  {
    layers =
    {
      {
        priority = "low",
        width = 102,
        height = 86,
        frame_count = 2,
        direction_count = 64,
        shift = {0, -0.1875},
        animation_speed = 8,
        max_advance = 0.2,
        stripes =
        {
          {
            filename = "__base__/graphics/entity/car/car-1.png",
            width_in_frames = 2,
            height_in_frames = 22
          },
          {
            filename = "__base__/graphics/entity/car/car-2.png",
            width_in_frames = 2,
            height_in_frames = 22
          },
          {
            filename = "__base__/graphics/entity/car/car-3.png",
            width_in_frames = 2,
            height_in_frames = 20
          }
        }
      },
      {
        priority = "low",
        width = 100,
        height = 75,
        frame_count = 2,
        apply_runtime_tint = true,
        direction_count = 64,
        max_advance = 0.2,
        line_length = 2,
        shift = {0, -0.171875},
        stripes = util.multiplystripes(2,
        {
          {
            filename = "__base__/graphics/entity/car/car-mask-1.png",
            width_in_frames = 1,
            height_in_frames = 22
          },
          {
            filename = "__base__/graphics/entity/car/car-mask-2.png",
            width_in_frames = 1,
            height_in_frames = 22
          },
          {
            filename = "__base__/graphics/entity/car/car-mask-3.png",
            width_in_frames = 1,
            height_in_frames = 20
          }
        })
      },
      {
        priority = "low",
        width = 114,
        height = 76,
        frame_count = 2,
        draw_as_shadow = true,
        direction_count = 64,
        shift = {0.28125, 0.25},
        max_advance = 0.2,
        stripes = util.multiplystripes(2,
        {
          {
            filename = "__base__/graphics/entity/car/car-shadow-1.png",
            width_in_frames = 1,
            height_in_frames = 22
          },
          {
            filename = "__base__/graphics/entity/car/car-shadow-2.png",
            width_in_frames = 1,
            height_in_frames = 22
          },
          {
            filename = "__base__/graphics/entity/car/car-shadow-3.png",
            width_in_frames = 1,
            height_in_frames = 20
          }
        })
      }
    }
  },
  animation =
  {
    layers =
    {
      {
        filename = "__Kontraptions__/data/long-range-delivery-drone/hr-drone.png",
        size = 512,
        scale = 0.5,
        frame_count = 1,
        direction_count = 64,
        line_length = 8,
      },
      {
        filename = "__Kontraptions__/data/long-range-delivery-drone/hr-drone-shadow.png",
        size = 512,
        scale = 0.5,
        frame_count = 1,
        direction_count = 64,
        line_length = 8,
        draw_as_shadow = true,
        shift = {5, 5}
      },

    }
  },
  poop_turret_animation =
  {
    layers =
    {
      {
        filename = "__base__/graphics/entity/car/car-turret.png",
        priority = "low",
        line_length = 8,
        width = 36,
        height = 29,
        frame_count = 1,
        direction_count = 64,
        shift = {0.03125, -0.890625},
        animation_speed = 8,
      },
      {
        filename = "__base__/graphics/entity/car/car-turret-shadow.png",
        priority = "low",
        line_length = 8,
        width = 46,
        height = 31,
        frame_count = 1,
        draw_as_shadow = true,
        direction_count = 64,
        shift = {0.875, 0.359375}
      }
    }
  },
  turret_rotation_speed = 0.35 / 60,
  sound_no_fuel =
  {
    {
      filename = "__base__/sound/fight/car-no-fuel-1.ogg",
      volume = 0.6
    }
  },
  stop_trigger_speed = 0.15,
  stop_trigger =
  {
    {
      type = "play-sound",
      sound =
      {
        {
          filename = "__base__/sound/car-breaks.ogg",
          volume = 0.2
        }
      }
    }
  },
  sound_minimum_speed = 0.25,
  sound_scaling_ratio = 0.8,
  working_sound =
  {
    sound =
    {
      filename = "__base__/sound/car-engine.ogg",
      volume = 0.67
    },
    activate_sound =
    {
      filename = "__base__/sound/car-engine-start.ogg",
      volume = 0.67
    },
    deactivate_sound =
    {
      filename = "__base__/sound/car-engine-stop.ogg",
      volume = 0.67
    },
    match_speed_to_activity = true
  },
  open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.5 },
  close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.4 },
  rotation_speed = 0.015,
  weight = 100,
  guns = {},
  inventory_size = 5,
  has_belt_immunity = true,
  allow_passengers = false,
  terrain_friction_modifier = 0,
  minimap_representation =
  {
    filename = "__Kontraptions__/data/long-range-delivery-drone/long-range-delivery-drone-map.png",
    flags = {"icon"},
    size = {128, 128},
    scale = 0.5
  }
}

local delivery_drone_item =
{
  type = "item",
  name = "long-range-delivery-drone",
  icon = delivery_drone.icon,
  icon_size = delivery_drone.icon_size,
  flags = {},
  stack_size = 1
}

local delivery_drone_recipe =
{
  type = "recipe",
  name = "long-range-delivery-drone",
  enabled = true,
  ingredients =
  {
    {"electric-engine-unit", 1},
    {"advanced-circuit", 1},
    {"steel-plate", 1},
    {"battery", 1}
  },
  result = "long-range-delivery-drone"
}

data:extend
{
  depot,
  depot_item,
  depot_recipe,
  request_depot,
  request_depot_item,
  request_depot_recipe,
  delivery_drone,
  delivery_drone_item,
  delivery_drone_recipe
}