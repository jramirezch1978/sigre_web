$PBExportHeader$w_rh016_abc_categoria_salarial.srw
forward
global type w_rh016_abc_categoria_salarial from w_abc_master_smpl
end type
end forward

global type w_rh016_abc_categoria_salarial from w_abc_master_smpl
integer width = 1367
integer height = 1304
string title = "(RH016) Categorías Salariales"
string menuname = "m_master_simple"
end type
global w_rh016_abc_categoria_salarial w_rh016_abc_categoria_salarial

type variables
//Integer ii_row
end variables

on w_rh016_abc_categoria_salarial.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh016_abc_categoria_salarial.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;//dw_master.of_column_protect('cod_categ_sal')

String ls_protect
ls_protect=dw_master.Describe("cod_categ_sal.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_categ_sal')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;int li_row
Decimal ldc_imp_min, ldc_imp_max

dw_master.GetText()
li_row = dw_master.GetRow()

If li_row > 0 then 
	//Asignacion de valores
	ldc_imp_min = dw_master.GetItemDecimal(li_row,"imp_categ_min")
	ldc_imp_max = dw_master.GetItemDecimal(li_row,"imp_categ_max")
	//Verificamos que el IMP MAX debe ser Mayor que el IMP MIN
	If ldc_imp_min > ldc_imp_max Then
		dw_master.ii_update = 0	
		messagebox("Sistema de Validacion","El IMPORTE MAXIMO debe ser "+&
		           "Mayor que el IMPORTE MINIMO")
		dw_master.SetColumn("imp_categ_max")
		dw_master.Setfocus()
		
	End if 				  
Else
	return 	
End if 
dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh016_abc_categoria_salarial
integer x = 5
integer width = 1317
integer height = 1112
string dataobject = "d_categoria_salarial_tbl"
end type

event dw_master::itemchanged;call super::itemchanged;Decimal ldc_imp_max, ldc_imp_min, ldc_imp_max_ant 
string ls_cod_categ


CHOOSE CASE dw_master.GetColumnName ( )
	    CASE "cod_categ_sal"
			    ls_cod_categ = trim(dw_master.GetText())
				 If len(ls_cod_categ) <> 2 Then
				 	Messagebox("Sistema Validacion","El codigo debe ser de 2 "+&
				 	           "Digitos")
				 	dw_master.setcolumn("cod_categ_sal")
				 	dw_master.setfocus()
				 		Return 1           
	          End if                     
        
       CASE "imp_categ_min"
		 		If row > 1 Then
		    		ldc_imp_max_ant=dw_master.GetItemDecimal(row - 1,"imp_categ_max")
		 			ldc_imp_min=Dec(dw_master.Gettext())
		 			If ldc_imp_min<=ldc_imp_max_ant Then
		 				MessageBox("Sistema Validacion","El Importe Mínimo debe ser "+&
		 				           "Mayor al Importe Maximo de la Categoria Anterior")
					   dw_master.setcolumn("imp_categ_min")
						dw_master.setfocus()
						Return 1
					End if
				End if
								
				If IsNull("imp_categ_max") Then
					dw_master.setItem(row,"imp_categ_max",99999999)
				Else
					ldc_imp_min=Dec(dw_master.Gettext())
					ldc_imp_max=dw_master.GetItemDecimal(row,"imp_categ_max")
					If ldc_imp_min >ldc_imp_max THen
						MessageBox("Sistema Validacion","El Importe Minimo debe ser "+&
						           "< IMporte Maximo")  
						dw_master.setcolumn("imp_categ_min")
						dw_master.setfocus()
						Return 1
					End if 
				End If 
END CHOOSE					


end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw 
end event

