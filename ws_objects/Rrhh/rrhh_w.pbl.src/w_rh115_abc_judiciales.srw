$PBExportHeader$w_rh115_abc_judiciales.srw
forward
global type w_rh115_abc_judiciales from w_abc_master_smpl
end type
type uo_cabecera from u_cst_quick_search within w_rh115_abc_judiciales
end type
end forward

global type w_rh115_abc_judiciales from w_abc_master_smpl
integer width = 2843
integer height = 2100
string title = "(RH115) Descuentos Judiciales a Alimentistas"
string menuname = "m_master_simple"
uo_cabecera uo_cabecera
end type
global w_rh115_abc_judiciales w_rh115_abc_judiciales

type variables
string 	is_codigo, is_grp_ret_jud
string	is_cnc_jud_fijo, is_cnc_jud_porc
end variables

on w_rh115_abc_judiciales.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_cabecera=create uo_cabecera
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cabecera
end on

on w_rh115_abc_judiciales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cabecera)
end on

event ue_open_pre;// Override
try 
	THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
	THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
	THIS.EVENT Post ue_open_pos()
	
	im_1 = CREATE m_rButton      	// crear menu de boton derecho del mouse
	ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
	
	idw_1 = dw_master             // asignar dw corriente
	idw_1.SetTransObject(SQLCA)
	idw_1.of_protect()        
	
	
	uo_cabecera.of_set_dw('d_maestro_lista_judicial_tbl')
	uo_cabecera.of_set_field('nombres')
	
	uo_cabecera.of_retrieve_lista(gs_origen)
	uo_cabecera.of_sort_lista()
	uo_cabecera.of_protect()
	
	is_grp_ret_jud 	= gnvo_app.of_get_parametro( "GRUPO RETENCION JUDICIAL FIJO", "050")
	is_cnc_jud_fijo 	= gnvo_app.of_get_parametro( "RRHH_CONCEPTO_JUDICIAL_FIJO", "2201")
	is_cnc_jud_porc 	= gnvo_app.of_get_parametro( "RRHH_CONCEPTO_JUDICIAL_PORC", "2008")
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
end try



end event

event resize;// Override

uo_cabecera.width	= newwidth  - uo_cabecera.x - 10
dw_master.height 	= newheight - dw_master.y - 10
dw_master.width 	= newwidth - dw_master.x - 10
end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_processing( dw_master ) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh115_abc_judiciales
integer y = 968
integer width = 2601
integer height = 672
string dataobject = "d_judicial_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_trabajador 	[al_row] = is_codigo
this.object.cod_usr 				[al_row] = gs_user

this.object.porcentaje 			[al_row] = 0.00
this.object.porc_utilidad 		[al_row] = 0.00
this.object.porc_cts				[al_row] = 0.00
this.object.porc_grati	 		[al_row] = 0.00
this.object.porc_VAC				[al_row] = 0.00

this.object.importe 				[al_row] = 0.00
this.object.imp_fijo_grati		[al_row] = 0.00
this.object.imp_fijo_bonif	 	[al_row] = 0.00
this.object.imp_fijo_vaca		[al_row] = 0.00
this.object.imp_fijo_cts 		[al_row] = 0.00



this.object.flag_estado 		[al_row] = '1'

this.SetColumn("concep")
end event

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1			//Columna de lectura del dw
ii_ck[2] = 2			//Columna de lectura del dw
ii_ck[3] = 3			//Columna de lectura del dw
end event

