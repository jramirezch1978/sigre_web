$PBExportHeader$w_pr310_asistencia_jornal.srw
forward
global type w_pr310_asistencia_jornal from w_abc_master_smpl
end type
type hpb_progreso from hprogressbar within w_pr310_asistencia_jornal
end type
type dw_origen from u_dw_abc within w_pr310_asistencia_jornal
end type
type sle_ot from singlelineedit within w_pr310_asistencia_jornal
end type
type st_2 from statictext within w_pr310_asistencia_jornal
end type
type sle_ot_d from singlelineedit within w_pr310_asistencia_jornal
end type
type cb_buscar from commandbutton within w_pr310_asistencia_jornal
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_pr310_asistencia_jornal
end type
type sle_cod_tra from singlelineedit within w_pr310_asistencia_jornal
end type
type sle_nom_tra from singlelineedit within w_pr310_asistencia_jornal
end type
type st_1 from statictext within w_pr310_asistencia_jornal
end type
type st_procesando from statictext within w_pr310_asistencia_jornal
end type
type cb_copiar from commandbutton within w_pr310_asistencia_jornal
end type
type cb_importar from commandbutton within w_pr310_asistencia_jornal
end type
type st_texto from statictext within w_pr310_asistencia_jornal
end type
type st_left_time from statictext within w_pr310_asistencia_jornal
end type
type cb_procesar from commandbutton within w_pr310_asistencia_jornal
end type
type gb_2 from groupbox within w_pr310_asistencia_jornal
end type
end forward

global type w_pr310_asistencia_jornal from w_abc_master_smpl
integer width = 4695
integer height = 2292
string title = "Asistencia de Jornales(PR310) "
string menuname = "m_mantto_smpl"
windowstate windowstate = maximized!
event ue_retrieve ( )
event ue_retrieve_hrs_row ( long al_row )
event ue_copiar ( )
event type integer ue_importar_xls ( string as_file )
event ue_procesar ( )
hpb_progreso hpb_progreso
dw_origen dw_origen
sle_ot sle_ot
st_2 st_2
sle_ot_d sle_ot_d
cb_buscar cb_buscar
uo_fechas uo_fechas
sle_cod_tra sle_cod_tra
sle_nom_tra sle_nom_tra
st_1 st_1
st_procesando st_procesando
cb_copiar cb_copiar
cb_importar cb_importar
st_texto st_texto
st_left_time st_left_time
cb_procesar cb_procesar
gb_2 gb_2
end type
global w_pr310_asistencia_jornal w_pr310_asistencia_jornal

type variables
integer 	ii_copia
string 	is_desc_turno, is_cod_trabajador, is_nombre, is_cod_tipo_mov, is_desc_movimi, &
		 	is_cod_origen, is_asist_normal, is_salir
datetime id_entrada, id_salida

n_cst_wait	invo_wait
end variables

forward prototypes
public function boolean of_verificar ()
public subroutine of_set_modify ()
public function boolean of_getparam ()
public function integer of_horas_trab (long al_row)
public function boolean of_calc_hrs_jornal ()
public function boolean of_valida_fecha (u_dw_abc adw_1)
public function boolean of_validar_registro (u_dw_abc adw_1)
end prototypes

event ue_retrieve;date 		ld_desde, ld_hasta
String 	ls_ot_adm, ls_cod_tra

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

IF NOT of_verificar() THEN RETURN

if trim(sle_ot.text) = '' then
	ls_ot_adm = "%%"	
ELSE	
	ls_ot_adm = trim(sle_ot.text) + "%"	
end if

if trim(sle_cod_tra.text) = '' then
	ls_cod_tra = "%%"	
ELSE	
	ls_cod_tra = trim(sle_cod_tra.text) + "%"	
end if

if dw_master.Retrieve(gs_user, ld_desde, ld_hasta, is_cod_origen, ls_ot_adm, ls_cod_tra) < 1 then 
		messagebox(this.title, "No hay asistencia registrada " &
					+ "para los datos Ingresados. " &
					+ "~n~rPerido" + string(ld_desde, 'dd/mm/yyyy') + " - " &
					+ string(ld_hasta, 'dd/mm/yyyy') &
					+ '~n~rOrigen: ' + is_cod_origen &
					+ '~n~rOT_adm: '+ ls_ot_adm)
					
end if				
end event

event ue_retrieve_hrs_row(long al_row);string 	ls_codtra, ls_turno, ls_tipo_mov
date		ld_fec_mov
decimal	ldc_hrs_diu_nor, ldc_hrs_diu_ext1, ldc_hrs_diu_ext2, &
			ldc_hrs_noc_nor, ldc_hrs_noc_ext1, ldc_hrs_noc_ext2
DateTime	ldt_fec_desde			

if al_row = 0 then return

ls_codtra 		= dw_master.object.cod_trabajador[al_row]
ld_fec_mov 		= Date(dw_master.object.fec_movim[al_row])
ldt_fec_desde 	= DateTime(dw_master.object.fec_desde[al_row])
ls_turno	 		= dw_master.object.turno			[al_row]
ls_tipo_mov 	= dw_master.object.cod_tipo_mov	[al_row]

select hor_diu_nor, HOR_EXT_DIU_1, HOR_EXT_DIU_2,
		 hor_noc_nor, HOR_EXT_noc_1, HOR_EXT_noc_2
into  :ldc_hrs_diu_nor, :ldc_hrs_diu_ext1, :ldc_hrs_diu_ext2, 
		:ldc_hrs_noc_nor, :ldc_hrs_noc_ext1, :ldc_hrs_noc_ext2		 
from asistencia
where cod_trabajador = :ls_codtra
  and fec_movim		= :ld_fec_mov
  and turno				= :ls_turno
  and cod_tipo_mov	= :ls_tipo_mov
  and fec_desde		= :ldt_fec_desde;

if SQLCA.SQLCode = 100 then
	ldc_hrs_diu_nor 	= 0
	ldc_hrs_diu_ext1 	= 0
	ldc_hrs_diu_ext2 	= 0
	ldc_hrs_noc_nor	= 0
	ldc_hrs_noc_ext1	= 0
	ldc_hrs_noc_ext2	= 0
end if

dw_master.object.hor_diu_nor	[al_row] = ldc_hrs_diu_nor
dw_master.object.hor_ext_diu_1[al_row] = ldc_hrs_diu_ext1
dw_master.object.hor_ext_diu_2[al_row] = ldc_hrs_diu_ext2
dw_master.object.hor_noc_nor	[al_row] = ldc_hrs_noc_nor
dw_master.object.hor_ext_noc_1[al_row] = ldc_hrs_noc_ext1
dw_master.object.hor_ext_noc_2[al_row] = ldc_hrs_noc_ext2


		 

