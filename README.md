# Blightspell

An interactive spellchecker plugin for [Blightmud].

[Blightmud]: https://github.com/Blightmud/Blightmud.git

## Status

Presently this plugin requires unreleased Blightmud features. You must build
Blightmud from source in order to use this plugin.

## Features

* Interactive highlighting of misspelled words.
* Toggle spellcheck on/off.
* Show suggested replacements for misspelled words.
* Navigate between misspelled words using key bindings.
* Works with any [Hunspell] compatible dictionary.

[Hunspell]: https://hunspell.github.io/

## Demo

[![asciicast](https://asciinema.org/a/ZvMTNWBIOk1ib84isRUxrUHBu.svg)](https://asciinema.org/a/ZvMTNWBIOk1ib84isRUxrUHBu)

## Installation

From within Blightmud,

```
/add_plugin https://github.com/cpu/blightspell
/load_plugin blightspell
/enable_plugin blightspell
```

## Commands

| Command  | Effect                                                               |
| ---------|----------------------------------------------------------------------|
| `/blightspell [setting] [value]` | View or change plugin options. See [Configuration](#configuration) below. |
| `f1` (default) | Toggle blightspell on/off.                                       |
| `f2` (default) | Show misspelled word suggestions.                                |
| `alt-l` (default) | Move prompt cursor forward to the start of the next misspelled word.|
| `alt-k` (default) | Move prompt cursor backward to the start of the previous misspelled word. |

## Configuration

You can customize some Blightspell settings using the `/blightspell` command.
When supplied with no arguments, it will print your current settings. When
provided with a single argument (e.g. `/blightspell max_suggest`) it will print
the current value of that setting. When provided when two arguments, it will
change the setting (e.g. `/blightspell language en-CA`).

| Setting    | Default | Effect                                                   |
| -----------|---------|----------------------------------------------------------|
| enabled    | true | Controls whether real-time spellchecking on the input buffer is performed. |
| highlight  | `\x1b[4m` .. C_RED | ANSI control code to use to highlight misspelled prompt words. |
| max_suggest | 4 | Maximum number of misspelled word suggestions to display at a time. |
| language   | en |Spellcheck language. Built-in support for: en, en-CA, en-GB only. |
| aff_path   | built-in | Path to a Hunspell affix file to use for the chosen language. |
| dict_path  | built-in | Path to a Hunspell dictionary file to use for the chosen language. |
| toggle_binding | f1 | Key binding (or "" to disable) for toggling Blightspell on/off. |
| suggest_binding | f2 | Key binding (or "" to disable) for showing misspelled word suggestions. |
| misspelled_next_binding| alt-l | Key binding (or "" to disable) to move to the next misspelled word. |
| misspelled_prev_binding| alt-k | Key binding (or "" to disable) to move to the previous misspelled word. |
| debug      | false | Show extra debug information. |

Default values can be restored with `/blightspell defaults`.

## More Dictionaries

Blightspell only provides `en`, `en-CA` and `en-GB` dictionaries by default.
You can download other compatible dictionaries from the [woorm/dictionaries]
repository. See that project's [list of dictionaries][dict-list] for more
information.

If you are interested in a language that isn't supported, open an issue to have
it included, or download additional dictionaries yourself and configure
Blightspell to use them with:

```
/blightspell language <my-lang>
/blightspell aff_path <path to affix file>
/blightspell dict_path <path to dict file>
```

[woorm/dictionaries]: https://github.com/wooorm/dictionaries
[dict-list]: https://github.com/wooorm/dictionaries#list-of-dictionaries

## Future work

* Replacement of misspelled words in-line.
* ???

## Thanks

* [@LiquidityC] - for [Blightmud], and lots of input on the prompt masking API.
* [@lisdude] - for [blightmud-mcp][blightmud-mcp], a very helpful plugin writing
  reference.

[@LiquidityC]: https://github.com/liquidityc 
[@lisdude]: https://github.com/lisdude
[blightmud-mcp]: https://github.com/lisdude/blightmud_mcp
