filetype plugin indent on
runtime! plugin/obedient.vim

function! ConfigurationAfterOpeningFile(file_path)
  new `=a:file_path`
  let configuration = {
  \   'expandtab': &l:expandtab,
  \   'shiftwidth': &l:shiftwidth,
  \   'softtabstop': &l:softtabstop,
  \ }
  close!

  return configuration
endfunction

describe 'obedient'
  it 'configures the right indentation style according to existing content'
    Expect ConfigurationAfterOpeningFile('t/fixtures/mix-even.txt')
    \ ==# {'expandtab': 0, 'shiftwidth': 0, 'softtabstop': 0}
    Expect ConfigurationAfterOpeningFile('t/fixtures/mix-more-spaces.txt')
    \ ==# {'expandtab': 1, 'shiftwidth': 4, 'softtabstop': 4}
    Expect ConfigurationAfterOpeningFile('t/fixtures/mix-more-tabs.txt')
    \ ==# {'expandtab': 0, 'shiftwidth': 0, 'softtabstop': 0}
    Expect ConfigurationAfterOpeningFile('t/fixtures/space-2.txt')
    \ ==# {'expandtab': 1, 'shiftwidth': 2, 'softtabstop': 2}
    Expect ConfigurationAfterOpeningFile('t/fixtures/space-4.txt')
    \ ==# {'expandtab': 1, 'shiftwidth': 4, 'softtabstop': 4}
    Expect ConfigurationAfterOpeningFile('t/fixtures/space-8.txt')
    \ ==# {'expandtab': 1, 'shiftwidth': 8, 'softtabstop': 8}
    Expect ConfigurationAfterOpeningFile('t/fixtures/tab.txt')
    \ ==# {'expandtab': 0, 'shiftwidth': 0, 'softtabstop': 0}
  end

  it 'leaves the default style for new file'
    set expandtab
    Expect ConfigurationAfterOpeningFile('t/fixtures/Makefile')
    \ ==# {'expandtab': 0, 'shiftwidth': 0, 'softtabstop': 0}
    set expandtab&

    Expect ConfigurationAfterOpeningFile('t/fixtures/nothing.py')
    \ ==# {'expandtab': 1, 'shiftwidth': 4, 'softtabstop': 4}
  end
end