end event

event ue_copiar();//Ventana para copiar
Date		ld_fecha1, ld_fecha2
String	ls_ot_adm
str_parametros	lstr_param

ld_Fecha1 = uo_fechas.of_get_fecha1()
ld_Fecha2 = uo_fechas.of_get_fecha2()

IF NOT of_verificar() THEN RETURN

if trim(sle_ot.text) = '' then
	ls_ot_adm = "%%"	
ELSE	
	ls_ot_adm = trim(sle_ot.text) + "%"	
end if

lstr_param.date1 		= ld_fecha1
lstr_param.date2 		= ld_fecha2
lstr_param.string1 	= ls_ot_adm
lstr_param.string2 	= is_cod_origen
lstr_param.dw_m		= dw_master

OpenWithParm(w_select_fecha, lstr_param)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm

if not lstr_param.b_Return then return




end event

event type integer ue_importar_xls(string as_file);oleobject excel
integer	li_i, li_borrar_anterior
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns, ll_fila1, ll_row
boolean 	lb_cek
String 	ls_cellValue , ls_nomcol, ls_codigo

String	ls_cod_trabajador, ls_dni, ls_nom_trabajador, ls_fecha, ls_hora_ent, ls_hora_sal, &
			ls_hrs_nor, ls_hrs_25, ls_hrs_35, ls_hrs_100, ls_ot_adm, ls_cod_labor, ls_mov_asist, &
			ls_turno, ls_labor, ls_mensaje, ls_fecha_hora, ls_hrs_noc_nor, ls_hrs_noc_25, &
			ls_hrs_noc_35, ls_origen, ls_oper_sec, ls_nro_ot, ls_turno_td, ls_fecha_ing, ls_fecha_sal
			
date		ld_fec_movim
DateTime	ldt_hora_ent, ldt_hora_sal, ldt_hora1, ldt_hora2
Decimal	ldc_tiempo, ldc_acum_tiempo, ldc_prom_tiempo, ldc_time_left, ldc_hrs_nor, ldc_hrs_25, &
			ldc_hrs_35, ldc_hrs_100, ldc_hrs_noc_nor, ldc_hrs_noc_25, ldc_hrs_noc_35

oleobject  lole_workbook, lole_worksheet

