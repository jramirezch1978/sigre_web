$PBExportHeader$w_cd001_usuario_seccion.srw
forward
global type w_cd001_usuario_seccion from w_abc_master
end type
end forward

global type w_cd001_usuario_seccion from w_abc_master
integer width = 3543
integer height = 1204
string title = "(CD001)Usuarios Recepcionistas"
string menuname = "m_mantenimiento_sl"
end type
global w_cd001_usuario_seccion w_cd001_usuario_seccion

on w_cd001_usuario_seccion.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_cd001_usuario_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve( )

of_position_window(50,50)

end event

event ue_update;call super::ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log and lbo_ok THEN
	lbo_ok = dw_master.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event resize;call super::resize;//

end event

type dw_master from w_abc_master`dw_master within w_cd001_usuario_seccion
event ue_display ( string as_columna,  long al_row )
integer x = 27
integer y = 32
integer width = 3424
integer height = 916
string dataobject = "d_usuario_seccion_grd"
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov, ls_area
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "COD_ORIGEN"
		ls_sql = "SELECT A.COD_ORIGEN AS CODIGO, " 	&
			    + "A.NOMBRE AS DESCRIPCION " 			&
				 + "FROM ORIGEN	 	A " 							
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.cod_origen[al_row] = ls_codigo
			This.ii_update = 1
		END IF

	CASE "COD_USR"
		ls_sql = "SELECT A.COD_USR AS CODIGO, " 	&
			    + "A.NOMBRE AS DESCRIPCION " 		&
				 + "FROM USUARIO 	A " 							
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		
		IF ls_codigo <> '' THEN
			This.object.cod_usr[al_row] 	 = ls_codigo
			This.object.usuario_nombre[al_row] 	 = ls_data
			This.ii_update = 1
		END IF
		
	CASE "COD_AREA"
		ls_sql = "SELECT A.COD_AREA AS CODIGO, " 	&
			    + "A.DESC_AREA AS DESCRIPCION " 		&
				 + "FROM AREA 	A " 							
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		
		IF ls_codigo <> '' THEN
			This.object.cod_area[al_row] 	 = ls_codigo
			This.object.desc_area[al_row]  = ls_data
			This.ii_update = 1
		END IF

CASE "COD_SECCION"
		ls_area = dw_master.object.cod_area[al_row] 
		
		ls_area = TRIM(ls_area)
		
		ls_sql = "SELECT A.COD_SECCION AS CODIGO, " 	&
			    + "A.DESC_SECCION AS DESCRIPCION " 	&
				 + "FROM SECCION 	A " &
				 + "WHERE COD_AREA = '" + ls_area + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		
		IF ls_codigo <> '' THEN
			This.object.cod_seccion[al_row] 	 = ls_codigo
			This.object.desc_seccion[al_row]  = ls_data
			This.ii_update = 1
		END IF

END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
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

event dw_master::itemerror;call super::itemerror;Return 1
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

event dw_master::itemchanged;call super::itemchanged;string ls_origen, ls_flag, ls_data, ls_codigo, ls_prov, ls_null,ls_usuario,ls_area,ls_seccion
Long ll_count

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "COD_ORIGEN"
		ls_origen = this.object.cod_origen[row]
	
		select count(*) 
		into :ll_count
		from origen 
		where cod_origen = :ls_origen ;
		
		IF ll_count=0 THEN
			messagebox('Aviso','Origen no existe')
			this.object.cod_origen[row] = ls_Null
			RETURN 1
		end if 

	CASE "COD_USR"
		ls_usuario = this.object.cod_usr[row]

		select count(*)
		into :ll_count
		from usuario
		where cod_usr = :ls_usuario;
		
	IF ll_count=0 THEN
		Messagebox('Aviso', "Codigo de Usuario no existe", StopSign!)
		this.object.cod_usr		  [row] = ls_Null
		RETURN 1
	End if 	
		
		SELECT a.nombre
			INTO :ls_data
		FROM usuario a
		WHERE cod_usr=:ls_usuario;
		
		this.object.usuario_nombre[row] = ls_data	
		  
	
	CASE "COD_AREA"
		ls_area = this.object.cod_area[row]
		
		select count(*)
		into :ll_count
		from area
		where cod_area = :ls_area;

	IF ll_count=0 THEN
		Messagebox('Aviso', "Codigo de Area no existe", StopSign!)
		this.object.cod_area	  [row] = ls_Null
		RETURN 1
	End if 	
		
		SELECT a.desc_area
			INTO :ls_data
		FROM area a
		WHERE cod_area=:ls_area;

		this.object.desc_area[row] = ls_data	
		

	CASE "COD_SECCION"
		ls_area 	  = this.object.cod_area[row]
		ls_seccion = this.object.cod_seccion[row]

		select count(*)
		into :ll_count
		from seccion
		where cod_area=:ls_area and cod_seccion = :ls_seccion;
		
		IF ll_count=0 THEN
		Messagebox('Aviso', "Codigo de Seccion no existe", StopSign!)
		this.object.cod_seccion	  [row] = ls_Null
		RETURN 1
	End if 	

		SELECT a.desc_seccion
		INTO :ls_data
		FROM seccion a
		WHERE cod_area=:ls_area and cod_seccion = :ls_seccion;

		this.object.desc_seccion[row] = ls_data	
			
END CHOOSE
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_recepcion[al_row] = '0'
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
end event

