$PBExportHeader$w_pt017_tipos_prtda_prsp.srw
forward
global type w_pt017_tipos_prtda_prsp from w_abc_mastdet_smpl
end type
end forward

global type w_pt017_tipos_prtda_prsp from w_abc_mastdet_smpl
integer width = 1870
integer height = 2340
string title = "Tipos de Partida Presupuestal (PT017)"
string menuname = "m_mantenimiento_simple"
end type
global w_pt017_tipos_prtda_prsp w_pt017_tipos_prtda_prsp

on w_pt017_tipos_prtda_prsp.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_pt017_tipos_prtda_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

if f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pt017_tipos_prtda_prsp
integer width = 1632
integer height = 772
string dataobject = "d_abc_tipo_prtda_prsp_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_output;call super::ue_output;dw_detail.REtrieve(dw_master.object.grp_prtda_prsp[dw_master.GEtRow()] )
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pt017_tipos_prtda_prsp
integer x = 0
integer y = 796
integer width = 1659
integer height = 780
string dataobject = "d_abc_tipo_prtda_prsp_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 2 	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