try 
	
	if not(FileExists( as_file )) then
		messagebox('Excel','Archivo ' + as_file + ' no existe o no se tiene acceso, por favor verifique!', StopSign!) 
		return -1
	end if 
	
	cb_importar.enabled = false
	
	ls_turno_td = gnvo_app.of_get_parametro("TURNO_MANAÑA", "TD")
	
	excel = create oleobject;
	
	//Inicializamos todo
	hpb_progreso.visible = true
	st_texto.visible = true
	st_texto.text = ''
	hpb_progreso.position = 0
	st_left_time.visible = true
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o cnfigurado el MS.Excel, por favor verifique!',exclamation!)
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
	
	
	
	ls_mov_asist 	= gnvo_app.of_get_parametro("MOV_ASISTENCIA_NORMAL", '01')
	
	li_borrar_anterior = MEssageBox('Aviso', 'Desea que esta asistencia reemplace la ' &
											+ 'asistencia anterior?', Information!, Yesno!, 2) 
	
	
	ldc_acum_tiempo = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		ldt_hora1 = gnvo_app.of_fecha_actual()
		
		ls_dni				= String(lole_worksheet.cells(ll_fila1,1).value) 
		ls_nom_trabajador	= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_fecha				= String(lole_worksheet.cells(ll_fila1,3).value)
		ls_hora_ent			= String(lole_worksheet.cells(ll_fila1,4).value)  
		ls_hora_sal			= String(lole_worksheet.cells(ll_fila1,5).value) 
		ls_hrs_nor			= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_hrs_25			= String(lole_worksheet.cells(ll_fila1,7).value) 
		ls_hrs_35			= String(lole_worksheet.cells(ll_fila1,8).value) 
		ls_hrs_100			= String(lole_worksheet.cells(ll_fila1,9).value) 
		ls_hrs_noc_nor		= String(lole_worksheet.cells(ll_fila1,10).value) 
		ls_hrs_noc_25		= String(lole_worksheet.cells(ll_fila1,11).value) 
		ls_hrs_noc_35		= String(lole_worksheet.cells(ll_fila1,12).value)
		ls_turno				= String(lole_worksheet.cells(ll_fila1,13).value)
		ls_ot_adm			= String(lole_worksheet.cells(ll_fila1,14).value) 
		ls_labor				= String(lole_worksheet.cells(ll_fila1,15).value) 
		ls_origen			= String(lole_worksheet.cells(ll_fila1,16).value) 
		ls_oper_sec			= String(lole_worksheet.cells(ll_fila1,18).value) 
		
		//Primero Valido el Dni del trabajador
		If IsNull(ls_dni) or trim(ls_dni) = '' then
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'No ha especificado Documento de Identidad en el registro ' + string(ll_fila1) + ' no existe en el maestro de trabajadores, por favor corrija')
			continue
		end if
		
		select cod_trabajador, nom_trabajador
			into :ls_cod_trabajador, :ls_nom_trabajador
		from vw_pr_trabajador m
		where m.nro_doc_ident_rtps = :ls_dni;
		
		if SQLCA.SQLCode = 100 then
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'El Documento de Indentidad ' + ls_dni + ' del registro ' + string(ll_fila1) + ' no existe en el maestro de trabajadores, por favor corrija')
			continue
		end if
		
		ls_fecha = trim(left(ls_fecha, 10))
		
		//Hora de ingreso
		ls_fecha_ing = ls_fecha + ' ' + ls_hora_ent
		
		//Hora de salida
		ls_fecha_sal = ls_fecha + ' ' + ls_hora_sal
		
		//FEcha de movimiento
		select trunc(to_date(:ls_fecha, 'dd/mm/yyyy')), to_date(:ls_fecha_ing, 'dd/mm/yyyy hh24:mi'), to_date(:ls_fecha_sal, 'dd/mm/yyyy hh24:mi')
			into :ld_fec_movim, :ldt_hora_ent, :ldt_hora_sal
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al procesar la fecha ' + ls_fecha + ' en el registro: ' + string(ll_fila1) + '. Mensaje: ' + ls_mensaje, StopSign!)
			return -1
		end if

		//Valido el origen
		if IsNull(ls_origen) or ls_origen = '' then
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'El Documento de Indentidad ' + ls_dni + ' del registro ' + ls_nom_trabajador + ' no tiene ORIGEN, por favor corrija')
			continue
		end if
		
		select count(*)
		  into :ll_count
		from origen
		where cod_origen = :ls_origen
		  and flag_estado = '1';
		
		if ll_count = 0 then
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'El Origen ' + ls_origen + ' del registro ' + ls_nom_trabajador + ' no existe, por favor corrija')
			continue
		end if
		
		//Valido el turno
		if ISNull(ls_turno) or trim(ls_turno) = '' then
			ls_turno			= ls_turno_td
		end if
		
		select count(*)
		  into :ll_count
		from turno
		where turno = :ls_turno;
		
		if ll_count = 0 then
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'El Turno ' + ls_turno + ' del registro ' + string(ll_fila1) + ' no existe, por favor corrija')
			continue
		end if
		
		
		
		
		//COnvierto las horas en decimales
		ldc_hrs_nor			= Dec(ls_hrs_nor)
		ldc_hrs_25			= Dec(ls_hrs_25)
		ldc_hrs_35			= Dec(ls_hrs_35)
		ldc_hrs_100			= Dec(ls_hrs_100)
		ldc_hrs_noc_nor	= Dec(ls_hrs_noc_nor)
		ldc_hrs_noc_25		= Dec(ls_hrs_noc_25)
		ldc_hrs_noc_35		= Dec(ls_hrs_noc_35)
		
		if IsNull(ldc_hrs_nor) then ldc_hrs_nor = 0
		if IsNull(ldc_hrs_25) then ldc_hrs_25 = 0
		if IsNull(ldc_hrs_35) then ldc_hrs_35 = 0
		if IsNull(ldc_hrs_100) then ldc_hrs_100 = 0
		if IsNull(ldc_hrs_noc_nor) then ldc_hrs_noc_nor = 0
		if IsNull(ldc_hrs_noc_25) then ldc_hrs_noc_25 = 0
		if IsNull(ldc_hrs_noc_35) then ldc_hrs_noc_35 = 0
		
		//Valido la cantidad de horas
		if ldc_hrs_nor + ldc_hrs_25 + ldc_hrs_35 + ldc_hrs_noc_nor + ldc_hrs_noc_25 + ldc_hrs_noc_35 + ldc_hrs_100 = 0 then
			gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'El registro ' + string(ll_row) +  ' correspondiente al trabajador ' + ls_nom_trabajador + ' no tiene horas asignadas, por favor corrija')
			continue
		end if
		
		//Valido si tiene orden de trabajo
		if IsNull(ls_oper_sec) and trim(ls_oper_sec) = '' then
			if not IsNull(ls_ot_adm) and trim(ls_ot_adm) <> '' and &
				not IsNull(ls_cod_labor) and trim(ls_cod_labor) <> '' then
				
				//Valido el OT_ADM
				select count(*)
				  into :ll_count
				from ot_administracion
				where ot_adm = :ls_ot_adm
				  and flag_estado = '1';
				
				if ll_count = 0 then
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'El OT_ADM ' + ls_ot_adm + ' del registro ' + ls_nom_trabajador + ' no existe o no se encuentra activo, por favor corrija')
					continue
				end if

				//Valido la labor
				select count(*)
				  into :ll_count
				from labor
				where cod_labor = :ls_cod_labor
				  and flag_estado = '1';
				
				if ll_count = 0 then
					gnvo_app.of_add_mensaje_error( ll_fila1, "ue_importar_xls", "PR310", 'La LABOR ' + ls_cod_labor + ' del registro ' + ls_nom_trabajador + ' no existe o no se encuentra activo, por favor corrija')
					continue
				end if
				
				//Busco el opersec
				select op.oper_sec, op.nro_orden
					into :ls_oper_sec, :ls_nro_ot
				from operaciones op,
					  orden_trabajo ot
				where op.nro_orden = ot.nro_orden
				  and op.flag_estado = '1'
				  and op.cod_labor	= :ls_cod_labor
				  and ot.ot_adm		= :ls_ot_adm
				order by ot.nro_orden desc;
       		
				if SQLCA.SQLCode = 100 then
					MessageBox('Error', 'Error en registro ' + string(ll_row) &
										   + ' correspondiente al trabajador ' + ls_nom_trabajador &
										   + ', no existe una operacion de OT aprobada, por favor corrija.'&
											+ '~r~nOT_ADM: ' + ls_ot_adm &
											+ '~r~nCOD_LABOR: ' + ls_cod_labor &
											, StopSign!)
					continue
				end if
				 
				
			end if
		end if
		
		// Si desea eliminar la asistencia anterior entonces la elimino
		if li_borrar_Anterior = 1 then
			//Verifico si el registro ya existe
			delete asistencia a
			where a.cod_trabajador 	= :ls_cod_trabajador
			  and trunc(fec_movim)	= trunc(:ld_fec_movim);
		end if
		
		//Verifico si el registro ya existe
		select count(*) 
			into :ll_count
		from asistencia a
		where a.cod_trabajador 	= :ls_cod_trabajador
		  and trunc(fec_movim)	= trunc(:ld_fec_movim)
		  and turno					= :ls_turno
		  and cod_tipo_mov		= :ls_mov_Asist
		  and fec_desde			= :ldt_hora_ent;
		
		if ll_count = 0 then
			//Inserto el registro de la asistencia
			insert into asistencia(
				cod_trabajador, fec_movim, cod_tipo_mov, fec_desde, fec_hasta, cod_usr,
				cod_origen, ot_adm, hor_diu_nor, hor_ext_diu_1, hor_ext_diu_2, hor_ext_100, 
				hor_noc_nor, hor_ext_noc_1, hor_ext_noc_2, oper_sec, turno)
			values(
				:ls_cod_trabajador, :ld_fec_movim, :ls_mov_asist, :ldt_hora_ent, :ldt_hora_sal, :gs_user,
				:ls_origen, :ls_ot_adm, :ldc_hrs_nor, :ldc_hrs_25, :ldc_hrs_35, :ldc_hrs_100,
				:ldc_hrs_noc_nor, :ldc_hrs_noc_25, :ldc_hrs_noc_35, :ls_oper_sec, :ls_turno);
			
			if SQLCA.SQLCode = -1 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al insertar asistencia del Trabajador: ' + ls_dni &
										+ ' del registro ' + ls_nom_trabajador &
										+ '~r~nFecha Asistencia: ' + ls_fecha &
										+ '~r~nMensaje deError: ' + ls_mensaje + ', por favor corrija', StopSign!)
				continue
			end if
			
		else
			
			//Actualizo los datos que se necesitan
			update asistencia a
				set 	fec_hasta 		= :ldt_hora_sal,
						ot_adm			= :ls_ot_adm,
						hor_diu_nor		= :ldc_hrs_nor,
						hor_ext_diu_1	= :ldc_hrs_25,
						hor_ext_diu_2	= :ldc_hrs_35,
						hor_ext_100		= :ldc_hrs_100,
						hor_noc_nor		= :ldc_hrs_noc_nor,
						hor_ext_noc_1	= :ldc_hrs_noc_25,
						hor_ext_noc_2	= :ldc_hrs_noc_35,
						oper_sec			= :ls_oper_sec,
						turno				= :ls_turno
			where a.cod_trabajador 	= :ls_cod_trabajador
		  	  and trunc(fec_movim)	= trunc(:ld_fec_movim)
		  	  and turno					= :ls_turno
		  	  and cod_tipo_mov		= :ls_mov_Asist
		  	  and fec_desde			= :ldt_hora_ent;

			if SQLCA.SQLCode = -1 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al actualizar asistencia del Trabajador: ' + ls_dni &
										+ ' del registro ' + ls_nom_trabajador &
										+ '~r~nFecha Asistencia: ' + ls_fecha &
										+ '~r~nMensaje deError: ' + ls_mensaje + ', por favor corrija', StopSign!)
				continue
			end if
			
		end if
		
		commit;
		
		//Inserto en el datawindow
		/*
		ll_row = dw_master.event ue_insert( )
		
		if ll_row > 0 then
			dw_master.object.cod_trabajador 	[ll_Row] = ls_cod_trabajador
			dw_master.object.nom_trabajador 	[ll_Row] = ls_nom_trabajador
			dw_master.object.turno 				[ll_Row] = ls_turno
			dw_master.object.fec_movim			[ll_Row] = ld_fec_movim
			dw_master.object.ot_adm 			[ll_Row] = ls_ot_adm
			dw_master.object.fec_desde		 	[ll_Row] = ldt_hora_ent
			dw_master.object.fec_hasta		 	[ll_Row] = ldt_hora_sal
			dw_master.object.hor_diu_nor		[ll_Row] = Dec(ls_hrs_nor)
			dw_master.object.hor_ext_diu_1	[ll_Row] = Dec(ls_hrs_25)
			dw_master.object.hor_ext_diu_2	[ll_Row] = Dec(ls_hrs_35)
			dw_master.object.hor_ext_100		[ll_Row] = Dec(ls_hrs_100)
			dw_master.object.horas_trab		[ll_Row] = Dec(ls_hrs_nor) + Dec(ls_hrs_25) + Dec(ls_hrs_35) + Dec(ls_hrs_100)
		end if
		*/
		
		ldt_hora2 = gnvo_app.of_fecha_actual()
		
		//Obtengo el tiempo que ha pasado entre ambos registros
		select (:ldt_hora2 - :ldt_hora1) * 24 * 60 * 60
			into :ldc_tiempo
		from dual;
		
		//El tiempo obtenido es de 
		ldc_acum_tiempo += ldc_tiempo
		ldc_prom_tiempo = ldc_acum_tiempo / (ll_fila1 - 1)
		
		//Obtengo el tiempo que queda
		ldc_time_left = (ll_max_rows - ll_fila1) * ldc_prom_tiempo
		
		//Actualizo la barra de progreso
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_left_time.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas. Tiempo : "  + string(ldc_prom_tiempo, '###,##0.0000')+ " Seg. "
		
		if ldc_time_left > 0 then
			//Agrego el tiempo que queda, en dias, horas, minutos y segundos
			st_left_time.Text += " - " + gnvo_app.utilitario.of_left_time_to_string(ldc_time_left)
		end if
		
		yield()		
	next
	

	

	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique y luego proceselo!", "")
	
	
	
	RETURN 1
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) then
		if IsValid(excel) then
			excel.application.quit
			excel.disconnectobject()
		end if
		destroy excel;
	end if
	
	hpb_progreso.visible = false
	st_texto.visible = false
	st_texto.text = ''
	cb_importar.enabled = true
	st_left_time.visible = false
	
