$PBExportHeader$w_rh202_periodo_vacacional.srw
forward
global type w_rh202_periodo_vacacional from w_abc_mastdet_smpl
end type
type dw_detdet from u_dw_abc within w_rh202_periodo_vacacional
end type
type cb_3 from commandbutton within w_rh202_periodo_vacacional
end type
type em_descripcion from editmask within w_rh202_periodo_vacacional
end type
type em_origen from editmask within w_rh202_periodo_vacacional
end type
type cb_1 from commandbutton within w_rh202_periodo_vacacional
end type
type sle_codigo from singlelineedit within w_rh202_periodo_vacacional
end type
type sle_nombre from singlelineedit within w_rh202_periodo_vacacional
end type
type cb_4 from commandbutton within w_rh202_periodo_vacacional
end type
type em_desc_tipo from editmask within w_rh202_periodo_vacacional
end type
type em_tipo from editmask within w_rh202_periodo_vacacional
end type
type cb_2 from commandbutton within w_rh202_periodo_vacacional
end type
type st_1 from statictext within w_rh202_periodo_vacacional
end type
type st_2 from statictext within w_rh202_periodo_vacacional
end type
type st_3 from statictext within w_rh202_periodo_vacacional
end type
type cb_5 from commandbutton within w_rh202_periodo_vacacional
end type
type hpb_progreso from hprogressbar within w_rh202_periodo_vacacional
end type
type st_texto from statictext within w_rh202_periodo_vacacional
end type
type gb_2 from groupbox within w_rh202_periodo_vacacional
end type
type gb_4 from groupbox within w_rh202_periodo_vacacional
end type
type gb_1 from groupbox within w_rh202_periodo_vacacional
end type
end forward

global type w_rh202_periodo_vacacional from w_abc_mastdet_smpl
integer width = 5047
integer height = 2688
string title = "[RH202] Vacaciones, Permisos o Subvenciones por Trabajador"
string menuname = "m_master_simple"
boolean resizable = false
event ue_retrieve ( string as_origen,  string as_tipo_trabaj,  string as_trabajador )
event type integer ue_import_data ( string as_file )
dw_detdet dw_detdet
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
sle_codigo sle_codigo
sle_nombre sle_nombre
cb_4 cb_4
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
st_1 st_1
st_2 st_2
st_3 st_3
cb_5 cb_5
hpb_progreso hpb_progreso
st_texto st_texto
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
end type
global w_rh202_periodo_vacacional w_rh202_periodo_vacacional

type variables
Integer ii_row, ii_column

String  	is_tabla_dd, is_colname_dd[], is_coltype_dd[]

end variables

event ue_retrieve(string as_origen, string as_tipo_trabaj, string as_trabajador);Long ll_rows

// Limpia los datawindows
dw_master.reset()
dw_detail.reset()
dw_detdet.reset()
// Recupera información
dw_master.Retrieve(as_origen, as_tipo_trabaj, as_trabajador)


end event

event type integer ue_import_data(string as_file);oleobject excel
integer	li_i
long 		ll_count, ll_max_rows, ll_fila1, ll_return
String	ls_mensaje
boolean	lb_cek

//Datos para importar
String 	ls_cod_trabajador, ls_nom_trabajador,  &
			ls_concepto, ls_fec_movim, ls_fec_desde, ls_fec_hasta, ls_cod_susp_lab, &
			ls_flag_vaca_adel, ls_tipo_doc, ls_nro_doc
Date		ld_fec_movim, ld_fec_desde, ld_Fec_hasta
Integer	li_dias_totales,  li_periodo_inicio, li_periodo_fin, li_dias_inasist, li_mes_periodo
Decimal	ldc_importe

oleobject  lole_workbook, lole_worksheet

