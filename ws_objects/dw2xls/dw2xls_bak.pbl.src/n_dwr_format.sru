$PBExportHeader$n_dwr_format.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_format from nonvisualobject
end type
end forward

global type n_dwr_format from nonvisualobject
end type
global n_dwr_format n_dwr_format

type prototypes
public subroutine setnumformat (ulong f,readonly string as_format)  library "pb2xls.dll" alias for "fmt_setNumFormat"
public subroutine setfontname (ulong f,readonly string as_font)  library "pb2xls.dll" alias for "fmt_setFontName"
public subroutine setfontsize (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontSize"
public subroutine setfontitalic (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontItalic"
public subroutine setfontunderline (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontUnderline"
public subroutine setfontweight (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontWeight"
public subroutine sethalign (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setHAlign"
public subroutine setvalign (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setVAlign"
public subroutine settextalign (ulong f,readonly string value)  library "pb2xls.dll" alias for "fmt_setTextAlign"
public subroutine setwrap (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setWrap"
public subroutine setfgcolor (ulong f,ulong value)  library "pb2xls.dll" alias for "fmt_setFgColor"
public subroutine setbgcolor (ulong f,ulong value)  library "pb2xls.dll" alias for "fmt_setBgColor"
public subroutine setborderstyle (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setBorderStyle"
public subroutine setfontfamily (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontFamily"
public subroutine setfontcharset (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontCharset"
public subroutine setfontshadow (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontShadow"
public subroutine setfontoutline (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setFontOutline"
public subroutine setrotation (ulong f,long value)  library "pb2xls.dll" alias for "fmt_setRotation"
public subroutine destroyformat (ulong f)  library "pb2xls.dll" alias for "fmt_destroyFormat"
end prototypes

type variables
public ulong handle
end variables

on n_dwr_format.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_format.destroy
triggerevent("destructor")
call super::destroy
end on

event destructor;if handle <> 0 then
	destroyformat(handle)
end if

return
end event

