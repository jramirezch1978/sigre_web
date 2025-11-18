$PBExportHeader$w_rh101_ctacte_registro.srw
forward
global type w_rh101_ctacte_registro from w_abc_mastdet_smpl
end type
type dw_detdet from u_dw_abc within w_rh101_ctacte_registro
end type
type cb_3 from commandbutton within w_rh101_ctacte_registro
end type
type em_descripcion from editmask within w_rh101_ctacte_registro
end type
type em_origen from editmask within w_rh101_ctacte_registro
end type
type em_desc_tipo from editmask within w_rh101_ctacte_registro
end type
type em_tipo from editmask within w_rh101_ctacte_registro
end type
type cb_2 from commandbutton within w_rh101_ctacte_registro
end type
type cb_1 from commandbutton within w_rh101_ctacte_registro
end type
type sle_codigo from singlelineedit within w_rh101_ctacte_registro
end type
type sle_nombre from singlelineedit within w_rh101_ctacte_registro
end type
type cb_4 from commandbutton within w_rh101_ctacte_registro
end type
type st_1 from statictext within w_rh101_ctacte_registro
end type
type st_2 from statictext within w_rh101_ctacte_registro
end type
type gb_2 from groupbox within w_rh101_ctacte_registro
end type
type gb_3 from groupbox within w_rh101_ctacte_registro
end type
type gb_4 from groupbox within w_rh101_ctacte_registro
end type
end forward

global type w_rh101_ctacte_registro from w_abc_mastdet_smpl
integer width = 4078
integer height = 2484
string title = "(RH101)  Cuenta corriente "
string menuname = "m_master_simple"
boolean resizable = false
event ue_retrieve ( string as_origen,  string as_tipo_trabaj,  string as_trabajador )
dw_detdet dw_detdet
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
sle_codigo sle_codigo
sle_nombre sle_nombre
cb_4 cb_4
st_1 st_1
st_2 st_2
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_rh101_ctacte_registro w_rh101_ctacte_registro

type variables
Integer 	li_row, li_column

end variables

event ue_retrieve(string as_origen, string as_tipo_trabaj, string as_trabajador);try 
	
	// Limpia los datawindows
	dw_master.reset()
	dw_detail.reset()
	dw_detdet.reset()
	
	// Recupera información
	dw_master.Retrieve(as_origen, as_tipo_trabaj, as_trabajador)
	
	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al Recuperar datos ventana de Cuenta Corriente")
	
finally
	/*statementBlock*/
	
end try


end event

on w_rh101_ctacte_registro.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_detdet=create dw_detdet
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.cb_4=create cb_4
this.st_1=create st_1
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detdet
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_desc_tipo
this.Control[iCurrent+6]=this.em_tipo
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.sle_codigo
this.Control[iCurrent+10]=this.sle_nombre
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_4
end on

on w_rh101_ctacte_registro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detdet)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.cb_4)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event resize;//override
dw_master.height = newheight - dw_master.y - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
st_1.width = dw_detail.width

dw_detdet.width  = newwidth  - dw_detdet.x - 10
dw_detdet.height = newheight - dw_detdet.y - 10
st_2.width = dw_detail.width
end event

event ue_open_pre;call super::ue_open_pre;try 
	dw_detdet.SetTransObject(sqlca)

	idw_1 = dw_master              			// asignar dw corriente
	
	dw_detdet.BorderStyle = StyleRaised!
	
	dw_detdet.of_protect()

	
	if gnvo_app.of_get_parametro("RRHH_MODIF_VALOR_CUOTA", "0" ) = "1" then
		dw_Detail.SetTabOrder ( "mont_cuota", 0 ) 
		
	else
		dw_Detail.SetTabOrder ( "mont_cuota", 80 ) 
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al Recuperar datos ventana de Cuenta Corriente")
	
finally
	/*statementBlock*/
	
end try



end event

event ue_update;//override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_cod_trabajador 
Long ll_row

