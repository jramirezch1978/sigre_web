$PBExportHeader$w_reprogra_ope_detalle_pop.srw
forward
global type w_reprogra_ope_detalle_pop from window
end type
type cb_aceptar_subsecuentes from commandbutton within w_reprogra_ope_detalle_pop
end type
type cb_2 from commandbutton within w_reprogra_ope_detalle_pop
end type
type cb_aceptar_registro from commandbutton within w_reprogra_ope_detalle_pop
end type
type dw_1 from datawindow within w_reprogra_ope_detalle_pop
end type
end forward

global type w_reprogra_ope_detalle_pop from window
integer x = 823
integer y = 360
integer width = 2386
integer height = 976
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
cb_aceptar_subsecuentes cb_aceptar_subsecuentes
cb_2 cb_2
cb_aceptar_registro cb_aceptar_registro
dw_1 dw_1
end type
global w_reprogra_ope_detalle_pop w_reprogra_ope_detalle_pop

on w_reprogra_ope_detalle_pop.create
this.cb_aceptar_subsecuentes=create cb_aceptar_subsecuentes
this.cb_2=create cb_2
this.cb_aceptar_registro=create cb_aceptar_registro
this.dw_1=create dw_1
this.Control[]={this.cb_aceptar_subsecuentes,&
this.cb_2,&
this.cb_aceptar_registro,&
this.dw_1}
end on

on w_reprogra_ope_detalle_pop.destroy
destroy(this.cb_aceptar_subsecuentes)
destroy(this.cb_2)
destroy(this.cb_aceptar_registro)
destroy(this.dw_1)
end on

event open;String ls_parametro, ls_corr_corte
Integer li_nro_operacion
ls_parametro = Message.StringParm
ls_corr_corte = mid( ls_parametro, 1, 11)
li_nro_operacion = Integer(mid( ls_parametro, 12, 4))
dw_1.SetTransObject(SQLCA);
dw_1.retrieve(ls_corr_corte, li_nro_operacion)
end event

type cb_aceptar_subsecuentes from commandbutton within w_reprogra_ope_detalle_pop
integer x = 1010
integer y = 788
integer width = 869
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Actualizar también subsecuentes"
boolean default = true
end type

event clicked;IF dw_1.Update() = -1 then		// Grabacion del Master
	ROLLBACK using SQLCA;
	messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
ELSE
	COMMIT using SQLCA;
	CloseWithReturn(Parent, "subsecuentes")
//	Close (This.GetParent())
END IF

end event

type cb_2 from commandbutton within w_reprogra_ope_detalle_pop
integer x = 2066
integer y = 788
integer width = 288
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;CloseWithReturn(Parent, "cancelar")
//Close (This.GetParent())
end event

type cb_aceptar_registro from commandbutton within w_reprogra_ope_detalle_pop
integer x = 18
integer y = 788
integer width = 869
integer height = 88
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Actualizar solo este registro"
boolean default = true
end type

event clicked;IF dw_1.Update() = -1 then		// Grabacion del Master
	ROLLBACK using SQLCA;
	messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
ELSE
	COMMIT using SQLCA;
	CloseWithReturn(Parent, "solo_registro")
END IF

end event

type dw_1 from datawindow within w_reprogra_ope_detalle_pop
integer x = 18
integer y = 20
integer width = 2336
integer height = 752
integer taborder = 10
string dataobject = "d_reprogra_ope_detalle_ff"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;cb_aceptar_registro.enabled = True
cb_aceptar_subsecuentes.enabled = True
end event

event editchanged;cb_aceptar_registro.enabled = True
cb_aceptar_subsecuentes.enabled = True
end event

