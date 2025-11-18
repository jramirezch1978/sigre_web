$PBExportHeader$w_clave_request.srw
forward
global type w_clave_request from window
end type
type cb_cancelar from commandbutton within w_clave_request
end type
type cb_aceptar from commandbutton within w_clave_request
end type
type sle_clave from singlelineedit within w_clave_request
end type
type st_1 from statictext within w_clave_request
end type
end forward

global type w_clave_request from window
integer width = 2647
integer height = 968
boolean titlebar = true
string title = "Ingreso de Clave"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_clave sle_clave
st_1 st_1
end type
global w_clave_request w_clave_request

event ue_cancelar();Str_parametros	lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();Str_parametros	lstr_param

if trim(sle_clave.text) = '' then
	MessageBox('Aviso', 'Debe ingresar una clave, por favor verifique!', StopSign!)
	sle_clave.setFocus()
	return
end if

lstr_param.b_return 	= true
lstr_param.s_clave 	= trim(sle_clave.text)

CloseWithReturn(this, lstr_param)
end event

on w_clave_request.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_clave=create sle_clave
this.st_1=create st_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.sle_clave,&
this.st_1}
end on

on w_clave_request.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_clave)
destroy(this.st_1)
end on

type cb_cancelar from commandbutton within w_clave_request
integer x = 1321
integer y = 556
integer width = 882
integer height = 248
integer taborder = 20
integer textsize = -30
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()

end event

type cb_aceptar from commandbutton within w_clave_request
integer x = 430
integer y = 556
integer width = 882
integer height = 248
integer taborder = 20
integer textsize = -30
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.dynamic event ue_aceptar()
end event

type sle_clave from singlelineedit within w_clave_request
event ue_keyup pbm_keyup
integer y = 224
integer width = 2629
integer height = 316
integer taborder = 10
integer textsize = -30
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 255
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;if len(trim(this.text)) = 0 then
	cb_Aceptar.default = false
else
	cb_Aceptar.default = true
end if
end event

type st_1 from statictext within w_clave_request
integer width = 2629
integer height = 208
integer textsize = -30
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CLAVE"
alignment alignment = center!
boolean focusrectangle = false
end type

