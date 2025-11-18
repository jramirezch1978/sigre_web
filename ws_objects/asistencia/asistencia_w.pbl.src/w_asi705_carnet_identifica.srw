$PBExportHeader$w_asi705_carnet_identifica.srw
forward
global type w_asi705_carnet_identifica from w_report_smpl
end type
type cb_1 from commandbutton within w_asi705_carnet_identifica
end type
type cb_2 from commandbutton within w_asi705_carnet_identifica
end type
type cb_3 from commandbutton within w_asi705_carnet_identifica
end type
type em_area from editmask within w_asi705_carnet_identifica
end type
type em_desc_area from editmask within w_asi705_carnet_identifica
end type
type em_seccion from editmask within w_asi705_carnet_identifica
end type
type em_desc_seccion from editmask within w_asi705_carnet_identifica
end type
type cbx_todos from checkbox within w_asi705_carnet_identifica
end type
type cb_seleccionar from commandbutton within w_asi705_carnet_identifica
end type
type uo_fecha from u_ingreso_fecha within w_asi705_carnet_identifica
end type
type st_porcentaje from statictext within w_asi705_carnet_identifica
end type
type rb_1 from radiobutton within w_asi705_carnet_identifica
end type
type rb_2 from radiobutton within w_asi705_carnet_identifica
end type
type gb_1 from groupbox within w_asi705_carnet_identifica
end type
type gb_2 from groupbox within w_asi705_carnet_identifica
end type
type gb_5 from groupbox within w_asi705_carnet_identifica
end type
type gb_3 from groupbox within w_asi705_carnet_identifica
end type
end forward

global type w_asi705_carnet_identifica from w_report_smpl
integer width = 4187
integer height = 2456
string title = "[ASI705] Carnets de Trabajadores"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
em_area em_area
em_desc_area em_desc_area
em_seccion em_seccion
em_desc_seccion em_desc_seccion
cbx_todos cbx_todos
cb_seleccionar cb_seleccionar
uo_fecha uo_fecha
st_porcentaje st_porcentaje
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
gb_3 gb_3
end type
global w_asi705_carnet_identifica w_asi705_carnet_identifica

type variables
string is_codigo
n_cst_codeqr		invo_codeqr
n_cst_utilitario	invo_util
n_cst_file_blob	invo_blob

end variables

forward prototypes
public function string of_load_foto (string as_codtra)
end prototypes

public function string of_load_foto (string as_codtra);blob 			lbl_imagen
string		ls_mensaje, ls_path, ls_nro_doc_ident, ls_tipo_doc_ident
Exception	ex

try 
	ex = create Exception
	
	select tipo_doc_ident_rtps, nro_doc_ident_rtps
		into :ls_tipo_doc_ident, :ls_nro_doc_ident
		from maestro m
	where cod_trabajador = :as_codtra;
	
	if SQLCA.SQLCode = 100 then
		rollback;
		ex.setMessage("No existe el código de trabajador " + as_codtra)
		throw ex
	end if
	
	selectblob foto_blob
		into :lbl_imagen
		from maestro m
	where cod_trabajador = :as_codtra;
	
	if SQLCA.SQLCode = 100 then
		SetNull(lbl_imagen)
	end if
	
	if SQLCA.SQlcode = -1 then
		ls_Mensaje = SQLCA.SQlErrText
		ROLLBACK;
		ex.setMessage('Error al recuperar foto de trabajador ' + as_codtra + ". Mensaje: " + ls_mensaje)
		throw ex
	end if
	
	if IsNull(lbl_imagen) then return gnvo_app.is_null
	
	ls_path = gnvo_app.of_get_parametro("PATH_TEMPORAL", "i:\sigre_exe\fotos\temp")
	
	If not DirectoryExists ( ls_path ) Then
		if not invo_util.of_CreateDirectory( ls_path ) then 
			ROLLBACK;
			ex.setMessage('Error al crear directorio temporal ' + ls_path + ' para la foto de trabajador ' + as_codtra)
			throw ex
		end if
	End If

	
	ls_path = ls_path + "\" + ls_tipo_doc_ident + "_" + ls_nro_doc_ident + ".png"
	
	if not invo_blob.of_write_blob(ls_path, lbl_Imagen) then
		return gnvo_app.is_null
	end if
	
	return ls_path

