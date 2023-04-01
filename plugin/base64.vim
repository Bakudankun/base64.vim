vim9script

import autoload 'base64/map.vim'

:nnoremap <silent><expr> <Plug>(base64-encode) map.Base64({mode: 'encode'})
:nnoremap <silent><expr> <Plug>(base64-decode) map.Base64({mode: 'decode'})
:xnoremap <silent><expr> <Plug>(base64-encode) map.Base64({mode: 'encode'})
:xnoremap <silent><expr> <Plug>(base64-decode) map.Base64({mode: 'decode'})
:snoremap <silent> <Plug>(base64-encode) <C-G><Plug>(base64-encode)
:snoremap <silent> <Plug>(base64-decode) <C-G><Plug>(base64-decode)


if !exists('g:base64_config.auto_map') || g:base64_config.auto_map
  :nnoremap gb <Plug>(base64-encode)
  :nnoremap gB <Plug>(base64-decode)
  :nnoremap gbgb <Plug>(base64-encode)_
  :nnoremap gbb <Plug>(base64-encode)_
  :nnoremap gBgB <Plug>(base64-decode)_
  :nnoremap gBB <Plug>(base64-decode)_
  :xnoremap gb <Plug>(base64-encode)
  :xnoremap gB <Plug>(base64-decode)
endif


# vim: et sts=-1 sw=2
