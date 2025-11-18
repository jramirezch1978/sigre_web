$PBExportHeader$w_pr328_parte_detajo_masivo.srw
forward
global type w_pr328_parte_detajo_masivo from w_abc_mastdet
end type
type st_campo from statictext within w_pr328_parte_detajo_masivo
end type
type dw_3 from datawindow within w_pr328_parte_detajo_masivo
end type
type sle_nro from u_sle_codigo within w_pr328_parte_detajo_masivo
end type
type cb_1 from commandbutton within w_pr328_parte_detajo_masivo
end type
type st_nro from statictext within w_pr328_parte_detajo_masivo
end type
end forward

global type w_pr328_parte_detajo_masivo from w_abc_mastdet
integer width = 3922
integer height = 2236
string title = "[PR328] Parte de Desatjo Masivo"
string menuname = "m_mantto_smpl"
st_campo st_campo
dw_3 dw_3
sle_nro sle_nro
cb_1 cb_1
st_nro st_nro
end type
global w_pr328_parte_detajo_masivo w_pr328_parte_detajo_masivo

type variables
String 	is_col, is_tipo, is_old_color, is_empresa, is_desc_empresa
n_cst_utilitario 	invo_util
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_parte)
public subroutine of_verifica_cuadrilla (string as_cuadrilla, long al_row)
public function boolean of_validar_trabajador (string as_trabajador, long al_row)
public function boolean of_validar ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_nro_parte, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

try 
	if is_action = 'new' then
		select count(*)
			into :ll_count
		from NUM_TG_PD_DESTAJO
		where origen = :gs_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla NUM_TG_PD_DESTAJO. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		if ll_count = 0 then
			insert into NUM_TG_PD_DESTAJO(origen, ult_nro)
			values( :gs_origen, 1);
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TG_PD_DESTAJO. Mensaje: " + ls_mensaje, StopSign!)
				return 0
			end if
		
		end if
		
		SELECT ult_nro
		  INTO :ll_ult_nro
		FROM NUM_TG_PD_DESTAJO
		where origen = :gs_origen for update;
	
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla NUM_TG_PD_DESTAJO. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		if gnvo_app.of_get_parametro("PROD_PARTE_DESTAJO_HEXADECIMAL", "0") = "1" then
			ls_nro_parte = trim(gs_origen) + invo_util.lpad(invo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(gs_origen)), '0')
		else
			ls_nro_parte = trim(gs_origen) + invo_util.lpad( string(ll_ult_nro) , 10 - len(trim(gs_origen)), '0')
		end if
		
		//Valido si el nro de parte existe
		select count(*)
		  into :ll_count
		  from tg_pd_destajo
		where nro_parte = :ls_nro_parte;
		
		do while ll_count > 0 
			//Incremento el numerador
			ll_ult_nro ++
			
			//Obtengo el siguiente numero de parte
			if gnvo_app.of_get_parametro("PROD_PARTE_DESTAJO_HEXADECIMAL", "0") = "1" then
				ls_nro_parte = trim(gs_origen) + invo_util.lpad(invo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(gs_origen)), '0')
			else
				ls_nro_parte = trim(gs_origen) + invo_util.lpad( string(ll_ult_nro) , 10 - len(trim(gs_origen)), '0')
			end if
		
			//Valido si el nro de parte existe
			select count(*)
			  into :ll_count
			  from tg_pd_destajo
			where nro_parte = :ls_nro_parte;
			
		loop
		
		//Actualizo el numerador
		update NUM_TG_PD_DESTAJO
			set ult_nro = :ll_ult_nro + 1
		where origen = :gs_origen;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TG_PD_DESTAJO. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		dw_master.object.nro_parte[dw_master.getrow()] = ls_nro_parte
		dw_master.ii_update = 1
	else
		ls_nro_parte = dw_master.object.nro_parte[dw_master.getrow()] 
	end if
	
	// Asigna numero a detalle
	for ll_j = 1 to dw_detail.RowCount()
		dw_detail.object.nro_parte[ll_j] = ls_nro_parte
	next
	
	return 1

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error en of_Set_numer()")
	return 0
finally
	/*statementBlock*/
end try

end function

public subroutine of_retrieve (string as_nro_parte);//this.event ue_udpate_request()

dw_master.retrieve(as_nro_parte)
dw_detail.retrieve(as_nro_parte)
is_action = 'open'

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

if dw_master.getRow() > 0 then dw_master.il_row = dw_master.getRow()

end subroutine

public subroutine of_verifica_cuadrilla (string as_cuadrilla, long al_row);//Esta funcion verifica si la cuadrilla tiene solo una labor
integer	li_count
string 	ls_cod_tarea, ls_desc_tarea, &
			ls_cod_especie, ls_desc_especie, &
			ls_cod_presentacion, ls_desc_presentacion, ls_und, ls_cod_labor
decimal	ldc_tarifa			
			
select count(*)
  into :li_count
  from tg_cuadrillas_labor
 where cod_cuadrilla = :as_cuadrilla;


//	Si la cuadrilla no tiene tareas o tiene varias entonces no se puede 
// hacer nada
if li_count = 0 or li_count > 1 then return


//de lo contario obtengo los datos necesarios
select tcl.especie, te.descr_especie,
       tcl.cod_presentacion, tp.desc_presentacion,
       tcl.cod_tarea, ta.desc_tarea,
       tf.tarifa, tf.und, tf.cod_labor
	into 	:ls_cod_especie, :ls_desc_especie,
			:ls_cod_presentacion, :ls_desc_presentacion,
			:ls_cod_tarea, :ls_desc_tarea,
			:ldc_tarifa, :ls_und, :ls_cod_labor
from tg_cuadrillas_labor tcl,
     tg_tarifario        tf,
     tg_especies         te,
     tg_presentacion     tp,
     tg_tareas           ta
where tcl.especie        = te.especie
  and tcl.cod_presentacion = tp.cod_presentacion
  and tcl.cod_tarea        = ta.cod_tarea
  and tcl.especie          = tf.cod_especie
  and tcl.cod_presentacion = tf.cod_presentacion
  and tcl.cod_tarea        = tf.cod_tarea  
  and tcl.cod_cuadrilla		= :as_cuadrilla;
  

