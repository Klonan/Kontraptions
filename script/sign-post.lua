local MAX_TEXT_LENGTH = 1000
local TOOLTIP_DELAY = 20

local script_data =
{
  sign_posts = {},
  player_tooltips = {}
}

local init_sign_post_data = function(entity)
  local sign_post_data = script_data.sign_posts[entity.unit_number]
  if not sign_post_data then
    sign_post_data =
    {
      entity = entity,
      text = "",
      admins_only = false,
      always_show_message = false,
      tooltip = false,
      players_targeting = {}
    }
    script_data.sign_posts[entity.unit_number] = sign_post_data
    script.register_on_entity_destroyed(entity)
  end
  return sign_post_data
end

local determine_height = function(player)
  local scale = player.display_scale
  local screen_height = player.display_resolution.height
  local remaining_height = screen_height - ((252 + 150 + 24 + 40 + 24 + 24) * scale)
  return math.min(remaining_height, 400 * scale)
end

local sign_post_opened = function(entity, player)
  local sign_post_data = init_sign_post_data(entity)
  local relative_gui = player.gui.relative.sign_post_gui
  if not relative_gui then
    relative_gui = player.gui.relative.add
    {
      type = "frame",
      name = "sign_post_gui",
      caption = {"edit-text"},
      direction = "vertical",
      anchor =
      {
        gui = defines.relative_gui_type.pipe_gui,
        name = entity.name,
        position = defines.relative_gui_position.bottom
        --position = defines.relative_gui_position.right
      }
    }
  end
  relative_gui.clear()
  local inner = relative_gui.add
  {
    type = "frame",
    direction = "vertical",
    style = "entity_frame"
  }
  inner.style.height = determine_height(player)

  local textbox = inner.add
  {
    type = "text-box",
    text = sign_post_data.text,
    tags = {sign_post_action = "edit_text", sign_post_unit_number = entity.unit_number},
    style = "textbox",
  }

  local read_only = sign_post_data.admins_only and not player.admin

  textbox.read_only = read_only
  textbox.style.horizontally_stretchable = true
  textbox.style.vertically_stretchable = true
  textbox.style.minimal_width = 0
  textbox.style.width = 0
  textbox.word_wrap = true

  local h_flow = inner.add{type = "flow", direction = "horizontal", style = "player_input_horizontal_flow"}
  h_flow.add{type = "label", caption = {"sign-post-icon"}}
  local icon_picker = h_flow.add
  {
    type = "choose-elem-button",
    elem_type = "signal",
    signal = sign_post_data.icon,
    enabled = player.admin,
    tags = {sign_post_action = "change_icon", sign_post_unit_number = entity.unit_number},
    style = "slot_button_in_shallow_frame"
  }

  inner.add
  {
    type = "checkbox",
    caption = {"always-show-message"},
    tooltip = {"always-show-message-tooltip"},
    state = sign_post_data.always_show_message,
    enabled = not read_only,
    tags = {sign_post_action = "always_show_message", sign_post_unit_number = entity.unit_number}
  }

  inner.add
  {
    type = "checkbox",
    caption = {"edit-admins-only"},
    tooltip = {"edit-admins-only-tooltip"},
    state = sign_post_data.admins_only,
    enabled = player.admin,
    tags = {sign_post_action = "admins_only", sign_post_unit_number = entity.unit_number}
  }

end

local on_gui_opened = function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if entity.name ~= "sign-post" then return end
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end
  sign_post_opened(entity, player)
end

local update_admins_only = function(player, unit_number, new_state)
  if not player.admin then return end
  local sign_post_data = script_data.sign_posts[unit_number]
  if not sign_post_data then return end
  sign_post_data.admins_only = new_state
end

local signal_id_to_sprite = function(signal_id)
  local type = signal_id.type or ""
  local name = signal_id.name or ""
  local sprite_path
  if type == "virtual" then
    sprite_path = "virtual-signal" .."."..name
  else
    sprite_path = type.."."..name
  end

  if not game.is_valid_sprite_path(sprite_path) then
    return "utility/missing_icon"
  end

  return sprite_path

end

local update_icon = function(sign_post_data)
  local renderings = sign_post_data.icon_renderings
  if renderings then
    for k, id in pairs(renderings) do
      rendering.destroy(id)
    end
    sign_post_data.icon_renderings = nil
  end

  local icon = sign_post_data.icon
  if not icon then return end

  local entity = sign_post_data.entity
  if not entity or not entity.valid then return end

  local surface = entity.surface

  local new_renderings = {}

  table.insert(new_renderings, rendering.draw_light
  {
    sprite = "utility.light_small",
    --sprite = signal_id_to_sprite(icon),
    scale = 0.5,
    intensity = 0.8,
    target = entity,
    target_offset = {0, -0.5},
    surface = surface,
    forces = {entity.force},
    only_in_alt_mode = true
  })

  table.insert(new_renderings, rendering.draw_sprite
  {
    sprite = "utility.light_small",
    --sprite = signal_id_to_sprite(icon),
    x_scale = 0.5,
    y_scale = 0.5,
    tint = {1, 0.5, 0},
    target = entity,
    target_offset = {0, -0.5},
    surface = surface,
    forces = {entity.force},
    only_in_alt_mode = true
  })

  table.insert(new_renderings, rendering.draw_sprite
  {
    sprite = signal_id_to_sprite(icon),
    x_scale = 1,
    y_scale = 1,
    tint = {0, 0, 0, 0.5},
    target = entity,
    target_offset = {0 + 1/16, -0.5 + 1/16},
    surface = surface,
    forces = {entity.force},
    only_in_alt_mode = true
  })

  table.insert(new_renderings, rendering.draw_sprite
  {
    sprite = signal_id_to_sprite(icon),
    x_scale = nil,
    y_scale = nil,
    tint = nil,
    target = entity,
    target_offset = {0, -0.5},
    surface = surface,
    forces = {entity.force},
    only_in_alt_mode = true
  })


  sign_post_data.icon_renderings = new_renderings

