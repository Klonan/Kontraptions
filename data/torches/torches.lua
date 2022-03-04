local torch_shift = {0.45, -0.45}

local graphics = function(active)
  return
  {
    layers =
    {
      {
        filename = "__Kontraptions__/data/torches/torch.png",
        priority = "extra-high",
        width = 91,
        height = 80,
        shift = torch_shift,
        repeat_count = 60,
        frame_count = 1,
        scale = 0.5
      },
      {
        filename = "__Kontraptions__/data/torches/torch-shadow.png",
        priority = "extra-high",
        width = 91,
        height = 80,
        shift = torch_shift,
        repeat_count = 60,
        frame_count = 1,
        scale = 0.5,
        draw_as_shadow = true
      },
      active and {
        filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire.png",
        line_length = 10,
        width = 20,
        height = 40,
        frame_count = 60,
        animation_speed = 0.1,
        draw_as_glow = true,
        shift = {-0.025, -1.1},
        scale = 0.5
      } or nil
    }
  }
end

data:extend{
  {
    type = "item",
    name = "torch",
    icon = "__Kontraptions__/data/torches/torch-icon.png",
    icon_size = 64,
    subgroup = "energy",
    order = "c-a",
    place_result = "torch",
    stack_size = 64
  },
  {
    type = "recipe",
    name = "torch",
    enabled = "true",
    ingredients =
    {
      {"wood", 3},
      {"coal", 1}
    },
    result = "torch",
    energy_required = 0.1
  },
  {
    type = "burner-generator",
    name = "torch",
    localised_name = {"torch"},
    icon = "__Kontraptions__/data/torches/torch-icon.png",
    icon_size = 64,
    flags = {"placeable-player", "player-creation"},
    fast_replaceable_group = "torches",
    max_health = 25,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    max_power_output = "0.001W",
    minable = {mining_time = 0.1, result = "wood", count = 3},
    created_effect =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {

          {
            type = "insert-item",
            item = "coal"
          }
        }
      }
    },
    animation =
    {
      north = graphics(true),
      east = graphics(true),
      south = graphics(true),
      west = graphics(true)
    },
    idle_animation =
    {
      north = graphics(false),
      east = graphics(false),
      south = graphics(false),
      west = graphics(false)
    },
    burner =
    {
      fuel_category = "chemical",
      effectivity = 1,
      fuel_inventory_size = 1,
      emissions_per_minute = 0.1,
      smoke =
      {
        {
          name = "smoke",
          deviation = {0, 0},
          position = {0.1, -1.3},
          frequency = 1
        }
      },
      light_flicker =
      {
        light_intensity_to_size_coefficient = 5,
        color = {r = 0.6, g = 0.4, b = 0.1},
        minimum_intensity = 1,
        maximum_intensity = 1,
      }
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-output",
      buffer_capacity = "1TW",
      render_no_network_icon = false
    },
    vehicle_impact_sound = sounds.car_wood_impact(0.5),
    open_sound = { filename = "__base__/sound/wooden-chest-open.ogg", volume = 0.6 },
    close_sound = { filename = "__base__/sound/wooden-chest-close.ogg", volume = 0.6 },
  }
}
