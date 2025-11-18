$PBExportHeader$w_pr336_parte_conservas.srw
forward
global type w_pr336_parte_conservas from w_abc_master_smpl
end type
type cb_buscar from commandbutton within w_pr336_parte_conservas
end type
type uo_fechas from u_ingreso_rango_fechas within w_pr336_parte_conservas
end type
type st_1 from statictext within w_pr336_parte_conservas
end type
type st_rows from statictext within w_pr336_parte_conservas
end type
type gb_2 from groupbox within w_pr336_parte_conservas
end type
end forward

global type w_pr336_parte_conservas from w_abc_master_smpl
integer width = 4695
integer height = 2292
string title = "[PR336] Parte de Empaque CONSERVA - PRODUCCION"
string menuname = "m_mantto_smpl"
windowstate windowstate = maximized!
event ue_retrieve ( )
event ue_retrieve_hrs_row ( long al_row )
event ue_procesar ( )
cb_buscar cb_buscar
uo_fechas uo_fechas
st_1 st_1
st_rows st_rows
gb_2 gb_2
end type
global w_pr336_parte_conservas w_pr336_parte_conservas

type variables
integer 	ii_copia
String	is_partes[], is_null[]
string 	is_desc_turno, is_cod_trabajador, is_nombre, is_cod_tipo_mov, is_desc_movimi, &
		 	is_cod_origen, is_asist_normal, is_salir
datetime id_entrada, id_salida

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
end prototypes

event ue_retrieve;date 		ld_desde, ld_hasta

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ld_desde, ld_hasta)

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
dw_master.Modify("cant_producida.Protect ='1~tIf(flag_estado=~~'0~~' or if(isnull(factor_conv_und), 0, factor_conv_und) > 0,1,0)'")

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

on w_pr336_parte_conservas.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.st_1=create st_1
this.st_rows=create st_rows
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_rows
this.Control[iCurrent+5]=this.gb_2
end on

on w_pr336_parte_conservas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.st_1)
destroy(this.st_rows)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

ii_lec_mst = 0

invo_nro = create nvo_numeradores_varios
invo_wait = create n_cst_wait

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
	
	//Proceso los partes que han sido modificados o incluidos
	if UpperBound(is_partes) > 0 then
		for ll_i = 1 to UpperBound(is_partes) 
			if not of_procesar(is_partes[ll_i]) then return
		next
	end if
	
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
String			ls_nro_parte
str_parametros	lstr_param

if dw_master.RowCount() = 0 then return

ls_nro_parte = dw_master.object.nro_parte [dw_master.getRow()]

lstr_param.string1 = ls_nro_parte

OpenWithParm(w_pr337_parte_conservas_popup, lstr_param)

end event

event ue_anular;call super::ue_anular;dw_master.event ue_Anular()
end event

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_insert;//Override

open(w_pr337_parte_conservas_popup)
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr336_parte_conservas
event ue_display ( string as_columna,  long al_row )
event ue_print_cus ( long al_row )
event ue_print_pallet ( long al_row )
integer y = 192
integer width = 4123
integer height = 1752
string dataobject = "d_abc_parte_conserva_tbl"
end type

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
	
	//Valido que el registro tenga pallet y tambien tenga vale de Ingreso
	ls_nro_pallet 		= this.object.nro_pallet		[al_row]
	ls_nro_vale_ing 	= this.object.nro_vale_ing		[al_row]
	
	if IsNull(ls_nro_pallet) or trim(ls_nro_pallet) = '' then
		MessageBox('Error', 'NO puede imprimir EL PALLET de este registro porque no tiene asignado un Nro de Pallet, por favor corrija', StopSign!)
		return
	end if

	if IsNull(ls_nro_vale_ing) or trim(ls_nro_vale_ing) = '' then
		MessageBox('Error', 'NO puede imprimir EL PALLET de este registro porque no VALE DE INGRESO, por favor corrija', StopSign!)
		return
	end if

	//Corresponde a un almacen de Productos Terminados
	if upper(gs_empresa) = 'TRANSMARINA' or upper(gs_empresa) = 'PROTEICOS' then
		lstr_rep.dw1 		= 'd_rpt_codigos_pallet_transmarina_lbl'
	elseif upper(gs_empresa) = 'SEAFROST' then
		lstr_rep.dw1 		= 'd_rpt_codigos_pallet_seafrost_lbl'
	else
		lstr_rep.dw1 		= 'd_rpt_codigos_pallet_conserva_lbl'
	end if
	
	lstr_rep.titulo 	= 'Previo de PALLETS para conserva'
	lstr_rep.string1 	= dw_master.object.nro_pallet	[al_row]
	lstr_rep.tipo		= '11'
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

