local util = require("util")
local fire_util = require("__base__/prototypes/fire-util.lua")

local tinderbox =
{
  type = "capsule",
  name = "tinderbox",
  localised_name = {"tinderbox"},
  icon = "__Kontraptions__/data/tinderbox/tinderbox.png",
  icon_size = 64,
  capsule_action =
  {
    type = "throw",
    attack_parameters =
    {
      type = "projectile",
      activation_type = "throw",
      ammo_category = "capsule",
      cooldown = 30,
      projectile_creation_distance = 0.6,
      range = 8,
      ammo_type =
      {
        category = "capsule",
        target_type = "position",
        action =
        {
          {
            type = "direct",
            repeat_count = 17,
            action_delivery =
            {
              type = "projectile",
              projectile = "tinderbox-fire-projectile",
              starting_speed = 0.4,
              starting_speed_deviation = 0.08,
              max_range = 7,
              range_deviation = 0.5,
              direction_deviation = 1,
            }
          },
          {
            type = "direct",
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                {
                  type = "play-sound",
                  sound = data.raw["utility-sounds"].default.axe_mining_ore
                }
              }
            }
          }
        }
      }
    }
  },
  subgroup = "capsule",
  order = "aa[tinderbox]",
  stack_size = 50
}

local tinderbox_projectile =
{
  type = "projectile",
  name = "tinderbox-fire-projectile",
  flags = {"not-on-map"},
  acceleration = 0,
  action =
  {
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-fire",
            entity_name = "tinderbox-fire",
            repeat_count = 7,
            repeat_count_deviation = 7,
            probability = 0.7
          },
          {
            type = "create-entity",
            entity_name = "tinderbox-fire",
            probability = 0.5
          },
        }
      }
    }
  },
  animation = util.draw_as_glow
  {
    filename = "__base__/graphics/entity/flamethrower-fire-stream/flamethrower-explosion.png",
    priority = "extra-high",
    width = 64,
    height = 64,
    frame_count = 32,
    line_length = 8,
    scale = 0.25
  },
  shadow =
  {
    filename = "__base__/graphics/entity/acid-projectile/projectile-shadow.png",
    line_length = 5,
    width = 28,
    height = 16,
    frame_count = 33,
    priority = "high",
    shift = {-0.09, 0.395},
    scale = 0.25
  },
  --smoke = capsule_smoke
}

local recipe =
{
  type = "recipe",
  name = "tinderbox",
  enabled = true,
  energy_required = 5,
  ingredients =
  {
    {"wood", 1},
    {"iron-stick", 1},
    {"coal", 1},
    {"stone", 1}
  },
  result = "tinderbox"
}


local tinderbox_fire = fire_util.add_basic_fire_graphics_and_effects_definitions
{
  type = "fire",
  name = "tinderbox-fire",
  flags = {"placeable-off-grid", "not-on-map"},
  damage_per_tick = {amount = 0.5 / 60, type = "fire"},
  maximum_damage_multiplier = 1,
  damage_multiplier_increase_per_added_fuel = 0,
  damage_multiplier_decrease_per_tick = 0,

  spawn_entity = "fire-flame-on-tree",

  spread_delay = 180,
  spread_delay_deviation = 180,
  maximum_spread_count = 100,
  emissions_per_second = 0.004,
  initial_lifetime = 250,
  lifetime_increase_by = 49,
  lifetime_increase_cooldown = 0,
  maximum_lifetime = 1800,
  delay_between_initial_flames = 10,
  pictures = fire_util.create_fire_pictures({ blend_mode = "normal", animation_speed = 1, scale = 0.25}),
  smoke_source_pictures =  fire_util.create_fire_smoke_source_pictures(0.5, nil),
  working_sound =
  {
    sound =
    {
      {
        filename = "__base__/sound/fire-1.ogg",
        volume = 0.4
      },
      {
        filename = "__base__/sound/fire-2.ogg",
        volume = 0.4
      }
    },
    match_volume_to_activity = true,
    max_sounds_per_type = 3,
    fade_in_ticks = 10,
    fade_out_ticks = 90
  }
}
tinderbox_fire.burnt_patch_pictures = nil
tinderbox_fire.smoke = nil


data:extend
{
  tinderbox,
  tinderbox_projectile,
  recipe,
  tinderbox_fire
}