$PBExportHeader$w_af009_parametros_calculo.srw
forward
global type w_af009_parametros_calculo from w_abc_master_smpl
end type
end forward

global type w_af009_parametros_calculo from w_abc_master_smpl
integer width = 1728
integer height = 816
string title = "(AF009) Parámetros de Operaciones"
string menuname = "m_numerador"
long backcolor = 67108864
end type
global w_af009_parametros_calculo w_af009_parametros_calculo

on w_af009_parametros_calculo.create
call super::create
if this.MenuName = "m_numerador" then this.MenuID = create m_numerador
end on

on w_af009_parametros_calculo.destroy
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

type dw_master from w_abc_master_smpl`dw_master within w_af009_parametros_calculo
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 28
integer width = 1627
integer height = 584
string dataobject = "dw_abc_parametros_calculo_ff"
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
	CASE "depreciacion"
		ls_sql = "SELECT CALCULO_TIPO AS OPERACION, " &
				  +"DESCRIPCION AS DESCRIPCION_OPERACION " &
				  +"FROM AF_CALCULO_TIPO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.depreciacion [al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
	CASE "indexacion"
		ls_sql = "SELECT CALCULO_TIPO AS OPERACION, " &
				  +"DESCRIPCION AS DESCRIPCION_OPERACION " &
				  +"FROM AF_CALCULO_TIPO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.indexacion [al_row] = ls_codigo
			This.ii_update = 1
		END IF
	
	CASE "repotenciacion"
		ls_sql = "SELECT CALCULO_TIPO AS OPERACION, " &
				  +"DESCRIPCION AS DESCRIPCION_OPERACION " &
				  +"FROM AF_CALCULO_TIPO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.repotenciacion [al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
	CASE "revaluacion"
		ls_sql = "SELECT CALCULO_TIPO AS OPERACION, " &
				  +"DESCRIPCION AS DESCRIPCION_OPERACION " &
				  +"FROM AF_CALCULO_TIPO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.revaluacion  [al_row] = ls_codigo
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
	CASE 'depreciacion'
		   SELECT COUNT(CALCULO_TIPO)
			  INTO :ll_count
			FROM   AF_CALCULO_TIPO
			WHERE  CALCULO_TIPO = :data;
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'LA OPERACION DEPRECIACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.depreciacion	[row]	= ls_null
				Return 1
			END IF
		
	CASE 'indexacion'
		    SELECT COUNT(CALCULO_TIPO)
			  INTO :ll_count
			FROM   AF_CALCULO_TIPO
			WHERE  CALCULO_TIPO = :data;
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'LA OPERACION INDEXACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.indexacion	[row]	= ls_null
				Return 1
			END IF
	
	CASE 'repotenciacion'
		    SELECT COUNT(CALCULO_TIPO)
			  INTO :ll_count
			FROM   AF_CALCULO_TIPO
			WHERE  CALCULO_TIPO = :data;
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'LA OPERACION REPOTENCIACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.repotenciacion	[row]	= ls_null
				Return 1
			END IF
		
	CASE 'revaluacion'
		    SELECT COUNT(CALCULO_TIPO)
			  INTO :ll_count
			FROM   AF_CALCULO_TIPO
			WHERE  CALCULO_TIPO = :data;
						
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'LA OPERACION REVALUACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.revaluacion	[row]	= ls_null
				Return 1
			END IF
			
END CHOOSE


end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

