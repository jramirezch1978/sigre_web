$PBExportHeader$w_fl001_motiv_mov.srw
forward
global type w_fl001_motiv_mov from w_abc_master_smpl
end type
end forward

global type w_fl001_motiv_mov from w_abc_master_smpl
integer width = 2249
integer height = 1076
string title = "Motivos de Traslado de la Embarcación (FL001)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl001_motiv_mov w_fl001_motiv_mov

on w_fl001_motiv_mov.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl001_motiv_mov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl001_motiv_mov
integer width = 2181
integer height = 824
string dataobject = "d_motiv_mov_grid"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string 	ls_motiv_mov, ls_tmp
long		ll_row

ls_motiv_mov = '000'
for ll_row = 1 to this.RowCount()
	ls_tmp = this.object.motivo_movimiento[ll_row]
	if ls_tmp > ls_motiv_mov then
		ls_motiv_mov = ls_tmp
	end if
next

ls_motiv_mov = string(integer(ls_motiv_mov) + 1, '000')

this.object.motivo_movimiento	[al_row] = ls_motiv_mov
this.object.flag_estado			[al_row] = '1'

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

