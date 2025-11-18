$PBExportHeader$w_rh034_abc_grupos_conceptos.srw
forward
global type w_rh034_abc_grupos_conceptos from w_abc_master_smpl
end type
end forward

global type w_rh034_abc_grupos_conceptos from w_abc_master_smpl
integer width = 1797
integer height = 1448
string title = "(RH034) Grupos de Conceptos"
string menuname = "m_master_simple"
end type
global w_rh034_abc_grupos_conceptos w_rh034_abc_grupos_conceptos

on w_rh034_abc_grupos_conceptos.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh034_abc_grupos_conceptos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("grupo_calc.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('grupo_calc')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;//Verificacion de la Validacion al Grabar
string ls_cod_grupo, ls_desc_grupo
integer li_row 
li_row = dw_master.Getrow()
If li_row > 0 Then  

	ls_cod_grupo = dw_master.GetItemString(li_row,"grupo_calc") 
	ls_desc_grupo = dw_master.GetItemString(li_row,"descripcion")
	If len(trim(ls_cod_grupo)) <> 2 Then 
			dw_master.ii_update = 0
			Messagebox("Sistema de Seguridad","El Código del grupo debe "+&
		           "tener 2 Digitos")
	End if 				  

	If len(trim(ls_desc_grupo)) = 0 Then
		  dw_master.ii_update = 0
		  Messagebox("Sistema de Seguridad","Ingrese la Descripción "+&
		             "del grupo del concepto")
					 
	End if 	
Else 
	return 
end if 	

dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh034_abc_grupos_conceptos
integer x = 5
integer y = 4
integer width = 1751
integer height = 1260
string dataobject = "d_grupo_concepto_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;string ls_cod_grupo

CHOOSE CASE dw_master.GetColumnName()
	CASE 'grupo_calc'
		   ls_cod_grupo = trim(dw_master.GetText())
			if len(ls_cod_grupo) <> 2 Then
				Messagebox("Sistema de Validación","El Código del grupo debe tener "+&
				           "2 Digitos")
				dw_master.SetColumn("grupo_calc")
				dw_master.setfocus()
		      return 1	
		   end if 	
END CHOOSE 
end event