end

local change_icon = function(player, unit_number, gui)
  if not player.admin then return end
  local sign_post_data = script_data.sign_posts[unit_number]
  if not sign_post_data then return end
  sign_post_data.icon = gui.elem_value
  update_icon(sign_post_data)
end

local create_tooltip = function(sign_post_data)
  local entity = sign_post_data.entity
  if not (entity and entity.valid) then return end

  local tooltip = sign_post_data.tooltip
  if tooltip and tooltip.valid then return end

  if sign_post_data.text == "" then return end

  sign_post_data.tooltip = entity.surface.create_entity
  {
    name = "compi-speech-bubble",
    position = entity.position,
    force = entity.force,
    direction = entity.direction,
    target = entity,
    text = sign_post_data.text,
  }

end

local clear_tooltip = function(sign_post_data)
  local tooltip = sign_post_data.tooltip
  if tooltip and tooltip.valid then
    tooltip.start_fading_out()
  end
  sign_post_data.tooltip = false
end

local update_tooltip = function(sign_post_data)
  if not sign_post_data.entity.valid then return end

  local should_show_tooltip = sign_post_data.always_show_message or next(sign_post_data.players_targeting)

  if should_show_tooltip then
    create_tooltip(sign_post_data)
  else
    clear_tooltip(sign_post_data)
  end
end

local update_always_show_message = function(player, unit_number, new_state)
  local sign_post_data = script_data.sign_posts[unit_number]
  if not sign_post_data then return end
  sign_post_data.always_show_message = new_state
  update_tooltip(sign_post_data)
end

local update_text = function(player, unit_number, gui)

  local sign_post_data = script_data.sign_posts[unit_number]
  if not sign_post_data then return end

  if sign_post_data.admins_only and not player.admin then
    player.print("You are not allowed to edit this sign post.")
    return
  end

  local text = gui.text

  if text:len() > MAX_TEXT_LENGTH then
    text = text:sub(1, MAX_TEXT_LENGTH)
    gui.text = text
    player.create_local_flying_text
    {
      text = {"text-too-long"},
      create_at_cursor = true,
    }
  end

  sign_post_data.text = text
  clear_tooltip(sign_post_data)
  update_tooltip(sign_post_data)
end

local on_gui_check_state_changed = function(event)
  local gui = event.element
  if not (gui and gui.valid) then return end

  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end

  local tags = gui.tags
  local action = tags.sign_post_action
  if not action then return end

  local unit_number = tags.sign_post_unit_number
  if not unit_number then return end

  if action == "admins_only" then
    update_admins_only(player, unit_number, gui.state)
    return
  end

  if action == "always_show_message" then
    update_always_show_message(player, unit_number, gui.state)
    return
  end
end

local on_gui_text_changed = function(event)
  local gui = event.element
  if not (gui and gui.valid) then return end

  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end

  local tags = gui.tags
  local action = tags.sign_post_action
  if not action then return end

  local unit_number = tags.sign_post_unit_number
  if not unit_number then return end

  if action == "edit_text" then
    update_text(player, unit_number, gui)
  end

end

local on_gui_elem_changed = function(event)
  local gui = event.element
  if not (gui and gui.valid) then return end

  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end

  local tags = gui.tags
  local action = tags.sign_post_action
  if not action then return end

  local unit_number = tags.sign_post_unit_number
  if not unit_number then return end

  if action == "change_icon" then
    change_icon(player, unit_number, gui)
  end

end

local clear_player_tooltip = function(player)
  local tooltip_data = script_data.player_tooltips[player.index]
  if not tooltip_data then return end

  script_data.player_tooltips[player.index] = nil

  local sign_post_data = script_data.sign_posts[tooltip_data.selected_unit_number]
  if not sign_post_data then return end

  local players_targeting = sign_post_data.players_targeting
  players_targeting[player.index] = nil

  update_tooltip(sign_post_data)

end