of_restringir_campos()
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_nro_trazabilidad, ls_jefe_turno, ls_grupo_empaque, ls_flag_tipo_proceso, &
			ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, ls_nro_ot, &
			ls_almacen, ls_juliano, ls_year, ls_flag_und2, ls_cod_art
date		ld_fec_produccion, ld_fec_empaque
decimal	ldc_factor_conv_und, ldc_total_cajas, ldc_cant_producida
Long		ll_nro_mov, ll_year, ll_count
Date		ld_fecha

this.AcceptText()

choose case lower(dwo.name)

	case "der"
		ls_cod_art = this.object.cod_art_mp [row]
		
		if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un Articulo de MATERIA PRIMA")
			this.setColumn("cod_art_mp")
			return
		end if
		
		select count(*)
			into :ll_count
		from ap_pd_descarga_det b,
			  ap_pd_descarga     a
		where a.nro_parte = b.nro_parte   
		  and b.der is not null
		  and b.der = :data
		  and b.cod_art = :ls_cod_art;
				 
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','DER ingresado ' + data + ' no existe, ' &
								  + 'o no le corresponder al articulo ' &
								  + ls_cod_art + ' no hay parte de recepcion de Materia prima ' &
								  + 'activo con ese DER, Verifique! ',StopSign!)
								  
			this.object.der			[row] = gnvo_app.is_null
			Return 1
		END IF

		
	case 'jefe_turno', 'grupo_empaque', 'flag_tipo_proceso', 'fec_empaque', 'fec_produccion'
		
		//Obtengo la fecha de produccion y de empaque
		ld_fec_produccion = Date(this.object.fec_produccion [row])
		ld_fec_empaque 	= Date(this.object.fec_empaque [row])
		
		if ld_fec_empaque < ld_fec_produccion then
			gnvo_app.of_mensaje_error("La fecha de empaque no puede ser menor a la fecha de produccion")
			this.object.fec_empaque [row] = this.object.fec_produccion [row]
			this.setColumn("fec_empaque")
			return
		end if
		
		//Obtengo el jefe de turno
		ls_jefe_turno = this.object.jefe_turno [row]
		if IsNull(ls_jefe_turno) or trim(ls_jefe_turno) = '' then return
		
		//Obtengo el grupo de empaque
		ls_grupo_empaque = this.object.grupo_empaque [row]
		if IsNull(ls_grupo_empaque) or trim(ls_grupo_empaque) = '' then return
		
		//Obtengo el tipo de proceso
		ls_flag_tipo_proceso = this.object.flag_tipo_proceso [row]
		if IsNull(ls_flag_tipo_proceso) or trim(ls_flag_tipo_proceso) = '' then return
		
		//Genero el nro de trazabilidad
		ls_juliano = invo_util.of_get_juliano(ld_fec_produccion)
		ll_year = Long(right(string(year(ld_Fec_produccion)),2)) - Long(right(ls_juliano,1))
		
		ls_nro_trazabilidad = ls_jefe_turno + ls_grupo_empaque + ls_juliano &
								  + string(ll_year, '00') + ls_flag_tipo_proceso &
								  + invo_util.of_get_juliano(ld_Fec_empaque)
		
		this.object.nro_trazabilidad	[row] = ls_nro_trazabilidad
	
		this.ii_update = 1

	case 'total_caja'
		
		ls_flag_und2			= this.object.flag_und2 				[row]
		ldc_factor_conv_und 	= Dec(this.object.factor_conv_und 	[row])
		
		if ls_flag_und2 = '0' then 
			gnvo_app.of_mensaje_error("No esta permitido ingresar esta cantidad, porque no ha especificado el flag_und2 del articulo, por favor corrija")
			this.object.total_caja 		[row] = 0.00
			this.object.cant_producida [row] = 0.00
			return 1
		end if
		
		if ls_flag_und2 = '1' and (IsNull(ldc_factor_conv_und) or ldc_factor_conv_und = 0) then
			gnvo_app.of_mensaje_error("No se ha especificado el factor de conversion, por favor corrija")
			this.object.cant_producida [row] = 0.00
			this.object.total_caja 		[row] = 0.00
			return 1
		end if
		
		if ldc_factor_conv_und > 0 then
			ldc_cant_producida = Dec(data) / ldc_factor_conv_und
		else
			ldc_cant_producida = 1
		end if
		this.object.cant_producida [row] = ldc_cant_producida
		
