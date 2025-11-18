$PBExportHeader$w_fl003_capit_puerto.srw
forward
global type w_fl003_capit_puerto from w_abc_master_smpl
end type
end forward

global type w_fl003_capit_puerto from w_abc_master_smpl
integer x = 0
integer y = 0
integer width = 3319
integer height = 1100
string title = "Capitanias de Puerto (FL003)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
integer ii_x = 0
boolean ib_update_check = false
end type
global w_fl003_capit_puerto w_fl003_capit_puerto

on w_fl003_capit_puerto.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl003_capit_puerto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl003_capit_puerto
integer x = 0
integer y = 0
integer width = 3250
integer height = 824
string dataobject = "d_capit_puert_grid"
end type

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

