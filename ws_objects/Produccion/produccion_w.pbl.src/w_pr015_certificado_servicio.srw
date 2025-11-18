$PBExportHeader$w_pr015_certificado_servicio.srw
forward
global type w_pr015_certificado_servicio from w_abc_master_smpl
end type
end forward

global type w_pr015_certificado_servicio from w_abc_master_smpl
integer width = 1728
integer height = 1000
string title = "Servicios del Certificado(PR015)"
string menuname = "m_mantto_smpl"
end type
global w_pr015_certificado_servicio w_pr015_certificado_servicio

on w_pr015_certificado_servicio.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr015_certificado_servicio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = true
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()


end event

event ue_update;call super::ue_update;//if dw_master.ii_update = 0 then
//	this.event ue_dw_share( )
//end if

dw_master.retrieve( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr015_certificado_servicio
integer width = 1623
string dataobject = "d_abc_certificado_servicio_tbl"
end type

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
Return 1
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

