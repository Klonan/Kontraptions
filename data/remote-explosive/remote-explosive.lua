local EXPLOSION_RADIUS = 12
local animations =
{
  layers =
  {
    {
      filename = "__Kontraptions__/data/remote-explosive/remote-explosive.png",
      priority = "extra-high",
      width = 100,
      height = 100,
      shift = util.by_pixel(-1.5, -4),
      scale = 0.5,
      frame_count = 1
    },
    {
      filename = "__base__/graphics/entity/steel-chest/hr-steel-chest-shadow.png",
      priority = "extra-high",
      width = 110,
      height = 46,
      shift = util.by_pixel(12.25, 8),
      draw_as_shadow = true,
      scale = 0.5,
      frame_count = 1
    }
  }
}

local connection_point = function()
  return
  {
    shadow =
    {
      red = util.by_pixel(40, 8),
      green = util.by_pixel(40, 8)
    },
    wire =
    {
      red = util.by_pixel(1.5, -25),
      green = util.by_pixel(0.5, -24)
    }
  }
end

local circuit_picture = function()
  return
  {
    led_red = util.empty_sprite(),
    led_green = util.empty_sprite(),
    led_blue = util.empty_sprite(),
    led_light = {size = 0, intensity = 0}
  }
end

local pump =
{
  type = "pump",
  name = "remote-explosive",
  localised_name = {"remote-explosive"},
  localised_description = {"remote-explosive-description"},
  icon = "__Kontraptions__/data/remote-explosive/remote-explosive-icon.png",
  icon_size = 64,
  is_military_target = true,
  flags = {"placeable-neutral", "player-creation", "not-rotatable"},
  minable = {mining_time = 0.5, result = "remote-explosive"},
  max_health = 250,
  dying_explosion = "big-artillery-explosion",
  collision_box = {{-0.25, -0.25}, {0.25, 0.25}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  circuit_wire_max_distance = EXPLOSION_RADIUS * 2,
  circuit_wire_connection_points =
  {
    connection_point(),
    connection_point(),
    connection_point(),
    connection_point()
  },
  circuit_connector_sprites =
  {
    circuit_picture(),
    circuit_picture(),
    circuit_picture(),
    circuit_picture(),
  },
  fluid_box =
  {
    base_area = 1,
    --pipe_covers = pipecoverspictures(),
    pipe_connections =
    {
      { position = {0, 1}, type = "input" },
      { position = {0, -1} }
    }
  },
  energy_source =
  {
    type = "void"
  },
  energy_usage = "1W",
  pumping_speed = 1,
  animations =
  {
    north = animations,
    east = animations,
    south = animations,
    west = animations
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
        effect_id = "remote-explosive-created"
      }
    }
  },

  dying_trigger_effect =
  {
    {
      type = "nested-result",
      action =
      {
        type = "area",
        radius = EXPLOSION_RADIUS,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "damage",
              damage = { amount = 250, type = "explosion"}
            },
            {
              type = "create-sticker",
              sticker = "stun-sticker"
            }
          }
        }
      }
    },
    {
      type = "nested-result",
      action =
      {
        type = "area",
        radius = EXPLOSION_RADIUS,
        target_entities = false,
        repeat_count = 25,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion"
            }
          }
        }
      }
    },
    {
      type = "create-entity",
      entity_name = "medium-scorchmark-tintable",
      check_buildability = true
    },
    {
      type = "invoke-tile-trigger",
      repeat_count = 1
    },
    {
      type = "destroy-decoratives",
      from_render_layer = "decorative",
      to_render_layer = "object",
      include_soft_decoratives = true,
      include_decals = false,
      invoke_decorative_trigger = true,
      decoratives_with_trigger_only = false,
      radius = 3.5
    },
    {
      type = "create-trivial-smoke",
      smoke_name = "artillery-smoke",
      initial_height = 0,
      speed_from_center = 0.05,
      speed_from_center_deviation = 0.005,
      offset_deviation = {{-EXPLOSION_RADIUS, -EXPLOSION_RADIUS}, {EXPLOSION_RADIUS, EXPLOSION_RADIUS}},
      max_radius = EXPLOSION_RADIUS,
      repeat_count = 4 * 4 * 15 * 5
    },
    {
      type = "show-explosion-on-chart",
      scale = 5/32
    }
  },
  radius_visualisation_specification =
  {
    sprite =
    {
      filename = "__Kontraptions__/data/remote-explosive/radius-visualisation.png",
      width = 128,
      height = 128
    },
    distance = EXPLOSION_RADIUS,

  }
}

