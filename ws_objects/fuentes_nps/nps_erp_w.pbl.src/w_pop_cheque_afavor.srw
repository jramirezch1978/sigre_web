$PBExportHeader$w_pop_cheque_afavor.srw
forward
global type w_pop_cheque_afavor from window
end type
type st_1 from statictext within w_pop_cheque_afavor
end type
type sle_1 from singlelineedit within w_pop_cheque_afavor
end type
type cb_1 from commandbutton within w_pop_cheque_afavor
end type
end forward

global type w_pop_cheque_afavor from window
integer width = 2313
integer height = 328
boolean titlebar = true
string title = "Ingrese Cheque a Favor "
windowtype windowtype = response!
long backcolor = 67108864
st_1 st_1
sle_1 sle_1
cb_1 cb_1
end type
global w_pop_cheque_afavor w_pop_cheque_afavor

on w_pop_cheque_afavor.create
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.Control[]={this.st_1,&
this.sle_1,&
this.cb_1}
end on

on w_pop_cheque_afavor.destroy
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

//f_centrar(This)


IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	sle_1.text = lstr_param.string1 
END IF
//**//



end event

type st_1 from statictext within w_pop_cheque_afavor
integer x = 23
integer y = 28
integer width = 471
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Cheque a Favor :"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_pop_cheque_afavor
integer x = 23
integer y = 108
integer width = 2254
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pop_cheque_afavor
integer x = 1929
integer y = 8
integer width = 343
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;str_parametros lstr_param


IF Isnull(sle_1.text) OR Trim(sle_1.text) = '' THEN
	Messagebox('Aviso','Debe Ingresar a Favor de quien se va generar el cheque')
END IF

lstr_param.string1 = sle_1.text 

CloseWithReturn(Parent,lstr_param)
end event

