" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufReadPost *.cr setlocal filetype=crystal
autocmd BufNewFile,BufReadPost shard.lock setlocal filetype=yaml