dw_master.object.cod_especie 			[al_row] = ls_cod_especie
dw_master.object.desc_especie 		[al_row] = ls_desc_especie
dw_master.object.cod_presentacion 	[al_row] = ls_cod_presentacion
dw_master.object.desc_presentacion 	[al_row] = ls_desc_presentacion
dw_master.object.cod_tarea 			[al_row] = ls_cod_tarea
dw_master.object.desc_tarea 			[al_row] = ls_desc_tarea
dw_master.object.precio_unit			[al_row] = ldc_tarifa
dw_master.object.und 					[al_row] = ls_und
dw_master.object.cod_labor				[al_row] = ls_cod_labor

  
end subroutine

public function boolean of_validar_trabajador (string as_trabajador, long al_row);integer li_row

for li_row = 1 to dw_detail.RowCount()
	if li_row <> al_row then
		if as_trabajador = dw_detail.object.cod_trabajador[li_row] then
			MessageBox('Error', 'Código de Trabajador ya existe en el parte de produccion')
			return false
		end if
	end if
next

return true
end function

public function boolean of_validar ();String 	ls_cuadrilla, ls_especie, ls_presentacion, ls_tarea, ls_turno, &
			ls_cliente, ls_oper_sec, ls_ot_adm, ls_mensaje, ls_nro_parte, &
			ls_flag_estado
Date 		ld_fec_parte
Long		ll_count

if dw_master.RowCount() = 0 then
	return true
end if

ls_especie 			= dw_master.object.cod_especie 		[1]
ls_cuadrilla 		= dw_master.object.cod_cuadrilla 	[1]
ls_presentacion 	= dw_master.object.cod_presentacion [1]
ls_tarea 			= dw_master.object.cod_tarea 			[1]
ls_turno 			= dw_master.object.turno 				[1]
ls_cliente 			= dw_master.object.cod_cliente 		[1]
ls_oper_sec			= dw_master.object.oper_sec 			[1]
ls_ot_adm			= dw_master.object.ot_adm	 			[1]
ld_fec_parte		= Date(dw_master.object.fec_parte	[1])


 select count(*)
	into :ll_count
	from tg_pd_destajo a
  where a.flag_estado       	<> '0'
	 and a.cod_cuadrilla     	= :ls_cuadrilla
	 and a.cod_especie       	= :ls_especie
	 and a.cod_presentacion  	= :ls_presentacion
	 and a.cod_tarea         	= :ls_tarea
	 and a.fec_parte         	= :ld_fec_parte
	 and a.turno             	= :ls_turno
	 and a.cod_cliente       	= :ls_cliente
	 and NVL(a.oper_sec, 'XX') = NVL(:ls_oper_sec, 'XX')
	 and NVL(a.ot_adm, 'XX')   = NVL(:ls_ot_adm,'XX');

if sqlca.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al consultar tabla TG_PD_DESTAJO para busqueda de duplicidad, por favor verifique' &
							 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
	return false
end if

if ll_count > 0 then
	ROLLBACK;
	
	select a.nro_parte, a.flag_estado
		into :ls_nro_parte, :ls_flag_estado
		from tg_pd_destajo a
	  where a.flag_estado       	<> '0'
		 and a.cod_cuadrilla     	= :ls_cuadrilla
		 and a.cod_especie       	= :ls_especie
		 and a.cod_presentacion  	= :ls_presentacion
		 and a.cod_tarea         	= :ls_tarea
		 and a.fec_parte         	= :ld_fec_parte
		 and a.turno             	= :ls_turno
		 and a.cod_cliente       	= :ls_cliente
		 and NVL(a.oper_sec, 'XX') = NVL(:ls_oper_sec, 'XX')
		 and NVL(a.ot_adm, 'XX')   = NVL(:ls_ot_adm,'XX');
	 
	if IsNull(ls_oper_sec) then ls_oper_Sec = 'VACIO'
	if IsNull(ls_ot_adm) then ls_ot_adm = 'VACIO'
	
	if ls_flag_estado = '1' then
		MessageBox('Error', 'Ya existe un PARTE DE DESTAJO ' + ls_nro_parte + ', con las mismas condiciones, no esta permitido tener otro parte de destajo, por favor verifique!' &
								 + '~r~Fec Parte: ' + String(ld_fec_parte, 'dd/mm/yyyy') &
								 + '~r~nCuadrilla: ' + ls_cuadrilla &
								 + '~r~nEspecie: ' 	+ ls_especie &
								 + '~r~nPresentacion: ' + ls_presentacion &
								 + '~r~nTarea: ' + ls_tarea &
								 + '~r~nTurno: ' + ls_turno &
								 + '~r~nCliente: ' + ls_cliente &
								 + '~r~nOT ADM: ' + ls_ot_adm &
								 + '~r~nOPER_SEC: ' + ls_oper_sec, StopSign!)
		return false
	end if
	
	if ls_flag_estado = '2' then
		MessageBox('Error', 'El PARTE DE DESTAJO ' + ls_nro_parte + ' que tiene las mismas condiciones ya ha sido PROCESADO, por favor verifique!' &
								 + '~r~Fec Parte: ' + String(ld_fec_parte, 'dd/mm/yyyy') &
								 + '~r~nCuadrilla: ' + ls_cuadrilla &
								 + '~r~nEspecie: ' 	+ ls_especie &
								 + '~r~nPresentacion: ' + ls_presentacion &
								 + '~r~nTarea: ' + ls_tarea &
								 + '~r~nTurno: ' + ls_turno &
								 + '~r~nCliente: ' + ls_cliente &
								 + '~r~nOT ADM: ' + ls_ot_adm &
								 + '~r~nOPER_SEC: ' + ls_oper_sec, StopSign!)
		return false
	end if

end if

return true
end function

on w_pr328_parte_detajo_masivo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_campo=create st_campo
this.dw_3=create dw_3
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.st_nro=create st_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_nro
end on