try 
	excel = create oleobject;
	
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
	
	/*
		String 	ls_cod_trabajador, ls_nom_trabajador, ls_periodo_inicio, ls_periodo_fin, &
					ls_concepto, ls_fec_movim, ls_fec_desde, ls_fec_hasta, ls_cod_susp_lab, &
					ls_flag_vaca_adel, ls_tipo_doc, ls_nro_doc
		Date		ld_fec_movim, ld_fec_desde, ld_Fec_hasta
		Integer	li_dias_totales, li_periodo_inicio, li_periodo_fin
		Decimal	ldc_importe
	*/
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_cod_trabajador	= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_nom_trabajador	= String(lole_worksheet.cells(ll_fila1,2).value) 
		li_periodo_inicio	= Integer(lole_worksheet.cells(ll_fila1,3).value)
		li_periodo_fin		= Integer(lole_worksheet.cells(ll_fila1,4).value) 
		li_dias_totales	= Integer(lole_worksheet.cells(ll_fila1,5).value) 
		ls_concepto			= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_fec_movim		= String(lole_worksheet.cells(ll_fila1,7).value) 
		ls_fec_desde		= String(lole_worksheet.cells(ll_fila1,8).value) 
		ls_fec_hasta		= String(lole_worksheet.cells(ll_fila1,9).value) 
		ls_cod_susp_lab	= String(lole_worksheet.cells(ll_fila1,10).value) 
		ldc_importe			= Dec(lole_worksheet.cells(ll_fila1,11).value) 
		ls_flag_vaca_adel	= String(lole_worksheet.cells(ll_fila1,12).value)
		ls_tipo_doc			= String(lole_worksheet.cells(ll_fila1,13).value)
		ls_nro_doc			= String(lole_worksheet.cells(ll_fila1,14).value)
		
		ld_fec_movim 		= date(ls_fec_movim)
		ld_fec_desde 		= date(ls_fec_desde)
		ld_Fec_hasta 		= date(ls_fec_hasta)
		
		//Obtengo los días de inasistencia
		select :ld_fec_hasta - :ld_fec_desde + 1
			into :li_dias_inasist
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrtext
			ROLLBACK;
			MessageBox('Error', 'Ha sucedido un error al OBTENER los días de inasistencia. ' &
									 + "~r~nMensaje de Error: " + ls_mensaje &
									 + "~r~nCod Trabajador: " + ls_cod_trabajador &
									 + "~r~nFec Desde: " + String(ld_fec_desde, 'dd/mm/yyyy') &
									 + "~r~nFec Hasta: " + String(ld_fec_hasta, 'dd/mm/yyyy') &
									 + "~r~nNro Registro Excel: " + String(ll_fila1), StopSign!)
			return -1
		end if
		
		//Obtengo el periodo
		li_mes_periodo = Month(ld_fec_desde)
		
		//Verifico que exista la cabecera de la tabla
		select count(*)
			into :ll_count
		from rrhh_vacaciones_trabaj
		where cod_trabajador = :ls_cod_trabajador
		  and periodo_inicio	= :li_periodo_inicio
		  and concep			= :ls_concepto;
		  
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrtext
			ROLLBACK;
			MessageBox('Error', 'Ha sucedido un error al CONSULTAR la tabla RRHH_VACACIONES_TRABAJ. ' &
									 + "~r~nMensaje de Error: " + ls_mensaje &
									 + "~r~nCod Trabajador: " + ls_cod_trabajador &
									 + "~r~nNro Registro Excel: " + String(ll_fila1), StopSign!)
			return -1
		end if

		if ll_count = 0 then
			insert into rrhh_vacaciones_trabaj(
				cod_trabajador, periodo_inicio, periodo_fin, dias_totales, 
				dias_gozados,
				flag_estado, 
				concep, cod_usr, item_laboral)
			values(
				:ls_cod_trabajador, :li_periodo_inicio, :li_periodo_fin, :li_dias_totales,
				0,
				'1',
				:ls_concepto,
				:gs_user, 
				1);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error', 'Ha sucedido un error al INSERTAR la tabla RRHH_VACACIONES_TRABAJ. ' &
									 + "~r~nMensaje de Error: " + ls_mensaje &
									 + "~r~nCod Trabajador: " + ls_cod_trabajador &
									 + "~r~nNro Registro Excel: " + String(ll_fila1), StopSign!)
				return -1
			end if
			
		end if	
		
		
		//Verifico que exista el registro en el detalle, la tabla INASISTENCIA
		select count(*)
			into :ll_count
		from INASISTENCIA
		where cod_trabajador = :ls_cod_trabajador
		  and fec_desde		= :ld_fec_desde
		  and concep			= :ls_concepto;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrtext
			ROLLBACK;
			MessageBox('Error', 'Ha sucedido un error al CONSULTAR la tabla INASISTENCIA. ' &
									 + "~r~nMensaje de Error: " + ls_mensaje &
									 + "~r~nCod Trabajador: " + ls_cod_trabajador &
									 + "~r~nNro Registro Excel: " + String(ll_fila1), StopSign!)
			return -1
		end if
		
		if ll_count = 0 then
			insert into INASISTENCIA(
				cod_trabajador, 
				concep, 
				fec_desde, 
				fec_hasta, 
				fec_movim, 
				dias_inasist, 
				cod_usr, 
				periodo_inicio, 
				cod_suspension_lab,
				mes_periodo, 
				flag_vacac_adelantadas, 
				importe, 
				tipo_doc, 
				nro_doc, 
				flag_replicacion
			)values(
				:ls_cod_trabajador, 
				:ls_concepto,
				:ld_fec_desde,
				:ld_fec_hasta,
				:ld_fec_movim,
				:li_dias_inasist,
				:gs_user,
				:li_periodo_inicio,
				:ls_cod_susp_lab,
				:li_mes_periodo,
				:ls_flag_vaca_adel,
				:ldc_importe,
				:ls_tipo_doc,
				:ls_nro_doc,
				'1'
			);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error', 'Ha sucedido un error al INSERTAR la tabla INASISTENCIA. ' &
									 + "~r~nMensaje de Error: " + ls_mensaje &
									 + "~r~nCod Trabajador: " + ls_cod_trabajador &
									 + "~r~nNro Registro Excel: " + String(ll_fila1), StopSign!)
				return -1
			end if
			
		else
			
			update INASISTENCIA i
				set 	fec_hasta 					= :ld_fec_hasta,
						fec_movim 					= :ld_fec_movim,
						dias_inasist 				= :li_dias_inasist,
						periodo_inicio				= :li_periodo_inicio,
						cod_suspension_lab 		= :ls_cod_susp_lab,
						mes_periodo					= :li_mes_periodo,
						flag_vacac_adelantadas 	= :ls_flag_vaca_adel,
						importe						= :ldc_importe,
						tipo_doc						= :ls_tipo_doc,
						nro_doc						= :ls_nro_doc,
						flag_replicacion			= '1'
			where i.cod_trabajador 	= :ls_cod_trabajador
			  and i.concep				= :ls_concepto
			  and i.fec_desde			= :ld_fec_Desde;		
			 
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error', 'Ha sucedido un error al ACTAULIZAR la tabla INASISTENCIA. ' &
									 + "~r~nMensaje de Error: " + ls_mensaje &
									 + "~r~nCod Trabajador: " + ls_cod_trabajador &
									 + "~r~nNro Registro Excel: " + String(ll_fila1), StopSign!)
				return -1
			end if
			
		end if	

	
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		
		yield()		
	next
	
	//Actualizo todos los importes
	update RRHH_VACACIONES_TRABAJ t
   	set t.dias_gozados = (select nvl(sum(i.dias_inasist), 0)
										from inasistencia i
									  where i.cod_trabajador = t.cod_trabajador
										 and i.periodo_inicio = t.periodo_inicio
										 and i.concep         = t.concep)
	  where t.dias_gozados <> (select nvl(sum(i.dias_inasist), 0)
										from inasistencia i
									  where i.cod_trabajador = t.cod_trabajador
										 and i.periodo_inicio = t.periodo_inicio
										 and i.concep         = t.concep);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrtext
		ROLLBACK;
		MessageBox('Error', 'Ha sucedido un error al ACTAULIZAR la tabla RRHH_VACACIONES_TRABAJ de manera masiva. ' &
							 + "~r~nMensaje de Error: " + ls_mensaje , StopSign!)
		return -1
	end if
			
									 
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

