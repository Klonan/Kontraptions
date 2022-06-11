local depot =
{
  type = "logistic-container",
  name = "long-range-delivery-drone-depot",
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
  inventory_size = 20,
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
  circuit_wire_max_distance = 0,
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
  enabled = false,
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
  inventory_size = 20,
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
  circuit_wire_max_distance = 0,
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
  enabled = false,
  ingredients =
  {
    {"steel-chest", 1},
    {"advanced-circuit", 5},
    {"processing-unit", 5}
  },
  result = "long-range-delivery-drone-request-depot"
}

data:extend
{
  depot,
  depot_item,
  depot_recipe,
  request_depot,
  request_depot_item,
  request_depot_recipe
}