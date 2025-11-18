$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
end forward

global type w_logon from w_logon_ancst
integer width = 1728
integer height = 844
end type
global w_logon w_logon

on w_logon.create
call super::create
end on

on w_logon.destroy
call super::destroy
end on

type st_psswd_db from w_logon_ancst`st_psswd_db within w_logon
end type

type sle_psswd_db from w_logon_ancst`sle_psswd_db within w_logon
end type

type cb_cancel from w_logon_ancst`cb_cancel within w_logon
end type

type cb_ok from w_logon_ancst`cb_ok within w_logon
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
end type

type st_user from w_logon_ancst`st_user within w_logon
end type

type sle_user from w_logon_ancst`sle_user within w_logon
end type

