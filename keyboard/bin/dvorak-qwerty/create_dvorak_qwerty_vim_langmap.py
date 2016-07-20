#! /usr/bin/env python

# this creates the vim langmap that swaps between dvorak and qwerty
# layout when in insert and normal mode, respectively. This will enable
# you to type all your commands and other keystrokes as qwerty, but when
# typing through insert mode, type as dvorak.
# I constructed this map by first plugging in two keyboards: a dvorak
# and a qwerty one. Then for each key identical key, I typed the dvorak
# key first, then the qwerty key, separated by a newline.
# I did this for ALL keys, including numerical keys (necessary when
# doing programmers dvorak), and did the same thing for all uppercase


# original solution used vim's langmap. However, langmap is
# considered harmful and works non-intuitively and breaks plugin
# keybindings. Still not fixed in 2016
# http://permalink.gmane.org/gmane.editors.vim.devel/36307
langmap_fixed = False


# type alpha-numberic keys from top row to bottom row, left to right
# USER INPUT HERE. THIS IS CURRENTLY SET-UP FOR PROGRAMMER'S DVORAK
lowercase_qwerty = r"""
`1234567890-=
qwertyuiop[]\
asdfghjkl;'
zxcvbnm,./
"""

lowercase_dvorak = r"""
$&[{}(=*)+]!#
;,.pyfgcrl/@\
aoeuidhtns-
'qjkxbmwvz
"""

uppercase_qwerty = r"""
~!@#$%^&*()_+
QWERTYUIOP{}|
ASDFGHJKL:"
ZXCVBNM<>?
"""

uppercase_dvorak = r"""
~%7531902468`
:<>PYFGCRL?^|
AOEUIDHTNS_
"QJKXBMWVZ
"""

# when setting langmap, vim requires that backslash (\), comma (,),
# semi-colon (;), and quote (") be escaped.
# for example, to swap comma (,) and w during normal mode:
# :set langmap=\\,w
# or
# :let &langmap="\\,w"
# or
# :let &langmap='\,w'     <= special case. Single quote-encloser
#                              requires one escaping-backslash only
special_chars = [
    '\\',
    ',',
    ';',
    '"',
]
replacements = [
    r'\\\\',
    r'\\,',
    r'\\;',
    r'\\"',
]

def escape_special_char(key):
    for special, escaped in zip(special_chars, replacements):
        key = key.replace(special, escaped)
    return key

def escape_all_special_chars(keys):
    escaped_keys = ''
    for key in keys:
        escaped_keys += escape_special_char(key)
    return escaped_keys

dvorak_keyboard = lowercase_dvorak + uppercase_dvorak
qwerty_keyboard = lowercase_qwerty + uppercase_qwerty
if not len(dvorak_keyboard) == len(qwerty_keyboard):
    print(len(dvorak_keyboard), len(qwerty_keyboard))
    raise ValueError('there is not a one-to-one corresondance between keys.\
                      Please verify each keyboard section is equivalent, \
                      right down to the number of newlines')

if langmap_fixed:
    dvorak_keyboard = escape_all_special_chars(dvorak_keyboard)
    qwerty_keyboard = escape_all_special_chars(qwerty_keyboard)
dvorak_keyboard = [row for row in dvorak_keyboard.split('\n') if row]
qwerty_keyboard = [row for row in qwerty_keyboard.split('\n') if row]

# generate code that remaps normal mode keys from dvorak to qwerty
f = open('dvorak_qwerty_noremaps.vim', 'w')
# due to remappings... we MUST Q to <nop>. Otherwise Q (accidentally
# hitting Q when thinking of hitting : in dvorak) will enter Ex-mode. A
# weird compatibility mode that requires you to type "visual" to escape.
# http://www.bestofvim.com/tip/leave-ex-mode-good/
f.write('nnoremap Q <nop>\n')
if not langmap_fixed:
    for dv_row, qw_row in zip(dvorak_keyboard, qwerty_keyboard):
        for dv_key, qw_key in zip(dv_row, qw_row):
            dv_key = escape_special_char(dv_key)
            qw_key = escape_special_char(qw_key)
            if not dv_key == qw_key:
                if not qw_key == 'Q':
                    # we avoid binding anything to Q, the Ex-Mode
                    f.write('nnoremap ' + dv_key + ' ' + qw_key + '\n')
                # Operator mode: keys expected after command keys. Makes
                # 'dd' behave as expected. Second 'd' is from operator
                # mode
                f.write('onoremap ' + dv_key + ' ' + qw_key + '\n')
f.close()


if langmap_fixed:
    for dv_row, qw_row in zip(dvorak_keyboard, qwerty_keyboard):
        row_swap = dv_row + ';' + qw_row
        quote = '"'
        if '"' in row_swap:
            # when using singlequote (') to enclose a row-swap, all
            # double-backslashes (\\) must be halved (to \)
            quote = "'"
            row_swap = row_swap.replace('\\\\', '\\')
        if '"' in row_swap and "'" in row_swap:
            raise ValueError('''
                cannot handle both doublequote (") and quote (') in same
                rowswap.  While it is probably doable, I have not
                figured it out. Perhaps try googling "vim set langmap".
                Instead you will probably have to split row_swap into
                smaller keyswaps that separate the ' and "
                ''')
        print('let &langmap=' + quote + row_swap + quote)

