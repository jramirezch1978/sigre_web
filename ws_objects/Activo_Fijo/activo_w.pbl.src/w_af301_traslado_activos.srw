$PBExportHeader$w_af301_traslado_activos.srw
forward
global type w_af301_traslado_activos from w_abc_master_lstmst
end type
end forward

global type w_af301_traslado_activos from w_abc_master_lstmst
integer width = 2574
integer height = 2232
string title = "(AF301) Traslado de Activos"
string menuname = "m_master_simple"
end type
global w_af301_traslado_activos w_af301_traslado_activos

type variables

end variables

forward prototypes
public function string of_set_numera_str ()
end prototypes

public function string of_set_numera_str ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN '0'

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM num_af_traslado
	WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE num_af_traslado IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN '0'
		END IF
		
		INSERT INTO num_af_traslado(origen, ult_nro)
		VALUES( :gs_origen, 1 );
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN '0'
		END IF
	END IF

	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_af_traslado
	WHERE origen = :gs_origen FOR UPDATE;
	
	UPDATE num_af_traslado
		SET ult_nro = ult_nro + 1
	WHERE origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN '0'
	END IF
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_movimiento[dw_master.getrow()] = ls_next_nro
	
	dw_master.ii_update = 1
	
ELSE
	ls_next_nro = dw_master.object.nro_movimiento[dw_master.getrow()] 
END IF

RETURN '1'

end function

on w_af301_traslado_activos.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_af301_traslado_activos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override 
dw_lista.width = newwidth - dw_lista.x - 10
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250

This.move(ll_x,ll_y)

ib_log 		= True
is_action 	= 'open'


end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "form") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()


IF of_set_numera_str() = '0' THEN RETURN

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE


end event

event ue_insert;//Override
Long   ll_row_master, ll_row, ll_verifica
String ls_clase


dw_master.Accepttext() //accepttext de los dw

ll_row_master = dw_master.getrow( )

CHOOSE CASE idw_1
	CASE dw_master
	   // Adicionando en dw_master
	   TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   IF ib_update_check = FALSE THEN RETURN
	  
	   // Limpieza de los demas dw en insercion
	  	  
	   is_action = 'new' 
	
   CASE ELSE
	  RETURN
	  
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF
end event

event ue_update;//Override
Boolean  lbo_ok = TRUE
String	ls_msg
Long		ll_row

