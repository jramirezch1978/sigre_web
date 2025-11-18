$PBExportHeader$w_cn982_balance_historico.srw
forward
global type w_cn982_balance_historico from w_prc
end type
type st_5 from statictext within w_cn982_balance_historico
end type
type sle_ano from singlelineedit within w_cn982_balance_historico
end type
type cb_cancelar from commandbutton within w_cn982_balance_historico
end type
type cb_generar from commandbutton within w_cn982_balance_historico
end type
type st_2 from statictext within w_cn982_balance_historico
end type
type st_1 from statictext within w_cn982_balance_historico
end type
type gb_1 from groupbox within w_cn982_balance_historico
end type
end forward

global type w_cn982_balance_historico from w_prc
integer width = 1376
integer height = 864
string title = "CN982 Balance de comprobación histórico"
st_5 st_5
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn982_balance_historico w_cn982_balance_historico

on w_cn982_balance_historico.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.cb_cancelar
this.Control[iCurrent+4]=this.cb_generar
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_cn982_balance_historico.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;Long ll_x, ll_y, ll_ano, ls_mes
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)


ll_ano = Long(String(year(today())))
					
sle_ano.text = String(year(today()))


end event

type st_5 from statictext within w_cn982_balance_historico
integer x = 197
integer y = 220
integer width = 942
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "HISTORICO - SUNAT"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn982_balance_historico
integer x = 704
integer y = 488
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

type cb_cancelar from commandbutton within w_cn982_balance_historico
integer x = 731
integer y = 644
integer width = 320
integer height = 80
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

type cb_generar from commandbutton within w_cn982_balance_historico
integer x = 306
integer y = 640
integer width = 320
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String ls_mensaje
Long ll_ano, ll_digito 


cb_generar.enabled  = false
cb_cancelar.enabled = false
sle_ano.enabled     = false


ll_ano = LONG(sle_ano.text)
ll_digito = 3 

DECLARE PB_USP_CNT_BALANCE_HISTORICO PROCEDURE FOR USP_CNT_BALANCE_HISTORICO
   ( :ll_ano, :ll_digito ) ;		  
EXECUTE PB_USP_CNT_BALANCE_HISTORICO ;

IF sqlca.sqlcode = -1 THEN
	ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', ls_mensaje, StopSign! )
	MessageBox ('Error',"Store Procedure USP_CNT_BALANCE_HISTORICO Falló", StopSign!)
ELSE
	COMMIT ;
	MessageBox ('Aviso',"Proceso ha concluído satisfactoriamente")
END IF

CLOSE PB_USP_CNT_BALANCE_HISTORICO ;

cb_generar.enabled  = true
cb_cancelar.enabled = true
sle_ano.enabled     = true

end event

type st_2 from statictext within w_cn982_balance_historico
integer x = 453
integer y = 488
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

type st_1 from statictext within w_cn982_balance_historico
integer x = 197
integer y = 76
integer width = 942
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "BALANCE DE COMPROBACION"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn982_balance_historico
integer x = 306
integer y = 416
integer width = 745
integer height = 168
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

