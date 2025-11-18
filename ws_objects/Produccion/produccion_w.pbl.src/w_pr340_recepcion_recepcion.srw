$PBExportHeader$w_pr340_recepcion_recepcion.srw
forward
global type w_pr340_recepcion_recepcion from w_abc_master_smpl
end type
type cb_buscar from commandbutton within w_pr340_recepcion_recepcion
end type
type uo_fechas from u_ingreso_rango_fechas within w_pr340_recepcion_recepcion
end type
type cb_procesar from commandbutton within w_pr340_recepcion_recepcion
end type
type st_1 from statictext within w_pr340_recepcion_recepcion
end type
type st_rows from statictext within w_pr340_recepcion_recepcion
end type
type st_nro from statictext within w_pr340_recepcion_recepcion
end type
type sle_origen from u_sle_codigo within w_pr340_recepcion_recepcion
end type
type cb_1 from commandbutton within w_pr340_recepcion_recepcion
end type
type gb_2 from groupbox within w_pr340_recepcion_recepcion
end type
end forward

global type w_pr340_recepcion_recepcion from w_abc_master_smpl
integer width = 4695
integer height = 2292
string title = "[PR340] Generacion Partes Recepcion - Recepcion Destajo"
string menuname = "m_mantto_smpl"
event ue_retrieve ( )
event ue_retrieve_hrs_row ( long al_row )
event ue_procesar ( )
event ue_aprobar ( )
cb_buscar cb_buscar
uo_fechas uo_fechas
cb_procesar cb_procesar
st_1 st_1
st_rows st_rows
st_nro st_nro
sle_origen sle_origen
cb_1 cb_1
gb_2 gb_2
end type
global w_pr340_recepcion_recepcion w_pr340_recepcion_recepcion

type variables
integer 	ii_copia
String	is_partes[], is_null[]
string 	is_desc_turno, is_cod_trabajador, is_nombre, is_cod_tipo_mov, is_desc_movimi, &
		 	is_cod_origen, is_salir
datetime id_entrada, id_salida

//Tipo de OT de produccion 'PROD', 'REPR', 'RPQE', 'RECL'			 
String	is_ot_tipo_prod, is_ot_tipo_repr, is_ot_tipo_rpqe, is_ot_tipo_recl



n_Cst_wait					invo_Wait
n_Cst_utilitario 			invo_util
nvo_numeradores_varios	invo_nro

end variables

forward prototypes
public subroutine of_set_modify ()
public function boolean of_getparam ()
public function integer of_horas_trab (long al_row)
public function boolean of_valida_fecha (u_dw_abc adw_1)
public function boolean of_validar_registro (u_dw_abc adw_1)
public function boolean of_procesar (string as_nro_parte)
public subroutine of_restringir_campos ()
public function boolean of_nro_trazabilidad (long al_row)
public function boolean of_get_oper_sec (long al_row)
public function boolean of_get_labor (long al_row)
end prototypes

event ue_retrieve;date 		ld_desde, ld_hasta
String	ls_origen

ls_origen = sle_origen.text

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ls_origen, ld_desde, ld_hasta)

st_rows.text = string(dw_master.RowCount( ), "###,##0")

dw_master.ii_protect = 0
dw_master.of_protect()
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

event ue_procesar();DAte		ld_fecha1, ld_Fecha2
String	ls_mensaje, ls_origen

try 
	
	if MessageBox('Pregunta', 'Desea realizar el proceso de consolidación de Partes de ' &
					+ 'RECEPCION?, ojo que los datos se eliminaran si no se ha proceso', &
					Information!, Yesno!, 2) = 2 then
		return
	end if
	
	ls_origen = sle_origen.text
	ld_fecha1 = uo_fechas.of_Get_fecha1()
	ld_fecha2 = uo_fechas.of_Get_fecha2()
	
	/*
	  pkg_produccion.sp_proc_recepcion_recepc(asi_origen => :asi_origen,
                                        		asi_empresa => :asi_empresa,
                                        	 	adi_fecha1 => :adi_fecha1,
                                        		adi_fecha2 => :adi_fecha2,
                                        		asi_usuario => :asi_usuario);
	*/
	
	DECLARE sp_proc_recepcion_recepc PROCEDURE FOR 
			  pkg_produccion.sp_proc_recepcion_recepc(:ls_origen,
			  													 	 :gnvo_app.empresa.is_empresa,
																 	 :ld_fecha1,
																 	 :ld_Fecha2,
																 	 :gs_user);
			  
	EXECUTE sp_proc_recepcion_recepc ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		Rollback ;
		Messagebox('Error', 'Error en procedure pkg_produccion.sp_proc_recepcion_recepc(), Mensaje: ' + ls_mensaje, StopSign!)
		Return
	end if
	
	CLOSE sp_proc_recepcion_recepc ;
	
	event ue_retrieve()
	
	return 
	

catch ( Exception ex )
	gnvo_app.of_Catch_Exception(ex, 'Error al procesar pkg_produccion.sp_proc_recepcion_recepc()')
finally
	

	
end try



end event

event ue_aprobar();DAte		ld_fecha1, ld_Fecha2
String	ls_mensaje, ls_origen

try 
	
	if MessageBox('Pregunta', 'Desea realizar el proceso de APROBACION de Partes de ' &
					+ 'RECEPCION - FILETEO?, Ojo una vez procesados, ya no se podrán hacer modificaciones al respecto', &
					Information!, Yesno!, 2) = 2 then
		return
	end if
	
	ls_origen = sle_origen.text
	ld_fecha1 = uo_fechas.of_Get_fecha1()
	ld_fecha2 = uo_fechas.of_Get_fecha2()
	
	/*
		begin
		  -- Call the procedure
		  pkg_produccion.sp_aprueba_recepcion_recepc(asi_origen => :asi_origen,
																	asi_empresa => :asi_empresa,
																	adi_fecha1 => :adi_fecha1,
																	adi_fecha2 => :adi_fecha2,
																	asi_usuario => :asi_usuario);
		end;
	*/
	
	DECLARE sp_aprueba_recepcion_recepc PROCEDURE FOR 
			  pkg_produccion.sp_aprueba_recepcion_recepc(:ls_origen,
			  															:gnvo_app.empresa.is_empresa,
																 		:ld_fecha1,
																 		:ld_Fecha2,
																 		:gs_user);
			  
	EXECUTE sp_aprueba_recepcion_recepc ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		Rollback ;
		Messagebox('Error', 'Error en procedure pkg_produccion.sp_aprueba_recepcion_recepc(), Mensaje: ' + ls_mensaje, StopSign!)
		Return
	end if
	
	CLOSE sp_aprueba_recepcion_recepc ;
	
	event ue_retrieve()
	
	return 
	

catch ( Exception ex )
	gnvo_app.of_Catch_Exception(ex, 'Error al procesar pkg_produccion.sp_aprueba_recepcion_recepc()')
finally
	

	
end try



end event

public subroutine of_set_modify ();//idw_1.Modify("trabajador.Background.Color ='" + string(RGB(255,0,0)) + " ~t If(isnull(idw_1.object.fec_desde) = ~~'C~~'')
end subroutine

public function boolean of_getparam ();try 
	
	//Obtengo los datos del Tipo de OT
	//is_ot_tipo_prod, is_ot_tipo_repr, is_ot_tipo_rpqe, is_ot_tipo_recl
	//'PROD', 'REPR', 'RPQE', 'RECL'
	
	is_ot_tipo_prod = gnvo_app.of_get_parametro('OPER_OT_TIPO_PRODUCCION', 'PROD')
	is_ot_tipo_repr = gnvo_app.of_get_parametro('OPER_OT_TIPO_REPROCESO', 'REPR')
	is_ot_tipo_rpqe = gnvo_app.of_get_parametro('OPER_OT_TIPO_REEMPAQUE', 'RPQE')
	is_ot_tipo_recl = gnvo_app.of_get_parametro('OPER_OT_TIPO_RECLASIFICACION', 'RECL')

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al obtener parametros de produccion')
	return false
	
finally
	
end try



return true
end function

public function integer of_horas_trab (long al_row);date 	ld_fec_desde, ld_fec_hasta
Time 	lt_hora, lt_hora2
Long	ll_segundos

if al_row = 0 then return -1

ld_fec_desde = date(dw_master.Object.fec_desde [al_row])
ld_fec_hasta = date(dw_master.Object.fec_hasta [al_row])

