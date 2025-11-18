$PBExportHeader$w_system_error.srw
forward
global type w_system_error from window
end type
type cb_Aceptar from commandbutton within w_system_error
end type
type p_1 from picture within w_system_error
end type
type st_7 from statictext within w_system_error
end type
type st_no from statictext within w_system_error
end type
type st_6 from statictext within w_system_error
end type
type st_nw from statictext within w_system_error
end type
type st_ne from statictext within w_system_error
end type
type st_le from statictext within w_system_error
end type
type st_nue from statictext within w_system_error
end type
type st_te from statictext within w_system_error
end type
type st_5 from statictext within w_system_error
end type
type st_4 from statictext within w_system_error
end type
type st_3 from statictext within w_system_error
end type
type st_2 from statictext within w_system_error
end type
type st_1 from statictext within w_system_error
end type
end forward

global type w_system_error from window
integer width = 2473
integer height = 1252
boolean titlebar = true
string title = "Ventana de Errores "
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_Aceptar cb_Aceptar
p_1 p_1
st_7 st_7
st_no st_no
st_6 st_6
st_nw st_nw
st_ne st_ne
st_le st_le
st_nue st_nue
st_te st_te
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_system_error w_system_error

on w_system_error.create
this.cb_Aceptar=create cb_Aceptar
this.p_1=create p_1
this.st_7=create st_7
this.st_no=create st_no
this.st_6=create st_6
this.st_nw=create st_nw
this.st_ne=create st_ne
this.st_le=create st_le
this.st_nue=create st_nue
this.st_te=create st_te
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.cb_Aceptar,&
this.p_1,&
this.st_7,&
this.st_no,&
this.st_6,&
this.st_nw,&
this.st_ne,&
this.st_le,&
this.st_nue,&
this.st_te,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_system_error.destroy
destroy(this.cb_Aceptar)
destroy(this.p_1)
destroy(this.st_7)
destroy(this.st_no)
destroy(this.st_6)
destroy(this.st_nw)
destroy(this.st_ne)
destroy(this.st_le)
destroy(this.st_nue)
destroy(this.st_te)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;String ls_msj_err,ls_linea_err,ls_nro_err,ls_desc_err

st_nw.text  = error.windowmenu     //nombre de ventana
st_no.text  = error.object		     //nombre de objeto
st_ne.text  = error.objectevent    //nombre de evento
st_le.text  = String(error.line)   //linea de error
st_nue.text = String(error.number) //numero de error
st_te.text  = error.text		     //texto de error


ls_linea_err = String(error.line)
ls_nro_err	 = String(error.number)
ls_desc_err	 = Mid(error.text,1,300)



end event

type cb_Aceptar from commandbutton within w_system_error
integer x = 1376
integer y = 984
integer width = 453
integer height = 116
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean cancel = true
boolean default = true
end type

event clicked;Close(parent)
end event

type p_1 from picture within w_system_error
integer x = 73
integer y = 992
integer width = 110
integer height = 96
string picturename = "Custom084!"
boolean focusrectangle = false
end type

type st_7 from statictext within w_system_error
integer x = 329
integer y = 1024
integer width = 768
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Comunicarse con Sistemas"
boolean focusrectangle = false
end type

type st_no from statictext within w_system_error
integer x = 731
integer y = 160
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_6 from statictext within w_system_error
integer x = 73
integer y = 160
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nombre de Objeto :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nw from statictext within w_system_error
integer x = 731
integer y = 32
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_ne from statictext within w_system_error
integer x = 731
integer y = 288
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_le from statictext within w_system_error
integer x = 731
integer y = 416
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_nue from statictext within w_system_error
integer x = 731
integer y = 544
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_te from statictext within w_system_error
integer x = 731
integer y = 672
integer width = 1609
integer height = 280
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_5 from statictext within w_system_error
integer x = 73
integer y = 672
integer width = 576
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Texto Error :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_system_error
integer x = 73
integer y = 544
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero de Error :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_system_error
integer x = 73
integer y = 416
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Linea de Error :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_system_error
integer x = 73
integer y = 288
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre de Evento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_system_error
integer x = 73
integer y = 32
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre de Ventana :"
alignment alignment = right!
boolean focusrectangle = false
end type