ls_crlf = char(13) + char(10)
dw_detail.AcceptText()
dw_detdet.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detdet.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_detdet.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detdet.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle del detalle - detdet", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detdet.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;

	dw_detdet.ii_update = 0
	
	dw_detdet.il_totdel = 0
	
	dw_detdet.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	IF dw_master.GetRow() = 0 THEN Return 
	
	ls_cod_trabajador = dw_master.object.cod_trabajador[dw_master.GetRow()]
	
	ll_row = dw_detail.GetRow()
	dw_detail.Retrieve(ls_cod_trabajador)
	dw_detail.SetFocus()
	
	if dw_detail.RowCount( ) < ll_row then
		ll_row = dw_detail.RowCount()
	end if
	
	dw_detail.setRow( ll_row )
	dw_detail.SCrollToRow( ll_row )
	dw_detail.selectRow( 0, false)
	dw_detail.selectRow( ll_row, true)
	dw_detail.event ue_output( ll_row )
	
	
END IF

end event

event ue_dw_share;// Override

//IF ii_lec_mst = 1 THEN dw_master.Retrieve()



if dw_master.rowcount( ) > 0 then
	dw_master.scrolltorow( 1 )
	dw_master.setrow( 1 )
	dw_master.selectrow( 1, true )
end if

long ll_fila

end event

event ue_open_pos;//Override

end event

event ue_modify;//Overrriding
str_parametros lstr_param
Long				ll_row

if idw_1 = dw_detail then
	ll_row = dw_detail.getRow()
	
	if ll_row < 1 then
		messagebox("Error", 'No hay ningun registro seleccionado en el detalle',StopSign! )
		return
	end if
	
	lstr_param.string1 	= dw_detail.object.cod_trabajador 	[ll_row]
	lstr_param.string2 	= dw_detail.object.tipo_doc 			[ll_row]
	lstr_param.string3 	= dw_detail.object.nro_doc 			[ll_row]
	lstr_param.s_action 	= 'edit'
	
	OpenWithParm(w_rh101_ctacte_registro_popup, lstr_param)
	
	dw_detail.retrieve(lstr_param.string1)
	
	if dw_detail.RowCount() > ll_row then
		dw_detail.il_row = ll_row
		dw_detail.ScrollToRow(ll_row)
		dw_detail.setRow(ll_row)
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(ll_row, true)
		dw_detail.event ue_output(ll_row)
	end if

else
	idw_1.of_protect()
end if


end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh101_ctacte_registro
integer x = 0
integer y = 188
integer width = 1605
integer height = 2040
string dataobject = "d_lista_trabajador_ctacte_tbl"
end type

event dw_master::constructor;call super::constructor;//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear
is_dwform = 'tabular'
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;dw_detail.reset()
dw_detdet.reset()

if currentrow < 1 then return

if dw_detail.retrieve(this.object.cod_trabajador[currentrow]) > 1 then
	dw_detail.setrow( 1 )
	dw_detail.scrolltorow( 1 )
	dw_detail.selectrow( 1, true )
end if
end event

event dw_master::ue_delete;// Override

MessageBox('Aviso','Registro no se puede eliminar')

Return 1
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh101_ctacte_registro
integer x = 1623
integer y = 272
integer width = 4009
integer height = 960
string dataobject = "d_abc_ctacte_trabaj_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3

ii_rk[1] = 1 	      // columnas que recibimos del master
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::ue_insert;//ovreride
str_parametros	lstr_param

if dw_master.getrow( ) < 1 then
	messagebox(parent.title, 'No hay ningún Trabajador Seleccionado' )
	return -1
end if

lstr_param.string1 = dw_master.object.cod_trabajador [dw_master.getRow()]
lstr_param.s_action = 'new'

OpenWithParm(w_rh101_ctacte_registro_popup, lstr_param)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return -1

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return -1

this.retrieve(lstr_param.string1)
	
