local UPDATE_INTERVAL = 269

local script_data =
{
  transceivers = {},
  channels = {},
  update_schedule = {}
}

local add_to_update_schedule = function(unit_number)
  local update_index = unit_number % UPDATE_INTERVAL
  local update_list = script_data.update_schedule[update_index]
  if not update_list then
    update_list = {}
    script_data.update_schedule[update_index] = update_list
  end
  update_list[unit_number] = true
end

local transceiver_created = function(event)
  local entity = event.source_entity
  if not (entity and entity.valid) then return end

  game.print("HEUK")

  local electric_source = entity.surface.create_entity
  {
    name = "circuit-network-transciever-electric-source",
    position = entity.position,
    force = entity.force
  }
  electric_source.destructible = false
  electric_source.minable = false

  local transceiver_data =
  {
    entity = entity,
    channel = "",
    electric_source = electric_source,
    connected = false,
    status_labels = {}
  }
  script_data.transceivers[entity.unit_number] = transceiver_data
  add_to_update_schedule(entity.unit_number)
  script.register_on_entity_destroyed(entity)
end

local triggers =
{
  ["circuit-network-transceiver-created"] = transceiver_created
}

local on_script_trigger_effect = function(event)
  local trigger = triggers[event.effect_id]
  if trigger then
    trigger(event)
  end
end

local on_robot_built_entity = function(event)
  -- Fires AFTER the script creation trigger.
end

local get_status_caption = function(connected)
  return connected and "[img=utility/status_working] Connected" or "[img=utility/status_not_working] Disconnected"
end

local transceiver_opened = function(entity, player)

  local transceiver_data = script_data.transceivers[entity.unit_number]
  local relative_gui = player.gui.relative.transceiver_gui
  if not relative_gui then
    relative_gui = player.gui.relative.add
    {
      type = "frame",
      name = "transceiver_gui",
      caption = "Transceiver settings",
      direction = "vertical",
      anchor =
      {
        gui = defines.relative_gui_type.storage_tank_gui,
        name = entity.name,
        position = defines.relative_gui_position.bottom
      }
    }
  end
  relative_gui.clear()
  relative_gui.style.horizontally_stretchable = false
  local inner = relative_gui.add
  {
    type = "frame",
    direction = "vertical",
    style = "entity_frame"
  }

  local status_flow = inner.add
  {
    type = "flow",
    direction = "horizontal"
  }

  status_flow.add
  {
    type = "label",
    caption = "Status:",
    style = "caption_label"
  }

  local status_label = status_flow.add
  {
    type = "label",
    name = "status_label",
    caption = get_status_caption(transceiver_data.connected)
  }

  table.insert(transceiver_data.status_labels, status_label)

  local flow = inner.add
  {
    type = "flow",
    direction = "horizontal",
  }

  flow.add
  {
    type = "label",
    caption = "Channel:",
    style = "caption_label"
  }

  local caption = transceiver_data.channel
  if caption == "" then
    caption = "[NO CHANNEL SET]"
  end
  flow.add
  {
    type = "label",
    caption = caption
  }

  flow.add
  {
    type = "sprite-button",
    sprite = "utility/rename_icon_small_black",
    style = "mini_button_aligned_to_text_vertically_when_centered",
    tags = {gui_action = "change_transceiver_channel"},
  }

end

local get_channels_list = function(current)
  local channels = {}
  local index = 0
  local k = 1
  for channel_name, channel in pairs(script_data.channels) do
    channels[k] = channel_name
    if channel_name == current then
      index = k
    end
    k = k + 1
  end
  return channels, index
end

