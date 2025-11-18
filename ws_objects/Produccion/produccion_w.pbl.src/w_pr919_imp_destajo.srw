$PBExportHeader$w_pr919_imp_destajo.srw
forward
global type w_pr919_imp_destajo from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_pr919_imp_destajo
end type
type cb_procesar from commandbutton within w_pr919_imp_destajo
end type
type hpb_progreso from hprogressbar within w_pr919_imp_destajo
end type
type st_texto from statictext within w_pr919_imp_destajo
end type
type uo_rango from ou_rango_fechas within w_pr919_imp_destajo
end type
type st_1 from statictext within w_pr919_imp_destajo
end type
type cb_2 from commandbutton within w_pr919_imp_destajo
end type
end forward

global type w_pr919_imp_destajo from w_abc_master_smpl
integer width = 3593
integer height = 2172
string title = "[PR919] Importar Destajo Masivo por Excel"
string menuname = "m_smpl"
event type integer ue_listar_data ( string as_file )
cb_1 cb_1
cb_procesar cb_procesar
hpb_progreso hpb_progreso
st_texto st_texto
uo_rango uo_rango
st_1 st_1
cb_2 cb_2
end type
global w_pr919_imp_destajo w_pr919_imp_destajo

type variables
u_ds_base ids_valorizar
integer ii_year
end variables

event type integer ue_listar_data(string as_file);oleobject excel
integer	li_i
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila2, &
			ll_fila, ll_year, ll_mes

boolean 	lb_cek
String 	ls_cellValue , ls_nomcol, ls_codigo

String	ls_nro_registro, ls_fecha_Destajo, ls_desc_especie, ls_desc_proceso, ls_desc_labor, &
			ls_desc_tarea, ls_cod_origen, &
			ls_desc_presentacion, ls_tipo_doc_ident, ls_nro_doc_ident, ls_und, ls_hora_inicio, &
			ls_hora_fin, ls_cod_turno
			
decimal	ldc_cant_destajo

Date		ld_fecha_destajo

dateTime	ldt_fecha_hora_inicio, ldt_fecha_hora_fin, ldt_fecha_creacion

oleobject  lole_workbook, lole_worksheet

try 
	ldt_fecha_creacion = gnvo_app.of_fecha_actual()
	
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		messagebox('Excel','El archivo ' + as_file + ' no existe, por favor verfique!') 
		destroy excel
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o cnfigurado el MS.Excel, por favor verifique!',exclamation!)
		destroy excel
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook = excel.workbooks(1)
	lb_cek = lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   = lole_worksheet.UsedRange.Rows.Count
	dw_master.reset( )
	
	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_nro_registro		= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_cod_origen			= String(lole_worksheet.cells(ll_fila1,2).value)
		ls_fecha_destajo		= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_desc_especie		= String(lole_worksheet.cells(ll_fila1,5).value) 
		ls_desc_presentacion	= String(lole_worksheet.cells(ll_fila1,7).value) 
		ls_desc_tarea			= String(lole_worksheet.cells(ll_fila1,9).value) 
		ls_desc_proceso		= String(lole_worksheet.cells(ll_fila1,11).value) 
		ls_desc_labor			= String(lole_worksheet.cells(ll_fila1,13).value) 
		ls_tipo_doc_ident		= String(lole_worksheet.cells(ll_fila1,14).value) 
		ls_nro_doc_ident		= String(lole_worksheet.cells(ll_fila1,15).value) 
		ls_cod_turno			= String(lole_worksheet.cells(ll_fila1,16).value) 
		ldc_cant_destajo		= Dec(	lole_worksheet.cells(ll_fila1,17).value) 
		ls_und					= String(lole_worksheet.cells(ll_fila1,18).value) 
		ls_hora_inicio			= String(lole_worksheet.cells(ll_fila1,19).value) 
		ls_hora_fin				= String(lole_worksheet.cells(ll_fila1,20).value) 
		
		// Convertir fecha string a Date con validación
		if IsDate(ls_fecha_destajo) then
			 ld_fecha_destajo = Date(ls_fecha_destajo)
			 
			 // Convertir hora string a Time y combinar con la fecha
			 if IsTime(ls_hora_inicio) then
				  ldt_fecha_hora_inicio = DateTime(ld_fecha_destajo, Time(ls_hora_inicio))
			 else
				  messageBox('Error', 'En el registro ' + ls_nro_registro + ' no tiene un formato de hora Inicio correcto, por favor corrija!')
				  return -1
			 end if
			 
			 // Convertir hora string a Time y combinar con la fecha
			 if IsTime(ls_hora_fin) then
				  ldt_fecha_hora_fin = DateTime(ld_fecha_destajo, Time(ls_hora_fin))
			 else
				  messageBox('Error', 'En el registro ' + ls_nro_registro + ' no tiene un formato de hora Fin correcto, por favor corrija!')
				  return -1
			 end if

		else
			messageBox('Error', 'En el registro ' + ls_nro_registro + ' no tiene un formato de fecha de destajo correcto, por favor corrija!')
			return -1
		end if
		
		
		
		ll_fila = dw_master.event ue_insert()
		
		if ll_fila > 0 then
			dw_master.object.cod_origen			[ll_fila] = ls_cod_origen
			dw_master.object.create_by				[ll_fila] = gs_user
			dw_master.object.fecha_creacion		[ll_fila] = ldt_fecha_creacion
			
			dw_master.object.nro_registro			[ll_fila] = Long(ls_nro_registro)
			dw_master.object.fecha_destajo		[ll_fila] = ld_fecha_destajo
			dw_master.object.desc_especie			[ll_fila] = ls_desc_especie
			dw_master.object.desc_proceso			[ll_fila] = ls_desc_proceso
			dw_master.object.desc_labor			[ll_fila] = ls_desc_labor
			dw_master.object.desc_tarea			[ll_fila] = ls_desc_tarea
			dw_master.object.desc_presentacion	[ll_fila] = ls_desc_presentacion
			
			dw_master.object.tipo_doc_ident		[ll_fila] = ls_tipo_doc_ident
			dw_master.object.nro_doc_ident		[ll_fila] = ls_nro_doc_ident
			dw_master.object.cod_turno				[ll_fila] = ls_cod_turno
			dw_master.object.cant_destajo			[ll_fila] = ldc_cant_destajo
			dw_master.object.und						[ll_fila] = ls_und
			
			dw_master.object.hora_inicio			[ll_fila] = ldt_fecha_hora_inicio
			dw_master.object.hora_fin				[ll_fila] = ldt_fecha_hora_fin
			
		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		yield()		
	next
	
	if dw_master.RowCount() > 0 then
		cb_procesar.enabled = true
	else
		cb_procesar.enabled = false
	end if
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique y luego proceselo!", "")
	
	RETURN 1
	
