$PBExportHeader$w_logon.srw
$PBExportComments$Ancestro para Logon
forward
global type w_logon from w_logon_ancst
end type
type st_1 from statictext within w_logon
end type
type p_1 from picture within w_logon
end type
type p_2 from picture within w_logon
end type
type gb_1 from groupbox within w_logon
end type
end forward

global type w_logon from w_logon_ancst
integer x = 830
integer width = 2341
integer height = 1200
st_1 st_1
p_1 p_1
p_2 p_2
gb_1 gb_1
end type
global w_logon w_logon

on w_logon.create
int iCurrent
call super::create
this.st_1=create st_1
this.p_1=create p_1
this.p_2=create p_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.gb_1
end on

on w_logon.destroy
call super::destroy
destroy(this.st_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.gb_1)
end on

type cbx_sesion from w_logon_ancst`cbx_sesion within w_logon
integer x = 1463
integer y = 700
end type

type cb_cancel from w_logon_ancst`cb_cancel within w_logon
integer x = 1353
integer y = 848
integer width = 407
integer height = 188
end type

type cb_ok from w_logon_ancst`cb_ok within w_logon
integer x = 928
integer y = 848
integer width = 407
integer height = 188
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
integer x = 1577
integer y = 584
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
integer x = 814
integer y = 584
integer height = 92
alignment alignment = right!
end type

type st_user from w_logon_ancst`st_user within w_logon
integer x = 1166
integer y = 472
integer height = 92
alignment alignment = right!
end type

type sle_user from w_logon_ancst`sle_user within w_logon
integer x = 1577
integer y = 472
end type

type st_1 from statictext within w_logon
integer x = 942
integer y = 92
integer width = 1285
integer height = 232
boolean bringtotop = true
integer textsize = -19
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 8388608
long backcolor = 16777215
string text = "Módulo de Activo Fijo"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_logon
integer x = 50
integer y = 60
integer width = 900
integer height = 450
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type p_2 from picture within w_logon
integer x = 1632
integer y = 228
integer width = 562
integer height = 120
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\Logo_2025.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_logon
integer width = 2309
integer height = 1100
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
end type

