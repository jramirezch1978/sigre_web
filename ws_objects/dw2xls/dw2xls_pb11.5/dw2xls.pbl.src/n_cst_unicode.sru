$PBExportHeader$n_cst_unicode.sru
forward
global type n_cst_unicode from nonvisualobject
end type
end forward

global type n_cst_unicode from nonvisualobject autoinstantiate
end type

type prototypes
//FUNCTION ulong MultiByteToWideChar( unsignedinteger codepage, unsignedlong dwflags, ref string lpmultibytestr, integer cbmultibyte, ref blob lpwidecharstr, integer cchwidechar ) LIBRARY "kernel32.dll" alias for "MultiByteToWideChar;Ansi"
//FUNCTION ulong WideCharToMultiByte( unsignedinteger codepage, unsignedlong dwflags, ref blob lpwidecharstr, integer cchwidechar, ref string lpmultibytestr, integer cchmultibyte, ref character lpdefaultchar, ref boolean lpuseddefaultchar )  LIBRARY "kernel32.dll" alias for "WideCharToMultiByte;Ansi"

end prototypes
type variables
PUBLIC INTEGER mb_precomposed = 1
PUBLIC INTEGER mb_composite = 2

PUBLIC INTEGER mb_useglyphchars = 4
PUBLIC INTEGER wc_defaultcheck = 256

PUBLIC INTEGER wc_compositecheck = 512
PUBLIC INTEGER wc_discardns = 16

PUBLIC INTEGER wc_sepchars = 32
PUBLIC INTEGER wc_defaultchar = 64


end variables

forward prototypes
public function blob of_ansi2unicode (string as_value, unsignedlong ai_codepage)
public function blob of_ansi2unicode (string as_value)
public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage)
public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage, character ac_default_char)
public function string of_unicode2ansi (blob a_value)
end prototypes

public function blob of_ansi2unicode (string as_value, unsignedlong ai_codepage);//BLOB lc_buff
//ULONG li_output_size
//STRING ls_temp_buff
//ULONG li_input_size
//
//SETNULL(lc_buff)
//li_input_size = LEN(as_value)
//li_output_size = multibytetowidechar(ai_codepage, 0, as_value, li_input_size, lc_buff, 0)
//
//IF li_output_size > 0 THEN
//	ls_temp_buff = SPACE(li_output_size * 2)
//	lc_buff = BLOB(ls_temp_buff)
//	li_output_size = multibytetowidechar(ai_codepage, 0, as_value, li_input_size, lc_buff, li_output_size)
//ELSE
//	lc_buff = BLOB("")
//END IF
//
//RETURN lc_buff
//

//Return ToUnicode(as_Value)

Return Blob(as_Value) 
end function

public function blob of_ansi2unicode (string as_value);RETURN of_ansi2unicode(as_value,0)

end function

public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage);//integer li_input_size
//integer li_output_size
//string ls_buff
//char lc_def_char
//boolean lb_use_def_char
//
//li_input_size = len(a_value) / 2
//li_output_size = widechartomultibyte(ai_codepage, 0, a_value, li_input_size, ls_buff, 0, lc_def_char, lb_use_def_char)
//ls_buff = space(li_output_size)
//lc_def_char = "?"
//lb_use_def_char = true
//widechartomultibyte(ai_codepage, 0, a_value, li_input_size, ls_buff, li_output_size, lc_def_char, lb_use_def_char)
//return ls_buff
//

Return  String(a_Value) 
end function

public function string of_unicode2ansi (blob a_value, unsignedinteger ai_codepage, character ac_default_char);//integer li_input_size
//integer li_output_size
//string ls_buff
//char lc_def_char
//boolean lb_use_def_char
//
//li_input_size = len(a_value) / 2
//li_output_size = widechartomultibyte(ai_codepage, 0, a_value, li_input_size, ls_buff, 0, lc_def_char, lb_use_def_char)
//ls_buff = space(li_output_size)
//lc_def_char = ac_default_char
//lb_use_def_char = true
//widechartomultibyte(ai_codepage, 0, a_value, li_input_size, ls_buff, li_output_size, lc_def_char, lb_use_def_char)
//return ls_buff

Return String(a_Value)
end function

public function string of_unicode2ansi (blob a_value);return of_unicode2ansi(a_value,0)
end function

on n_cst_unicode.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_unicode.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

