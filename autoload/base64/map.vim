vim9script

import autoload 'base64.vim'


export def Base64(context: dict<any>, type: string = ''): string
  if type == ''
    context->extend({
      dot_command: false,
      extend_block: '',
      virtualedit: [&l:virtualedit, &g:virtualedit],
    })
    &operatorfunc = function(Base64, [context])
    :set virtualedit=block
    return 'g@'
  endif

  const save = {
    clipboard: &clipboard,
    selection: &selection,
    virtualedit: [&l:virtualedit, &g:virtualedit],
    register: getreginfo('"'),
    visual_marks: [getpos("'<"), getpos("'>")],
  }

  defer RestoreOptions(context, save)

  :set clipboard= selection=inclusive virtualedit=
  var commands = {
    line: "'[V']",
    char: "`[v`]",
    block: "`[\<C-V>`]",
  }[type]
  var [_, _, col, off] = getpos("']")
  if off != 0
    const vcol = getline("'[")->strpart(0, col + off)->strdisplaywidth()
    if vcol >= [line("'["), '$']->virtcol() - 1
      context.extend_block = '$'
    else
      context.extend_block = vcol .. '|'
    endif
  endif
  if context.extend_block != ''
    commands ..= 'oO' .. context.extend_block
  endif
  commands ..= 'y'
  :execute 'silent noautocmd keepjumps normal! ' .. commands
  if type == 'block'
    const output: list<string> = getreg('"', true, true)
      ->map((_, v: string) => context.mode == 'encode' ? base64.Encode(v) : base64.Decode2Str(v))
      ->flattennew()
    setreg('"', output, 'b')
  else
    const output = context.mode == 'encode' ?
      base64.Encode(getreg('"', true, true)) :
      base64.Decode2Str(getreg('"', true, true)->join(''))
    setreg('"', output, 'c')
  endif
  :execute 'silent keepjumps normal! gvp'

  return null_string
enddef


def RestoreOptions(context: dict<any>, save: dict<any>)
  setreg('"', save.register)
  setpos("'<", save.visual_marks[0])
  setpos("'>", save.visual_marks[1])
  &clipboard = save.clipboard
  &selection = save.selection
  [&l:virtualedit, &g:virtualedit] = get(context.dot_command ? save : context, 'virtualedit')
  context.dot_command = v:true
enddef
