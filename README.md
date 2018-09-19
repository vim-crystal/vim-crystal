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



## Installation

Please copy `autoload`, `ftdetect`, `ftplugin`, `indent`, `plugin` and `syntax` directories into your `~/.vim` (or `~/vimfiles` in Windows) directory.

```
$ cp -R autoload ftdetect ftplugin indent plugin syntax ~/.vim/

$ # If you use vim-syntastic
$ cp -R syntax_checkers ~/.vim/
```

If you use Vim8, `:packadd` is available to install. Please see `:help packages` for more detail.

Otherwise, please use your favorite plugin manager like [vim-plug](https://github.com/junegunn/vim-plug).



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

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gsc`.

## Formatter Integration

![format screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/formatting.gif)

You can run formatter manually by `:CrystalFormat` or automatically at saving buffer.

When you set `g:crystal_auto_format` to `1`, current buffer is automatically formatted on `BufWritePre`.  The variable is set to `0` by default because `crystal tool format` currently seems buggy.


## Tool Integration

### `:CrystalDef` (mapping to `gd`)

It makes cursor jump to the definition of name under the cursor.  This command uses `crystal tool implementations`.

![screenshort](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/jump-to-definition.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gd`.

### `:CrystalContext` (mapping to `gc`)

It shows the _context_ under the cursor. Context includes variable names and their types.

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/show-context.gif)

If you don't set `g:crystal_define_mappings` to 0, you can use this feature with mapping `gc`.

### `:CrystalHierarchy`

It shows types hierarchy of current code.

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/show-hierarchy.gif)

### `:CrystalImpl`

It shows how the identifier under the cursor is implemented. For example, when the cursor is on some
property of an object instance, `:CrystalImpl` would report where the property is defined with
`property` macro.

### `:CrystalExpand`

It expands macro invocation under the cursor.


## Completion

Omni completion for crystal can be used by `<C-x><C-o>`.  (Please see `:help ins-completion`)

![screenshot](https://raw.githubusercontent.com/rhysd/ss/master/vim-crystal/completion.gif)

Currently you can complete variable names.



## License

This plugin is distributed under the [MIT License](http://opensource.org/licenses/MIT).

```
Copyright (c) 2014 rhysd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
