local spinny_boi = function(in_vis)
  local shift = in_vis and {0, -3.5} or {0, -3.7}
  return
  {
    layers =
    {
      {
        filename = "__base__/graphics/entity/roboport/hr-roboport-base-animation.png",
        width = 83,
        height = 59,
        --frame_count = 8,
        direction_count = 8,
        animation_speed = 0.5,
        shift = shift,
        scale = 0.66
      },
      {
        filename = "__base__/graphics/entity/roboport/hr-roboport-base-animation.png",
        width = 83,
        height = 59,
        --frame_count = 8,
        direction_count = 8,
        animation_speed = 0.5,
        shift = {3.7, -0.1},
        scale = 0.66,
        draw_as_shadow = true
      },
    }
  }
end

local sprite =
{
  layers =
  {
    {
      filename = "__Kontraptions__/data/circuit-network-transceiver/circuit-network-transceiver.png",
      width = 150,
      height = 310,
      shift = {0,-1.45},
      scale = 0.5
    },
    {
      filename = "__Kontraptions__/data/circuit-network-transceiver/circuit-network-transceiver-shadow.png",
      width = 310,
      height = 150,
      shift = {1.45, -0.1},
      scale = 0.5,
      draw_as_shadow = true
    },
  }
}

local transceiver =
{
  type = "storage-tank",
  name = "circuit-network-transceiver",
  localised_name = {"circuit-network-transceiver"},
  localised_description = {"circuit-network-transceiver-description"},
  icon = "__Kontraptions__/data/circuit-network-transceiver/circuit-network-transceiver-icon.png",
  icon_size = 64,
  flags = {"placeable-player", "player-creation", "not-rotatable"},
  minable = {mining_time = 0.5, result = "circuit-network-transceiver"},
  max_health = 500,
  corpse = "medium-remnants",
  selection_priority = 0,
  collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
  selection_box = {{-1, -1}, {1, 1}},
  damaged_trigger_effect = hit_effects.entity(),
  fluid_box =
  {
    base_area = 1,
    pipe_connections = {}
  },
  two_direction_only = true,
  window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}},
  pictures =
  {
    picture = sprite,
    fluid_background = util.empty_sprite(),
    window_background = util.empty_sprite(),
    flow_sprite = util.empty_sprite(),
    gas_flow = util.empty_sprite(),
  },
  flow_length_in_ticks = 1,
  vehicle_impact_sound = sounds.generic_impact,
  open_sound = sounds.machine_open,
  close_sound = sounds.machine_close,
  allow_copy_paste = true,
  additional_pastable_entities = {"circuit-network-transceiver"},
  circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points,
  circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites,
  circuit_wire_max_distance = 15,
  created_effect =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        type = "script",
        effect_id = "circuit-network-transceiver-created"
      }
    }
  },
  radius_visualisation_specification =
  {
    sprite =
    {
      layers =
      {
        spinny_boi(true),
        spinny_boi(true),
      }
    },
    distance = 0.66,
    offset = {0, 0},
    draw_on_selection = false,
    draw_in_cursor = true
  },
}

local item =
{
  type = "item",
  name = "circuit-network-transceiver",
  localised_name = {"circuit-network-transceiver"},
  localised_description = {"circuit-network-transceiver-description"},
  icon = transceiver.icon,
  icon_size = 64,
  subgroup = "circuit-network",
  order = "k[kontraptions]-c[circuit-network-transceiver]",
  place_result = "circuit-network-transceiver",
  stack_size = 10
}

local recipe =
{
  type = "recipe",
  name = "circuit-network-transceiver",
  localised_name = {"circuit-network-transceiver"},
  localised_description = {"circuit-network-transceiver-description"},
  enabled = false,
  ingredients =
  {
    {"electronic-circuit", 10},
    {"steel-plate", 10},
    {"radar", 1},
  },
  result = "circuit-network-transceiver"
}

local technology =
{
  type = "technology",
  name = "circuit-network-transceiver",
  localised_name = {"circuit-network-transceiver"},
  localised_description = {"circuit-network-transceiver-description"},
  icon = "__Kontraptions__/data/circuit-network-transceiver/circuit-network-transceiver-tech-icon.png",
  icon_size = 128,
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = "circuit-network-transceiver"
    }
  },
  prerequisites = {"circuit-network"},
  unit =
  {
    count = 500,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1},
    },
    time = 30
  },
  order = "k[kontraptions]-c[circuit-network-transceiver]"
}

local electric_source =
{
  type = "radar",
  name = "circuit-network-transciever-electric-source",
  localised_name = transceiver.localised_name,
  icon = transceiver.icon,
  icon_size = 64,
  flags = {"placeable-off-grid"},
  max_health = 15000,
  subgroup = "other",
  collision_box = {{-0.9, -1.0}, {0.9, 0.8}},
  selection_box = {{-1, -1.1}, {1, 0.9}},
  allow_copy_paste = false,
  selectable_in_game = false,
  energy_source =
  {
    type = "electric",
    buffer_capacity = "10MJ",
    usage_priority = "secondary-input",
  },
  energy_production = "0W",
  energy_usage = "500kW",
  pictures = spinny_boi(false),
  energy_per_sector = "1J",
  energy_per_nearby_scan = "1J",
  max_distance_of_sector_revealed = 0,
  max_distance_of_nearby_sector_revealed = 0,
  rotation_speed = 1/16,
}

data:extend
{
  transceiver,
  item,
  electric_source,
  recipe,
  technology
}