on w_rh202_periodo_vacacional.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_detdet=create dw_detdet
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.cb_4=create cb_4
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.cb_5=create cb_5
this.hpb_progreso=create hpb_progreso
this.st_texto=create st_texto
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detdet
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.sle_codigo
this.Control[iCurrent+7]=this.sle_nombre
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.em_desc_tipo
this.Control[iCurrent+10]=this.em_tipo
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.cb_5
this.Control[iCurrent+16]=this.hpb_progreso
this.Control[iCurrent+17]=this.st_texto
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_4
this.Control[iCurrent+20]=this.gb_1
end on

on w_rh202_periodo_vacacional.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detdet)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.cb_4)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_5)
destroy(this.hpb_progreso)
destroy(this.st_texto)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_1)
end on

event resize;//override
dw_master.height = newheight - dw_master.y - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
st_2.width		  = dw_detail.width

dw_detdet.width  = newwidth  - dw_detdet.x - 10
dw_detdet.height = newheight - dw_detdet.y - 10
st_3.width		  = dw_detdet.width
end event

event ue_open_pre;call super::ue_open_pre;Integer li_dias_vacaciones
String ls_concepto 

SELECT dias_vacaciones, concepto_vacac
  INTO :li_dias_vacaciones, :ls_concepto
  FROM rrhhparam_vacacion 
 WHERE reckey='1' ;

