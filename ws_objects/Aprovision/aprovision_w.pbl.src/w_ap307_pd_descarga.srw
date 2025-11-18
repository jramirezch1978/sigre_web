$PBExportHeader$w_ap307_pd_descarga.srw
forward
global type w_ap307_pd_descarga from w_abc_mastdet_smpl
end type
type dw_1 from u_dw_abc within w_ap307_pd_descarga
end type
type tab_detalles from tab within w_ap307_pd_descarga
end type
type tabpage_1 from userobject within tab_detalles
end type
type tab_1 from tab within tabpage_1
end type
type tabpage_4 from userobject within tab_1
end type
type dw_2 from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_5 from userobject within tab_1
end type
type dw_lecturas from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_lecturas dw_lecturas
end type
type tab_1 from tab within tabpage_1
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type tabpage_1 from userobject within tab_detalles
tab_1 tab_1
end type
type tabpage_2 from userobject within tab_detalles
end type
type dw_obs from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_detalles
dw_obs dw_obs
end type
type tabpage_3 from userobject within tab_detalles
end type
type dw_firmas from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_detalles
dw_firmas dw_firmas
end type
type tab_detalles from tab within w_ap307_pd_descarga
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type st_ori from statictext within w_ap307_pd_descarga
end type
type sle_gs_origen from singlelineedit within w_ap307_pd_descarga
end type
type st_1 from statictext within w_ap307_pd_descarga
end type
type cb_buscar from commandbutton within w_ap307_pd_descarga
end type
type sle_nro from u_sle_codigo within w_ap307_pd_descarga
end type
type cb_3 from commandbutton within w_ap307_pd_descarga
end type
type gb_1 from groupbox within w_ap307_pd_descarga
end type
end forward

global type w_ap307_pd_descarga from w_abc_mastdet_smpl
integer width = 3790
integer height = 2672
string title = "[AP307] Recepción, descarga y pesaje de Materia Prima"
string menuname = "m_mantto_cons_anula"
string is_action = "open"
event ue_cancelar ( )
event ue_print_cus_grandes ( )
dw_1 dw_1
tab_detalles tab_detalles
st_ori st_ori
sle_gs_origen sle_gs_origen
st_1 st_1
cb_buscar cb_buscar
sle_nro sle_nro
cb_3 cb_3
gb_1 gb_1
end type
global w_ap307_pd_descarga w_ap307_pd_descarga

type variables
integer 		ii_insert, ii_item
string 		is_inicio, is_final, is_tipo
StaticText	ist_1
Long			il_st_color

//nuevas
u_dw_abc  	idw_2, idw_lecturas, idw_obs, idw_firmas
n_cst_Wait	invo_wait
nvo_numeradores_varios	invo_nro




end variables

forward prototypes
public subroutine of_retrieve (string as_nro_parte)
public function integer of_set_numera ()
public function integer of_set_status_menu (datawindow adw)
public subroutine of_set_modify ()
public subroutine of_get_tarifa (string as_proveedor, string as_nro_placa)
public subroutine of_set_alm_tacito (string as_especie)
public function boolean of_gen_grmp (string as_nro_parte)
public function boolean of_valida_detalle ()
public subroutine of_asigna_dws ()
end prototypes

event ue_cancelar;EVENT ue_update_request()   // Verifica actualizaciones pendientes

dw_1.Reset()
idw_2.Reset()
idw_lecturas.Reset()
idw_obs.Reset()
idw_firmas.Reset()

dw_1.ii_update 			= 0
idw_2.ii_update 			= 0
idw_lecturas.ii_update 	= 0
idw_obs.ii_update 		= 0
idw_firmas.ii_update 	= 0

is_Action = 'open'

idw_1 = dw_1
idw_1.SetFocus()

of_set_status_menu(idw_1)

end event

event ue_print_cus_grandes();// vista previa de mov. almacen
str_parametros lstr_rep

try 
	
	if dw_1.rowcount() = 0 then return
	
	if dw_1.ii_update = 1 or idw_2.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	if upper(gs_empresa) = 'SEAFROST' then
		lstr_rep.dw1 		= 'd_rpt_codigoqr_rec_mp_seafrost_lbl'
	else
		lstr_rep.dw1 		= 'd_rpt_codigoqr_recepcion_mp_lbl'
	end if
	
	lstr_rep.titulo 	= 'Previo de Códigos QR de MATERIA PRIMA'
	lstr_rep.string1 	= dw_1.object.nro_parte	[1]
	lstr_rep.tipo		= '10'
	lstr_rep.dw_m		= dw_1

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try


end event

public subroutine of_retrieve (string as_nro_parte);dw_1.retrieve   ( as_nro_parte )
idw_2.retrieve  ( as_nro_parte )
idw_obs.retrieve( as_nro_parte )
idw_firmas.retrieve( as_nro_parte )
idw_lecturas.retrieve( as_nro_parte )

dw_1.ii_protect 			= 0
idw_2.ii_protect 			= 0
idw_lecturas.ii_protect = 0
idw_obs.ii_protect 		= 0
idw_firmas.ii_protect	= 0

dw_1.of_protect( )
idw_2.of_protect( )
idw_lecturas.of_protect( )
idw_obs.of_protect( )
idw_firmas.of_protect( )

dw_1.ii_update 			= 0
idw_2.ii_update 			= 0
idw_lecturas.ii_update 	= 0
idw_obs.ii_update			= 0
idw_firmas.ii_update		= 0	

is_Action = 'open'

of_set_status_menu(dw_1)