if ld_fec_desde = ld_fec_hasta then
	lt_hora 		 = time(dw_master.Object.fec_desde [al_row])
	lt_hora2		 = time(dw_master.Object.fec_hasta [al_row])
	ll_segundos = SecondsAfter(lt_hora, lt_hora2)
	dw_master.object.horas_trab [al_row] = Dec(ll_segundos) / 3600
else
	lt_hora 		 = time(dw_master.Object.fec_desde [al_row])
	ll_segundos = SecondsAfter(lt_hora, 23:59:59)
	
	lt_hora		 = time(dw_master.Object.fec_hasta [al_row])
	ll_segundos += SecondsAfter(00:00:00, lt_hora)
	
	dw_master.object.horas_trab [al_row] = Dec(ll_segundos) / 3600
end if

//MessageBox('', Dec(ll_segundos) / 3600)
return ll_segundos
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
string				ls_trabajador, ls_nombre, ls_cod_trabajador, ls_turno, ls_tipo_mov
Date				ld_fec_movim, ld_fec_desde
dwItemStatus 	ldis_status 

if adw_1.RowCount() < 1 then Return true

For ll_i = 1 to adw_1.RowCount()
	  
	ldis_status = adw_1.GetItemStatus(ll_i, 0, Primary!)

	if ldis_status = NewModified! or ldis_status = New! then
		//PK = COD_TRABAJADOR, FEC_MOVIM, TURNO, COD_TIPO_MOV, FEC_DESDE
		
		ls_cod_trabajador = adw_1.object.cod_trabajador 	[ll_i]
		ld_fec_movim 		= Date(adw_1.object.fec_movim 	[ll_i])
		ls_turno 				= adw_1.object.turno 				[ll_i]
		ls_tipo_mov			= adw_1.object.cod_tipo_mov		[ll_i]
		ld_fec_desde 		= Date(adw_1.object.fec_desde 	[ll_i])
		
	
		select count(*)
			into :ll_count
		from asistencia
		where cod_trabajador 		= :ls_cod_trabajador
			and trunc(fec_movim)	= trunc(:ld_fec_movim)
			and turno					= :ls_turno
			and cod_tipo_mov			= :ls_tipo_mov
			and trunc(fec_desde)	= trunc(:ld_fec_desde);
		
		if ll_count > 0 then
			Messagebox('Error','Registro ya ha sido registrado. Porfavor Verifique' &
						+ '~r~nCod Trabajador: ' + ls_cod_trabajador &
						+ '~r~nFec. Movim: ' + string(ld_fec_movim, 'dd/mm/yyyy') &
						+ '~r~nTurno: ' + ls_turno &
						+ '~r~nTipo Mov.: ' + ls_tipo_mov &
						+ '~r~nFec. Desde: ' + string(ld_fec_desde, 'dd/mm/yyyy')	, StopSign!)
		 	return false
		end if
	end if
next
		 
Return true
	 
end function

public function boolean of_procesar (string as_nro_parte);String 	ls_mensaje
//begin
//  -- Call the procedure
//  pkg_produccion.sp_procesar_parte(asi_nro_parte => :asi_nro_parte);
//end;

DECLARE sp_procesar_parte PROCEDURE FOR 
		  pkg_produccion.sp_procesar_parte(:as_nro_parte);
		  
EXECUTE sp_procesar_parte ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error', 'Error en procedure pkg_produccion.sp_procesar_parte(), Mensaje: ' + ls_mensaje, StopSign!)
	Return false
end if

CLOSE sp_procesar_parte ;

return true
end function

