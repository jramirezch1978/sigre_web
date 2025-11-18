$PBExportHeader$w_rh014_abc_motivo_cese.srw
forward
global type w_rh014_abc_motivo_cese from w_abc_master_smpl
end type
end forward

global type w_rh014_abc_motivo_cese from w_abc_master_smpl
integer width = 1385
integer height = 1344
string title = "(RH014) Motivos de Ceses"
string menuname = "m_master_simple"
end type
global w_rh014_abc_motivo_cese w_rh014_abc_motivo_cese

on w_rh014_abc_motivo_cese.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh014_abc_motivo_cese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;//dw_master.of_column_protect('cod_motiv_cese')

String ls_protect
ls_protect=dw_master.Describe("cod_motiv_cese.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_motiv_cese')
END IF

end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;string ls_desc_cese
Int li_row

li_row = dw_master.GetRow()

if li_row > 0 then 
	ls_desc_cese = dw_master.GetItemString(li_row,"desc_motiv_cese")

	IF Len(ls_desc_cese) = 0 or isnull(ls_desc_cese) Then
		dw_master.ii_update = 0
		Messagebox("Sistema de Validacion","Ingrese una DESCRIPCION de CESE")
		dw_master.SetColumn("desc_motiv_cese")			  
		dw_master.SetFocus()
	end if 
else 
	return
end if 	
dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh014_abc_motivo_cese
integer y = 4
integer width = 1330
integer height = 1152
string dataobject = "d_motivo_cese_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;string ls_cod_cese

CHOOSE CASE dw_master.GetColumnName()
	CASE "cod_motiv_cese"   
		ls_cod_cese = trim(dw_master.Gettext())
		IF Len(ls_cod_cese) <> 2 Then
			Messagebox("Sistema de Validacion","El Codigo de CESE "+&
			           "es de 2 DIGITOS")
			dw_master.SetColumn("cod_motiv_cese")			  
			dw_master.SetFocus()
			return 1
		end if 
end choose 		

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_motiv_cese.Protect='1~tIf(IsRowNew(),0,1)'")
end event

