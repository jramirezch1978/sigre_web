$PBExportHeader$w_cn045_grupos_secuencia.srw
forward
global type w_cn045_grupos_secuencia from w_abc_master_smpl
end type
end forward

global type w_cn045_grupos_secuencia from w_abc_master_smpl
integer width = 2583
integer height = 1444
string title = "(CN045) Grupos de Secuencia Para Gastos Fijos"
string menuname = "m_master_smpl"
end type
global w_cn045_grupos_secuencia w_cn045_grupos_secuencia

on w_cn045_grupos_secuencia.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn045_grupos_secuencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("reporte.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('reporte')
END IF
end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;string ls_grupo

int li_row
li_row = dw_master.GetRow()
if li_row > 0 THen
	ls_grupo = dw_master.GetItemString(li_row,"grupo")
	If isnull(ls_grupo) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Grupo de Secuencia "+&
		           "Contable")
		dw_master.SetColumn("grupo")
		dw_master.SetFocus()
	End If
Else
	return
End if

end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn045_grupos_secuencia
integer x = 50
integer y = 44
integer width = 2446
integer height = 1176
string dataobject = "d_grupo_transferencia_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("reporte.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nivel.Protect='1~tIf(IsRowNew(),0,1)'")

// Datos que se ingresan automáticamente
this.setitem(al_row,"reporte","TRANSFER")

end event

