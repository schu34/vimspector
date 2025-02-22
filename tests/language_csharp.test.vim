function! SetUp()
  call vimspector#test#setup#SetUpWithMappings( v:none )
endfunction

function! ClearDown()
  call vimspector#test#setup#ClearDown()
endfunction

function! SetUp_Test_Go_Simple()
  let g:vimspector_enable_mappings = 'HUMAN'
endfunction

function! SkipUnsupported() abort
  call SkipOn( 'arm64', 'Darwin' )
endfunction

function! Test_CSharp_Simple_Adhoc_Config()
  call SkipUnsupported()
  let fn='Program.cs'
  lcd ../support/test/csharp
  exe 'edit ' . fn

  call vimspector#SetLineBreakpoint( fn, 31 )
  call vimspector#LaunchWithConfigurations( {
    \ 'launch - netcoredbg': {
    \   'adapter': 'netcoredbg',
    \   'configuration': {
    \     'request': 'launch',
    \     'program': '${workspaceRoot}/bin/Debug/netcoreapp5.0/csharp.dll',
    \     'args': [],
    \     'stopAtEntry': v:false
    \   }
    \ }
  \ } )
  call vimspector#test#signs#AssertCursorIsAtLineInBuffer( fn, 31, 7 )
  call WaitForAssert( {->
        \ vimspector#test#signs#AssertPCIsAtLineInBuffer( fn, 31 )
        \ } )

  call vimspector#StepOver()
  call vimspector#test#signs#AssertCursorIsAtLineInBuffer( fn, 32, 12 )
  call WaitForAssert( {->
        \ vimspector#test#signs#AssertPCIsAtLineInBuffer( fn, 32 )
        \ } )

  call vimspector#test#setup#Reset()

  lcd -
  %bwipeout!
endfunction

function! Test_CSharp_Simple()
  call SkipUnsupported()

  let fn='Program.cs'
  lcd ../support/test/csharp
  exe 'edit ' . fn

  call vimspector#SetLineBreakpoint( fn, 31 )
  call vimspector#LaunchWithSettings( {
        \ 'configuration': 'launch - netcoredbg'
        \ } )
  call vimspector#test#signs#AssertCursorIsAtLineInBuffer( fn, 31, 7 )
  call WaitForAssert( {->
        \ vimspector#test#signs#AssertPCIsAtLineInBuffer( fn, 31 )
        \ } )

  call vimspector#StepOver()
  call vimspector#test#signs#AssertCursorIsAtLineInBuffer( fn, 32, 12 )
  call WaitForAssert( {->
        \ vimspector#test#signs#AssertPCIsAtLineInBuffer( fn, 32 )
        \ } )

  call vimspector#test#setup#Reset()

  lcd -
  %bwipeout!
endfunction


function! Test_Run_To_Cursor()
  call SkipUnsupported()
  let fn='Program.cs'
  lcd ../support/test/csharp
  exe 'edit ' . fn

  call vimspector#SetLineBreakpoint( fn, 31 )
  call vimspector#LaunchWithSettings( {
        \ 'configuration': 'launch - netcoredbg'
        \ } )
  call vimspector#test#signs#AssertCursorIsAtLineInBuffer( fn, 31, 7 )
  call WaitForAssert( {->
        \ vimspector#test#signs#AssertPCIsAtLineInBuffer( fn, 31 )
        \ } )

  call cursor( 33, 1 )
  call vimspector#RunToCursor()
  call vimspector#test#signs#AssertCursorIsAtLineInBuffer( fn, 33, 1 )
  call WaitForAssert( {->
        \ vimspector#test#signs#AssertPCIsAtLineInBuffer( fn, 33 )
        \ } )

  call vimspector#test#setup#Reset()
  lcd -
  %bwipeout!
endfunction