local show_player_tooltip = function(player)
  local tooltip_data = script_data.player_tooltips[player.index]
  if not tooltip_data then return end

  if tooltip_data.entity and tooltip_data.entity.valid then
    return
  end

  local entity = player.selected
  if not (entity and entity.valid) then return end

  if entity.name ~= "sign-post" then return end

  local sign_post_data = script_data.sign_posts[entity.unit_number]
  if not sign_post_data then return end

  sign_post_data.players_targeting[player.index] = true

  update_tooltip(sign_post_data)

end

local on_selected_entity_changed = function(event)
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end

  clear_player_tooltip(player)

  local entity = player.selected
  if not (entity and entity.valid) then return end
  if entity.name ~= "sign-post" then return end

  script_data.player_tooltips[player.index] =
  {
    tick_of_selection = event.tick,
    selected_unit_number = entity.unit_number
  }

end

local on_tick = function(event)
  for player_index, tooltip_data in pairs(script_data.player_tooltips) do
    if event.tick == tooltip_data.tick_of_selection + TOOLTIP_DELAY then
      show_player_tooltip(game.get_player(player_index))
    end
  end
end

local on_entity_settings_pasted = function(event)
  local destination = event.destination
  local source = event.source
  if not (destination and destination.valid) then return end
  if not (source and source.valid) then return end
  if destination.name ~= "sign-post" then return end
  if source.name ~= "sign-post" then return end
  local sign_post_data = script_data.sign_posts[source.unit_number]
  if not sign_post_data then return end

  local destination_data = init_sign_post_data(destination)
  destination_data.text = sign_post_data.text
  destination_data.admins_only = sign_post_data.admins_only
  destination_data.always_show_message = sign_post_data.always_show_message
  destination_data.icon = sign_post_data.icon

  clear_tooltip(destination_data)
  update_tooltip(destination_data)
  update_icon(destination_data)

end

local save_to_blueprint_tags = function(unit_number)

  local sign_post_data = script_data.sign_posts[unit_number]
  if not sign_post_data then return end

  return
  {
    text = sign_post_data.text,
    admins_only = sign_post_data.admins_only,
    always_show_message = sign_post_data.always_show_message,
    icon = sign_post_data.icon,
  }
end

local on_player_setup_blueprint = function(event)
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end

  local item = player.cursor_stack
  if not (item and item.valid_for_read) then
    item = player.blueprint_to_setup
    if not (item and item.valid_for_read) then return end
  end
  local count = item.get_blueprint_entity_count()
  if count == 0 then return end

  for index, entity in pairs(event.mapping.get()) do
    if entity.valid and entity.name == "sign-post" then
      local save_tags = save_to_blueprint_tags(entity.unit_number)
      if save_tags then
        if index <= count then
          item.set_blueprint_entity_tag(index, "sign_post_data", save_tags)
        end
      end
    end
  end

end

local restore_data_from_tags = function(entity, tags)

  local sign_post_tags = tags.sign_post_data
  if not sign_post_tags then return end

  local sign_post_data = init_sign_post_data(entity)
  sign_post_data.text = sign_post_tags.text
  sign_post_data.admins_only = sign_post_tags.admins_only
  sign_post_data.always_show_message = sign_post_tags.always_show_message
  sign_post_data.icon = sign_post_tags.icon
  update_tooltip(sign_post_data)
  update_icon(sign_post_data)

  --game.print("Loaded tags from blueprint")
end

local ghost_revived_event = function(event)
  local entity = event.created_entity or event.entity
  if not (entity and entity.valid) then return end
  if entity.name ~= "sign-post" then return end

  local tags = event.tags
  if not tags then return end

  restore_data_from_tags(entity, tags)
end

local on_entity_destroyed = function(event)
  if event.unit_number then
    script_data.sign_posts[event.unit_number] = nil
  end
end

local on_post_entity_died = function(event)
  local unit_number = event.unit_number
  if not unit_number then return end

  local sign_post_data = script_data.sign_posts[unit_number]
  if not sign_post_data then return end

  local ghost = event.ghost
  if not (ghost and ghost.valid) then return end

  local tags = ghost.tags or {}
  tags.sign_post_data = save_to_blueprint_tags(unit_number)
  ghost.tags = tags
end

local lib = {}

lib.events =
{
  [defines.events.on_gui_opened] = on_gui_opened,
  [defines.events.on_gui_text_changed] = on_gui_text_changed,
  [defines.events.on_gui_checked_state_changed] = on_gui_check_state_changed,
  [defines.events.on_gui_elem_changed] = on_gui_elem_changed,
  [defines.events.on_selected_entity_changed] = on_selected_entity_changed,
  [defines.events.on_tick] = on_tick,
  [defines.events.on_entity_settings_pasted] = on_entity_settings_pasted,
  [defines.events.on_player_setup_blueprint] = on_player_setup_blueprint,
  [defines.events.on_robot_built_entity] = ghost_revived_event,
  [defines.events.on_entity_destroyed] = on_entity_destroyed,
  [defines.events.on_post_entity_died] = on_post_entity_died,
  [defines.events.script_raised_revive] = ghost_revived_event,

}

lib.on_init = function()
  global.sign_posts = global.sign_posts or script_data
end

lib.on_load = function()
  script_data = global.sign_posts or script_data
end

return lib