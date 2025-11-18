$PBExportHeader$w_ap016_parametros_generales.srw
forward
global type w_ap016_parametros_generales from w_abc_master
end type
end forward

global type w_ap016_parametros_generales from w_abc_master
integer width = 2171
integer height = 2072
string title = "Parametros Generales de Aprovisionamiento (AP016)"
string menuname = "m_ap_param"
end type
global w_ap016_parametros_generales w_ap016_parametros_generales

on w_ap016_parametros_generales.create
call super::create
if this.MenuName = "m_ap_param" then this.MenuID = create m_ap_param
end on

on w_ap016_parametros_generales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

idw_1.Retrieve( )

IF idw_1.RowCount() = 0 THEN
	idw_1.event ue_insert()
END IF

end event

event ue_update;// Override

Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect	( )
	dw_master.retrieve	( )
	
END IF


end event

type dw_master from w_abc_master`dw_master within w_ap016_parametros_generales
event ue_display ( string as_columna,  long al_row )
integer x = 41
integer y = 36
integer width = 2053
integer height = 1820
string dataobject = "d_ap_parametros_generales_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
integer	li_year


str_parametros sl_param

CHOOSE CASE lower(as_columna)
		
	CASE "tipo_mov"
		ls_sql = "SELECT TIPO_MOV AS TIPO_MOV, " 	&
				  + "DESC_TIPO_MOV AS DESCRIPCION " &
				  + "FROM ARTICULO_MOV_TIPO " 		&
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.tipo_mov			[al_row] = ls_codigo
			this.object.desc_tipo_mov	[al_row] = ls_data
			this.ii_update = 1
		END IF

	CASE "servicio_flete"
		ls_sql = "SELECT SERVICIO AS codigo_servicio, " 	&
				  + "descripcion AS descripcion_servicio " &
				  + "FROM SERVICIOS " 		&
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.servicio_flete	[al_row] = ls_codigo
			this.ii_update = 1
		END IF

	CASE "trato_estable"
		ls_sql = "SELECT trato_provee_id AS codigo_trato, " 	&
				  + "trato_provee_desc AS descripcion_trato " &
				  + "FROM ap_trato_provee " 		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.trato_estable	[al_row] = ls_codigo
			this.ii_update = 1
		END IF

	CASE  "almacen"
		ls_sql = "SELECT almacen AS COD_ALMACEN, " 	&
				  + "desc_almacen AS DESCRIPCION " 		&
				  + "FROM ALMACEN " 							&
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen[al_row]	= ls_data
			this.ii_update = 1
		END IF	
		
	CASE "doc_guia_mp"  
		ls_sql = "SELECT TIPO_DOC AS COD_TIPO_DOC,  "	&
				 + "DESC_TIPO_DOC AS DESCRIPCION "			&
				 + "FROM DOC_TIPO "								&
				 + "WHERE FLAG_ESTADO = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.doc_guia_mp	[al_row] = ls_codigo
			this.object.desc_doc_gmp[al_row]	= ls_data
			this.ii_update = 1
		END IF	
	
	CASE "doc_lc"  
		ls_sql = "SELECT TIPO_DOC AS COD_TIPO_DOC,  "	&
				 + "DESC_TIPO_DOC AS DESCRIPCION "			&
				 + "FROM DOC_TIPO "								&
				 + "WHERE FLAG_ESTADO = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.doc_lc		[al_row] = ls_codigo
			this.object.desc_doc_lc	[al_row]	= ls_data
			this.ii_update = 1
		END IF	
	
	CASE "confin_lc"
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
		sl_param = message.PowerObjectParm			
		
		IF sl_param.titulo = 's' THEN this.ii_update = 1
	
	CASE	'cencos_lc'
			li_year = Year(DAte(f_fecha_Actual()))
			
			ls_sql = "SELECT distinct cc.cencos AS codigo_cencos, " &
					  + "cc.desc_cencos AS descripcion_cencos " &
					  + "FROM centros_costo cc, " &
					  + "presupuesto_partida pp " &
					  + "where cc.cencos = pp.cencos " &
					  + "and pp.flag_estado <> '0' " &
					  + "and cc.flag_estado = '1' " &
					  + "and pp.ano = " + string(li_year)
				 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			IF ls_codigo <> '' THEN
				this.object.cencos_lc	[al_row] = ls_codigo
				this.object.desc_cencos	[al_row] = ls_data
				this.ii_update = 1
			END IF
	
	CASE "cnta_prsp_mp"
		ls_sql = "SELECT CNTA_PRSP AS COD_CUENTA, "		&
					+ "DESCRIPCION AS DESCRIPCION_CUENTA " &
					+ "FROM PRESUPUESTO_CUENTA "				&
					+ "WHERE FLAG_ESTADO = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
				this.object.cnta_prsp_mp		[al_row] = ls_codigo
				this.object.desc_cnta_prsp_mp	[al_row] = ls_data
				this.ii_update = 1
		END IF
		
	CASE "impuesto_lc"
		ls_sql = "SELECT TIPO_IMPUESTO AS COD_IMP, " 			&
					+ "DESC_IMPUESTO AS DESCRIPCION_IMPUESTO "	&
					+ "FROM  IMPUESTOS_TIPO	"							&
				   
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
				this.object.impuesto_lc	[al_row] = ls_codigo
				this.object.desc_impt_lc[al_row] = ls_data
				this.ii_update = 1
		END IF
		
	CASE "und_kg"  
		ls_sql = "SELECT UND AS COD_UNIDADC,  "	&
				 + "DESC_UNIDAD AS DESCRIPCION "		&
				 + "FROM UNIDAD "							
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.und_kg		[al_row] = ls_codigo
			this.object.desc_und_kg	[al_row]	= ls_data
			this.ii_update = 1
		END IF	
	
	CASE "und_tm"  
		ls_sql = "SELECT UND AS COD_UNIDADC,  "	&
				 + "DESC_UNIDAD AS DESCRIPCION "		&
				 + "FROM UNIDAD "							
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.und_tm		[al_row] = ls_codigo
			this.object.desc_und_tm	[al_row]	= ls_data
			this.ii_update = 1
		END IF	

END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 27				// columnas de lectrua de este dw

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_prov, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 THEN
	return
END IF

CHOOSE CASE lower(dwo.name)
		
	CASE "tipo_mov"
		SELECT DESC_TIPO_MOV
	     INTO :ls_data
	   FROM ARTICULO_MOV_TIPO
		WHERE FLAG_ESTADO = '1'
		 AND tipo_mov	= :data;
				 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL TIPO DE DOCUMENTO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.tipo_mov			[row] = ls_null
			this.object.desc_tipo_mov	[row] = ls_null
			return 1
		END IF
		
		this.object.desc_tipo_mov	[row] = ls_data

	CASE "servicio_flete"
		SELECT descripcion
		  INTO :ls_data
		FROM servicios
		WHERE FLAG_ESTADO = '1'
		  AND servicio = :data;
				 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'SERVICIO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.servicio_flete		[row] = ls_null
			return 1
		END IF	

	CASE  "almacen"
		SELECT desc_almacen
		  INTO :ls_data
		FROM ALMACEN
		WHERE FLAG_ESTADO = '1'
		  AND almacen = :data;
				 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL ALMACEN NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.almacen		[row] = ls_null
			this.object.desc_almacen[row]	= ls_null
			return 1
		END IF	
		
			this.object.desc_almacen[row]	= ls_data
		
	CASE "doc_guia_mp"  
		SELECT DESC_TIPO_DOC 
		  INTO :ls_data
		FROM DOC_TIPO
		WHERE FLAG_ESTADO = '1'
		 AND tipo_doc = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL TIPO DE DOCUMENTO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.doc_guia_mp	[row] = ls_null
			this.object.desc_doc_gmp[row]	= ls_null
			return 1
		END IF	
		
		this.object.desc_doc_gmp[row]	= ls_data
	
	CASE "doc_lc"  
		SELECT DESC_TIPO_DOC
		  INTO :ls_data
		FROM DOC_TIPO
		WHERE FLAG_ESTADO = '1'
		  AND tipo_doc = :data;
		
 	  IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL TIPO DE DOCUMENTO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.doc_lc		[row] = ls_null
			this.object.desc_doc_lc	[row]	= ls_null
			return 1
		END IF	
	
		this.object.desc_doc_lc	[row]	= ls_data
		
	CASE "confin_lc"
		SELECT descripcion	
		 INTO :ls_data
		FROM concepto_financiero	
		WHERE confin = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CONFIN NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.confin_lc		[row] = ls_null
			this.object.desc_confin_lc	[row]	= ls_null
			return 1
		END IF
		
		this.object.desc_confin_lc[row]	= ls_data
	
	CASE "cencos_lc"
		SELECT DESC_CENCOS
		  INTO :ls_data
		FROM  CENTROS_COSTO
		WHERE CENCOS = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CENCOS NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.cencos_lc	[row] = ls_null
			this.object.desc_cencos	[row]	= ls_null
			return 1
		END IF
		
		this.object.desc_cencos	[row]	= ls_data
		
	CASE "cnta_prsp_mp"
		SELECT DESCRIPCION
		  INTO :ls_data
		FROM  PRESUPUESTO_CUENTA
		WHERE CNTA_PRSP = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'LA CUENTA PRESUPUESTAL NO EXISTE O NO ESTA ACTIVA, POR FAVOR VERIFIQUE', StopSign!)
			this.object.cnta_prsp_mp		[row] = ls_null
			this.object.desc_cnta_prsp_mp	[row]	= ls_null
			return 1
		END IF
		
		this.object.desc_cnta_prsp_mp	[row]	= ls_data
		
	CASE "impuesto_lc"
		SELECT DESC_IMPUESTO
		  INTO :ls_data 
		FROM  IMPUESTOS_TIPO
		WHERE TIPO_IMPUESTO = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'IMPUESTO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.impuesto_lc		[row] = ls_null
			this.object.desc_impt_lc	[row]	= ls_null
			return 1
		END IF
		
		this.object.desc_impt_lc[row]	= ls_data
			
	CASE "und_kg"  
		SELECT DESC_UNIDAD
		  INTO :ls_data
		FROM UNIDAD 
		WHERE und = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'LA UNIDAD NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.und_kg		[row] = ls_null
			this.object.desc_und_kg	[row]	= ls_null
			return 1
		END IF	
	
		this.object.desc_und_kg	[row]	= ls_data
		
		
	CASE "und_tm"  
		SELECT DESC_UNIDAD
		  INTO :ls_data
		FROM UNIDAD 
		WHERE und = :data;							
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'LA UNIDAD NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.und_tm		[row] = ls_null
			this.object.desc_und_tm	[row]	= ls_data
			return 1
		END IF	
		
		this.object.desc_und_tm	[row]	= ls_data
		
		
		
END CHOOSE
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen		[al_row] = 'XX'  // Equivale a todos los origenes
This.object.nom_origen	[al_row] = 'TODOS'
end event