end try

end event

event ue_procesar();
Long ll_i

try 
	invo_wait.of_mensaje("Calculando las horas de jornal, por favor espere")
	
	if not of_calc_hrs_jornal( ) then 
		ROLLBACK;
		return
	end if
	
	COMMIT using SQLCA;
		
	hpb_progreso.minposition = 1
	hpb_progreso.maxposition = dw_master.RowCount()
	hpb_progreso.position = 0
	hpb_progreso.visible = true
	st_procesando.visible = true
	
	for ll_i = 1 to dw_master.RowCount()
		hpb_progreso.position = ll_i
		this.event ue_retrieve_hrs_row( ll_i )
	next
	hpb_progreso.visible = false
	st_procesando.visible = false
		
		
		
	
catch ( Exception ex)
	/*statementBlock*/
finally
	invo_wait.of_close()
end try

end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i
String 	ls_separador
boolean	lb_ok

is_cod_origen = ''
ls_separador  = ''
lb_ok			  = True

// leer el dw_origen con los origenes seleccionados

For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Producción', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF

RETURN lb_ok
end function

public subroutine of_set_modify ();//idw_1.Modify("trabajador.Background.Color ='" + string(RGB(255,0,0)) + " ~t If(isnull(idw_1.object.fec_desde) = ~~'C~~'')
end subroutine

public function boolean of_getparam ();select MOV_ASIST_NOR
	into :is_asist_normal
from asistparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox("Error", "no ha especificado los parámetros de Asistencia")
	return false
end if

if is_asist_normal = "" or IsNull(is_asist_normal) then
	MessageBox("Error", "no ha especificado los parámetros de Asistencia")
	return false
end if

return true
end function

public function integer of_horas_trab (long al_row);dateTime 	ldt_fec_desde, ldt_fec_hasta
Decimal		ldc_horas
String		ls_mensaje

if al_row = 0 then return -1

ldt_fec_desde = dateTime(dw_master.Object.fec_desde [al_row])
ldt_fec_hasta = dateTime(dw_master.Object.fec_hasta [al_row])

select :ldt_fec_hasta - :ldt_fec_desde
	into :ldc_horas
from dual;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al encontrar diferencia de horas de entrada y salida. Mensaje: ' + ls_mensaje, StopSign!)
	return -1
end if

dw_master.object.horas_trab [al_row] = ldc_horas * 24


//MessageBox('', Dec(ll_segundos) / 3600)
return ldc_horas
end function

public function boolean of_calc_hrs_jornal ();String	ls_mensaje
Date		ld_fecha1, ld_fecha2
long		ll_row, ll_i

if dw_master.RowCount() = 0 then return true
ll_row = dw_master.getRow()

ld_fecha1 = Date(dw_master.object.fec_movim[1])
ld_fecha2 = Date(dw_master.object.fec_movim[1])

