$PBExportHeader$w_rh018_abc_profesion.srw
forward
global type w_rh018_abc_profesion from w_abc_master_smpl
end type
end forward

global type w_rh018_abc_profesion from w_abc_master_smpl
integer width = 1472
integer height = 1376
string title = "(RH018) Profesiones"
string menuname = "m_master_simple"
end type
global w_rh018_abc_profesion w_rh018_abc_profesion

on w_rh018_abc_profesion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh018_abc_profesion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;//dw_master.of_column_protect('cod_billete')

String ls_protect
ls_protect=dw_master.Describe("cod_profesion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_profesion')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;string ls_desc_profesion
int li_row 
li_row = dw_master.GetRow()
if li_row > 0 THen
	
	ls_desc_profesion = Trim(dw_master.GetItemString(li_row,"desc_profesion"))

	If Len(ls_desc_profesion) = 0 or isnull(ls_desc_profesion) Then
		dw_master.ii_update = 0
		Messagebox("Sistema de Validacion","Iingrese la Descripción de la "+&
		           "PROFESION")
		dw_master.SetColumn("desc_profesion")
		dw_master.SetFocus()
	End If 
Else 
	return 
End if 	
dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh018_abc_profesion
integer x = 5
integer y = 4
integer width = 1403
integer height = 1184
string dataobject = "d_profesion_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;string ls_cod_profesion
choose case dwo.name 
	case 'cod_profesion'
		ls_cod_profesion = Trim(dw_master.GetText())
		If Len(ls_cod_profesion) <> 3 Then
			Messagebox("Sistema de Validacion","El Código del Profesión "+&
			           "es de 3 Dígitos")
			dw_master.SetColumn("cod_profesion")
			dw_master.SetFocus()
			return 1
		End if 
End Choose 
	
			        
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("cod_profesion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

