$PBExportHeader$n_cst_unicode.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_cst_unicode from nonvisualobject
end type
end forward

global type n_cst_unicode from nonvisualobject autoinstantiate
end type
global n_cst_unicode n_cst_unicode

type prototypes
public function integer multibytetowidechar (uint codepage,ulong dwflags,ref string lpmultibytestr,integer cbmultibyte,ref blob lpwidecharstr,integer cchwidechar)  library "kernel32.dll" alias for "MultiByteToWideChar"
public function integer widechartomultibyte (uint codepage,ulong dwflags,ref blob lpwidecharstr,integer cchwidechar,ref string lpmultibytestr,integer cchmultibyte,ref char lpdefaultchar,ref boolean lpuseddefaultchar)  library "kernel32.dll" alias for "WideCharToMultiByte"
end prototypes

type variables
public integer mb_precomposed = 1
public integer mb_composite = 2
public integer mb_useglyphchars = 4
public integer wc_defaultcheck = 256
public integer wc_compositecheck = 512
public integer wc_discardns = 16
public integer wc_sepchars = 32
public integer wc_defaultchar = 64
end variables

forward prototypes
public function blob of_ansi2unicode (string as_value)
public function blob of_ansi2unicode (string as_value,uint ai_codepage)
public function string of_unicode2ansi (blob a_value)
public function string of_unicode2ansi (blob a_value,uint ai_codepage)
public function string of_unicode2ansi (blob a_value,uint ai_codepage,char ac_default_char)
end prototypes

public function blob of_ansi2unicode (string as_value);return of_ansi2unicode(as_value,0)
end function

public function blob of_ansi2unicode (string as_value,uint ai_codepage);blob lc_buff
integer li_output_size
string ls_temp_buff
integer li_input_size

setnull(lc_buff)
li_input_size = len(as_value)
li_output_size = len(blob(as_value))

if li_input_size = li_output_size then
	lc_buff = blob("*")
	li_output_size = multibytetowidechar(ai_codepage,0,as_value,li_input_size,lc_buff,0)

	if li_output_size > 0 then
		ls_temp_buff = space(li_output_size * 2)
		lc_buff = blob(ls_temp_buff)
		li_output_size = multibytetowidechar(ai_codepage,0,as_value,li_input_size,lc_buff,li_output_size)
	else
		lc_buff = blob("")
	end if

else
	lc_buff = blob(as_value)
end if

return lc_buff
end function

public function string of_unicode2ansi (blob a_value);return of_unicode2ansi(a_value,0)
end function

public function string of_unicode2ansi (blob a_value,uint ai_codepage);integer li_input_size
integer li_output_size
string ls_buff
char lc_def_char
boolean lb_use_def_char = false

li_input_size = len(a_value) / 2
li_output_size = widechartomultibyte(ai_codepage,0,a_value,li_input_size,ls_buff,0,lc_def_char,lb_use_def_char)
ls_buff = space(li_output_size)
lc_def_char = "?"
lb_use_def_char = true
widechartomultibyte(ai_codepage,0,a_value,li_input_size,ls_buff,li_output_size,lc_def_char,lb_use_def_char)
return ls_buff
end function

public function string of_unicode2ansi (blob a_value,uint ai_codepage,char ac_default_char);integer li_input_size
integer li_output_size
string ls_buff
char lc_def_char
boolean lb_use_def_char = false

li_input_size = len(a_value) / 2
li_output_size = widechartomultibyte(ai_codepage,0,a_value,li_input_size,ls_buff,0,lc_def_char,lb_use_def_char)
ls_buff = space(li_output_size)
lc_def_char = ac_default_char
lb_use_def_char = true
widechartomultibyte(ai_codepage,0,a_value,li_input_size,ls_buff,li_output_size,lc_def_char,lb_use_def_char)
return ls_buff
end function

on n_cst_unicode.create
call super::create;

triggerevent("constructor")
end on

on n_cst_unicode.destroy
triggerevent("destructor")
call super::destroy
end on