if this.RowCount() > 0 then
	this.il_row = 1
	this.ScrollToRow(1)
	this.setRow(1)
	this.SelectRow(0, false)
	this.SelectRow(1, false)
	this.event ue_output(1)
end if


end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::ue_output;call super::ue_output;string ls_cod_trabajador, ls_tipo_doc, ls_nro_doc

dw_detdet.reset()


if al_row < 1 then return

ls_cod_trabajador = this.object.cod_trabajador	[al_row]
ls_tipo_doc 		= this.object.tipo_doc			[al_row]
ls_nro_doc 			= this.object.nro_doc			[al_row]

if dw_detdet.retrieve(ls_cod_trabajador, ls_tipo_doc, ls_nro_doc) > 1 then
	dw_detdet.setrow( 1 )
	dw_detdet.scrolltorow( 1 )
	dw_detdet.selectrow( 1, true )
end if
end event

event dw_detail::doubleclicked;call super::doubleclicked;if row > 0 then
	if is_flag_modificar = '1' then
		parent.event ue_modify()
	end if
end if
end event

type dw_detdet from u_dw_abc within w_rh101_ctacte_registro
integer x = 1623
integer y = 1316
integer width = 4009
integer height = 620
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_ctacte_detalle_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row_detail 

ll_row_detail = dw_detail.GetRow()

IF ll_row_detail < 1 THEN Return

THIS.object.cod_trabajador	[al_row] = dw_detail.object.cod_trabajador	[ll_row_detail]
THIS.object.tipo_doc			[al_row] = dw_detail.object.tipo_doc			[ll_row_detail]
THIS.object.nro_doc			[al_row] = dw_detail.object.nro_doc				[ll_row_detail]
THIS.object.flag_digitado	[al_row] = '1'
THIS.object.flag_estado		[al_row] = '2' //(Descuento manual)
THIS.object.observaciones	[al_row] = 'Ingreso manual. No esta registrado en tablas de planillas' 
THIS.object.flag_proceso	[al_row] = 'O'
THIS.object.cod_usr			[al_row] = gs_user
this.object.nro_item			[al_row] = of_nro_item(this)
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;// OVERRIDE

if dw_detail.getrow( ) < 1 then
	messagebox(parent.title, 'No hay ningun documento de cuenta corriente seleccionado seleccionado')
	return -1
end if
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

event ue_delete;// Override

Long ll_count, ll_row = 1
String ls_cod_trabajador, ls_tipo_doc, ls_nro_doc, ls_flag_estado
Date ld_fec_dscto

ls_cod_trabajador = dw_detdet.object.cod_trabajador[dw_detdet.GetRow()]
ls_tipo_doc = dw_detdet.object.tipo_doc[dw_detdet.GetRow()]
ls_nro_doc = dw_detdet.object.nro_doc[dw_detdet.GetRow()]
ld_fec_dscto = DATE(dw_detdet.object.fec_dscto[dw_detdet.GetRow()])
ls_flag_estado = dw_detdet.object.flag_estado[dw_detdet.GetRow()]

SELECT count(*) 
  INTO :ll_count
  FROM calculo c 
 WHERE c.cod_trabajador = :ls_cod_trabajador 
   AND c.tipo_doc_cc = :ls_tipo_doc 
   AND c.nro_doc_cc = :ls_nro_doc 
	AND TRUNC(c.fec_proceso) = :ld_fec_dscto ;
  
IF (ll_count > 0 OR ls_flag_estado<>'0') THEN
	MessageBox('Aviso','Registro no se puede eliminar. Coordinar con Sistemas')
	this.Retrieve(ls_cod_trabajador, ls_tipo_doc, ls_nro_doc)
	return 1	
END IF 

///////////
//long ll_row = 1

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row

end event

event itemchanged;call super::itemchanged;This.Object.cod_usr[row] = gs_user 
ii_update = 1
end event

type cb_3 from commandbutton within w_rh101_ctacte_registro
integer x = 187
integer y = 72
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

