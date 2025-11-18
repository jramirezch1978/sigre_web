$PBExportHeader$w_pop_comprobante_ret.srw
forward
global type w_pop_comprobante_ret from window
end type
type cb_1 from commandbutton within w_pop_comprobante_ret
end type
type dw_1 from datawindow within w_pop_comprobante_ret
end type
end forward

global type w_pop_comprobante_ret from window
integer width = 1577
integer height = 396
boolean titlebar = true
string title = "Ingrese Periodo de Pre - Asientos"
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
cb_1 cb_1
dw_1 dw_1
end type
global w_pop_comprobante_ret w_pop_comprobante_ret

on w_pop_comprobante_ret.create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.dw_1}
end on

on w_pop_comprobante_ret.destroy
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;


end event

type cb_1 from commandbutton within w_pop_comprobante_ret
integer x = 1198
integer y = 104
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;String ls_nro_certificado
str_parametros lstr_param


dw_1.Accepttext()

ls_nro_certificado = dw_1.object.nro_certificado [1]

IF Isnull(ls_nro_certificado) THEN
	Messagebox('Aviso','Debe Ingresar Algun Nro de Certificado ')
   Return	
END IF	




lstr_param.string1 = ls_nro_certificado

CloseWithReturn(Parent,lstr_param)
end event

type dw_1 from datawindow within w_pop_comprobante_ret
integer x = 27
integer y = 104
integer width = 1079
integer height = 92
integer taborder = 20
string title = "none"
string dataobject = "d_ext_comprobante_ret_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()

end event

event itemerror;Return 1
end event

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

