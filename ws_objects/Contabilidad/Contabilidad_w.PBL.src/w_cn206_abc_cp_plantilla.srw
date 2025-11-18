$PBExportHeader$w_cn206_abc_cp_plantilla.srw
forward
global type w_cn206_abc_cp_plantilla from w_abc_mastdet_smpl
end type
end forward

global type w_cn206_abc_cp_plantilla from w_abc_mastdet_smpl
integer width = 3177
integer height = 1496
string title = "Costos de Producción de Azúcar - Formatos de Plantillas (CN206)"
string menuname = "m_master_smpl"
end type
global w_cn206_abc_cp_plantilla w_cn206_abc_cp_plantilla

type variables
Integer ii_dw_upd
end variables

on w_cn206_abc_cp_plantilla.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn206_abc_cp_plantilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_modify;call super::ue_modify;integer li_protect 

// Porteccion del tipo de operacion
li_protect = integer(dw_detail.Object.tipo_operacion.Protect)
If li_protect = 0 Then
	dw_detail.Object.tipo_operacion.Protect = 1
End if 

// Porteccion del codigo del formato
li_protect = integer(dw_detail.Object.cod_frmt.Protect)
If li_protect = 0 Then
	dw_detail.Object.cod_frmt.Protect = 1
End if 

// Porteccion del numero de item
li_protect = integer(dw_detail.Object.item.Protect)
If li_protect = 0 Then
	dw_detail.Object.item.Protect = 1
End if 

end event

event ue_print;call super::ue_print;idw_1.print()
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;integer li_row
string  ls_calculo, ls_proceso, ls_formula

li_row = dw_detail.GetRow()
if li_row > 0 THen
	ls_calculo = dw_detail.GetItemString(li_row,"flag_tipo_calculo")
	ls_proceso = dw_detail.GetItemString(li_row,"cod_proceso")
	ls_formula = dw_detail.GetItemString(li_row,"dato_formula")
	If ls_calculo = 'C' and isnull(ls_formula) Then
		dw_detail.ii_update = 0
		MessageBox("Validación","Ingrese Fórmula a Calcular")
		dw_detail.SetColumn("dato_formula")
		dw_detail.SetFocus()
	End If
	If ls_calculo = 'P' and isnull(ls_proceso) Then
		dw_detail.ii_update = 0
		MessageBox("Validación","Ingrese Código de Proceso")
		dw_detail.SetColumn("cod_proceso")
		dw_detail.SetFocus()
	End If
Else
	return
End if

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn206_abc_cp_plantilla
integer x = 41
integer y = 40
integer width = 3054
integer height = 464
string dataobject = "d_abc_cp_formatos_costos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::clicked;call super::clicked;ii_dw_upd = 1
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1             // colunmna de pase de parametros
ii_dk[2] = 2

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn206_abc_cp_plantilla
integer x = 41
integer y = 540
integer width = 3054
integer height = 732
string dataobject = "d_abc_cp_plantilla_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2
end event

event dw_detail::constructor;call super::constructor;// Forma parte del pK
ii_ck[1] = 1
ii_ck[2] = 2

// Variable de pase de Parametros
ii_rk[1] = 1
ii_rk[2] = 2

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;integer li_protect 

li_protect = integer(dw_detail.object.tipo_operacion.Protect)
If li_protect = 0 Then
	dw_detail.Object.tipo_operacion.Protect = 1
End if

li_protect = integer(dw_detail.object.cod_frmt.Protect)
If li_protect = 0 Then
	dw_detail.Object.cod_frmt.Protect = 1
End if

// Validacion al ingresar un registro
dw_detail.Modify("item.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("und.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_tipo_calculo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_proceso.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("sec_frmt.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("dato_formula.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_visualizacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cnta_cntbl_debe.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cnta_cntbl_haber.Protect='1~tIf(IsRowNew(),0,1)'")


end event

