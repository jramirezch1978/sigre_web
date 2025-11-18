$PBExportHeader$w_cn035_grupo_centro_costo.srw
forward
global type w_cn035_grupo_centro_costo from w_abc_mastdet_smpl
end type
end forward

global type w_cn035_grupo_centro_costo from w_abc_mastdet_smpl
integer width = 2610
integer height = 1620
string title = "Grupos de centros de costo (CN035)"
string menuname = "m_abc_mastdet_smpl"
end type
global w_cn035_grupo_centro_costo w_cn035_grupo_centro_costo

on w_cn035_grupo_centro_costo.create
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
end on

on w_cn035_grupo_centro_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn035_grupo_centro_costo
integer width = 2546
string dataobject = "d_abc_grupo_cencos_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn035_grupo_centro_costo
integer width = 2551
integer height = 900
string dataobject = "d_abc_grupo_cencos_det_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master

end event

