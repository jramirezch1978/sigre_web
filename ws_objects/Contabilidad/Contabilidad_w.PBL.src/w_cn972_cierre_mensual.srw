$PBExportHeader$w_cn972_cierre_mensual.srw
forward
global type w_cn972_cierre_mensual from w_prc
end type
type st_3 from statictext within w_cn972_cierre_mensual
end type
type st_2 from statictext within w_cn972_cierre_mensual
end type
type em_mes from editmask within w_cn972_cierre_mensual
end type
type em_ano from editmask within w_cn972_cierre_mensual
end type
type cb_cancelar from commandbutton within w_cn972_cierre_mensual
end type
type cb_generar from commandbutton within w_cn972_cierre_mensual
end type
type st_1 from statictext within w_cn972_cierre_mensual
end type
type gb_1 from groupbox within w_cn972_cierre_mensual
end type
end forward

global type w_cn972_cierre_mensual from w_prc
integer width = 1678
integer height = 1100
string title = "(CN972) Asiento de Cierre Mensual"
st_3 st_3
st_2 st_2
em_mes em_mes
em_ano em_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_1 gb_1
end type
global w_cn972_cierre_mensual w_cn972_cierre_mensual

on w_cn972_cierre_mensual.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.em_mes=create em_mes
this.em_ano=create em_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn972_cierre_mensual.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_mes)
destroy(this.em_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_3 from statictext within w_cn972_cierre_mensual
integer x = 585
integer y = 528
integer width = 123
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn972_cierre_mensual
integer x = 585
integer y = 400
integer width = 123
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_mes from editmask within w_cn972_cierre_mensual
integer x = 731
integer y = 512
integer width = 233
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_ano from editmask within w_cn972_cierre_mensual
integer x = 731
integer y = 384
integer width = 233
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_cancelar from commandbutton within w_cn972_cierre_mensual
integer x = 878
integer y = 812
integer width = 320
integer height = 80
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

type cb_generar from commandbutton within w_cn972_cierre_mensual
integer x = 398
integer y = 808
integer width = 320
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;cb_generar.enabled  = false
cb_cancelar.enabled = false

integer li_ano, li_mes
string ls_mensaje

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

DECLARE PB_USP_CNTBL_ASIENTO_17 PROCEDURE FOR USP_CNTBL_ASIENTO_17
        ( :li_ano, :li_mes, :gs_origen, :gs_user ) ;
EXECUTE PB_USP_CNTBL_ASIENTO_17 ;

IF sqlca.sqlcode = -1 THEN
   ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', ls_mensaje, StopSign! )
	MessageBox ('Error',"Store Procedure USP_CNTBL_ASIENTO_17 Falló", StopSign!)
ELSE
	COMMIT ;
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
END IF

CLOSE PB_USP_CNTBL_ASIENTO_17 ;

cb_generar.enabled  = true
cb_cancelar.enabled = true

end event

type st_1 from statictext within w_cn972_cierre_mensual
integer x = 146
integer y = 112
integer width = 1303
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "ASIENTO DE CIERRE MENSUAL"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn972_cierre_mensual
integer x = 485
integer y = 288
integer width = 622
integer height = 384
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Fecha "
end type