IF (isnull(li_dias_vacaciones) OR li_dias_vacaciones = 0) THEN
	MessageBox('Aviso','Defina previamente parametros de tabla RRHHPARAM_VACACION') 
	Return
END IF 

dw_detdet.SetTransObject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
dw_detdet.BorderStyle = StyleRaised!
dw_detdet.of_protect()

is_tabla_dd = dw_detdet.Object.Datawindow.Table.UpdateTable

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
	dw_detail.of_create_log()
	dw_detdet.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle - detail", ls_msg, StopSign!)
	END IF
END IF

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
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_detdet.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
	dw_detdet.ii_update = 0
	
	dw_detail.il_totdel = 0
	dw_detdet.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	

	IF dw_master.GetRow() = 0 THEN Return 
	
	ls_cod_trabajador = dw_master.object.cod_trabajador[dw_master.GetRow()]
	ll_row = dw_detail.GetRow()
	
	dw_detail.Retrieve(ls_cod_trabajador)
	if ll_row > 0 and ll_row < dw_detail.RowCount() and dw_detail.RowCount() > 0 then
		dw_detail.SetRow(ll_row)
		dw_detail.scrolltorow( ll_row )
		dw_detail.selectrow( 0, false)
		dw_detail.selectrow( ll_row, true)
		dw_detail.event ue_output( ll_row )
	end if
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	dw_detail.SetFocus()
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

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh202_periodo_vacacional
integer x = 0
integer y = 272
integer width = 1760
integer height = 2136
integer taborder = 50
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

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh202_periodo_vacacional
integer x = 1769
integer y = 272
integer width = 3973
integer height = 928
integer taborder = 70
string dataobject = "d_abc_vacac_trabaj_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2

ii_rk[1] = 1 	      // columnas que recibimos del master

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

is_mastdet = 'd'


end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::ue_insert;//ovreride
if dw_master.getrow( ) < 1 then
	messagebox(parent.title, 'No hay ningún país Seleccionado' )
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

event dw_detail::ue_insert_pre;call super::ue_insert_pre;Integer 	li_row_master, li_item, li_nro_dias 
String 	ls_concepto, ls_desc
DateTime ldt_fec_prestamo

li_row_master = dw_master.GetRow()

IF li_row_master = 0 THEN Return