catch ( Exception e )
	throw e
	
finally
	destroy ex
end try


end function

on w_asi705_carnet_identifica.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_area=create em_area
this.em_desc_area=create em_desc_area
this.em_seccion=create em_seccion
this.em_desc_seccion=create em_desc_seccion
this.cbx_todos=create cbx_todos
this.cb_seleccionar=create cb_seleccionar
this.uo_fecha=create uo_fecha
this.st_porcentaje=create st_porcentaje
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.em_area
this.Control[iCurrent+5]=this.em_desc_area
this.Control[iCurrent+6]=this.em_seccion
this.Control[iCurrent+7]=this.em_desc_seccion
this.Control[iCurrent+8]=this.cbx_todos
this.Control[iCurrent+9]=this.cb_seleccionar
this.Control[iCurrent+10]=this.uo_fecha
this.Control[iCurrent+11]=this.st_porcentaje
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.rb_2
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_5
this.Control[iCurrent+17]=this.gb_3
end on

on w_asi705_carnet_identifica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_area)
destroy(this.em_desc_area)
destroy(this.em_seccion)
destroy(this.em_desc_seccion)
destroy(this.cbx_todos)
destroy(this.cb_seleccionar)
destroy(this.uo_fecha)
destroy(this.st_porcentaje)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.gb_3)
end on

event ue_retrieve;//Override
string  	ls_seccion, ls_desde, ls_hasta, ls_mensaje, ls_area
date		ld_fecha, ld_hoy
Long 		ll_row

//DAtos para el QR
String	ls_cod_trabajador, ls_nom_trabajador, ls_tipo_doc_ident, ls_nro_doc_ident, ls_tipo_trabajador, &
			ls_fec_inicio, ls_cod_area, ls_desc_area, ls_cod_seccion, ls_desc_seccion, ls_tipo_sangre, &
			ls_fec_vigencia, ls_valor, ls_desc_cargo, ls_foto, ls_cabecera, ls_fondo
			
//Variables para firma
String	ls_direccion, ls_telefono, ls_condiciones01, ls_condiciones02, ls_firma

