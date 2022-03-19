local fire_util = require("__base__/prototypes/fire-util.lua")

local tinderbox =
{
  type = "capsule",
  name = "tinderbox",
  icon = "__base__/graphics/icons/slowdown-capsule.png",
  icon_size = 64, icon_mipmaps = 4,
  capsule_action =
  {
    type = "throw",
    attack_parameters =
    {
      type = "projectile",
      activation_type = "throw",
      ammo_category = "capsule",
      cooldown = 100,
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
            repeat_count = 12,
            action_delivery =
            {
              type = "projectile",
              projectile = "tinderbox-fire-projectile",
              starting_speed = 0.3,
              starting_speed_deviation = 0.2,
              max_range = 6,
              range_deviation = 1,
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
                  sound = sounds.throw_projectile
                }
              }
            }
          }
        }
      }
    }
  },
  subgroup = "capsule",
  order = "c[slowdown-capsule]",
  stack_size = 100
}

local tinderbox_projectile =
{
  type = "projectile",
  name = "tinderbox-fire-projectile",
  flags = {"not-on-map"},
  acceleration = -0.001,
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
            entity_name = "tinderbox-fire"
          },
        }
      }
    }
  },
  animation =
  {
    filename = "__base__/graphics/entity/slowdown-capsule/slowdown-capsule.png",
    draw_as_glow = true,
    frame_count = 16,
    line_length = 8,
    animation_speed = 0.250,
    width = 32,
    height = 30,
    shift = util.by_pixel(1, 0),
    priority = "high",
    hr_version =
    {
      filename = "__base__/graphics/entity/slowdown-capsule/hr-slowdown-capsule.png",
      draw_as_glow = true,
      frame_count = 16,
      line_length = 8,
      animation_speed = 0.250,
      width = 60,
      height = 60,
      shift = util.by_pixel(0.5, 0.5),
      priority = "high",
      scale = 0.5
    }
  },
  shadow =
  {
    filename = "__base__/graphics/entity/slowdown-capsule/slowdown-capsule-shadow.png",
    frame_count = 16,
    line_length = 8,
    animation_speed = 0.250,
    width = 32,
    height = 24,
    shift = util.by_pixel(2, 13),
    priority = "high",
    draw_as_shadow = true,
    hr_version =
    {
      filename = "__base__/graphics/entity/slowdown-capsule/hr-slowdown-capsule-shadow.png",
      frame_count = 16,
      line_length = 8,
      animation_speed = 0.250,
      width = 64,
      height = 48,
      shift = util.by_pixel(2, 13.5),
      priority = "high",
      draw_as_shadow = true,
      scale = 0.5
    }
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
  damage_per_tick = {amount = 2 / 60, type = "fire"},
  maximum_damage_multiplier = 6,
  damage_multiplier_increase_per_added_fuel = 1,
  damage_multiplier_decrease_per_tick = 0.005,

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