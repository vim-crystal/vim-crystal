" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufReadPost *.cr setlocal filetype=crystal
autocmd BufNewFile,BufReadPost Projectfile setlocal filetype=crystal
