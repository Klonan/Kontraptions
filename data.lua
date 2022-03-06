util = require("util")
sounds = require("__base__/prototypes/entity/sounds")
hit_effects = require ("__base__/prototypes/entity/hit-effects")
require("__Kontraptions__/data/data")

local confirm_hotkey =
{
  type = "custom-input",
  name = "confirm-hotkey",
  key_sequence = "CONTROL + SHIFT + 0",
  linked_game_control = "confirm-gui",
  consuming = "none"
}

data:extend
{
  confirm_hotkey,
}