end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i, ll_item
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_1.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_ap_pd_descarga
	where cod_origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_ap_pd_descarga IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_ap_pd_descarga(cod_origen, ult_nro)
		values( :gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_ap_pd_descarga
	where cod_origen = :gs_origen for update;
	
	update num_ap_pd_descarga
		set ult_nro = ult_nro + 1
	where cod_origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_1.object.nro_parte[dw_1.getrow()] = ls_next_nro
	dw_1.ii_update = 1
else
	ls_next_nro = dw_1.object.nro_parte[dw_1.getrow()] 
end if

// Asigna numero a detalle idw_2
for ll_i = 1 to idw_2.RowCount()
	idw_2.object.nro_parte[ll_i] = ls_next_nro
next

// Asigna numero a detalle idw_lecturas
idw_lecturas.setfilter("")  //elima el filtro
idw_lecturas.Filter( )

for ll_i = 1 to idw_lecturas.RowCount()
	idw_lecturas.object.nro_parte[ll_i] = ls_next_nro
next

// Asigna numero a detalle (obs)
for ll_i = 1 to idw_obs.RowCount()
	idw_obs.object.nro_parte[ll_i] = ls_next_nro
next


// Asigna numero a detalle (firmas)
for ll_i = 1 to idw_firmas.RowCount()
	idw_firmas.object.nro_parte[ll_i] = ls_next_nro
next

return 1
end function

public function integer of_set_status_menu (datawindow adw);Int li_estado
long ll_ref

this.ChangeMenu( m_mantto_cons_anula )

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if


if dw_1.getrow() = 0 then return 0

if is_Action = 'new' then

// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	if is_flag_insertar = '1' then
		m_master.m_file.m_basedatos.m_insertar.enabled = true
	else
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if

	if adw = idw_2 then
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if

		m_master.m_file.m_basedatos.m_insertar.enabled 	= true
	elseif adw = idw_lecturas then
		m_master.m_file.m_basedatos.m_insertar.enabled 	= true
		m_master.m_file.m_basedatos.m_eliminar.enabled 	= true
	elseif adw = idw_obs then
		m_master.m_file.m_basedatos.m_insertar.enabled 	= true
		m_master.m_file.m_basedatos.m_eliminar.enabled 	= true
		
	elseif adw = idw_firmas then
		
		if is_flag_insertar = '1' then
			m_master.m_file.m_basedatos.m_insertar.enabled = true
		else
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if
	end if
	
elseif is_Action = 'open' THEN
	if adw = dw_1 then
		if is_flag_modificar = '1' then
			m_master.m_file.m_basedatos.m_modificar.enabled = true
		else
			m_master.m_file.m_basedatos.m_modificar.enabled = false
		end if
	end if
end if

return 1

end function

public subroutine of_set_modify ();//Proveedor
idw_2.Modify("proveedor.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("proveedor.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

//Especie
idw_2.Modify("Especie.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("Especie.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

//Unidad
idw_2.Modify("und_peso.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("und_peso.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

//cod_uso_ref
idw_2.Modify("cod_uso_ref.Protect ='1~tIf(IsNull(flag_cierre),1,0)'")
idw_2.Modify("cod_uso_ref.Background.color ='1~tIf(IsNull(flag_cierre),RGB(192,192,192), RGB(255,255,255))'")

//inicio de descarga
idw_2.Modify("inicio_descarga.Protect ='1~tIf(IsNull(flag_cierre),1,0)'")
idw_2.Modify("inicio_descarga.Background.color ='1~tIf(IsNull(flag_cierre),RGB(192,192,192), RGB(255,255,255))'")

//fin de descarga
idw_2.Modify("fin_descarga.Protect ='1~tIf(IsNull(flag_cierre),1,0)'")
idw_2.Modify("fin_descarga.Background.color ='1~tIf(IsNull(flag_cierre),RGB(192,192,192), RGB(255,255,255))'")

//Peso estimado
idw_2.Modify("peso_estimado.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("peso_estimado.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

//Peso Bruto
idw_2.Modify("peso_bruto.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("peso_bruto.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

//Peso Variacion
idw_2.Modify("peso_variacion.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("peso_variacion.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

//Flag Variacion
idw_2.Modify("flag_variacion.Protect ='1~tIf(IsNull(flag_guia),1,0)'")
idw_2.Modify("flag_variacion.Background.color ='1~tIf(IsNull(flag_guia),RGB(192,192,192), RGB(255,255,255))'")

end subroutine

public subroutine of_get_tarifa (string as_proveedor, string as_nro_placa);decimal 	ldc_tarifa
string 	ls_moneda
Date 		ld_fecha_pd

if dw_1.getRow() = 0 then return
if idw_2.getRow() = 0 then return

ld_fecha_pd = Date(idw_2.object.inicio_descarga[idw_2.GetRow()])

select cod_moneda, tarifa
	into :ls_moneda, :ldc_tarifa
from ap_transportes_mp_tarifa
where proveedor = :as_proveedor
  and trim(nro_placa) = :as_nro_placa
  and trunc(:ld_fecha_pd) between trunc(fecha_inicio) and trunc(fecha_fin);

if SQLCA.SQLCode = 100 then 
	MessageBox("Error", "No existen tarifas vigentes para este proveedor de transportes")
	return
end if

idw_2.object.cod_moneda		[idw_2.getRow()] = ls_moneda
idw_2.object.precio_flete	[idw_2.getRow()] = ldc_tarifa


end subroutine

public subroutine of_set_alm_tacito (string as_especie);string ls_almacen, ls_cod_art, ls_clase, ls_origen

if dw_1.GetRow() = 0 then return

ls_origen = dw_1.object.cod_origen[dw_1.getRow()]

select cod_art
	into :ls_cod_art
from tg_especies
where especie = :as_especie;

if SQLCA.SQLCode = 100 then return
if IsNull(ls_cod_art) or ls_cod_art = "" then return

select cod_clase
	into :ls_clase
from articulo
where cod_art = :ls_cod_art;

if SQLCA.SQLCode = 100 then return
if IsNull(ls_clase) or ls_clase = "" then return

select almacen
	into :ls_almacen
from almacen_tacito
where cod_origen = :ls_origen
  and cod_clase = :ls_clase;
  
if SQLCA.SQLCode = 100 then return
if IsNull(ls_almacen) or ls_almacen = "" then return

idw_2.object.almacen_dst[idw_2.getRow()] = ls_almacen




end subroutine

public function boolean of_gen_grmp (string as_nro_parte);String ls_mensaje

//create or replace procedure USP_AP_GEN_GRMP(
//       asi_nro_parte IN ap_pd_descarga.nro_parte%TYPE
//) IS

DECLARE USP_AP_GEN_GRMP PROCEDURE FOR
	USP_AP_GEN_GRMP( :as_nro_parte);

EXECUTE USP_AP_GEN_GRMP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_AP_GEN_GRMP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE USP_AP_GEN_GRMP;

return true
end function

public function boolean of_valida_detalle ();long 		ll_row, ll_count
String	ls_codigo_recepcion, ls_nro_contenedor, ls_nro_lote, ls_cod_art, ls_desc_art, ls_anaquel, &
			ls_columna, ls_fila, ls_mensaje
date		ld_fec_produccion			
 
if is_Action = 'anular' then return true

if idw_2.RowCount() = 0 then return false

//Valido si tienen el nro de lote y el nro de Contenedor (Nro Pallet)

for ll_row = 1 to idw_2.RowCount()
	
	if idw_2.is_row_new( ll_row ) or idw_2.is_row_modified( ll_row ) then
		
		if idw_2.of_existeCampo('fec_produccion') then
			ld_fec_produccion	= Date(idw_2.object.fec_produccion 	[ll_row])
		end if
		
		if idw_2.of_existeCampo('nro_lote') then
			ls_nro_lote 		= idw_2.object.nro_lote 			[ll_row]
		end if
		
		if idw_2.of_existeCampo('nro_contenedor') then
			ls_nro_contenedor = idw_2.object.nro_contenedor 	[ll_row]
		end if
		
		if idw_2.of_existeCampo('anaquel') then
			ls_anaquel			= idw_2.object.anaquel				[ll_row]
		end if
		
		if idw_2.of_existeCampo('columna') then
			ls_columna			= idw_2.object.columna				[ll_row]
		end if

		if idw_2.of_existeCampo('fila') then
			ls_fila				= idw_2.object.fila					[ll_row]
		end if

		ls_cod_art			= idw_2.object.cod_art 					[ll_row]
		ls_desc_art			= idw_2.object.desc_art					[ll_row]
		
		if not IsNull(ls_nro_lote) and trim(ls_nro_lote)<> '' then
			if IsNull(ls_nro_contenedor) or trim(ls_nro_contenedor) = '' then
				if MessageBox('Aviso', 'La Linea ' + string(ll_row) + ' con el Articulo ' &
											+ ls_cod_art + ' - ' + ls_desc_art &
											+ ' tiene NRO DE LOTE pero no se ha indicado NRO DE CONTENEDOR.' &
											+ 'Desea continuar con la grabación?', Information!, Yesno!, 2) = 2 then 
					ROLLBACK;
					idw_2.setRow( ll_row )
					idw_2.ScrollToRow(ll_row)
					idw_2.SelectRow(0, false)
					idw_2.SelectRow(ll_row, true)
					return false
				end if
			end if
		end if
		
		if not IsNull(ls_nro_contenedor) and trim(ls_nro_contenedor)<> '' then
			if IsNull(ls_nro_lote) or trim(ls_nro_lote) = '' then
				if MessageBox('Aviso', 'La Linea ' + string(ll_row) + ' con el Articulo ' &
											+ ls_cod_art + ' - ' + ls_desc_art &
											+ ' tiene NRO DE CONTENEDOR pero no se ha indicado NRO DE LOTE.' &
											+ 'Desea continuar con la grabación?', Information!, Yesno!, 2) = 2 then 
					ROLLBACK;
					idw_2.setRow( ll_row )
					idw_2.ScrollToRow(ll_row)
					idw_2.SelectRow(0, false)
					idw_2.SelectRow(ll_row, true)
					return false
				end if
			end if
		end if
		
		if not IsNull(ls_nro_contenedor) and trim(ls_nro_contenedor)<> '' and &
			not IsNull(ls_nro_lote) and trim(ls_nro_lote) <> '' then
			
			if IsNull(ls_anaquel) or trim(ls_anaquel) = '' or &
				IsNull(ls_columna) or trim(ls_columna) = '' or &
				IsNull(ls_fila) or trim(ls_fila) = '' then
				
				MessageBox('Aviso', 'La Linea ' + string(ll_row) + ' con el Articulo ' &
											+ ls_cod_art + ' - ' + ls_desc_art &
											+ ' no tiene Posicion en Almacen, por favor corrija!.', &
											Exclamation!)
				ROLLBACK;
				idw_2.setRow( ll_row )
				idw_2.ScrollToRow(ll_row)
				idw_2.SelectRow(0, false)
				idw_2.SelectRow(ll_row, true)
				return false
				
			end if
		end if
		
		//VAlido la fecha de produccion
		if not IsNull(ls_nro_lote) and trim(ls_nro_lote) <> '' then
			
			if IsNull(ld_fec_produccion) or string(ld_fec_produccion, 'dd/mm/yyyy') = '01/01/1900' then
				
				MessageBox('Aviso', 'La Linea ' + string(ll_row) + ' con el Articulo ' &
											+ ls_cod_art + ' - ' + ls_desc_art &
											+ ' tiene Nro Lote, pero no se ha indicado Fecha de Produccion, ' &
											+ 'o la Fecha Ingresada es incorrecta, por favor corrija!.', &
											Exclamation!)
				ROLLBACK;
				idw_2.setRow( ll_row )
				idw_2.ScrollToRow(ll_row)
				idw_2.SelectRow(0, false)
				idw_2.SelectRow(ll_row, true)
				return false
				
			end if
		end if
		
	end if
	
	//Valido el peso bruto
	if dec(idw_2.object.peso_bruto [ll_row]) <= 0 or &
		IsNull(idw_2.object.peso_bruto [ll_row]) then
		
		MessageBox('Error', 'No ha especificado un peso bruto en el detalle')
		idw_2.setFocus( )
		idw_2.setColumn('peso_bruto')
		idw_2.setRow( ll_row )
		idw_2.ScrollToRow(ll_row)
		idw_2.SelectRow(0, false)
		idw_2.SelectRow(ll_row, true)
		return false
	end if
next

for ll_row = 1 to idw_2.RowCount()
	
	
	//Genero un nuevo numero para el Codigo de recepcion
	if idw_2.is_row_new( ll_row ) or idw_2.is_row_modified( ll_row ) then
		
		if idw_2.of_existeCampo('nro_lote') then
			ls_nro_lote 		= idw_2.object.nro_lote 				[ll_row]
		end if
		
		if idw_2.of_existeCampo('nro_contenedor') then
			ls_nro_contenedor = idw_2.object.nro_contenedor 		[ll_row]
		end if

		if idw_2.of_existeCampo('fec_produccion') then
			ld_fec_produccion	= Date(idw_2.object.fec_produccion 	[ll_row])
		end if

		
		
		
		//Inserto el LOTE
		if not IsNull(ls_nro_lote) and trim(ls_nro_lote) <> '' then
			select count(*)
				into :ll_count
			from templas
			where cod_templa = :ls_nro_lote;
			
			if ll_count = 0 then
				insert into templas(
					cod_templa, fec_registro, flag_estado, fec_produccion, cod_usr, cod_origen)
				values(
					:ls_nro_lote, sysdate, '1', :ld_fec_produccion, :gs_user, :gs_origen);
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Aviso', 'La Linea ' + string(ll_row) + ' con el Nro LOTE ' &
												+ ls_nro_lote + ' ha generado un error al insertar en TABLA TEMPLAS.' &
												+ 'Por favor verifique! ' &
												+ '~r~nMensaje Error: ' + ls_mensaje, StopSign!)
					return false
				end if
			end if
			
		end if
		
		if not IsNull(ls_nro_lote) and trim(ls_nro_lote) <> '' and &
			not IsNull(ls_nro_contenedor) and trim(ls_nro_contenedor) <> '' then

			//Los Codigos de REcepcion
			ls_codigo_recepcion = idw_2.object.codigo_recepcion [ll_row]		
			
			if IsNull(ls_codigo_recepcion) or trim(ls_codigo_recepcion) = '' then
			
				if not invo_nro.of_num_codigo_cu( gs_origen, ls_codigo_recepcion) then 
					ROLLBACK;
					return false
				end if
					
				idw_2.object.codigo_recepcion [ll_row] = ls_codigo_recepcion
			end if

		end if
		
			
	end if

next

return true
	
end function

public subroutine of_asigna_dws ();idw_2        = tab_detalles.tabpage_1.tab_1.tabpage_4.dw_2
idw_lecturas = tab_detalles.tabpage_1.tab_1.tabpage_5.dw_lecturas
idw_obs      = tab_detalles.tabpage_2.dw_obs
idw_firmas   = tab_detalles.tabpage_3.dw_firmas
end subroutine

on w_ap307_pd_descarga.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_cons_anula" then this.MenuID = create m_mantto_cons_anula
this.dw_1=create dw_1
this.tab_detalles=create tab_detalles
this.st_ori=create st_ori
this.sle_gs_origen=create sle_gs_origen
this.st_1=create st_1
this.cb_buscar=create cb_buscar
this.sle_nro=create sle_nro
this.cb_3=create cb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.tab_detalles
this.Control[iCurrent+3]=this.st_ori
this.Control[iCurrent+4]=this.sle_gs_origen
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_buscar
this.Control[iCurrent+7]=this.sle_nro
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_ap307_pd_descarga.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.tab_detalles)
destroy(this.st_ori)
destroy(this.sle_gs_origen)
destroy(this.st_1)
destroy(this.cb_buscar)
destroy(this.sle_nro)
destroy(this.cb_3)
destroy(this.gb_1)
end on

event ue_open_pre;// Override

try 
	THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
	THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
	THIS.EVENT Post ue_open_pos()
	im_1 = CREATE m_rButton
	
	invo_wait = create n_cst_Wait
	invo_nro = create nvo_numeradores_varios
	
	
	dw_1.Settransobject(SQLCA)			// relaciona dw con bd
	dw_1.ii_protect = 0					//Bloque modificaciones
	dw_1.of_protect( )
	
	//Datawindow por defecto
	idw_1 = dw_1
	
	idw_2.Settransobject(SQLCA)
	idw_lecturas.Settransobject(SQLCA)
	idw_obs.Settransobject(SQLCA)
	idw_firmas.Settransobject(SQLCA)
	
	idw_1.object.p_logo.filename = gs_logo
	sle_gs_origen.text = gs_origen
	
	//oculta el menu anular 
	m_master.m_file.m_basedatos.m_anular.enabled 				= False
	m_master.m_file.m_basedatos.m_anular.visible					= False
	m_master.m_file.m_basedatos.m_anular.toolbarItemVisible 	= False
	
	/*
		0 = El detalle con precio, proveeedor de transporte y precio
		1 = 
		2 = Sin proveedor de transporte
		3 = sin precio de venta
	*/
	
	if upper(gs_empresa) = 'TRANSMARINA' then
		
		idw_2.dataobject = 'd_ap_pd_descarga_transmarina_det_tbl'
	
	elseif upper(gs_empresa) = 'SEAFROST' then
		
		idw_2.dataobject = 'd_ap_pd_descarga_seafrost_det_tbl'
	
	elseif gnvo_app.of_get_parametro( "APROV_EMPRESA_PESCA" + gnvo_app.empresa.is_empresa, "1") = "1" then
	
		idw_2.dataobject = 'd_ap_pd_descarga_det_pesca_tbl'
		
	elseif gnvo_app.of_get_parametro( "APROV_EMPRESA_PESCA" + gnvo_app.empresa.is_empresa, "1") = "2" then
		
		idw_2.dataobject = 'd_ap_pd_descarga_det_pesca_st_tbl'
	
	elseif gnvo_app.of_get_parametro( "APROV_EMPRESA_PESCA" + gnvo_app.empresa.is_empresa, "1") = "3" then
		
		idw_2.dataobject = 'd_ap_pd_descarga_pesca_sp_det_tbl'
	
	else
		idw_2.dataobject = 'd_ap_pd_descarga_det_tbl'
	end if
	
	idw_2.SetTransObject(SQLCA)
	
	
	// Para grabar el log diario
	ib_log = TRUE

catch ( Exception ex)
	gnvo_app.of_catch_exception( ex, "")
end try


end event

event ue_modify;//override

IF dw_1.GetRow() = 0 THEN RETURN

idw_1.of_protect()

of_set_modify()

of_set_status_menu( dw_master)
end event

event open;//Ancestor Script Override

of_asigna_dws()
is_action = 'open'

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;// Override

long ll_x

of_asigna_dws()

This.SetRedraw(false)

dw_1.width  = newwidth  - dw_1.x - 10

tab_detalles.height = newheight - tab_detalles.y - 10
tab_detalles.width  = newwidth  - tab_detalles.x - 10

//resize de los objetos dentro del tab
tab_detalles.tabpage_1.tab_1.height = tab_detalles.tabpage_1.height - tab_detalles.tabpage_1.tab_1.y - 10
tab_detalles.tabpage_1.tab_1.width = tab_detalles.tabpage_1.width - tab_detalles.tabpage_1.tab_1.x - 10

idw_2.width  = tab_detalles.tabpage_1.tab_1.tabpage_4.width  - idw_2.x - 10
idw_2.height  = tab_detalles.tabpage_1.tab_1.tabpage_4.height  - idw_2.y - 10

idw_lecturas.width  = tab_detalles.tabpage_1.tab_1.tabpage_4.width - idw_lecturas.x - 10
idw_lecturas.height = tab_detalles.tabpage_1.tab_1.tabpage_4.height - idw_lecturas.y - 10

idw_obs.width  = tab_detalles.tabpage_2.width  - idw_obs.x - 10
idw_obs.height = tab_detalles.tabpage_2.height - idw_obs.y - 10

idw_firmas.width  = tab_detalles.tabpage_3.width - idw_obs.x - 10
idw_firmas.height = tab_detalles.tabpage_3.height - idw_obs.y - 10

This.SetRedraw(true)
end event

event ue_insert;//Override

Long  ll_row

if idw_1 = idw_2 then
	if dw_1.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
		return
	end if
end if

if idw_1 = idw_obs then
	if dw_1.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar una observacion si no tiene cabecera')
		return
	end if
end if

if idw_1 = idw_firmas then
	if dw_1.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar una firma si no tiene cabecera')
		return
	end if
end if

if idw_1 = idw_lecturas then
	if dw_1.GetRow() = 0 OR idw_2.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar un atributo si no tiene cabecera o detalle')
		return
	end if
end if

if idw_1 = dw_1 then
	if idw_1.ii_update = 1 then
		MessageBox('Error', 'Tiene cambios pendientes, no puede insertar otro registro')
		return
	end if
	dw_1.reset( )
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
END IF

end event

event ue_print;call super::ue_print;
IF dw_1.rowcount() = 0 then return

str_parametros lstr_rep

lstr_rep.string1 = dw_1.object.nro_parte[dw_1.getrow()]

OpenSheetWithParm(w_ap307_pd_descarga_frm, lstr_rep, w_main, 0, Layered!)



end event

event ue_update;// Override
long 		ll_item
Boolean 	lbo_ok = TRUE
String 	ls_msg, ls_nro_parte, ls_sql, ls_mensaje

try 
	dw_1.AcceptText()                // Cabecera de Parte diario de descarga de MP
	idw_2.AcceptText()					// Detalle de Parte diario de descarga de MP
	idw_lecturas.Accepttext( )
	idw_obs.Accepttext( )
	idw_firmas.Accepttext( )
	
	ib_update_check = TRUE
	
	THIS.EVENT ue_update_pre()
	
	IF ib_update_check = FALSE THEN RETURN
	
	//Desactivo la llave foranea y luego la activo
	invo_wait.of_mensaje("Apagando LLAVE FORANEA FK_TG_PARTE_EMPA_UND_PARTE_DES de TG_PARTE_EMPAQUE_UND")
	
	//Apago el trigger;
	ls_sql = 'alter table TG_PARTE_EMPAQUE_UND disable constraint FK_TG_PARTE_EMPA_UND_PARTE_DES'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		MessageBox("Error", "Error al desactivar Llave Foranea, sentencia SQL: " + ls_sql + ", Mensaje: " + ls_mensaje)
		return
	end if
	
	// Para el log diario
	IF ib_log THEN
		dw_1.of_create_log()                // Cabecera de Parte diario de descarga de MP
		idw_2.of_create_log()					// Detalle de Parte diario de descarga de MP
		idw_lecturas.of_create_log( )
		idw_obs.of_create_log( )
		idw_firmas.of_create_log( )
	END IF
	//
	
	ls_msg = "Se ha procedido al rollback"
	
	if is_action = "anular" then
		
		IF	idw_lecturas.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_lecturas.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion de Mediciones de calidad ", ls_msg, exclamation!)
			END IF
		END IF
	
		IF	idw_2.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_2.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion detalle de Parte", ls_msg, exclamation!)
			END IF
		END IF
		
		IF	idw_obs.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_obs.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion de Observaciones ", ls_msg, exclamation!)
			END IF
		END IF
		
		IF	idw_firmas.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_firmas.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion de Firmas ", ls_msg, exclamation!)
			END IF
		END IF
	
		IF	dw_1.ii_update = 1 AND lbo_ok = TRUE THEN
			IF dw_1.Update(true, false) = -1 then		// Grabacion del Master
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion Master", ls_msg, exclamation!)
			END IF
		END IF
	
	else
		IF	dw_1.ii_update = 1 AND lbo_ok = TRUE THEN
			IF dw_1.Update(true, false) = -1 then		// Grabacion del Master
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion Master", ls_msg, exclamation!)
			END IF
		END IF
		
		IF	idw_2.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_2.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion detalle de Parte", ls_msg, exclamation!)
			END IF
		END IF
		
		IF	idw_lecturas.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_lecturas.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion de Mediciones de calidad ", ls_msg, exclamation!)
			END IF
		END IF
		
		IF	idw_obs.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_obs.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion de Observaciones ", ls_msg, exclamation!)
			END IF
		END IF
		
		IF	idw_firmas.ii_update = 1 AND lbo_ok = TRUE THEN
			IF idw_firmas.Update(true, false) = -1 then		// Grabacion del detalle
				lbo_ok = FALSE
				Rollback ;
				messagebox("Error en Grabacion de Firmas ", ls_msg, exclamation!)
			END IF
		END IF
	
	end if
	
	if not lbo_ok then return
	
	//Para el log diario
	IF ib_log THEN
		lbo_ok = dw_1.of_save_log()                // Cabecera de Parte diario de descarga de MP
		lbo_ok = idw_2.of_save_log()					// Detalle de Parte diario de descarga de MP
		lbo_ok = idw_lecturas.of_save_log( )
		lbo_ok = idw_obs.of_save_log( )
		lbo_ok = idw_firmas.of_save_log( )
	END IF
	//
	if not lbo_ok then 
		ROLLBACK;
		return
	end if
	
	ls_nro_parte = dw_1.object.nro_parte[dw_1.GetRow()]

	
	COMMIT using SQLCA;
	
	of_retrieve(ls_nro_parte)
	
	if idw_2.RowCount() > 0 then
		ll_item = idw_2.object.nro_item[idw_2.GetRow()]
		idw_lecturas.setfilter( "item = " + string(ll_item))  //Repone el filtro
		idw_lecturas.Filter( )
	end if
	
	dw_1.ii_update  		  = 0
	idw_2.ii_update 		  = 0
	idw_lecturas.ii_update = 0
	idw_obs.ii_update 	  = 0
	idw_firmas.ii_update   = 0
	
	dw_1.ii_protect 			= 0
	idw_2.ii_protect 			= 0
	idw_lecturas.ii_protect = 0
	idw_obs.ii_protect 		= 0
	idw_firmas.ii_protect 	= 0
	
	dw_1.of_protect( )
	idw_2.of_protect( )
	idw_lecturas.of_protect( )
	idw_obs.of_protect( )
	idw_firmas.of_protect( )
	
	dw_1.ResetUpdate()
	idw_2.ResetUpdate()
	idw_lecturas.ResetUpdate()
	idw_obs.ResetUpdate()
	idw_firmas.ResetUpdate()
	
	dw_1.il_totdel 	= 0
	idw_2.il_totdel 	= 0
	
	is_action = 'open'
	
	of_set_status_menu(dw_1)
	
	f_mensaje("Cambios guardados satisfactoriamente", "")

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al grabar Parte de Recepcion y Pesaje')
	
finally
	//Activo la llave foranea y luego la activo
	invo_wait.of_mensaje("Enciendo LLAVE FORANEA FK_TG_PARTE_EMPA_UND_PARTE_DES de TG_PARTE_EMPAQUE_UND")
	
	//Apago el trigger;
	ls_sql = 'alter table TG_PARTE_EMPAQUE_UND enable constraint FK_TG_PARTE_EMPA_UND_PARTE_DES'
	execute immediate :ls_sql;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		MessageBox("Error", "Error al ACTIVAR Llave Foranea, sentencia SQL " + ls_sql + ". Mensaje: " + ls_mensaje)
		return
	end if
	
	invo_wait.of_close()
	
	
end try





end event

event ue_update_pre;call super::ue_update_pre;long ll_row

// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if is_action = 'anular' then 
	ib_update_check = true
	return
end if

if gnvo_app.of_row_Processing( dw_1 ) <> true then return


// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_2 ) 		 <> true then return
if gnvo_app.of_row_Processing( idw_lecturas ) <> true then return
if gnvo_app.of_row_Processing( idw_obs ) 		 <> true then return
if gnvo_app.of_row_Processing( idw_firmas )	 <> true then return

// verifica que tenga datos de detalle
if idw_2.rowcount() = 0 then
	Messagebox( "Atencion", "Ingrese informacion de detalle", StopSign!)
	return
end if

// Valido algunos datos extras, como el peso bruto
if of_valida_detalle( ) <> true then 
	ROLLBACK;
	return
end if

//Para la replicacion de datos
dw_1.of_set_flag_replicacion()
idw_2.of_set_flag_replicacion()
idw_lecturas.of_set_flag_replicacion()
idw_obs.of_set_flag_replicacion()
idw_firmas.of_set_flag_replicacion()

// Genera el numero del Parte Diario

if of_set_numera() = 0 then return

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = true

end event

event ue_update_request;// Override
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF  dw_1.ii_update           = 1 &
	or idw_2.ii_update        = 1 &
	or idw_lecturas.ii_update = 1 &
	or idw_obs.ii_update      = 1 &
	or idw_firmas.ii_update   = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_1.ii_update         = 0
		idw_2.ii_update        = 0
		idw_lecturas.ii_update = 0
		idw_obs.ii_update      = 0
		idw_firmas.ii_update   = 0
	END IF
END IF

end event

event ue_open_pos;// Override
end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 

str_parametros lstr_param

lstr_param.dw1    = 'd_parte_diario_grd'
lstr_param.titulo = 'PARTES DIARIOS DE DESCARGA'
lstr_param.field_ret_i[1] = 1	//Cod Origen
lstr_param.field_ret_i[2] = 2	//Nro Parte
lstr_param.field_ret_i[3] = 3	//fecha_descarga
lstr_param.field_ret_i[4] = 4	//cod_moneda

OpenWithParm( w_lista, lstr_param )


lstr_param = Message.PowerObjectParm

if IsNull(lstr_param) or Not IsValid(lstr_param) then return

IF lstr_param.titulo <> 'n' THEN
	of_retrieve(lstr_param.field_ret[2])
END IF
end event

event ue_anular;call super::ue_anular;
if dw_1.RowCount() = 0 then return

if dw_1.ii_update = 1 or idw_2.ii_update = 1 or idw_lecturas.ii_update = 1 or idw_obs.ii_update = 1 or idw_firmas.ii_update = 1 then
	MessageBox("Aviso", "Hay modificaciones pendientes de grabar, por favor grabe primero antes de anular")
	return
end if	


if dw_1.object.flag_estado[dw_1.getRow()] <> '1' then
	MessageBox('Aviso', 'Documento ya esta anulado, por favor verifique')
	return
end if

if MessageBox('Aviso', 'Desea anular este parte de recepcion y descarga de materia prima?', Information!, Yesno!, 2) = 2 then return


//Anulando
dw_1.object.flag_estado [idw_1.getRow()] = '0'
dw_1.ii_update = 1

idw_2.event ue_delete_all( )
idw_2.ii_update = 1

idw_lecturas.event ue_delete_all( )
idw_lecturas.ii_update = 1

idw_obs.event ue_delete_all( )
idw_obs.ii_update = 1

idw_firmas.event ue_delete_all( )
idw_firmas.ii_update = 1

is_action = 'anular'

of_set_status_menu(idw_1)

end event

event close;call super::close;destroy invo_wait
destroy invo_nro
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap307_pd_descarga
boolean visible = false
integer x = 2679
integer y = 952
integer width = 146
integer height = 100
boolean enabled = false
end type

event dw_master::constructor;//Override

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap307_pd_descarga
boolean visible = false
integer x = 0
integer y = 220
integer width = 55
integer height = 48
boolean enabled = false
boolean hsplitscroll = true
end type

event dw_detail::constructor;//Override

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type dw_1 from u_dw_abc within w_ap307_pd_descarga
event ue_display ( string as_columna,  long al_row )
integer y = 164
integer width = 3200
integer height = 836
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ap_descarga_diaria_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
integer	li_i

choose case lower(as_columna)
	case "cod_moneda"
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				  + "DESCRIPCION AS DESC_MONEDA " &
				  + "FROM MONEDA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
		if ls_codigo <> '' then					
			this.object.cod_moneda [al_row] = ls_codigo
			this.object.desc_moneda[al_row] = ls_data
			
			for li_i = 1 to idw_2.RowCount( )
				idw_2.object.mon_vta[li_i] = ls_codigo	
			next
			
		end if
		
		this.ii_update = 1

	case "turno"
		
		ls_sql = "select t.turno as turno, " &
				 + "t.descripcion as desc_turno " &
				 + "from turno t " &
				 + "where t.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then					
			
			this.object.turno 		[al_row] = ls_codigo
			this.object.desc_turno	[al_row] = ls_data
			
		end if
		
		this.ii_update = 1		
end choose
end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)


end event

event itemchanged;call super::itemchanged;string ls_flag, ls_data
integer i

this.AcceptText()

if row = 0 then
	return
end if

choose case lower(dwo.name)
	
	case "cod_moneda"
		
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';

		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'LA MONEDA ' + data + ' NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.cod_moneda	[row] = gnvo_app.is_null
			this.object.desc_moneda	[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_moneda [row] = ls_data
		
		for i = 1 to idw_2.RowCount( )
			idw_2.object.mon_vta[i] = data
		next

	case "turno"
		
		select descripcion
			into :ls_data
		from turno
		where turno = :data
		  and flag_estado = '1';

		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'EL TURNO ' + data + ' NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.turno			[row] = gnvo_app.is_null
			this.object.desc_turno	[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_turno [row] = ls_data
		
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
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
	 	this.event ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_desc_moneda
is_action = 'new'

select descripcion
	into :ls_desc_moneda
from moneda
where cod_moneda = :gnvo_app.is_soles;

this.object.fecha_descarga			[al_row] = Date(gnvo_app.of_fecha_actual())
this.object.fec_registro			[al_row] = gnvo_app.of_fecha_actual()
this.object.ritmo_artesanal_min 	[al_row] = 0
this.object.ritmo_artesanal_max	[al_row] = 0
this.object.ritmo_industrial_min [al_row] = 0
this.object.ritmo_industrial_max [al_row] = 0
this.object.cod_origen				[al_row] = gs_origen
this.object.flag_replicacion		[al_row] = '1'
this.object.flag_estado				[al_row] = '1'
this.object.cod_usr					[al_row] = gs_user
this.object.cod_moneda				[al_row] = gnvo_app.is_soles
this.object.desc_moneda				[al_row] = ls_desc_moneda

this.object.p_logo.FileName = gs_logo

idw_2.reset()
idw_lecturas.reset()
idw_obs.reset()
idw_firmas.reset()

idw_2.ii_protect 			= 1
idw_lecturas.ii_protect = 1
idw_obs.ii_protect 		= 1
idw_firmas.ii_protect 	= 1

idw_2.of_protect()
idw_lecturas.of_protect()
idw_obs.of_protect()
idw_firmas.of_protect()

idw_2.ii_update 			= 0
idw_lecturas.ii_update 	= 0
idw_obs.ii_update 		= 0
idw_firmas.ii_update 	= 0

Tab_detalles.Selectedtab = 1

of_set_status_menu(this)
end event

type tab_detalles from tab within w_ap307_pd_descarga
event create ( )
event destroy ( )
integer y = 1024
integer width = 3250
integer height = 1352
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_detalles.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_detalles.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_detalles
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3214
integer height = 1224
long backcolor = 79741120
string text = "Detalle de Parte Diario"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "SelectReturn!"
long picturemaskcolor = 536870912
tab_1 tab_1
end type

on tabpage_1.create
this.tab_1=create tab_1
this.Control[]={this.tab_1}
end on

on tabpage_1.destroy
destroy(this.tab_1)
end on

type tab_1 from tab within tabpage_1
event create ( )
event destroy ( )
integer width = 2240
integer height = 1008
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2203
integer height = 880
long backcolor = 79741120
string text = "Registro de Descarga / Recepción"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_4.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_4.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tabpage_4
integer width = 2249
integer height = 760
integer taborder = 30
string dataobject = "d_ap_pd_descarga_det_pesca_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event doubleclicked;call super::doubleclicked;string ls_columna
Str_parametros	lstr_rep
w_ap301_guia_recepcion_frm lw1

IF row = 0 then return

if lower(dwo.name) = 'cod_guia_rec' then
	
	lstr_rep.string1 = this.object.cod_guia_rec[row]
	
	OpenSheetWithParm(lw1, lstr_rep, w_main, 0, Layered!)
	
else
	if not this.is_protect(dwo.name, row) and row > 0 then
		ls_columna = upper(dwo.name)
		THIS.event dynamic ue_display(ls_columna, row)
	end if
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_data2, ls_proveedor_transp, ls_mensaje, &
			ls_prov_transp, ls_ruta, ls_moneda, ls_tipo_fact, ls_inc_igv, &
			ls_especie, ls_exo_igv, ls_proveedor
Decimal	ldc_importe
date	 	ld_today, ld_fecha, ld_fecha2, ld_fecha3
decimal	ldc_peso_est, ldc_peso_bruto
long		ll_count

THIS.AcceptText()

if row <= 0 then return

CHOOSE CASE lower(dwo.name)
	CASE "cod_art"
		
		ls_especie = this.object.especie [row]
			
		if IsNull(ls_especie) or ls_especie = '' then
			MessageBox('Error', 'Debe ingresar una especie de Materia Prima', stopSign!)
			setColumn('especie')
			return
		end if
			
		SELECT a.desc_art, a.und
			INTO :ls_data, :ls_data2
		FROM 	articulo a,
				tg_especies_articulo tea
		WHERE tea.cod_art = a.cod_art
		  and tea.especie = :ls_especie
		  and a.cod_art	= :data
		  and a.flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de articulo " + data + " no existe o no esta activo o no pertenece a la especie " + ls_especie, StopSign!)
			this.object.cod_Art	[row] = gnvo_app.is_null
			this.object.desc_art	[row] = gnvo_app.is_null
			return 1
		END IF

		this.object.desc_art[row] = ls_data
		
	CASE "zona_descarga"
		SELECT descripcion, flag_tipo
			INTO :ls_data, :ls_data2
		FROM ap_zona_descarga
		WHERE zona_descarga = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de zona de descarga no existe", StopSign!)
			this.object.zona_descarga			[row] = gnvo_app.is_null
			this.object.desc_zona_descarga	[row] = gnvo_app.is_null
			this.object.flag_tipo				[row] = gnvo_app.is_null
			return 1
		END IF

		this.object.desc_zona_descarga[row] = ls_data
		this.object.flag_tipo 			[row] = ls_data2
		
	CASE "proveedor"
		Select p.nom_proveedor
		  Into :ls_data
		  from ap_prov_mp_especie ap, proveedor p 
		 Where ap.proveedor = p.proveedor 
		   and Nvl(ap.flag_estado,'0')='1'
			and Nvl(p.flag_estado,'0')='1'
			and ap.proveedor = :data;
			
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Proveedor no existe o no esta activo", StopSign!)
			this.object.proveedor		[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			return 1
		END IF

		this.object.nom_proveedor[row] = ls_data
		
		SELECT N.NOMB_NAVE, N.MATRICULA
		  INTO :ls_data, :ls_data2
		FROM TG_NAVES N
		WHERE N.Proveedor = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			this.object.nomb_nave	[row] = gnvo_app.is_null
			this.object.matricula	[row] = gnvo_app.is_null
			return 1
		END IF

		//This.object.nomb_nave	[row] = ls_data
		//This.object.matricula	[row] = ls_data2
		
		/*Tarifa de Materia Prima*/
		ls_proveedor 	= data
		ls_especie		= This.Object.especie[row]
		ld_fecha			= Date(This.Object.inicio_descarga[row])
		
		if IsNull(ls_proveedor) or IsNull(ls_especie) or &
			ls_proveedor = '' or ls_especie = '' then return
		
		// Obtengo la tarifa
		Select apt.cod_moneda, Nvl(apt.importe,0), 
				 Nvl(apt.flag_inc_igv,'0'), Nvl(apt.flag_exon_igv,'0')
        Into :ls_moneda, :ldc_importe, :ls_inc_igv, :ls_exo_igv
      From ap_prov_mp_tarifa apt
      Where apt.proveedor = :ls_proveedor
        and apt.especie = :ls_especie
        and :ld_fecha Between apt.fecha_inicio and apt.fecha_fin;

		if SQLCA.SQLCode = 100 then
			MessageBox('Dato no encontrado', 'Proveedor de MP no tiene tarifas vigentes, por favor verificar')
			setNull(ldc_importe)
			This.Object.cod_mon_vta				[row] = gnvo_app.is_null
			This.Object.precio_venta			[row] = ldc_importe
			This.Object.flag_incluye_igv_vta	[row] = gnvo_app.is_null
			This.Object.flag_exo_igv_vta		[row] = gnvo_app.is_null
			this.object.proveedor				[row] = gnvo_app.is_null
			this.setColumn('proveedor')
			return
		end if
		
		This.Object.cod_mon_vta				[row] = ls_moneda
		This.Object.precio_venta			[row] = ldc_importe
		This.Object.flag_incluye_igv_vta	[row] = ls_inc_igv
		This.Object.flag_exo_igv_vta		[row] = ls_exo_igv	
		
		
	CASE "especie"
		ls_proveedor 	= This.Object.proveedor[row]
		
		if IsNull(ls_proveedor) or ls_proveedor = '' then
			MessageBox("Error", "Debe ingresar el proveedor de MP")
			this.setColumn("proveedor")
			Return	
		end if
		
		SELECT descr_especie
		 	INTO :ls_data
		FROM tg_especies
		WHERE especie = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Especie no existe", StopSign!)
			this.object.especie			[row] = gnvo_app.is_null
			this.object.descr_especie	[row] = gnvo_app.is_null
			return 1
		END IF

		this.object.descr_especie[row] = ls_data
		
		/*Tarifa de Materia Prima*/
		
		ls_especie		= data
		ld_fecha			= Date(This.Object.inicio_descarga[row])
		
		// Obtengo la tarifa
		Select apt.cod_moneda, Nvl(apt.importe,0), 
				 Nvl(apt.flag_inc_igv,'0'), Nvl(apt.flag_exon_igv,'0')
        Into :ls_moneda, :ldc_importe, :ls_inc_igv, :ls_exo_igv
      From ap_prov_mp_tarifa apt
      Where apt.proveedor = :ls_proveedor
        and apt.especie = :ls_especie
        and :ld_fecha Between apt.fecha_inicio and apt.fecha_fin;

		if SQLCA.SQLCode = 100 then
			MessageBox('Dato no encontrado', 'Proveedor de MP no tiene tarifas vigentes, por favor verificar')
			setNull(ldc_importe)
			This.Object.cod_mon_vta				[row] = gnvo_app.is_null
			This.Object.precio_venta			[row] = ldc_importe
			This.Object.flag_incluye_igv_vta	[row] = gnvo_app.is_null
			This.Object.flag_exo_igv_vta		[row] = gnvo_app.is_null
			this.object.proveedor				[row] = gnvo_app.is_null
			this.setColumn('especie')
			return
		end if
		
		This.Object.cod_mon_vta				[row] = ls_moneda
		This.Object.precio_venta			[row] = ldc_importe
		This.Object.flag_incluye_igv_vta	[row] = ls_inc_igv
		This.Object.flag_exo_igv_vta		[row] = ls_exo_igv	
		
	CASE "cod_balanza"
		SELECT desc_maq
		 	INTO :ls_data
		FROM maquina
		WHERE cod_maquina = :data
		 AND cod_origen = :gs_origen;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de balanza no existe", StopSign!)
			this.object.cod_balanza	[row] = gnvo_app.is_null
			this.object.desc_maq		[row] = gnvo_app.is_null
			return 1
		END IF

		this.object.desc_maq[row] = ls_data
	
	CASE "und_peso"
		SELECT desc_unidad
		  INTO :ls_data
		  FROM UNIDAD
	   WHERE und = :data
		  and flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Unidad no existe o no se encuentra activo, por favor verifique!", StopSign!)
			this.object.und_peso		[row] = gnvo_app.is_null
			
			if this.of_ExisteCampo("desc_unidad") then
				this.object.desc_unidad	[row] = gnvo_app.is_null
			end if
			
			return 1
		END IF
		
		if this.of_ExisteCampo("desc_unidad") then
			this.object.desc_unidad[row] = ls_data
		end if
				
	CASE "zona_pesca"
		SELECT descr_zona
		 	INTO :ls_data
		FROM tg_zonas_pesca
		WHERE zona_pesca = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Código de Zona de Pesca no existe", StopSign!)
			this.object.zona_pesca			[row] = gnvo_app.is_null
			this.object.descr_zona_pesca	[row] = gnvo_app.is_null
			return 1
		END IF

		THIS.object.descr_zona_pesca[row] = ls_data
	
	CASE "inicio_descarga"
		ld_today = date(f_fecha_actual())
		ld_fecha = date(this.object.inicio_descarga [row])
		
		IF ld_today < ld_fecha THEN
			messagebox('Aviso', 'La fecha ingresada no es válida')
			this.object.inicio_descarga [row] = gnvo_app.id_null
			return 1
		END IF
		
	CASE "fin_descarga"
	   ld_today = date(gnvo_app.of_fecha_actual())
		ld_fecha = date(this.object.fin_descarga [row])
		ld_fecha2 = date(this.object.inicio_descarga [row])
		ld_fecha3 = RelativeDate(ld_fecha,-1)
		
		IF ld_today < ld_fecha THEN
			messagebox('Aviso', 'La fecha ingresada no puede ser mayor a la fecha actual ' + string(ld_today, 'dd/mm/yyyy'), StopSign!)
			this.object.fin_descarga [row] = gnvo_app.id_null
			return 1
		END IF
		IF ld_fecha <> ld_fecha2 THEN
			IF ld_fecha2 <> ld_fecha3 THEN
				messagebox('Aviso', 'Error en el rango de fechas')
				this.object.fin_descarga [row] = gnvo_app.id_null
				RETURN 1
			END IF
		END IF
	
	CASE "prov_transporte"
		Select Distinct p.nom_proveedor 
		  Into :ls_data
        from proveedor p, ap_transportes_mp mp 
       Where p.proveedor = mp.PROVEEDOR 
	 		and Nvl(p.flag_estado,'0')='1' 
   		and Nvl(mp.flag_estado,'0')='1'
			and p.proveedor = :data;
					
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Proveedor de Transporte no existe", StopSign!)
			this.object.prov_transporte	[row] = gnvo_app.is_null
			this.object.nomb_transp			[row] = gnvo_app.is_null
			return 1
		END IF

		THIS.object.nomb_transp[row] = ls_data
	
	CASE "nro_placa"
		ls_proveedor_transp = This.Object.prov_transporte [row]
		
		Select ap.nro_placa Into :ls_data
  		  From ap_transportes_mp ap
 		 Where Nvl(ap.flag_estado,'0')='1' 
   		and ap.PROVEEDOR =  :ls_proveedor_transp
			and ap.nro_placa = :data;
					
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Placa no existe para el Proveedor " + ls_proveedor_transp, StopSign!)
			this.object.nro_placa			[row] = gnvo_app.is_null		
			return 1
		END IF		
		
		//of_get_tarifa(ls_proveedor_transp, data)
	
	case "peso_estimado"
		ldc_peso_bruto = Dec(this.object.peso_bruto[row])
		ldc_peso_est	= Dec(data)
		
		if IsNull(ldc_peso_bruto) or ldc_peso_bruto = 0 then
			this.object.peso_bruto [row] = ldc_peso_est
		end if
	
	case "cod_ruta"
		ls_prov_transp = this.object.prov_transporte[row]
		
		if IsNull(ls_prov_transp) or ls_prov_transp = '' then
			MessageBox('Error', 'Debe elegir un proveedor de transporte')
			setColumn('prov_transporte')
			return
		end if
		
		Select count(*) 
		  into :ll_count
		from ap_transp_ruta atr, 
				ap_rutas_mp arm 
		Where atr.cod_ruta = arm.cod_ruta 
		and Nvl(arm.flag_estado,'0')='1' 
		and Nvl(atr.flag_estado,'0')='1'
		and atr.proveedor = : ls_prov_transp;
					
		IF ll_count = 0 THEN
			Messagebox('Aviso', "Código de Ruta no existe, por favor verifique", StopSign!)
			this.object.cod_ruta			[row] = gnvo_app.is_null		
			return 1
		END IF
		
		/*Tarifa de Transporte*/
		ld_fecha			= Date(This.Object.inicio_descarga[row])
		
		// Obtengo la tarifa del proveedor de transporte de MP
		Select at.cod_moneda, at.importe, 
				 at.flag_tipo_fact, at.flag_inc_igv
        Into :ls_moneda, :ldc_importe, 
		  		:ls_tipo_fact, :ls_inc_igv
        From ap_transp_tarif at
		Where at.proveedor = :ls_prov_transp
		  and at.cod_ruta = :data
		  and :ld_fecha Between at.fecha_inicio and at.fecha_fin;
		
		IF SQLCA.SQLCode = 100 then
			MessageBox('Dato no encontrado', &
				'proveedor de Transporte no tiene tarifa vigente, por favor verifique')
			setNull(ldc_importe)
			
			this.object.cod_ruta						[row] = gnvo_app.is_null
			this.object.cod_moneda 					[row] = gnvo_app.is_null
			this.object.flag_incluye_igv_flete 	[row] = gnvo_app.is_null
			this.object.flag_tipo_fact				[row] = gnvo_app.is_null
			this.object.precio_flete				[row] = ldc_importe
			
			this.setColumn('cod_ruta')
			return
		end if
		
		this.object.cod_moneda 					[row] = ls_moneda
		this.object.precio_flete				[row] = ldc_importe
		this.object.flag_incluye_igv_flete 	[row] = ls_inc_igv
		this.object.flag_tipo_fact				[row] = ls_tipo_fact
		
END CHOOSE

end event

event itemerror;call super::itemerror;return 1
end event

event rowfocuschanged;call super::rowfocuschanged;int    li_item
string ls_filtro


IF not isNull(currentrow) AND currentrow > 0 Then

	li_item		 = this.object.nro_item		[currentrow]
   ls_filtro = "item = " + string(li_item)
	IF isNull(ls_filtro) THEN ls_filtro = ''
		
	idw_lecturas.setfilter( ls_filtro )
	idw_lecturas.Filter( )
	
End if


end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_parte

if dw_1.GetRow() = 0 then return

if IsNull(dw_1.object.cod_moneda[dw_1.GetRow()]) or trim(dw_1.object.cod_moneda[dw_1.GetRow()]) = '' then
	MessageBox('Error', 'Debe especificar la moneda del parte de recepcion de materia prima', StopSign!)
	return
end if

ls_nro_parte = dw_1.object.nro_parte[dw_1.GetRow()]

dw_master.AcceptText()

this.object.nro_item						[al_row] = of_nro_item(this)
this.object.nro_parte 					[al_row] = ls_nro_parte
this.object.inicio_descarga			[al_row] = dw_1.object.fecha_descarga[dw_1.getRow( )]
this.object.fin_descarga				[al_row] = dw_1.object.fecha_descarga[dw_1.getRow( )]
this.object.cod_usr						[al_row] = gs_user
this.object.cod_moneda					[al_row] = dw_1.object.cod_moneda[dw_1.GetRow()]

if this.of_existecampo( "flag_incluye_igv_flete") then
	this.object.flag_incluye_igv_flete	[al_row] = '0'
end if

if this.of_existecampo( "flag_incluye_igv_vta") then
	this.object.flag_incluye_igv_vta 	[al_row] = '0'
end if

if this.of_existecampo( "precio_flete") then
	this.object.precio_flete 				[al_row] = 0.00
end if

if this.of_existecampo( "nro_marea") then
	this.object.nro_marea					[al_row] = 0	
end if

if this.of_existecampo( "precio_venta") then
	this.object.precio_venta 				[al_row] = 0.00
end if

if this.of_existecampo( "peso_estimado") then
	this.object.peso_estimado 				[al_row] = 0
end if

if this.of_existecampo( "peso_bruto") then
	this.object.peso_bruto					[al_row] = 0
end if

if this.of_existecampo( "tara") then
	this.object.tara							[al_row] = 0
end if

if this.of_existecampo( "peso_variacion") then
	this.object.peso_variacion 			[al_row] = 0
end if


// Para controlar la función de modificar
This.object.flag_guia  					[al_row] = '1'
This.object.flag_cierre					[al_row] = '1'

//if al_row > 0 then
//	this.object.zona_descarga			[al_row] = this.object.zona_descarga		[al_row - 1]
//	this.object.desc_zona_descarga	[al_row] = this.object.desc_zona_descarga	[al_row - 1]
//	this.object.proveedor				[al_row] = this.object.proveedor				[al_row - 1]
//	this.object.nom_proveedor			[al_row] = this.object.nom_proveedor		[al_row - 1]
//	this.object.nro_bl					[al_row] = this.object.nro_bl					[al_row - 1]
//	this.object.nro_contenedor			[al_row] = this.object.nro_contenedor		[al_row - 1]
//	this.object.nro_guia_remision		[al_row] = this.object.nro_guia_remision	[al_row - 1]
//	this.object.nave						[al_row] = this.object.nave					[al_row - 1]
//	this.object.nomb_nave				[al_row] = this.object.nomb_nave				[al_row - 1]
//	this.object.flag_registro_issf	[al_row] = this.object.flag_registro_issf	[al_row - 1]
//	this.object.flag_euro_1				[al_row] = this.object.flag_euro_1			[al_row - 1]
//	this.object.cuba						[al_row] = this.object.cuba					[al_row - 1]
//	this.object.nro_marea				[al_row] = this.object.nro_marea				[al_row - 1]
//	this.object.especie					[al_row] = this.object.especie				[al_row - 1]
//	this.object.descr_especie			[al_row] = this.object.descr_especie		[al_row - 1]
//	this.object.der						[al_row] = this.object.der						[al_row - 1]
//	this.object.cod_art					[al_row] = this.object.cod_art				[al_row - 1]
//	this.object.desc_art					[al_row] = this.object.desc_art				[al_row - 1]
//	this.object.nro_lote					[al_row] = this.object.nro_lote				[al_row - 1]
//	this.object.almacen_dst				[al_row] = this.object.almacen_dst			[al_row - 1]
//	this.object.anaquel					[al_row] = this.object.anaquel				[al_row - 1]
//	this.object.fila						[al_row] = this.object.fila					[al_row - 1]
//	this.object.columna					[al_row] = this.object.columna				[al_row - 1]
//	this.object.und_peso					[al_row] = this.object.und_peso				[al_row - 1]
//	this.object.inicio_descarga		[al_row] = this.object.inicio_descarga		[al_row - 1]
//	this.object.fin_descarga			[al_row] = this.object.fin_descarga			[al_row - 1]
//	this.object.cod_uso_ref				[al_row] = this.object.cod_uso_ref			[al_row - 1]
//end if

of_set_modify()
//
end event

event ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_data3, ls_data4, ls_data5, ls_data6, ls_string, &
			ls_evaluate, ls_prov_transp, ls_almacen, ls_mensaje, &
			ls_moneda, ls_tipo_fact, ls_inc_igv, ls_especie, ls_exo_igv, ls_proveedor, &
			ls_nave, ls_anaquel, ls_fila, ls_columna
Decimal	ldc_importe
Date		ld_fecha
Long		ll_count

try 

	choose case lower(as_columna)
		
		case "cod_art"
			ls_especie = this.object.especie [al_row]
			
			if IsNull(ls_especie) or ls_especie = '' then
				MessageBox('Error', 'Debe ingresar una especie de Materia Prima', stopSign!)
				setColumn('especie')
				return
			end if
			
			ls_sql = "select a.cod_art as codigo_articulo, " &
					 + "a.desc_art as descripcion_articulo, " &
					 + "a.und as unidad " &
					 + "from tg_especies_articulo tea, " &
					 + "     articulo             a " &
					 + "where tea.cod_art = a.cod_art " &
					 + "  and tea.especie = '" + ls_especie + "'" &
					 + "  and a.flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.cod_art 	 	[al_row] = ls_codigo
				this.object.desc_art		[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "cod_planta"
			ls_sql = "Select p.proveedor as codigo_proveedor, " &
					 + "p.nom_proveedor as nom_proveedor, "&
					 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as dni_ruc " &
					 + "from proveedor p " &
					 + "Where p.flag_estado = '1' "
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.cod_planta 	 	[al_row] = ls_codigo
				this.object.nom_planta		[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "zona_descarga"
			ls_sql = "SELECT ZONA_DESCARGA AS COD_ZONA_DESC, " &
					  + "DESCRIPCION AS DESCRIPCION_ZONA_DESC, " &
					  + "FLAG_TIPO AS FLAG_TIPO " &
					  + "FROM AP_ZONA_DESCARGA " &
					  + "WHERE FLAG_ESTADO = '1'"
					 
			lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '1')
			
			if ls_codigo <> '' then
				this.object.zona_descarga 		 [al_row] = ls_codigo
				this.object.desc_zona_descarga [al_row] = ls_data
				this.object.flag_tipo			 [al_row] = ls_data2
				this.ii_update = 1
			end if
			
		case "proveedor"
			ls_sql = "Select ap.proveedor as codigo_proveedor, " &
					 + "p.nom_proveedor as nom_proveedor, "&
					 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as dni_ruc " &
					 + "from ap_proveedor_mp ap, " &
					 + "proveedor p " &
					 + "Where ap.proveedor = p.proveedor " &
					 + "and Nvl(ap.flag_estado,'0')='1' "&
					 + "and Nvl(p.flag_estado,'0')='1' "
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.proveedor 	 	[al_row] = ls_codigo
				this.object.nom_proveedor	[al_row] = ls_data
				this.object.nave 		 		[al_row] = gnvo_app.is_null
				this.object.nomb_nave 		[al_row] = gnvo_app.is_null
				this.object.matricula 		[al_row] = gnvo_app.is_null
				this.ii_update = 1
			end if
			
			/*Tarifa de Materia Prima*/
			ls_proveedor	= ls_codigo
			ls_especie		= This.Object.especie[al_row]
			ld_fecha			= Date(This.Object.inicio_descarga[al_row])
			
			// Si la especie o el proveedor son nulos entonces no hago nada
			if isNull(ls_proveedor) or isNull(ls_especie) &
				or ls_especie = '' or ls_proveedor = '' then 
				return
			end if
			
			// Obtengo la tarifa
			if gnvo_app.of_get_parametro("APROV_FILTRAR_TARIFAS", "1") = "1" then
				Select apt.cod_moneda, Nvl(apt.importe,0), 
						 Nvl(apt.flag_inc_igv,'0'), Nvl(apt.flag_exon_igv,'0')
				  Into :ls_moneda, :ldc_importe, :ls_inc_igv, :ls_exo_igv
				From ap_prov_mp_tarifa apt
				Where apt.proveedor = :ls_proveedor
				  and apt.especie = :ls_especie
				  and :ld_fecha Between apt.fecha_inicio and apt.fecha_fin;
		
				if SQLCA.SQLCode = 100 then
					MessageBox('Dato no encontrado', 'Proveedor de MP no tiene tarifas vigentes, por favor verificar')
					setNull(ldc_importe)
					This.Object.cod_mon_vta				[al_row] = gnvo_app.is_null
					This.Object.precio_venta			[al_row] = 0
					This.Object.flag_incluye_igv_vta	[al_row] = gnvo_app.is_null
					This.Object.flag_exo_igv_vta		[al_row] = gnvo_app.is_null
					this.object.proveedor				[al_row] = gnvo_app.is_null
					this.setColumn('proveedor')
					return
				end if
				
				This.Object.cod_mon_vta				[al_row] = ls_moneda
				This.Object.precio_venta			[al_row] = ldc_importe
				This.Object.flag_incluye_igv_vta	[al_row] = ls_inc_igv
				This.Object.flag_exo_igv_vta		[al_row] = ls_exo_igv	
				
			else
				
				This.Object.cod_mon_vta				[al_row] = gnvo_app.is_null
				This.Object.precio_venta			[al_row] = 0
				This.Object.flag_incluye_igv_vta	[al_row] = '1'
				This.Object.flag_exo_igv_vta		[al_row] = '0'	
				
			end if
			
			
		case "especie"
			ls_proveedor = This.Object.proveedor[al_row]
			
			if IsNull(ls_proveedor) or ls_proveedor = '' then
				MessageBox('Error', 'Debe ingresar un proveedor de MP', stopSign!)
				setColumn('proveedor')
				return
			end if
			
			if gnvo_app.of_get_parametro( "APROV_FILTRAR_ESPECIE_X_NAVE", "1") = "1" then
				ls_nave = This.Object.nave[al_row]
				
				if IsNull(ls_nave) or trim(ls_nave) = '' then 
					ls_sql = "Select Distinct ape.especie as especie, " &
							 + "t.descr_especie as descripcion, " &
							 + "null as almacen " &
							 + "from AP_PROV_MP_TARIFA ape, " &
							 + "tg_especies t "&
							 + "Where ape.especie = t.especie " &
							 + "and trunc(sysdate) between trunc(fecha_inicio) and trunc(fecha_fin) " &
							 + "and ape.proveedor = '" + ls_proveedor + "'"
				else
					ls_sql = "select distinct te.especie as especie,  " &
							 + "te.descr_especie as desc_especie, " &
							 + "null as almacen " &
							 + "from tg_naves t, " &
							 + "     tg_naves_especies tge, " &
							 + "     tg_especies       te " &
							 + "where t.nave = tge.nave   " &
							 + "  and tge.especie = te.especie "&
							 + "  and te.flag_estado = '1'" &
							 + "  and tge.nave = '" + ls_nave + "'"
				end if
						 
			else
				ls_sql = "Select Distinct ape.especie as especie, " &
							 + "t.descr_especie as descripcion, " &
							 + "null as almacen " &
							 + "from AP_PROV_MP_TARIFA ape, " &
							 + "tg_especies t "&
							 + "Where ape.especie = t.especie " &
							 + "and trunc(sysdate) between trunc(fecha_inicio) and trunc(fecha_fin) " &
							 + "and ape.proveedor = '" + ls_proveedor + "'"
			end if
						
			
			lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_almacen, '1')
			
			if ls_codigo <> '' then
				this.object.especie 			[al_row] = ls_codigo
				this.object.descr_especie 	[al_row] = ls_data
				this.object.almacen_dst		[al_Row] = ls_almacen
				this.ii_update = 1
			end if
			
			/*Tarifa de Materia Prima*/
			if not IsNull(ls_nave) and trim(ls_nave) <>'' then
				ls_especie 		= ls_codigo
				ld_fecha			= Date(This.Object.inicio_descarga[al_row])
				
				Select apt.cod_moneda, Nvl(apt.importe,0), 
						 Nvl(apt.flag_inc_igv,'0'), Nvl(apt.flag_exon_igv,'0')
				  Into :ls_moneda, :ldc_importe, :ls_inc_igv, :ls_exo_igv
				From ap_prov_mp_tarifa apt
				Where apt.proveedor 	= :ls_proveedor
				  and apt.especie 	= :ls_especie
				  and :ld_fecha Between apt.fecha_inicio and apt.fecha_fin;
		
				if SQLCA.SQLCode = 100 then
					MessageBox('Dato no encontrado', 'Proveedor de MP no tiene tarifas vigentes, por favor verificar.' &
															+ '~r~nProveedor: ' + ls_proveedor &
															+ '~r~nEspecie: ' + ls_especie)
					setNull(ldc_importe)
					This.Object.cod_mon_vta				[al_row] = gnvo_app.is_null
					This.Object.precio_venta			[al_row] = ldc_importe
					This.Object.flag_incluye_igv_vta	[al_row] = gnvo_app.is_null
					This.Object.flag_exo_igv_vta		[al_row] = gnvo_app.is_null
					this.object.especie					[al_row] = gnvo_app.is_null
					this.setColumn('especie')
					return
				end if
				
				This.Object.cod_mon_vta				[al_row] = ls_moneda
				This.Object.precio_venta			[al_row] = ldc_importe
				This.Object.flag_incluye_igv_vta	[al_row] = ls_inc_igv
				This.Object.flag_exo_igv_vta		[al_row] = ls_exo_igv
			else
				This.Object.cod_mon_vta				[al_row] = gnvo_app.is_soles
				This.Object.precio_venta			[al_row] = 1.00
				This.Object.flag_incluye_igv_vta	[al_row] = '0'
				This.Object.flag_exo_igv_vta		[al_row] = '0'
			end if
	
		case "nave"
			ls_proveedor = This.Object.proveedor[al_row]
			if IsNull(ls_proveedor) or ls_proveedor = '' then
				MessageBox('Error', 'Debe ingresar un proveedor de MP')
				setColumn('proveedor')
				return
			end if
			
			if gnvo_app.of_get_parametro( "APROV_FILTRAR_NAVES_X_ARMADOR", "1") = "1" then
				ls_sql = "SELECT t.nave AS codigo, " &
						  + "t.nomb_nave AS descripcion_nave, " &
						  + "t.matricula AS matricula, " &
						  + "t.flag_registro_issf AS REGISTRO_ISSF, " &
						  + "T.FLAG_EURO_1 AS EURO_1, " &
						  + "T.CUBA  AS CUBA " &
						  + "FROM tg_naves t " &
						  + "WHERE FLAG_ESTADO = '1'" &
						  + "  and proveedor = '" + ls_proveedor + "'"
			else
				ls_sql = "select t.nave as nave, " &
						 + "t.nomb_nave as nombre_nave, " &
						 + "matricula AS matricula, " &
						  + "t.flag_registro_issf AS REGISTRO_ISSF, " &
						  + "T.FLAG_EURO_1 AS EURO_1, " &
						  + "T.CUBA  AS CUBA " &
						 + "from tg_naves t, " &
						 + "     tg_naves_sanipes ts " &
						 + "where t.nave = ts.nave (+) " &
						 + "  and (ts.fec_fin_sanipes is null or (ts.fec_fin_sanipes is not null and trunc(ts.fec_fin_sanipes) > trunc(sysdate))) " &
						 + "  and t.flag_estado = '1'"
			end if		
					 
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, ls_data4, ls_data5, '1') then
				this.object.nave 		 [al_row] = ls_codigo
				this.object.nomb_nave [al_row] = ls_data
				this.object.matricula [al_row] = ls_data2
				
				if this.of_existecampo( "flag_registro_issf") then
					this.object.flag_registro_issf [al_row] = ls_data3
				end if
				
				if this.of_existecampo( "flag_euro_1") then
					this.object.flag_euro_1 [al_row] = ls_data4
				end if
				
				if this.of_existecampo( "cuba") then
					this.object.cuba [al_row] = ls_data5
				end if
				
				this.ii_update = 1
			end if
			
			
		case "cod_balanza"
			ls_sql = "SELECT M.COD_MAQUINA AS COD_MAQUINA, " 	&
					  + "M.DESC_MAQ AS DESCRIPCION_MAQUINA, " 	&
					  + "M.COD_ORIGEN AS ORIGEN "						&
					  + "FROM MAQUINA M, " 								&
					  + "BALANZA B "										&
					  + "WHERE M.COD_MAQUINA = B.COD_MAQUINA "  	&
					  + " AND  M.COD_ORIGEN = '" + gs_origen + "'" &
					  + " AND  M.FLAG_ESTADO = '1'"
			
					 
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
				this.object.cod_balanza [al_row] = ls_codigo
				this.object.desc_maq		[al_row] = ls_data
				this.ii_update = 1
			end if
	
	
		case "und_peso"
			ls_sql = "SELECT U.UND AS CODIGO_UNIDAD, " &
					 + "U.DESC_UNIDAD AS DESCRIPCION " &
					 + "FROM vw_alm_und_peso U " &
					 + "WHERE U.FLAG_ESTADO = '1'"
					 
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
				this.object.und_peso		[al_row] = ls_codigo
				this.object.desc_unidad [al_row] = ls_data
				this.ii_update = 1
			end if
			
	
		case "zona_pesca"
			ls_sql = "SELECT ZONA_PESCA AS COD_ZONA_PESCA, " &
					  + "DESCR_ZONA AS DESCRIPCION_ZONA_PESCA " &
					  + "FROM TG_ZONAS_PESCA " &
					  + "WHERE FLAG_ESTADO = '1'"
					 
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
				this.object.zona_pesca			[al_row] = ls_codigo
				this.object.descr_zona_pesca 	[al_row] = ls_data
				this.ii_update = 1
			end if
			
		case "prov_transporte"
			ls_sql = "Select Distinct mp.proveedor as codigo_proveedor, "&
						+ "p.nom_proveedor as razon_social, " &
						+ "p.ruc as ruc_empresa " &
						+ "from proveedor p, " &
						+ "AP_TRANSP_UNID mp " &
						+ "Where p.proveedor = mp.proveedor "&
						+ "and p.flag_estado ='1' "&
						+ "and mp.flag_estado = '1' " &
						+ "order by p.nom_proveedor"
						
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.prov_transporte[al_row] = ls_codigo
				this.object.nomb_transp 	[al_row] = ls_data
				this.object.nro_placa		[al_row] = gnvo_app.is_null
				this.object.cod_moneda		[al_row] = gnvo_app.is_null
				this.object.precio_flete	[al_row] = 0.00
	
				this.ii_update = 1
			end if
			
		case "nro_placa"
			ls_prov_transp = this.object.prov_transporte[al_row]
			
			if IsNull(ls_prov_transp) or ls_prov_transp = "" then
				MEssageBox("Error", "Debe elegir previamente un transportista")
				return
			end if
			
			ls_sql = "Select mp.nro_placa as numero_placa, " &
					 + "peso_tara as peso_tara, " &
					 + "peso_util as peso_util " &
					 + "from ap_transp_unid mp " &
					 + "Where mp.proveedor = '" + ls_prov_transp + "' " 
						
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.nro_placa		[al_row] = ls_codigo
			end if
	
		case "cod_moneda"
			
			ls_sql = "Select m.cod_moneda as codigo, " &
					 + "m.descripcion as  descripcion " &
					 + "from moneda m " &
					 + "where m.flag_estado='1'"
		
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.cod_moneda	 [al_row] =ls_codigo
				this.ii_update = 1
			end if
			
		case "almacen_dst"
			select count(*)
				into :ll_count
			from almacen_user
			where cod_usr = :gs_user;
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje, StopSign!)
				return
			end if
			
			if ll_count = 0 then
				ls_sql = "Select distinct al.almacen as codigo_almacen, " &
						 + "		  al.desc_almacen as descripcion_almacen " &
						 + "from almacen al, " &
						 + "		tg_posiciones tp " &
						 + "where al.almacen = tp.almacen (+) " &
						 + "  and al.flag_estado='1'" &
						 + "  and al.flag_tipo_almacen in ('P', 'T')" &
						 + "  and al.cod_origen = '" + gs_origen + "' " &
						 + "order by al.almacen " 
						  
			else
				ls_sql = "Select distinct al.almacen as codigo_almacen, " &
						 + "		  al.desc_almacen as descripcion_almacen " &
						 + "from almacen 		  al, " &
						 + "		tg_posiciones tp, " &
						 + "     almacen_user  au " &
						 + "where al.almacen 	 		 = au.almacen " &
						 + "  and au.cod_usr 	 		 = '" + gs_user + "'" &
						 + "  and al.almacen 	 		 = tp.almacen (+) " &
						 + "  and al.flag_estado 		 = '1'" &
						 + "  and al.flag_tipo_almacen in ('P', 'T')" &
						 + "  and al.cod_origen 		 = '" + gs_origen + "' " &
						 + "order by al.almacen " 
						 
			end if			
			
		
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
				this.object.almacen_dst	[al_row] = ls_codigo
				this.ii_update = 1
			end if

		case "anaquel"
			ls_almacen = this.object.almacen_dst [al_row]
			
			if IsNull(ls_almacen) or trim(ls_almacen) = '' then
				MessageBox('Error', 'Debe elegir un almacen de destino de materia prima', StopSign!)
				this.setColumn("almacen_dst")
				return
			end if
			
			ls_sql = "Select al.almacen as codigo_almacen, " &
					 + "al.desc_almacen as descripcion_almacen, " &
					 + "tp.anaquel as anaquel, " &
					 + "tp.fila as fila, " &
					 + "tp.columna as columna " &
					 + "from almacen al, " &
					 + "tg_posiciones tp " &
					 + "where al.almacen = tp.almacen (+) " &
					 + "  and al.almacen = '" + ls_almacen + "'" &
					 + "  and al.flag_estado='1'"
		
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_anaquel, ls_fila, ls_columna, '1') then
				this.object.anaquel		[al_row] = ls_anaquel
				this.object.fila		 	[al_row] = ls_fila
				this.object.columna	 	[al_row] = ls_columna
				this.ii_update = 1
			end if			

		case "fila"
			ls_almacen = this.object.almacen_dst [al_row]
			
			if IsNull(ls_almacen) or trim(ls_almacen) = '' then
				MessageBox('Error', 'Debe elegir un almacen de destino de materia prima', StopSign!)
				this.setColumn("almacen_dst")
				return
			end if
			
			ls_anaquel = this.object.anaquel [al_row]
			
			if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
				MessageBox('Error', 'Debe elegir un anaquel', StopSign!)
				this.setColumn("anaquel")
				return
			end if
			
			ls_sql = "Select al.almacen as codigo_almacen, " &
					 + "al.desc_almacen as descripcion_almacen, " &
					 + "tp.anaquel as anaquel, " &
					 + "tp.fila as fila, " &
					 + "tp.columna as columna " &
					 + "from almacen al, " &
					 + "tg_posiciones tp " &
					 + "where al.almacen = tp.almacen (+) " &
					 + "  and al.almacen = '" + ls_almacen + "'" &
					 + "  and tp.anaquel = '" + ls_anaquel + "'" &
					 + "  and al.flag_estado='1'"
		
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_anaquel, ls_fila, ls_columna, '1') then
				this.object.fila		 	[al_row] = ls_fila
				this.object.columna	 	[al_row] = ls_columna
				this.ii_update = 1
			end if
			
		case "columna"
			ls_almacen = this.object.almacen_dst [al_row]
			
			if IsNull(ls_almacen) or trim(ls_almacen) = '' then
				MessageBox('Error', 'Debe elegir un almacen de destino de materia prima', StopSign!)
				this.setColumn("almacen_dst")
				return
			end if
			
			ls_anaquel = this.object.anaquel [al_row]
			
			if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
				MessageBox('Error', 'Debe elegir un anaquel', StopSign!)
				this.setColumn("anaquel")
				return
			end if
			
			ls_fila = this.object.fila [al_row]
			
			if IsNull(ls_fila) or trim(ls_fila) = '' then
				MessageBox('Error', 'Debe elegir un fila', StopSign!)
				this.setColumn("fila")
				return
			end if
			
			ls_sql = "Select al.almacen as codigo_almacen, " &
					 + "al.desc_almacen as descripcion_almacen, " &
					 + "tp.anaquel as anaquel, " &
					 + "tp.fila as fila, " &
					 + "tp.columna as columna " &
					 + "from almacen al, " &
					 + "tg_posiciones tp " &
					 + "where al.almacen = tp.almacen (+) " &
					 + "  and al.almacen = '" + ls_almacen + "'" &
					 + "  and tp.anaquel = '" + ls_anaquel + "'" &
					 + "  and tp.fila    = '" + ls_fila + "'" &
					 + "  and al.flag_estado='1'"
		
			if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_anaquel, ls_fila, ls_columna, '1') then
				this.object.columna	 	[al_row] = ls_columna
				this.ii_update = 1
			end if
		
		case "cod_ruta"
			ls_prov_transp = this.object.prov_transporte[al_row]
			
			if IsNull(ls_prov_transp) or ls_prov_transp = '' then
				MessageBox('Error', 'Debe elegir un proveedor de transporte')
				setColumn('prov_transporte')
				return
			end if
			
			ls_sql = "Select arm.cod_ruta as codigo, " &
					 + "arm.desc_ruta as descripcion, " &
					 + "arm.flag_estado as estado " &
					 + "from ap_transp_ruta atr, " &
					 + "ap_rutas_mp arm " &
					 + "Where atr.cod_ruta = arm.cod_ruta " & 
					 + "and Nvl(arm.flag_estado,'0')='1' " &
					 + "and Nvl(atr.flag_estado,'0')='1' " &
					 + "and atr.proveedor ='" +ls_prov_transp +"'"
						
			lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '1')
			
			if ls_codigo <> '' then
				this.object.cod_ruta 		 [al_row] = ls_codigo
				this.ii_update = 1
			end if
			
			/*Tarifa de Transporte*/
			ld_fecha			= Date(This.Object.inicio_descarga[al_row])
			
			// Obtengo la tarifa del proveedor de transporte de MP
			Select at.cod_moneda, at.importe, 
					 at.flag_tipo_fact, at.flag_inc_igv
			  Into :ls_moneda, :ldc_importe, 
					:ls_tipo_fact, :ls_inc_igv
			  From ap_transp_tarif at
			Where at.proveedor = :ls_prov_transp
			  and at.cod_ruta = :ls_codigo
			  and :ld_fecha Between at.fecha_inicio and at.fecha_fin;
			
			IF SQLCA.SQLCode = 100 then
				MessageBox('Dato no encontrado', &
					'proveedor de Transporte no tiene tarifa vigente, por favor verifique')
				setNull(ldc_importe)
				
				this.object.cod_ruta						[al_row] = gnvo_app.is_null
				this.object.cod_moneda 					[al_row] = gnvo_app.is_null
				this.object.flag_incluye_igv_flete 	[al_row] = gnvo_app.is_null
				this.object.flag_tipo_fact				[al_row] = gnvo_app.is_null
				this.object.precio_flete				[al_row] = ldc_importe
				
				this.setColumn('cod_ruta')
				return
			end if
			
			this.object.cod_moneda 					[al_row] = ls_moneda
			this.object.precio_flete				[al_row] = ldc_importe
			this.object.flag_incluye_igv_flete 	[al_row] = ls_inc_igv
			this.object.flag_tipo_fact				[al_row] = ls_tipo_fact
	end choose


catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error en evento ue_display")

end try

end event

event ue_duplicar;
//Oveeride
IF Lower(is_dwform) <> 'tabular' THEN
	MessageBox('Error', 'Solo se puede duplicar en ventanas Tabulares')
	RETURN
END IF

Long	ll_row, ll_totcol, ll_source
Any  la_id
Integer li_x

IF IsNull(il_row) OR il_row < 1 THEN
	MessageBox('Error','Tiene que Seleccionar una Fila')
	RETURN
END IF

ll_source = il_row
ll_row = THIS.Event ue_insert()

if ll_row > 0 then
	
	ll_totcol = Long(THIS.Object.DataWindow.Column.Count)
	
	FOR li_x = 1 TO ll_totcol
		if lower(this.Describe("#"+string(li_x)+".Name")) <> 'nro_item' then
			la_id = THIS.object.data.primary.current[ll_source, li_x]
			THIS.SetItem(ll_row, li_x, la_id)
		end if
	NEXT
	
end if
end event

type tabpage_5 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2203
integer height = 880
long backcolor = 79741120
string text = "Mediciones de Calidad"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_lecturas dw_lecturas
end type

on tabpage_5.create
this.dw_lecturas=create dw_lecturas
this.Control[]={this.dw_lecturas}
end on

on tabpage_5.destroy
destroy(this.dw_lecturas)
end on

type dw_lecturas from u_dw_abc within tabpage_5
integer width = 2190
integer height = 760
integer taborder = 30
string dataobject = "d_ap_pd_descarga_atrib_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)
end event

event itemchanged;call super::itemchanged;string ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "atributo"
		
		select descripcion
			into :ls_data
		from tg_calidad_atributo
		where atributo = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de Atributo no existe", StopSign!)
			this.object.atributo		[row] = ls_null
			this.object.descripcion	[row] = ls_null
			return 1
		end if

		this.object.atributo[row] = ls_data
		
end choose

end event

event itemerror;call super::itemerror;return 1
end event

event dwnenter;//Override

Send(Handle(this),256,9,Long(0,0))
return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_parte
long ll_item

if dw_1.GetRow() = 0 or idw_2.GetRow( ) = 0 then return

ls_nro_parte = idw_2.object.nro_parte	[idw_2.GetRow()]
ll_item 		 = idw_2.object.nro_item	[idw_2.GetRow()]

if isNull(ls_nro_parte) then ls_nro_parte = ''

this.object.nro_parte[al_row] = ls_nro_parte
this.object.item		[al_row] = ll_item

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

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

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_data2

choose case lower(as_columna)
	
	case "atributo"
		ls_sql = "SELECT A.ATRIBUTO AS COD_ATRIBUTO, " 	&
				  + "A.DESCRIPCION AS DESCRIPCION, "     	&
				  + "B.DESC_UNIDAD AS UNIDAD "			 	&
				  + "FROM TG_CALIDAD_ATRIBUTO A, "  		&
				  + "UNIDAD B "   								&
				  + "WHERE A.UND = B.UND (+) " 				&
	  				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '1')
		
		if ls_codigo <> '' then
			this.object.atributo					[al_row] = ls_codigo
			this.object.atributo_descripcion [al_row] = ls_data
			this.object.desc_unidad				[al_row] = ls_data2
			this.ii_update = 1
		end if