SELECT concepto_vacac, dias_vacaciones 
  INTO :ls_concepto, :li_nro_dias 
  FROM rrhhparam_vacacion 
 WHERE reckey='1' ;
 
select desc_concep
	into :ls_desc
from concepto
where concep = :ls_concepto;

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'El concepto de planilla ' + ls_concepto &
						+ ' no existe o no se encuentra activo, por favor verifique')
	return
end if

THIS.object.cod_trabajador	[al_row] = dw_master.Object.cod_trabajador[li_row_master] 
THIS.object.concep			[al_row] = ls_concepto 
THIS.object.desc_concep		[al_row] = ls_desc
THIS.object.dias_totales	[al_row] = li_nro_dias 
THIS.object.dias_gozados	[al_row] = 0 
THIS.object.flag_estado		[al_row] = '1' //Planeado (Se debe activar al pasar por historico)

end event

event dw_detail::itemchanged;Integer li_dias
Decimal{2} ld_monto_original
String ls_cod_trabajador, ls_tipo_doc, ls_nro_doc, ls_codigo, ls_descrip, ls_null

This.AcceptText()

SETNULL(ls_null)

ii_update = 1

This.Object.cod_usr[row] = gs_user 

CHOOSE CASE dwo.name
	CASE 'dias_totales'
		li_dias = this.Object.dias_totales[row] 
		IF li_dias > 30 OR li_dias<0 THEN
			MessageBox('Aviso','Dias no apropiados para periódo vacacional')
			this.Object.dias_totales[row] = 30
			Return 1			
		END IF 
	CASE 'dias_gozados'
		li_dias = this.Object.dias_gozados[row] 
		IF li_dias > this.Object.dias_totales[row]  THEN
			MessageBox('Aviso','Dias gozados no puede ser mayor al periodo total')
			Return 1			
		END IF 
		
END CHOOSE
end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2
ls_col = lower(trim(string(dwo.name)))
//This.Object.cod_usr[row] = gs_user 

choose case ls_col
	case 'concep'
		ls_sql = "select c.concep as cod, c.desc_concep as descripcion "&
				+  "from concepto c "&
				+  "where c.flag_estado<>'0' " 
					
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.concep		[row] = ls_return1
		this.object.desc_concep	[row] = ls_return2
		this.ii_update = 1
end choose		
end event

event dw_detail::ue_delete;call super::ue_delete;MessageBox('Aviso','Procede a eliminar')
Return 1
end event

event dw_detail::ue_output;call super::ue_output;//THIS.EVENT ue_retrieve_det(al_row)

string ls_cod_trabajador, ls_concepto
Integer li_periodo

dw_detdet.reset()


if al_row < 1 then return

ls_cod_trabajador = this.object.cod_trabajador[al_row]
li_periodo 			= INTEGER(this.object.periodo_inicio[al_row])
ls_concepto 		= this.object.concep[al_row]

if dw_detdet.retrieve(ls_cod_trabajador, li_periodo, ls_concepto) > 1 then
	dw_detdet.setrow( 1 )
	dw_detdet.scrolltorow( 1 )
	dw_detdet.selectrow( 1, true )
end if
end event

event dw_detail::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;THIS.Event ue_output(currentrow)
end event

type dw_detdet from u_dw_abc within w_rh202_periodo_vacacional
integer x = 1769
integer y = 1292
integer width = 3973
integer height = 712
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_abc_vacac_trabaj_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_ck[3] = 3				// columnas de lectura de este dw

ii_rk[1] = 1 	      	// columnas que recibimos del master
ii_rk[2] = 2 	      	// columnas que recibimos del master


end event

event ue_insert_pre;call super::ue_insert_pre;Integer li_row_detail 

li_row_detail = dw_detail.GetRow()

IF li_row_detail < 1 THEN Return

