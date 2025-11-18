$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
end forward

global type w_logon from w_logon_ancst
end type
global w_logon w_logon

on w_logon.create
call super::create
end on

on w_logon.destroy
call super::destroy
end on

type pb_cancelar from w_logon_ancst`pb_cancelar within w_logon
end type

type pb_ok from w_logon_ancst`pb_ok within w_logon
end type

type p_logo from w_logon_ancst`p_logo within w_logon
end type

type p_1 from w_logon_ancst`p_1 within w_logon
end type

type st_psswd_db from w_logon_ancst`st_psswd_db within w_logon
end type

type sle_psswd_db from w_logon_ancst`sle_psswd_db within w_logon
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
end type

type st_user from w_logon_ancst`st_user within w_logon
end type

type sle_user from w_logon_ancst`sle_user within w_logon
end type