end choose

end event

type tabpage_2 from userobject within tab_detalles
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3214
integer height = 1224
long backcolor = 79741120
string text = "Observaciones y Acciones correctivas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom100!"
long picturemaskcolor = 536870912
string powertiptext = "Observaciones y Acciones Correctivas en Parte Diario de Descarga"
dw_obs dw_obs
end type

on tabpage_2.create
this.dw_obs=create dw_obs
this.Control[]={this.dw_obs}
end on

on tabpage_2.destroy
destroy(this.dw_obs)
end on

type dw_obs from u_dw_abc within tabpage_2
integer width = 3118
integer height = 864
integer taborder = 20
string dataobject = "d_ap_pd_descarga_obs_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_parte

if dw_1.GetRow() = 0 then return

ls_nro_parte = dw_1.object.nro_parte[dw_1.GetRow()]

this.object.nro_parte 		[al_row] = ls_nro_parte
this.object.nro_item			[al_row] = of_nro_item(this)

end event

type tabpage_3 from userobject within tab_detalles
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3214
integer height = 1224
long backcolor = 79741120
string text = "Firmas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom082!"
long picturemaskcolor = 536870912
string powertiptext = "Aprobación de Partes Diarios de Descarga"
dw_firmas dw_firmas
end type

on tabpage_3.create
this.dw_firmas=create dw_firmas
this.Control[]={this.dw_firmas}
end on