on w_pr328_parte_detajo_masivo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_3)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.st_nro)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
String 	ls_flag_destajo, ls_nro_orden, ls_oper_sec
decimal 	ldc_total_prod
long		ll_row

try 
	ib_update_check = False
	if gnvo_app.of_row_Processing( dw_master ) <> true then return
	
	// Verifica que campos son requeridos y tengan valores
	if gnvo_app.of_row_Processing( dw_detail ) <> true then return
	
	//Validar que si el parte es de destajo entonces debe tener una cantidad producida total
	if dw_master.getRow() = 0 then return
	
	//Valido si los datos del parte de destajo ya existen
	if is_action = 'new' or dw_master.is_row_new (1) then
		if not this.of_validar() then return
	end if
	
	ls_flag_destajo 	= dw_master.object.flag_destajo 	[1]
	ls_nro_orden		= dw_master.object.nro_orden	 	[1]
	ls_oper_sec			= dw_master.object.oper_sec	 	[1]
	
	if ls_flag_destajo = '1' then
		ldc_total_prod = 0
		for ll_row =1 to dw_detail.RowCount()
			ldc_total_prod += dec(dw_detail.object.cant_producida[ll_row])
		next
		
		if ldc_total_prod = 0 then
			MessageBox('Error', 'No se puede guardar un parte de destajo si previamente no ha ingresado una cantidad de produccion a los trabajadores')
			return
		end if
	
	end if
	
	if gnvo_app.of_get_parametro("PROD_PARTE_DESTAJO_VALIDA_OT", "0") = "1" then
		if IsNull(ls_nro_orden) or trim(ls_nro_orden) = '' then
			MessageBox('Error', 'Debe Colocar el NRO DE ORDEN DE TRABAJO antes de guardar este parte, por favor corrija!')	
			dw_master.setFocus()
			dw_master.setColumn('nro_orden')
			return
		end if
		if IsNull(ls_oper_sec) or trim(ls_oper_sec) = '' then
			MessageBox('Error', 'Debe Colocar el NRO DE OPERACION antes de guardar este parte, por favor corrija!')	
			dw_master.setFocus()
			dw_master.setColumn('oper_sec')
			return
		end if
	end if
	
	
	
	if of_set_numera	() = 0 then return
	
	ib_update_check = true

catch ( Exception ex)
	gnvo_app.of_Catch_exception(ex, 'error al validar grabacion')
	
finally
	
end try

end event

event ue_insert;Long  ll_row
string ls_flag_estado

if idw_1 = dw_detail then
	
	if dw_master.getRow() = 0 then
		gnvo_app.of_mensaje_error('Debe ingresar una cabecera del documento')
		return
	end if
	ls_flag_estado = dw_master.object.flag_estado[dw_master.getRow()]
	
	if ls_flag_estado <> '1' then
		gnvo_app.of_mensaje_error('Error, el parte de producción no esta activo, por favor verifique')
		return
	end if
	
elseif idw_1 = dw_master then
	
	//Verificar si hay cambios pendientes
	if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
		if MessageBox('Aviso', 'Hay cambios pendientes por grabar, si continua ' &
									+ 'perderá todos los cambios. Desea continuar?', &
									Information!, YesNo!, 2) = 2 then return
	end if
	
	dw_master.Reset()
	dw_detail.Reset()
	
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
end if

ll_row = idw_1.Event ue_insert()


IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if


end event

event ue_open_pre;call super::ue_open_pre;String ls_columna
ib_log = TRUE
idw_1 = dw_master
dw_master.setFocus()

is_col = 'nom_trabajador'
is_tipo = LEFT( dw_detail.Describe(is_col + ".ColType"),1)	
ls_columna = dw_detail.describe(is_col + "_t.text")
is_old_color = dw_Detail.Describe(is_col + "_t.Background.Color")
dw_Detail.Modify(is_col + "_t.Background.Color = 255")

//Quito las doble comillas
ls_columna = f_replace(ls_columna, '"', "")
ls_columna = f_replace(ls_columna, "~r~n", " ")

st_campo.text = "Buscar por: " + ls_columna

//Saco el codigo de la empresa
select g.cod_empresa, p.nom_proveedor
   into :is_empresa, :is_desc_empresa
from genparam g,
	  proveedor p
where g.cod_empresa = p.proveedor
  and g.reckey = '1';


end event

event ue_update;//Overriding

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	messagebox("Aviso", "No se ha grabado, revisar", Information!)
	RETURN
end if

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
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
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	is_action = 'open'
	
END IF

end event

event ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

this.event ue_update_request()

sl_param.dw1    = 'd_list_prod_parte_destajo_tbl'
sl_param.titulo = 'Lista de partes de DESTAJO'
sl_param.tipo	 = '1S'
sl_param.string1 = gs_user
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_print;call super::ue_print;IF dw_master.rowcount() = 0 then return

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.nro_parte[1]

OpenSheetWithParm(w_pr326_parte_produccion_rpt, lstr_rep, w_main, 2, Layered!)
end event

event ue_anular;call super::ue_anular;if dw_master.GetRow() = 0 then return

dw_master.object.flag_estado [dw_master.getRow()] = '0'
dw_master.ii_update = 1
end event

event ue_modify;//Overrride

if dw_master.RowCount() = 0 then return

if dw_master.object.flag_estado[dw_master.getRow()] <> '1' then 
	MessageBox('Error', 'El parte de producción no está activo, por favor verifique')
	return
end if
dw_master.of_protect()
dw_detail.of_protect()
end event