local pump_item =
{
  type = "item",
  name = "remote-explosive",
  localised_name = {"remote-explosive"},
  localised_description = {"remote-explosive-description"},
  icon = "__Kontraptions__/data/remote-explosive/remote-explosive-icon.png",
  icon_size = 64,
  subgroup = "circuit-network",
  order = "a[remotes]-a[remote-explosive]",
  place_result = "remote-explosive",
  stack_size = 10
}

local fluid_turret =
{
  type = "fluid-turret",
  name = "remote-explosive-turret",
  icon = "__Kontraptions__/data/remote-explosive/remote-explosive-icon.png",
  icon_size = 64,
  flags = {"not-rotatable"},
  collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  selectable_in_game = false,
  collision_mask = {},
  base_picture = util.empty_sprite(),
  fluid_box =
  {
    base_area = 1,
    --pipe_covers = pipecoverspictures(),
    pipe_connections =
    {
      { position = {0, -1} }
    }
  },
  fluid_buffer_size = 1,
  fluid_buffer_input_flow = 1, -- 5s to fill the buffer
  activation_buffer_ratio = 0.1,

  attack_parameters =
  {
    type = "stream",
    cooldown = 60,
    range = 1,
    turn_range = 0.1,
    fluids =
    {
      {type = "water"}
    },
    fluid_consumption = 0.1,
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
            effect_id = "remote-explosive-triggered"
          }
        }
      }
    }
  },
  folded_animation = util.empty_sprite(),
  call_for_help_radius = 0,
  turret_base_has_direction = true,
  out_of_ammo_alert_icon = util.empty_sprite()
}

local invisible_pump =
{
  type = "pump",
  name = "invisible-pump",
  icon = "__Kontraptions__/data/remote-explosive/remote-explosive-icon.png",
  icon_size = 64,
  flags = {"not-rotatable"},
  max_health = 50,
  collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  collision_mask = {},
  selectable_in_game = false,
  fluid_box =
  {
    base_area = 1,
    --pipe_covers = pipecoverspictures(),
    pipe_connections =
    {
      { position = {0, -1} }
    }
  },
  energy_source =
  {
    type = "void"
  },
  energy_usage = "1W",
  pumping_speed = 1,
  animations =
  {
    north = util.empty_sprite(),
    east = util.empty_sprite(),
    south = util.empty_sprite(),
    west = util.empty_sprite()
  },
}

local remote_explosive_recipe =
{
  type = "recipe",
  name = "remote-explosive",
  enabled = false,
  ingredients =
  {
    {"steel-chest", 1},
    {"explosives", 10}
  },
  result = "remote-explosive"
}

local remote_explosive_technology =
{
  type = "technology",
  name = "remote-explosive",
  localised_name = {"remote-explosive"},
  localised_description = {"remote-explosive-description"},
  icon = "__Kontraptions__/data/remote-explosive/remote-explosive-tech-icon.png",
  icon_size = 128,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "remote-explosive"
    },
  },
  prerequisites = {"explosives"},
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
  order = "a-d-a"
}

data:extend
{
  pump,
  pump_item,
  fluid_turret,
  invisible_pump,
  remote_explosive_recipe,
  remote_explosive_technology,

}