on tabpage_3.destroy
destroy(this.dw_firmas)
end on

type dw_firmas from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer width = 2597
integer taborder = 20
string dataobject = "d_ap_pd_descarga_firma_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_cargo"
		
		ls_sql = "SELECT cod_cargo AS CODIGO_cargo, " &
				  + "Desc_cargo AS descripcion_cargo " &
				  + "FROM cargo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_cargo	[al_row] = ls_codigo
			this.object.desc_cargo	[al_row] = ls_data
		end if
		
		this.ii_update = 1
		
end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)
end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cod_cargo"
		
		select desc_cargo
			into :ls_data
		from cargo
		where cod_cargo = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de cargo no existe", StopSign!)
			this.object.cod_cargo	[row] = ls_null
			this.object.desc_cargo	[row] = ls_null
			return 1
		end if

		this.object.desc_cargo[row] = ls_data
		
end choose

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

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

event ue_insert_pre;call super::ue_insert_pre;string ls_nom_user
string ls_nro_parte

if dw_1.GetRow() = 0 then return

ls_nro_parte = dw_1.object.nro_parte[dw_1.GetRow()]

select nombre
	into :ls_nom_user
from usuario
where cod_usr = :gs_user;

this.object.cod_usr 	[al_row] = gs_user
this.object.nombre	[al_row] = ls_nom_user
this.object.nro_parte[al_row] = ls_nro_parte
end event

type st_ori from statictext within w_ap307_pd_descarga
integer x = 37
integer y = 64
integer width = 192
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_gs_origen from singlelineedit within w_ap307_pd_descarga
integer x = 238
integer y = 64
integer width = 133
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ap307_pd_descarga
integer x = 425
integer y = 64
integer width = 210
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_buscar from commandbutton within w_ap307_pd_descarga
integer x = 1138
integer y = 28
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type sle_nro from u_sle_codigo within w_ap307_pd_descarga
integer x = 640
integer y = 64
integer width = 393
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_buscar.event clicked()
end event

type cb_3 from commandbutton within w_ap307_pd_descarga
integer x = 2075
integer y = 908
integer width = 608
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir CUS Grandes"
end type

event clicked;event ue_print_cus_grandes()
end event

type gb_1 from groupbox within w_ap307_pd_descarga
integer width = 1102
integer height = 148
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