//	case 'cant_producida'
//		
//		ls_flag_und2			= this.object.flag_und2 				[row]
//		ldc_factor_conv_und 	= Dec(this.object.factor_conv_und 	[row])
//		
//		if ls_flag_und2 = '0' then 
//			this.object.total_caja [row] = 0.00
//			return 1
//		end if
//		
//		if ls_flag_und2 = '1' and (IsNull(ldc_factor_conv_und) or ldc_factor_conv_und = 0) then
//			gnvo_app.of_mensaje_error("No se ha especificado el factor de conversion, por favor corrija")
//			this.object.cant_producida [row] = 0.00
//			this.object.total_caja [row] = 0.00
//			return 1
//		end if
//		
//		if ldc_factor_conv_und > 0 then
//			ldc_total_cajas = Dec(data) * ldc_factor_conv_und
//		else
//			ldc_total_cajas = 1
//		end if
//		this.object.total_caja [row] = ldc_total_cajas
		
	case 'lugar_empaque'
		select desc_sala
			into :ls_return1
		  from tg_lugar_empaque 
		where flag_estado = '1'
		  and lugar_empaque = :data;
		
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Lugar de empaque , ' + data + ' no existe o no esta activo.' &
								  + ' Por favor Verifique! ',StopSign!)
			this.object.lugar_empaque		[row] = gnvo_app.is_null
			this.object.desc_lugar_empaque[row] = gnvo_app.is_null
			Return 1
		END IF
			 
		this.object.desc_lugar_empaque		[row] = ls_return1
		
	case 'nro_tunel'
		select desc_tunel
			into :ls_return1
		  from tg_tuneles_frio 
		where flag_estado = '1'
		  and nro_tunel = :data;
		
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Nro de Tunel , ' + data + ' no existe o no esta activo.' &
								  + ' Por favor Verifique! ',StopSign!)
			this.object.nro_tunel		[row] = gnvo_app.is_null
			this.object.desc_tunel		[row] = gnvo_app.is_null
			Return 1
		END IF
			 
		this.object.desc_tunel		[row] = ls_return1

	case 'nro_ot'
		select ot.titulo, ot.cliente, p.nom_proveedor
			into :ls_return1, :ls_return2, :ls_return3
		  from orden_trabajo ot,
				 proveedor     p,
				 ot_adm_usuario otu 
		where ot.cliente = p.proveedor (+) 
		  AND ot.ot_tipo in (select * from table(split(PKG_CONFIG.USF_GET_PARAMETER('PRODUCCION_TIPOS_OT', 'PROD,REPR,RPQE'))))
		  and ot.ot_adm  = otu.ot_adm 
		  and otu.cod_usr = :gs_user
		  and ot.flag_estado = '1'
		  and ot.nro_orden = :data;
		
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Nro de Orden de Trabajo ' + data &
								  + ' no existe, no se encuentra activo o tiene acceso a su OT_ADM, ' &
								  + 'por favor Verifique! ',StopSign!)
			this.object.nro_ot		[row] = gnvo_app.is_null
			this.object.titulo		[row] = gnvo_app.is_null
			this.object.cliente		[row] = gnvo_app.is_null
			this.object.nom_cliente	[row] = gnvo_app.is_null
			Return 1
		END IF
			 
		this.object.titulo		[row] = ls_return1
		this.object.cliente		[row] = ls_return2
		this.object.nom_cliente	[row] = ls_return3
				 
	case "almacen_mp"
		ls_nro_ot = this.object.nro_ot  [row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe ingresar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		select al.desc_almacen
			into :ls_return2
		from 	articulo_mov_proy amp, 
				almacen           al, 
				articulo          a 
		where amp.almacen = al.almacen 
		  and amp.cod_Art = a.cod_art 
		  and amp.nro_doc = :ls_nro_ot
		  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') 
		  and amp.tipo_mov = (select l.oper_cons_interno from logparam l where l.reckey = '1') 
		  and al.flag_tipo_almacen in ('P', 'T')
		  and amp.flag_estado = '1'
		  and al.almacen = :data;
		
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de Almacen ' + data + ' no existe, no se encuentra activo, ' &
								  + 'no es almacen de Materia Prima o Producto Terminado, o no corresponde a la Orden de Trabajo ' &
								  + ls_nro_ot + ', Verifique! ',StopSign!)
			this.object.almacen_mp		[row] = gnvo_app.is_null
			this.object.desc_almacen_mp[row] = gnvo_app.is_null
			Return 1
		END IF
			 
		this.object.desc_almacen_mp		[row] = ls_return1
		

	case "cod_art_mp"
		ls_nro_ot = this.object.nro_ot  [row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_almacen = this.object.almacen_mp  [row]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un almacen de materia prima")
			this.setColumn("almacen_mp")
			return
		end if
		
		select a.desc_art, a.und, amp.cod_origen, amp.nro_mov
			into :ls_return1, :ls_return2, :ls_return3, :ll_nro_mov
		from articulo_mov_proy amp, 
			  articulo          a 
		where amp.cod_Art 		= a.cod_art 
		  and amp.nro_doc 		= :ls_nro_ot
		  and amp.tipo_doc 		= (select l.doc_ot from logparam l where l.reckey = '1') 
	  	  and amp.tipo_mov 		= (select l.oper_cons_interno from logparam l where l.reckey = '1') 
		  and amp.almacen 		= :ls_almacen
		  and amp.flag_estado 	= '1'
		  and amp.cod_art			= :data;
				 
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de ARTICULO ' + data + ' no existe, no se encuentra activo, ' &
								  + 'no pertenece a la OT ' + ls_nro_ot + ' o no corresponde al almacen ' &
								  + ls_almacen + ', Verifique! ',StopSign!)
			this.object.cod_art_mp			[row] = gnvo_app.is_null
			this.object.desc_art_mp			[row] = gnvo_app.is_null
			this.object.und					[row] = gnvo_app.is_null
			this.object.org_amp_cons		[row] = gnvo_app.is_null
			this.object.nro_amp_cons		[row] = gnvo_app.il_null
			Return 1
		END IF
			 
		this.object.desc_art_mp			[row] = ls_return1
		this.object.und					[row] = ls_return2
		this.object.org_amp_cons		[row] = ls_return3
		this.object.nro_amp_cons		[row] = ll_nro_mov
		
	case "almacen_pptt"
		ls_nro_ot = this.object.nro_ot  [row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		select al.desc_almacen
			into :ls_return1
		from 	articulo_mov_proy amp,
				almacen           al, 
				articulo          a 
		where amp.almacen = al.almacen 
		  and amp.cod_Art = a.cod_art 
		  and amp.nro_doc = :ls_nro_ot
		  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') 
		  and amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1')
		  and amp.flag_estado 	= '1'
		  and al.almacen			= :data;
				 
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de Almacen ' + data + ' no existe, no se encuentra activo, ' &
								  + 'no es almacen de PRODUCTO TERMINADO, o no corresponde a la Orden de Trabajo ' &
								  + ls_nro_ot + ', Verifique! ',StopSign!)
			this.object.almacen_pptt		[row] = gnvo_app.is_null
			this.object.desc_almacen_pptt	[row] = gnvo_app.is_null
			Return 1
		END IF
			 
		this.object.desc_almacen_pptt	[row] = ls_return1
		
	case "cod_art_pptt"
		ls_nro_ot = this.object.nro_ot  [row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_almacen = this.object.almacen_pptt  [row]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un almacen de producto terminado")
			this.setColumn("almacen_pptt")
			return
		end if
		
		select a.desc_art, a.und, a.und2, a.factor_conv_und, amp.cod_origen, amp.nro_mov, 
				 a.flag_und2
			into :ls_return1, :ls_return2, :ls_return3, :ldc_factor_conv_und, :ls_return4, :ll_nro_mov,
					:ls_flag_und2
		from 	articulo_mov_proy amp, 
				articulo          a 
		where amp.cod_Art = a.cod_art 
		  and amp.nro_doc = :ls_nro_ot
		  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') 
		  and amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1') 
		  and amp.almacen = :ls_almacen
		  and amp.flag_estado 	= '1'
		  and amp.cod_art			= :data;
		
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de ARTICULO ' + data + ' no existe, no se encuentra activo, ' &
								  + 'no pertenece a la OT ' + ls_nro_ot + ' o no corresponde al almacen ' &
								  + ls_almacen + ', Verifique! ',StopSign!)
								  
			this.object.cod_art_pptt		[row] = gnvo_app.is_null
			this.object.desc_art_pptt		[row] = gnvo_app.is_null
			this.object.und_pptt				[row] = gnvo_app.is_null
			this.object.und2_pptt			[row] = gnvo_app.is_null
			this.object.flag_und2			[row] = gnvo_app.is_null
			this.object.factor_conv_und	[row] = gnvo_app.idc_null
			this.object.org_amp_ing			[row] = gnvo_app.is_null
			this.object.nro_amp_ing			[row] = gnvo_app.il_null
			
			this.object.total_caja			[row] = 0
			this.object.cant_producida		[row] = 0
		
			Return 1
		END IF

		this.object.desc_art_pptt		[row] = ls_return1
		this.object.und_pptt				[row] = ls_return2
		this.object.und2_pptt			[row] = ls_return3
		this.object.flag_und2			[row] = ls_flag_und2
		this.object.factor_conv_und	[row] = ldc_factor_conv_und
		this.object.org_amp_ing			[row] = ls_return4
		this.object.nro_amp_ing			[row] = ll_nro_mov
		
		this.object.total_caja			[row] = 0
		this.object.cant_producida		[row] = 0
		
	case "turno"
		select t.descripcion
			into :ls_return1
		from turno t 
		where t.flag_estado = '1'
		  and t.turno = :data;
				 
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de TURNO ' + data + ' no existe o no se encuentra activo, Verifique! ',StopSign!)
								  
			this.object.turno			[row] = gnvo_app.is_null
			this.object.desc_turno	[row] = gnvo_app.is_null
			Return 1
		END IF

		this.object.desc_turno	[row] = ls_return1
		
	case "cod_presentacion"
		select tp.desc_presentacion 
			into :ls_return1
		from tg_presentacion tp 
		where tp.flag_estado = '1'
		  and tp.cod_presentacion = :data;
				 
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de TURNO ' + data + ' no existe o no se encuentra activo, Verifique! ',StopSign!)
								  
			this.object.cod_presentacion	[row] = gnvo_app.is_null
			this.object.desc_presentacion	[row] = gnvo_app.is_null
			Return 1
		END IF

		this.object.desc_presentacion	[row] = ls_return1
		
End choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::buttonclicked;call super::buttonclicked;String ls_nro_parte, ls_nro_pallet, ls_origen
this.AcceptText()


choose case lower(dwo.name)

	case "b_print_pallet"
		this.event dynamic ue_print_pallet(row)		
End choose
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
DECLARE 	sp_anular_parte_empaque_sin_cu PROCEDURE FOR
			pkg_produccion.sp_anular_parte_empaque_sin_cu(:ls_nro_parte) ;
			
EXECUTE 	sp_anular_parte_empaque_sin_cu ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "Error al ejecutar pkg_produccion.sp_anular_parte_empaque_sin_cu(). Mensaje: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE sp_anular_parte_empaque_sin_cu;


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

event dw_master::doubleclicked;call super::doubleclicked;//Override
String			ls_nro_parte
str_parametros	lstr_param

if row  > 0 then


	ls_nro_parte = this.object.nro_parte [row]
	
	lstr_param.string1 = ls_nro_parte
	
	OpenWithParm(w_pr337_parte_conservas_popup, lstr_param)

end if
end event

type cb_buscar from commandbutton within w_pr336_parte_conservas
integer x = 1330
integer y = 48
integer width = 571
integer height = 100
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
end event

type uo_fechas from u_ingreso_rango_fechas within w_pr336_parte_conservas
event destroy ( )
integer x = 14
integer y = 56
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

type st_1 from statictext within w_pr336_parte_conservas
integer x = 3611
integer y = 100
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

type st_rows from statictext within w_pr336_parte_conservas
integer x = 4050
integer y = 100
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

type gb_2 from groupbox within w_pr336_parte_conservas
integer width = 4320
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
string text = "Filtro Parte de Conservas"
end type

