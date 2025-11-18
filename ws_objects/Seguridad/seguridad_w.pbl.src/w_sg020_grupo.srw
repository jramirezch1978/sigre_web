$PBExportHeader$w_sg020_grupo.srw
forward
global type w_sg020_grupo from w_abc_mastdet_smpl
end type
type dw_aplicaciones from u_dw_abc within w_sg020_grupo
end type
type st_roles from statictext within w_sg020_grupo
end type
type st_usuarios from statictext within w_sg020_grupo
end type
type st_aplicaciones from statictext within w_sg020_grupo
end type
end forward

global type w_sg020_grupo from w_abc_mastdet_smpl
integer width = 3625
integer height = 2328
string title = "[SG020] Mantenimiento de Roles"
string menuname = "m_abc_master_smpl"
dw_aplicaciones dw_aplicaciones
st_roles st_roles
st_usuarios st_usuarios
st_aplicaciones st_aplicaciones
end type
global w_sg020_grupo w_sg020_grupo

type variables

end variables

on w_sg020_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.dw_aplicaciones=create dw_aplicaciones
this.st_roles=create st_roles
this.st_usuarios=create st_usuarios
this.st_aplicaciones=create st_aplicaciones
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_aplicaciones
this.Control[iCurrent+2]=this.st_roles
this.Control[iCurrent+3]=this.st_usuarios
this.Control[iCurrent+4]=this.st_aplicaciones
end on

on w_sg020_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_aplicaciones)
destroy(this.st_roles)
destroy(this.st_usuarios)
destroy(this.st_aplicaciones)
end on

event ue_open_pre;//Override
idw_1 = dw_master  

dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_aplicaciones.SetTransObject(SQLCA)

// bloquear modificaciones 
dw_master.of_protect()         			
dw_detail.of_protect()
dw_aplicaciones.of_protect()


end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
st_roles.width  = newwidth  - st_roles.x - 10

dw_detail.width  = ( newwidth * 0.40 ) - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_usuarios.width = dw_detail.width

dw_aplicaciones.x 		= dw_detail.x + dw_detail.width + 10 
dw_aplicaciones.width 	= newwidth - dw_aplicaciones.x - 10
dw_aplicaciones.height  = dw_detail.height 
st_Aplicaciones.x 		= dw_aplicaciones.x
st_Aplicaciones.width 	= dw_aplicaciones.width
end event

event ue_update;call super::ue_update;//Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()
dw_aplicaciones.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_aplicaciones.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF dw_aplicaciones.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_aplicaciones.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion APLICACIONES", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_aplicaciones.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_aplicaciones.il_totdel = 0
	dw_aplicaciones.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_aplicaciones.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_insert;//Override
Long  ll_row