for ll_i = 1 to dw_master.RowCount()
	if Date(dw_master.object.fec_movim[ll_i]) < ld_fecha1 then
		ld_fecha1 = Date(dw_master.object.fec_movim[ll_i])
	end if
	if Date(dw_master.object.fec_movim[ll_i]) > ld_fecha2 then
		ld_fecha2 = Date(dw_master.object.fec_movim[ll_i])
	end if

next

//create or replace procedure USP_RH_HORAS_ASISTENCIA(
//       adi_fecha1 IN DATE,
//       adi_fecha2 IN DATE
//       
//) IS


DECLARE 	USP_RH_HORAS_ASISTENCIA PROCEDURE FOR
			USP_RH_HORAS_ASISTENCIA( :ld_fecha1,
											 :ld_fecha2);
EXECUTE 	USP_RH_HORAS_ASISTENCIA ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_RH_HORAS_ASISTENCIA: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE USP_RH_HORAS_ASISTENCIA;

//uo_fechas.of_set_fecha( ld_fecha1, ld_fecha2 )
//
//this.event ue_retrieve( )
//
//if dw_master.RowCount() >= ll_row then
//	dw_master.Selectrow( ll_row, true)
//	dw_master.setRow(ll_row)
//	dw_master.ScrollToRow(ll_row)
//end if
//
return true



end function

public function boolean of_valida_fecha (u_dw_abc adw_1);Long 		ll_i, ll_row
string		ls_trabajador, ls_nombre
Boolean  ll_Result = True

ll_row = adw_1.RowCount()

if ll_row < 1 then Return ll_Result

For ll_i = 1 to ll_row
	  
	 if isnull(adw_1.object.fec_desde [ll_i]) or &
	    isnull(adw_1.object.fec_hasta [ll_i]) then
		 ll_Result = False
		 Messagebox('Aistencia','Existen Horas de Entrada o de Salida Sin definir. Porfavor Verifique', StopSign!)
		 Exit
	end if
next
		 
Return ll_Result
	 
end function

public function boolean of_validar_registro (u_dw_abc adw_1);Long 				ll_i, ll_count
string			ls_trabajador, ls_nombre, ls_cod_trabajador, ls_turno, ls_tipo_mov
Date				ld_fec_movim
DateTime			ldt_fec_desde
dwItemStatus 	ldis_status 

if adw_1.RowCount() < 1 then Return true

For ll_i = 1 to adw_1.RowCount()
	  
	ldis_status = adw_1.GetItemStatus(ll_i, 0, Primary!)

	if ldis_status = NewModified! or ldis_status = New! then
		//PK = COD_TRABAJADOR, FEC_MOVIM, TURNO, COD_TIPO_MOV, FEC_DESDE
		
		ls_cod_trabajador = adw_1.object.cod_trabajador 		[ll_i]
		ld_fec_movim 		= Date(adw_1.object.fec_movim 		[ll_i])
		ls_turno 			= adw_1.object.turno 					[ll_i]
		ls_tipo_mov			= adw_1.object.cod_tipo_mov			[ll_i]
		ldt_fec_desde 		= DateTime(adw_1.object.fec_desde 	[ll_i])
		
	
		select count(*)
			into :ll_count
		from asistencia
		where cod_trabajador 	= :ls_cod_trabajador
			and trunc(fec_movim)	= trunc(:ld_fec_movim)
			and turno				= :ls_turno
			and cod_tipo_mov		= :ls_tipo_mov
			and fec_desde			= :ldt_fec_desde;
		
		if ll_count > 0 then
			Messagebox('Error','Registro ya se encuentra ingresado en la asistencia. Porfavor Verifique' &
						+ '~r~nCod Trabajador: ' + ls_cod_trabajador &
						+ '~r~nFec. Movim: ' + string(ld_fec_movim, 'dd/mm/yyyy') &
						+ '~r~nTurno: ' + ls_turno &
						+ '~r~nTipo Mov.: ' + ls_tipo_mov &
						+ '~r~nFec. Desde: ' + string(ldt_fec_desde, 'dd/mm/yyyy hh:mm:ss')	, StopSign!)
		 	return false
		end if
	end if
next
		 
Return true
	 
end function

on w_pr310_asistencia_jornal.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.hpb_progreso=create hpb_progreso
this.dw_origen=create dw_origen
this.sle_ot=create sle_ot
this.st_2=create st_2
this.sle_ot_d=create sle_ot_d
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.sle_cod_tra=create sle_cod_tra
this.sle_nom_tra=create sle_nom_tra
this.st_1=create st_1
this.st_procesando=create st_procesando
this.cb_copiar=create cb_copiar
this.cb_importar=create cb_importar
this.st_texto=create st_texto
this.st_left_time=create st_left_time
this.cb_procesar=create cb_procesar
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.dw_origen
this.Control[iCurrent+3]=this.sle_ot
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_ot_d
this.Control[iCurrent+6]=this.cb_buscar
this.Control[iCurrent+7]=this.uo_fechas
this.Control[iCurrent+8]=this.sle_cod_tra
this.Control[iCurrent+9]=this.sle_nom_tra
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_procesando
this.Control[iCurrent+12]=this.cb_copiar
this.Control[iCurrent+13]=this.cb_importar
this.Control[iCurrent+14]=this.st_texto
this.Control[iCurrent+15]=this.st_left_time
this.Control[iCurrent+16]=this.cb_procesar
this.Control[iCurrent+17]=this.gb_2
end on

on w_pr310_asistencia_jornal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.dw_origen)
destroy(this.sle_ot)
destroy(this.st_2)
destroy(this.sle_ot_d)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.sle_cod_tra)
destroy(this.sle_nom_tra)
destroy(this.st_1)
destroy(this.st_procesando)
destroy(this.cb_copiar)
destroy(this.cb_importar)
destroy(this.st_texto)
destroy(this.st_left_time)
destroy(this.cb_procesar)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

invo_wait = create n_cst_wait

ii_lec_mst = 0

if not of_getparam() then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_copia = 0

//dw_asist_anterior.settransobject( sqlca )

// Para mostrar los origenes
dw_origen.SetTransObject( sqlca )
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

if ll_row > 0 then dw_origen.object.chec[ll_row] = '1'


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = false


if gnvo_app.of_row_processing( dw_master ) = false then return

dw_master.of_set_flag_replicacion( )
ib_update_check = true
end event

event ue_update;//Override

Boolean  lbo_ok = TRUE
String	ls_msg
Date		ld_fecha1, ld_fecha2
Long		ll_i

dw_master.AcceptText()

