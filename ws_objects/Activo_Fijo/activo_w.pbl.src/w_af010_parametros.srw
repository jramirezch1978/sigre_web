$PBExportHeader$w_af010_parametros.srw
forward
global type w_af010_parametros from w_abc_master_smpl
end type
end forward

global type w_af010_parametros from w_abc_master_smpl
integer width = 1929
integer height = 960
string title = "(AF010) Parámetros de Control"
string menuname = "m_numerador"
long backcolor = 67108864
end type
global w_af010_parametros w_af010_parametros

on w_af010_parametros.create
call super::create
if this.MenuName = "m_numerador" then this.MenuID = create m_numerador
end on

on w_af010_parametros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "form") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE

end event

event ue_update;// Override //
Boolean lbo_ok = TRUE
Integer	li_rc
String	ls_msg

dw_master.AcceptText()
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
END IF

ls_msg = "Se ha procedido al Rollback"

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Rollback;
		messagebox("Error en Grabacion Master", ls_msg, exclamation!)
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
	dw_master.ii_update = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
END IF
end event

event ue_open_pre;//Override
THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton     

idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

ib_log = TRUE  //Para activar el log diario

idw_1.Retrieve( )



end event

event ue_open_pos;call super::ue_open_pos;IF idw_1.RowCount() = 0 THEN
	idw_1.event ue_insert()
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_af010_parametros
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 28
integer width = 1851
integer height = 724
string dataobject = "dw_abc_parametros_activo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string,	ls_evaluate
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE "tipo_doc_depre"
		ls_sql = "SELECT TIPO_DOC AS DOCUMENTO, " &
				  +"DESC_TIPO_DOC AS DESCRIPCION_TIPO_DOC " &
				  +"FROM DOC_TIPO " &
				  +"WHERE FLAG_ESTADO = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc_depre [al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
	CASE "tipo_doc_index"
		ls_sql = "SELECT TIPO_DOC AS DOCUMENTO, " &
				  +"DESC_TIPO_DOC AS DESCRIPCION_TIPO_DOC " &
				  +"FROM DOC_TIPO " &
				  +"WHERE FLAG_ESTADO = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc_index [al_row] = ls_codigo
			This.ii_update = 1
		END IF
	
	CASE "tipo_doc_reval"
		ls_sql = "SELECT TIPO_DOC AS DOCUMENTO, " &
				  +"DESC_TIPO_DOC AS DESCRIPCION_TIPO_DOC " &
				  +"FROM DOC_TIPO " &
				  +"WHERE FLAG_ESTADO = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc_reval [al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
	CASE "tipo_doc_index_depre"
		ls_sql = "SELECT TIPO_DOC AS DOCUMENTO, " &
				  +"DESC_TIPO_DOC AS DESCRIPCION_TIPO_DOC " &
				  +"FROM DOC_TIPO " &
				  +"WHERE FLAG_ESTADO = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc_index_depre  [al_row] = ls_codigo
			This.ii_update = 1
		END IF

	CASE "nro_libro_depre"
		ls_sql = "SELECT NRO_LIBRO AS NUMERO_LIBRO, " &
				  +"DESC_LIBRO AS DESCRIPCION_LIBRO_CONTABLE " &
				  +"FROM CNTBL_LIBRO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_libro_depre  [al_row] = INTEGER(ls_codigo)
			This.ii_update = 1
		END IF
		
	CASE "nro_libro_index"
		ls_sql = "SELECT NRO_LIBRO AS NUMERO_LIBRO, " &
				  +"DESC_LIBRO AS DESCRIPCION_LIBRO_CONTABLE " &
				  +"FROM CNTBL_LIBRO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_libro_index  [al_row] = INTEGER(ls_codigo)
			This.ii_update = 1
		END IF
	
	CASE "nro_libro_reval"
		ls_sql = "SELECT NRO_LIBRO AS NUMERO_LIBRO, " &
				  +"DESC_LIBRO AS DESCRIPCION_LIBRO_CONTABLE " &
				  +"FROM CNTBL_LIBRO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_libro_reval  [al_row] = INTEGER(ls_codigo)
			This.ii_update = 1
		END IF
		
	CASE "nro_libro_index_depre"
		ls_sql = "SELECT NRO_LIBRO AS LIBRO, " &
				  +"DESC_LIBRO AS DESCRIPCION_LIBRO_CONTABLE " &
				  +"FROM CNTBL_LIBRO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.nro_libro_index_depre  [al_row] = INTEGER(ls_codigo)
			This.ii_update = 1
		END IF
	
	CASE 'oper_depre'
		ls_sql = "SELECT CALCULO_TIPO AS COD_OPERACION, " &
				  +"DESCRIPCION AS DESCRIPCION_OPERACION " &
				  +"FROM AF_CALCULO_TIPO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.oper_depre	[al_row] = ls_codigo
			This.object.descripcion [al_row] = ls_data
			This.ii_update = 1
		END IF
		
	
END CHOOSE
end event

event dw_master::constructor;call super::constructor;ii_ck[1]   = 1
is_dwform  = 'form'
is_mastdet = 'm'
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;This.object.reckey [al_row] = '1'

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event dw_master::itemchanged;call super::itemchanged;String   ls_data, ls_null
Long		ll_count

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'tipo_doc_depre'
		   SELECT COUNT(TIPO_DOC)
			  INTO :ll_count
			FROM   DOC_TIPO
			WHERE  TIPO_DOC = :data
			  AND  FLAG_ESTADO = '1';
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'EL TIPO_DOC_DEPRE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.tipo_doc_depre	[row]	= ls_null
				Return 1
			END IF
		
	CASE 'tipo_doc_index'
		   SELECT COUNT(TIPO_DOC)
			  INTO :ll_count
			FROM   DOC_TIPO
			WHERE  TIPO_DOC = :data
			  AND  FLAG_ESTADO = '1';
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'EL TIPO_DOC_DEPRE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.tipo_doc_index [row]	= ls_null
				Return 1
			END IF
	
	CASE 'tipo_doc_reval'
		   SELECT COUNT(TIPO_DOC)
			  INTO :ll_count
			FROM   DOC_TIPO
			WHERE  TIPO_DOC = :data
			  AND  FLAG_ESTADO = '1';
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'EL TIPO_DOC_DEPRE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.tipo_doc_reval	[row]	= ls_null
				Return 1
			END IF
		
	CASE 'tipo_doc_index_depre'
		   SELECT COUNT(TIPO_DOC)
			  INTO :ll_count
			FROM   DOC_TIPO
			WHERE  TIPO_DOC = :data
			  AND  FLAG_ESTADO = '1';
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'EL TIPO_DOC_DEPRE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.tipo_doc_index_depre	[row]	= ls_null
				Return 1
			END IF
			
	CASE 'oper_depre'
			SELECT descripcion	
			 INTO :ls_data
			FROM af_calculo_tipo	
			WHERE calculo_tipo = :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA OPERACION DEPRECIACIÓN NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				this.object.oper_depre	[row] = ls_null
				this.object.descripcion	[row]	= ls_null
				return 1
			END IF
			
			this.object.descripcion[row]	= ls_data
	
END CHOOSE


end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