local open_set_channel_window = function(gui)
  local player = game.get_player(gui.player_index)
  if not player then return end
  local transceiver_unit_number = player.opened and player.opened.unit_number
  if not transceiver_unit_number then return end
  local transceiver_data = script_data.transceivers[transceiver_unit_number]
  if not transceiver_data then return end

  local frame = player.gui.screen.add
  {
    type = "frame",
    direction = "vertical",
    name = "set_channel_window",
    tags = {opened_unit_number = transceiver_unit_number}
  }
  local header_flow = frame.add
  {
    type = "flow",
    direction = "horizontal"
  }
  local title = header_flow.add
  {
    type = "label",
    caption = "Set transciever channel",
    style = "frame_title"
  }
  title.drag_target = frame
  local filler = header_flow.add
  {
    type = "empty-widget",
    style = "draggable_space_header"
  }
  filler.style.horizontally_stretchable = true
  filler.style.height = 24
  filler.drag_target = frame
  header_flow.add
  {
    type = "sprite-button",
    sprite = "utility/close_white",
    style = "close_button",
    tooltip = "Close",
    tags = {gui_action = "close_set_channel_window"}
  }

  local inner_frame = frame.add
  {
    type = "frame",
    direction = "vertical",
    style = "inside_deep_frame"
  }

  local subheader = inner_frame.add
  {
    type = "frame",
    direction = "horizontal",
    style = "subheader_frame"
  }
  subheader.style.horizontally_stretchable = true

  local textfield = subheader.add
  {
    type = "textfield",
    tags = {gui_action = "set_transceiver_channel"},
    text = transceiver_data.channel
  }
  textfield.style.horizontally_stretchable = true
  textfield.style.maximal_width = 0
  textfield.focus()

  local confirm_button = subheader.add
  {
    type = "sprite-button",
    sprite = "utility/enter",
    style = "item_and_count_select_confirm",
    tags = {gui_action = "set_transceiver_channel_confirm"}
  }
  local list, selected_index = get_channels_list(transceiver_data.channel)
  local listbox = inner_frame.add
  {
    type = "list-box",
    name = "channel_list",
    items = list,
    tags = {gui_action = "copy_selected_channel"}
  }
  listbox.selected_index = selected_index
  listbox.style.horizontally_stretchable = true
  listbox.style.minimal_height = 250
  listbox.style.maximal_width = 500

  frame.force_auto_center()
  player.opened = frame
end

local surface_name = "transciever_channel_surface"
local get_transciever_surface = function()
  local surface = game.surfaces[surface_name]
  if not surface then
    surface = game.create_surface(surface_name, {width = 1, height = 1})
  end
  return surface
end

local get_channel_data_safe = function(name)
  local channel_data = script_data.channels[name]
  if not channel_data then
    local pole = get_transciever_surface().create_entity{name = "small-electric-pole", position = {0, 0}}
    pole.disconnect_neighbour()
    pole.destructible = false
    pole.minable = false
    channel_data =
    {
      pole = pole,
      transceivers = {}
    }
    script_data.channels[name] = channel_data
  end
  return channel_data
end

local disconnect_from_channel = function(unit_number, channel, check_prune)
  local transceiver_data = script_data.transceivers[unit_number]
  if not transceiver_data then return end

  local channel_data = get_channel_data_safe(channel)
  local pole = channel_data.pole

  local transceiver = transceiver_data.entity
  transceiver.disconnect_neighbour({wire = defines.wire_type.red, target_entity = pole})
  transceiver.disconnect_neighbour({wire = defines.wire_type.green, target_entity = pole})

  channel_data.transceivers[unit_number] = nil

  transceiver_data.connected = false

  if check_prune and not next(channel_data.transceivers) then
    channel_data.pole.destroy()
    script_data.channels[channel] = nil
  end

end

local connect_to_channel = function(unit_number, channel)
  local transceiver_data = script_data.transceivers[unit_number]
  if not transceiver_data then return end

  local channel_data = get_channel_data_safe(channel)
  local pole = channel_data.pole

  local transceiver = transceiver_data.entity
  transceiver.connect_neighbour({wire = defines.wire_type.red, target_entity = pole})
  transceiver.connect_neighbour({wire = defines.wire_type.green, target_entity = pole})

  channel_data.transceivers[unit_number] = true
  transceiver_data.connected = true

end

local update_transceiver = function(unit_number)
  local transceiver_data = script_data.transceivers[unit_number]
  if not transceiver_data then return true end

  local entity = transceiver_data.entity
  if not (entity and entity.valid) then return true end

  local channel = transceiver_data.channel
  if channel == "" then return end

  local energy_source = transceiver_data.electric_source
  local should_connect = energy_source.energy > 0
  if should_connect == transceiver_data.connected then return end

  if should_connect then
    connect_to_channel(unit_number, channel)
  else
    disconnect_from_channel(unit_number, channel)
  end
