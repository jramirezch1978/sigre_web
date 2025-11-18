$PBExportHeader$w_cn207_abc_cp_mov_mensual.srw
forward
global type w_cn207_abc_cp_mov_mensual from w_abc_master_smpl
end type
end forward

global type w_cn207_abc_cp_mov_mensual from w_abc_master_smpl
integer width = 1851
integer height = 1076
string title = "Costos de Producción de Azúcar - Movimiento Mensual (CN207)"
string menuname = "m_master_smpl"
end type
global w_cn207_abc_cp_mov_mensual w_cn207_abc_cp_mov_mensual

on w_cn207_abc_cp_mov_mensual.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn207_abc_cp_mov_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("tipo_operacion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('tipo_operacion')
END IF

ls_protect=dw_master.Describe("cod_frmt.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_frmt')
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

event ue_update_pre;call super::ue_update_pre;integer li_row, ln_valor, ln_count, ln_item
string  ls_tipo_operacion, ls_cod_frmt

li_row = dw_master.GetRow()
if li_row > 0 THen
	ls_tipo_operacion = dw_master.GetItemString(li_row,"tipo_operacion")
	If isnull(ls_tipo_operacion) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Tipo de Operación")
		dw_master.SetColumn("tipo_operacion")
		dw_master.SetFocus()
	End If
	ls_cod_frmt = dw_master.GetItemString(li_row,"cod_frmt")
	If isnull(ls_cod_frmt) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese el Código del Formato")
		dw_master.SetColumn("cod_frmt")
		dw_master.SetFocus()
	End If
/*
	If len(ls_cod_frmt) <> 3 Then
		dw_master.ii_update = 0
		MessageBox("Validación","El Código del Formato Debe Ser de 3 Dígitos")
		dw_master.SetColumn("cod_frmt")
		dw_master.SetFocus()
	End If
*/
	ln_item = dw_master.GetItemNumber(li_row,"item")
	If isnull(ln_item) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Número de Item NO Dede Ser Nulo")
		dw_master.SetColumn("item")
		dw_master.SetFocus()
	End If
	ln_valor = dw_master.GetItemNumber(li_row,"valor")
	If isnull(ln_valor) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Valor NO Dede Ser Nulo")
		dw_master.SetColumn("valor")
		dw_master.SetFocus()
	End If
   ln_count = 0
	Select count(*)
	  into :ln_count
	  from cntbl_cp_plantilla
	  where tipo_operacion = :ls_tipo_operacion and cod_frmt = :ls_cod_frmt and
			  item = :ln_item ;
   If ln_count = 0 then
		dw_master.ii_update = 0
		MessageBox("Validación","El Registro No Existe En La Plantilla")
		dw_master.SetColumn("tipo_operacion")
		dw_master.SetFocus()
	End if
Else
	return
End if

end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn207_abc_cp_mov_mensual
integer x = 46
integer y = 40
integer width = 1710
integer height = 808
string dataobject = "d_abc_cp_mov_mensual_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("tipo_operacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_frmt.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("item.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("valor.Protect='1~tIf(IsRowNew(),0,1)'")

end event

