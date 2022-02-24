local sprite = function()
  return
  {
    filename = "__Kontraptions__/data/pressure-plate/pressure-plate.png",
    priority = "extra-high",
    width = 100,
    height = 99,
    shift = util.by_pixel(0, 0),
    scale = 0.5
  }
end

local connection_point = function()
  return
  {
    wire =
    {
      red = {14/64, 9/64},
      green = {20/64, 18/64},
    },
    shadow =
    {
      red = {18/64, 28/64},
      green = {24/64, 30/64}
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
    north = util.empty_sprite(),
    east = util.empty_sprite(),
    south = util.empty_sprite(),
    west = util.empty_sprite()
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
  circuit_wire_max_distance = 20,
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "pressure-plate-created"
      }
    }
  },
  radius_visualisation_specification =
  {
    sprite =
    {
      layers =
      {
        sprite(),
        sprite(),
        sprite(),
      }
    },
    distance = 0.64,
    draw_on_selection = false,
    draw_in_cursor = true
  }

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

local pressure_plate_turret =
{
  type = "turret",
  name = "pressure-plate-turret",
  attack_target_mask = {"ground-motion"},
  icon = "__Kontraptions__/data/motion-sensor/enemy-motion-sensor-icon.png",
  icon_size = 64,
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  selectable_in_game = false,
  collision_mask = {},
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
    range = 0.325,
    min_range = 0,
    --turn_range = 1,
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
    north = sprite(),
    east = sprite(),
    south = sprite(),
    west = sprite(),
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
  }
}

local target_mask =
{
  name = "ground-motion",
  type = "trigger-target-type"
}


data:extend
{
  pressure_plate,
  item,
  pressure_plate_turret,
  target_mask
}