-- Blightspell
--
-- A real-time spellchecker script for the Blightmud MUD client.
-- Highlights misspelled words, offers suggestions for replacements, allows
-- easy movement between misspelled words.
--
-- Author: Daniel McCarney (@cpu) <daniel@binaryparadox.net>
-- Date: 2023-02-10
--

if _G["spellcheck"] == nil then
  blight.output(cformat(
    "<black:red>ERROR: <reset> <red>Your version of Blightmud is missing the "..
    "spellcheck API.\nThis plugin can not function without this "..
    "API.\nPlease update your Blightmud installation and try again.<reset>"))
else
  require("src/settings")
  require("src/spellcheck")
  require("src/listeners")
  require("src/bindings")
  require("src/init")
end
