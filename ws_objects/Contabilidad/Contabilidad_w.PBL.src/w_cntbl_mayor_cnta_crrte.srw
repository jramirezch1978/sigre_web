$PBExportHeader$w_cntbl_mayor_cnta_crrte.srw
forward
global type w_cntbl_mayor_cnta_crrte from w_prc
end type
type st_5 from statictext within w_cntbl_mayor_cnta_crrte
end type
type sle_mes from singlelineedit within w_cntbl_mayor_cnta_crrte
end type
type sle_ano from singlelineedit within w_cntbl_mayor_cnta_crrte
end type
type cb_cancelar from commandbutton within w_cntbl_mayor_cnta_crrte
end type
type cb_generar from commandbutton within w_cntbl_mayor_cnta_crrte
end type
type st_3 from statictext within w_cntbl_mayor_cnta_crrte
end type
type st_2 from statictext within w_cntbl_mayor_cnta_crrte
end type
type st_1 from statictext within w_cntbl_mayor_cnta_crrte
end type
type gb_1 from groupbox within w_cntbl_mayor_cnta_crrte
end type
end forward

global type w_cntbl_mayor_cnta_crrte from w_prc
integer width = 1376
integer height = 1164
string title = "Contabilidad"
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
global w_cntbl_mayor_cnta_crrte w_cntbl_mayor_cnta_crrte

on w_cntbl_mayor_cnta_crrte.create
int iCurrent
call super::create
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
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.sle_ano
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_generar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_cntbl_mayor_cnta_crrte.destroy
call super::destroy
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

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

String ls_ano, ls_mes
ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) -1 )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes

end event

type st_5 from statictext within w_cntbl_mayor_cnta_crrte
integer x = 165
integer y = 220
integer width = 1006
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "CUENTA CORRIENTE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cntbl_mayor_cnta_crrte
integer x = 704
integer y = 616
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

type sle_ano from singlelineedit within w_cntbl_mayor_cnta_crrte
integer x = 704
integer y = 524
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

type cb_cancelar from commandbutton within w_cntbl_mayor_cnta_crrte
integer x = 731
integer y = 844
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

type cb_generar from commandbutton within w_cntbl_mayor_cnta_crrte
integer x = 306
integer y = 840
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

event clicked;String ls_ano, ls_mes

cb_generar.enabled  = false
cb_cancelar.enabled = false
sle_ano.enabled     = false
sle_mes.enabled     = false

ls_ano = sle_ano.text
ls_mes = sle_mes.text

DECLARE PB_USP_CNTBL_MAYOR_CNTA_CRRTE PROCEDURE FOR USP_CNTBL_MAYOR_CNTA_CRRTE
        ( :ls_ano, :ls_mes ) ;
EXECUTE PB_USP_CNTBL_MAYOR_CNTA_CRRTE ;

IF sqlca.sqlcode = -1 THEN
	ROLLBACK ;
	MessageBox ('Error',"Store Procedure USP_CNTBL_MAYOR_CNTA_CRRTE Falló", StopSign!)
ELSE
	COMMIT ;
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
END IF

CLOSE PB_USP_CNTBL_MAYOR_CNTA_CRRTE ;

cb_generar.enabled  = true
cb_cancelar.enabled = true
sle_ano.enabled     = true
sle_mes.enabled     = true
end event

type st_3 from statictext within w_cntbl_mayor_cnta_crrte
integer x = 453
integer y = 616
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

type st_2 from statictext within w_cntbl_mayor_cnta_crrte
integer x = 453
integer y = 524
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

type st_1 from statictext within w_cntbl_mayor_cnta_crrte
integer x = 224
integer y = 76
integer width = 887
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "MAYORIZACION DE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cntbl_mayor_cnta_crrte
integer x = 306
integer y = 416
integer width = 745
integer height = 340
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

