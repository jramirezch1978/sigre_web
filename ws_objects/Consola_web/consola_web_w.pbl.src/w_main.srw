$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
type pb_2 from picturebutton within w_main
end type
type pb_1 from picturebutton within w_main
end type
type gb_1 from groupbox within w_main
end type
end forward

global type w_main from w_main_ancst
integer width = 3314
integer height = 1588
string menuname = "m_master"
pb_2 pb_2
pb_1 pb_1
gb_1 gb_1
end type
global w_main w_main

on w_main.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_master" then this.MenuID = create m_master
this.pb_2=create pb_2
this.pb_1=create pb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.gb_1)
end on

type pb_2 from picturebutton within w_main
integer x = 78
integer y = 340
integer width = 421
integer height = 268
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Gif\comercializacion.gif"
alignment htextalign = left!
string powertiptext = "Empresas"
end type

event clicked;//Open(w_cw001_empresas)
//Open(w_prueba)
end event

type pb_1 from picturebutton within w_main
integer x = 78
integer y = 92
integer width = 402
integer height = 224
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Usuarios"
boolean originalsize = true
end type

type gb_1 from groupbox within w_main
integer x = 32
integer y = 32
integer width = 549
integer height = 1320
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

