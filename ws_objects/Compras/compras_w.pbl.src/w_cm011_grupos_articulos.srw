$PBExportHeader$w_cm011_grupos_articulos.srw
forward
global type w_cm011_grupos_articulos from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_cm011_grupos_articulos
end type
type st_2 from statictext within w_cm011_grupos_articulos
end type
type dw_super_grupos from u_dw_abc within w_cm011_grupos_articulos
end type
type st_super_grupos from statictext within w_cm011_grupos_articulos
end type
end forward

global type w_cm011_grupos_articulos from w_abc_mastdet_smpl
integer width = 3890
integer height = 2532
string title = "[CM011] Grupos - Super Grupos"
string menuname = "m_mantto_smpl"
st_1 st_1
st_2 st_2
dw_super_grupos dw_super_grupos
st_super_grupos st_super_grupos
end type
global w_cm011_grupos_articulos w_cm011_grupos_articulos

on w_cm011_grupos_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
this.st_2=create st_2
this.dw_super_grupos=create dw_super_grupos
this.st_super_grupos=create st_super_grupos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_super_grupos
this.Control[iCurrent+4]=this.st_super_grupos
end on

on w_cm011_grupos_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_super_grupos)
destroy(this.st_super_grupos)
end on

event ue_modify;call super::ue_modify;int li_protect_grupo, li_protect_art

li_protect_grupo = integer(dw_master.Object.Grupo_art.Protect)
IF li_protect_grupo= 0 THEN
   dw_master.Object.grupo_art.Protect = 1
END IF

li_protect_art = integer(dw_detail.Object.Cod_art.Protect)
IF li_protect_art = 0 THEN
   dw_detail.Object.cod_art.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;
ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master

ii_pregunta_delete = 1

idw_1 = dw_super_grupos


dw_super_grupos.setTransObject(SQLCA)

dw_super_grupos.Retrieve()
end event

event resize;// Override 

st_1.y = newheight / 2 + 5
dw_master.y 		= st_1.y + st_1.height + 10
dw_master.height 	= newheight - dw_master.y - 10
dw_master.width  	= newwidth/2  - dw_master.x - 5

st_1.x = dw_master.x
st_1.width = dw_master.width


//Super Grupos
dw_super_grupos.height 	= st_1.y - dw_super_grupos.y - 5
dw_super_grupos.width  	= dw_master.width

st_super_grupos.width	= dw_super_grupos.width

//Detalle de articulos
dw_detail.X  = newwidth/2  + 5
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

st_2.x = dw_detail.x
st_2.width = dw_detail.width
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False	

if gnvo_app.of_row_Processing( dw_master) <> true then return 

if gnvo_app.of_row_Processing( dw_detail) <> true then return

if gnvo_app.of_row_Processing( dw_super_grupos) <> true then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_super_grupos.of_set_flag_replicacion()

ib_update_check = True
end event

event ue_insert;//Override
Long  ll_row

if idw_1 = dw_master then
	
	if dw_super_grupos.getRow() = 0 or dw_super_grupos.RowCount() = 0 then
		MessageBox('Error', 'Debe Seleccionar un Super Grupo antes de ingresar un Grupo', StopSign!)
		return
	end if
	
elseif idw_1 = dw_detail then
	
	if dw_master.getRow() = 0 or dw_master.RowCount() = 0 then
		MessageBox('Error', 'Debe Seleccionar un Grupo de Articulo antes de Insertar un ARTICULO', StopSign!)
		return
	end if
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_open_pos;call super::ue_open_pos;idw_1 = dw_super_grupos

dw_super_grupos.setFocus()
end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 OR &
	dw_detail.ii_update = 1 OR &
	dw_super_grupos.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_super_grupos.ii_update = 0
		
		ib_update_check = true
		
	END IF
END IF

end event

event ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()
dw_super_grupos.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_super_grupos.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_super_grupos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_super_grupos.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion SUPER - GRUPOS", ls_msg, StopSign!)
	END IF
END IF

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

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_super_grupos.of_save_log()
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update 			= 0
	dw_detail.ii_update 			= 0
	dw_super_grupos.ii_update 	= 0
	
	dw_master.il_totdel 			= 0
	dw_detail.il_totdel 			= 0
	dw_super_grupos.il_totdel 	= 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_super_grupos.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm011_grupos_articulos
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1232
integer width = 1952
integer height = 1020
string dataobject = "d_abc_grupos_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "und"
		ls_sql = "SELECT und AS CODIGO_unidad, " &
				  + "desc_unidad AS DESCRIPCION_unidad " &
				  + "FROM unidad " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.und			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		return
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//ib_delete_cascada = true
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "und"
		
		select desc_unidad
			into :ls_data
		from unidad
		where und = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de unidad no existe o no está activo", StopSign!)
			this.object.und	[row] = ls_null
			return 1
		end if

end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.spr_grp_art	[al_Row] = dw_super_grupos.object.spr_grp_art [dw_super_grupos.getRow()]

this.object.flag_estado [al_row] = '1'


end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm011_grupos_articulos
integer x = 1975
integer y = 100
integer width = 1952
integer height = 1320
string dataobject = "d_abc_articulo_grupo_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 2	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;RETURN 1   // Fuerza a no mostrar ventana de powerb
end event

event dw_detail::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_detail::ue_display;call super::ue_display;// Abre ventana de ayuda 
string			ls_sql, ls_codigo, ls_data, ls_art_bonific
str_Articulo	lstr_articulo

choose case lower(as_columna)
	case "cod_art"
		/*************************************************************/
		//De acuerdo al factor Saldo Total aparece la ventana correcta
		/*************************************************************/
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
	
		if lstr_articulo.b_Return then
			this.object.cod_Art		[al_row] = lstr_articulo.cod_art
			this.object.desc_art		[al_row] = lstr_articulo.desc_art
			this.object.und			[al_row] = lstr_articulo.und
			
			this.ii_update = 1
		end if

end choose
end event

event dw_detail::itemchanged;call super::itemchanged;String ls_data, ls_und, ls_art_bonific

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_data, :ls_und
		  from articulo
		 Where cod_art = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_art		[row] = gnvo_app.is_null
			this.object.desc_art		[row] = gnvo_app.is_null
			this.object.und			[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Artículo ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_art			[row] = ls_data
		this.object.und				[row] = ls_und

END CHOOSE
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.grupo_art [al_row] = dw_master.object.grupo_art [dw_master.getRow()]
end event

type st_1 from statictext within w_cm011_grupos_articulos
integer y = 1124
integer width = 1952
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Grupos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm011_grupos_articulos
integer x = 1975
integer width = 1742
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Articulos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_super_grupos from u_dw_abc within w_cm011_grupos_articulos
integer y = 100
integer width = 1952
integer height = 1020
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_super_grupos_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_output;call super::ue_output;if al_Row = 0 then return

dw_master.Retrieve(this.object.spr_grp_art [al_row])
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

type st_super_grupos from statictext within w_cm011_grupos_articulos
integer width = 1952
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "SUPER - GRUPOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

