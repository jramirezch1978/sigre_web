$PBExportHeader$w_cv_pro_inicializa_mov.srw
forward
global type w_cv_pro_inicializa_mov from w_prc
end type
type st_5 from statictext within w_cv_pro_inicializa_mov
end type
type cb_cancelar from commandbutton within w_cv_pro_inicializa_mov
end type
type cb_generar from commandbutton within w_cv_pro_inicializa_mov
end type
type st_1 from statictext within w_cv_pro_inicializa_mov
end type
type gb_1 from groupbox within w_cv_pro_inicializa_mov
end type
end forward

global type w_cv_pro_inicializa_mov from w_prc
integer width = 1829
integer height = 912
string title = "Contabilidad"
st_5 st_5
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_1 gb_1
end type
global w_cv_pro_inicializa_mov w_cv_pro_inicializa_mov

on w_cv_pro_inicializa_mov.create
int iCurrent
call super::create
this.st_5=create st_5
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.cb_generar
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_cv_pro_inicializa_mov.destroy
call super::destroy
destroy(this.st_5)
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

type st_5 from statictext within w_cv_pro_inicializa_mov
integer x = 142
integer y = 220
integer width = 1490
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "COSTOS DE VENTAS DE AZUCAR"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_cv_pro_inicializa_mov
integer x = 946
integer y = 516
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

type cb_generar from commandbutton within w_cv_pro_inicializa_mov
integer x = 517
integer y = 512
integer width = 320
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Eliminar"
end type

event clicked;cb_generar.enabled  = false
cb_cancelar.enabled = false

update cntbl_cv_plantilla_det
  set valor_manual = 0
  where flag_tipo_calculo = 'I' ;
  
COMMIT ;

MESSAGEBOX ('Atención', "Proceso Ha Concluído Satisfactoriamente")

cb_generar.enabled  = true
cb_cancelar.enabled = true

end event

type st_1 from statictext within w_cv_pro_inicializa_mov
integer x = 183
integer y = 80
integer width = 1408
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "ELIMINA MOVIMIENTO MENSUAL DE "
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cv_pro_inicializa_mov
integer x = 407
integer y = 432
integer width = 960
integer height = 216
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Opción "
end type