dw_master.AcceptText()
ll_row = dw_master.getrow( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
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
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update  = 0
	dw_master.il_totdel  = 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	is_action = 'open'
	dw_lista.event rowfocuschanged( ll_row )
END IF

end event

type dw_master from w_abc_master_lstmst`dw_master within w_af301_traslado_activos
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 860
integer width = 2491
integer height = 1168
string dataobject = "dw_traslado_activo_ff"
boolean hscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, &
			ls_data2, ls_data3, ls_usr_origen, ls_usr_desc

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
		
	CASE 'cod_activo'
		ls_sql = "select m.cod_activo as codigo_activo, " &
		        +"m.descripcion as descripcion, " &
				  +"m.cencos as centro_costo, " &
				  +"cc.desc_cencos "&
				  +"from af_maestro m, " &
				  +"centros_costo cc " &
				  +"where m.cencos = cc.cencos " &
				  +"and m.flag_estado = '1' "
				  
		lb_ret = f_lista_4ret_text(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '2')

		IF ls_codigo <> '' THEN
			This.object.cod_activo	 [al_row] = ls_codigo
			This.object.descripcion  [al_row] = ls_data
			This.object.cencos_origen[al_row] = ls_data2
			This.object.desc_origen	 [al_row] = ls_data3
			
			// Ingresamos el codigo de usuario origen
			SELECT af.usr_asignado, u.nombre
			  INTO :ls_usr_origen, :ls_usr_desc
			FROM  af_maestro af,
					usuario 	  u
			WHERE af.usr_asignado = u.cod_usr
			  AND af.cod_activo = :ls_codigo;
	
			This.object.usr_origen 	[al_row] = ls_usr_origen
			This.object.desc_usr_ori[al_row] = ls_usr_desc
			
			This.ii_update = 1
		END IF
		
	CASE 'cencos_destino'
		ls_sql = "select cencos as codigo, " &
		 		  +"desc_cencos as descripcion " &
				  +"from centros_costo " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cencos_destino [al_row] = ls_codigo
			This.object.desc_destino	[al_row] = ls_data
			This.ii_update = 1
		END IF

	CASE 'usr_origen'
		ls_sql = "select cod_usr as codigo, " &
				  +"nombre as descripcion " &
				  +"from usuario " & 
				  +"where flag_estado = '1' "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.usr_origen	[al_row] = ls_codigo
			This.object.desc_usr_ori[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'usr_destino'
		ls_sql = "select cod_usr as codigo, " &
				  +"nombre as descripcion " &
				  +"from usuario " & 
				  +"where flag_estado = '1' "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.usr_destino	[al_row] = ls_codigo
			This.object.desc_usr_des[al_row] = ls_data
			This.ii_update = 1
		END IF

END CHOOSE


end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1 
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 


THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_data, ls_null, ls_cencos, ls_desc_cencos, &
		 	ls_usr_origen, ls_usr_desc

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		
	CASE 'cod_activo'
		SELECT m.descripcion, m.cencos, cc.desc_cencos
		 INTO :ls_data, :ls_cencos, :ls_desc_cencos 
		FROM  af_maestro    m,
		      centros_costo cc
		WHERE m.cencos = cc.cencos
		  and m.cod_activo = :data
		  AND m.flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.cod_activo		[row] = ls_null
			This.object.descripcion		[row] = ls_null
			This.object.cencos_origen	[row] = ls_null
			This.object.desc_origen		[row] = ls_null
			RETURN 1
		END IF
		
		This.object.descripcion		[row] = ls_data
		This.object.cencos_origen	[row] = ls_cencos
		This.object.desc_origen		[row] = ls_desc_cencos
		
		// Agregamos el usuario origen
		
		SELECT af.usr_asignado, u.nombre
		  INTO :ls_usr_origen, :ls_usr_desc
		FROM  af_maestro af,
				usuario 	  u
		WHERE af.usr_asignado = u.cod_usr
		  AND af.cod_activo = :data;

		This.object.usr_origen 	[row] = ls_usr_origen
		This.object.desc_usr_ori[row] = ls_usr_desc
		
	CASE 'cencos_destino'
		SELECT desc_cencos	
		 INTO :ls_data
		FROM centros_costo	
		WHERE cencos = :data
		  AND flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CENCOS NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.cencos_destino	[row] = ls_null
			This.object.desc_destino	[row] = ls_null
			RETURN 1
		END IF
	
		This.object.desc_destino	[row] = ls_data
	
	CASE 'usr_origen'
		SELECT nombre
		  INTO :ls_data
		FROM usuario
		WHERE cod_usr = :data
		  AND flag_estado = '1';
		 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL USUARIO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.usr_origen 	[row] = ls_null
			This.object.desc_usr_ori[row] = ls_null
			RETURN 1
		END IF

		This.object.desc_usr_ori[row] = ls_data
	
	CASE 'usr_destino'
		SELECT nombre
		  INTO :ls_data
		FROM usuario
		WHERE cod_usr = :data
		  AND flag_estado = '1';
		 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CENCOS NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.usr_destino [row] = ls_null
			This.object.desc_usr_des[row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_usr_des[row] = ls_data
	
//	CASE 'usr_autorizacion'
//		SELECT nombre
//		  INTO :ls_data
//		FROM usuario
//		WHERE cod_usr = :data
//		  AND flag_estado = '1';
//		 
//		IF SQLCA.sqlcode = 100 THEN
//			MessageBox('Aviso', 'EL CENCOS NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
//			This.object.usr_autorizacion [row] = ls_null
//			This.object.desc_usr_aut	  [row] = ls_null
//			RETURN 1
//		END IF
//		
//		This.object.desc_usr_aut[row] = ls_data
	
END CHOOSE
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String	ls_nro_activo

This.object.fecha_movimiento 	[al_row] = DATE(f_fecha_actual())
This.object.usr_registra	  	[al_row] = gs_user
This.object.fecha_registro   	[al_row] = f_fecha_actual()

  
end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_af301_traslado_activos
integer y = 12
integer width = 2496
integer height = 796
string dataobject = "dw_lista_traslados_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1 
end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;IF currentrow > 0 THEN
	This.SelectRow(0,false)
	This.SelectRow(currentrow,true)
	dw_master.Scrolltorow(currentrow)
END IF

end event

