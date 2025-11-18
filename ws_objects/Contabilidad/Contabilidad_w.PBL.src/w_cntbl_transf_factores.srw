$PBExportHeader$w_cntbl_transf_factores.srw
forward
global type w_cntbl_transf_factores from w_prc
end type
type st_4 from statictext within w_cntbl_transf_factores
end type
type st_1 from statictext within w_cntbl_transf_factores
end type
type sle_mes from singlelineedit within w_cntbl_transf_factores
end type
type sle_ano from singlelineedit within w_cntbl_transf_factores
end type
type cb_cancelar from commandbutton within w_cntbl_transf_factores
end type
type cb_generar from commandbutton within w_cntbl_transf_factores
end type
type st_3 from statictext within w_cntbl_transf_factores
end type
type st_2 from statictext within w_cntbl_transf_factores
end type
type gb_1 from groupbox within w_cntbl_transf_factores
end type
end forward

global type w_cntbl_transf_factores from w_prc
integer width = 1984
integer height = 1140
string title = "Genera Factores de Transferencias Automáticas"
st_4 st_4
st_1 st_1
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_3 st_3
st_2 st_2
gb_1 gb_1
end type
global w_cntbl_transf_factores w_cntbl_transf_factores

on w_cntbl_transf_factores.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_1=create st_1
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.gb_1
end on

on w_cntbl_transf_factores.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_1)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

String ls_ano, ls_mes
ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes

end event

type st_4 from statictext within w_cntbl_transf_factores
integer x = 215
integer y = 228
integer width = 1563
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "DE SECUENCIAS PRE - ESTABLECIDAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cntbl_transf_factores
integer x = 315
integer y = 80
integer width = 1367
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "GENERA FACTORES VARIABLES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cntbl_transf_factores
integer x = 1024
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

type sle_ano from singlelineedit within w_cntbl_transf_factores
integer x = 1024
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

type cb_cancelar from commandbutton within w_cntbl_transf_factores
integer x = 1093
integer y = 828
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

type cb_generar from commandbutton within w_cntbl_transf_factores
integer x = 571
integer y = 824
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

ls_ano = TRIM(STRING(sle_ano.text))
ls_mes = TRIM(STRING(sle_mes.text))

DECLARE PB_USP_CNT_TRAN_GENERA_FACTORES PROCEDURE FOR USP_CNT_TRAN_GENERA_FACTORES
        ( :ls_ano, :ls_mes ) ;
EXECUTE PB_USP_CNT_TRAN_GENERA_FACTORES ;

IF sqlca.sqlcode = -1 THEN
	ROLLBACK ;
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	MessageBox ('Error',"Store Procedure USP_CNT_TRAN_GENERA_FACTORES Falló", StopSign!)
ELSE
	COMMIT ;
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
END IF

CLOSE PB_USP_CNT_TRAN_GENERA_FACTORES ;

cb_generar.enabled  = true
cb_cancelar.enabled = true
sle_ano.enabled     = true
sle_mes.enabled     = true
end event

type st_3 from statictext within w_cntbl_transf_factores
integer x = 773
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

type st_2 from statictext within w_cntbl_transf_factores
integer x = 773
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

type gb_1 from groupbox within w_cntbl_transf_factores
integer x = 626
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

