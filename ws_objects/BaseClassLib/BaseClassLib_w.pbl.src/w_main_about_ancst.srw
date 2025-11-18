$PBExportHeader$w_main_about_ancst.srw
$PBExportComments$Ancestrp para Help About
forward
global type w_main_about_ancst from window
end type
type st_4 from statictext within w_main_about_ancst
end type
type st_3 from statictext within w_main_about_ancst
end type
type st_2 from statictext within w_main_about_ancst
end type
type st_1 from statictext within w_main_about_ancst
end type
type cb_ok from commandbutton within w_main_about_ancst
end type
end forward

global type w_main_about_ancst from window
integer x = 873
integer y = 428
integer width = 1897
integer height = 768
boolean titlebar = true
string title = "Acerca de..."
windowtype windowtype = response!
long backcolor = 67108864
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_ok cb_ok
end type
global w_main_about_ancst w_main_about_ancst

type variables
Integer ii_help
end variables

on w_main_about_ancst.create
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_ok=create cb_ok
this.Control[]={this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_ok}
end on

on w_main_about_ancst.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_ok)
end on

type st_4 from statictext within w_main_about_ancst
integer x = 78
integer y = 560
integer width = 690
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Junio 2007"
long bordercolor = 134217732
boolean focusrectangle = false
end type

type st_3 from statictext within w_main_about_ancst
integer x = 69
integer y = 420
integer width = 1083
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Hecho por Jhonny Ramírez Chiroque"
long bordercolor = 134217732
boolean focusrectangle = false
end type

type st_2 from statictext within w_main_about_ancst
integer x = 32
integer y = 144
integer width = 1678
integer height = 96
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "Versión 1.0"
long bordercolor = 134217732
boolean focusrectangle = false
end type

type st_1 from statictext within w_main_about_ancst
integer x = 41
integer y = 12
integer width = 1701
integer height = 96
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "Sistema Integrado de Gestión de Rescursos Empresariales"
long bordercolor = 134217732
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_main_about_ancst
integer x = 1458
integer y = 492
integer width = 279
integer height = 108
integer taborder = 1
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
boolean default = true
end type

event clicked;
Close (parent)
end event

