--
-- Blightspell initialization code.
--

-- Initialize blightspell.
function blightspell_init()
  -- Hunspell format .aff and .dic paths.
  local aff_path = blightspell_settings.aff_path
  local dict_path = blightspell_settings.dict_path
  local lang = blightspell_settings.language
  local debug = blightspell_settings.debug

  blight.output(cformat(
    "%s <bold>spellchecking language: <green>%s<reset>", 
    blightspell_tag(), lang))
  if debug then
    blight.output(cformat(
      "%s <bold>dictionary path: <green>%s<reset>\n"..
      "%s <bold>AFF path: <green>%s<reset>",
      blightspell_tag(), dict_path, blightspell_tag(), aff_path))
  end

  spellcheck.init(aff_path, dict_path)

  blightspell_prompt_listener(prompt.get())
  blightspell_bindings_init()
  blight.output(cformat("%s <bold>spellchecking enabled<reset>", blightspell_tag()))
end

blightspell_init()

-- Set up required listeners and aliases.
prompt.add_prompt_listener(blightspell_prompt_listener)
alias.add("^/blightspell$", blightspell_settings_display)
alias.add("^/blightspell ((?:\\S+)) (.*)$", blightspell_settings_change)
alias.add("^/blightspell ([^ ]*)$", blightspell_settings_display)
