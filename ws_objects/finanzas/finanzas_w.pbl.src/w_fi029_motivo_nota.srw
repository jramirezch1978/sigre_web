$PBExportHeader$w_fi029_motivo_nota.srw
forward
global type w_fi029_motivo_nota from w_abc
end type
type dw_master from u_dw_abc within w_fi029_motivo_nota
end type
end forward

global type w_fi029_motivo_nota from w_abc
integer width = 2400
integer height = 1504
string title = "Motivos de notas de Credito /Debito (FI029)"
string menuname = "m_mantenimiento_cl"
dw_master dw_master
end type
global w_fi029_motivo_nota w_fi029_motivo_nota

type variables

end variables

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

on w_fi029_motivo_nota.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi029_motivo_nota.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
dw_master.retrieve()

dw_master.ii_protect = 0
dw_master.of_protect( )
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_delete;call super::ue_delete;Long  ll_row


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	//this.event ue_retrieve()
	
END IF
end event

type dw_master from u_dw_abc within w_fi029_motivo_nota
integer width = 2281
integer height = 1276
string dataobject = "d_abc_motivo_nota_tbl"
end type

event itemchanged;call super::itemchanged;String ls_data, ls_motivo

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'motivo'
		
		// Verifica que codigo ingresado exista			
		if upper(left(data, 3)) <> 'NCC' and upper(left(data, 3)) <> 'NCP' and &
			upper(left(data, 3)) <> 'NDC' and upper(left(data, 3)) <> 'NDP' then
			
			MessageBox('Error', &
				'El código del motivo de la nota de credito o débito debe comenzar por NCC, NCP, NDC, NDP. ' + &
				'Por favor verifique', StopSign!)
			
			this.object.motivo	[row] = gnvo_app.is_null
			
			return 1
		end if
		

	CASE 'tipo_nc'
		
		ls_motivo = this.object.motivo [row]
		
		if upper(left(ls_motivo, 2)) <> 'NC' then
			messageBox('Error', 'El tipo de Nota de Crédito esta permitido para los motivos que comiencen con NC. Por favor verifique', StopSign!)
			this.object.tipo_nc			[row] = gnvo_app.is_null
			this.object.desc_tipo_nc	[row] = gnvo_app.is_null
			return 1
		end if


		// Verifica que codigo ingresado exista			
		Select desc_tipo_nc
	     into :ls_data
		  from sunat_catalogo09
		 Where tipo_nc = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'Código de Tipo de Nota de Crédito no existe o no esta activo, por favor verifique', StopSign!)
			
			this.object.tipo_nc			[row] = gnvo_app.is_null
			this.object.desc_tipo_nc	[row] = gnvo_app.is_null
			
			return 1
		end if
		
		this.object.desc_tipo_nc	[row] = ls_data

	CASE 'tipo_nd'
		
		ls_motivo = this.object.motivo [row]
		
		if upper(left(ls_motivo, 2)) <> 'ND' then
			messageBox('Error', 'El tipo de Nota de Débito esta permitido para los motivos que comiencen con ND. Por favor verifique', StopSign!)
			this.object.tipo_nd			[row] = gnvo_app.is_null
			this.object.desc_tipo_nd	[row] = gnvo_app.is_null
			return 1
		end if


		// Verifica que codigo ingresado exista			
		Select desc_tipo_nd
	     into :ls_data
		  from sunat_catalogo10
		 Where tipo_nd = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'Código de Tipo de Nota de Débito no existe o no esta activo, por favor verifique', StopSign!)
			
			this.object.tipo_nd			[row] = gnvo_app.is_null
			this.object.desc_tipo_nd	[row] = gnvo_app.is_null
			
			return 1
		end if
		
		this.object.desc_tipo_nd	[row] = ls_data

END CHOOSE
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst = dw_master

end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_motivo

choose case lower(as_columna)
	case "tipo_nc"
		ls_motivo = this.object.motivo [al_row]
		
		if upper(left(ls_motivo, 2)) <> 'NC' then
			messageBox('Error', 'El tipo de Nota de Credito esta permitido para los motivos que comiencen con NC. Por favor verifique', StopSign!)
			return
		end if
		
		ls_sql = "select t.tipo_nc as tipo_nc, " &
				 + "t.desc_tipo_nc as desc_tipo_nc " &
				 + "from SUNAT_CATALOGO09 t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_nc			[al_row] = ls_codigo
			this.object.desc_tipo_nc	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tipo_nd"
		ls_motivo = this.object.motivo [al_row]
		
		if upper(left(ls_motivo, 2)) <> 'ND' then
			messageBox('Error', 'El tipo de Nota de Débito esta permitido para los motivos que comiencen con ND. Por favor verifique', StopSign!)
			return
		end if
		
		ls_sql = "select t.tipo_nd as tipo_nd, " &
				 + "t.desc_tipo_nd as desc_tipo_nd " &
				 + "from SUNAT_CATALOGO10 t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_nd			[al_row] = ls_codigo
			this.object.desc_tipo_nd	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

