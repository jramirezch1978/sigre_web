$PBExportHeader$w_rh237_abc_basc_tipoactivofinanciero.srw
forward
global type w_rh237_abc_basc_tipoactivofinanciero from w_abc_master_smpl
end type
end forward

global type w_rh237_abc_basc_tipoactivofinanciero from w_abc_master_smpl
integer width = 1806
integer height = 1288
string title = "(RH237) Tipos de Activos Financieros Personal"
string menuname = "m_master_simple"
end type
global w_rh237_abc_basc_tipoactivofinanciero w_rh237_abc_basc_tipoactivofinanciero

on w_rh237_abc_basc_tipoactivofinanciero.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh237_abc_basc_tipoactivofinanciero.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_modify;call super::ue_modify;String ls_protect

ls_protect = dw_master.Describe("tipo_activo.protect")
If ls_protect = '0' then
	dw_master.of_column_protect('tipo_activo')
End If
end event

event ue_update_pre;call super::ue_update_pre;
ib_update_check = False	
// Verifica que campos son requeridos y tengan valores
if not gnvo_app.of_row_Processing( dw_master) then return
ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh237_abc_basc_tipoactivofinanciero
integer width = 1737
integer height = 1092
string dataobject = "d_abc_basc_tipo_activo_financiero"
string is_dwform = "grid"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr				[al_row] = gs_user
end event

