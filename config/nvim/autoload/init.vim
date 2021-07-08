function! s:AutoSaveWinView()
  if !exists('w:SavedBufView')
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr('%')] = winsaveview()
endfunction
function! s:AutoRestoreWinView()
  let l:buf = bufnr('%')
  if exists('w:SavedBufView') && has_key(w:SavedBufView, l:buf)
    let l:view = winsaveview()
    if l:view.lnum == 1 && l:view.col == 0 && !&diff
      call winrestview(w:SavedBufView[l:buf])
    endif
    unlet w:SavedBufView[l:buf]
  endif
endfunction

function init#setup()
  filetype plugin indent on  " needed for setting formatoptions https://github.com/neovim/neovim/issues/4684
  " TODO add user completion when this is merged https://github.com/neovim/neovim/pull/12995

  augroup AutoCommands
    autocmd!
    autocmd BufLeave * call s:AutoSaveWinView()
    autocmd BufEnter * call s:AutoRestoreWinView()
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
    autocmd BufWritePost plugins.lua PackerCompile
    autocmd FileType * setlocal formatoptions=jql
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
    autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :bdelete<CR>
    autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> bdelete! <bar> copen<CR>| nnoremap <buffer> <CR> <CR>| noremap <buffer> <C-q> :cclose <bar> TroubleToggle quickfix<CR>
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    autocmd BufEnter term://* startinsert
  augroup END

  command! -complete=file -nargs=* SetRunCommand let b:RunCommand = <q-args>
  command! -complete=file -nargs=* SetArgs let b:args = <q-args> == '' ? '' : ' '. <q-args>  " :SetArgs <args...><CR>, all execution will use args
  command! -complete=shellcmd -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr(). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | else | execute "put =execute('". <q-args>. "')" | endif | 1d
  command! W write !sudo tee %
  command! Grt Gcd

  if $SSH_CLIENT != ''  " ssh session
    call funcs#map_copy_with_osc_yank()
  elseif !has('macunix')  " WSL Vim
    call funcs#map_copy_to_win_clip()
  endif
endfunction