THIS.object.cod_trabajador				[al_row] = dw_detail.object.cod_trabajador[li_row_detail]
THIS.object.periodo_inicio				[al_row] = dw_detail.object.periodo_inicio[li_row_detail]
THIS.object.concep						[al_row] = dw_detail.object.concep			[li_row_detail]
THIS.Object.cod_usr						[al_row] = '1'
THIS.Object.flag_vacac_adelantadas	[al_row] = '0'
this.object.importe						[al_row] = 0

this.setColumn('mes_periodo')

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;// OVERRIDE

if dw_detail.getrow( ) < 1 then
	messagebox(parent.title, 'No hay ningun registro de vacaciones seleccionado')
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
Long 		ll_count, ll_row = 1
Date 		ld_fecha_proceso
String 	ls_cod_trabajador, ls_concep, ls_flag_estado, ls_mensaje

if idw_1 = dw_detdet then
	ls_cod_trabajador = this.object.cod_trabajador	[dw_detdet.GetRow()]
	ls_concep 			= dw_detail.object.concep		[dw_detail.GetRow()]
	ld_fecha_proceso 	= Date(this.object.fec_movim	[dw_detdet.GetRow()])
	
	//Verifico si el concepto se encuentra en el historico
	select count(*)
	  into :ll_count
	  from historico_calculo hc
	 where hc.fec_calc_plan  = :ld_fecha_proceso
		and hc.cod_trabajador = :ls_cod_trabajador
		and hc.concep			 = :ls_concep;
	 
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrtext
		ROLLBACK;
		MessageBox('Error al consultar en historico_calculo', ls_mensaje)
		return -1
	end if
	
	IF ll_count > 0 then
		MessageBox('Aviso', 'Registro no puede eliminarse, se encuentra en archivo histórico')
		Return 1
	END IF 
end if

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

event itemchanged;call super::itemchanged;Integer 	li_nro_dias
Date 		ld_fecha_ini, ld_fecha_fin 
string	ls_data, ls_null

setNull(ls_null)
This.Object.cod_usr[row] = gs_user 
ii_update = 1
this.Accepttext( )

CHOOSE CASE lower(dwo.name)
	CASE 'fec_desde', 'fec_hasta' 
		
		
		ld_fecha_ini = DATE(this.Object.fec_desde[row])
		ld_fecha_fin = DATE(this.Object.fec_hasta[row])
		
		if ld_fecha_fin < ld_fecha_ini then
			Messagebox( "Error", "Incosistencia en el rango de fechas ingresado, por favor verifique" &
									+  "~r~nFecha Inicio: " + String (ld_fecha_ini, 'dd/mm/yyyy') &
									+  "~r~nFecha Fin: " + String (ld_fecha_fin, 'dd/mm/yyyy'))
			
			this.Object.fec_hasta	[row] = ld_fecha_ini						
			this.Object.dias_inasist[row] = 0
			return 1
		end if
		
		IF not isnull(ld_fecha_ini) and not isnull(ld_fecha_ini) THEN
			li_nro_dias = DaysAfter(ld_fecha_ini, ld_fecha_fin) + 1
		ELSE
			li_nro_dias = 0
		END IF
		
		this.Object.dias_inasist[row] = li_nro_dias
	
	case 'cod_suspension_lab'
		
		//Verifica que exista dato ingresado	
		Select descripcion
	     into :ls_data
		  from RRHH_TIPO_SUSP_LABORAL_RTPS
		  Where cod_suspension_lab = :data
		    and flag_estado = '1';
					
		if sqlca.SQLcode = 100 then
			Messagebox( "Error", "Código de Suspensión Laboral no existe o no esta activo, por favor verifique")
			this.object.cod_suspension_lab	[row] = ls_null
			this.object.desc_susp_laboral		[row] = ls_null
			return 1
		end if
		
		this.object.desc_susp_laboral	[row] = ls_data

