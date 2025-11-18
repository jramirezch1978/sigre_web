$PBExportHeader$w_cn037_abc_gxcfactores.srw
forward
global type w_cn037_abc_gxcfactores from w_abc_master_smpl
end type
end forward

global type w_cn037_abc_gxcfactores from w_abc_master_smpl
integer width = 1088
integer height = 1128
string title = "Factores de Indexación (CN037)"
string menuname = "m_master_smpl"
end type
global w_cn037_abc_gxcfactores w_cn037_abc_gxcfactores

on w_cn037_abc_gxcfactores.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn037_abc_gxcfactores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;//dw_master.of_column_protect('ano')

String ls_protect
ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('ano')
END IF
end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre();call super::ue_update_pre;int ln_ano
double ln_factor
int li_row
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
	ln_factor = dw_master.GetItemNumber(li_row,"factor_indexacion")
	If ln_factor = 0 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Factor Para Indexación "+&
		           "Anual")
		dw_master.SetColumn("factor_indexacion")
		dw_master.SetFocus()
	End If
Else
	return
End if

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn037_abc_gxcfactores
integer y = 0
integer width = 1019
integer height = 940
string dataobject = "d_gxc_factores_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("ano.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("factor_indexacion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

