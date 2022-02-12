local automatic_circuit_wire_technology =
{
  type = "technology",
  name = "automatic-circuit-wire",
  localised_name = {"automatic-circuit-wire"},
  localised_description = {"automatic-circuit-wire-description"},
  icon = "__Kontraptions__/data/automatic-circuit-wire/automatic-circuit-wire-tech-icon.png",
  icon_size = 128,
  effects ={},
  prerequisites = {"circuit-network"},
  unit =
  {
    count = 200,
    ingredients =
    {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1}
    },
    time = 30
  }
}

data:extend
{
  automatic_circuit_wire_technology
}