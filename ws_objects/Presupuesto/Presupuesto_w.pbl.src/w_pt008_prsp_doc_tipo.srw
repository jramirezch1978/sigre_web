$PBExportHeader$w_pt008_prsp_doc_tipo.srw
forward
global type w_pt008_prsp_doc_tipo from w_abc_master_smpl
end type
end forward

global type w_pt008_prsp_doc_tipo from w_abc_master_smpl
string title = "Modificar Flag Prsp en Doc Tipo (PT008)"
string menuname = "m_save_modif_exit"
end type
global w_pt008_prsp_doc_tipo w_pt008_prsp_doc_tipo

on w_pt008_prsp_doc_tipo.create
call super::create
if this.MenuName = "m_save_modif_exit" then this.MenuID = create m_save_modif_exit
end on

on w_pt008_prsp_doc_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_pt008_prsp_doc_tipo
integer x = 0
integer y = 0
string dataobject = "d_abc_flag_prsp_doc_tipo_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_Replicacion[al_row] = '1'
end event

