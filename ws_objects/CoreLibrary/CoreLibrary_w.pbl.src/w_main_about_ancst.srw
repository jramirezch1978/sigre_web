$PBExportHeader$w_main_about_ancst.srw
$PBExportComments$Ancestrp para Help About
forward
global type w_main_about_ancst from window
end type
type pb_1 from picturebutton within w_main_about_ancst
end type
type st_2 from statictext within w_main_about_ancst
end type
type st_1 from statictext within w_main_about_ancst
end type
type p_1 from picture within w_main_about_ancst
end type
end forward

global type w_main_about_ancst from window
integer x = 873
integer y = 428
integer width = 2025
integer height = 1504
boolean titlebar = true
string title = "About"
boolean controlmenu = true
windowtype windowtype = response!
boolean center = true
pb_1 pb_1
st_2 st_2
st_1 st_1
p_1 p_1
end type
global w_main_about_ancst w_main_about_ancst

type variables
Integer ii_help
end variables

on w_main_about_ancst.create
this.pb_1=create pb_1
this.st_2=create st_2
this.st_1=create st_1
this.p_1=create p_1
this.Control[]={this.pb_1,&
this.st_2,&
this.st_1,&
this.p_1}
end on

on w_main_about_ancst.destroy
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_1)
end on

type pb_1 from picturebutton within w_main_about_ancst
integer x = 1591
integer y = 1140
integer width = 334
integer height = 248
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "C:\SIGRE\resources\JPG\Ok.jpg"
string powertiptext = "Haga click aqui para cerrar la ventana"
end type

event clicked;Close(parent)
end event

type st_2 from statictext within w_main_about_ancst
integer x = 119
integer y = 1140
integer width = 1088
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 16711680
string text = "Copyrigth @ N.P.S.S.A.C. 2011"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_main_about_ancst
integer x = 41
integer y = 32
integer width = 1870
integer height = 184
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Nina"
long textcolor = 16711680
string text = "SOLUCIÓN INTEGRAL DE GESTIÓN DE RECURSOS EMPRESARIALES"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_main_about_ancst
integer x = 73
integer y = 240
integer width = 1838
integer height = 852
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

