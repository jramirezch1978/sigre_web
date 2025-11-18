$PBExportHeader$w_rh241_abc_tipos_permiso_papeleta.srw
forward
global type w_rh241_abc_tipos_permiso_papeleta from w_abc_master_smpl
end type
end forward

global type w_rh241_abc_tipos_permiso_papeleta from w_abc_master_smpl
integer y = 360
integer width = 3013
integer height = 1373
string title = "(RH241) Tipos de Permiso para Papeletas de Salida"
string menuname = "m_master_simple"
end type
global w_rh241_abc_tipos_permiso_papeleta w_rh241_abc_tipos_permiso_papeleta

on w_rh241_abc_tipos_permiso_papeleta.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh241_abc_tipos_permiso_papeleta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_modify;call super::ue_modify;String ls_protect

ls_protect = dw_master.Describe("tipo_permiso.protect")
If ls_protect = '0' then
	dw_master.of_column_protect('tipo_permiso')
End If
end event

event ue_update_pre;call super::ue_update_pre;
ib_update_check = False	
// Verifica que campos son requeridos y tengan valores
if not gnvo_app.of_row_Processing( dw_master) then return
ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh241_abc_tipos_permiso_papeleta
integer x = 29
integer y = 26
integer width = 2929
integer height = 1181
string dataobject = "d_abc_tipo_permiso_papeleta_grd"
string is_dwform = "grid"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

