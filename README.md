Filetype Support for [Crystal](http://crystal-lang.org/)
========================================================

This is filetype support for [Crystal programming language](http://crystal-lang.org/).

- `crystal` filetype detection
- Syntax highlight
- Indentation
- vim-matchit support
- `crystal tool` integration ([implementations](http://crystal-lang.org/2015/09/05/tools.html), [context](http://crystal-lang.org/2015/09/05/tools.html) and so on)
- `crystal spec` integration
- Syntax check (Using [Syntastic](https://github.com/scrooloose/syntastic))
- Completion (currently for variable names)



## Syntax Highlight

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/highlight1.png)

This plugin was firstly imported from Ruby's filetype plugin.  There are many differences between Ruby and Crystal but vim-crystal can't support all of them yet.  In addition, Crystal is growing rapidly and being added many changes.  If you've found some issues or points to improve, pull requests and issues are welcome.



## Spec Integration

### `:CrystalSpecSwitch` (mapping to `gss`)

It switches current source file and its spec file.  This command assumes the standard directory layout which `crystal init` generates.

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gss`.

### `:CrystalSpecRunAll` (mapping to `gsa`)

It runs the all specs for current file's project.

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gsa`.

## Tool Integration

### `:CrystalDef` (mapping to `gd`)

It makes cursor jump to the definition of name under the curosr.  This command uses `crystal tool implementations`.

![screenshort](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/jump-to-definition.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gd`.

### `:CrystalContext` (mapping to `gc`)

It shows the _context_ under the cursor. Context includes variable names and their types.

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/show-context.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gc`.

### `:CrystalHierarychy`

It shows types hierarchy of current code.

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/show-hierarchy.gif)



## Completion

Omni completion for crystal can be used by `<C-x><C-o>`.  (Please see `:help ins-completion`)

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/completion.gif)

Currently you can complete variable names.



## License

This plugin is distributed under the [MIT License](http://opensource.org/licenses/MIT).

    Copyright (c) 2014-2015 rhysd
