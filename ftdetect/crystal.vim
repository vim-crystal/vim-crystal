" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufReadPost *.cr setlocal filetype=crystal
autocmd BufNewFile,BufReadPost Projectfile setlocal filetype=crystal
autocmd BufNewFile,BufReadPost *.html.ecr setlocal filetype=ecr.html
autocmd BufNewFile,BufReadPost *.ecr if &filetype !~# '^ecr.' | setlocal filetype=ecr | endif
