$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
type p_logo2 from picture within w_logon
end type
end forward

global type w_logon from w_logon_ancst
integer width = 2359
p_logo2 p_logo2
end type
global w_logon w_logon

on w_logon.create
int iCurrent
call super::create
this.p_logo2=create p_logo2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_logo2
end on

on w_logon.destroy
call super::destroy
destroy(this.p_logo2)
end on

event open;call super::open;if gnvo_app.is_logo2 = '' or not FileExists(gnvo_app.is_logo2) then
	p_logo2.visible = false
else
	p_logo2.visible = true
	p_logo2.picturename = gnvo_app.is_logo2
end if
end event

type ole_skin from w_logon_ancst`ole_skin within w_logon
end type

type pb_cancelar from w_logon_ancst`pb_cancelar within w_logon
integer x = 1682
integer y = 988
end type

type pb_ok from w_logon_ancst`pb_ok within w_logon
integer x = 1179
integer y = 992
end type

type p_logo from w_logon_ancst`p_logo within w_logon
integer x = 1568
integer y = 8
end type

type p_1 from w_logon_ancst`p_1 within w_logon
end type

type st_psswd_db from w_logon_ancst`st_psswd_db within w_logon
end type

type sle_psswd_db from w_logon_ancst`sle_psswd_db within w_logon
integer width = 923
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
integer width = 923
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
end type

type st_user from w_logon_ancst`st_user within w_logon
end type

type sle_user from w_logon_ancst`sle_user within w_logon
integer width = 923
end type

type p_logo2 from picture within w_logon
integer x = 791
integer y = 8
integer width = 763
integer height = 376
boolean bringtotop = true
boolean focusrectangle = false
end type

