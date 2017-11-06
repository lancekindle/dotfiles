" do nothing if we already have syntax loaded
if exists("b:current_syntax")
    finish
endif

"begin syntax stuff -- borrowed from github.com/AntonioND/dotfiles
syn case ignore

syn sync fromstart

" Registers
syn keyword gbz80Reg af bc de hl sp
syn keyword gbz80Reg a b c d e f h l

" Common gbz80 Assembly instructions
syn keyword gbz80Inst adc add and bit ccf cp cpl daa dec di ei halt inc jp jr ld
syn keyword gbz80Inst ldd ldh ldi nop or res rl rla rlc rlca rr rra rrc rrca sbc
syn keyword gbz80Inst scf set sla sra srl stop sub swap xor
syn keyword gbz80SpecInst push pop call ret reti rst

" Grab the condition too
syn match gbz80Inst "\s\+jp\s\+n\=[cz]\>" " Match Z C NZ NC
syn match gbz80Inst "\s\+jr\s\+n\=[zc]\>"
syn match gbz80SpecInst "\s\+call\s\+n\=[cz]\>"
syn match gbz80SpecInst "\s\+ret\s\+n\=[cz]\>"

" Directives
syn keyword gbz80PreProc __DATE__ __TIME__ __ISO_8601_UTC__ ___ISO_8601_LOCAL__
syn keyword gbz80PreProc __UTC_YEAR__ __UTC_MONTH__ __UTC_DAY__
syn keyword gbz80PreProc __UTC_HOUR__ __UTC_MINUTE__ __UTC_SECOND__
syn keyword gbz80PreProc __LINE__ __FILE__
syn keyword gbz80PreProc __RGBDS_MAJOR__ __RGBDS_MINOR__ __RGBDS_PATCH__
syn keyword gbz80PreProc _PI ACOS ASIN ATAN ATAN2 COS DIV MUL SIN TAN
syn keyword gbz80PreProc DEF EQU EQUS EXPORT GLOBAL IMPORT PURGE SET
syn keyword gbz80PreProc ELSE ELIF ENDC IF
syn keyword gbz80PreProc _NARG ENDM MACRO SHIFT
syn keyword gbz80PreProc ENDR REPT
syn keyword gbz80PreProc FAIL PRINTF PRINTT PRINTV WARN
syn keyword gbz80PreProc INCBIN INCLUDE
syn keyword gbz80PreProc OPT POPO PUSHO
syn keyword gbz80PreProc POPS PUSHS
syn keyword gbz80PreProc _RS RB RB RSRESET RSSET RW
syn keyword gbz80PreProc STRCAT STRCMP STRIN STRLEN STRLWR STRSUB STRUPR
syn keyword gbz80PreProc CHARMAP
syn keyword gbz80PreProc HIGH LOW

syn keyword gbz80OrgDirs BANK SECTION ALIGN
syn keyword gbz80OrgDirs HOME CODE DATA BSS
syn keyword gbz80OrgDirs ROM0 ROMX VRAM WRAM SRAM WRAM0 WRAMX HRAM

syn keyword gbz80Type DB DS DW

" Strings
syn region gbz80String start=/"/ skip=/\\"/ end=/"/ oneline
syn region gbz80String start=/'/ end=/'/ oneline

" Labels
syn match gbz80Lbl "^\.\=[A-Za-z_][A-Za-z0-9_#]*\(\\@\)\=[A-Za-z0-9_#]*:\="
syn match gbz80Lbl "^[A-Za-z_][A-Za-z0-9_#]*::\="

" Operators
syn match gbz80Other "[~+\-*/%^&=!<>\|@]"

" Numbers
syn match gbz80Number "\<\$\>"
syn match gbz80Number "\<\d\+\>"
syn match gbz80Number "\<\d\+\.\d\+\>"
syn match gbz80Number "%[01]\+"
syn match gbz80Number "\`[0-3]\+"
syn match gbz80Number "\<\&\o\+\>"
syn match gbz80Number "\$\x\+"

" Macro Arguments (like \@, \1, \3, \12, etc.)
syn match gbz80MacroArg "\\\d\+"
syn match gbz80MacroArg "\\@"

" Comments
syn region gbz80Comment start=';' end='$'

" To do
syn keyword gbz80Todo TODO FIXME

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_gbz80_syntax_inits")
  if version < 508
    let did_gbz80_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " Identifier PreCondit Special Normal Label Statement
  HiLink gbz80Reg Constant
  HiLink gbz80Lbl Function
  HiLink gbz80Comment Comment
  HiLink gbz80Inst Type
  HiLink gbz80SpecInst Statement
  HiLink gbz80Include Include
  HiLink gbz80PreProc PreProc
  HiLink gbz80MacroArg Identifier
  HiLink gbz80Number Number
  HiLink gbz80String String
  HiLink gbz80Other Type
  HiLink gbz80OrgDirs PreProc
  HiLink gbz80Type Type
  HiLink gbz80Todo Todo
  delcommand HiLink
endif

let b:current_syntax = "gbz80"
