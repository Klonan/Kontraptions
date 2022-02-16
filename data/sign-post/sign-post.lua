
pictures = function()
  return
  {
    straight_vertical_single =
    {
      layers =
      {
        {
          filename = "__Kontraptions__/data/sign-post/sign-post.png",
          priority = "extra-high",
          width = 150,
          height = 150,
          shift = util.by_pixel(-1.5, 0),
          scale = 0.5
        },
        {
          filename = "__Kontraptions__/data/sign-post/sign-post.png",
          priority = "extra-high",
          width = 150,
          x = 150,
          height = 150,
          shift = util.by_pixel(0, 0),
          scale = 0.5,
          draw_as_shadow = true
        },
      }
    },
    straight_vertical = util.empty_sprite(),
    straight_vertical_window = util.empty_sprite(),
    straight_horizontal_window = util.empty_sprite(),
    straight_horizontal = util.empty_sprite(),
    corner_up_right = util.empty_sprite(),
    corner_up_left = util.empty_sprite(),
    corner_down_right = util.empty_sprite(),
    corner_down_left = util.empty_sprite(),
    t_up = util.empty_sprite(),
    t_down = util.empty_sprite(),
    t_right = util.empty_sprite(),
    t_left = util.empty_sprite(),
    cross = util.empty_sprite(),
    ending_up = util.empty_sprite(),
    ending_down = util.empty_sprite(),
    ending_right = util.empty_sprite(),
    ending_left = util.empty_sprite(),
    horizontal_window_background = util.empty_sprite(),
    vertical_window_background = util.empty_sprite(),
    fluid_background = util.empty_sprite(),
    low_temperature_flow = util.empty_sprite(),
    middle_temperature_flow = util.empty_sprite(),
    high_temperature_flow = util.empty_sprite(),
    gas_flow = util.empty_sprite()
  }
end

local sign_post =
{
  type = "pipe",
  name = "sign-post",
  localised_name = {"sign-post"},
  localised_description = {"sign-post-description"},
  icon = "__Kontraptions__/data/sign-post/sign-post-icon.png",
  icon_size = 64,
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 2.5, result = "sign-post"},
  max_health = 50,
  corpse = "small-remnants",
  collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
  selection_box = {{-0.5, -0.75}, {0.5, 0.5}},
  fluid_box =
  {
    base_area = 1,
    --pipe_covers = pipecoverspictures(),
    pipe_connections =
    {
      --{ position = {0, -1} },
      --{ position = {1, 0} },
      --{ position = {0, 1} },
      --{ position = {-1, 0} }
    }
  },
  pictures = pictures(),
  horizontal_window_bounding_box = {{-0.25, -0.28125}, {0.25, 0.15625}},
  vertical_window_bounding_box = {{-0.28125, -0.5}, {0.03125, 0.125}},
  allow_copy_paste = true,
  additional_pastable_entities = {"sign-post"}

}

local sign_post_item =
{
  type = "item",
  name = "sign-post",
  icon = "__Kontraptions__/data/sign-post/sign-post-icon.png",
  icon_size = 64,
  subgroup = "circuit-network",
  order = "a[sign-post]",
  place_result = "sign-post",
  stack_size = 10
}

local recipe =
{
  type = "recipe",
  name = "sign-post",
  enabled = true,
  ingredients =
  {
    {"wood", 3}
  },
  result = "sign-post"
}

data:extend
{
  sign_post,
  sign_post_item,
  recipe

}