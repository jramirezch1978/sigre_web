$PBExportHeader$w_cn038_abc_gxcsemilla.srw
forward
global type w_cn038_abc_gxcsemilla from w_abc_master_smpl
end type
end forward

global type w_cn038_abc_gxcsemilla from w_abc_master_smpl
integer width = 2990
integer height = 1276
string title = "Movimiento de Distribución de Semilla (CN038)"
string menuname = "m_master_smpl"
end type
global w_cn038_abc_gxcsemilla w_cn038_abc_gxcsemilla

on w_cn038_abc_gxcsemilla.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn038_abc_gxcsemilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('ano')
END IF

ls_protect=dw_master.Describe("mes.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('mes')
END IF

ls_protect=dw_master.Describe("item.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('item')
END IF

end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre();call super::ue_update_pre;int li_row, ln_ano, ln_mes
li_row = dw_master.GetRow()
if li_row > 0 THen
	ln_ano = dw_master.GetItemNumber(li_row,"ano")
	If ln_ano = 0 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Año "+&
		           "Contable")
		dw_master.SetColumn("ano")
		dw_master.SetFocus()
	End If
	ln_mes = dw_master.GetItemNumber(li_row,"mes")
	If ln_mes = 0 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Mes "+&
		           "Contable")
		dw_master.SetColumn("mes")
		dw_master.SetFocus()
	End If
Else
	return
End if

end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn038_abc_gxcsemilla
integer x = 5
integer y = 0
integer width = 2944
integer height = 1092
string dataobject = "d_gxc_semilla_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("ano.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("mes.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("item.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cencos.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("proveedor.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_ctbl.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_prsp.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("has_netas.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("has_avance.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tns_avance.Protect='1~tIf(IsRowNew(),0,1)'")



// Determina el último registro
Integer li_registros
If isnull(li_registros) then
  li_registros = al_row
end if
li_registros = al_row

long ll_row
ll_row =  dw_master.getrow()
if ll_row = 0 then return

// Datos que se ingresan automáticamente
this.setitem(al_row,"item",li_registros)

end event

