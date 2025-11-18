$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
type p_1 from picture within w_logon
end type
type st_1 from statictext within w_logon
end type
type gb_1 from groupbox within w_logon
end type
end forward

global type w_logon from w_logon_ancst
integer width = 2309
integer height = 1308
p_1 p_1
st_1 st_1
gb_1 gb_1
end type
global w_logon w_logon

on w_logon.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_logon.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_1)
destroy(this.gb_1)
end on

type st_psswd_db from w_logon_ancst`st_psswd_db within w_logon
integer x = 695
integer y = 460
integer weight = 400
fontcharset fontcharset = defaultcharset!
string facename = "Arial Narrow"
alignment alignment = right!
end type

type sle_psswd_db from w_logon_ancst`sle_psswd_db within w_logon
integer x = 1632
integer y = 464
end type

type cb_cancel from w_logon_ancst`cb_cancel within w_logon
integer x = 1687
integer y = 608
end type

type cb_ok from w_logon_ancst`cb_ok within w_logon
integer x = 1216
integer y = 608
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
integer x = 1632
integer y = 340
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
integer x = 818
integer y = 352
integer height = 104
integer weight = 400
fontcharset fontcharset = defaultcharset!
string facename = "Arial Narrow"
alignment alignment = right!
end type

type st_user from w_logon_ancst`st_user within w_logon
integer x = 1170
integer y = 232
integer weight = 400
fontcharset fontcharset = defaultcharset!
string facename = "Arial Narrow"
alignment alignment = right!
end type

type sle_user from w_logon_ancst`sle_user within w_logon
integer x = 1637
integer y = 220
end type

type p_1 from picture within w_logon
integer x = 55
integer y = 192
integer width = 805
integer height = 496
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type st_1 from statictext within w_logon
integer x = 27
integer y = 48
integer width = 2094
integer height = 96
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long backcolor = 16777215
string text = "SISTEMA CONSOLA WEB"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_logon
integer x = 14
integer y = 4
integer width = 2277
integer height = 1172
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
end type

