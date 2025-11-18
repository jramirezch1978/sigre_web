$PBExportHeader$w_rh201_upload_gan_dscto_variable.srw
forward
global type w_rh201_upload_gan_dscto_variable from w_abc_master
end type
type uo_fecha from u_ingreso_fecha within w_rh201_upload_gan_dscto_variable
end type
type st_1 from statictext within w_rh201_upload_gan_dscto_variable
end type
type sle_desc_concepto from singlelineedit within w_rh201_upload_gan_dscto_variable
end type
type cb_buscar from commandbutton within w_rh201_upload_gan_dscto_variable
end type
type sle_concepto from n_cst_textbox within w_rh201_upload_gan_dscto_variable
end type
type st_texto from statictext within w_rh201_upload_gan_dscto_variable
end type
type cb_importar from commandbutton within w_rh201_upload_gan_dscto_variable
end type
type hpb_progreso from hprogressbar within w_rh201_upload_gan_dscto_variable
end type
type cb_duplicar from commandbutton within w_rh201_upload_gan_dscto_variable
end type
type st_rows from statictext within w_rh201_upload_gan_dscto_variable
end type
type gb_1 from groupbox within w_rh201_upload_gan_dscto_variable
end type
end forward

global type w_rh201_upload_gan_dscto_variable from w_abc_master
integer width = 3899
integer height = 1940
string title = "[RH201] Ingreso Masivo de Ganancias Variables"
string menuname = "m_master_simple"
event type integer ue_listar_data ( string as_file )
uo_fecha uo_fecha
st_1 st_1
sle_desc_concepto sle_desc_concepto
cb_buscar cb_buscar
sle_concepto sle_concepto
st_texto st_texto
cb_importar cb_importar
hpb_progreso hpb_progreso
cb_duplicar cb_duplicar
st_rows st_rows
gb_1 gb_1
end type
global w_rh201_upload_gan_dscto_variable w_rh201_upload_gan_dscto_variable

type variables
string is_codigo
end variables

event type integer ue_listar_data(string as_file);oleobject excel
integer	li_i, li_count
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila2, &
			ll_fila, ll_year, ll_mes
double 	dbl_precio
boolean 	lb_cek

//Datos para importar
String 	ls_cod_trabajador, ls_fecha, ls_concepto, ls_tipo_doc, ls_nro_doc, ls_cencos, ls_labor, &
			ls_proveedor, ls_tipo_planilla, ls_mensaje
Date		ld_fecha
Decimal	ldc_cant_labor, ldc_nro_dias, ldc_nro_horas, ldc_nro_cuotas, ldc_importe

oleobject  lole_workbook, lole_worksheet