event dw_master::itemchanged;call super::itemchanged;String ls_data, ls_concepto

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'concep'
		
		// Verifica que codigo ingresado exista	
		select c.desc_concep
			into :ls_data
			from 	grupo_calculo_det t, 
					concepto          c 
		  where t.concepto_calc = c.concep 
			 and t.grupo_calculo = :is_grp_ret_jud 
			 and c.flag_estado   = '1'
			 and c.concep			= :data;
		
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.concep		[row] = gnvo_app.is_null
			this.object.desc_concep	[row] = gnvo_app.is_null
			MessageBox('Error', 'Concepto de Planilla ingresado no existe, no esta activo o no pertenece al grupo de calculo ' + is_grp_ret_jud + ', por favor verifique')
			return 1
		end if

		this.object.desc_concep			[row] = ls_data

	CASE 'cod_alimentista'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_data
		  from proveedor
		 Where proveedor = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_alimentista	[row] = gnvo_app.is_null
			this.object.nom_pension	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Alimentista no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.nom_pension	[row] = ls_data

	CASE 'cod_banco'
		
		// Verifica que codigo ingresado exista			
		Select nom_banco
	     into :ls_data
		  from banco
		 Where cod_banco = :data ;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_banco	[row] = gnvo_app.is_null
			this.object.nom_banco	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Almacen no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.nom_banco	[row] = ls_Data
		
	CASE 'porcentaje', 'porc_utilidad', 'porc_cts', 'porc_grati', 'porc_vac'
		ls_concepto = this.object.concep		[row]
		
		if IsNull(ls_concepto) or trim(ls_concepto) = '' then
			this.setColumn('concep')
			MEssageBox('Error', 'Debe Seleccionar previamente un concepto de planilla, por favor verifique!', StopSign!)
			return 1
		end if
		
		if Dec(ls_data) <> 0 then
			if ls_concepto <> is_cnc_jud_porc then
				this.object.porcentaje 		[row] = 0.00
				this.object.porc_utilidad	[row] = 0.00
				this.object.porc_cts			[row] = 0.00
				this.object.porc_grati		[row] = 0.00
				this.object.porc_vac			[row] = 0.00
				
				this.setColumn('concep')
				MessageBox('Error', 'El concepto de planilla ingresado es incorrecto, el Descuento ' &
										+ 'Judicial por Porcentaje es ' + is_cnc_jud_porc &
										+ ', por favor verifique!', StopSign!)
				return 1
			end if
		end if

	CASE 'importe', 'imp_fijo_grati', 'imp_fijo_bonif', 'imp_fijo_vaca', 'imp_fijo_cts'
		ls_concepto = this.object.concep		[row]
		
		if IsNull(ls_concepto) or trim(ls_concepto) = '' then
			this.setColumn('concep')
			MEssageBox('Error', 'Debe Seleccionar previamente un concepto de planilla, por favor verifique!', StopSign!)
			return 1
		end if
		
		if Dec(ls_data) <> 0 then
			if ls_concepto <> is_cnc_jud_fijo then
				this.object.importe 			[row] = 0.00
				this.object.imp_fijo_grati	[row] = 0.00
				this.object.imp_fijo_bonif	[row] = 0.00
				this.object.imp_fijo_vaca	[row] = 0.00
				this.object.imp_fijo_cts	[row] = 0.00
				
				this.setColumn('concep')
				MessageBox('Error', 'El concepto de planilla ingresado es incorrecto, el Descuento ' &
										+ 'Judicial FIJO es ' + is_cnc_jud_fijo &
										+ ', por favor verifique!', StopSign!)
				return 1
			end if
		end if
		
END CHOOSE


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
	case "concep"
		ls_sql = "select c.concep as codigo_concepto, " &
				 + "c.desc_concep as descripcion_concepto " &
				 + "from grupo_calculo_det t, " &
				 + "     concepto          c " &
				 + "where t.concepto_calc = c.concep " &
				 + "  and t.grupo_calculo = '" + is_grp_ret_jud + "'" &
				 + "  and c.flag_estado   = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.concep		[al_row] = ls_codigo
			this.object.desc_concep	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_alimentista"
		ls_sql = "SELECT p.proveedor as proveedor, " &
				 + "p.nom_proveedor as nombre_alimentista, " &
				 + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni " &
				 + "FROM proveedor p " &
				 + "where p.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_alimentista	[al_row] = ls_codigo
			this.object.nom_pension			[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_banco"
		ls_sql = "select b.cod_banco as codigo_banco, " &
				 + "b.nom_banco as nombre_banco " &
				 + "from banco b"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_banco	[al_row] = ls_codigo
			this.object.nom_banco	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

type uo_cabecera from u_cst_quick_search within w_rh115_abc_judiciales
integer width = 2766
integer height = 940
integer taborder = 10
boolean bringtotop = true
end type

on uo_cabecera.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

