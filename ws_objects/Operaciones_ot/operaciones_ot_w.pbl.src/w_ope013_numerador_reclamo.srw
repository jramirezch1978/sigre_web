$PBExportHeader$w_ope013_numerador_reclamo.srw
forward
global type w_ope013_numerador_reclamo from w_abc_master_smpl
end type
end forward

global type w_ope013_numerador_reclamo from w_abc_master_smpl
integer width = 690
integer height = 752
string title = "Numerador de reclamos (ope013)"
end type
global w_ope013_numerador_reclamo w_ope013_numerador_reclamo

on w_ope013_numerador_reclamo.create
call super::create
end on

on w_ope013_numerador_reclamo.destroy
call super::destroy
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(150,150)
//ii_help = 101 
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope013_numerador_reclamo
integer width = 617
integer height = 568
string dataobject = "d_num_cal_reclamo_tbl"
boolean hscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

end event