type dw_master from w_abc_mastdet`dw_master within w_pr328_parte_detajo_masivo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 120
integer width = 3854
integer height = 932
string dataobject = "d_abc_parte_produccion2_ff"
boolean vscrollbar = false
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cuadrilla, ls_especie, &
			ls_presentacion, ls_und, ls_turno, ls_desc_turno, &
			ls_flag_destajo, ls_cod_labor, ls_ot_adm, ls_desc_ot_adm, &
			ls_nro_orden, ls_titulo, ls_oper_sec, ls_desc_operacion
decimal 	ldc_tarifa			
		
			
choose case lower(as_columna)
		
	case "cod_cliente"

		ls_sql = "select proveedor as codigo_cliente, " &
				 + "  	  nom_proveedor as nombre_cliente, " &
				 + "       ruc as ruc_cliente " &
				 + "  from proveedor " &
				 + " where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_cliente	[al_row] = ls_codigo
			this.object.nom_cliente	[al_row] = ls_data
			this.ii_update = 1
			
	end if

	case "cod_cuadrilla"

		ls_sql = "select tc.cod_cuadrilla as codigo_cuadrilla, " &
				 + "		  tc.desc_cuadrilla as descripcion_cuadrilla, " &
				 + "		  tu.turno as codigo_turno, " &
				 + "		  tu.descripcion as descripcion_turno " &
				 + "from tg_cuadrillas tc, " &
				 + "     turno 		  tu, " &
				 + "     ot_adm_usuario otu " &
				 + "where tc.turno = tu.turno " &
				 + "  and tc.ot_adm = otu.ot_adm " &
				 + "  and otu.cod_usr = '" + gs_user + "'" &
				 + "  and tc.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_turno, ls_desc_turno, '1') then
			this.object.cod_cuadrilla	[al_row] = ls_codigo
			this.object.desc_cuadrilla	[al_row] = ls_data
			this.object.turno				[al_row] = ls_turno
			this.object.desc_turno		[al_row] = ls_desc_turno
			
			this.object.cod_especie			[al_row] = gnvo_app.is_null
			this.object.desc_especie		[al_row] = gnvo_app.is_null
			this.object.cod_presentacion	[al_row] = gnvo_app.is_null
			this.object.desc_presentacion	[al_row] = gnvo_app.is_null
			this.object.cod_tarea			[al_row] = gnvo_app.is_null
			this.object.desc_tarea			[al_row] = gnvo_app.is_null

			this.object.ot_adm				[al_row] = gnvo_app.is_null
			this.object.desc_ot_adm			[al_row] = gnvo_app.is_null
			this.object.nro_orden			[al_row] = gnvo_app.is_null
			this.object.titulo_ot			[al_row] = gnvo_app.is_null
			this.object.oper_sec				[al_row] = gnvo_app.is_null
			this.object.desc_operacion		[al_row] = gnvo_app.is_null

			this.ii_update = 1
			
			// Valido si la cuadrilla tiene una sola tarea de ser asi 
			// coloco el resto de datos
			of_verifica_cuadrilla(ls_codigo, al_row)
		end if
		
	case "turno"

		ls_sql = "select turno as codigo_turno, " &
				 + "		  descripcion as descripcion_turno " &
				 + "from turno " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.turno			[al_row] = ls_codigo
			this.object.desc_turno	[al_row] = ls_data
			
			this.object.cod_especie			[al_row] = gnvo_app.is_null
			this.object.desc_especie		[al_row] = gnvo_app.is_null
			this.object.cod_presentacion	[al_row] = gnvo_app.is_null
			this.object.desc_presentacion	[al_row] = gnvo_app.is_null
			this.object.cod_tarea			[al_row] = gnvo_app.is_null
			this.object.desc_tarea			[al_row] = gnvo_app.is_null

			this.object.ot_adm				[al_row] = gnvo_app.is_null
			this.object.desc_ot_adm			[al_row] = gnvo_app.is_null
			this.object.nro_orden			[al_row] = gnvo_app.is_null
			this.object.titulo_ot			[al_row] = gnvo_app.is_null
			this.object.oper_sec				[al_row] = gnvo_app.is_null
			this.object.desc_operacion		[al_row] = gnvo_app.is_null
			
			this.ii_update = 1
			
		end if

	case "cod_especie"
		ls_cuadrilla = this.object.cod_cuadrilla[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla')
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_sql = "select distinct e.especie as codigo_especie, " &
				 + "		  e.descr_especie as descripcion_especie " &
				 + "from tg_especies e, " &
				 + "      tg_cuadrillas_labor tcl " &
				 + "where tcl.especie = e.especie " &
				 + "  and e.flag_estado = '1' " &
				 + "  and tcl.cod_cuadrilla = '" + ls_cuadrilla + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_especie		[al_row] = ls_codigo
			this.object.desc_especie	[al_row] = ls_data
			
			this.object.cod_presentacion	[al_row] = gnvo_app.is_null
			this.object.desc_presentacion	[al_row] = gnvo_app.is_null
			this.object.cod_tarea			[al_row] = gnvo_app.is_null
			this.object.desc_tarea			[al_row] = gnvo_app.is_null

			this.object.ot_adm				[al_row] = gnvo_app.is_null
			this.object.desc_ot_adm			[al_row] = gnvo_app.is_null
			this.object.nro_orden			[al_row] = gnvo_app.is_null
			this.object.titulo_ot			[al_row] = gnvo_app.is_null
			this.object.oper_sec				[al_row] = gnvo_app.is_null
			this.object.desc_operacion		[al_row] = gnvo_app.is_null
			
			this.ii_update = 1
		end if
		
	case "cod_presentacion"
		ls_cuadrilla = this.object.cod_cuadrilla[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla')
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_especie = this.object.cod_especie[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar un código de especie')
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

			this.object.ot_adm				[al_row] = gnvo_app.is_null
			this.object.desc_ot_adm			[al_row] = gnvo_app.is_null
			this.object.nro_orden			[al_row] = gnvo_app.is_null
			this.object.titulo_ot			[al_row] = gnvo_app.is_null
			this.object.oper_sec				[al_row] = gnvo_app.is_null
			this.object.desc_operacion		[al_row] = gnvo_app.is_null

			this.ii_update = 1
		end if

	case "cod_tarea"
		ls_cuadrilla = this.object.cod_cuadrilla[al_row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe Ingresar una cuadrilla')
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ls_especie = this.object.cod_especie[al_row]
		
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
			
			this.object.ot_adm			[al_row] = gnvo_app.is_null
			this.object.desc_ot_adm		[al_row] = gnvo_app.is_null
			this.object.nro_orden		[al_row] = gnvo_app.is_null
			this.object.titulo_ot		[al_row] = gnvo_app.is_null
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null
			
			this.ii_update = 1
			
			// Con la selección de la tarea entonces obtengo del tarifario
			// el precio y la unidad
			
			select tf.und, tf.tarifa, tf.flag_destajo, tf.cod_labor
			  into :ls_und, :ldc_tarifa, :ls_flag_destajo, :ls_cod_labor
			  from tg_tarifario tf
			 where tf.cod_especie 		= :ls_especie
			   and tf.cod_presentacion = :ls_presentacion
				and tf.cod_tarea			= :ls_codigo;
			
			this.object.precio_unit	[al_row] = ldc_tarifa
			this.object.und			[al_row] = ls_und
			this.object.flag_destajo[al_row] = ls_flag_destajo
			this.object.cod_labor	[al_row] = ls_cod_labor
		end if
						
	case "ot_adm"
		ls_cod_labor = this.object.cod_labor	[al_row]
		
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('Error', 'Debe especificar primero una tarea o actividad que tenga un codigo de labor')
			return
		end if
		
		ls_sql = "select ota.ot_adm as ot_adm, " &
				 + "ota.descripcion as descripcion_ot_adm " &
				 + "  from ot_administracion ota, " &
				 + "       ot_adm_usuario    otu " &
				 + "where ota.ot_adm = otu.ot_adm " &
				 + "  and ota.flag_estado = '1'" &
				 + "  and otu.cod_usr = '" + gs_user + "'"
				 
		lb_ret = f_lista(ls_sql, ls_ot_adm, ls_desc_ot_adm, '2')
		
		if ls_ot_adm <> '' then
			this.object.ot_adm			[al_row] = ls_ot_adm
			this.object.desc_ot_adm		[al_row] = ls_desc_ot_adm
			
			this.object.nro_orden		[al_row] = gnvo_app.is_null
			this.object.titulo_ot		[al_row] = gnvo_app.is_null
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null

			this.ii_update = 1
		end if
						
	case "nro_orden"
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
		
		ls_sql = "select ot.nro_orden as nro_ot, " &
				 + "		  ot.titulo as titulo_ot, " &
				 + "		  op.oper_sec as oper_sec, " &
				 + "		  op.desc_operacion as descripcion_operacion " &
				 + "from operaciones op, " &
				 + "     orden_trabajo ot, " &
				 + "     ot_administracion ota " &
				 + "where op.nro_orden = ot.nro_orden " &
				 + "  and ot.ot_adm    = ota.ot_adm " &
				 + "  and op.cod_labor = '" + ls_cod_labor + "' " &
				 + "  and ot.ot_adm = '" + ls_ot_adm + "' " &
				 + "  and op.flag_estado = '1'"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_nro_orden, ls_titulo, ls_oper_sec, ls_desc_operacion, '2')
		
		if ls_ot_adm <> '' then
			this.object.nro_orden		[al_row] = ls_nro_orden
			this.object.titulo_ot		[al_row] = ls_titulo
			this.object.oper_sec			[al_row] = ls_oper_sec
			this.object.desc_operacion	[al_row] = ls_desc_operacion
			
			this.object.oper_sec			[al_row] = gnvo_app.is_null
			this.object.desc_operacion	[al_row] = gnvo_app.is_null

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
		
		ls_nro_orden = this.object.nro_orden	[al_row]
		
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
			this.ii_update = 1
	end if

end choose
end event

event dw_master::constructor;call super::constructor;
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  	=		dw_master
idw_det  	=		dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha, ldt_hora_inicio, ldt_hora_fin
Date		ld_Fec_parte

ldt_fecha = gnvo_app.of_fecha_actual()

This.Object.cod_usr				[al_row] = gs_user
This.Object.fec_registro		[al_row] = ldt_fecha
This.Object.fec_parte			[al_row] = Date(ldt_fecha)
This.Object.precio_unit			[al_row] = 0
This.Object.produccion_total	[al_row] = 0
This.Object.flag_estado			[al_row] = '1'
this.object.cod_cliente			[al_row] = is_empresa
this.object.nom_cliente			[al_row] = is_desc_empresa


ld_fec_parte = Date(this.object.fec_parte[al_row])
		
ldt_hora_inicio = DateTime(ld_fec_parte, Now())

//La hora de fin será 8 horas despues
select :ldt_hora_inicio + 8/24
  into :ldt_hora_fin
  from dual;


this.object.hora_inicio	[al_row] = ldt_hora_inicio
this.object.hora_fin		[al_row] = ldt_hora_fin
this.SetColumn("fec_parte")

is_action = 'new'
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::buttonclicked;call super::buttonclicked;String		ls_Cuadrilla
Integer 		li_i, li_row, li_rows
Decimal		ldc_produccion, ldc_acumulador, ldc_cant_produc, ldc_dif, &
				ldc_hrs_diu, ldc_hrs_noc
DateTime		ldt_fecha1, ldt_fecha2
u_ds_base 	ds_cuadrilla_det
Date			ld_fec_parte

this.acceptText()

choose case lower(dwo.name)
		
	case "b_trabajadores"
		ls_cuadrilla = this.object.cod_cuadrilla [row]
		
		if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
			MessageBox('Error', 'Debe elegir una cuadrilla primero')
			this.SetColumn('cod_cuadrilla')
			return
		end if
		
		ld_fec_parte = Date(this.object.fec_parte[row])
		
		if isNull(ld_fec_parte) then
			MessageBox('Error', 'Debe ingresar una fecha de parte')
			this.SetColumn('fec_parte')
			return
		end if
		
		ds_cuadrilla_det = create u_ds_base
		ds_cuadrilla_det.DataObject = 'd_list_cuadrillas_destajo_det_tbl'
		ds_cuadrilla_det.SetTransObject(SQLCA)
		ds_cuadrilla_det.Retrieve(ls_cuadrilla, ld_fec_parte)
		
		ds_cuadrilla_det.setSort("nro_item a")
		ds_cuadrilla_det.Sort()
		
		do while dw_detail.RowCount() > 0
			dw_detail.event ue_delete()
		loop
		
		for li_i=1 to ds_cuadrilla_det.RowCount()
			li_row = dw_detail.event ue_insert()
			dw_detail.object.cod_trabajador 		[li_row] = ds_cuadrilla_det.object.cod_trabajador 		[li_i]
			dw_detail.object.nom_trabajador 		[li_row] = ds_cuadrilla_det.object.nom_trabajador		[li_i]
			dw_detail.object.nro_doc_ident_rtps [li_row] = ds_cuadrilla_det.object.nro_doc_ident_rtps [li_i]
		next
		
		destroy ds_cuadrilla_det
		
	case "b_distribuir"
		li_rows = dw_detail.RowCount()
		
		if li_rows = 0 then return
		
		ldc_produccion = Dec(this.object.produccion_total [row])
		
		ldc_acumulador = 0
		for li_i = 1 to dw_detail.RowCount()
			ldc_cant_produc = round(ldc_produccion / li_rows, 4)
			dw_detail.object.cant_producida [li_i] = ldc_cant_produc
			ldc_acumulador += ldc_cant_produc
			dw_detail.ii_update = 1
		next
		
		ldc_dif = ldc_produccion - ldc_acumulador
		
		if dw_detail.RowCount() > 0 then
			dw_detail.object.cant_producida [1] = Dec(dw_detail.object.cant_producida [1]) + ldc_dif
		end if
	
	case "b_asignar"
		li_rows = dw_detail.RowCount()
		
		if li_rows = 0 then return
		
		ldc_produccion = Dec(this.object.hrs [row])
		
		for li_i = 1 to dw_detail.RowCount()
			dw_detail.object.cant_horas [li_i] = ldc_produccion
			dw_detail.ii_update = 1
		next
		
//	case "b_hora_inicio"
//		li_rows = dw_detail.RowCount()
//		
//		if li_rows = 0 then return
//		
//		ldt_fecha1 = DateTime(this.object.hora_inicio [row])
//		
//		for li_i = 1 to dw_detail.RowCount()
//			dw_detail.object.hora_inicio [li_i] = ldt_fecha1
//			ldt_fecha2 = DateTime(dw_detail.object.hora_fin [row])
//			
//			if not IsNull(ldt_fecha2) then
//				select usf_pr_horas(:ldt_fecha1, :ldt_fecha2, 'HD'), usf_pr_horas(:ldt_fecha1, :ldt_fecha2, 'HN')
//					into :ldc_hrs_diu, :ldc_hrs_noc
//				from dual;
//				
//				if ldc_hrs_diu < 0 then ldc_hrs_diu = 0
//				if ldc_hrs_noc < 0 then ldc_hrs_noc = 0
//				
//				dw_detail.object.cant_horas_diu [li_i] = ldc_hrs_diu
//				dw_detail.object.cant_horas_noc [li_i] = ldc_hrs_noc
//			else
//				dw_detail.object.cant_horas_diu [li_i] = 0
//				dw_detail.object.cant_horas_noc [li_i] = 0
//			end if
//			
//			dw_detail.ii_update = 1
//		next
	
	case "b_hora_fin"
		li_rows = dw_detail.RowCount()
		
		if li_rows = 0 then return
		
		ldt_fecha1 = DateTime(this.object.hora_inicio 	[row])
		ldt_fecha2 = DateTime(this.object.hora_fin 		[row])
		
		for li_i = 1 to dw_detail.RowCount()
			dw_detail.object.hora_fin 		[li_i] = ldt_fecha2
			dw_detail.object.hora_inicio 	[li_i] = ldt_fecha1
			
			if not IsNull(ldt_fecha2) and not IsNull(ldt_fecha1) then
				select usf_pr_horas(:ldt_fecha1, :ldt_fecha2, 'HD'), usf_pr_horas(:ldt_fecha1, :ldt_fecha2, 'HN')
					into :ldc_hrs_diu, :ldc_hrs_noc
				from dual;
				
				if ldc_hrs_diu < 0 then ldc_hrs_diu = 0
				if ldc_hrs_noc < 0 then ldc_hrs_noc = 0

				dw_detail.object.cant_horas_diu [li_i] = ldc_hrs_diu
				dw_detail.object.cant_horas_noc [li_i] = ldc_hrs_noc
			else
				dw_detail.object.cant_horas_diu [li_i] = 0
				dw_detail.object.cant_horas_noc [li_i] = 0
			end if
			
			dw_detail.ii_update = 1
		next
end choose

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemchanged;call super::itemchanged;Date			ld_fec_parte, ld_hoy
DateTime		ldt_hora_inicio, ldt_hora_fin
Integer		li_dias

try 
	this.AcceptText()
	
	if row <= 0 then return
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	
	choose case lower(dwo.name)
		case 'fec_parte'
			
			ld_fec_parte = Date(this.object.fec_parte[row])
			
			// Valido si la fecha debe estar en un rango aceptable, no debe
			// ser mayor a la fecha de hoy ni tampoco menor a 4 días
			
			
			if ld_fec_parte > ld_hoy then
				MessageBox('Error', 'La fecha del parte no puede ser mayor a la fecha de hoy. Fecha del Parte: ' + string(ld_hoy, 'dd/mm/yyyy'))
				this.object.fec_parte [row] = ld_hoy
				return 1
			end if
			
			//Ahora la fecha del parte no puede ser menor a 4 días de hoy
			li_dias = Integer(gnvo_app.of_get_parametro("DIAS_MAXIMO_ATRASO_PARTE_PROD", "7"))
			if DaysAfter(ld_fec_parte, ld_hoy) > li_dias then
				MessageBox('Error', 'La fecha del parte no puede ser menor a ' + string(li_dias) + ' días de la fecha de hoy. Fecha del Parte: ' + string(ld_hoy, 'dd/mm/yyyy'))
				ld_fec_parte = RelativeDate(ld_hoy, -li_dias)
				this.object.fec_parte [row] = ld_fec_parte
				return
			end if
			
			//Ahora con la fecha del parte general las horas de inicio y de fin
			ldt_hora_inicio = DateTime(ld_fec_parte, Now())
			
			//La hora de fin será 8 horas despues
			select :ldt_hora_inicio + 8/24
			  into :ldt_hora_fin
			  from dual;
			
			
			this.object.hora_inicio	[row] = ldt_hora_inicio
			this.object.hora_fin		[row] = ldt_hora_fin
		
		case 'hora_inicio'
			
			ldt_hora_inicio = DateTime(this.object.hora_inicio [row])
			
			//La hora de fin será 8 horas despues
			select :ldt_hora_inicio + 8/24
			  into :ldt_hora_fin
			  from dual;
			
			this.object.hora_fin		[row] = ldt_hora_fin
				
	end choose

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "Error en evento itemchanged en dw_master")
	
finally
	/*statementBlock*/
end try

end event

type dw_detail from w_abc_mastdet`dw_detail within w_pr328_parte_detajo_masivo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1156
integer width = 3854
integer height = 868
string dataobject = "d_abc_parte_produccion_det2_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_dni
date		ld_fec_parte

