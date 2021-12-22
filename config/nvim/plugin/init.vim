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

function! OrganizeImportsAndFormat()
  if !exists(':OrganizeImports')
    Neoformat
  else
    OrganizeImports
    call timer_start(500, { tid -> execute('Neoformat') })
  endif
endfunction

augroup AutoCommands
  autocmd!
  autocmd BufLeave * call s:AutoSaveWinView()
  autocmd BufEnter * call s:AutoRestoreWinView()
  autocmd BufReadPost * if !exists('b:RestoredCursor') && line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif | let b:RestoredCursor = 1
  autocmd BufWritePost */lua/plugins.lua source <afile> | PackerCompile
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup = "IncSearch", timeout = 300})
  autocmd FileType * setlocal formatoptions=jql
  autocmd FileType http set commentstring=#\ %s
  autocmd FileType netrw setlocal bufhidden=wipe | nmap <buffer> h [[<CR>^| nmap <buffer> l <CR>| nnoremap <buffer> <C-l> <C-w>l| nnoremap <buffer> <nowait> q :bdelete<CR>
  autocmd BufReadPost quickfix setlocal nobuflisted modifiable | nnoremap <buffer> <leader>w :let &l:errorformat='%f\|%l col %c\|%m,%f\|%l col %c%m' <bar> cgetbuffer <bar> silent! bdelete! <bar> copen<CR>| nnoremap <buffer> <CR> <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
  autocmd BufEnter term://* if line('$') <= line('w$') && len(filter(getline(line('.') + 1, '$'), 'v:val != ""')) == 0 | startinsert | endif
  autocmd User FugitiveIndex nmap <silent> <buffer> dt :Gtabedit <Plug><cfile><bar>Gdiffsplit! @<CR>
augroup END

command! -complete=file -nargs=* SetRunCommand let b:RunCommand = <q-args>
command! -complete=file -nargs=* SetArgs let b:args = <q-args> == '' ? '' : ' '. <q-args>  " :SetArgs <args...><CR>, all execution will use args
command! -complete=command -nargs=* -range -bang S execute 'botright new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | let b:RunCommand = "write !python3 -i" | if <line1> < <line2> | setlocal filetype='. &filetype. ' | put =getbufline('. bufnr(). ', <line1>, <line2>) | resize '. min([<line2>-<line1>+2, &lines * 2/5]). '| else | resize '. min([15, &lines * 2/5]). '| endif' | if '<bang>' != '' | execute 'read !'. <q-args> | else | execute "put =execute('". <q-args>. "')" | endif | 1d
command! -bang W if '<bang>' == '' | execute 'write !sudo tee % > /dev/null' | else | %yank | vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile | 0put='Enter password in terminal and press <lt>C-u>pa<lt>Esc>;w' | wincmd p | execute 'lua require("packer").loader("neoterm")' | execute "botright T sudo vim +'set paste' +'1,$d' +startinsert %" | endif
command! Grt execute "lua require('packer').loader('vim-fugitive')" | Gcd
command! SaveSession mksession! ~/.cache/nvim/session.vim | lua vim.notify("Session saved to ~/.cache/nvim/session.vim")
command! LoadSession source ~/.cache/nvim/session.vim | lua vim.notify("Loaded session from ~/.cache/nvim/session.vim")
command! -nargs=* GrepRegex lua require("telescope.builtin").grep_string({path_display = {"smart"}, use_regex = true, search = <q-args>})
command! -nargs=* GrepNoRegex lua require("telescope.builtin").grep_string({path_display = {"smart"}, search = <q-args>})

if $SSH_CLIENT != ''  " ssh session
  call funcs#map_copy_with_osc_yank()
elseif !has('macunix')  " WSL Vim
  call funcs#map_copy_to_win_clip()
endif
