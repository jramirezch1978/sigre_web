$PBExportHeader$w_ap004_precios_rep.srw
forward
global type w_ap004_precios_rep from w_abc_master_smpl
end type
end forward

global type w_ap004_precios_rep from w_abc_master_smpl
integer width = 1774
integer height = 1524
string title = "Precios de Representacion (AP004)"
string menuname = "m_mantto_tablas"
boolean resizable = false
boolean center = true
end type
global w_ap004_precios_rep w_ap004_precios_rep

type variables

end variables

on w_ap004_precios_rep.create
call super::create
if this.MenuName = "m_mantto_tablas" then this.MenuID = create m_mantto_tablas
end on

on w_ap004_precios_rep.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
dw_master.retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ap004_precios_rep
integer width = 1714
integer height = 1168
string dataobject = "d_ap_precios_rep_tbl"
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr [al_row] = gs_user
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

