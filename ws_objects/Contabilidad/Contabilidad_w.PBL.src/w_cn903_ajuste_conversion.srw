$PBExportHeader$w_cn903_ajuste_conversion.srw
forward
global type w_cn903_ajuste_conversion from w_prc
end type
type st_7 from statictext within w_cn903_ajuste_conversion
end type
type st_6 from statictext within w_cn903_ajuste_conversion
end type
type sle_libro from singlelineedit within w_cn903_ajuste_conversion
end type
type st_5 from statictext within w_cn903_ajuste_conversion
end type
type sle_mes from singlelineedit within w_cn903_ajuste_conversion
end type
type sle_ano from singlelineedit within w_cn903_ajuste_conversion
end type
type cb_cancelar from commandbutton within w_cn903_ajuste_conversion
end type
type cb_generar from commandbutton within w_cn903_ajuste_conversion
end type
type st_3 from statictext within w_cn903_ajuste_conversion
end type
type st_2 from statictext within w_cn903_ajuste_conversion
end type
type st_1 from statictext within w_cn903_ajuste_conversion
end type
type gb_1 from groupbox within w_cn903_ajuste_conversion
end type
end forward

global type w_cn903_ajuste_conversion from w_prc
integer width = 1600
integer height = 1276
string title = "[CN903] Ajuste x conversión"
string menuname = "m_prc"
st_7 st_7
st_6 st_6
sle_libro sle_libro
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn903_ajuste_conversion w_cn903_ajuste_conversion

on w_cn903_ajuste_conversion.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.st_7=create st_7
this.st_6=create st_6
this.sle_libro=create sle_libro
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.sle_libro
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.sle_mes
this.Control[iCurrent+6]=this.sle_ano
this.Control[iCurrent+7]=this.cb_cancelar
this.Control[iCurrent+8]=this.cb_generar
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.gb_1
end on

on w_cn903_ajuste_conversion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_libro)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x, ll_y, ll_libro
String ls_libro, ls_ano, ls_mes

ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

select libro_ajuste_conv into :ll_libro from cntblparam where reckey='1' ;

ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) -1 )
ls_libro = string( ll_libro )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes
sle_libro.text = ls_libro

end event

type st_7 from statictext within w_cn903_ajuste_conversion
integer x = 389
integer y = 748
integer width = 690
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "anteriormente procesados"
boolean focusrectangle = false
end type

type st_6 from statictext within w_cn903_ajuste_conversion
integer x = 389
integer y = 676
integer width = 827
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Proceso no eliminará registros "
boolean focusrectangle = false
end type

type sle_libro from singlelineedit within w_cn903_ajuste_conversion
integer x = 658
integer y = 556
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_cn903_ajuste_conversion
integer x = 411
integer y = 564
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Libro"
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn903_ajuste_conversion
integer x = 658
integer y = 464
integer width = 187
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn903_ajuste_conversion
integer x = 658
integer y = 372
integer width = 187
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn903_ajuste_conversion
integer x = 846
integer y = 896
integer width = 320
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn903_ajuste_conversion
integer x = 421
integer y = 892
integer width = 320
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String ls_msj
Long ll_ano, ll_mes, ll_libro

cb_generar.enabled  = false
cb_cancelar.enabled = false
sle_ano.enabled     = false
sle_mes.enabled     = false

ll_ano = LONG( sle_ano.text )
ll_mes = LONG( sle_mes.text )
ll_libro = LONG( sle_libro.text )

DECLARE USP_CNTBL_AJUSTE_CONVERSION PROCEDURE FOR 
	USP_CNTBL_AJUSTE_CONVERSION( :gs_origen, 
										  :ll_ano, 
										  :ll_mes, 
										  :ll_libro, 
										  :gs_user ) ;
EXECUTE USP_CNTBL_AJUSTE_CONVERSION ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox ('Error en USP_CNTBL_AJUSTE_CONVERSION', ls_msj, StopSign!)
	return
end if

COMMIT ;
CLOSE USP_CNTBL_AJUSTE_CONVERSION;

MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")

cb_generar.enabled  = true
cb_cancelar.enabled = true
sle_ano.enabled     = true
sle_mes.enabled     = true
end event

type st_3 from statictext within w_cn903_ajuste_conversion
integer x = 411
integer y = 464
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn903_ajuste_conversion
integer x = 411
integer y = 372
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn903_ajuste_conversion
integer x = 256
integer y = 88
integer width = 1051
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "AJUSTES POR CONVESION"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn903_ajuste_conversion
integer x = 306
integer y = 264
integer width = 978
integer height = 584
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

