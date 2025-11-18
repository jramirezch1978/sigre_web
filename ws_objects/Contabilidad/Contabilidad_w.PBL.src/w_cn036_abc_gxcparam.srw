$PBExportHeader$w_cn036_abc_gxcparam.srw
forward
global type w_cn036_abc_gxcparam from w_abc_master_smpl
end type
end forward

global type w_cn036_abc_gxcparam from w_abc_master_smpl
integer width = 2537
integer height = 1048
string title = "Parámetros de Gastos por Campos (CN036)"
string menuname = "m_master_smpl"
end type
global w_cn036_abc_gxcparam w_cn036_abc_gxcparam

on w_cn036_abc_gxcparam.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn036_abc_gxcparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
end event

event ue_insert();call super::ue_insert;// Control para insertar un solo registro
Integer ln_contador
SELECT count(reckey)
  INTO :ln_contador
  FROM gxcparam ;

If ln_contador = 1 Then 
 	dw_master.deleterow(0) 
	dw_master.ii_update=0
	messagebox("Sistema de Seguridad","Sólo se debe tener un Registro")
End If 

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("reckey.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('reckey')
END IF
end event

event ue_open_pre();call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre();call super::ue_update_pre;int ln_nro_libro_index
int li_row 
li_row = dw_master.GetRow()
if li_row > 0 THen
	
	ln_nro_libro_index = dw_master.GetItemNumber(li_row,"libro_idexacion")

	If ln_nro_libro_index = 0 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese Número de Libro de "+&
		           "Indexación")
		dw_master.SetColumn("libro_idexacion")
		dw_master.SetFocus()
	End If 
Else 
	return 
End if 	
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn036_abc_gxcparam
integer x = 50
integer y = 52
integer width = 2409
integer height = 760
string dataobject = "d_gxc_param_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::clicked;// Override
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// Columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;string ls_reckey
choose case dwo.name 
	case 'reckey'
		ls_reckey = Trim(dw_master.GetText())
		If ls_reckey = ' ' Then
			Messagebox("Validación","Ingrese Llave Primaria, "+&
			           "del Registro")
			dw_master.SetColumn("reckey")
			dw_master.SetFocus()
			return 1
		End if 
End Choose
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("reckey.Protect='1~tIf(IsRowNew(),0,1)'")
end event

