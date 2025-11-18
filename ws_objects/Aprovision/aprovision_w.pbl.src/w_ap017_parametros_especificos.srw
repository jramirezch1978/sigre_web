$PBExportHeader$w_ap017_parametros_especificos.srw
forward
global type w_ap017_parametros_especificos from w_abc_master
end type
end forward

global type w_ap017_parametros_especificos from w_abc_master
integer width = 1833
integer height = 964
string title = "Parametros Especificos de Aprovisionamiento (AP017)"
string menuname = "m_ap_param"
end type
global w_ap017_parametros_especificos w_ap017_parametros_especificos

on w_ap017_parametros_especificos.create
call super::create
if this.MenuName = "m_ap_param" then this.MenuID = create m_ap_param
end on

on w_ap017_parametros_especificos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

idw_1.Retrieve(gs_origen )

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
	dw_master.retrieve(gs_origen)
END IF


end event

type dw_master from w_abc_master`dw_master within w_ap017_parametros_especificos
event ue_display ( string as_columna,  long al_row )
integer x = 41
integer y = 36
integer width = 1723
integer height = 720
string dataobject = "d_ap_parametros_especificos_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

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

END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 10				// columnas de lectrua de este dw

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

END CHOOSE
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_origen

this.object.origen		[al_row] = gs_origen  // Equivale a todos los origenes

SELECT nombre
  INTO :ls_origen
FROM origen
WHERE cod_origen = :gs_origen;

This.object.nom_origen	[al_row] = ls_origen
end event

