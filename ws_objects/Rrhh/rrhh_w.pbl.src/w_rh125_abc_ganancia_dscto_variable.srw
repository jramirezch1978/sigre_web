$PBExportHeader$w_rh125_abc_ganancia_dscto_variable.srw
forward
global type w_rh125_abc_ganancia_dscto_variable from w_abc_master
end type
type uo_cabecera from u_cst_quick_search within w_rh125_abc_ganancia_dscto_variable
end type
end forward

global type w_rh125_abc_ganancia_dscto_variable from w_abc_master
integer width = 3365
integer height = 1940
string title = "(RH125) Ganancias y Descuentos Variables"
string menuname = "m_master_simple"
uo_cabecera uo_cabecera
end type
global w_rh125_abc_ganancia_dscto_variable w_rh125_abc_ganancia_dscto_variable

type variables
string is_codigo
end variables

on w_rh125_abc_ganancia_dscto_variable.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_cabecera=create uo_cabecera
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cabecera
end on

on w_rh125_abc_ganancia_dscto_variable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cabecera)
end on

event ue_modify;call super::ue_modify;int li_protect
li_protect = integer(dw_master.Object.cod_trabajador.Protect)
if li_protect = 0 then
	dw_master.Object.cod_trabajador.Protect = 1
end if 

end event

event ue_open_pre;call super::ue_open_pre;
uo_cabecera.of_set_dw('d_maestro_lista_tbl')
uo_cabecera.of_set_field('nombres')

uo_cabecera.of_retrieve_lista(gs_origen)
uo_cabecera.of_sort_lista()
uo_cabecera.of_protect()
end event

event resize;uo_cabecera.width  = newwidth  - uo_cabecera.x - 10

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master`dw_master within w_rh125_abc_ganancia_dscto_variable
integer y = 932
integer width = 3173
integer height = 768
string dataobject = "d_ganancia_dscto_variable_tbl"
end type

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;
this.object.cod_trabajador	[al_row] = is_codigo
this.object.cod_usr			[al_row] = gs_user
this.object.nro_dias			[al_row] = 0
this.object.nro_horas		[al_row] = 0
this.object.nro_cuotas		[al_row] = 1
this.object.tipo_planilla	[al_row] = 'N'


end event

event dw_master::clicked;call super::clicked;DataWindowChild	dwc_dddw								

CHOOSE CASE dw_master.GetColumnName()
	CASE 'concep'
			string DWfilter2
			DWfilter2 = 'Mid(concep,1,1) = "1" or Mid(concep,1,1) = "2"'
			dw_master.GetChild ("concep", dwc_dddw)
			dwc_dddw.SetTransObject (sqlca)
			dwc_dddw.Retrieve ()
			dwc_dddw.SetFilter(DWfilter2)
			dwc_dddw.Filter( )
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc1, ls_desc2
Long 		ll_count
decimal ldc_imp_var

dw_master.Accepttext()
Accepttext()

choose case dwo.name
	case 'imp_var'
		ldc_imp_var = dec(dw_master.GetText())
		If ldc_imp_var < 0 then
			Messagebox("Sistema de Validacion","El IMPORTE debe ser "+&
			           "MAYOR que CERO")
			dw_master.SetColumn("imp_var")
			dw_master.SetFocus()
			return 1
		End if 
		
	CASE 'cod_labor'
		
		// Verifica que codigo ingresado exista			
		Select desc_labor
	     into :ls_desc1
		  from labor
		 Where cod_labor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Labor no existe o no se encuentra activo, por favor verifique")
			this.object.cod_labor	[row] = gnvo_app.is_null
			this.object.desc_labor	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_labor		[row] = ls_desc1
		
	CASE 'concep'
		
		// Verifica que codigo ingresado exista			
		Select desc_concep
	     into :ls_desc1
		  from concepto
		 Where concep = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Concepto de Planilla ingresado no existe o no se encuentra activo, por favor verifique")
			this.object.concep		[row] = gnvo_app.is_null
			this.object.desc_concep	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_concep		[row] = ls_desc1

END CHOOSE
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF currentrow = 0 THEN RETURN

IF is_dwform = 'tabular' or is_dwform = 'grid' THEN
	Any 	la_id
	il_row = currentrow                    // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_labor"
		ls_sql = "SELECT cod_labro AS codigo_labor, " &
				  + "desc_labor AS descripcion_labor " &
				  + "FROM labor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "concep"
		ls_sql = "SELECT concep as codigo_concepto, " &
				 + "desc_concep as descripcion_concepto " &
				 + "from concepto " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.concep		[al_row] = ls_codigo
			this.object.desc_concep	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
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

type uo_cabecera from u_cst_quick_search within w_rh125_abc_ganancia_dscto_variable
integer width = 2994
integer height = 920
integer taborder = 20
boolean bringtotop = true
end type

event ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

on uo_cabecera.destroy
call u_cst_quick_search::destroy
end on

event constructor;call super::constructor;//uo_1.of_set_dw('d_maestro_lista_tbl')
//uo_1.of_set_field('apel_paterno')
//
//uo_1.of_retrieve_lista()
//uo_1.of_sort_lista()
//uo_1.of_protect()

//uo_1.of_set_colnum(1)
end event

