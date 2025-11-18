$PBExportHeader$u_sle_codigo.sru
forward
global type u_sle_codigo from singlelineedit
end type
end forward

global type u_sle_codigo from singlelineedit
integer width = 512
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type
global u_sle_codigo u_sle_codigo

type variables
Integer	ii_prefijo, ii_total
Boolean  ibl_mayuscula, ibl_activacion = True
end variables

on u_sle_codigo.create
end on

on u_sle_codigo.destroy
end on

event modified;String 	ls_texto, ls_prefijo, ls_sufijo
Integer	li_sufijo, li_diferencia

IF ibl_activacion = FALSE THEN RETURN
ls_texto = TRIM(THIS.text)
IF LEN(ls_texto) = 0 THEN RETURN


IF ibl_mayuscula THEN ls_texto = Upper(ls_texto)
IF LEN(ls_texto) > ii_total THEN  ls_texto = Left(ls_texto, ii_total)
ls_prefijo = Left(ls_texto, ii_prefijo)
li_sufijo = LEN(ls_texto) - ii_prefijo
ls_sufijo = Right(ls_texto, li_sufijo)
li_diferencia = ii_total - ii_prefijo - li_sufijo

THIS.TEXT = ls_prefijo + Fill('0', li_diferencia) + ls_sufijo


end event

event constructor;//ii_prefijo = 2
//ii_total = 10
//ibl_mayuscula = true
end event

