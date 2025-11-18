$PBExportHeader$w_cn039_abc_gxcnumerador.srw
forward
global type w_cn039_abc_gxcnumerador from w_abc_master_smpl
end type
end forward

global type w_cn039_abc_gxcnumerador from w_abc_master_smpl
integer width = 1024
integer height = 748
string title = "Numerador de Gastos por Campos (CN039)"
string menuname = "m_master_smpl"
end type
global w_cn039_abc_gxcnumerador w_cn039_abc_gxcnumerador

on w_cn039_abc_gxcnumerador.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn039_abc_gxcnumerador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
end event

event ue_insert;call super::ue_insert;// Control para insertar un solo registro
Integer ln_contador
SELECT count(origen)
  INTO :ln_contador
  FROM num_gxc_fusion_apertura ;

If ln_contador = 1 Then 
 	dw_master.deleterow(0) 
	dw_master.ii_update=0
	messagebox("Sistema de Seguridad","Sólo se debe tener un Registro")
End If 

end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("origen.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('origen')
END IF
end event

event ue_open_pre();call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;string ls_reckey
int li_row 
li_row = dw_master.GetRow()
if li_row > 0 then
	ls_reckey = dw_master.GetItemString(li_row,"origen")
	if ls_reckey <> gs_origen then
		dw_master.ii_update = 0
		MessageBox("Validación","Debe ingresar el origen")
		dw_master.SetColumn("origen")
		dw_master.SetFocus()
	end if 
else 
	return 
end if 	
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn039_abc_gxcnumerador
integer x = 50
integer y = 52
integer width = 878
integer height = 460
string dataobject = "d_gxc_numerador_ff"
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
	case 'origen'
		ls_reckey = Trim(dw_master.GetText())
		If isnull(ls_reckey) Then
			Messagebox("Validación","Ingrese Origen, "+&
			           "del Registro")
			dw_master.SetColumn("origen")
			dw_master.SetFocus()
			return 1
		End if 
End Choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("origen.Protect='1~tIf(IsRowNew(),0,1)'")
end event

