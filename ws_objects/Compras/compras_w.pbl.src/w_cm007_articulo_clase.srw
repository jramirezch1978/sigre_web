$PBExportHeader$w_cm007_articulo_clase.srw
forward
global type w_cm007_articulo_clase from w_abc_master_smpl
end type
type dw_detail from u_dw_abc within w_cm007_articulo_clase
end type
type st_detail from statictext within w_cm007_articulo_clase
end type
end forward

global type w_cm007_articulo_clase from w_abc_master_smpl
integer width = 3758
integer height = 2276
string title = "[CM007] Clases de Artículos"
string menuname = "m_mantto_smpl"
boolean maxbox = false
dw_detail dw_detail
st_detail st_detail
end type
global w_cm007_articulo_clase w_cm007_articulo_clase

on w_cm007_articulo_clase.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.dw_detail=create dw_detail
this.st_detail=create st_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_detail
end on

on w_cm007_articulo_clase.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.st_detail)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if gnvo_app.of_row_Processing( dw_master) <> true then return
if gnvo_app.of_row_Processing( dw_Detail) <> true then return

ib_update_check = True
end event

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_clase.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_clase.Protect = 1
END IF 
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1
idw_1 = dw_master
dw_master.setFocus()
end event

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10

st_detail.width  = newwidth  - st_detail.x - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF	dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detail", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	dw_detail.ii_protect = 0
	dw_detail.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	this.event ue_retrieve()
	
END IF



//Boolean  lbo_ok = TRUE
//String	ls_msg
//
//dw_master.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN RETURN
//
//IF ib_log THEN
//	u_ds_base		lds_log
//	lds_log = Create u_ds_base
//	lds_log.DataObject = 'd_log_diario_tbl'
//	lds_log.SetTransObject(SQLCA)
//	
//	IF ISNull(in_log) THEN											
//		in_log = Create n_cst_log_diario
//		in_log.of_dw_map(idw_1, is_colname, is_coltype)
//	END IF
//	
//	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
//END IF
//
////Open(w_log)
////lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
//IF	dw_master.ii_update = 1 THEN
//	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
//	END IF
//END IF
//
//IF ib_log THEN
//	IF lbo_ok THEN
//		IF lds_log.Update(true, false) = -1 THEN
//			lbo_ok = FALSE
//			ROLLBACK USING SQLCA;
//			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
//		END IF
//	END IF
//	DESTROY lds_log
//END IF
//
//IF lbo_ok THEN
//	COMMIT using SQLCA;
//	dw_master.ii_update = 0
//	dw_master.il_totdel = 0
//	
//	dw_master.ResetUpdate( )
//END IF
//
end event

type dw_master from w_abc_master_smpl`dw_master within w_cm007_articulo_clase
integer width = 3479
integer height = 1128
string dataobject = "d_abc_articulo_clase_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_clase.Protect='1~tIf(IsRowNew(),0,1)'")
this.object.flag_estado [al_row] = '1'
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;//Overrite
IF this.is_dwform <> 'form' and ii_ss = 1 THEN		        // solo para seleccion individual			
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	this.event ue_output(currentrow)
	RETURN
END IF
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_sunat"

		ls_sql = "select codigo as codigo_sunat, " &
				 + "descripcion as descripcion_sunat " &
				 + "from sunat_tabla5 " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sunat				[al_row] = ls_codigo
			this.object.desc_tipo_existencia	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_sunat'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from sunat_tabla5
		 Where codigo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe código de Existencia en Tabla de SUNAT o no esta activo, por favor verifique!")
			this.object.cod_sunat				[row] = gnvo_app.is_null
			this.object.desc_tipo_existencia	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_tipo_existencia		[row] = ls_desc

END CHOOSE
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

ii_dk[1] = 1
end event

event dw_master::ue_output;call super::ue_output;if al_row = 0 then return

if dw_detail.ii_update = 1 then
	MessageBox('Aviso', 'Hay cambios pendientes en el panel de detalle, por favor grabe primero!', Information!)
	return
end if

dw_detail.Retrieve(dw_master.object.cod_clase [al_Row])
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from u_dw_abc within w_cm007_articulo_clase
integer y = 1208
integer width = 3479
integer height = 1280
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_articulo_clase_user_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)

	case "cod_usr"
		ls_sql = "select u.cod_usr as codigo_usuario, " &
				 + "u.nombre as nombre_usuario " &
				 + "from usuario u " &
				 + "where u.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_usr		[al_row] = ls_codigo
			this.object.nom_usuario	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
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

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_usr'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_data
		  from usuario
		 Where cod_usr = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_usr		[row] = gnvo_app.is_null
			this.object.nom_usuario	[row] = gnvo_app.is_null
			MessageBox('Error', 'Usuario ingresado [' + data + '] no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_usuario			[row] = ls_data


END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_clase [al_row] = dw_master.object.cod_clase [dw_master.getRow()]
end event

type st_detail from statictext within w_cm007_articulo_clase
integer y = 1128
integer width = 3474
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Usuarios por Clase de Articulo"
alignment alignment = center!
boolean focusrectangle = false
end type