catch ( Exception ex )
	cb_procesar.enabled = false
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
end try

end event

on w_pr919_imp_destajo.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_1=create cb_1
this.cb_procesar=create cb_procesar
this.hpb_progreso=create hpb_progreso
this.st_texto=create st_texto
this.uo_rango=create uo_rango
this.st_1=create st_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_procesar
this.Control[iCurrent+3]=this.hpb_progreso
this.Control[iCurrent+4]=this.st_texto
this.Control[iCurrent+5]=this.uo_rango
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_2
end on

on w_pr919_imp_destajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_procesar)
destroy(this.hpb_progreso)
destroy(this.st_texto)
destroy(this.uo_rango)
destroy(this.st_1)
destroy(this.cb_2)
end on

event ue_update;//Override
Boolean 	lbo_ok = TRUE
String	ls_msg, ls_crlf

DateTime	ldt_fecha_creacion
string	ls_create_by, ls_cod_origen

if dw_master.RowCount( ) = 0 then return

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

ls_cod_origen			= dw_master.object.cod_origen	[1]
ls_create_by 			= dw_master.object.create_by 	[1]
ldt_fecha_creacion	= DateTime(dw_master.object.fecha_creacion [1])


if MessageBox('Aviso', '¿Desea Procesar la información?', Information!, Yesno!, 1) = 0 then
	return 
end if


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
	
	dw_master.Retrieve(gnvo_app.is_null, gnvo_app.is_null, ls_create_by, &
							 ldt_fecha_Creacion, ls_cod_origen)
	
END IF



end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;ids_valorizar = create u_ds_base
ids_valorizar.dataobject = "d_abc_valor_mensual_pptt_tbl"
ids_valorizar.settransobject(SQLCA)

ii_lec_mst = 0
end event

event close;call super::close;destroy ids_valorizar
end event

event ue_update_request;//Override
end event

event closequery;//Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr919_imp_destajo
event ue_display ( string as_columna,  long al_row )
integer y = 200
integer width = 2958
integer height = 1448
string dataobject = "d_abc_tg_pesos_proceso_tbl"
end type

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

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		ls_sql = "select und as codigo, desc_unidad as descripcion from unidad"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		this.ii_update = 1
		
	case 'grp_medicion'
		ls_sql = "select grp_medicion as codigo, descripcion as nombre from tg_med_act_atributo_grp"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		this.ii_update = 1
end choose
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		select und, desc_unidad
			into :ls_return1, :ls_return2
			from unidad
			where und = :data;
			
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		
		return 2
		
	case 'grp_medicion'
		select grp_medicion, descripcion 
			into :ls_return1, :ls_return2
			from tg_med_act_atributo_grp
			where grp_medicion = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		
		return 2
		
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

type cb_1 from commandbutton within w_pr919_imp_destajo
integer x = 37
integer y = 20
integer width = 475
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar de XLS"
end type

event clicked;Integer	li_value
string 	ls_docname, ls_named, ls_codigo, ls_filtro, ls_mensaje

cb_procesar.enabled = false
li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.xls*),*.xls*" )

if li_value = 1 then
	IF parent.event ue_listar_data(ls_docname) = -1 THEN 
		RETURN -1
	END IF
end if




end event

type cb_procesar from commandbutton within w_pr919_imp_destajo
integer x = 517
integer y = 20
integer width = 475
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;parent.event ue_update()
end event

type hpb_progreso from hprogressbar within w_pr919_imp_destajo
integer x = 1029
integer y = 8
integer width = 1591
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_texto from statictext within w_pr919_imp_destajo
integer x = 2670
integer width = 736
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_rango from ou_rango_fechas within w_pr919_imp_destajo
integer x = 1531
integer y = 88
integer taborder = 30
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type st_1 from statictext within w_pr919_imp_destajo
integer x = 1047
integer y = 100
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_pr919_imp_destajo
integer x = 2825
integer y = 76
integer width = 475
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar Datos"
end type

event clicked;Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

//REcuperar los datos
dw_master.retrieve(ld_fecha1, ld_fecha2, gnvo_app.is_null, gnvo_app.is_null, gnvo_app.is_null)


end event

