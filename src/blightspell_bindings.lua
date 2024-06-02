--
-- Blightspell command bindings and associated functions.
--

--
-- TODO(XXX): lots of crummy duplication here. Clean it up soon.
--

-- Set up bindings based on settings.
function blightspell_bindings_init()
  if blightspell_settings.toggle_binding ~= nil then
    blight.bind(blightspell_settings.toggle_binding, blightspell_toggle)
  end

  if blightspell_settings.suggest_binding ~= nil then
    blight.bind(blightspell_settings.suggest_binding, blightspell_suggestions_show)
  end

  if blightspell_settings.misspelled_next_binding ~= nil then
    blight.bind(blightspell_settings.misspelled_next_binding, blightspell_move_next)
  end

  if blightspell_settings.misspelled_prev_binding ~= nil then
    blight.bind(blightspell_settings.misspelled_prev_binding, blightspell_move_prev)
  end
end

-- Remove bindings set up by blightspell_bindings_init().
function blightspell_bindings_rm()
  if blightspell_settings.toggle_binding ~= nil then
    blight.unbind(blightspell_settings.toggle_binding)
  end

  if blightspell_settings.suggest_binding ~= nil then
    blight.unbind(blightspell_settings.suggest_binding)
  end

  if blightspell_settings.misspelled_next_binding ~= nil then
    blight.unbind(blightspell_settings.misspelled_next_binding)
  end

  if blightspell_settings.misspelled_prev_binding ~= nil then
    blight.unbind(blightspell_settings.misspelled_prev_binding)
  end
end

-- toggle spellcheck on/off.
function blightspell_toggle()
  if blightspell_settings.enabled then
    blightspell_settings.enabled = false
    prompt_mask.clear()
    blight.output(cformat(
      "%s <bold>spellchecking disabled<reset>", blightspell_tag()))
  else
    blightspell_settings.enabled = true
    blight.output(cformat(
      "%s <bold>spellchecking enabled<reset>", blightspell_tag()))
    blightspell_prompt_listener(blightspell_buf)
  end

  blightspell_settings_save()
end

-- show suggestions for each of the misspelled words in the prompt buffer.
function blightspell_suggestions_show()
  for _, word in pairs(blightspell_badwords) do
    local suggestions = blightspell_suggestions(word)
    local suggestions_str = "No suggestions found."
    if #suggestions > 0 then
      suggestions_str = cformat("<bold>Did you mean: <green>%s<reset>",
        table.concat(suggestions, ", "))
    end
    blight.output(cformat(
      "%s <bold>Misspelled word: '<red>%s<reset>'\n"..
      "%s %s<reset>", 
      blightspell_tag(), word, blightspell_tag(), suggestions_str))
  end
end

-- move backwards to the previous misspelled word.
function blightspell_move_prev()
  local cursor_pos = prompt.get_cursor_pos()
  for i=#blightspell_badwords_sorted, 1, -1 do
    local start = blightspell_badwords_sorted[i]
    if start < cursor_pos then
      prompt.set_cursor_pos(start)
      return
    end
  end
  -- Wrap around
  if #blightspell_badwords_sorted > 0 then
      prompt.set_cursor_pos(blightspell_badwords_sorted[#blightspell_badwords_sorted])
  end
end

-- move forwards to the next misspelled word.
function blightspell_move_next()
  local cursor_pos = prompt.get_cursor_pos()
  for _, start in pairs(blightspell_badwords_sorted) do
    if start > cursor_pos then
      prompt.set_cursor_pos(start)
      return
    end
  end
  -- Wrap around
  if #blightspell_badwords_sorted > 0 then
      prompt.set_cursor_pos(blightspell_badwords_sorted[1])
  end
end