public subroutine of_restringir_campos ();dw_master.Modify("nro_tunel.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("lugar_empaque.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("nro_ot.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("almacen_mp.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("cod_art_mp.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("peso_consumo.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("der.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("fec_produccion.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("fec_reproceso.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("fec_empaque.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("fec_cavalier.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("cod_art_cavalier.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("jefe_turno.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("grupo_empaque.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("flag_tipo_proceso.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("almacen_pptt.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("nro_pallet.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("turno.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("cod_presentacion.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("cod_tratamiento.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
dw_master.Modify("nro_dino.Protect ='1~tIf(flag_estado=~~'0~~',1,0)'")
	
//La segundo unidad dependera del flag_und2 del articulo
dw_master.Modify("total_caja.Protect ='1~tIf(flag_und2=~~'0~~' or IsNull(flag_und2),1,0)'")
dw_master.Modify("cant_producida.Protect ='1~tIf(flag_estado=~~'0~~' or abs(if(isnull(factor_conv_und), 0, factor_conv_und)) <> 1,1,0)'")

dw_master.Modify("cod_art_pptt.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("der.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("fec_produccion.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("fec_reproceso.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("fec_empaque.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("fec_cavalier.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("fec_vencimiento.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("jefe_turno.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("grupo_empaque.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("flag_tipo_proceso.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("almacen_pptt.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")
dw_master.Modify("total_caja.Protect ='1~tIf(flag_estado=~~'0~~' or isnull(desde) <> true or trim(desde) <> ~~'~~' ,1,0)'")

end subroutine

public function boolean of_nro_trazabilidad (long al_row);Date 		ld_fec_produccion, ld_fec_empaque
String	ls_jefe_turno, ls_grupo_empaque, ls_juliano, ls_nro_trazabilidad, ls_flag_tipo_proceso
Long		ll_year

//Obtengo la fecha de produccion y de empaque
ld_fec_produccion = Date(dw_master.object.fec_produccion 	[al_row])
ld_fec_empaque 	= Date(dw_master.object.fec_empaque 		[al_row])

if ld_fec_empaque < ld_fec_produccion then
	gnvo_app.of_mensaje_error("La fecha de empaque no puede ser menor a la fecha de produccion")
	dw_master.object.fec_empaque [al_row] = dw_master.object.fec_produccion [al_row]
	dw_master.setColumn("fec_empaque")
	return false
end if

//Obtengo el jefe de turno
ls_jefe_turno = dw_master.object.jefe_turno [al_row]
if IsNull(ls_jefe_turno) or trim(ls_jefe_turno) = '' then return false

//Obtengo el grupo de empaque
ls_grupo_empaque = dw_master.object.grupo_empaque [al_row]
if IsNull(ls_grupo_empaque) or trim(ls_grupo_empaque) = '' then return false

//Obtengo el tipo de proceso
ls_flag_tipo_proceso = dw_master.object.flag_tipo_proceso [al_row]
if IsNull(ls_flag_tipo_proceso) or trim(ls_flag_tipo_proceso) = '' then return false

//Genero el nro de trazabilidad
ls_juliano = invo_util.of_get_juliano(ld_fec_produccion)
ll_year = Long(right(string(year(ld_Fec_produccion)),2)) - Long(right(ls_juliano,1))

ls_nro_trazabilidad = ls_jefe_turno + ls_grupo_empaque + ls_juliano &
						  + string(ll_year, '00') + ls_flag_tipo_proceso &
						  + invo_util.of_get_juliano(ld_Fec_empaque)

dw_master.object.nro_trazabilidad	[al_row] = ls_nro_trazabilidad
		
return true
end function

public function boolean of_get_oper_sec (long al_row);String 	ls_cod_labor, ls_ot_adm, ls_nro_orden, ls_oper_sec, ls_desc_operacion

ls_cod_labor = dw_master.object.cod_labor	[al_row]

if ls_cod_labor = '' or IsNull(ls_cod_labor) then
	dw_master.setColumn('cod_labor')
	dw_master.setFocus()
	return false
end if

ls_ot_adm = dw_master.object.ot_adm	[al_row]

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	dw_master.setColumn('ot_adm')
	dw_master.setFocus()
	return false
end if

ls_nro_orden = dw_master.object.nro_ot	[al_row]

if ls_nro_orden = '' or IsNull(ls_nro_orden) then
	dw_master.setColumn('nro_orden')
	dw_master.setFocus()
	return false
end if

select op.oper_sec, op.desc_operacion
	into :ls_oper_sec, :ls_desc_operacion
from operaciones op, 
	  orden_trabajo ot, 
     ot_administracion ota 
where op.nro_orden   = ot.nro_orden 
  and ot.ot_adm      = ota.ot_adm 
  and op.cod_labor   = :ls_cod_labor
  and ot.ot_adm      = :ls_ot_adm
  and ot.nro_orden   = :ls_nro_orden 
  and op.flag_estado = '1';
		 
if SQLCA.SQLCode = 100 then
	dw_master.object.oper_sec			[al_row] = gnvo_app.is_null
	dw_master.object.desc_operacion	[al_row] = gnvo_app.is_null
	dw_master.ii_update = 1
	
	MessageBox('Error', 'No existe una operacion en la Orden de Trabajo que tenga la labor asignada a la tarea, por favor verifique!' &
							+ '~r~nLabor: ' + ls_cod_labor &
							+ '~r~nOT_ADM: ' + ls_ot_adm &
							+ '~r~nNRO ORDEN: ' + ls_nro_orden, StopSign!)
							
	
	return false
end if		

dw_master.object.oper_sec			[al_row] = ls_oper_sec
dw_master.object.desc_operacion	[al_row] = ls_Desc_operacion
		
return true

end function

public function boolean of_get_labor (long al_row);String 	ls_cod_labor, ls_desc_labor, ls_especie, ls_presentacion, ls_cod_tarea

ls_especie = dw_master.object.especie  [al_row]

if ls_especie = '' or IsNull(ls_especie) then
	dw_master.SetColumn('especie')
	return false
end if

ls_presentacion = dw_master.object.cod_presentacion[al_row]

if ls_presentacion = '' or IsNull(ls_presentacion) then
	dw_master.SetColumn('cod_presentacion')
	return false
end if

ls_cod_tarea = dw_master.object.cod_tarea	[al_row]

if ls_cod_tarea = '' or IsNull(ls_cod_tarea) then
	MessageBox('Error', 'Debe Ingresar un código de TAREA', StopSign!)
	dw_master.SetColumn('cod_tarea')
	return false
end if
		
// Con la selección de la tarea entonces obtengo del tarifario
// el precio y la unidad

select tf.cod_labor, la.desc_labor
  into :ls_cod_labor, :ls_desc_labor
  from tg_tarifario 	tf,
		 labor			la
 where tf.cod_labor			= la.cod_labor
	and tf.cod_especie 		= :ls_especie
	and tf.cod_presentacion = :ls_presentacion
	and tf.cod_tarea			= :ls_cod_tarea;

if SQLCA.SQLCode = 100 then
	dw_master.object.cod_labor		[al_row] = gnvo_app.is_null
	dw_master.object.desc_labor	[al_row] = gnvo_app.is_null
	
	dw_master.object.oper_sec			[al_row] = gnvo_app.is_null
	dw_master.object.desc_operacion	[al_row] = gnvo_app.is_null

	return false
	
end if

dw_master.object.cod_labor		[al_row] = ls_cod_labor
dw_master.object.desc_labor	[al_row] = ls_desc_labor

dw_master.object.oper_sec			[al_row] = gnvo_app.is_null
dw_master.object.desc_operacion	[al_row] = gnvo_app.is_null

return true

end function

on w_pr340_recepcion_recepcion.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.cb_procesar=create cb_procesar
this.st_1=create st_1
this.st_rows=create st_rows
this.st_nro=create st_nro
this.sle_origen=create sle_origen
this.cb_1=create cb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_procesar
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_rows
this.Control[iCurrent+6]=this.st_nro
this.Control[iCurrent+7]=this.sle_origen
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_pr340_recepcion_recepcion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.cb_procesar)
destroy(this.st_1)
destroy(this.st_rows)
destroy(this.st_nro)
destroy(this.sle_origen)
destroy(this.cb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

if not this.of_getparam() then
	post event close()
	
	return
end if

ii_lec_mst = 0

invo_nro = create nvo_numeradores_varios
invo_wait = create n_cst_wait

sle_origen.text = gs_origen

end event

event ue_update_pre;call super::ue_update_pre;Long 		ll_row, ll_index
String	ls_nro_parte, ls_nom_tabla

try 
	is_partes = is_null
	
	ib_update_check = false
	
	if gnvo_app.of_row_processing( dw_master ) = false then return
	
	ls_nom_tabla = dw_master.of_get_tabla( )
	
	for ll_row = 1 to dw_master.RowCount()
		ls_nro_parte = dw_master.object.nro_parte [ll_row]
		if dw_master.is_row_modified( ll_row ) or IsNull(ls_nro_parte) or trim(ls_nro_parte) = '' then
			
			//Genero un nuevo numero para el parte
			if dw_master.is_row_new( ll_row ) or IsNull(ls_nro_parte) or trim(ls_nro_parte) = '' then
				if not invo_nro.of_num_parte_empaque( gs_origen, ls_nom_tabla, ls_nro_parte) then return
				dw_master.object.nro_parte [ll_row] = ls_nro_parte
				
				
			end if
			
			ll_index = UpperBound(is_partes) + 1
			
			is_partes[ll_index] = ls_nro_parte
			
		end if
		
	next
	
	dw_master.of_set_flag_replicacion( )
	
	ib_update_check = true

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, '')
end try


end event

event ue_update;//Override

Boolean  lbo_ok = TRUE
String	ls_msg
Date		ld_fecha1, ld_fecha2
Long		ll_i

dw_master.AcceptText()


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
END IF

end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
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

event close;call super::close;destroy invo_nro
destroy invo_wait
end event

event ue_delete;//Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_modify;//Override
dw_master.of_protect() 


end event

event ue_anular;call super::ue_anular;dw_master.event ue_Anular()
end event

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr340_recepcion_recepcion
event ue_display ( string as_columna,  long al_row )
event ue_print_cus ( long al_row )
event ue_print_pallet ( long al_row )
integer y = 188
integer width = 4123
integer height = 1752
string dataobject = "d_abc_recepcion_recepcion_tbl"
end type

event dw_master::ue_display;String	ls_sql, ls_codigo, ls_data, ls_turno, ls_cuadrilla, ls_especie, &
			ls_presentacion, ls_cod_labor, ls_ot_adm, ls_nro_orden, ls_oper_sec, &
			ls_desc_operacion, ls_tarea, ls_desc_labor, ls_cod_art, ls_cliente, &
			ls_titulo, ls_nom_cliente
Long		ll_row, ll_nro_trabaj		

if dw_master.object.flag_estado [al_row] = '0' then
	gnvo_app.of_mensaje_error("El registro esta anulado, no se puede modificar")
	return
end if

choose case lower(as_columna)
	case "cod_cuadrilla"
		ls_turno 	= dw_master.object.turno [al_row]
		
		ls_sql = "select tc.cod_cuadrilla as codigo_cuadrilla, " &
				 + "		  tc.desc_cuadrilla as descripcion_cuadrilla " &
				 + "from tg_cuadrillas tc, " &
				 + "     ot_adm_usuario otu " &
				 + "where tc.turno    = '" + ls_turno + "'" &
				 + "  and tc.ot_adm   = otu.ot_adm " &
				 + "  and otu.cod_usr = '" + gs_user + "'" &
				 + "  and tc.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			select count(*)
			  into :ll_nro_trabaj
			  from tg_cuadrillas_det tcd
			 where tcd.cod_cuadrilla = :ls_codigo;
			  
			this.object.cod_cuadrilla		[al_row] = ls_codigo
			this.object.desc_cuadrilla		[al_row] = ls_data
			this.object.nro_trabaj			[al_row] = ll_nro_trabaj
			
			this.object.cod_presentacion	[al_row] = gnvo_app.is_null
			this.object.desc_presentacion	[al_row] = gnvo_app.is_null
			
			this.object.cod_tarea			[al_row] = gnvo_app.is_null
			this.object.desc_tarea			[al_row] = gnvo_app.is_null

			this.object.cod_labor			[al_row] = gnvo_app.is_null
			this.object.desc_labor			[al_row] = gnvo_app.is_null
			
			this.object.ot_adm				[al_row] = gnvo_app.is_null
			this.object.nro_ot				[al_row] = gnvo_app.is_null
			this.object.titulo				[al_row] = gnvo_app.is_null
			this.object.cod_cliente			[al_row] = gnvo_app.is_null
			this.object.nom_cliente			[al_row] = gnvo_app.is_null

			this.object.oper_sec				[al_row] = gnvo_app.is_null
			this.object.desc_operacion		[al_row] = gnvo_app.is_null
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma CUADRILLA para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.cod_cuadrilla		[ll_row] = ls_codigo
					this.object.desc_cuadrilla		[ll_row] = ls_data
					this.object.nro_trabaj			[ll_row] = ll_nro_trabaj
					
					this.object.cod_presentacion	[ll_row] = gnvo_app.is_null
					this.object.desc_presentacion	[ll_row] = gnvo_app.is_null
					
					this.object.cod_tarea			[ll_row] = gnvo_app.is_null
					this.object.desc_tarea			[ll_row] = gnvo_app.is_null
		
					this.object.cod_labor			[ll_row] = gnvo_app.is_null
					this.object.desc_labor			[ll_row] = gnvo_app.is_null
					
					this.object.ot_adm				[ll_row] = gnvo_app.is_null
					this.object.nro_ot				[ll_row] = gnvo_app.is_null
					this.object.titulo				[ll_row] = gnvo_app.is_null
					this.object.cod_cliente			[ll_row] = gnvo_app.is_null
					this.object.nom_cliente			[ll_row] = gnvo_app.is_null
		
					this.object.oper_sec				[ll_row] = gnvo_app.is_null
					this.object.desc_operacion		[ll_row] = gnvo_app.is_null
					yield()
			
				next
			end if	
		

			this.ii_update = 1
			
			// Valido si la cuadrilla tiene una sola tarea de ser asi 
			// coloco el resto de datos
		end if

	case "cod_presentacion"
		ls_cuadrilla = this.object.cod_cuadrilla[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla', StopSign!)
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_especie = this.object.especie[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar un código de especie', StopSign!)
			this.SetColumn('cod_especie')
			return
		end if
		
		ls_sql = "select distinct tp.cod_presentacion as codigo_presentacion, " &
				 + "		  tp.desc_presentacion as descripcion_presentacion " &
				 + "from tg_presentacion tp, " &
				 + "      tg_cuadrillas_labor tcl " &
				 + "where tcl.cod_presentacion = tp.cod_presentacion " &
				 + "  and tp.flag_estado = '1' " &
				 + "  and tcl.cod_cuadrilla = '" + ls_cuadrilla + "' " &
				 + "  and tcl.especie = '" + ls_especie + "'"
				 
	
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_presentacion	[al_row] = ls_codigo
			this.object.desc_presentacion	[al_row] = ls_data

			this.object.cod_tarea			[al_row] = gnvo_app.is_null
			this.object.desc_tarea			[al_row] = gnvo_app.is_null
			
			this.object.cod_labor			[al_row] = gnvo_app.is_null
			this.object.desc_labor			[al_row] = gnvo_app.is_null
			
			this.object.ot_adm				[al_row] = gnvo_app.is_null
			this.object.nro_ot				[al_row] = gnvo_app.is_null
			this.object.titulo				[al_row] = gnvo_app.is_null
			this.object.cod_cliente			[al_row] = gnvo_app.is_null
			this.object.nom_cliente			[al_row] = gnvo_app.is_null
		
			this.object.oper_sec				[al_row] = gnvo_app.is_null
			this.object.desc_operacion		[al_row] = gnvo_app.is_null
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma PRESENTACION para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.cod_presentacion	[ll_row] = ls_codigo
					this.object.desc_presentacion	[ll_row] = ls_data
					
					this.object.cod_tarea			[ll_row] = gnvo_app.is_null
					this.object.desc_tarea			[ll_row] = gnvo_app.is_null
		
					this.object.cod_labor			[ll_row] = gnvo_app.is_null
					this.object.desc_labor			[ll_row] = gnvo_app.is_null
					
					this.object.ot_adm				[ll_row] = gnvo_app.is_null
					this.object.nro_ot				[ll_row] = gnvo_app.is_null
					this.object.titulo				[ll_row] = gnvo_app.is_null
					this.object.cod_cliente			[ll_row] = gnvo_app.is_null
					this.object.nom_cliente			[ll_row] = gnvo_app.is_null
		
					this.object.oper_sec				[ll_row] = gnvo_app.is_null
					this.object.desc_operacion		[ll_row] = gnvo_app.is_null
					yield()
			
				next
			end if

			this.ii_update = 1
		end if

	case "cod_tarea"
		ls_cuadrilla = this.object.cod_cuadrilla[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla')
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_especie = this.object.especie[al_row]
		
		if ls_especie = '' or IsNull(ls_especie) then
			MessageBox('Error', 'Debe Ingresar un código de especie')
			this.SetColumn('cod_especie')
			return
		end if
		
		ls_presentacion = this.object.cod_presentacion[al_row]
		
		if ls_presentacion = '' or IsNull(ls_presentacion) then
			MessageBox('Error', 'Debe Ingresar un código de presentacion')
			this.SetColumn('cod_presentacion')
			return
		end if
		
		ls_sql = "select distinct ta.cod_tarea as codigo_tarea, " &
				 + "		  ta.desc_tarea as descripcion_tarea " &
				 + "from tg_tareas ta, " &
				 + "     tg_cuadrillas_labor tcl " &
				 + "where tcl.cod_tarea = ta.cod_tarea " &
				 + "  and ta.flag_estado = '1' " &
				 + "  and tcl.cod_cuadrilla = '" + ls_cuadrilla + "'" &
				 + "  and tcl.especie = '" + ls_especie + "'" &
				 + "  and tcl.cod_presentacion = '" + ls_presentacion + "'"
				 
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_tarea		[al_row] = ls_codigo
			this.object.desc_tarea		[al_row] = ls_data
			
			this.object.cod_labor		[al_row] = gnvo_app.is_null
			this.object.desc_labor		[al_row] = gnvo_app.is_null
			
			this.object.ot_adm			[al_row] = gnvo_app.is_null
			this.object.nro_ot			[al_row] = gnvo_app.is_null
			this.object.titulo			[al_row] = gnvo_app.is_null
			this.object.cod_cliente		[al_row] = gnvo_app.is_null
			this.object.nom_cliente		[al_row] = gnvo_app.is_null
			
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma TAREA para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.cod_tarea		[ll_row] = ls_codigo
					this.object.desc_tarea		[ll_row] = ls_data
		
					this.object.cod_labor		[ll_row] = gnvo_app.is_null
					this.object.desc_labor		[ll_row] = gnvo_app.is_null
					
					this.object.ot_adm			[ll_row] = gnvo_app.is_null
					this.object.nro_ot			[ll_row] = gnvo_app.is_null
					this.object.titulo			[ll_row] = gnvo_app.is_null
					this.object.cod_cliente		[ll_row] = gnvo_app.is_null
					this.object.nom_cliente		[ll_row] = gnvo_app.is_null
		
					this.object.oper_sec			[ll_row] = gnvo_app.is_null
					this.object.desc_operacion	[ll_row] = gnvo_app.is_null
					yield()
			
				next
			end if
			
			this.ii_update = 1
			
			if of_get_labor(al_row) then
				of_get_oper_sec(al_row)
			end if
		end if

	case "cod_labor"
		ls_especie = this.object.especie[al_row]
		
		if ls_especie = '' or IsNull(ls_especie) then
			MessageBox('Error', 'Debe Ingresar un código de especie', StopSign!)
			this.SetColumn('cod_especie')
			return
		end if
		
		ls_presentacion = this.object.cod_presentacion[al_row]
		
		if ls_presentacion = '' or IsNull(ls_presentacion) then
			MessageBox('Error', 'Debe Ingresar un código de presentacion', StopSign!)
			this.SetColumn('cod_presentacion')
			return
		end if
		
		ls_tarea = this.object.cod_tarea	[al_row]
		
		if ls_tarea = '' or IsNull(ls_tarea) then
			MessageBox('Error', 'Debe Ingresar un código de TAREA', StopSign!)
			this.SetColumn('cod_tarea')
			return
		end if
		
		
		ls_sql = "select tt.cod_labor as codigo_labor, " &
				 + "la.desc_labor as descripcion_labor " &
				 + "  from tg_tarifario tt, " &
				 + "       labor        la " &
				 + " where tt.cod_labor        = la.cod_labor " &
				 + "   and tt.cod_especie 		 = '" + ls_especie + "'" &
				 + "   and tt.cod_presentacion = '" + ls_presentacion + "'" &
				 + "   and tt.cod_tarea			 = '" + ls_tarea + "'" &
				 + "   and tt.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_labor		[al_row] = ls_codigo
			this.object.desc_labor		[al_row] = ls_data
			
			this.object.ot_adm			[al_row] = gnvo_app.is_null
			this.object.nro_ot			[al_row] = gnvo_app.is_null
			this.object.titulo			[al_row] = gnvo_app.is_null
			this.object.cod_cliente		[al_row] = gnvo_app.is_null
			this.object.nom_cliente		[al_row] = gnvo_app.is_null
			
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma LABOR para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.cod_labor		[ll_row] = ls_codigo
					this.object.desc_labor		[ll_row] = ls_data
					
					this.object.ot_adm			[ll_row] = gnvo_app.is_null
					this.object.nro_ot			[ll_row] = gnvo_app.is_null
					this.object.titulo			[ll_row] = gnvo_app.is_null
					this.object.cod_cliente		[ll_row] = gnvo_app.is_null
					this.object.nom_cliente		[ll_row] = gnvo_app.is_null
		
					this.object.oper_sec			[ll_row] = gnvo_app.is_null
					this.object.desc_operacion	[ll_row] = gnvo_app.is_null
					yield()
			
				next
			end if
			
			this.ii_update = 1
		end if		

	case "ot_adm"
		ls_cod_art = this.object.cod_art	[al_row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Ingresar un código de ARTICULO', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		ls_cod_labor = this.object.cod_labor	[al_row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe Ingresar un código de LABOR', StopSign!)
			this.SetColumn('cod_labor')
			return
		end if
		
		ls_sql = "select distinct ota.ot_adm as ot_adm, " &
				 + "ota.descripcion as desc_ot_adm " &
				 + "  from ot_administracion ota, " &
				 + "       ot_adm_usuario    otu, " &
				 + "       (select distinct ot.nro_orden, ot.ot_adm " &
				 + "          from orden_trabajo     ot, " &
				 + "               articulo_mov_proy amp " &
				 + "         where ot.nro_orden      = amp.nro_doc " &
				 + "           and amp.tipo_doc      = (select doc_ot from logparam where reckey = '1') " &
				 + "           and ot.flag_estado    = '1' " &
				 + "           and amp.cod_art       = '" + ls_cod_art + "' " &
				 + "           and amp.flag_estado   = '1') vw, " &
				 + "       operaciones       op " &
				 + " where ota.ot_adm        = otu.ot_adm " &
				 + "   and ota.ot_adm        = vw.ot_adm " &
				 + "   and vw.nro_orden      = op.nro_orden " &
				 + "   and op.cod_labor      = '" + ls_cod_labor + "' " &
				 + "   and otu.cod_usr       = '" + gs_user + "' " &
				 + "   and op.flag_estado    = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.ot_adm			[al_row] = ls_codigo
			
			this.object.nro_ot			[al_row] = gnvo_app.is_null
			this.object.titulo			[al_row] = gnvo_app.is_null
			this.object.cod_cliente		[al_row] = gnvo_app.is_null
			this.object.nom_cliente		[al_row] = gnvo_app.is_null
			
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar el mismo OT_ADM para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.ot_adm			[ll_row] = ls_codigo
			
					this.object.nro_ot			[ll_row] = gnvo_app.is_null
					this.object.titulo			[ll_row] = gnvo_app.is_null
					this.object.cod_cliente		[ll_row] = gnvo_app.is_null
					this.object.nom_cliente		[ll_row] = gnvo_app.is_null
		
					this.object.oper_sec			[ll_row] = gnvo_app.is_null
					this.object.desc_operacion	[ll_row] = gnvo_app.is_null
					yield()
			
				next
			end if
			
			this.ii_update = 1
		end if	
		
	case "nro_ot"
		ls_cod_art = this.object.cod_art	[al_row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Ingresar un código de ARTICULO', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		ls_cod_labor = this.object.cod_labor	[al_row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe Ingresar un código de LABOR', StopSign!)
			this.SetColumn('cod_labor')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[al_row]
		
		if ls_ot_adm = '' or IsNull(ls_ot_adm) then
			MessageBox('Error', 'Debe Ingresar un OT_ADM', StopSign!)
			this.SetColumn('ot_adm')
			return
		end if
		
		ls_sql = "select distinct ot.nro_orden as nro_orden, " &
				 + "		ot.titulo as titulo, " &
				 + "		ot.cliente as cliente, " &
				 + "		p.nom_proveedor as nom_cliente " &
				 + "  from orden_trabajo ot, " &
				 + "       proveedor     p, " &
				 + "       (select distinct ot.nro_orden, ot.ot_adm " &
				 + "          from orden_trabajo     ot, " &
				 + "               articulo_mov_proy amp " &
				 + "         where ot.nro_orden      = amp.nro_doc " &
				 + "           and amp.tipo_doc      = (select doc_ot from logparam where reckey = '1') " &
				 + "           and ot.flag_estado    = '1' " &
				 + "           and amp.cod_art       = '" + ls_cod_art + "' " &
				 + "           and amp.flag_estado   = '1') vw, " &
				 + "       operaciones       op " &
				 + " where ot.nro_orden      = vw.nro_orden " &
				 + "   and ot.cliente        = p.proveedor  (+) " &
				 + "   and op.cod_labor      = '" + ls_cod_labor + "' " &
				 + "   and ot.ot_adm      	  = '" + ls_ot_adm + "' " &
				 + "   and op.flag_estado    = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_nro_orden, ls_titulo, ls_cliente, ls_nom_cliente, '2') then
			
			this.object.nro_ot			[al_row] = ls_nro_orden
			this.object.titulo			[al_row] = ls_titulo
			this.object.cod_cliente		[al_row] = ls_cliente
			this.object.nom_cliente		[al_row] = ls_nom_cliente
			
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar el mismo NRO_OT para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
			
					this.object.nro_ot			[ll_row] = ls_nro_orden
					this.object.titulo			[ll_row] = ls_titulo
					this.object.cod_cliente		[ll_row] = ls_cliente
					this.object.nom_cliente		[ll_row] = ls_nom_cliente
		
					this.object.oper_sec			[ll_row] = gnvo_app.is_null
					this.object.desc_operacion	[ll_row] = gnvo_app.is_null
					yield()
			
				next
			end if
			
			of_get_oper_sec(al_row)
			
			this.ii_update = 1
		end if	

	case "oper_sec"
		ls_cod_labor = this.object.cod_labor	[al_row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe especificar primero una tarea o actividad que tenga un codigo de labor')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[al_row]
		
		if ls_ot_adm = '' or IsNull(ls_ot_adm) then
			MessageBox('Error', 'Debe especificar primero un OT_ADM')
			this.setColumn('ot_adm')
			return
		end if
		
		ls_nro_orden = this.object.nro_ot	[al_row]
		
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('Error', 'Debe especificar primero una ORDEN TRABAJO')
			this.setColumn('nro_orden')
			return
		end if
		
		ls_sql = "select op.oper_sec as oper_sec, " &
				 + "		  op.desc_operacion as descripcion_operacion " &
				 + "from operaciones op, " &
				 + "     orden_trabajo ot, " &
				 + "     ot_administracion ota " &
				 + "where op.nro_orden   = ot.nro_orden " &
				 + "  and ot.ot_adm      = ota.ot_adm " &
				 + "  and op.cod_labor   = '" + ls_cod_labor + "'" &
				 + "  and ot.ot_adm      = '" + ls_ot_adm + "'" &
				 + "  and ot.nro_orden   = '" + ls_nro_orden + "'" &
				 + "  and op.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_oper_sec, ls_desc_operacion, '2') then
			this.object.oper_sec			[al_row] = ls_oper_sec
			this.object.desc_operacion	[al_row] = ls_desc_operacion
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma OPERACION para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.oper_sec			[ll_row] = ls_oper_sec
					this.object.desc_operacion	[ll_row] = ls_desc_operacion
					yield()
			
				next
			end if
			
			
			this.ii_update = 1
		end if					
	
end choose
				

end event

event dw_master::ue_print_cus(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen, ls_nro_vale_ing, ls_nro_pallet
Integer			li_print_size
try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	//Corresponde a un almacen de Productos Terminados
	li_print_size 		= gnvo_app.of_get_print_size( )
	
	if li_print_size < 0 then return
	
	if li_print_size = 1 then
		lstr_rep.dw1 		= 'd_rpt_codigos_cu_pptt_lbl'
	else
		lstr_rep.dw1 		= 'd_rpt_codigos_cu2_pptt_lbl'
	end if
	
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_parte	[al_row]
	lstr_rep.tipo		= '2'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::ue_print_pallet(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen, ls_nro_pallet, ls_nro_vale_ing

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	//Valido que el registro tenga pallet y tambien tenga vale de Ingreso
	ls_nro_pallet 		= this.object.nro_pallet		[al_row]
	ls_nro_vale_ing 	= this.object.nro_vale_ing		[al_row]
	
	if IsNull(ls_nro_pallet) or trim(ls_nro_pallet) = '' then
		MessageBox('Error', 'NO puede imprimir los Codigo CU de este registro porque no tiene asignado un Nro de Pallet, por favor corrija', StopSign!)
		return
	end if

	if IsNull(ls_nro_vale_ing) or trim(ls_nro_vale_ing) = '' then
		MessageBox('Error', 'NO puede imprimir los Codigo CU de este registro porque no VALE DE INGRESO, por favor corrija', StopSign!)
		return
	end if

	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_codigos_pallet_pptt_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_pallet	[al_row]
	lstr_rep.tipo		= '3'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime	ldt_Fec_registro

ldt_fec_registro = gnvo_app.of_fecha_actual()

//La cantidad producida dependera si tiene el factor_conv_und

this.object.cod_usr				[al_row] = gs_user
this.object.cod_origen			[al_row] = gs_origen
this.object.fec_registro		[al_row] = ldt_fec_registro
this.object.fec_produccion		[al_row] = Date(ldt_fec_registro)
this.object.fec_empaque			[al_row] = Date(ldt_fec_registro)
this.object.factor_conv_und	[al_row] = 0
this.object.flag_und2			[al_row] = '0'
this.object.flag_Estado			[al_row] = '1'
this.object.flag_conserva		[al_row] = '0'

of_restringir_campos()
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = lower(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;String	ls_sql, ls_desc, ls_turno, ls_cuadrilla, ls_especie, &
			ls_presentacion, ls_cod_labor, ls_ot_adm, ls_nro_orden, ls_oper_sec, &
			ls_desc_operacion, ls_tarea, ls_desc_labor, ls_cod_art, ls_labor, &
			ls_titulo, ls_cliente, ls_nom_cliente
			
Long		ll_row, ll_nro_trabaj

if dw_master.object.flag_estado [row] = '0' then
	gnvo_app.of_mensaje_error("El registro esta anulado, no se puede modificar")
	return
end if


choose case lower(dwo.name)
	case "cod_cuadrilla"
		ls_turno 	= dw_master.object.turno [row]
		
		select tc.desc_cuadrilla
			into :ls_desc
			from 	tg_cuadrillas tc, 
					ot_adm_usuario otu 
		where tc.ot_adm   		= otu.ot_adm
		  and tc.turno    		= :ls_turno
		  and otu.cod_usr 		= :gs_user
		  and tc.cod_cuadrilla 	= :data
		  and tc.flag_estado 	= '1';

		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de CUADRILLA " + data  + " no existe o no se encuentra activo, por favor verifique")
			this.object.cod_cuadrilla		[row] = gnvo_app.is_null
			this.object.desc_cuadrilla		[row] = gnvo_app.is_null
			this.object.nro_trabaj			[row] = 0
			
			this.object.cod_presentacion	[row] = gnvo_app.is_null
			this.object.desc_presentacion	[row] = gnvo_app.is_null
			
			this.object.cod_tarea			[row] = gnvo_app.is_null
			this.object.desc_tarea			[row] = gnvo_app.is_null
			
			this.object.cod_labor			[row] = gnvo_app.is_null
			this.object.desc_labor			[row] = gnvo_app.is_null
			
			this.object.ot_adm				[row] = gnvo_app.is_null
			this.object.nro_ot				[row] = gnvo_app.is_null
			this.object.titulo				[row] = gnvo_app.is_null
			this.object.cod_cliente			[row] = gnvo_app.is_null
			this.object.nom_cliente			[row] = gnvo_app.is_null

			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if		  
		
		select count(*)
		  into :ll_nro_trabaj
		  from tg_cuadrillas_det tcd
		 where tcd.cod_cuadrilla = :data;
			 
		this.object.desc_cuadrilla	[row] = ls_desc
		this.object.nro_trabaj		[row] = ll_nro_trabaj
			
		this.object.cod_presentacion	[row] = gnvo_app.is_null
		this.object.desc_presentacion	[row] = gnvo_app.is_null
		
		this.object.cod_tarea			[row] = gnvo_app.is_null
		this.object.desc_tarea			[row] = gnvo_app.is_null
		
		this.object.cod_labor			[row] = gnvo_app.is_null
		this.object.desc_labor			[row] = gnvo_app.is_null
		
		this.object.ot_adm				[row] = gnvo_app.is_null
		this.object.nro_ot				[row] = gnvo_app.is_null
		this.object.titulo				[row] = gnvo_app.is_null
		this.object.cod_cliente			[row] = gnvo_app.is_null
		this.object.nom_cliente			[row] = gnvo_app.is_null

		this.object.oper_sec				[row] = gnvo_app.is_null
		this.object.desc_operacion		[row] = gnvo_app.is_null

		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar la misma CUADRILLA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.cod_cuadrilla		[ll_row] = data
				this.object.desc_cuadrilla		[ll_row] = ls_desc
				
				this.object.cod_presentacion	[ll_row] = gnvo_app.is_null
				this.object.desc_presentacion	[ll_row] = gnvo_app.is_null
				
				this.object.cod_tarea			[ll_row] = gnvo_app.is_null
				this.object.desc_tarea			[ll_row] = gnvo_app.is_null
	
				this.object.cod_labor			[ll_row] = gnvo_app.is_null
				this.object.desc_labor			[ll_row] = gnvo_app.is_null
				
				this.object.ot_adm				[ll_row] = gnvo_app.is_null
				this.object.nro_ot				[ll_row] = gnvo_app.is_null
				this.object.titulo				[ll_row] = gnvo_app.is_null
				this.object.cod_cliente			[ll_row] = gnvo_app.is_null
				this.object.nom_cliente			[ll_row] = gnvo_app.is_null
	
				this.object.oper_sec				[ll_row] = gnvo_app.is_null
				this.object.desc_operacion		[ll_row] = gnvo_app.is_null
				yield()
			next
		end if	

	case "cod_presentacion"
		ls_cuadrilla = this.object.cod_cuadrilla[row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla', StopSign!)
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_especie = this.object.especie[row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar un código de especie', StopSign!)
			this.SetColumn('cod_especie')
			return
		end if
		
		select distinct tp.desc_presentacion
			into :ls_desc
		from 	tg_presentacion tp, 
				tg_cuadrillas_labor tcl 
		where tcl.cod_presentacion = tp.cod_presentacion 
		  and tp.flag_estado 		= '1' 
		  and tcl.cod_cuadrilla 	= :ls_cuadrilla
		  and tcl.especie 			= :ls_especie
		  and tcl.cod_presentacion	= :data;
		  
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de PRESENTACION " + data + " no existe, no pertenece a la Cuadrilla o no se encuentra activo, por favor verifique")
			
			this.object.cod_presentacion	[row] = gnvo_app.is_null
			this.object.desc_presentacion	[row] = gnvo_app.is_null
			
			this.object.cod_tarea			[row] = gnvo_app.is_null
			this.object.desc_tarea			[row] = gnvo_app.is_null

			this.object.cod_labor			[row] = gnvo_app.is_null
			this.object.desc_labor			[row] = gnvo_app.is_null
			
			this.object.ot_adm				[row] = gnvo_app.is_null
			this.object.nro_ot				[row] = gnvo_app.is_null
			this.object.titulo				[row] = gnvo_app.is_null
			this.object.cod_cliente			[row] = gnvo_app.is_null
			this.object.nom_cliente			[row] = gnvo_app.is_null
			
			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if				
				 
	
		this.object.desc_presentacion	[row] = ls_desc

		this.object.cod_tarea			[row] = gnvo_app.is_null
		this.object.desc_tarea			[row] = gnvo_app.is_null
		
		this.object.cod_labor			[row] = gnvo_app.is_null
		this.object.desc_labor			[row] = gnvo_app.is_null
		
		this.object.ot_adm				[row] = gnvo_app.is_null
		this.object.nro_ot				[row] = gnvo_app.is_null
		this.object.titulo				[row] = gnvo_app.is_null
		this.object.cod_cliente			[row] = gnvo_app.is_null
		this.object.nom_cliente			[row] = gnvo_app.is_null

		this.object.oper_sec				[row] = gnvo_app.is_null
		this.object.desc_operacion		[row] = gnvo_app.is_null
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar la misma CUADRILLA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.cod_presentacion	[ll_row] = data
				this.object.desc_presentacion	[ll_row] = ls_desc
				
				this.object.cod_tarea			[ll_row] = gnvo_app.is_null
				this.object.desc_tarea			[ll_row] = gnvo_app.is_null
	
				this.object.cod_labor			[ll_row] = gnvo_app.is_null
				this.object.desc_labor			[ll_row] = gnvo_app.is_null
				
				this.object.ot_adm				[ll_row] = gnvo_app.is_null
				this.object.nro_ot				[ll_row] = gnvo_app.is_null
				this.object.titulo				[ll_row] = gnvo_app.is_null
				this.object.cod_cliente			[ll_row] = gnvo_app.is_null
				this.object.nom_cliente			[ll_row] = gnvo_app.is_null
	
				this.object.oper_sec				[ll_row] = gnvo_app.is_null
				this.object.desc_operacion		[ll_row] = gnvo_app.is_null
				yield()
			next
		end if	

	case "cod_tarea"
		ls_cuadrilla = this.object.cod_cuadrilla[row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla')
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_especie = this.object.especie[row]
		
		if ls_especie = '' or IsNull(ls_especie) then
			MessageBox('Error', 'Debe Ingresar un código de especie')
			this.SetColumn('cod_especie')
			return
		end if
		
		ls_presentacion = this.object.cod_presentacion[row]
		
		if ls_presentacion = '' or IsNull(ls_presentacion) then
			MessageBox('Error', 'Debe Ingresar un código de presentacion')
			this.SetColumn('cod_presentacion')
			return
		end if
		
		select distinct ta.desc_tarea
			into :ls_desc
		from 	tg_tareas ta, 
				tg_cuadrillas_labor tcl 
		where tcl.cod_tarea 			= ta.cod_tarea 
		  and ta.flag_estado 		= '1' 
		  and ta.cod_tarea			= :data
		  and tcl.cod_cuadrilla 	= :ls_cuadrilla
		  and tcl.especie 			= :ls_especie
	 	  and tcl.cod_presentacion = :ls_presentacion
		  and ta.cod_tarea			= :data;
		  
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de TAREA " + data + " no existe, no pertenece a la Cuadrilla o no se encuentra activo, por favor verifique")
			
			this.object.cod_tarea			[row] = gnvo_app.is_null
			this.object.desc_tarea			[row] = gnvo_app.is_null
			
			this.object.cod_labor			[row] = gnvo_app.is_null
			this.object.desc_labor			[row] = gnvo_app.is_null
			
			this.object.ot_adm				[row] = gnvo_app.is_null
			this.object.nro_ot				[row] = gnvo_app.is_null
			this.object.titulo				[row] = gnvo_app.is_null
			this.object.cod_cliente			[row] = gnvo_app.is_null
			this.object.nom_cliente			[row] = gnvo_app.is_null

			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if	
				 
		
		this.object.desc_tarea			[row] = ls_desc
		
		this.object.cod_labor			[row] = gnvo_app.is_null
		this.object.desc_labor			[row] = gnvo_app.is_null
		
		this.object.ot_adm				[row] = gnvo_app.is_null
		this.object.nro_ot				[row] = gnvo_app.is_null
		this.object.titulo				[row] = gnvo_app.is_null
		this.object.cod_cliente			[row] = gnvo_app.is_null
		this.object.nom_cliente			[row] = gnvo_app.is_null
		
		this.object.oper_sec				[row] = gnvo_app.is_null
		this.object.desc_operacion		[row] = gnvo_app.is_null
		
		if of_get_labor(row) then
			of_get_oper_sec(row)
		end if
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar la misma CUADRILLA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.cod_tarea			[ll_row] = data
				this.object.desc_tarea			[ll_row] = ls_desc
	
				this.object.cod_labor			[ll_row] = gnvo_app.is_null
				this.object.desc_labor			[ll_row] = gnvo_app.is_null
				
				this.object.ot_adm				[ll_row] = gnvo_app.is_null
				this.object.nro_ot				[ll_row] = gnvo_app.is_null
				this.object.titulo				[ll_row] = gnvo_app.is_null
				this.object.cod_cliente			[ll_row] = gnvo_app.is_null
				this.object.nom_cliente			[ll_row] = gnvo_app.is_null
	
				this.object.oper_sec				[ll_row] = gnvo_app.is_null
				this.object.desc_operacion		[ll_row] = gnvo_app.is_null
				
				if of_get_labor(ll_row) then
					of_get_oper_sec(ll_row)
				end if
				yield()
			next
		end if

	case "cod_labor"
		ls_especie = this.object.especie[row]
		
		if ls_especie = '' or IsNull(ls_especie) then
			MessageBox('Error', 'Debe Ingresar un código de especie', StopSign!)
			this.SetColumn('cod_especie')
			return
		end if
		
		ls_presentacion = this.object.cod_presentacion[row]
		
		if ls_presentacion = '' or IsNull(ls_presentacion) then
			MessageBox('Error', 'Debe Ingresar un código de presentacion', StopSign!)
			this.SetColumn('cod_presentacion')
			return
		end if
		
		ls_tarea = this.object.cod_tarea	[row]
		
		if ls_tarea = '' or IsNull(ls_tarea) then
			MessageBox('Error', 'Debe Ingresar un código de TAREA', StopSign!)
			this.SetColumn('cod_tarea')
			return
		end if
		
		
		select la.desc_labor
			into :ls_desc
		from 	tg_tarifario tt, 
				labor        la 
		where tt.cod_labor        	= la.cod_labor 
		  and tt.cod_especie			= :ls_especie
		  and tt.cod_presentacion 	= :ls_presentacion
		  and tt.cod_tarea			= :ls_tarea
		  and tt.cod_labor			= :data
		  and tt.flag_estado 		= '1';
		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de LABOR " + data + " no existe, no pertenece al TARIFARIO o no se encuentra activo, por favor verifique")
			
			this.object.cod_labor			[row] = gnvo_app.is_null
			this.object.desc_labor			[row] = gnvo_app.is_null
			
			this.object.ot_adm				[row] = gnvo_app.is_null
			this.object.nro_ot				[row] = gnvo_app.is_null
			this.object.titulo				[row] = gnvo_app.is_null
			this.object.cod_cliente			[row] = gnvo_app.is_null
			this.object.nom_cliente			[row] = gnvo_app.is_null

			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if	
				 
		this.object.desc_labor			[row] = ls_Desc
		
		this.object.ot_adm				[row] = gnvo_app.is_null
		this.object.nro_ot				[row] = gnvo_app.is_null
		this.object.titulo				[row] = gnvo_app.is_null
		this.object.cod_cliente			[row] = gnvo_app.is_null
		this.object.nom_cliente			[row] = gnvo_app.is_null
		
		this.object.oper_sec				[row] = gnvo_app.is_null
		this.object.desc_operacion		[row] = gnvo_app.is_null
			
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar la misma CUADRILLA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.cod_labor			[ll_row] = data
				this.object.desc_labor			[ll_row] = ls_desc
				
				this.object.ot_adm				[ll_row] = gnvo_app.is_null
				this.object.nro_ot				[ll_row] = gnvo_app.is_null
				this.object.titulo				[ll_row] = gnvo_app.is_null
				this.object.cod_cliente			[ll_row] = gnvo_app.is_null
				this.object.nom_cliente			[ll_row] = gnvo_app.is_null
	
				this.object.oper_sec				[ll_row] = gnvo_app.is_null
				this.object.desc_operacion		[ll_row] = gnvo_app.is_null
				
				yield()
		
			next
		end if
			
	case "ot_adm"
		ls_cod_art = this.object.cod_art	[row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Ingresar un código de ARTICULO', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		ls_cod_labor = this.object.cod_labor	[row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe Ingresar un código de LABOR', StopSign!)
			this.SetColumn('cod_labor')
			return
		end if
		
		select ota.descripcion
			into :ls_desc
		from 	ot_administracion ota, 
				ot_adm_usuario    otu, 
				(select distinct ot.nro_orden, ot.ot_adm 
					from 	orden_trabajo     ot, 
							articulo_mov_proy amp 
				 where ot.nro_orden      = amp.nro_doc 
				 	and amp.tipo_doc      = (select doc_ot from logparam where reckey = '1') 
					and ot.flag_estado    = '1' 
					and amp.cod_art       = :ls_cod_art
					and amp.flag_estado   = '1') vw, 
				operaciones       op 
		where ota.ot_adm        = otu.ot_adm 
		  and ota.ot_adm        = vw.ot_adm 
		  and vw.nro_orden      = op.nro_orden 
		  and op.cod_labor      = :ls_labor
		  and otu.cod_usr       = :gs_user
	     and op.flag_estado    = '1'
		  and ota.ot_adm			= :data;
				 
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de OT_ADM " + data  + " no existe, o no tiene acceso a ese OT_ADM, por favor verifique" &
									 + "~r~nCod Art: " + ls_cod_art &
									 + "~r~nCod Labor: " + ls_labor &
									 + "~r~nUSuario: " + gs_user, StopSign!)
			
			this.object.ot_adm				[row] = gnvo_app.is_null
			this.object.nro_ot				[row] = gnvo_app.is_null
			this.object.titulo				[row] = gnvo_app.is_null
			this.object.cod_cliente			[row] = gnvo_app.is_null
			this.object.nom_cliente			[row] = gnvo_app.is_null

			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if	
				 

		this.object.nro_ot			[row] = gnvo_app.is_null
		this.object.titulo			[row] = gnvo_app.is_null
		this.object.cod_cliente		[row] = gnvo_app.is_null
		this.object.nom_cliente		[row] = gnvo_app.is_null
		
		this.object.oper_sec			[row] = gnvo_app.is_null
		this.object.desc_operacion	[row] = gnvo_app.is_null
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo OT_ADM para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.ot_adm			[ll_row] = data
		
				this.object.nro_ot			[ll_row] = gnvo_app.is_null
				this.object.titulo			[ll_row] = gnvo_app.is_null
				this.object.cod_cliente		[ll_row] = gnvo_app.is_null
				this.object.nom_cliente		[ll_row] = gnvo_app.is_null
	
				this.object.oper_sec			[ll_row] = gnvo_app.is_null
				this.object.desc_operacion	[ll_row] = gnvo_app.is_null
				yield()
		
			next
		end if

	case "nro_ot"
		ls_cod_art = this.object.cod_art	[row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Error', 'Debe Ingresar un código de ARTICULO', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		ls_cod_labor = this.object.cod_labor	[row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe Ingresar un código de LABOR', StopSign!)
			this.SetColumn('cod_labor')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[row]
		
		if ls_ot_adm = '' or IsNull(ls_ot_adm) then
			MessageBox('Error', 'Debe Ingresar un código de OT_ADM', StopSign!)
			this.SetColumn('ot_adm')
			return
		end if
		
		select distinct ot.nro_orden, ot.titulo, ot.cliente, p.nom_proveedor
			into :ls_titulo, :ls_cliente, :ls_nom_cliente
		from orden_trabajo ot, 
			  proveedor     p, 
			  (select distinct ot.nro_orden, ot.ot_adm 
				  from orden_trabajo     ot, 
						 articulo_mov_proy amp 
				 where ot.nro_orden      = amp.nro_doc 
					and amp.tipo_doc      = (select doc_ot from logparam where reckey = '1') 
					and ot.flag_estado    = '1' 
					and amp.cod_art       = :ls_Cod_art
					and amp.flag_estado   = '1') vw, 
			  operaciones       op 
	  	where ot.nro_orden      	= vw.nro_orden 
		  and ot.cliente        	= p.proveedor  (+) 
		  and op.cod_labor      	= :ls_labor
		  and ot.ot_adm				= :ls_ot_adm
		  and op.flag_estado    	= '1'
		  and ot.nro_orden			= :data;
		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Nro de OT " + data  + " no existe, o no tiene acceso a ese OT_ADM, por favor verifique" &
									 + "~r~nCod Art: " + ls_cod_art &
									 + "~r~nCod Labor: " + ls_labor &
									 + "~r~nOT_ADM: " + ls_ot_adm, StopSign!)
			
			this.object.nro_ot				[row] = gnvo_app.is_null
			this.object.titulo				[row] = gnvo_app.is_null
			this.object.cod_cliente			[row] = gnvo_app.is_null
			this.object.nom_cliente			[row] = gnvo_app.is_null

			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if	
		
				 
		this.object.titulo			[row] = ls_titulo
		this.object.cod_cliente		[row] = ls_cliente
		this.object.nom_cliente		[row] = ls_nom_cliente
		
		this.object.oper_sec			[row] = gnvo_app.is_null
		this.object.desc_operacion	[row] = gnvo_app.is_null
		
		of_get_oper_sec(row)
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo NRO_OT para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
		
				this.object.nro_ot			[ll_row] = data
				this.object.titulo			[ll_row] = ls_titulo
				this.object.cod_cliente		[ll_row] = ls_cliente
				this.object.nom_cliente		[ll_row] = ls_nom_cliente
	
				this.object.oper_sec			[ll_row] = gnvo_app.is_null
				this.object.desc_operacion	[ll_row] = gnvo_app.is_null
				yield()
		
			next
		end if
		
			
	case "oper_sec"
		ls_cod_labor = this.object.cod_labor	[row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe especificar primero una tarea o actividad que tenga un codigo de labor')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[row]
		
		if ls_ot_adm = '' or IsNull(ls_ot_adm) then
			MessageBox('Error', 'Debe especificar primero un OT_ADM')
			this.setColumn('ot_adm')
			return
		end if
		
		ls_nro_orden = this.object.nro_ot	[row]
		
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('Error', 'Debe especificar primero una ORDEN TRABAJO')
			this.setColumn('nro_orden')
			return
		end if
		
		select op.desc_operacion 
			into :ls_desc
		from 	operaciones op, 
				orden_trabajo ot, 
				ot_administracion ota 
		where op.nro_orden   = ot.nro_orden 
		  and ot.ot_adm      = ota.ot_adm 
		  and op.cod_labor   = :ls_cod_labor
		  and ot.ot_adm      = :ls_ot_adm
		  and ot.nro_orden   = :ls_nro_orden
		  and op.oper_sec		= :data
		  and op.flag_estado = '1';

		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de OPERSEC " + data + " no existe, no pertenece al OT o no se encuentra activo, por favor verifique")
			
			this.object.oper_sec				[row] = gnvo_app.is_null
			this.object.desc_operacion		[row] = gnvo_app.is_null

			return 1
			
		end if	
		
		this.object.desc_operacion	[row] = ls_desc
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar la misma CUADRILLA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.oper_sec				[ll_row] = data
				this.object.desc_operacion		[ll_row] = ls_desc
				yield()
			next
		end if
		
end choose
				

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_anular;call super::ue_anular;String	ls_nro_Parte, ls_mensaje
Long		ll_find
if this.rowCount() = 0 then return

if this.object.flag_estado [this.getRow()] = '0' then 
	gnvo_app.of_mensaje_Error("No se puede anular el parte de empaque porque esta anulado")
	return
end if

ls_nro_parte = this.object.nro_parte [this.getRow()]

if MessageBox('PRODUCCIÓN','¿Esta seguro de ANULAR el Parte de Empaque ' + ls_nro_parte + ' esta operacion?',Question!,yesno!) = 2 then
		return
End if

//begin
//  -- Call the procedure
//  pkg_produccion.sp_anular_parte_empaque(asi_nro_parte => :asi_nro_parte);
//end;
DECLARE 	sp_anular_parte_empaque PROCEDURE FOR
			pkg_produccion.sp_anular_parte_empaque(:ls_nro_parte) ;
			
EXECUTE 	sp_anular_parte_empaque ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "Error al ejecutar pkg_produccion.sp_anular_parte_empaque. Mensaje: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE sp_anular_parte_empaque;


event ue_retrieve()

if this.RowCount() > 0 then
	ll_find = this.Find("nro_parte='" + ls_nro_parte + "'", 0, this.RowCount())
	
	if ll_find > 0 then
		this.setRow(ll_find)
		this.SelectRow(0, false)
		this.SelectRow(ll_find, true)
		this.scrollToRow(ll_find)
	end if
end if
end event

event dw_master::ue_filter_avanzado;call super::ue_filter_avanzado;st_rows.text = String(this.RowCount(), '###,##0')
end event

type cb_buscar from commandbutton within w_pr340_recepcion_recepcion
integer x = 1810
integer y = 56
integer width = 571
integer height = 100
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

event clicked;parent.event ue_retrieve( )
end event

type uo_fechas from u_ingreso_rango_fechas within w_pr340_recepcion_recepcion
event destroy ( )
integer x = 503
integer y = 60
integer taborder = 70
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_procesar from commandbutton within w_pr340_recepcion_recepcion
integer x = 2391
integer y = 56
integer width = 763
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar Partes de Recepcion"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_procesar( )
setPointer(Arrow!)
end event

type st_1 from statictext within w_pr340_recepcion_recepcion
integer x = 3867
integer y = 76
integer width = 416
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Registros:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_rows from statictext within w_pr340_recepcion_recepcion
integer x = 4306
integer y = 76
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
boolean focusrectangle = false
end type

type st_nro from statictext within w_pr340_recepcion_recepcion
integer x = 55
integer y = 72
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
boolean focusrectangle = false
end type

type sle_origen from u_sle_codigo within w_pr340_recepcion_recepcion
event ue_dobleclick pbm_lbuttondblclk
integer x = 288
integer y = 60
integer width = 165
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
end type

event ue_dobleclick;string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text = ls_codigo
end if

end event

type cb_1 from commandbutton within w_pr340_recepcion_recepcion
integer x = 3163
integer y = 56
integer width = 718
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aprobar Partes de Recepcion"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_aprobar( )
setPointer(Arrow!)
end event

type gb_2 from groupbox within w_pr340_recepcion_recepcion
integer width = 4567
integer height = 180
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtros para datos"
end type

