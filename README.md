Filetype Support for [Crystal](http://crystal-lang.org/)
========================================================

This is filetype support for [Crystal programming language](http://crystal-lang.org/).

- `crystal` filetype detection
- Syntax highlight
- Indentation
- vim-matchit support
- Syntax check (Using [Syntastic](https://github.com/scrooloose/syntastic))
- Jump to definition using [crystal tool implementations](http://crystal-lang.org/2015/09/05/tools.html)

## Syntax Highlight

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/highlight1.png)

This plugin was firstly imported from Ruby's filetype plugin.  There are many differences between Ruby and Crystal but vim-crystal can't support all of them yet.  In addition, Crystal is growing rapidly and being added many changes.  If you've found some issues or points to improve, pull requests and issues are welcome.

## Commands

### `:CrystalDef` (mapping to `gd`)

It makes cursor jump to the definition of name under the curosr.  This command uses `crystal tool implementations`.

![screenshort](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/jump-to-definition.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gd`.

## License

This plugin is distributed under the [MIT License](http://opensource.org/licenses/MIT).

    Copyright (c) 2014-2015 rhysd
