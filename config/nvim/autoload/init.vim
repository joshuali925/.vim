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
  command! -complete=shellcmd -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | resize '. min([15, &lines * 2/5]). '| if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr(). ', <line1>, <line2>) | endif' | if '<bang>' != '' | execute 'read !'. <q-args> | else | execute "put =execute('". <q-args>. "')" | endif | 1d
  command! W write !sudo tee %

  if $SSH_CLIENT != ''  " ssh session
    function! s:CopyWithOSCYank(str)
      let @" = a:str
      OSCYankReg "
    endfunction
    call funcs#map_action('CopyWithOSCYank', '<leader>y')
    nmap <leader>Y <leader>y$
  elseif !has('macunix') && !has('gui_running')  " WSL Vim
    function! s:CopyToWinClip(str)
      call system('clip.exe', a:str)
    endfunction
    call funcs#map_action('CopyToWinClip', '<leader>y')
    nmap <leader>Y <leader>y$
  endif
endfunction