end

local set_transceiver_channel = function(unit_number, new_channel)
  local transceiver_data = script_data.transceivers[unit_number]
  if not transceiver_data then return end
  local old_channel = transceiver_data.channel
  if old_channel == new_channel then return end
  if old_channel ~= "" then
    disconnect_from_channel(unit_number, old_channel, true)
  end
  if new_channel ~= "" then
    connect_to_channel(unit_number, new_channel)
  end
  transceiver_data.channel = new_channel
  update_transceiver(unit_number)
end

local confirm_transciever_channel_from_textfield = function(gui)
  local player = game.get_player(gui.player_index)
  if not player then return end
  local opened = player.opened
  if not opened then return end
  local unit_number = opened.tags.opened_unit_number
  if not unit_number then return end
  set_transceiver_channel(unit_number, gui.text)
  player.opened = nil
end

local copy_selected_channel_from_listbox = function(gui)
  local textfield = gui.parent.children[1].children[1]
  if not textfield then return end
  local selected = gui.selected_index
  if selected < 1 then return end

  textfield.text = gui.get_item(selected)

end

local close_opened_window = function(gui)
  local player = game.get_player(gui.player_index)
  if not player then return end
  local opened = player.opened
  if not opened then return end
  player.opened = nil
end

local gui_click_actions =
{
  change_transceiver_channel = open_set_channel_window,
  set_transceiver_channel_confirm = function(gui) confirm_transciever_channel_from_textfield(gui.parent.children[1]) end,
  close_set_channel_window  = close_opened_window
}

local gui_confirm_actions =
{
  set_transceiver_channel = confirm_transciever_channel_from_textfield
}

local gui_selection_state_changed_actions =
{
  copy_selected_channel = copy_selected_channel_from_listbox
}

local on_gui_opened = function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if entity.name ~= "circuit-network-transceiver" then return end
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end
  game.print("OPEN")
  transceiver_opened(entity, player)
end

local create_gui_action = function(action_list)
  return function(event)
    local gui = event.element
    if not (gui and gui.valid) then return end
    local tags = gui.tags
    local action = tags.gui_action
    if not action then return end
    local gui_action = action_list[action]
    if not gui_action then return end
    gui_action(gui)
  end
end

local on_gui_click = create_gui_action(gui_click_actions)

local on_gui_confirm = create_gui_action(gui_confirm_actions)

local on_gui_selection_state_changed = create_gui_action(gui_selection_state_changed_actions)

local on_gui_closed = function(event)
  local gui = event.element
  if not (gui and gui.valid) then return end
  if gui.name ~= "set_channel_window" then return end
  local last_opened = gui.tags.opened_unit_number
  gui.destroy()
  if not last_opened then return end
  local player = game.get_player(event.player_index)
  if not (player and player.valid) then return end
  local transceiver_data = script_data.transceivers[last_opened]
  if not transceiver_data then return end
  local entity = transceiver_data.entity
  if not (entity and entity.valid) then return end
  player.opened = entity
end

local on_tick = function(event)
  local update_index = event.tick % UPDATE_INTERVAL
  local update_list = script_data.update_schedule[update_index]
  if not update_list then return end

  for unit_number, bool in pairs(update_list) do
    if update_transceiver(unit_number) then
      update_list[unit_number] = nil
      if not next(update_list) then
        script_data.update_schedule[update_index] = nil
      end
    end
  end

end

local lib = {}

lib.events =
{
  [defines.events.on_gui_opened] = on_gui_opened,
  [defines.events.on_gui_closed] = on_gui_closed,
  [defines.events.on_gui_click] = on_gui_click,
  [defines.events.on_gui_selection_state_changed] = on_gui_selection_state_changed,
  [defines.events.on_gui_confirmed] = on_gui_confirm,
  [defines.events.on_tick] = on_tick,
  [defines.events.on_script_trigger_effect] = on_script_trigger_effect,
  [defines.events.on_robot_built_entity] = on_robot_built_entity,
}

lib.on_init = function()
  global.circuit_network_transceivers = global.circuit_network_transceivers or script_data
end

lib.on_load = function()
  script_data = global.circuit_network_transceivers or script_data
end

return lib