try 
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		Messagebox('Error','Archivo ' + as_file + ' del archivo no existe, por favor verifique!', Exclamation!) 
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o configurado el MS.Excel, por favor verifique!',exclamation!)
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if ll_max_rows = 0 then
		messagebox('Error','No tiene registros para importar, por favor verifique!',exclamation!)
		return -1
	end if
	
	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_cod_trabajador	= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_fecha				= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_concepto			= String(lole_worksheet.cells(ll_fila1,4).value)
		ls_tipo_doc			= String(lole_worksheet.cells(ll_fila1,5).value)  
		ls_nro_doc			= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_cencos			= String(lole_worksheet.cells(ll_fila1,7).value) 
		ls_labor				= String(lole_worksheet.cells(ll_fila1,8).value) 
		ldc_cant_labor		= Dec(lole_worksheet.cells(ll_fila1,9).value) 
		ldc_nro_dias		= Dec(lole_worksheet.cells(ll_fila1,10).value) 
		ldc_nro_horas		= Dec(lole_worksheet.cells(ll_fila1,11).value) 
		ldc_nro_cuotas		= Dec(lole_worksheet.cells(ll_fila1,12).value) 
		ls_proveedor		= String(lole_worksheet.cells(ll_fila1,13).value) 
		ldc_importe			= Dec(lole_worksheet.cells(ll_fila1,14).value) 
		ls_tipo_planilla	= String(lole_worksheet.cells(ll_fila1,15).value) 
		
		//Valido si existe el codigo del trabajador
		select count(*)
		  into :li_count
		  from maestro m
		 where m.cod_trabajador = :ls_cod_trabajador;
		
		if li_count = 0 then
			ROLLBACK;
			MessageBox('Error', 'Ha sucedido un error al insertar el registro ' &
					+ string(ll_fila1) + '. No existe el codigo de Trabajador ' + ls_cod_trabajador, StopSign!)
			return -1
		end if
		
		//Valido si existe el concepto de planilla
		select count(*)
		  into :li_count
		  from concepto co
		 where co.concep = :ls_concepto;
		
		if li_count = 0 then
			ROLLBACK;
			MessageBox('Error', 'Ha sucedido un error al insertar el registro ' &
					+ string(ll_fila1) + '. No existe el concepto de Planilla ' + ls_concepto, StopSign!)
			return -1
		end if
		
		ld_fecha = date(ls_fecha)
		
		select count(*)
			into :li_count
		from GAN_DESCT_VARIABLE gv
		where gv.cod_trabajador = :ls_cod_trabajador
		  and gv.concep			= :ls_concepto
		  and gv.FEC_MOVIM		= :ld_fecha
		  and gv.tipo_planilla	= :ls_tipo_planilla;
		
		if li_count = 0 then
			insert into GAN_DESCT_VARIABLE(
				COD_TRABAJADOR, FEC_MOVIM, CONCEP, NRO_DOC, IMP_VAR, CENCOS, 
				COD_LABOR, COD_USR,
				PROVEEDOR, TIPO_DOC, CANT_LABOR, NRO_DIAS, NRO_HORAS, 
				NRO_CUOTAS, TIPO_PLANILLA)
			values(
				:ls_cod_trabajador, :ld_fecha, :ls_concepto, :ls_nro_doc, :ldc_importe, :ls_cencos, 
				:ls_labor, :gs_user,
				:ls_proveedor, :ls_tipo_doc, :ldc_cant_labor, :ldc_nro_dias, :ldc_nro_horas, 
				:ldc_nro_cuotas, :ls_tipo_planilla);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error', 'Ha sucedido un error al insertar el registro ' &
					+ string(ll_fila1) + '. Mensaje de Error: ' + ls_mensaje, StopSign!)
				return -1
			end if
			
		else
			
			update GAN_DESCT_VARIABLE gv
				set 	gv.nro_doc 		= :ls_nro_doc,
						gv.tipo_doc		= :ls_tipo_doc,
						gv.imp_var		= :ldc_importe,
						gv.cencos		= :ls_cencos,
						gv.cod_labor	= :ls_labor,
						gv.proveedor	= :ls_proveedor,
						gv.cant_labor	= :ldc_cant_labor,
						gv.nro_dias		= :ldc_nro_dias,
						gv.nro_horas	= :ldc_nro_horas,
						gv.nro_cuotas	= :ldc_nro_cuotas
			where gv.cod_trabajador = :ls_cod_trabajador
			  and gv.concep			= :ls_concepto
			  and gv.FEC_MOVIM		= :ld_fecha
			  and gv.tipo_planilla	= :ls_tipo_planilla;
			
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error', 'Ha sucedido un error al actualizar los datos del registro ' &
					+ string(ll_fila1) + '. Mensaje de Error: ' + ls_mensaje, StopSign!)
				return -1
			end if

		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		
		yield()		
	next
	
	commit;
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor consulte los datos!", "")
	
	RETURN 1
	
catch ( Exception ex )
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

on w_rh201_upload_gan_dscto_variable.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.sle_desc_concepto=create sle_desc_concepto
this.cb_buscar=create cb_buscar
this.sle_concepto=create sle_concepto
this.st_texto=create st_texto
this.cb_importar=create cb_importar
this.hpb_progreso=create hpb_progreso
this.cb_duplicar=create cb_duplicar
this.st_rows=create st_rows
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_desc_concepto
this.Control[iCurrent+4]=this.cb_buscar
this.Control[iCurrent+5]=this.sle_concepto
this.Control[iCurrent+6]=this.st_texto
this.Control[iCurrent+7]=this.cb_importar
this.Control[iCurrent+8]=this.hpb_progreso
this.Control[iCurrent+9]=this.cb_duplicar
this.Control[iCurrent+10]=this.st_rows
this.Control[iCurrent+11]=this.gb_1
end on

