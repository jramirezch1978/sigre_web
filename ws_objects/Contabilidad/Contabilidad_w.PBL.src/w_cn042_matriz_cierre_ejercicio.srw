$PBExportHeader$w_cn042_matriz_cierre_ejercicio.srw
forward
global type w_cn042_matriz_cierre_ejercicio from w_abc_master_smpl
end type
end forward

global type w_cn042_matriz_cierre_ejercicio from w_abc_master_smpl
integer width = 2496
integer height = 1500
string title = "(CN042) Matriz Para Cierre del Ejercicio"
string menuname = "m_master_smpl"
end type
global w_cn042_matriz_cierre_ejercicio w_cn042_matriz_cierre_ejercicio

on w_cn042_matriz_cierre_ejercicio.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn042_matriz_cierre_ejercicio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("grupo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('grupo')
END IF

ls_protect=dw_master.Describe("secuencia.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('secuencia')
END IF

end event

event ue_update_pre;call super::ue_update_pre;int li_row, ln_grupo, ln_secuencia
li_row = dw_master.GetRow()
if li_row > 0 THen
	ln_grupo = dw_master.GetItemNumber(li_row,"grupo")
	If ln_grupo = 0 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese el grupo, es obligatorio")
		dw_master.SetColumn("grupo")
		dw_master.SetFocus()
	End If
	ln_secuencia = dw_master.GetItemNumber(li_row,"secuencia")
	If ln_secuencia = 0 Then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingrese la secuencia, es obligatorio")
		dw_master.SetColumn("secuencia")
		dw_master.SetFocus()
	End If
Else
	return
End if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn042_matriz_cierre_ejercicio
integer x = 5
integer width = 2478
integer height = 1192
string dataobject = "d_cntbl_cierre_ejercicio_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("secuencia.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_ctbl_recep.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_fin_grp.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cnta_ctbl_recep"

		ls_sql = "select t.cnta_ctbl as cnta_cntbl, " &
				 + "t.desc_cnta as descripcion_cuenta " &
				 + "from cntbl_cnta t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_ctbl_recep	[al_row] = ls_codigo
			this.object.desc_cnta			[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'cnta_ctbl_recep'
		
		// Verifica que codigo ingresado exista			
		Select desc_cnta
	     into :ls_desc
		  from cntbl_cnta
		 Where cnta_ctbl = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Cuenta Contable o no se encuentra activo, por favor verifique!")
			this.object.cnta_ctbl_recep	[row] = gnvo_app.is_null
			this.object.desc_cnta			[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_cnta		[row] = ls_desc
	
END CHOOSE
end event