try
	
	if isnull(em_area.text) or trim(em_area.text) = '' then 
		MessageBox('Error', 'Debe especificar un area para listar los trabajadores por esa area', StopSign!)
		return
	end if
		
	ls_area = trim(em_area.text) + '%'
	
	//Ahora obtengo la sección
	ls_seccion = string (em_seccion.text)
	
	if isnull(em_seccion.text) or trim(em_seccion.text) = '' then 
		ls_seccion = '%%'
	else
		ls_Seccion = trim(em_seccion.text) + '%'
	end if
	
	//Valido si hay un filtro o muestro todos los trabajadores
	if cbx_todos.checked then
	
		delete tt_proveedor;
		
		insert into tt_proveedor(proveedor)
		select distinct cod_trabajador
		  from maestro m,
		  		  seccion s
		 where m.cod_seccion = s.cod_seccion
		   and m.flag_estado = '1'
			and s.cod_area		like :ls_area
		   and s.cod_seccion like :ls_seccion;
		
		if sqlca.SQlCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			rollbacK;
			MEssageBox('Error', 'Ha ocurrido un error al insertar en tt_proveedor. Mensaje de error: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
	end if
	
	if rb_1.checked then
		dw_report.DataObject = 'd_rpt_fotocheck_trabajador_lbl'

		//La cebecera y el fondo son por empresa
		ls_Cabecera = "i:\sigre_exe\Fondos\cabecera_" + trim(UPPER(gs_empresa)) + ".png"
		ls_fondo  = "i:\sigre_exe\Fondos\fondo_" + trim(UPPER(gs_empresa)) + ".jpg"
		
		If not FileExists(ls_Cabecera) then
			MessageBox("Error", "No existe archivo CABECERA del fotocheck: "+ ls_Cabecera, StopSign!)
			return
		end if
		
		If not FileExists(ls_fondo) then
			MessageBox("Error", "No existe archivo FONDO del fotocheck: "+ ls_fondo, StopSign!)
			return
		end if
	
		//Cabecera 
		if dw_report.of_Existspicturename( "p_cabecera") then
			dw_report.object.p_cabecera.filename = ls_cabecera
		end if
		
		//Fondo
		if dw_report.of_Existspicturename( "p_fondo") then
			dw_report.object.p_fondo.filename = ls_fondo
		end if

	else
		dw_report.DataObject = 'd_rpt_carnet_posterior_lbl'
		
		ls_direccion 		= gnvo_app.of_get_parametro( "FOTOCHECK_DIRECCION", "Mz ~"D~" Lote I Zona Industrial II carr. Paita - Sullana - Dpto. Piura")
		ls_telefono 		= gnvo_app.of_get_parametro( "FOTOCHECK_TELEFONO", '073-211110')
		ls_condiciones01	= gnvo_app.of_get_parametro( "FOTOCHECK_CONDICIONES01", &
											'-Este fotochek es personal e intransferible y su uso es obligatorio ' + &
											'durante su permanencia en las instalaciones de la compañía.~r~n' + &
											'-Debe portarse en todo momento y en un lugar visible de lo contrario ' + &
											'será retirado de la empresa.')

		ls_condiciones02	= gnvo_app.of_get_parametro( "FOTOCHECK_CONDICIONES02", &
											'-En caso de pérdida debe reportarse a la oficina de RRHH ' + &
											'dentro de las 48 horas. ~r~n' + &
											'-En caso de hallazgo, favor llamar al tel.: 211110.')

		ls_firma  = "i:\sigre_exe\Fondos\firma_fotocheck_" + trim(UPPER(gs_empresa)) + ".png"
		
		If not FileExists(ls_firma) then
			MessageBox("Error", "No existe archivo FIRMA del fotocheck: "+ ls_firma, StopSign!)
			return
		end if
		
		if dw_report.of_Existspicturename( "p_firma") then
			dw_report.object.p_firma.filename = ls_firma
		end if
		
		dw_report.object.t_direccion.text 		= String(ls_direccion)
		dw_report.object.t_telefono.text 		= ls_telefono
		dw_report.object.t_condiciones01.text 	= ls_condiciones01
		dw_report.object.t_condiciones02.text 	= ls_condiciones02
		
		
	end if
	
	dw_report.SetTransObject(SQLCA)
	dw_report.retrieve()
	
	if dw_report.of_Existspicturename( "p_logo") then
		dw_report.object.p_logo.filename = gs_logo
	end if
	
	ld_fecha = uo_fecha.of_get_fecha( )
	ld_hoy = date(gnvo_app.of_fecha_actual( ))
	
	//Genero los QR adecuados
	ls_fec_vigencia= string(ld_fecha, 'dd/mm/yyyy')

	if rb_1.checked then

		
		st_porcentaje.visible = true
		for ll_row = 1 to dw_report.Rowcount()
			ls_cod_trabajador 	= dw_report.object.cod_trabajador 				[ll_Row]
			ls_nom_trabajador		= dw_report.object.nom_trabajador 				[ll_Row]
			ls_tipo_doc_ident		= dw_report.object.tipo_doc_ident_rtps 		[ll_Row]
			ls_nro_doc_ident		= dw_report.object.nro_doc_ident_rtps			[ll_Row]
			ls_tipo_trabajador	= dw_report.object.tipo_trabajador 				[ll_Row]
			ls_fec_inicio			= String(Date(dw_report.object.fec_ingreso 	[ll_Row]), 'dd/mm/yyyy')
			ls_cod_area				= dw_report.object.cod_area 						[ll_Row]
			ls_desc_area			= dw_report.object.desc_area 						[ll_Row]
			ls_cod_seccion			= dw_report.object.cod_seccion 					[ll_Row]
			ls_desc_seccion		= dw_report.object.desc_seccion 					[ll_Row]
			ls_tipo_sangre			= dw_report.object.desc_sangre	 				[ll_Row]
			ls_desc_cargo			= dw_report.object.desc_cargo		 				[ll_Row]
			
			if isNull(ls_tipo_sangre) then ls_tipo_sangre = ''
			
			ls_valor	= ls_cod_trabajador + '|' + ls_nom_trabajador + '|' + ls_tipo_doc_ident + '|' + ls_nro_doc_ident &
						+ '|' + ls_tipo_trabajador + '|' + ls_fec_inicio + '|' + ls_cod_area + '|' + ls_desc_area &
						+ '|' + ls_cod_seccion + '|' + ls_desc_seccion + '|' + ls_tipo_sangre &
						+ '|' + ls_fec_vigencia + '|' + ls_desc_cargo + '|'
						
			 
				
			ls_foto = this.of_load_foto( ls_cod_trabajador )
			
			if IsNull(ls_foto) or trim(ls_foto) = '' then
				ls_foto = "C:\SIGRE\resources\PNG\noimage.png"
			end if
				
			dw_report.object.code_qr[ll_Row] = invo_codeqr.of_generar_qrcode( ls_tipo_doc_ident, &
																									ls_nro_doc_ident, &
																									ls_valor)
			dw_report.object.foto	[ll_Row] = ls_foto
				
		
			
			st_porcentaje.text = "CARGANDO : " + string(ll_row / dw_report.RowCount() * 100, "##0.00") + "%"
			yield()
			
		next
		
		idw_1.Visible = True
		st_porcentaje.visible = false
		
	else
		
		if dw_report.of_Existspicturename( "p_firma") then
			dw_report.object.p_firma.filename = ls_firma
		end if
		
		dw_report.object.fec_emision_t.text = 'Fecha Emisión: ' + string(ld_hoy, 'dd/mm/yyyy')
		dw_report.object.fecha_vence_t.text = 'Fecha Vencem.: ' + string(ld_fecha, 'dd/mm/yyyy')		
		
		idw_1.Visible = True
		
	end if
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al generar imagen")
end try
end event

event open;call super::open;Date 		ld_fecha
Integer 	li_year

FileCopy("IDAutomationHC39M_Free.ttf", &
	"C:\WINDOWS\Fonts\IDAutomationHC39M_Free.ttf", false)
	
invo_codeqr = create n_cst_codeqr	
invo_blob	= create n_cst_file_blob

li_year = year(date(gnvo_app.of_fecha_Actual()))

ld_fecha = date('31/12/' + string(li_year + 1, '0000'))

uo_fecha.of_set_fecha( ld_fecha )


end event

event close;call super::close;destroy invo_codeqr
destroy invo_blob
end event

event ue_open_pre;call super::ue_open_pre;String ls_cabecera, ls_fondo

//La cebecera y el fondo son por empresa
ls_Cabecera = "i:\sigre_exe\Fondos\cabecera_" + trim(UPPER(gs_empresa)) + ".png"
ls_fondo  = "i:\sigre_exe\Fondos\fondo_" + trim(UPPER(gs_empresa)) + ".jpg"

If not FileExists(ls_Cabecera) then
	MessageBox("Error", "No existe archivo CABECERA del fotocheck: "+ ls_Cabecera, StopSign!)
	return
end if

If not FileExists(ls_fondo) then
	MessageBox("Error", "No existe archivo FONDO del fotocheck: "+ ls_fondo, StopSign!)
	return
end if

//Cabecera 
if dw_report.of_Existspicturename( "p_cabecera") then
	dw_report.object.p_cabecera.filename = ls_cabecera
end if

//Fondo
if dw_report.of_Existspicturename( "p_fondo") then
	dw_report.object.p_fondo.filename = ls_fondo
end if

end event

type dw_report from w_report_smpl`dw_report within w_asi705_carnet_identifica
integer x = 0
integer y = 420
integer width = 3849
integer height = 1664
integer taborder = 70
string dataobject = "d_rpt_fotocheck_trabajador_lbl"
end type

type cb_1 from commandbutton within w_asi705_carnet_identifica
integer x = 3273
integer y = 236
integer width = 389
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type cb_2 from commandbutton within w_asi705_carnet_identifica
integer x = 293
integer y = 76
integer width = 87
integer height = 80
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

event clicked;// Abre ventana de ayuda 
String	ls_sql, ls_Codigo, ls_data
Boolean	lb_ret

ls_sql = "  SELECT distinct " &
		 + "		   a.COD_AREA as codigo_area, " &
       + "  		a.DESC_AREA as descripcion_area " &
		 + "    FROM AREA A," &
		 + "			Maestro m, " &
		 + "			seccion s " &
		 + "where s.cod_seccion = m.cod_seccion " &
		 + "  and s.cod_area	  = a.cod_area " &
		 + "ORDER BY a.COD_AREA ASC "
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")

if ls_codigo <> "" then

	em_area.text      = ls_codigo
	em_desc_area.text = ls_data

	
end if


end event

type cb_3 from commandbutton within w_asi705_carnet_identifica
integer x = 1975
integer y = 76
integer width = 87
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 
String	ls_sql, ls_Codigo, ls_data, ls_area
Boolean	lb_ret

ls_Area = em_area.text

if trim(ls_area) = '' then
	MessageBox('Error', 'Debe elegir un area primero, por favor verifique!', StopSign!)
	em_area.setFocus()
	return
end if

ls_sql = "  select distinct " &
		 + "			 s.cod_seccion as codigo_Seccion, " &
		 + "			 s.desc_seccion as descripcion_seccion " &
		 + "from seccion s, " &
		 + "     maestro m " &
		 + "where s.cod_seccion = m.cod_Seccion " &
		 + "  and s.cod_area = '" + ls_area + "'" &
	 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")

if ls_codigo <> "" then

	em_seccion.text      = ls_codigo
	em_desc_seccion.text = ls_data

	
end if


end event

type em_area from editmask within w_asi705_carnet_identifica
integer x = 64
integer y = 76
integer width = 192
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_area from editmask within w_asi705_carnet_identifica
integer x = 411
integer y = 76
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_seccion from editmask within w_asi705_carnet_identifica
integer x = 1655
integer y = 76
integer width = 283
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_seccion from editmask within w_asi705_carnet_identifica
integer x = 2098
integer y = 76
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_todos from checkbox within w_asi705_carnet_identifica
integer x = 64
integer y = 284
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if not this.checked then
	cb_seleccionar.enabled = true
else
	cb_seleccionar.enabled = false
end if
end event

type cb_seleccionar from commandbutton within w_asi705_carnet_identifica
integer x = 507
integer y = 272
integer width = 1458
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccionar trabajadores"
end type

event clicked;string 			ls_area, ls_seccion
str_parametros lstr_param

ls_area    = string (em_area.text)
ls_seccion = string (em_seccion.text)

if isnull(ls_area) or trim(ls_area) = '' then ls_area = '%%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%%'



// Si es una salida x consumo interno
lstr_param.titulo    	= 'Trabajadores Activos'
lstr_param.dw1				= 'd_list_trabajadores_tbl'
lstr_param.tipo			= '1S2S'
lstr_param.string1		= ls_area
lstr_param.string2		= ls_seccion
lstr_param.opcion    	= 1


OpenWithParm( w_abc_seleccion, lstr_param)



end event

type uo_fecha from u_ingreso_fecha within w_asi705_carnet_identifica
integer x = 2057
integer y = 280
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(date(f_fecha_actual())) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

type st_porcentaje from statictext within w_asi705_carnet_identifica
boolean visible = false
integer x = 3218
integer y = 8
integer width = 933
integer height = 204
boolean bringtotop = true
integer textsize = -18
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

type rb_1 from radiobutton within w_asi705_carnet_identifica
integer x = 2821
integer y = 236
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte anterior"
boolean checked = true
end type

type rb_2 from radiobutton within w_asi705_carnet_identifica
integer x = 2821
integer y = 320
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte posterior"
end type

type gb_1 from groupbox within w_asi705_carnet_identifica
integer width = 1518
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Area "
end type

type gb_2 from groupbox within w_asi705_carnet_identifica
integer x = 1591
integer width = 1609
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Sección "
end type

type gb_5 from groupbox within w_asi705_carnet_identifica
integer x = 5
integer y = 204
integer width = 1984
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Rango de Trabajadores"
end type

type gb_3 from groupbox within w_asi705_carnet_identifica
integer x = 1998
integer y = 200
integer width = 791
integer height = 204
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Vencimiento"
end type

