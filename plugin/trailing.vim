let s:max_size = get(g:, 'trailing_max_size', 50) * 1024 * 1024

function! s:checkSize(fname)

    if ! &bin && getfsize(a:fname) < s:max_size
        let view = winsaveview()
        try
            silent %s/\v\s+$//ge
            call histdel('/', -1)
        catch
        endtry
        call winrestview(view)
    endif
endf

function! s:checkType(fname)

    let blacklist = ['bzr', 'diff', 'git', 'gitcommit', 'wdiff']

    if index(blacklist, &filetype) == -1
        call s:checkSize(a:fname)
        augroup trailing
            autocmd! * <buffer>
            autocmd BufRead,BufWrite <buffer> call s:checkSize(expand('<afile>'))
        augroup END
    endif
endf

augroup trailing
    autocmd!
    autocmd FileType * call s:checkType(expand('<afile>'))
augroup END
