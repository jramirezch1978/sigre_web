$PBExportHeader$w_cn203_abc_cp_procesos.srw
forward
global type w_cn203_abc_cp_procesos from w_abc_master_smpl
end type
end forward

global type w_cn203_abc_cp_procesos from w_abc_master_smpl
integer width = 2299
integer height = 1076
string title = "Costos de Producción de Azúcar - Códigos de Procesos (CN203)"
string menuname = "m_master_smpl"
end type
global w_cn203_abc_cp_procesos w_cn203_abc_cp_procesos

on w_cn203_abc_cp_procesos.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn203_abc_cp_procesos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("cod_proceso.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_proceso')
END IF

end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;integer li_row
string  ls_cod_proceso, ls_descripcion
li_row = dw_master.GetRow()
if li_row > 0 THen
	ls_cod_proceso = dw_master.GetItemString(li_row,"cod_proceso")
	If isnull(ls_cod_proceso) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Código de Proceso")
		dw_master.SetColumn("cod_proceso")
		dw_master.SetFocus()
	End If
	If len(ls_cod_proceso) <> 6 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Código de Proceso Debe Ser de 6 Dígitos")
		dw_master.SetColumn("cod_proceso")
		dw_master.SetFocus()
	End If
	ls_descripcion = dw_master.GetItemString(li_row,"descripcion")
	If isnull(ls_descripcion) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese la Descripción del Proceso")
		dw_master.SetColumn("descripcion")
		dw_master.SetFocus()
	End If
Else
	return
End if

end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn203_abc_cp_procesos
integer x = 46
integer y = 40
integer width = 2158
integer height = 808
string dataobject = "d_abc_cp_procesos_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_proceso.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")

end event