IF idw_1 = dw_detail or idw_1 = dw_aplicaciones THEN
	if dw_master.RowCount() = 0 then
		MessageBox("Error", "No existe ningun rol creado, por favor verifique!", StopSign!)
		RETURN
	end if
	
	if dw_master.getRow() = 0 then
		MessageBox("Error", "No existe ningun rol Seleccionado, por favor verifique!", StopSign!)
		RETURN
	end if
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;//Override
dw_master.of_protect()
dw_detail.of_protect()
dw_aplicaciones.of_protect( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_sg020_grupo
integer x = 0
integer y = 96
integer width = 1865
integer height = 848
string dataobject = "d_grupo_tbl"
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
dw_detail.retrieve( dw_master.object.grupo[dw_master.getrow()] )
dw_aplicaciones.retrieve( dw_master.object.grupo[dw_master.getrow()] )
end event

event dw_master::ue_output;//Override
if al_row = 0 then return

dw_detail.retrieve( this.object.grupo[al_row] )
dw_aplicaciones.retrieve( this.object.grupo[al_row] )

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_sg020_grupo
integer x = 0
integer y = 1052
integer width = 1019
integer height = 1016
string dataobject = "d_grp_usr_tbl"
boolean livescroll = false
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_cod_usr, ls_nombre, ls_origen_alt, ls_flag_estado, ls_sql
choose case lower(as_columna)
		
	case "cod_usr"

		ls_sql = "select cod_usr as codigo_usuario, " &
				 + "nombre as nombre_usuario, " &
				 + "origen_alt as origen_alterno, " &
				 + "flag_estado as estado_usuario " &
				 + "from usuario " &
				 + "where flag_estado = '1'"
				 
		
		if gnvo_app.of_lista(ls_sql, ls_cod_usr, ls_nombre, ls_origen_alt, ls_flag_estado, '2') then
			this.object.cod_usr		[al_row] = ls_cod_usr
			this.object.nom_usuario	[al_row] = ls_nombre
			this.object.origen_alt	[al_row] = ls_origen_alt
			this.object.flag_estado	[al_row] = ls_flag_estado

			this.ii_update = 1
		end if

end choose



end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_nombre, ls_origen_alt, ls_flag_estado
Long 		ll_count

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_usr'
		
		// Verifica que codigo ingresado exista			
		Select nombre, origen_alt, flag_estado
	     into :ls_nombre, :ls_origen_alt, :ls_flag_estado
		  from usuario
		 Where cod_usr = :data  
		   and flag_estado <> '0';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			
			this.object.cod_usr		[row] = gnvo_app.is_null
			this.object.nombre		[row] = gnvo_app.is_null
			this.object.origen_alt	[row] = gnvo_app.is_null
			this.object.flag_estado	[row] = gnvo_app.is_null
			
			MessageBox("Error", "No existe Codigo de usuario " + data + " o no se encuentra activo, por favor verifique", StopSign!)
			
			return 1
			
		end if

		this.object.nombre		[row] = ls_nombre
		this.object.origen_alt	[row] = ls_origen_alt
		this.object.flag_estado	[row] = ls_flag_estado


END CHOOSE
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.grupo	[al_row] = dw_master.object.grupo [dw_master.getRow()]
end event

type dw_aplicaciones from u_dw_abc within w_sg020_grupo
integer x = 1047
integer y = 1052
integer height = 1016
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_grp_obj"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.grupo	[al_row] = dw_master.object.grupo [dw_master.getRow()]

this.object.flag_insertar	[al_row] = '0'
this.object.flag_eliminar	[al_row] = '0'
this.object.flag_modificar	[al_row] = '0'
this.object.flag_cancelar	[al_row] = '0'
this.object.flag_anular		[al_row] = '0'
this.object.flag_consultar	[al_row] = '0'
this.object.flag_duplicar	[al_row] = '0'
end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_sistema, ls_objeto, ls_sql, ls_lista
Long		ll_i
choose case lower(as_columna)
	case "objeto"
		ls_sql = "select sistema as sistema, " &
				 + "objeto as objeto_sistema, " &
				 + "descripcion as descripcion_objeto " &
				 + "from objeto_sis "
		
		//Verifico que existan regsitros en esta objeto
		if dw_aplicaciones.RowCount() > 0 then
			ls_lista = ''
			for ll_i = 1 to dw_aplicaciones.RowCount()
				if Not Isnull(dw_aplicaciones.object.objeto [ll_i]) and trim(dw_aplicaciones.object.objeto [ll_i]) <> '' then
					ls_lista += "'" + trim(dw_aplicaciones.object.objeto [ll_i]) + "', "				
				end if
			next
			
			if trim(ls_lista) <> '' then
				ls_lista = left(ls_lista, len(trim(ls_lista)) - 1)
				ls_sql += "where objeto not in (" + ls_lista + ")"
			end if
			
		end if
		
		if gnvo_app.of_lista(ls_sql, ls_sistema, ls_objeto, '1') then
			this.object.sistema	[al_row] = ls_sistema
			this.object.objeto	[al_row] = ls_objeto
			
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_sistema

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'objeto'
		
		// Verifica que codigo ingresado exista			
		Select sistema
	     into :ls_sistema
		  from objeto_sis
		 Where objeto = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.objeto	[row] = gnvo_app.is_null
			this.object.sistema	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Sistema " + data + " no existe, por favor verifique')
			return 1
		end if

		this.object.sistema		[row]  = ls_sistema


END CHOOSE
end event

type st_roles from statictext within w_sg020_grupo
integer width = 608
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Roles"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_usuarios from statictext within w_sg020_grupo
integer y = 952
integer width = 608
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Usuarios"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_aplicaciones from statictext within w_sg020_grupo
integer x = 1047
integer y = 952
integer width = 608
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Aplicaciones"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

