$PBExportHeader$w_fl034_param_espec.srw
forward
global type w_fl034_param_espec from w_abc
end type
type dw_master from u_dw_abc within w_fl034_param_espec
end type
end forward

global type w_fl034_param_espec from w_abc
integer width = 3913
integer height = 1644
string title = "Parámetros Específicos (FL034)"
string menuname = "m_mto_smpl"
boolean maxbox = false
boolean resizable = false
boolean center = true
dw_master dw_master
end type
global w_fl034_param_espec w_fl034_param_espec

on w_fl034_param_espec.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fl034_param_espec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_query_retrieve;// Ancestor Script has been Override
idw_1.Retrieve()
idw_1.ii_protect = 0
idw_1.of_protect()         			// bloquear modificaciones 
if idw_1.RowCount() = 0 then 
	idw_1.event ue_insert()
end if

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente

this.event ue_query_retrieve()


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF
end event

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1.RowCount() > 0 then
	MessageBox('Aviso', 'Ya existen un registro, no puede ingresar mas parametros ',StopSign!)
	return
end if
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from u_dw_abc within w_fl034_param_espec
event ue_display ( string as_columna,  long al_row )
integer width = 3877
integer height = 1468
string dataobject = "d_param_espec_ff"
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param

choose case lower(as_columna)
		
	case "zona_pesca"
		
		ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO_MOV, " &
				  + "DESCR_SITUACION AS DESCRIPCION " &
				  + "FROM FL_MOTIVO_MOVIMIENTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.zona_pesca			[al_row] = ls_codigo
			this.object.descr_situacion_1	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "arribo_pesca"
		
		ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO_MOV, " &
				  + "DESCR_SITUACION AS DESCRIPCION " &
				  + "FROM FL_MOTIVO_MOVIMIENTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.arribo_pesca		[al_row] = ls_codigo
			this.object.descr_situacion_2	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "travesia"
		
		ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO_MOV, " &
				  + "DESCR_SITUACION AS DESCRIPCION " &
				  + "FROM FL_MOTIVO_MOVIMIENTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.travesia				[al_row] = ls_codigo
			this.object.descr_situacion_3	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cargo_patron"
		
		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				  + "DESCR_CARGO AS DESCRIPCION " &
				  + "FROM FL_CARGO_TRIPULANTES " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cargo_patron	[al_row] = ls_codigo
			this.object.descr_cargo		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cencos_rsp"
		
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "DESC_cencos AS DESCRIPCION_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_rsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cencos_admflo"
		
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "DESC_cencos AS DESCRIPCION_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_admflo	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cencos_flota_terc"
		
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "DESC_cencos AS DESCRIPCION_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_flota_terc	[al_row] = ls_codigo
			this.ii_update = 1
		end if		

	case "ejecutor_flota"
		
		ls_sql = "SELECT cod_ejecutor AS CODIGO_ejecutor, " &
				  + "descripcion AS DESCRIPCION_ejecutor " &
				  + "FROM ejecutor " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ejecutor_flota	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "labor_flota"
		
		ls_sql = "SELECT cod_labor AS CODIGO_labor, " &
				  + "desc_labor AS DESCRIPCION_labor " &
				  + "FROM labor " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.labor_flota	[al_row] = ls_codigo
			this.ii_update = 1
		end if		

	case "almacen_flota"
		
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS DESCRIPCION_almacen " &
				  + "FROM almacen " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen_flota	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "bonif_esp"
		
		ls_sql = "SELECT concep AS CODIGO_concepto, " &
				  + "desc_concep AS DESCRIPCION_concepto " &
				  + "FROM concepto " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.bonif_esp	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "concep_gratif"
		
		ls_sql = "SELECT concep AS CODIGO_concepto, " &
				  + "desc_concep AS DESCRIPCION_concepto " &
				  + "FROM concepto " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.concep_gratif	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "concep_cts"
		
		ls_sql = "SELECT concep AS CODIGO_concepto, " &
				  + "desc_concep AS DESCRIPCION_concepto " &
				  + "FROM concepto " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.concep_cts	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "concep_vacaciones"
		
		ls_sql = "SELECT concep AS CODIGO_concepto, " &
				  + "desc_concep AS DESCRIPCION_concepto " &
				  + "FROM concepto " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.concep_vacaciones	[al_row] = ls_codigo
			this.ii_update = 1
		end if		
		
	case "ot_adm_flota"
		
		ls_sql = "SELECT ot_adm AS CODIGO_ot_adm, " &
				  + "descripcion AS DESCRIPCION_ot_adm " &
				  + "FROM ot_administracion " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_adm_flota	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "ot_tipo_flota"
		
		ls_sql = "SELECT ot_tipo AS tipo_ot, " &
				  + "descripcion AS DESCRIPCION_tipo_ot " &
				  + "FROM ot_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_tipo_flota	[al_row] = ls_codigo
			this.ii_update = 1
		end if	
		
	case "pago_contado"
		
		ls_sql = "SELECT FORMA_PAGO AS CODIGO_FORMA_PAGO, " &
				  + "desc_FORMA_PAGO AS DESCRIPCION_FORMA_PAGO " &
				  + "FROM FORMA_PAGO " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.pago_contado	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "fpago_incent"
		
		ls_sql = "SELECT FORMA_PAGO AS CODIGO_FORMA_PAGO, " &
				  + "desc_FORMA_PAGO AS DESCRIPCION_FORMA_PAGO " &
				  + "FROM FORMA_PAGO " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.fpago_incent	[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "cnta_prsp_bonif"
		
		ls_sql = "SELECT CNTA_PRSP AS CUENTA_PRSP, " &
				  + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
				  + "FROM PRESUPUESTO_CUENTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_bonif [al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "cnta_prsp_flota_terc"
		
		ls_sql = "SELECT CNTA_PRSP AS CUENTA_PRSP, " &
				  + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
				  + "FROM PRESUPUESTO_CUENTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_flota_terc [al_row] = ls_codigo
			this.ii_update = 1
		end if			

	case "cnta_prsp_incent"
		
		ls_sql = "SELECT CNTA_PRSP AS CUENTA_PRSP, " &
				  + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
				  + "FROM PRESUPUESTO_CUENTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_incent [al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "cnta_prsp_cbssp"
		
		ls_sql = "SELECT CNTA_PRSP AS CUENTA_PRSP, " &
				  + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
				  + "FROM PRESUPUESTO_CUENTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_cbssp [al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "cnta_prsp_dp"
		
		ls_sql = "SELECT CNTA_PRSP AS CUENTA_PRSP, " &
				  + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
				  + "FROM PRESUPUESTO_CUENTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_dp [al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "doc_dp"
		
		ls_sql = "SELECT TIPO_DOC AS tipo_documento, " &
				  + "DESC_tipo_doc AS DESCRIPCION_documento " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.doc_dp [al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "prov_cbssp"
		
		ls_sql = "SELECT proveedor AS codigo_provedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "ruc as ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.prov_cbssp [al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "quinta_categ"
		
		ls_sql = "SELECT tipo_impuesto AS codigo_impuesto, " &
				  + "DESC_IMPUESTO AS descripcion_impuesto " &
				  + "FROM impuestos_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.quinta_categ [al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "prov_produce"
		
		ls_sql = "SELECT proveedor AS codigo_provedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "ruc as ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.prov_produce [al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "libro_bonif_pesca"
		
		ls_sql = "SELECT TO_CHAR(NRO_LIBRO) AS NUMERO_LIBRO, " &
				  + "DESC_LIBRO AS DESCRIPCION_LIBRO " &
				  + "FROM CNTBL_LIBRO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.libro_bonif_pesca [al_row] = Integer(ls_codigo)
			this.ii_update = 1
		end if	

	case "ot_seccion"
		
		ls_sql = "SELECT SECCION_TIPO AS CODIGO_SECCION_TIPO, " &
				  + "DESCRIPCION AS DESCRIPCION_SECCION_TIPO " &
				  + "FROM ot_seccion_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_seccion	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "banco_pago_dp"
		
		ls_sql = "SELECT cod_banco AS codigo_banco, " &
				  + "nom_banco AS Descripcion_banco " &
				  + "FROM banco " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.banco_pago_dp	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "confin_incent"
		
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
		sl_param = message.PowerObjectParm			
		
		IF sl_param.titulo = 's' THEN 
			this.object.confin_incent [al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		end if

	case "confin_bpt"
		
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
		sl_param = message.PowerObjectParm			
		
		IF sl_param.titulo = 's' THEN 
			this.object.confin_bpt [al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		end if
		
	case "confin_prov_dp"
		
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
		sl_param = message.PowerObjectParm			
		
		IF sl_param.titulo = 's' THEN 
			this.object.confin_prov_dp [al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		end if

	case "confin_def_dp"
		
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
		sl_param = message.PowerObjectParm			
		
		IF sl_param.titulo = 's' THEN 
			this.object.confin_def_dp [al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		end if		

end choose

end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.reckey[al_row] = '1'
end event

event itemerror;call super::itemerror;return 1
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "concepto"
		
		ls_codigo = this.object.concepto[row]

		SetNull(ls_data)
		select desc_concep
			into :ls_data
		from concepto
		where concep = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('FLOTa', "CONCEPTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.concepto			[row] = ls_codigo
			this.object.desc_concepto	[row] = ls_codigo
			return 1
		end if

		this.object.desc_concepto[row] = ls_data
		
end choose
end event

