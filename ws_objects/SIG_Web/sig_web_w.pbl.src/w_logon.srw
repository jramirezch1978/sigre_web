$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
type p_1 from picture within w_logon
end type
type gb_1 from groupbox within w_logon
end type
end forward

global type w_logon from w_logon_ancst
integer width = 3058
integer height = 1464
boolean controlmenu = false
p_1 p_1
gb_1 gb_1
end type
global w_logon w_logon

on w_logon.create
int iCurrent
call super::create
this.p_1=create p_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.gb_1
end on

on w_logon.destroy
call super::destroy
destroy(this.p_1)
destroy(this.gb_1)
end on

type st_psswd_db from w_logon_ancst`st_psswd_db within w_logon
integer x = 1257
integer y = 792
alignment alignment = right!
end type

type sle_psswd_db from w_logon_ancst`sle_psswd_db within w_logon
integer x = 2162
integer y = 800
end type

type cb_cancel from w_logon_ancst`cb_cancel within w_logon
integer x = 2469
integer y = 964
integer width = 352
integer height = 212
end type

type cb_ok from w_logon_ancst`cb_ok within w_logon
integer x = 1998
integer y = 964
integer width = 352
integer height = 212
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
integer x = 2162
integer y = 676
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
integer x = 1381
integer y = 684
alignment alignment = right!
end type

type st_user from w_logon_ancst`st_user within w_logon
integer x = 1733
integer y = 564
alignment alignment = right!
end type

type sle_user from w_logon_ancst`sle_user within w_logon
integer x = 2167
integer y = 556
end type

type p_1 from picture within w_logon
integer x = 178
integer y = 208
integer width = 951
integer height = 548
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_logon
integer width = 3013
integer height = 1356
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
end type

