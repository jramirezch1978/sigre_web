$PBExportHeader$n_cst_unicode.sru
forward
global type n_cst_unicode from nonvisualobject
end type
end forward

global type n_cst_unicode from nonvisualobject autoinstantiate
end type

type prototypes
function integer MultiByteToWideChar (uint CodePage,  ulong dwFlags,  ref string lpMultiByteStr, int cbMultiByte,  ref blob lpWideCharStr,  int cchWideChar) LIBRARY "kernel32.dll"
function integer WideCharToMultiByte(uint CodePage, ulong dwFlags, ref blob lpWideCharStr, int cchWideChar, ref string lpMultiByteStr, int cchMultiByte, ref char lpDefaultChar, ref boolean lpUsedDefaultChar) LIBRARY "kernel32.dll"

end prototypes

type variables
integer  MB_PRECOMPOSED = 1 //use precomposed chars
integer  MB_COMPOSITE = 2 // use composite chars 
integer  MB_USEGLYPHCHARS = 4  // use glyph chars, not ctrl chars 
integer  WC_DEFAULTCHECK = 256 //$100 check for default char 
integer  WC_COMPOSITECHECK = 512 //$200 convert composite to precomposed 
integer  WC_DISCARDNS = 16 //$10 discard non-spacing chars 
integer  WC_SEPCHARS = 32 //$20 generate separate chars 
integer  WC_DEFAULTCHAR = 64 //$40 replace w default char 

end variables

forward prototypes
public function blob of_ansi2unicode (string as_value)
public function blob of_ansi2unicode (string as_value, unsignedinteger ai_codepage)
public function string of_unicode2ansi (blob a_value)
public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage)
public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage, char ac_default_char)
end prototypes

public function blob of_ansi2unicode (string as_value);return of_ansi2unicode(as_value, 0)
end function

public function blob of_ansi2unicode (string as_value, unsignedinteger ai_codepage);blob lc_buff
integer li_output_size
string ls_temp_buff
integer li_input_size

SetNull(lc_buff)

li_input_size = len(as_value)
li_output_size = len(blob(as_value))

if li_input_size = li_output_size then 
	//ANSI
	//convert
	li_output_size = MultiByteToWideChar (ai_codepage,  0,  as_value, li_input_size,  lc_buff,  0)
	
	if li_output_size > 0 then
		ls_temp_buff = Space(li_output_size * 2)
		lc_buff = blob(ls_temp_buff)
		li_output_size = MultiByteToWideChar (ai_codepage,  0,  as_value, li_input_size,  lc_buff,  li_output_size)
	else
		lc_buff = blob('')
	end if
else
	//UNICODE
	//not convert
	lc_buff = blob(as_value)
end if

return lc_buff
end function

public function string of_unicode2ansi (blob a_value);return of_unicode2ansi(a_value, 0)
end function

public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage);integer li_input_size
integer li_output_size
string ls_buff
char lc_def_char
boolean lb_use_def_char
li_input_size = len(a_value)/2
li_output_size = WideCharToMultiByte(ai_codepage, 0, a_value, li_input_size, ls_buff, 0, lc_def_char, lb_use_def_char)
ls_buff = Space(li_output_size)
lc_def_char = '?'
lb_use_def_char = true
WideCharToMultiByte(ai_codepage, 0, a_value, li_input_size, ls_buff, li_output_size, lc_def_char, lb_use_def_char)
return ls_buff
end function

public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage, char ac_default_char);integer li_input_size
integer li_output_size
string ls_buff
char lc_def_char
boolean lb_use_def_char
li_input_size = len(a_value)/2
li_output_size = WideCharToMultiByte(ai_codepage, 0, a_value, li_input_size, ls_buff, 0, lc_def_char, lb_use_def_char)
ls_buff = Space(li_output_size)
lc_def_char = ac_default_char
lb_use_def_char = true
WideCharToMultiByte(ai_codepage, 0, a_value, li_input_size, ls_buff, li_output_size, lc_def_char, lb_use_def_char)
return ls_buff
end function

on n_cst_unicode.create
TriggerEvent( this, "constructor" )
end on

on n_cst_unicode.destroy
TriggerEvent( this, "destructor" )
end on

