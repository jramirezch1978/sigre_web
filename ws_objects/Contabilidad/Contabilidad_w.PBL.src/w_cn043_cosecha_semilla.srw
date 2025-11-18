$PBExportHeader$w_cn043_cosecha_semilla.srw
forward
global type w_cn043_cosecha_semilla from w_abc_master_smpl
end type
end forward

global type w_cn043_cosecha_semilla from w_abc_master_smpl
integer width = 2519
integer height = 1504
string title = "(CN043) Hectáreas y Toneladas de Cosecha y Semilla"
string menuname = "m_master_smpl"
end type
global w_cn043_cosecha_semilla w_cn043_cosecha_semilla

on w_cn043_cosecha_semilla.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn043_cosecha_semilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('ano')
END IF

ls_protect=dw_master.Describe("mes.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('mes')
END IF

ls_protect=dw_master.Describe("corr_corte.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('corr_corte')
END IF

end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;int li_row, ln_ano, ln_mes
string ls_corr_corte
li_row = dw_master.GetRow()
if li_row > 0 THen
	ls_corr_corte = dw_master.GetItemString(li_row,"corr_corte")
	If isnull(ls_corr_corte) Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Correlativo de Corte")
		dw_master.SetColumn("corr_corte")
		dw_master.SetFocus()
	End If
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

type dw_master from w_abc_master_smpl`dw_master within w_cn043_cosecha_semilla
integer x = 5
integer y = 4
integer width = 2469
integer height = 1316
string dataobject = "d_gxc_cosecha_semilla_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("ano.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("mes.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("corr_corte.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_cos_sem.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("has_netas.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("has_avance.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tns_avance.Protect='1~tIf(IsRowNew(),0,1)'")

end event

