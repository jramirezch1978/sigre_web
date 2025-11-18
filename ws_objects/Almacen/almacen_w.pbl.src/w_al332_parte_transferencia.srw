$PBExportHeader$w_al332_parte_transferencia.srw
forward
global type w_al332_parte_transferencia from w_abc_master_smpl
end type
type cb_buscar from commandbutton within w_al332_parte_transferencia
end type
type uo_fechas from u_ingreso_rango_fechas within w_al332_parte_transferencia
end type
type gb_2 from groupbox within w_al332_parte_transferencia
end type
end forward

global type w_al332_parte_transferencia from w_abc_master_smpl
integer width = 4695
integer height = 2292
string title = "[AL332] Parte de Transferencia Interna"
string menuname = "m_mantto_smpl"
windowstate windowstate = maximized!
event ue_retrieve ( )
event ue_retrieve_hrs_row ( long al_row )
cb_buscar cb_buscar
uo_fechas uo_fechas
gb_2 gb_2
end type
global w_al332_parte_transferencia w_al332_parte_transferencia

type variables
integer 	ii_copia
string 	is_desc_turno, is_cod_trabajador, is_nombre, is_cod_tipo_mov, is_desc_movimi, &
		 	is_cod_origen, is_asist_normal, is_salir
datetime id_entrada, id_salida
n_Cst_utilitario 			invo_util
nvo_numeradores_varios	invo_nro
end variables

forward prototypes
public subroutine of_set_modify ()
public function boolean of_getparam ()
public function integer of_horas_trab (long al_row)
public function boolean of_valida_fecha (u_dw_abc adw_1)
public function boolean of_validar_registro (u_dw_abc adw_1)
end prototypes

event ue_retrieve;date 		ld_desde, ld_hasta

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ld_desde, ld_hasta)
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

on w_al332_parte_transferencia.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.gb_2
end on

on w_al332_parte_transferencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

ii_lec_mst = 0

invo_nro = create nvo_numeradores_varios

end event

event ue_update_pre;call super::ue_update_pre;Long 		ll_row
String	ls_nro_parte, ls_nom_tabla

try 
	
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
end event

event ue_anular;call super::ue_anular;dw_master.event ue_Anular()
end event

event ue_insert;//Override
Str_parametros		lstr_param
w_al332_parte_transferencia lw_1

Open(lw_1)

if IsNull(Message.PowerObjectParm) or not isValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return

