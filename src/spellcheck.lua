-- always consider the following words valid.
-- TODO(XXX): support some kind of user dictionary!
local ignore_words = {
  ["blightmud"]=true,
  ["Blightmud"]=true,
  ["blightspell"]=true,
}

-- convert buf to a table of words, indexed by their start location in buf.
function blightspell_word_table(buf)
  local words = {}
  local word_start = 1
  for i = 1, #buf do
    local c = buf:sub(i, i)
    local stop = c:find("[%s]")

    function strip_outer_punctuation(word)
      return string.gsub(string.gsub(word, '[%p]+$', ''), '^[%p]+', '')
    end

    if stop ~= nil then
      local word = buf:sub(word_start, i - 1)
      words[word_start] = strip_outer_punctuation(word)
      word_start = i + 1
    elseif i == #buf then
      local word = buf:sub(word_start, i)
      words[word_start] = strip_outer_punctuation(word)
    end
  end

  return words
end

-- return a table of misspelled words found in blightspell_word_table keyed by
-- where the word begins.
function blightspell_misspelled()
  local result = {}
  for idx, word in pairs(blightspell_words) do
    if ignore_words[word] == nil and spellcheck.check(word) == false then
      result[idx] = word
    end
  end

  return result
end

-- get a table of up to max_suggest suggestions for the given word.
function blightspell_suggestions(word)
  local max_suggest = blightspell_settings.max_suggest

  local suggestions = spellcheck.suggest(word)
  if #suggestions >= max_suggest then
    suggestions = {table.unpack(suggestions, 1, max_suggest)}
  end

  return suggestions
end
