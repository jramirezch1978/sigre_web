$PBExportHeader$w_rh013_abc_situac_trabajador.srw
forward
global type w_rh013_abc_situac_trabajador from w_abc_master_smpl
end type
end forward

global type w_rh013_abc_situac_trabajador from w_abc_master_smpl
integer width = 1458
integer height = 1244
string title = "(RH013) Condición del Trabajador"
string menuname = "m_master_simple"
end type
global w_rh013_abc_situac_trabajador w_rh013_abc_situac_trabajador

event ue_modify;call super::ue_modify;//dw_master.of_column_protect('cod_motiv_cese')

String ls_protect
ls_protect=dw_master.Describe("situa_trabaj.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('situa_trabaj')
END IF


end event

on w_rh013_abc_situac_trabajador.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh013_abc_situac_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;string ls_desc_sit 
int li_row

li_row = dw_master.GetRow()
if li_row > 0 then
ls_desc_sit = trim(dw_master.GetItemString(li_row,"desc_sit_trab"))
If len(ls_desc_sit) = 0 or isnull(ls_desc_sit) Then
	dw_master.ii_update = 0
	Messagebox("Sistema de Validacion","INGRESE una DESCRIPCION para "+&
	           "la SITUACION del TRABAJADOR")
	dw_master.SetColumn("desc_sit_trab")
	dw_master.SetFocus()
End If 	
else
	return
end if
dw_master.of_set_flag_replicacion( )
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh013_abc_situac_trabajador
integer x = 5
integer y = 4
integer width = 1408
integer height = 1052
string dataobject = "d_situac_trabajador_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("situa_trabaj.Protect='1~tIf(IsRowNew(),0,1)'")
end event

