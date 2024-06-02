--
-- Blightspell settings management.
--
-- Credit to github.com/lisdude/blightmud_mcp for inspiration for
-- settings handling :)
--

local plugin_name = "blightspell"

-- Formatting tag used for output printing.
function blightspell_tag()
  return cformat("<bold>[<green>%s<reset><bold>]<reset>", plugin_name)
end

-- Compute path to a dict resource within the plugin data dir.
function resource_path(lang, typ)
  return string.format("%s/plugins/%s/dictionaries/%s/index.%s",
    blight.data_dir(), plugin_name, lang, typ)
end

-- Initialize blightspell default settings, saving them to disk. Settings
-- won't take effect until blightspell_settings_init() is called to load
-- the defaults that were saved.
function blightspell_defaults_init()
  local defaults = {
    -- Enable spellchecking by default.
    enabled = true,
    -- Use red + underline as the default spellcheck highlight.
    highlight = "\x1b[4m" .. C_RED,
    -- Limit the number of suggestions provided.
    max_suggest = 4,
    -- Toggle spellcheck binding.
    toggle_binding = "f1",
    -- Show spellcheck suggestions.
    suggest_binding = "f2",
    -- Move to next misspelled word.
    misspelled_next_binding = "alt-l",
    -- Move to prev misspelled word.
    misspelled_prev_binding = "alt-k",
    -- Spellcheck language.
    language = "en",
    -- Hunspell format .aff and .dic paths.
    aff_path = resource_path("en", "aff"),
    dict_path = resource_path("en", "dic"),
    -- Extra debug output.
    debug = false
  }
  store.disk_write(plugin_name, json.encode(defaults))
end

-- Save the current settings to disk.
function blightspell_settings_save()
  store.disk_write(plugin_name, json.encode(blightspell_settings))
end

-- Read settings from disk and load them.
function blightspell_settings_init()
  blightspell_settings = json.decode(store.disk_read(plugin_name))
end

-- Display current settings, a particular setting, or reset settings to default.
-- Usage:
--   blightspell_settings_display() - show all settings.
--   blightspell_settings_display("foo") - show "foo" setting.
--   blightspell_settings_display("defaults") - reset to default settings.
function blightspell_settings_display(args)
  if #args == 1 then
    for key, value in pairs(blightspell_settings) do
      blight.output(cformat(
        "%s <green>%s => %s<reset>",
        blightspell_tag(), key, tostring(value)))
    end
    blight.output(cformat(
      "%s <bold>Use '/blightspell defaults' to reset settings to defaults.<reset>", 
      blightspell_tag()))
  elseif args[2] == "defaults" then
    blightspell_defaults_init()
    blightspell_settings_init()
    blightspell_init()
    blight.output(cformat(
      "%s <bold>Default settings restored<bold>", blightspell_tag()))
  else
    if blightspell_settings[args[2]] == nil then
      blight.output(cformat(
        "%s <red>setting %s does not exist<reset>",
        blightspell_tag(), args[2]))
    else
      blight.output(cformat(
        "%s <green>%s => %s<reset>",
        blightspell_tag(), args[2], tostring(blightspell_settings[args[2]])))
    end
  end
end

-- Change a blightspell setting.
-- Usage:
--   blightspell_settings_change("foo bar") - change "foo" to "bar".
function blightspell_settings_change(args)
  local arg = args[2]
  local val = args[3]
  if blightspell_settings[arg] == nil then
    blight.output(cformat(
      "%s <red>setting %s does not exist<reset>",
      blightspell_tag(), arg))
  else
    -- Some settings require special shenanigans:
    if arg == "max_suggest" then
      val = tonumber(val)
    elseif arg == "enabled" or arg == "debug" then
      val = val == "true" and true or false
    elseif arg == "toggle_binding" or arg == "suggest_binding" 
      or arg == "misspelled_next_binding" or arg == "misspelled_prev_binding" then
      -- remove old bindings first (if any)
      blightspell_bindings_rm()
    end

    if arg == "language" then
      blightspell_settings.aff_path = resource_path(val, "aff")
      blightspell_settings.dict_path = resource_path(val, "dic")
    end

    blightspell_settings[arg] = val
    blightspell_settings_save()
    blight.output(cformat(
      "%s <green>%s => %s<reset>",
      blightspell_tag(), arg, tostring(val)))

    -- TODO(XXX): This is clumsy.
    if arg == "toggle_binding" or arg == "suggest_binding" or 
      arg == "misspelled_next_binding" or arg == "misspelled_prev_binding" or
      arg == "language" or arg == "dict_path" or arg == "aff_path" then
      -- reinit plugin
      blightspell_init()
    end
  end
end

-- Store defaults on first run.
if store.disk_read(plugin_name) == nil then
  blightspell_defaults_init()
end

blightspell_settings_init()
