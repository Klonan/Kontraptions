local transceiver =
{
  type = "storage-tank",
  name = "circuit-network-transceiver",
  localised_name = {"circuit-network-transceiver"},
  localised_description = {"circuit-network-transceiver-description"},
  icon = "__base__/graphics/icons/storage-tank.png",
  icon_size = 64,
  flags = {"placeable-player", "player-creation", "not-rotatable"},
  minable = {mining_time = 0.5, result = "storage-tank"},
  max_health = 500,
  corpse = "storage-tank-remnants",
  dying_explosion = "storage-tank-explosion",
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
    picture =
    {
      sheets =
      {
        {
          filename = "__base__/graphics/entity/storage-tank/hr-storage-tank.png",
          priority = "extra-high",
          frames = 2,
          width = 219,
          height = 215,
          shift = util.by_pixel(-0.25, 3.75),
          scale = 1/3
        },
      }
    },
    fluid_background = util.empty_sprite(),
    window_background = util.empty_sprite(),
    flow_sprite = util.empty_sprite(),
    gas_flow = util.empty_sprite(),
  },
  flow_length_in_ticks = 1,
  vehicle_impact_sound = sounds.generic_impact,
  open_sound = sounds.machine_open,
  close_sound = sounds.machine_close,

  circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points,
  circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites,
  circuit_wire_max_distance = default_circuit_wire_max_distance,
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
  }
}

local item =
{
  type = "item",
  name = "circuit-network-transceiver",
  localised_name = {"circuit-network-transceiver"},
  localised_description = {"circuit-network-transceiver-description"},
  icon = transceiver.icon,
  icon_size = 64,
  subgroup = "storage",
  order = "a[items]-c[circuit-network-transceiver]",
  place_result = "circuit-network-transceiver",
  stack_size = 50
}

local electric_source =
{
  type = "radar",
  name = "circuit-network-transciever-electric-source",
  localised_name = transceiver.localised_name,
  icon = transceiver.icon,
  icon_size = 64,
  flags = {},
  max_health = 15000,
  subgroup = "other",
  collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
  selection_box = {{-1, -1}, {1, 1}},
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
  pictures = util.empty_sprite(),
  energy_per_sector = "1J",
  energy_per_nearby_scan = "1J",
  max_distance_of_sector_revealed = 0,
  max_distance_of_nearby_sector_revealed = 0,
}

data:extend
{
  transceiver,
  item,
  electric_source
}