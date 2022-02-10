--motion sensor stuff

local moving_types =
{
  "car",
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
  "character",
  "spider-vehicle",
  "unit",
  "combat-robot",
  "logistic-robot",
  "construction-robot",
}

local target_mask_defaults = data.raw["utility-constants"].default.default_trigger_target_mask_by_type

for k, type in pairs(moving_types) do
  for k, prototype in pairs (data.raw[type]) do
    if prototype.is_military_target == nil then
      prototype.is_military_target = true
    end
    if prototype.trigger_target_mask == nil then
      prototype.trigger_target_mask = util.copy(target_mask_defaults[type]) or {"common"}
    end
    table.insert(prototype.trigger_target_mask, "motion")
    log(prototype.name .. serpent.line(prototype.trigger_target_mask))
  end
end