on w_rh201_upload_gan_dscto_variable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.sle_desc_concepto)
destroy(this.cb_buscar)
destroy(this.sle_concepto)
destroy(this.st_texto)
destroy(this.cb_importar)
destroy(this.hpb_progreso)
destroy(this.cb_duplicar)
destroy(this.st_rows)
destroy(this.gb_1)
end on

event ue_modify;call super::ue_modify;int li_protect
li_protect = integer(dw_master.Object.cod_trabajador.Protect)
if li_protect = 0 then
	dw_master.Object.cod_trabajador.Protect = 1
end if 

end event

event resize;date ld_hoy

ld_hoy = Date(gnvo_app.of_fecha_actual())

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

uo_Fecha.of_set_fecha( ld_hoy )
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

event ue_insert;//Override

Long  ll_row

String ls_concepto

ls_concepto = trim(sle_concepto.text)

if trim(ls_concepto) = '' then
	MessageBox('Error', 'Debe indicar un concepto de planilla para insertar un registro', Exclamation!)
	sle_concepto.setfocus( )
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_master`dw_master within w_rh201_upload_gan_dscto_variable
integer y = 316
integer width = 3200
integer height = 1184
string dataobject = "d_abc_gan_dsctos_variable_tbl"
end type

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String 	ls_concepto
date		ld_fecha

ls_concepto = trim(sle_concepto.text)

if ls_concepto = '' then
	return
end if

ld_fecha = uo_fecha.of_get_fecha( )

this.object.concep			[al_row] = ls_concepto
this.object.fec_movim		[al_row] = ld_fecha
this.object.cod_usr			[al_row] = gs_user
this.object.nro_dias			[al_row] = 0.00
this.object.nro_horas		[al_row] = 0.00
this.object.nro_cuotas		[al_row] = 1
this.object.tipo_planilla	[al_row] = 'N'


end event

event dw_master::clicked;call super::clicked;DataWindowChild	dwc_dddw								

CHOOSE CASE dw_master.GetColumnName()
	CASE 'concep'
			string DWfilter2
			DWfilter2 = 'Mid(concep,1,1) = "1" or Mid(concep,1,1) = "2"'
			dw_master.GetChild ("concep", dwc_dddw)
			dwc_dddw.SetTransObject (sqlca)
			dwc_dddw.Retrieve ()
			dwc_dddw.SetFilter(DWfilter2)
			dwc_dddw.Filter( )
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc1, ls_desc2
Long 		ll_count
decimal ldc_imp_var

dw_master.Accepttext()
Accepttext()

choose case dwo.name
	case 'imp_var'
		ldc_imp_var = dec(dw_master.GetText())
		If ldc_imp_var < 0 then
			Messagebox("Sistema de Validacion","El IMPORTE debe ser "+&
			           "MAYOR que CERO")
			dw_master.SetColumn("imp_var")
			dw_master.SetFocus()
			return 1
		End if 
		
	CASE 'cod_labor'
		
		// Verifica que codigo ingresado exista			
		Select desc_labor
	     into :ls_desc1
		  from labor
		 Where cod_labor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Labor no existe o no se encuentra activo, por favor verifique")
			this.object.cod_labor	[row] = gnvo_app.is_null
			this.object.desc_labor	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_labor		[row] = ls_desc1
		
	CASE 'concep'
		
		// Verifica que codigo ingresado exista			
		Select desc_concep
	     into :ls_desc1
		  from concepto
		 Where concep = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Concepto de Planilla ingresado no existe o no se encuentra activo, por favor verifique")
			this.object.concep		[row] = gnvo_app.is_null
			this.object.desc_concep	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_concep		[row] = ls_desc1

END CHOOSE
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF currentrow = 0 THEN RETURN

IF is_dwform = 'tabular' or is_dwform = 'grid' THEN
	Any 	la_id
	il_row = currentrow                    // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_labor"
		ls_sql = "SELECT cod_labro AS codigo_labor, " &
				  + "desc_labor AS descripcion_labor " &
				  + "FROM labor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_trabajador"
		ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
				 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
				 + "m.DNI as dni " &
				 + "from vw_pr_trabajador m " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cencos"
		ls_sql = "select cencos as centro_Costo, " &
				 + "cc.desc_cencos as descripcion_centro_costo " &
				 + "from centros_costo cc " &
				 + "where cc.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "proveedor"
		ls_sql = "select p.proveedor as proveedor, " &
				 + "p.nom_proveedor as razon_social, " &
				 + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni " &
				 + "from proveedor p " &
				 + "where p.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_doc"
		ls_sql = "select tipo_doc as tipo_doc, " &
				 + "desc_tipo_doc as descripcion_tipo_doc " &
				 + "from doc_tipo " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_doc	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
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

type uo_fecha from u_ingreso_fecha within w_rh201_upload_gan_dscto_variable
event destroy ( )
integer x = 46
integer y = 196
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Fecha:') // para seatear el titulo del boton
 of_set_fecha(date('31/12/9999')) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

end event

type st_1 from statictext within w_rh201_upload_gan_dscto_variable
integer x = 55
integer y = 100
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Concepto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_concepto from singlelineedit within w_rh201_upload_gan_dscto_variable
integer x = 608
integer y = 84
integer width = 1193
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_rh201_upload_gan_dscto_variable
integer x = 1824
integer y = 64
integer width = 329
integer height = 220
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String 	ls_concepto
Date		ld_fecha

ls_concepto = trim(sle_concepto.text)

if trim(ls_concepto) = '' then
	MessageBox('Error', 'Debe Especificar un concepto de planilla, por favor verifique!', Exclamation!)
	sle_concepto.setfocus( )
	return
end if

ld_fecha = uo_fecha.of_get_fecha( )

dw_master.retrieve(ls_concepto, ld_fecha)

if dw_master.Rowcount( ) = 0 then
	st_rows.text = 'No hay registros'
	cb_duplicar.enabled = false
else
	st_rows.text = String(dw_master.Rowcount( )) + ' registros devueltos'
	cb_duplicar.enabled = true
end if
end event

type sle_concepto from n_cst_textbox within w_rh201_upload_gan_dscto_variable
integer x = 320
integer y = 84
integer width = 288
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
end type

event modified;call super::modified;String 	ls_desc, ls_codigo

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Cuadrilla')
	return
end if

SELECT desc_concep 
	INTO :ls_desc
FROM concepto 
where concep = :ls_codigo 
  and flag_estado = '1';


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Concepto de planilla no existe o no esta activo, por favor verifique! ')
	return
end if

sle_desc_concepto.text = ls_desc
end event

event ue_dobleclick;call super::ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select concep as concepto, " &
		 + "desc_concep as descripcion_concepto " &
		 + "from concepto " &
		 + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_concepto.text 	= ls_data
end if

end event

type st_texto from statictext within w_rh201_upload_gan_dscto_variable
integer x = 2619
integer y = 216
integer width = 1083
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_importar from commandbutton within w_rh201_upload_gan_dscto_variable
integer x = 3150
integer y = 44
integer width = 553
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar de Excel"
end type

event clicked;//Validacion

String 	ls_concepto, ls_docname, ls_named, ls_codigo, ls_filtro, ls_mensaje
Date		ld_fecha
integer	li_count, li_value


ls_concepto = trim(sle_concepto.text)

if trim(ls_concepto) = '' then
	MessageBox('Error', 'Debe Especificar un concepto de planilla, por favor verifique!', Exclamation!)
	sle_concepto.setfocus( )
	return
end if

//ld_fecha = uo_fecha.of_get_fecha( )
//
//select count(*)
//	into :li_count
//from gan



li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.XLS),*.XLS" )

IF parent.event dynamic ue_listar_data(ls_docname) = -1 THEN 
	RETURN -1
END IF
end event

type hpb_progreso from hprogressbar within w_rh201_upload_gan_dscto_variable
integer x = 2619
integer y = 144
integer width = 1083
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cb_duplicar from commandbutton within w_rh201_upload_gan_dscto_variable
integer x = 2162
integer y = 64
integer width = 329
integer height = 220
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Duplicar"
end type

event clicked;Date				ld_fecha
Long				ll_i, ll_item
String			ls_cod_trabajador, ls_nro_doc	, ls_Cencos, ls_Cod_labor, ls_proveedor, ls_tipo_doc, &
					ls_tipo_planilla, ls_nave, ls_mensaje, ls_Concepto
Decimal			ldc_cant_labor, ldc_nro_dias, ldc_nro_horas, ldc_nro_cuotas, ldc_imp_var
Str_parametros	lstr_param

ls_concepto = trim(sle_concepto.text)

if trim(ls_concepto) = '' then
	MessageBox('Error', 'Debe Especificar un concepto de planilla, por favor verifique!', Exclamation!)
	sle_concepto.setfocus( )
	return
end if

ld_fecha = uo_fecha.of_get_fecha( )

if dw_master.Rowcount( ) = 0 then
	MessageBox('Error', 'No hay registros para hacer la duplicacion, por favor verifique', StopSign!)
	return
end if

lstr_param.string1 	= ls_concepto
lstr_param.date1		= ld_fecha

OpenWithParm(w_abc_fecha_concepto, lstr_param)

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return

ls_concepto = lstr_param.string1
ld_fecha		= lstr_param.date1

for ll_i = 1 to dw_master.RowCount()
	ls_cod_trabajador = dw_master.object.cod_trabajador 	[ll_i]
	ls_nro_doc			= dw_master.object.nro_doc 			[ll_i]
	ls_Cencos			= dw_master.object.cencos	 			[ll_i]
	ls_Cod_labor		= dw_master.object.cod_labor 			[ll_i]
	ls_proveedor		= dw_master.object.proveedor 			[ll_i]
	ls_tipo_doc			= dw_master.object.tipo_doc 			[ll_i]
	ls_tipo_planilla	= dw_master.object.tipo_planilla		[ll_i]
	ls_nave				= dw_master.object.nave					[ll_i]
	
	ll_item				= Long(dw_master.object.item			[ll_i])
	ldc_cant_labor		= Dec(dw_master.object.cant_labor 	[ll_i])
	ldc_nro_dias		= Dec(dw_master.object.nro_dias		[ll_i])
	ldc_nro_horas		= Dec(dw_master.object.nro_horas		[ll_i])
	ldc_nro_cuotas		= Dec(dw_master.object.nro_cuotas	[ll_i])
	ldc_imp_var			= Dec(dw_master.object.imp_Var 		[ll_i])
	
	insert into gan_desct_variable(
       cod_trabajador, fec_movim, concep, nro_doc, imp_var, cencos, cod_labor, cod_usr, 
		 proveedor, tipo_doc, cant_labor, nro_dias, nro_horas, nro_cuotas, tipo_planilla, 
		 nave, item)
	values(
		:ls_cod_trabajador, :ld_fecha, :ls_concepto, :ls_nro_doc, :ldc_imp_Var, :ls_cencos, &
		:ls_cod_labor, :gs_user, :ls_proveedor, :ls_tipo_doc, :ldc_cant_labor, :ldc_nro_dias, &
		:ldc_nro_horas, :ldc_nro_cuotas, :ls_tipo_planilla, :ls_nave, :ll_item);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al insertar en tabla gan_desct_variable. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
		
		
next

commit;

end event

type st_rows from statictext within w_rh201_upload_gan_dscto_variable
integer x = 2610
integer y = 76
integer width = 539
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh201_upload_gan_dscto_variable
integer width = 3730
integer height = 304
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

