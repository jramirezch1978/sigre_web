$PBExportHeader$w_datos_comparar.srw
forward
global type w_datos_comparar from window
end type
type cb_2 from commandbutton within w_datos_comparar
end type
type cb_1 from commandbutton within w_datos_comparar
end type
type dw_datos from datawindow within w_datos_comparar
end type
end forward

global type w_datos_comparar from window
integer width = 1650
integer height = 468
boolean titlebar = true
string title = "Opción de Datos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
dw_datos dw_datos
end type
global w_datos_comparar w_datos_comparar

type variables

end variables

on w_datos_comparar.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_datos=create dw_datos
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_datos}
end on

on w_datos_comparar.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_datos)
end on

event open;String ls_banco

ls_banco = Message.StringParm

dw_datos.Retrieve(ls_banco)

end event

type cb_2 from commandbutton within w_datos_comparar
integer x = 1129
integer y = 144
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;

CloseWithReturn(Parent, '')
end event

type cb_1 from commandbutton within w_datos_comparar
integer x = 1134
integer y = 32
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;Long ll_row
String ls_oper


dw_datos.Accepttext()
ll_row = dw_datos.getrow()

if ll_row = 0 then return 

ls_oper= dw_datos.object.oper[ll_row]



CloseWithReturn(Parent ,ls_oper)
end event

type dw_datos from datawindow within w_datos_comparar
integer x = 14
integer y = 32
integer width = 992
integer height = 296
integer taborder = 10
string title = "none"
string dataobject = "d_abc_oper_banc_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

event itemchanged;Accepttext()
end event

event itemerror;RETURN 1
end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