if of_valida_fecha( idw_1 ) = False then Return
if of_validar_registro( idw_1 ) = False then Return


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_Create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ResetUpdate()
	
	f_mensaje("Cambios guardados satisfactoriamente", "")
	
	if MessageBox('Error', 'Desea realizar el proceso de distribucion de horas?.' &
							+ '~r~nTenga cuidado que si ha ingresado horas manualmente, perdera todos los cambios', &
							Information!, YesNo!, 2) = 1 then 
		event ue_procesar()
	end if
END IF

end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_open_pos;call super::ue_open_pos;m_mantto_smpl m_1

m_1 = this.menuid

m_1.m_file.m_basedatos.m_anular.enabled = false
m_1.m_file.m_basedatos.m_anular.visible = false
m_1.m_file.m_basedatos.m_anular.toolbaritemvisible = false
end event

event ue_query_retrieve;//Override
this.event ue_retrieve( )
end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_master, ls_file )
End If
end event

event close;call super::close;destroy invo_wait
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr310_asistencia_jornal
event ue_display ( string as_columna,  long al_row )
integer y = 448
integer width = 3566
integer height = 1260
string dataobject = "d_asistencia_tbl"
end type

event dw_master::ue_display;string 	ls_sql, ls_return1, ls_return2, ls_ot_adm, ls_nro_ot, ls_return3
DATE   	ld_fec_desde, ld_fec_hasta, ld_null
INTEGER 	ld_dias

if dw_master.ii_protect = 1 then return

choose case lower(as_columna)

	case 'cod_trabajador'
		ls_sql = "select m.cod_trabajador as codigo_trabajador, " &
				 + "m.nom_trabajador as nom_trabajador, " &
				 + "m.nro_doc_ident_rtps as nro_dni " &
				 + "from vw_pr_trabajador m " &
				 + "where m.flag_estado = '1' " &
				 + "and m.tipo_trabajador in ('EJO', 'JOR', 'PRA', 'EVE')"
				 
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, '2') then return
		
		this.object.cod_trabajador			[al_row] = ls_return1
		this.object.nom_trabajador			[al_row] = ls_return2
		this.object.nro_doc_ident_rtps	[al_row] = ls_return3
		
		ii_update = 1
		return 
				
	case 'turno'
		ls_sql = "SELECT turno as Codigo, " &
				 + "descripcion as descripcion " &
				 + "FROM turno " &
			  	 + "WHERE flag_estado = '1'"
					
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1)  = '' then return
		this.object.turno			[al_row] = ls_return1
		this.object.desc_turno	[al_row] = ls_return2
		ii_update = 1
		return 
	
	case 'ot_adm'
		ls_sql = "SELECT O.OT_ADM AS CODIGO, " &
				 + "O.DESCRIPCION AS DESCRIPCIÓN " &
				 + "FROM OT_ADMINISTRACION O, " &
				 + "OT_ADM_USUARIO P " &
				 + "WHERE O.OT_ADM = P.OT_ADM " &
				 + "AND P.COD_USR = '" + gs_user + "'"
				 
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.ot_adm		[al_row] = ls_return1
		this.object.desc_ot_adm	[al_row] = ls_return2
		ii_update = 1
		return 
		
	case 'cod_tipo_mov'
		ls_sql = "select cod_tipo_mov as codigo, " &
				 + "desc_movimi as descripción " &
				 + "from tipo_mov_asistencia "
				 
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.cod_tipo_mov		[al_row] = ls_return1
		this.object.desc_movimiento	[al_row] = ls_return2
		ii_update = 1
		return 
	
	case "nro_orden"
		ls_ot_adm = this.object.ot_adm[al_row]
		
		if ls_ot_adm = "" or IsNull(ls_ot_adm) then
			MessageBox("Error", "Debe Definir primeramente un OT_ADM")
			setColumn("OT_ADM")
			return
		end if
		
		ls_sql = "Select distinct ot.nro_orden as numero_OT, " &
			    + "ot.descripcion as descripcion_ot " &
				 + "FROM Orden_trabajo OT, " &
				 + "OPERACIONES op " &
				 + "where op.nro_orden = ot.nro_orden " &
				 + "and op.flag_estado = '1' " &
				 + "and ot.ot_adm = '" + ls_ot_adm + "'"
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.nro_orden		[al_row] = ls_return1
		ii_update = 1
		return 
	
	case "oper_sec"
		ls_nro_ot = this.object.nro_orden[al_row]
		
		if ls_nro_ot = "" or IsNull(ls_nro_ot) then
			MessageBox("Error", "Debe Definir primeramente un Número de OT")
			setColumn("nro_orden")
			return
		end if
		
		ls_sql = "Select op.oper_sec as oper_sec, " &
			    + "op.desc_operacion as descripcion_operacion " &
				 + "FROM OPERACIONES op " &
				 + "where op.nro_orden = '" + ls_nro_ot + "' " &
				 + "and op.flag_estado = '1' " 
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.oper_sec		[al_row] = ls_return1
		ii_update = 1
		return 
		
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fecha
string 	ls_desc

this.object.cod_usr		[al_row] = gs_user
this.object.cod_origen	[al_row] = gs_origen
this.object.cod_tipo_mov[al_row] = is_asist_normal

select desc_movimi
	into :ls_desc
from tipo_mov_asistencia
where cod_tipo_mov = :is_asist_normal;

this.object.desc_movimiento[al_row] = ls_desc

if al_row = 1 then
	//Si es el primer registro entonces le coloco algunos datos por defecto
	ldt_fecha = gnvo_app.of_fecha_actual()
	
	this.object.fec_movim			[al_row] 		= Date(ldt_fecha)
	this.object.fec_desde			[al_row] 		= ldt_fecha
	this.object.fec_hasta			[al_row] 		= ldt_fecha
else
	//De lo contrario datos del registro anterior
	this.object.fec_movim			[al_row] 		= Date(this.object.fec_movim			[al_row - 1])
	this.object.fec_desde			[al_row] 		= this.object.fec_desde			[al_row - 1] 
	this.object.fec_hasta			[al_row] 		= this.object.fec_hasta			[al_row - 1] 
	this.object.ot_adm				[al_row] 		= this.object.ot_adm				[al_row - 1]
	this.object.desc_ot_adm			[al_row] 		= this.object.desc_ot_adm		[al_row - 1]
	this.object.turno					[al_row] 		= this.object.turno				[al_row - 1]
	this.object.desc_turno			[al_row] 		= this.object.desc_turno		[al_row - 1]
	this.object.cod_tipo_mov		[al_row] 		= this.object.cod_tipo_mov		[al_row - 1] 
	this.object.desc_movimiento	[al_row] 		= this.object.desc_movimiento	[al_row - 1]
	this.object.nro_orden			[al_row] 		= this.object.nro_orden			[al_row - 1] 
	this.object.oper_sec				[al_row] 		= this.object.oper_sec			[al_row - 1]