choose case lower(as_columna)
		
	case "cod_trabajador"
		
		ld_fec_parte = date(dw_master.object.fec_parte[dw_master.getRow()])
		
		if upper(gs_empresa) = 'VITAL_SAC' then
			ls_sql = "Select vw.cod_trabajador as codigo_trabajador, " &
					 + " 		  vw.nom_trabajador as nombre_trabajador, " &
					 + " 		  vw.nro_doc_ident_rtps as dni " &
					 + "from vw_pr_trabajador vw " &
					 + "where vw.flag_estado = '1' " &
					 + "  and vw.tipo_trabajador in ('DES', 'SER', 'JOR', 'EVE')" &
					 + "  and trunc(vw.fec_ingreso) <= to_date('" + string(ld_fec_parte, "dd/mm/yyyy") + "', 'dd/mm/yyyy') " &
					 + "  and (vw.fec_cese is null or trunc(vw.fec_cese) >= to_date('" + string(ld_fec_parte, "dd/mm/yyyy") + "', 'dd/mm/yyyy'))"
		else
			ls_sql = "Select vw.cod_trabajador as codigo_trabajador, " &
					 + " 		  vw.nom_trabajador as nombre_trabajador, " &
					 + " 		  vw.nro_doc_ident_rtps as dni " &
					 + "from vw_pr_trabajador vw " &
					 + "where vw.flag_estado = '1' " &
					 + "  and vw.tipo_trabajador in ('DES', 'SER')" &
					 + "  and trunc(vw.fec_ingreso) <= to_date('" + string(ld_fec_parte, "dd/mm/yyyy") + "', 'dd/mm/yyyy') " &
					 + "  and (vw.fec_cese is null or trunc(vw.fec_cese) >= to_date('" + string(ld_fec_parte, "dd/mm/yyyy") + "', 'dd/mm/yyyy'))"
		end if
			
				 
		
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_dni, '2') and of_validar_trabajador(ls_codigo, al_row) then
			this.object.cod_trabajador		[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.object.nro_doc_ident_rtps[al_row] = ls_dni
			this.ii_update = 1
		end if
					
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 1				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

//idw_mst  = 				// dw_master
idw_det  =  	dw_detail			// dw_detail
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna, ls_color
long		ll_row
Integer	li_col, li_pos

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if

if row = 0 then
	li_col = this.GetColumn()
	
	ls_columna = upper(dwo.name)
	
	IF right(ls_columna, 2) = '_T' THEN
		//A la antigua columna le regreso el color anterior
		this.Modify(is_col + "_t.Background.Color = " + is_old_color)
		
		//Ahora obtengo la nueva columna
		is_col  = UPPER( mid(ls_columna,1,len(ls_columna) - 2) )	
		is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
		ls_columna = this.Describe(is_col + "_t.text")
		is_old_color = this.Describe(is_col + "_t.Background.Color")
		this.Modify(is_col + "_t.Background.Color = 255")
		
		//Quito las doble comillas
		ls_columna = f_replace(ls_columna, '"', "")
		ls_columna = f_replace(ls_columna, "~r~n", " ")

		st_campo.text = "Buscar por: " + ls_columna
		dw_3.reset()
		dw_3.InsertRow(0)
		dw_3.SetFocus()
		
		this.setRow(row)
		this.scrolltoRow(row)
	end if
END IF
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;Date ld_fecha

if dw_master.GetRow() > 0 then
	ld_fecha = Date(dw_master.object.fec_parte [dw_master.GetRow()])
else
	ld_fecha = Date(f_fecha_actual())
end if

this.object.cant_horas_diu	[al_row] = 0
this.object.cant_horas_noc	[al_row] = 0
this.object.cant_producida	[al_row] = 0
this.object.hora_inicio		[al_row] = DateTime(ld_fecha, Now())
this.object.hora_fin			[al_row] = DateTime(ld_fecha, Now())
end event

event dw_detail::itemchanged;call super::itemchanged;date		ld_fecha
DateTime ldt_fecha1, ldt_fecha2
decimal	ldc_hrs_diu, ldc_hrs_noc
String	ls_codtra, ls_data, ls_dni, ls_cod_trabajador

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "nro_doc_ident_rtps"
		ld_fecha = Date(dw_master.object.fec_parte [dw_master.getRow()])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe ingresar una fecha')
			dw_master.setFocus()
			dw_master.setColumn('fecha')
			return
		end if
		
		select m.cod_trabajador, nom_Trabajador
			into :ls_codtra, :ls_data
		from 	vw_pr_trabajador m
		where m.nro_doc_ident_rtps 	= :data
		  and m.tipo_trabajador			in ('DES', 'SER')
		  and m.flag_estado 				= '1'
		  and (m.fec_cese is null or m.fec_cese >= :ld_fecha)
		  and m.fec_ingreso <= :ld_fecha;

		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Documento de Identidad del trabajador no existe, "&
							+ "no está activo o ha cesado antes de la "&
							+ "fecha indicada o ha ingresado después de "&
							+ "la fecha indicada o no tiene autorización "&
							+ "a ingresar ese tipo de trabajador (DES)", StopSign!)
			this.object.nro_doc_ident_rtps	[row] = gnvo_app.is_null
			this.object.cod_trabajador			[row] = gnvo_app.is_null
			this.object.nom_trabajador			[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.cod_trabajador	[row] = ls_codtra
		this.object.nom_trabajador [row] = ls_data
		return 1
		
	case "cod_trabajador"
		ld_fecha = Date(dw_master.object.fec_parte [dw_master.getRow()])
		
		if IsNull(ld_fecha) then
			gnvo_app.of_mensaje_error('Debe ingresar una fecha, por favor corrija!!!!')
			dw_master.setFocus()
			dw_master.setColumn('fecha')
			return
		end if
		
		ls_cod_trabajador = data
		
		if len(trim(ls_cod_trabajador)) < 8 then
			ls_cod_trabajador = "%" + trim(ls_Cod_trabajador)
		
			select m.nom_trabajador, m.nro_doc_ident_rtps, m.cod_trabajador
				into :ls_data, :ls_dni, :ls_cod_trabajador
			from 	vw_pr_trabajador m
			where m.cod_trabajador 	like :ls_cod_trabajador
			  and m.flag_estado 		= '1'
			  and m.tipo_trabajador in ('DES', 'SER')
			  and (m.fec_cese is null or m.fec_cese >= :ld_fecha)
			  and m.fec_ingreso <= :ld_fecha;
	
			if SQLCA.SQLCode = 100 then
				Messagebox('Error', "Codigo ingresado " + data + " no corresponde a ningun registro de trabajadores, "&
								+ "no está activo o ha cesado antes de la "&
								+ "fecha indicada o ha ingresado después de "&
								+ "la fecha indicada o no tiene autorización "&
								+ "a ingresar ese tipo de trabajador "&
								+ "o el trabajador ingresado no es Destajero (DES)", StopSign!)
				this.object.cod_trabajador			[row] = gnvo_app.is_null
				this.object.nom_trabajador			[row] = gnvo_app.is_null
				this.object.nro_doc_ident_rtps	[row] = gnvo_app.is_null
				return 1
			end if
			
		else
			
			select m.nom_trabajador, m.nro_doc_ident_rtps
				into :ls_data, :ls_dni
			from 	vw_pr_trabajador m
			where m.cod_trabajador 	= :ls_cod_trabajador
			  and m.flag_estado 		= '1'
			  and m.tipo_trabajador in ('DES', 'SER')
			  and (m.fec_cese is null or m.fec_cese >= :ld_fecha)
			  and m.fec_ingreso <= :ld_fecha;
	
			if SQLCA.SQLCode = 100 then
				Messagebox('Error', "Código de trabajador " + data + " no existe, "&
								+ "no está activo o ha cesado antes de la "&
								+ "fecha indicada o ha ingresado después de "&
								+ "la fecha indicada o no tiene autorización "&
								+ "a ingresar ese tipo de trabaajdor", StopSign!)
				this.object.cod_trabajador			[row] = gnvo_app.is_null
				this.object.nom_trabajador			[row] = gnvo_app.is_null
				this.object.nro_doc_ident_rtps	[row] = gnvo_app.is_null
				return 1
			end if		
			
		end if
		

		
		this.object.nom_trabajador 		[row] = ls_data
		this.object.cod_trabajador			[row] = ls_cod_trabajador
		this.object.nro_doc_ident_rtps	[row] = ls_dni
		return 1
		
	case 'hora_fin', 'hora_inicio'
		
		ldt_fecha2 = DateTime(this.object.hora_fin [row])
		ldt_fecha1 = DateTime(this.object.hora_inicio [row])

		if not IsNull(ldt_fecha2) and not IsNull(ldt_fecha1) then
			select usf_pr_horas(:ldt_fecha1, :ldt_fecha2, 'HD'), usf_pr_horas(:ldt_fecha1, :ldt_fecha2, 'HN')
				into :ldc_hrs_diu, :ldc_hrs_noc
			from dual;
			
			if ldc_hrs_diu < 0 then ldc_hrs_diu = 0
			if ldc_hrs_noc < 0 then ldc_hrs_noc = 0

			this.object.cant_horas_diu [row] = ldc_hrs_diu
			this.object.cant_horas_noc [row] = ldc_hrs_noc
		else
			this.object.cant_horas_diu [row] = 0
			this.object.cant_horas_noc [row] = 0
		end if
			
end choose
end event

type st_campo from statictext within w_pr328_parte_detajo_masivo
integer x = 9
integer y = 1068
integer width = 1074
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Nombres"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_pr328_parte_detajo_masivo
event ue_tecla pbm_dwnkey
event dw_enter pbm_dwnprocessenter
integer x = 1115
integer y = 1064
integer width = 2139
integer height = 80
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_detail.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_detail.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
end event

event dw_enter;dw_detail.triggerevent(doubleclicked!)
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_detail.find(ls_comando, 1, dw_detail.rowcount())
		IF ll_fila <> 0 THEN		// la busqueda resulto exitosa
			dw_detail.selectrow(0, FALSE)
			dw_detail.selectrow(ll_fila, TRUE)
			dw_detail.scrolltorow(ll_fila)
			dw_3.Setfocus()
		END IF
	else
		if dw_detail.RowCount() > 0 then
			dw_detail.selectrow(0, FALSE)
			dw_detail.selectrow(1, TRUE)
			dw_detail.scrolltorow(1)
			dw_3.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type sle_nro from u_sle_codigo within w_pr328_parte_detajo_masivo
integer x = 283
integer y = 4
integer width = 471
integer height = 92
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;dw_detail.reset()
cb_1.event clicked()
end event

type cb_1 from commandbutton within w_pr328_parte_detajo_masivo
integer x = 855
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type st_nro from statictext within w_pr328_parte_detajo_masivo
integer y = 16
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