this.event ue_retrieve( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_al332_parte_transferencia
event ue_display ( string as_columna,  long al_row )
event ue_print_ubicacion ( long al_row )
event ue_print_pallet_org ( long al_row )
event ue_print_pallet_dst ( long al_row )
integer y = 192
integer width = 4123
integer height = 1752
string dataobject = "d_abc_parte_transferencia_tbl"
end type

event dw_master::ue_display;string 	ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, &
			ls_return7, ls_nro_ot, ls_almacen
boolean 	lb_ret

if dw_master.ii_protect = 1 then return

choose case lower(as_columna)

	case 'nro_ot'
		ls_sql = "select ot.nro_orden as nro_orden, " &
				 + "ot.titulo as titulo_ot, " &
				 + "ot.cliente as cliente, " &
				 + "p.nom_proveedor as nom_cliente " &
				 + "from orden_trabajo ot, " &
				 + "     proveedor     p," &
				 + "     ot_adm_usuario otu " &
				 + "where ot.cliente = p.proveedor (+) " &
				 + "  AND ot.ot_tipo in (select * from table(split(PKG_CONFIG.USF_GET_PARAMETER('PRODUCCION_TIPOS_OT', 'PROD,REPR,RPQE'))))" &
				 + "  and ot.ot_adm  = otu.ot_adm " &
				 + "  and otu.cod_usr = '" + gs_user + "'" &
				 + "  and ot.flag_estado = '1' "
				 
		lb_ret = f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_Return4, '2')
		if lb_ret and ls_return1 <>''then 
			this.object.nro_ot		[al_row] = ls_return1
			this.object.titulo		[al_row] = ls_return2
			this.object.cliente		[al_row] = ls_return3
			this.object.nom_cliente	[al_row] = ls_return4
			this.ii_update = 1
		end if
		 
		
	case "almacen_mp"
		ls_nro_ot = this.object.nro_ot  [al_row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_sql = "select distinct al.almacen as almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "from articulo_mov_proy amp, " &
				 + "     almacen           al, " &
				 + "     articulo          a " &
				 + "where amp.almacen = al.almacen " &
				 + "  and amp.cod_Art = a.cod_art " &
				 + "  and amp.nro_doc = '" + ls_nro_ot + "'" &
				 + "  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') " &
				 + "  and amp.tipo_mov = (select l.oper_cons_interno from logparam l where l.reckey = '1') " &
				 + "  and al.flag_tipo_almacen = 'P'" &
				 + "  and amp.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.almacen_mp			[al_row] = ls_return1
			this.object.desc_almacen_mp	[al_row] = ls_return2

			this.ii_update = 1
		end if

	case "cod_art_mp"
		ls_nro_ot = this.object.nro_ot  [al_row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_almacen = this.object.almacen_mp  [al_row]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un almacen de materia prima")
			this.setColumn("almacen_mp")
			return
		end if
		
		ls_sql = "select a.cod_art as codigo_articulo, " &
				 + "a.desc_art as descripcion_Articulo, " &
				 + "a.und as und, " &
				 + "amp.cod_origen, " &
				 + "amp.nro_mov " &
				 + "from articulo_mov_proy amp, " &
				 + "     articulo          a " &
				 + "where amp.cod_Art = a.cod_art " &
				 + "  and amp.nro_doc = '" + ls_nro_ot + "'" &
				 + "  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') " &
				 + "  and amp.tipo_mov = (select l.oper_cons_interno from logparam l where l.reckey = '1') " &
				 + "  and amp.almacen = '" + ls_almacen + "'" &
				 + "  and amp.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, &
											ls_return5, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.cod_art_mp			[al_row] = ls_return1
			this.object.desc_art_mp			[al_row] = ls_return2
			this.object.und					[al_row] = ls_return3
			this.object.org_amp_cons		[al_row] = ls_return4
			this.object.nro_amp_cons		[al_row] = Long(ls_return5)
			this.ii_update = 1
		end if
		
	case "almacen_pptt"
		ls_nro_ot = this.object.nro_ot  [al_row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_sql = "select distinct al.almacen as almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "from articulo_mov_proy amp, " &
				 + "     almacen           al, " &
				 + "     articulo          a " &
				 + "where amp.almacen = al.almacen " &
				 + "  and amp.cod_Art = a.cod_art " &
				 + "  and amp.nro_doc = '" + ls_nro_ot + "'" &
				 + "  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') " &
				 + "  and amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1') " &
				 + "  and amp.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.almacen_pptt		[al_row] = ls_return1
			this.object.desc_almacen_pptt	[al_row] = ls_return2

			this.ii_update = 1
		end if	

	case "cod_art_pptt"
		ls_nro_ot = this.object.nro_ot  [al_row]
		
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero una orden de trabajo")
			this.setColumn("nro_ot")
			return
		end if
		
		ls_almacen = this.object.almacen_pptt  [al_row]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un almacen de producto terminado")
			this.setColumn("almacen_pptt")
			return
		end if
		
		ls_sql = "select a.cod_art as codigo_articulo, " &
				 + "a.desc_art as descripcion_Articulo, " &
				 + "a.und as und, " &
				 + "a.und2 as und2, " &
				 + "a.factor_conv_und as factor_conv_und, " &
				 + "amp.cod_origen, " &
				 + "amp.nro_mov " &
				 + "from articulo_mov_proy amp, " &
				 + "     articulo          a " &
				 + "where amp.cod_Art = a.cod_art " &
				 + "  and amp.nro_doc = '" + ls_nro_ot + "'" &
				 + "  and amp.tipo_doc = (select l.doc_ot from logparam l where l.reckey = '1') " &
				 + "  and amp.tipo_mov = (select l.oper_ing_prod from logparam l where l.reckey = '1') " &
				 + "  and amp.almacen = '" + ls_almacen + "'" &
				 + "  and amp.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, &
											ls_return5, ls_return6, ls_return7, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.cod_art_pptt		[al_row] = ls_return1
			this.object.desc_art_pptt		[al_row] = ls_return2
			this.object.und_pptt				[al_row] = ls_return3
			this.object.und2_pptt			[al_row] = ls_return4
			this.object.factor_conv_und	[al_row] = Dec(ls_return5)
			this.object.org_amp_ing			[al_row] = ls_return6
			this.object.nro_amp_ing			[al_row] = Long(ls_return7)
			this.ii_update = 1
		end if	
		
	case "turno"
		ls_sql = "select turno as turno, " &
				 + "t.descripcion as desc_turno " &
				 + "from turno t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.turno			[al_row] = ls_return1
			this.object.desc_turno	[al_row] = ls_return2

			this.ii_update = 1
		end if		
		
	case "cod_presentacion"
		ls_sql = "select tp.cod_presentacion as codigo_presentacion, " &
				 + "tp.desc_presentacion as descripcion_presentacion " &
				 + "from tg_presentacion tp " &
				 + "where tp.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.cod_presentacion	[al_row] = ls_return1
			this.object.desc_presentacion	[al_row] = ls_return2

			this.ii_update = 1
		end if	

	case "nro_pallet"
		ls_sql = "select t.nro_pallet as nro_pallet " &
				 + "from TG_PARTE_EMPAQUE t " &
				 + "where t.flag_estado = '1' " &
				 + "  and t.nro_pallet is not null"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.nro_pallet			[al_row] = ls_return1

			this.ii_update = 1
		end if		

	case "cliente_final"
		ls_sql = "select p.proveedor as codigo_cliente, " &
				 + "p.nom_proveedor as nombre_cliente " &
				 + "from proveedor p " &
				 + "where p.flag_estado = '1'" &
				 + "  and p.flag_clie_prov in ('1', '2')"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.cliente_final		[al_row] = ls_return1
			this.object.nom_cliente_final	[al_row] = ls_return2

			this.ii_update = 1
		end if			

	case "cod_tratamiento"
		ls_sql = "select t.codigo as codigo_tratamiento, " &
				 + "t.descripcion as descripcion_tratamiento " &
				 + "from TG_TRATAMIENTO_QUI t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if lb_ret and ls_return1 <> '' then
			this.object.cod_tratamiento	[al_row] = ls_return1
			this.object.desc_tratamiento	[al_row] = ls_return2

			this.ii_update = 1
		end if		
end choose
				

end event

event dw_master::ue_print_ubicacion(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if

	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_codigos_ubicacion_pptt_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos Recepcion PPTT'
	lstr_rep.string1 	= dw_master.object.nro_parte	[al_row]
	lstr_rep.tipo		= '5'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::ue_print_pallet_org(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if

	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_pallet_fusion_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_pallet_org[al_row]
	lstr_rep.string2 	= dw_master.object.almacen_org	[al_row]
	lstr_rep.tipo		= '6'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::ue_print_pallet_dst(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if

	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_pallet_fusion_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_pallet_dst[al_row]
	lstr_rep.string2 	= dw_master.object.almacen_dst	[al_row]
	lstr_rep.string3 	= dw_master.object.nro_vale_ing	[al_row]
	lstr_rep.tipo		= '6'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime	ldt_Fec_registro

ldt_fec_registro = gnvo_app.of_fecha_actual()

this.object.cod_usr			[al_row] = gs_user
this.object.cod_origen		[al_row] = gs_origen
this.object.fec_registro	[al_row] = ldt_fec_registro
this.object.fec_produccion	[al_row] = Date(ldt_fec_registro)
this.object.fec_empaque		[al_row] = Date(ldt_fec_registro)
this.object.flag_Estado		[al_row] = '1'



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

event dw_master::itemchanged;call super::itemchanged;string 	ls_nro_trazabilidad, ls_jefe_turno, ls_grupo_empaque, ls_flag_tipo_proceso, &
			ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, ls_nro_ot, &
			ls_almacen, ls_juliano, ls_year
date		ld_fec_produccion, ld_fec_empaque
decimal	ldc_factor_conv_und, ldc_total_cajas
Long		ll_nro_mov, ll_year

this.AcceptText()

choose case lower(dwo.name)


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
	
	case 'cant_producida'
		
		ldc_factor_conv_und = Dec(this.object.factor_conv_und [row])
		
		if not IsNull(ldc_factor_conv_und) and ldc_factor_conv_und > 0 then
			ldc_total_cajas = Dec(data) * ldc_factor_conv_und
			this.object.total_caja [row] = ldc_total_cajas
		end if
		
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
		  and al.flag_tipo_almacen = 'P'
		  and amp.flag_estado = '1'
		  and al.almacen = :data;
		
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Código de Almacen ' + data + ' no existe, no se encuentra activo, ' &
								  + 'no es almacen de Materia Prima, o no corresponde a la Orden de Trabajo ' &
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
		
		select a.desc_art, a.und, a.und2, a.factor_conv_und, amp.cod_origen, amp.nro_mov
			into :ls_return1, :ls_return2, :ls_return3, :ldc_factor_conv_und, :ls_return4, :ll_nro_mov
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
			this.object.factor_conv_und	[row] = gnvo_app.idc_null
			this.object.org_amp_ing			[row] = gnvo_app.is_null
			this.object.nro_amp_ing			[row] = gnvo_app.il_null
			Return 1
		END IF

		this.object.desc_art_pptt		[row] = ls_return1
		this.object.und_pptt				[row] = ls_return2
		this.object.und2_pptt			[row] = ls_return3
		this.object.factor_conv_und	[row] = ldc_factor_conv_und
		this.object.org_amp_ing			[row] = ls_return4
		this.object.nro_amp_ing			[row] = ll_nro_mov
		
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
	
	case "b_print_ubicacion"
		this.event dynamic ue_print_ubicacion(row)
		
	case "b_print_pallet_dst"
		this.event dynamic ue_print_pallet_dst(row)
End choose
end event

event dw_master::ue_anular;call super::ue_anular;String	ls_nro_Parte, ls_mensaje
Long		ll_find
if this.rowCount() = 0 then return

if this.object.flag_estado [this.getRow()] = '0' then 
	gnvo_app.of_mensaje_Error("No se puede anular el parte de transferencia porque esta anulado")
	return
end if

ls_nro_parte = this.object.nro_parte [this.getRow()]

if MessageBox('PRODUCCIÓN','¿Esta seguro de ANULAR el Parte de TRANSFERENCIA ' + ls_nro_parte + ' ?',Question!,yesno!) = 2 then
		return
End if

//begin
//  -- Call the procedure
//  pkg_produccion.sp_anular_parte_tranferencia(asi_nro_parte => :asi_nro_parte);
//end;
  
DECLARE 	sp_anular_parte_tranferencia PROCEDURE FOR
			pkg_produccion.sp_anular_parte_tranferencia(:ls_nro_parte) ;
			
EXECUTE 	sp_anular_parte_tranferencia ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "Error al ejecutar pkg_produccion.sp_anular_parte_tranferencia. Mensaje: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE sp_anular_parte_tranferencia;

commit;

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

type cb_buscar from commandbutton within w_al332_parte_transferencia
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

type uo_fechas from u_ingreso_rango_fechas within w_al332_parte_transferencia
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

type gb_2 from groupbox within w_al332_parte_transferencia
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
string text = "Filtro Parte de Recepcion"
end type

