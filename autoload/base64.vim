vim9script

const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

export def Encode(input: any): string
  var inblob: blob
  if typename(input) == 'list<string>'
    inblob = Str2Blob(input)
  elseif type(input) == v:t_string
    inblob = Str2Blob(input->split('\n', true))
  elseif type(input) == v:t_blob
    inblob = input
  else
    throw 'argument must be Blob or List of strings'
  endif

  var bits: list<number> = []

  var remain = 0
  var remainlen = 0
  var i = 0
  const len = len(inblob)
  while i < len
    const byte = inblob[i]
    const nextbitlen = 6 - remainlen
    const nextbit = (remain << nextbitlen) + (byte >> (8 - nextbitlen))
    add(bits, nextbit)
    remainlen += 2
    if remainlen == 6
      add(bits, and(byte, 0b111111))
      remainlen = 0
    endif
    remain = and(byte, 0b11111111 >> (8 - remainlen))
    ++i
  endwhile

  if remainlen > 0
    add(bits, remain << (6 - remainlen))
  endif

  var ret = mapnew(bits, (_, v) => letters[v])->join('')
  ret ..= repeat('=', (4 - len(ret) % 4) % 4)

  return ret
enddef


export def Decode(input: string): blob
  var ret = 0z
  var remain = 0

  for char in input
    if char == '='
      break
    endif

    const bits: number = stridx(letters, char)
    if bits < 0
      throw 'invalid base64 code'
    endif

    if remain > 0
      ret[-1] += bits >> (6 - remain)
    endif
    if remain < 6
      add(ret, and(bits << 2 + remain, 0b11111111))
    endif
    remain = (remain + 2) % 8
  endfor

  if remain > 0
    remove(ret, len(ret) - 1)
  endif

  return ret
enddef


export def Decode2Str(input: string): list<string>
  return Blob2Str(Decode(input))
enddef


def Str2Blob(input: list<string>): blob
  return input
    ->mapnew((_, line) =>
      repeat(0z00, len(line))
        ->map((i: number, _): number => char2nr(strpart(line, i, 1)))
        ->map((_, v) => v == 0x0A ? 0x00 : v))
    ->reduce((acc, val) => acc + 0z0A + val)
enddef


def Blob2Str(input: blob): list<string>
  var ret: list<string> = ['']
  for byte in input
    if byte == 0x0A # == "\n"
      add(ret, '')
      continue
    endif

    if byte == 0
      ret[-1] ..= "\n"
    else
      ret[-1] ..= printf('%c', byte)
    endif
  endfor
  return ret
enddef