end if

this.object.HOR_DIU_NOR			[al_row] = 0.00
this.object.HOR_NOC_NOR			[al_row] = 0.00
this.object.HOR_EXT_DIU_1		[al_row] = 0.00
this.object.HOR_EXT_DIU_2		[al_row] = 0.00
this.object.HOR_EXT_NOC_1		[al_row] = 0.00
this.object.HOR_EXT_NOC_2		[al_row] = 0.00
this.object.HOR_EXT_100			[al_row] = 0.00

this.object.IMP_HOR_DIU_NOR	[al_row] = 0.00
this.object.IMP_HOR_DIU_EXT1	[al_row] = 0.00
this.object.IMP_HOR_DIU_EXT2	[al_row] = 0.00
this.object.IMP_HOR_NOC_NOR	[al_row] = 0.00
this.object.IMP_HOR_NOC_EXT1	[al_row] = 0.00
this.object.IMP_HOR_NOC_EXT2	[al_row] = 0.00
this.object.IMP_HOR_EXT_100	[al_row] = 0.00

of_horas_trab(al_row)

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_col, ls_data, ls_ot_adm, ls_nro_ot, ls_codigo, ls_cod_trabajador, ls_nro_doc_ident_rtps
date 		ld_fec_desde, ld_fec_hasta
integer 	ld_dias
long		ll_segundos, ll_8_horas
datetime ld_fec_desde_dt, ld_fec_hasta_dt
time 		lt_hora, lt_hora2

ls_col = trim(lower(string(dwo.name)))

this.accepttext()

ll_8_horas = 3600 * 8

choose case ls_col

	case 'cod_trabajador'
		ls_codigo = trim(data)
		
		if len(ls_codigo) < 8 then
			ls_codigo = '%' + ls_codigo
		end if
		
		select m.cod_trabajador, m.nom_trabajador, m.nro_doc_ident_rtps
		   into :ls_cod_trabajador, :ls_data, :ls_nro_doc_ident_rtps
			from 	vw_pr_trabajador m
			where m.cod_trabajador like :ls_codigo
				and m.flag_estado = '1'
				and m.cod_origen = :gs_origen
				and m.tipo_trabajador in ('EJO', 'JOR', 'PRA', 'EVE');
			
		if SQLCA.SQLCode = 100 then
			messagebox(parent.title, 'No existe código de trabajador ' + trim(data) &
										  + ', no está activo, no pertenece al origen ' &
										  + gs_origen + ', o no es un trabajador de TIPO EJO, PRA o JOR', StopSign!)
			this.object.cod_trabajador		[row] = gnvo_app.is_null
			this.object.nom_trabajador		[row] = gnvo_app.is_null
			this.object.nro_doc_ident_rtps[row] = gnvo_app.is_null
			return
		end if
		
		this.object.cod_trabajador			[row] = ls_cod_trabajador
		this.object.nom_trabajador			[row] = ls_data
		this.object.nro_doc_ident_rtps	[row] = ls_nro_doc_ident_rtps
		
		this.setColumn('turno')
		
		return 2
	
	case 'turno'
		select descripcion
			into :ls_data
		from turno
		where turno = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox(parent.Title, "No existe código de turno")
			this.object.turno 		[row] = gnvo_app.is_null
			this.object.desc_turno 	[row] = gnvo_app.is_null
			return
		end if
		
		this.object.desc_turno [row] = ls_data
		return 2
	
	case 'ot_adm'
		select descripcion
			into :ls_data
		from ot_administracion
		where ot_adm = :data;
		
		if SQLCA.SQLCOde = 100 then
			MessageBox(parent.title, "No existe código de ot_adm")
			this.object.ot_adm 		[row] = gnvo_app.is_null
			this.object.desc_ot_adm [row] = gnvo_app.is_null
			return
		end if
		
		this.object.desc_ot_adm [row] = ls_data
		return 2

	case 'cod_tipo_mov'
		select desc_movimi 
		   into :ls_data
			from tipo_mov_asistencia
			where cod_tipo_mov = :data;
				
		if SQLCA.SQLCode = 100 then
			messagebox(parent.title, 'No existe código tipo de asistencia')
			this.object.cod_tipo_mov		[row] = gnvo_app.is_null
			this.object.desc_movimiento	[row] = gnvo_app.is_null
			return
		end if
		
		this.object.desc_movimiento	[row] = ls_data
		
		return 2
		
	case "fec_movim"
		ld_fec_desde = Date(This.Object.fec_movim [row])
		This.Object.fec_desde [row] = ld_fec_desde
		This.Object.fec_hasta [row] = gnvo_app.id_null
		
	CASE "fec_desde"
		
		ld_fec_desde = Date(This.Object.fec_desde [row])
		lt_hora		 = Time(This.Object.fec_desde [row])
		
		//hay que ver si existen segundos adecuados 
		ll_segundos = SecondsAfter(lt_hora, 23:59:59)
		
		if ll_segundos > ll_8_horas then
			lt_hora2 = RelativeTime(lt_hora, ll_8_horas)
			ld_fec_hasta = ld_fec_desde
		else
			lt_hora2 = RelativeTime(00:00:00, ll_8_horas - ll_segundos)
			ld_fec_hasta = RelativeDate(ld_fec_desde, 1)
		end if
		
		This.Object.fec_hasta [row] = DateTime(ld_fec_hasta, lt_hora2)
		
		of_horas_trab(row)
		
		
	CASE "fec_hasta"
		
		ld_fec_desde = Date(This.Object.fec_desde [row])
		ld_fec_hasta = Date(This.Object.fec_hasta [row])
		ld_dias      = DaysAfter(ld_fec_desde, ld_fec_hasta)

		if isNull(ld_fec_desde) or isNull(ld_fec_hasta) then
			return
		end if
		
		if ld_dias > 1 or ld_dias < 0 then
			SetNull(gnvo_app.id_null)
			Messagebox('Error', 'La Diferencia de Días es Mayor a 1 o Negativa. ¡Verifique!')
			This.Object.fec_hasta[row] = gnvo_app.id_null
			of_horas_trab(row)
			Return 2
		end if

		ld_fec_desde_dt = This.Object.fec_desde [row]
		ld_fec_hasta_dt = This.Object.fec_hasta [row]
		
		IF ld_fec_hasta_dt < ld_fec_desde_dt THEN
			SetNull(gnvo_app.id_null)
			messagebox('Error', 'Inconsistencia en las fechas')
			This.Object.fec_hasta[row] = gnvo_app.id_null
			of_horas_trab(row)
			RETURN 2
		END IF
		
		of_horas_trab(row)
		
	case "nro_orden"
		ls_ot_adm = this.object.ot_adm[row]
		if ls_ot_adm = "" or IsNull(ls_ot_adm) then
			MessageBox("Error", "Debe Definir primeramente un OT_ADM")
			setColumn("OT_ADM")
			return
		end if
		
		Select ot.descripcion
			into :ls_data
		 FROM Orden_trabajo OT, 
		 		OPERACIONES op 
		 where op.nro_orden = ot.nro_orden 
		   and op.flag_estado = '1' 
		   and ot.ot_adm = :ls_ot_adm 
		   and ot.nro_orden = :data;
		
		if SQLCA.SQLCode = 100 then
			messagebox(parent.title, 'No existe NRO OT, por favor verifique')
			this.object.nro_orden		[row] = gnvo_app.is_null
			return
		end if
		
	
	case "oper_sec"
		ls_nro_ot = this.object.nro_orden[row]
		
		if ls_nro_ot = "" or IsNull(ls_nro_ot) then
			MessageBox("Error", "Debe Definir primeramente un Número de OT")
			setColumn("nro_orden")
			return
		end if
		
 		Select op.desc_operacion
			into :ls_data
		FROM OPERACIONES op
		where op.nro_orden = :ls_nro_ot
		  and op.oper_sec = :data
		  and op.flag_estado = '1';  
		
		if SQLCA.SQLCode = 100 then
			messagebox(parent.title, 'No existe OPER_SEC tipo de asistencia')
			this.object.oper_sec		[row] = gnvo_app.is_null
			return
		end if

	End choose
