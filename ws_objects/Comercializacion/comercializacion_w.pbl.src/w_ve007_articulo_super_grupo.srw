$PBExportHeader$w_ve007_articulo_super_grupo.srw
forward
global type w_ve007_articulo_super_grupo from w_abc_master
end type
type dw_detail from u_dw_abc within w_ve007_articulo_super_grupo
end type
type dw_3 from u_dw_abc within w_ve007_articulo_super_grupo
end type
end forward

global type w_ve007_articulo_super_grupo from w_abc_master
integer width = 2441
integer height = 2072
string title = "[VE007] Super Grupo y Grupo de Articulos"
string menuname = "m_mantenimiento"
boolean maxbox = false
boolean resizable = false
dw_detail dw_detail
dw_3 dw_3
end type
global w_ve007_articulo_super_grupo w_ve007_articulo_super_grupo

on w_ve007_articulo_super_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
this.dw_detail=create dw_detail
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_3
end on

on w_ve007_articulo_super_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_3)
end on

event ue_open_pre;call super::ue_open_pre;dw_detail.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

idw_1.Retrieve()

dw_detail.of_protect() 	// bloquear modificaciones al dw_detail
dw_3.of_protect()    	// bloquear modificaciones al dw_3

of_position_window(50,50)
end event

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_master.x - 10
dw_3.width  = newwidth  - dw_3.x - 10
dw_3.height = newheight - dw_3.y - 10

end event

event ue_modify;idw_1.of_protect( )
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true
dw_master.accepttext( )
dw_detail.accepttext( )
dw_3.accepttext( )

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

if f_row_processing( dw_detail, 'tabular') = false then
	ib_update_check = false
	return
end if

if f_row_processing( dw_3, 'tabular') = false then
	ib_update_check = false
	return
end if

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_3.of_set_flag_replicacion()

end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
dw_detail.accepttext( )
dw_3.accepttext( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_3.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_3.ii_update = 1 THEN
	IF dw_3.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF


IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = dw_3.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	//idw_1.Retrieve()
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	dw_detail.ii_update 	= 0
	dw_detail.il_totdel 	= 0
	dw_detail.ii_protect = 0
	dw_detail.of_protect( )
	
	dw_3.ii_update 	= 0
	dw_3.il_totdel 	= 0
	dw_3.ii_protect = 0
	dw_3.of_protect( )
	
END IF


end event

event ue_update_request;//Ancestor Overriding
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF dw_master.ii_update 		= 1 &
	or dw_detail.ii_update 	= 1 &
	or dw_3.ii_update 		= 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_3.ii_update = 0
	END IF
END IF
end event

type dw_master from w_abc_master`dw_master within w_ve007_articulo_super_grupo
integer x = 37
integer y = 32
integer width = 2341
integer height = 580
string dataobject = "d_ve_art_super_grupo_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

idw_det  =   dw_detail
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!


end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

type dw_detail from u_dw_abc within w_ve007_articulo_super_grupo
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 616
integer width = 2341
integer height = 580
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ve_articulo_grupo_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_und
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "grupo_art"
		ls_sql = "SELECT grupo_art AS grupo_articulo, " &
				  + "DESC_GRUPO_ART AS DESCRIPCION_grupo, " &
				  + "und_reporte as unidad_reporte " &
				  + "FROM articulo_grupo " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '1')
		
		if ls_codigo <> '' then
			this.object.grupo_art		[al_row] = ls_codigo
			this.object.desc_grupo_art	[al_row] = ls_data
			this.object.und_reporte		[al_row] = ls_und
			this.ii_update = 1
		end if
		
		return
end choose
end event

event constructor;call super::constructor;is_mastdet = 'dd'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master
ii_dk[1] = 2 	      	// columnas que se pasan al detalle

idw_mst  = dw_master
idw_det  = dw_3
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

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
	if li_column <= 0 then return 0

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

event itemchanged;call super::itemchanged;string 	ls_data, ls_null, ls_und

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "grupo_art"
		
		select desc_grupo_art, und_reporte
			into :ls_data, :ls_und
		from articulo_grupo
		where grupo_art = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Grupo de Articulos no existe o no está activo", StopSign!)
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			this.object.und_reporte	[row] = ls_null
			return 1
		end if

		this.object.desc_labor	[row] = ls_data
		this.object.und_reporte	[row] = ls_und
		
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return

this.object.spr_grp_art [al_row] = dw_master.object.spr_grp_art[dw_master.GetRow()]
end event

type dw_3 from u_dw_abc within w_ve007_articulo_super_grupo
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 1196
integer width = 2341
integer height = 600
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ve_rel_articulo_grupo_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "COD_ART"
		ls_sql = "SELECT DISTINCT A.COD_ART AS CODIGO, " 	&
			    + "A.desc_art AS DESCRIPCION " 			&
				 + "FROM ARTICULO A, " 								&
				 + "ARTICULO_VENTA AV "								&
				 + "WHERE A.COD_ART = AV.COD_ART "				&	
				 + "AND FLAG_ESTADO = '1' " 		
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_art		[al_row] = ls_codigo
			This.object.nom_articulo[al_row] = ls_data
			This.ii_update = 1
		END IF
	
END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'd'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectura de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master

idw_mst  = dw_detail

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_codigo, ls_prov, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
		
CASE "COD_ART"
		SELECT a.nom_articulo
			INTO :ls_data
		FROM articulo 			a,
		     articulo_venta  av
		WHERE a.cod_art = :data
		  AND a.cod_art = av.cod_art
		  AND  flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Articulo no existe", StopSign!)
			this.object.cod_art		[row] = ls_Null
			this.object.nom_articulo[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_articulo[row] = ls_data

END CHOOSE
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

event doubleclicked;call super::doubleclicked;string ls_columna
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

event itemerror;call super::itemerror;Return 1
end event