type em_descripcion from editmask within w_rh101_ctacte_registro
integer x = 288
integer y = 72
integer width = 718
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Todos"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh101_ctacte_registro
integer x = 50
integer y = 72
integer width = 133
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_origen, ls_desc

if this.text = '%' then
	em_descripcion.text = 'Todos'
else
	ls_origen = this.text
	
	SELECT nombre 
		into :ls_desc
	from origen
	where cod_origen = :ls_origen
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		this.text = ''
		em_descripcion.text = ''
		MessageBox('Error', 'El origen ' + ls_origen + ' ingresado no existe o no esta activo, por favor verifique!')
		this.setFocus()
		return
	end if
	
	em_descripcion.text = ls_desc
	  
		  
end if
end event

type em_desc_tipo from editmask within w_rh101_ctacte_registro
integer x = 1435
integer y = 72
integer width = 667
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Todos"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh101_ctacte_registro
integer x = 1125
integer y = 72
integer width = 206
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_codigo, ls_desc, ls_origen

if this.text = '%' then
	em_desc_tipo.text = 'Todos'
else
	
	if trim(em_origen.text) = '' then
		MessageBox('Error', 'Debe Seleccionar origen / sucursal', StopSign!)
		return
	end if
	
	ls_origen 	= trim(em_origen.text) + '%'
	ls_codigo	= this.text
	
	select tt.DESC_TIPO_TRA 
		into :ls_desc
	FROM 	tipo_trabajador tt,
			maestro			  m, 
			tipo_trabajador_user ttu 
	WHERE m.tipo_Trabajador = tt.tipo_trabajador 
	  and tt.tipo_trabajador = ttu.tipo_trabajador 
	  and m.cod_origen like :ls_origen
	  and tt.tipo_trabajador = :ls_codigo
	  and ttu.cod_usr = :gs_user
	  and m.flag_estado = '1'
	  and tt.FLAG_ESTADO = '1';
	
	if SQLCA.SQLCode = 100 then
		em_tipo.text = ''
		em_desc_tipo.text = ''
		MessageBox('Error', 'El tipo de trabajador ' + ls_codigo &
							+ " no existe, no esta activo, no tiene acceso o no tiene personal " &
							+ "activo, por favor verifique!", StopSign!)
		
	end if
	
	em_desc_tipo.text = ls_desc
	
end if

end event

type cb_2 from commandbutton within w_rh101_ctacte_registro
integer x = 1339
integer y = 72
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen

if trim(em_origen.text) = '' then
	MessageBox('Error', 'Debe Seleccionar origen / sucursal', StopSign!)
	return
end if

ls_origen = trim(em_origen.text) + '%'

ls_sql = "SELECT distinct tt.TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "tt.DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador tt," &
		  + "     maestro			  m, " &
		  + "		 tipo_trabajador_user ttu " &
		  + "WHERE m.tipo_Trabajador = tt.tipo_trabajador " &
		  + "  and tt.tipo_trabajador = ttu.tipo_trabajador " &
		  + "  and m.cod_origen like '" + ls_origen + "'" &
		  + "  and ttu.cod_usr = '" + gs_user + "'" &
		  + "  and m.flag_estado = '1'" &
		  + "  and tt.FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo.text = ls_codigo
	em_desc_tipo.text = ls_data
end if

end event

type cb_1 from commandbutton within w_rh101_ctacte_registro
integer x = 3639
integer y = 60
integer width = 247
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String ls_origen, ls_tipo, ls_codigo, ls_mensaje

ls_origen = em_origen.text
ls_tipo = em_tipo.text 
ls_codigo = sle_codigo.text