end event

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

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
end event

type hpb_progreso from hprogressbar within w_pr310_asistencia_jornal
boolean visible = false
integer x = 1746
integer y = 312
integer width = 1792
integer height = 64
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type dw_origen from u_dw_abc within w_pr310_asistencia_jornal
integer x = 846
integer y = 76
integer width = 859
integer height = 336
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ap_origen_liq_pesca_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type sle_ot from singlelineedit within w_pr310_asistencia_jornal
event dobleclick pbm_lbuttondblclk
integer x = 2039
integer y = 48
integer width = 288
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM AS CODIGO, O.DESCRIPCION AS DESCRIPCIÓN " &
				  + "FROM OT_ADMINISTRACION O, OT_ADM_USUARIO P " &
				  + "WHERE O.OT_ADM = P.OT_ADM " &
				  + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			
if ls_codigo <> '' then
	
	this.text= ls_codigo
	
	sle_ot_d.text = ls_data

end if


end event

event modified;String ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT descripcion INTO :ls_desc
FROM ot_administracion
WHERE ot_adm =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe')
	return
end if

sle_ot_d.text = ls_desc


end event

type st_2 from statictext within w_pr310_asistencia_jornal
integer x = 1765
integer y = 52
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "OT.Adm"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_ot_d from singlelineedit within w_pr310_asistencia_jornal
integer x = 2331
integer y = 48
integer width = 1170
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type cb_buscar from commandbutton within w_pr310_asistencia_jornal
integer x = 3538
integer y = 128
integer width = 571
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_retrieve( )

if dw_master.RowCount() > 0 then
	cb_procesar.enabled = true
else
	cb_procesar.enabled = false
end if
end event

type uo_fechas from u_ingreso_rango_fechas_v within w_pr310_asistencia_jornal
event destroy ( )
integer x = 110
integer y = 140
integer taborder = 50
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(date(f_fecha_actual()), - 7), date(f_fecha_actual())) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type sle_cod_tra from singlelineedit within w_pr310_asistencia_jornal
event dobleclick pbm_lbuttondblclk
integer x = 2039
integer y = 136
integer width = 288
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select cr.cod_relacion as codigo, " &
		 + "cr.nombre as trabajador " &
		 + "from codigo_relacion cr, " &
		 + "maestro m " &
		 + "where flag_tabla = 'M' "&
		 + "and m.cod_trabajador = cr.cod_relacion " &
		 + "and m.flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if isnull(ls_codigo) or trim(ls_data)  = '' then return
sle_cod_tra.text = ls_codigo
sle_nom_tra.text = ls_data

end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un código de trabajador')
	return
end if

SELECT apel_paterno || ' ' || apel_materno || ', ' || nombre1 
	INTO :ls_desc
FROM maestro
WHERE cod_trabajador =:ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Trabajador no existe')
	return
end if

sle_nom_tra.text = ls_desc


end event

type sle_nom_tra from singlelineedit within w_pr310_asistencia_jornal
integer x = 2331
integer y = 136
integer width = 1170
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type st_1 from statictext within w_pr310_asistencia_jornal
integer x = 1755
integer y = 140
integer width = 279
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Trabajador"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procesando from statictext within w_pr310_asistencia_jornal
boolean visible = false
integer x = 1746
integer y = 256
integer width = 407
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Procesando ..."
boolean focusrectangle = false
end type

type cb_copiar from commandbutton within w_pr310_asistencia_jornal
integer x = 3538
integer y = 216
integer width = 571
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar"
end type

event clicked;parent.event ue_copiar( )
end event

type cb_importar from commandbutton within w_pr310_asistencia_jornal
integer x = 3538
integer y = 40
integer width = 571
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar xls"
end type

event clicked;Integer	li_value
string 	ls_docname, ls_named

try 
	
	cb_importar.enabled = false
	cb_buscar.enabled = false
	cb_copiar.enabled = false
	
	li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.XLS),*.XLS" )
	
	if li_value = 1 then
		IF parent.event ue_importar_xls(ls_docname) = -1 THEN 
			RETURN -1
		END IF
	end if

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Ha ocurrido una excepcion")
	
finally
	cb_importar.enabled = true
	cb_buscar.enabled = true
	cb_copiar.enabled = true
end try





end event

type st_texto from statictext within w_pr310_asistencia_jornal
integer x = 2235
integer y = 252
integer width = 1253
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_left_time from statictext within w_pr310_asistencia_jornal
boolean visible = false
integer x = 1746
integer y = 376
integer width = 2363
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
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_pr310_asistencia_jornal
integer x = 3538
integer y = 304
integer width = 571
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;if MessageBox('Error', 'Desea realizar el proceso de distribucion de horas?.' &
							+ '~r~nTenga cuidado que si ha ingresado horas manualmente, perdera todos los cambios', &
							Information!, YesNo!, 2) = 2 then return
							
parent.event ue_procesar( )
end event

type gb_2 from groupbox within w_pr310_asistencia_jornal
integer width = 4320
integer height = 448
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cargar Asistencia por Rango de fechas, Origen y OT_ADM."
end type

