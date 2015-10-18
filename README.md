Filetype Support for [Crystal](http://crystal-lang.org/)
========================================================
[![Build Status](https://travis-ci.org/rhysd/vim-crystal.svg?branch=travis)](https://travis-ci.org/rhysd/vim-crystal)

This is filetype support for [Crystal programming language](http://crystal-lang.org/).

- `crystal` filetype detection
- Syntax highlight
- Indentation
- vim-matchit support
- `crystal tool` integration ([implementations](http://crystal-lang.org/2015/09/05/tools.html), [context](http://crystal-lang.org/2015/09/05/tools.html), [formatter](http://crystal-lang.org/2015/10/16/crystal-0.9.0-released.html), and so on)
- `crystal spec` integration
- Syntax check (Using [Syntastic](https://github.com/scrooloose/syntastic))
- Completion (currently for variable names)



## Syntax Highlight

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/highlight1.png)

This plugin was firstly imported from Ruby's filetype plugin.  There are many differences between Ruby and Crystal but vim-crystal can't support all of them yet.  In addition, Crystal is growing rapidly and being added many changes.  If you've found some issues or points to improve, pull requests and issues are welcome.



## Spec Integration

![screen shot: run spec](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/spec.gif)

Running spec(s) and show the result in Vim.  The output is colorful if possible as executed in CLI.

### `:CrystalSpecSwitch` (mapping to `gss`)

It switches current source file and its spec file.  This command assumes the standard directory layout which `crystal init` generates.

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gss`.

### `:CrystalSpecRunAll` (mapping to `gsa`)

It runs the all specs for current file's project.

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gsa`.

### `:CrystalSpecRunCurrent` (mapping to `gsc`)

It runs spec for current buffer.

1. When current buffer is a spec source, `:CrystalSpecRunCurrent` runs the spec under the cursor.  You should execute this command after moving cursor to `it ... do` line or `describe ... do` line.
2. When current buffer is not a spec source, `:CrystalSpecRunCurrent` finds corresponding spec source and runs all specs in the source.

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gsa`.

## Formatter Integration

![format screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/formatting.gif)

You can run formatter manually by `:CrystalFormat` or automatically at saving buffer.

When you set `g:crystal_auto_format` to `1`, current buffer is automatically formatted on `BufWritePre`.  The variable is set to `0` by default because `crystal tool format` currently seems buggy.


## Tool Integration

### `:CrystalDef` (mapping to `gd`)

It makes cursor jump to the definition of name under the curosr.  This command uses `crystal tool implementations`.

![screenshort](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/jump-to-definition.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gd`.

### `:CrystalContext` (mapping to `gc`)

It shows the _context_ under the cursor. Context includes variable names and their types.

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/show-context.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gc`.

### `:CrystalHierarchy`

It shows types hierarchy of current code.

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/show-hierarchy.gif)



## Completion

Omni completion for crystal can be used by `<C-x><C-o>`.  (Please see `:help ins-completion`)

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/completion.gif)

Currently you can complete variable names.



## License

This plugin is distributed under the [MIT License](http://opensource.org/licenses/MIT).

    Copyright (c) 2014-2015 rhysd