END CHOOSE
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_suspension_lab"
		ls_sql = "SELECT cod_suspension_lab AS Codigo_suspension, " &
				  + "descripcion AS descripcion_suspension_laboral " &
				  + "FROM RRHH_TIPO_SUSP_LABORAL_RTPS " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_suspension_lab	[al_row] = ls_codigo
			this.object.desc_susp_laboral		[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case 'tipo_doc'
		ls_sql = "SELECT tipo_doc AS tipo_documento, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_doc	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

type cb_3 from commandbutton within w_rh202_periodo_vacacional
integer x = 187
integer y = 64
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

type em_descripcion from editmask within w_rh202_periodo_vacacional
integer x = 288
integer y = 64
integer width = 613
integer height = 72
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

type em_origen from editmask within w_rh202_periodo_vacacional
integer x = 50
integer y = 64
integer width = 128
integer height = 72
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

type cb_1 from commandbutton within w_rh202_periodo_vacacional
integer x = 3328
integer y = 56
integer width = 270
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_origen, ls_tipo, ls_codigo

ls_origen = em_origen.text
ls_tipo = em_tipo.text 
ls_codigo = sle_codigo.text

Parent.Event ue_retrieve(ls_origen, ls_tipo, ls_codigo)
end event

type sle_codigo from singlelineedit within w_rh202_periodo_vacacional
integer x = 1998
integer y = 64
integer width = 279
integer height = 72
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
	from vw_pr_trabajador m 
	WHERE m.tipo_Trabajador like :ls_tipo_trabaj
	  and m.cod_origen like :ls_origen
	  and m.flag_estado = '1'
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

type sle_nombre from singlelineedit within w_rh202_periodo_vacacional
integer x = 2405
integer y = 64
integer width = 873
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
string text = "Todos"
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_rh202_periodo_vacacional
integer x = 2299
integer y = 64
integer width = 87
integer height = 72
integer taborder = 30
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
		  + "FROM vw_pr_trabajador m " &
		  + "WHERE m.tipo_Trabajador like '" + ls_tipo_trabaj + "'" &
		  + "  and m.cod_origen like '" + ls_origen + "'" &
		  + "  and m.flag_estado = '1'" 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_codigo.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

type em_desc_tipo from editmask within w_rh202_periodo_vacacional
integer x = 1303
integer y = 64
integer width = 599
integer height = 72
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

type em_tipo from editmask within w_rh202_periodo_vacacional
integer x = 1006
integer y = 64
integer width = 201
integer height = 72
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

event modified;string ls_codigo, ls_desc, ls_origen

if this.text = '%' then
	em_descripcion.text = 'Todos'
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

type cb_2 from commandbutton within w_rh202_periodo_vacacional
integer x = 1211
integer y = 64
integer width = 87
integer height = 72
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

type st_1 from statictext within w_rh202_periodo_vacacional
integer y = 184
integer width = 1760
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "MAESTRO DE TRABAJADORES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh202_periodo_vacacional
integer x = 1769
integer y = 184
integer width = 3973
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "LISTADO DE CONCEPTOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh202_periodo_vacacional
integer x = 1769
integer y = 1204
integer width = 3973
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "DETALLES POR FECHA DE PROCESO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_rh202_periodo_vacacional
integer x = 3607
integer y = 56
integer width = 416
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar XLS"
end type

event clicked;//Validacion

String 	ls_docname, ls_named, ls_filtro
integer	li_value


li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.XLS),*.XLS" )

if li_value <> 1 then
	return -1
end if

IF parent.event dynamic ue_import_data(ls_docname) = -1 THEN 
	RETURN -1
END IF
end event

type hpb_progreso from hprogressbar within w_rh202_periodo_vacacional
integer x = 4069
integer y = 32
integer width = 891
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type st_texto from statictext within w_rh202_periodo_vacacional
integer x = 4069
integer y = 104
integer width = 891
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

type gb_2 from groupbox within w_rh202_periodo_vacacional
integer width = 951
integer height = 180
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_4 from groupbox within w_rh202_periodo_vacacional
integer x = 1957
integer width = 1362
integer height = 180
integer taborder = 100
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

type gb_1 from groupbox within w_rh202_periodo_vacacional
integer x = 960
integer width = 987
integer height = 180
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

