--
-- Blightspell event listeners.
--

-- set a prompt mask for misspelled words.
function blightspell_mask(buf)
  local mask = {}
  for idx, word in pairs(blightspell_badwords) do
    local off_idx = idx + #word
    mask[idx] = blightspell_settings.highlight
    mask[off_idx] = C_RESET
  end

  prompt_mask.set(buf, mask)
end

-- handle the prompt data buf being updated.
function blightspell_prompt_listener(buf)
  -- Build a world table and a misspelled word table for buf and keep them
  -- cached in globals so we can refer to them from other funcs without
  -- duplicating the work.
  blightspell_buf = buf
  blightspell_words = blightspell_word_table(blightspell_buf)
  blightspell_badwords = blightspell_misspelled(blightspell_buf)

  -- Also keep a table of sorted badword start indexes.
  blightspell_badwords_sorted = {}
  local i = 0
  for k, _ in pairs(blightspell_badwords) do
    i = i + 1
    blightspell_badwords_sorted[i] = k
  end
  table.sort(blightspell_badwords_sorted)

  -- TODO(XXX): Rename enabled to be specific to realtime masking.
  if blightspell_settings.enabled then
    -- Apply a prompt mask.
    blightspell_mask(blightspell_buf)
  end
end

blightspell_buf = ""
blightspell_words = {}
blightspell_badwords = {}
blightspell_badwords_sorted = {}