//Actualizo la cuenta corriente
update cnta_crrte cc
  set cc.sldo_prestamo = cc.mont_original - (select NVL(sum(ccd.imp_dscto),0)
															  from cnta_crrte_detalle ccd
															 where ccd.cod_trabajador = cc.cod_trabajador
																and ccd.tipo_doc       = cc.tipo_doc
																and ccd.nro_doc        = cc.nro_doc)
 where cc.sldo_prestamo <> cc.mont_original - (select NVL(sum(ccd.imp_dscto),0)
															  from cnta_crrte_detalle ccd
															 where ccd.cod_trabajador = cc.cod_trabajador
																and ccd.tipo_doc       = cc.tipo_doc
																and ccd.nro_doc        = cc.nro_doc);
  
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'Ha ocurrido un error al actualizar la cuenta corriente. Mensaje: ' + ls_mensaje, StopSign!)
else
	commit;  
end if

Parent.Event ue_retrieve(ls_origen, ls_tipo, ls_codigo)
end event

type sle_codigo from singlelineedit within w_rh101_ctacte_registro
integer x = 2240
integer y = 72
integer width = 279
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_codigo, ls_Desc, ls_origen, ls_tipo_trabaj

if this.text = '%' then
	sle_nombre.text = 'Todos'
else
	if trim(em_origen.text) = '' then
		MessageBox('Error', 'Debe Seleccionar origen / sucursal', StopSign!)
		em_origen.setFocus()
		return
	end if
	
	if trim(em_tipo.text) = '' then
		MessageBox('Error', 'Debe Seleccionar un tipo de trabajador', StopSign!)
		em_tipo.setFocus()
		return
	end if
	
	ls_origen = trim(em_origen.text) + '%'
	ls_tipo_trabaj = trim(em_tipo.text) + '%'
	ls_codigo = trim(this.text)
	
	SELECT m.nom_trabajador 
		into :ls_desc
	from VW_MAESTRO_CNTA_CTE m 
	WHERE m.tipo_Trabajador like :ls_tipo_trabaj
	  and m.cod_origen like :ls_origen
	  and m.cod_trabajador = :ls_codigo;
	
	if SQLCA.SQLCode = 100 then
		this.text = ''
		sle_nombre.text = ''
		MessageBox('Error', 'Codigo de trabajador ' + ls_codigo + ' no existe, no esta activo o no corresponde a los datos ingresados, por favor verifique!', StopSign!)
		return
	end if
	
	sle_nombre.text = ls_desc
end if

end event

type sle_nombre from singlelineedit within w_rh101_ctacte_registro
integer x = 2647
integer y = 72
integer width = 896
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_rh101_ctacte_registro
integer x = 2542
integer y = 72
integer width = 87
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj

if trim(em_origen.text) = '' then
	MessageBox('Error', 'Debe Seleccionar origen / sucursal', StopSign!)
	em_origen.setFocus()
	return
end if

if trim(em_tipo.text) = '' then
	MessageBox('Error', 'Debe Seleccionar un tipo de trabajador', StopSign!)
	em_tipo.setFocus()
	return
end if

ls_origen = trim(em_origen.text) + '%'
ls_tipo_trabaj = trim(em_tipo.text) + '%'

ls_sql = "SELECT distinct m.cod_trabajador AS codigo_trabajador, " &
		  + "m.nom_trabajador AS nombre_trabajador " &
		  + "FROM VW_MAESTRO_CNTA_CTE m " &
		  + "WHERE m.tipo_Trabajador like '" + ls_tipo_trabaj + "'" &
		  + "  and m.cod_origen like '" + ls_origen + "'"  

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
	sle_codigo.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

type st_1 from statictext within w_rh101_ctacte_registro
integer x = 1623
integer y = 188
integer width = 4009
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Listado de Cuenta Corriente"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh101_ctacte_registro
integer x = 1623
integer y = 1232
integer width = 4009
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Aplicaciones de Cuenta Corriente"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh101_ctacte_registro
integer y = 4
integer width = 1056
integer height = 172
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh101_ctacte_registro
integer x = 1079
integer y = 8
integer width = 1056
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

type gb_4 from groupbox within w_rh101_ctacte_registro
integer x = 2199
integer width = 1385
integer height = 180
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador"
end type

