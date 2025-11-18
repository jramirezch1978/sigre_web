$PBExportHeader$w_pop_tipo_doc.srw
forward
global type w_pop_tipo_doc from window
end type
type st_2 from statictext within w_pop_tipo_doc
end type
type sle_2 from singlelineedit within w_pop_tipo_doc
end type
type st_1 from statictext within w_pop_tipo_doc
end type
type sle_1 from singlelineedit within w_pop_tipo_doc
end type
type cb_1 from commandbutton within w_pop_tipo_doc
end type
end forward

global type w_pop_tipo_doc from window
integer width = 1879
integer height = 236
boolean titlebar = true
string title = "Ingrese Cheque a Favor "
windowtype windowtype = response!
long backcolor = 67108864
st_2 st_2
sle_2 sle_2
st_1 st_1
sle_1 sle_1
cb_1 cb_1
end type
global w_pop_tipo_doc w_pop_tipo_doc

on w_pop_tipo_doc.create
this.st_2=create st_2
this.sle_2=create sle_2
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.Control[]={this.st_2,&
this.sle_2,&
this.st_1,&
this.sle_1,&
this.cb_1}
end on

on w_pop_tipo_doc.destroy
destroy(this.st_2)
destroy(this.sle_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	sle_1.text = lstr_param.string1 
END IF
//**//




sle_1.setfocus()
end event

type st_2 from statictext within w_pop_tipo_doc
integer x = 663
integer y = 52
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro. Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_pop_tipo_doc
integer x = 1056
integer y = 40
integer width = 343
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pop_tipo_doc
integer x = 23
integer y = 48
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tipo Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_pop_tipo_doc
integer x = 343
integer y = 40
integer width = 210
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pop_tipo_doc
integer x = 1477
integer y = 40
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
	Messagebox('Aviso','Debe Ingresar Tipo de Documento ,Verifique!')
	RETURN
END IF

IF Isnull(sle_2.text) OR Trim(sle_2.text) = '' THEN
	Messagebox('Aviso','Debe Ingresar Nro de Documento ,Verifique!')
	RETURN
END IF


lstr_param.bret = TRUE

lstr_param.string1 = sle_1.text 
lstr_param.string3 = sle_2.text 

CloseWithReturn(Parent,lstr_param)
end event

