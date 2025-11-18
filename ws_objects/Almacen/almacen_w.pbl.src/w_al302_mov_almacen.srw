$PBExportHeader$w_al302_mov_almacen.srw
forward
global type w_al302_mov_almacen from w_abc
end type
type cb_3 from commandbutton within w_al302_mov_almacen
end type
type cb_2 from commandbutton within w_al302_mov_almacen
end type
type sle_nro from u_sle_codigo within w_al302_mov_almacen
end type
type em_saldo_und2 from singlelineedit within w_al302_mov_almacen
end type
type em_saldo from singlelineedit within w_al302_mov_almacen
end type
type em_prom_dol from singlelineedit within w_al302_mov_almacen
end type
type em_prom_sol from singlelineedit within w_al302_mov_almacen
end type
type st_4 from statictext within w_al302_mov_almacen
end type
type cb_1 from commandbutton within w_al302_mov_almacen
end type
type st_nro from statictext within w_al302_mov_almacen
end type
type st_3 from statictext within w_al302_mov_almacen
end type
type st_2 from statictext within w_al302_mov_almacen
end type
type st_1 from statictext within w_al302_mov_almacen
end type
type dw_detail from u_dw_abc within w_al302_mov_almacen
end type
type gb_1 from groupbox within w_al302_mov_almacen
end type
type cb_codigo_barra from commandbutton within w_al302_mov_almacen
end type
type dw_master from u_dw_abc within w_al302_mov_almacen
end type
end forward

global type w_al302_mov_almacen from w_abc
integer width = 4123
integer height = 2756
string title = "Movimiento de Almacen (AL302)"
string menuname = "m_mov_almacen"
boolean minbox = false
windowstate windowstate = maximized!
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
event ue_print_codigo_barras ( )
event ue_print_code_qr ( )
cb_3 cb_3
cb_2 cb_2
sle_nro sle_nro
em_saldo_und2 em_saldo_und2
em_saldo em_saldo
em_prom_dol em_prom_dol
em_prom_sol em_prom_sol
st_4 st_4
cb_1 cb_1
st_nro st_nro
st_3 st_3
st_2 st_2
st_1 st_1
dw_detail dw_detail
gb_1 gb_1
cb_codigo_barra cb_codigo_barra
dw_master dw_master
end type
global w_al302_mov_almacen w_al302_mov_almacen

type variables
// Tipos de movimiento
String 	is_soles, is_dolares, is_rep_merc_dev, is_cencos, &
			is_cnta_prsp,  is_salir = 'N', is_contab, is_doc_int, is_doc_ext, is_flag_und2, &
			is_solicita_ref, is_solicita_prov, is_clase_mov, is_doc_ov, &
			is_doc_otr, is_cntrl_lote_art, is_cntrl_lote_alm, &
			is_solicita_precio, is_oper_ing_oc, is_oper_ing_cdir, &
			is_oper_ing_prod, is_doc_oc, is_cencos_vta, is_cnta_prsp_vta, &
			is_oper_vnta_terc, is_oper_cons_interno, is_flag_matriz_contab, &
			is_doc_grmp, is_flag_Cnta_prsp, is_TIPO_MOV_DEV, is_flag_amp, &
			is_oper_sec, is_flag_cenbef, is_solicita_cenbef, is_mod_fecha, &
			is_FLAG_CNTRL_CTA_CTE

Int 			ii_cerrado 
DATETIME 	idt_fec_registro
Decimal 		in_tipo_cambio, idc_cant_proy, idc_cant_fact
Long 			il_dias_holgura, il_afecta_pto, il_factor_lote, il_fac_total, &
				il_fac_total_dev
Boolean 		ib_control_lin = TRUE, ib_mod = false

dataStore 				ids_print
n_cst_contabilidad	invo_cntbl
end variables

forward prototypes
public function integer of_set_costo_promedio (integer an_ano, integer an_mes, string as_almacen, string as_cod_art)
public function integer of_get_datos ()
public function integer of_get_param ()
public function integer of_get_datos_det ()
public function integer of_evalua_saldos (integer al_row)
public function integer of_set_status_doc (datawindow idw)
public function integer of_set_numera ()
public function integer of_tipo_mov (string as_tipo_mov)
public function integer of_evalua_saldos_und2 (integer al_row)
public subroutine of_saldos_articulo (long al_row)
public function integer of_verifica_pta_prsp (long al_row)
public function integer of_solicita_lote (string as_almacen, string as_cod_art)
public function integer of_evalua_lote ()
public function integer of_set_matriz ()
public subroutine of_duplica_mov_art (long al_row)
public subroutine of_mov_devol_alm (string as_tipo_mov)
public function integer of_referencia_ot (string as_tipo_mov)
public function integer of_flag_amp ()
public function integer of_evalua_mov (string as_accion)
public function integer of_cntrl_cnta_cnte ()
public subroutine of_retrieve (string as_nro)
public function integer of_set_articulo (string as_codigo_sku, string as_almacen)
public subroutine of_referencia_mov (string as_tipo_mov)
public subroutine of_salidas_mov (string as_tipo_mov)
end prototypes

event ue_anular;Integer 	j
Long 		ll_row, ll_count
String 	ls_tipo_ref, ls_nro_ref, ls_nro_vale, ls_origen_vale
Decimal	ldc_cant_fact

if is_action = 'new' or is_action='edit' or dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
	MessageBox('Aviso', 'No puede anular este movimiento de almacen, debe grabarlo primero', StopSign!)
	return
end if

IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No se puede anular este movimiento de almacen', StopSign!)
	return
end if

// Si el movimiento de Almacen tiene como referencia
// a una Guia de Recepcion de MP no lo debo anular
ls_tipo_ref 	= dw_master.object.tipo_refer 	[1]
ls_nro_ref 		= dw_master.object.nro_refer 		[1]

if ls_tipo_ref = is_doc_grmp then
	
	MessageBox('Aviso', 'No puede anular este movimiento, ya que esta amarrado a una Guia de Recepcion de MP')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
end if



if ls_tipo_ref = is_doc_oc then
	
	select sum(NVL(cant_facturada,0))
		into :ldc_cant_fact
	from articulo_mov_proy
	where tipo_doc 	= :ls_tipo_ref
	  and nro_doc  	= :ls_nro_ref
	  and flag_estado = '1'
	  and cod_art in (select distinct cod_art 
	  							from articulo_mov 
							  where cod_origen 	= :ls_origen_vale
							    and nro_Vale 		= :ls_nro_vale) ;
								 
	if ldc_cant_fact > 0 then
		MessageBox('Aviso', 'Imposible anular movimiento de almacen, ya ha sido facturado', StopSign!)
		return
	end if
end if

// Evaluo si el movimiento de almacen no ha sido generado a partir de otras 
// fuentes
if this.of_evalua_mov('anular') = 0 then
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
end if

// Lee detalle
of_retrieve(dw_master.object.nro_vale[1])

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1

// Anulando Detalle
for j = 1 to dw_detail.rowCount()	
	dw_detail.object.flag_estado		[j] = '0'
	dw_detail.object.cant_procesada	[j] = 0
	dw_detail.object.cant_proc_und2	[j] = 0
	dw_detail.object.precio_unit		[j] = 0
next

dw_detail.ii_update = 1
is_action = 'anu'
of_set_status_doc(dw_master)
end event

event ue_cancelar;// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_nro.text = ''
sle_nro.SetFocus()
idw_1 = dw_master

is_Action = ''
of_set_status_doc(dw_master)

end event

event ue_preview();// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen, ls_tipo_mov


try 
	
	if dw_master.GetRow() = 0 then return 
	
	if gnvo_app.almacen.is_despacho_POST_vta = '0' then
	
		if dw_master.rowcount() = 0 then return
		
		ls_tipo_almacen 	= dw_master.object.flag_tipo_almacen 	[1]
		ls_tipo_mov			= dw_master.object.tipo_mov 				[1]
		
		if ls_tipo_almacen = 'T' then
			//Corresponde a un almacen de Productos Terminados
			if gs_empresa = 'SEAFROST' then
				lstr_rep.dw1 		= 'd_frm_movimiento_almacen_seafrost_pptt'
			else
				lstr_rep.dw1 		= 'd_frm_movimiento_almacen_pptt'
			end if
		else
			if gs_empresa = 'SEAFROST' then
				lstr_rep.dw1 		= 'd_frm_movimiento_almacen_seafrost_tbl'
				
			elseif gs_empresa = 'CANTABRIA' or gnvo_app.of_get_parametro("MOV_ALMACEN_UBICACION", "0") = '1' THEN
				
				lstr_rep.dw1 		= 'd_frm_movimiento_alm_cantabria'
				
			elseif gnvo_app.of_get_parametro("ALMACEN_INGRESOS_COSTO", "0") = '1' &
				 or (gs_empresa = 'SUCESION' or gs_empresa = 'BOGACCI' or gs_empresa = 'MINKA' or gs_empresa = 'OPEN')  THEN
				 
				if left(ls_tipo_mov, 1) = 'I' then
					lstr_rep.dw1 		= 'd_frm_ingreso_almacen_costo_tbl'
				else
					lstr_rep.dw1 		= 'd_frm_movimiento_almacen'
				end if
			else
				lstr_rep.dw1 		= 'd_frm_movimiento_almacen'
			end if
		end if
		
		lstr_rep.titulo 	= 'Previo de Movimiento de almacen'
		lstr_rep.string1 	= dw_master.object.cod_origen	[dw_master.getrow()]
		lstr_rep.string2 	= dw_master.object.nro_vale	[dw_master.getrow()]
		lstr_rep.tipo		= '1S2S'
		
		OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	else
		gnvo_app.ventas.of_print_mov_almacen(dw_master.object.nro_vale	[1])
	end if



catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event ue_print_codigo_barras();// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.object.tipo_refer	[dw_master.getrow()] <> gnvo_app.is_doc_oc then
		MessageBox('Error', 'Este reporte solo se imprime con los ingresos por compra', StopSign!)
		return
	end if

	if dw_detail.rowcount() = 0 then 
		MessageBox('Error', 'Debe haber ingresado al menos un registro en el vale de ingreso', StopSign!)
		return
	end if
	
	if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
		MessageBox('Error', 'Debe guardar los cambios realizados antes de imprimir el codigo de barras, por favor verifique!', StopSign!)
		return
	end if
		
	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_codigos_barra_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos de Barra'
	lstr_rep.string1 	= dw_master.object.nro_refer	[dw_master.getrow()]
	lstr_rep.string2 	= gnvo_app.empresa.is_sigla
	lstr_rep.tipo		= '1'
	lstr_rep.dw_m		= dw_master
	lstr_rep.dw_d 		= dw_detail
		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event ue_print_code_qr();// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen

try 
	
	if dw_master.rowcount() = 0 then return
	
		
	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_codigoqr_grande_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos de Barra'
	lstr_rep.tipo		= '7'
	lstr_rep.dw_m		= dw_master
	lstr_rep.dw_d 		= dw_detail
		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

public function integer of_set_costo_promedio (integer an_ano, integer an_mes, string as_almacen, string as_cod_art);/*
     Procedimiento que encuentra los datos del ultimo mov. para actualizar 
     costo, ult_ingreso, etc, en la tabla articulo
*/
String ls_soles, ls_cod_moneda, ls_tipo_mov
Long ln_mes_ant, ln_mes_sig , ln_ano_ant, ln_ano_sig, ln_count
double ln_saldo, ln_prom_s, ln_prom_d, ln_sal, ln_ing, ln_cambio, &
   ln_cps, ln_cpd, ln_precio, ln_cant  

Declare c_mov Cursor FOR 
 Select am.cod_moneda, am.precio_unit, vm.tipo_mov, vm.fec_registro, am.cod_art, am.cant_procesada, 
    
    from vale_mov vm, articulo_mov am 
    where TO_NUMBER( TO_CHAR( vm.fec_registro, 'MM')) = :an_mes and
    TO_NUMBER( TO_CHAR( vm.fec_registro, 'YYYY')) = :an_ano and
    vm.cod_origen = am.cod_origen and vm.nro_vale = am.nro_vale and
    vm.almacen = :as_almacen and am.cod_art = :as_cod_art and
    vm.flag_estado <> 0;    

  Select cod_soles into :ls_soles from logparam where reckey = '1';

  // Inserta saldo anterior
  if an_mes = 1 then
     ln_mes_ant = 12
     ln_ano_ant = an_ano - 1 
  else
     ln_mes_ant = an_mes - 1
     ln_ano_ant = an_ano
  end if
  if an_mes = 12 then
     ln_mes_sig = 1;
     ln_ano_sig = an_ano + 1
  else
     ln_mes_sig = an_mes + 1
     ln_ano_sig = an_ano
  end if
        
    // Busco saldo anterior
    Select Count(t.sldo_total) into :ln_count from articulo_sdo_men t
      where ano = ln_ano_ant and mes = ln_mes_ant and
      almacen = as_almacen and cod_art = as_cod_art;
    if ln_count = 0 then
       ln_saldo  = 0;
       ln_prom_s = 0;
       ln_prom_d = 0;
    else
      Select t.sldo_total, precio_prom_sol, 
        precio_prom_dol into :ln_saldo, :ln_prom_s, :ln_prom_d 
        from articulo_sdo_men t
        where ano = ln_ano_ant and mes = ln_mes_ant and
        almacen = as_almacen and cod_art = as_cod_art;
    end if;
    ln_sal = 0
    ln_ing = 0
    
    //for rc_mov in c_mov loop    
	 Open c_mov;
	 DO WHILE SQLCA.sqlcode = 0
      FETCH c_mov INTO :ls_cod_moneda, :ln_precio, :ls_tipo_mov,
		  :ln_cant;
		if SQLCA.sqlcode < 0 then
		   MessageBox("Fetch Error",SQLCA.sqlerrtext)
		end if
      // Busca tipo de cambio
      Select count(vta_dol_prom) into :ln_count from calendario
        Where to_char(fecha,'DD/MM/YYYY') = TO_CHAR(rc_mov.fec_registro,'DD/MM/YYYY');
      if ln_count = 1 then        
        Select vta_dol_prom into :ln_cambio from calendario
          Where to_char(fecha,'DD/MM/YYYY') = TO_CHAR(rc_mov.fec_registro,'DD/MM/YYYY');
        if ln_cambio = 0 then
//           Raise_application_error( -20001, 'Defina el tipo de cambio del ' ||
//           TO_CHAR(rc_mov.fec_registro, 'DD/MM/YYYY'));
        end if;        
  
        // Costo promedio        
        if ls_cod_moneda = ls_soles then
           ln_cps = ln_precio
           ln_cpd = ln_precio / ln_cambio;
        else
           ln_cpd = ln_precio
           ln_cps = ln_precio * ln_cambio;
        end if;
        
        // Cantidades
        if LEFT( ls_tipo_mov,1) = 'I' then
           ln_ing  += ln_cant
           ln_saldo += ln_cant
        else
           ln_sal += ln_cant
           ln_saldo -= ln_cant
        end if
      else
//          Raise_application_error( -20002, 'No existe tipo de cambio para el ' ||
//           TO_CHAR(rc_mov.fec_registro,'DD/MM/YYYY'));
      end if;      
	loop
   Close c_mov;  
     // Actualiza tabla articulo, con nuevos datos
     Update articulo set costo_prom_sol = :ln_prom_s, 
        costo_prom_dol = :ln_prom_d where cod_art = :as_cod_art;     
     
     // Mes actual
     update articulo_sdo_men set 
        precio_prom_sol = :ln_prom_s, precio_prom_dol = :ln_prom_d        
        where cod_art = :as_cod_art and ano = :an_ano and mes = :an_mes and
        almacen = :as_almacen; 

RETURN 1
end function

public function integer of_get_datos ();// Verifica que los datos que son requeridos via flag, esten ingresados
// Evalua datos
String ls_tipo_mov, ls_prov, ls_doc_int, ls_doc_ext, ls_doc_ref, ls_cod_art, ls_almacen, &
 		 ls_consig
Long ll_row
Int j
Double ld_saldo
dwobject dwo_1


if is_action <> 'new' then return 1

ll_row = dw_master.getrow()
ls_tipo_mov = dw_master.object.tipo_mov[ll_row]

// Activa/desactiva boton de referencias segun tipo de movimiento
Select flag_solicita_prov, flag_solicita_doc_int, flag_solicita_doc_ext, flag_solicita_ref
   into :ls_prov, :ls_doc_int, :ls_doc_ext, :ls_doc_ref 
from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov;

if isnull(dw_master.object.almacen[dw_master.getrow()]) then
	Messagebox( "Atencion", "Ingrese el almacen")
	dw_master.setcolumn( "almacen")
	dw_master.setfocus()	
	return 0
end if

ls_almacen = dw_master.object.almacen[ll_row]

if isnull(dw_master.object.tipo_mov[ll_row]) then
	Messagebox( "Atencion", "Ingrese tipo movimiento")
	dw_master.setcolumn( "tipo_mov")
	dw_master.setfocus()
	return 0
end if

if ls_doc_ext = '1' then
	if isnull(dw_master.object.tipo_doc_ext[ll_row]) then
		messagebox( "Atencion", "Indicar tipo doc. externo")
		dw_master.Setcolumn("tipo_doc_ext")
		dw_master.setfocus()
		Return 0
	end if
	if isnull(dw_master.object.nro_doc_ext[ll_row]) then
		messagebox( "Atencion", "Indicar nro. doc. externo")
		dw_master.Setcolumn("nro_doc_ext")
		dw_master.setfocus()
		Return 0
	end if
end if

if ls_prov = '1' then
	if isnull(dw_master.object.proveedor[ll_row]) or TRIM( dw_master.object.proveedor[ll_row]) = '' then
		messagebox( "Atencion", "Indicar proveedor")
		dw_master.Setcolumn("proveedor")
		dw_master.setfocus()
		Return 0
	end if
end if

return 1
end function

public function integer of_get_param ();// Evalua parametros
Int li_ret = 1

// busca tipos de movimiento definidos
SELECT cod_soles, rep_merc_dev, cod_dolares, NVL(dias_holgura_mat,0),
		 doc_otr, oper_ing_oc, oper_ing_cdir, oper_ing_prod,
		 oper_vnta_terc, oper_cons_interno, flag_matriz_contab, 
		 doc_ov, NVL(flag_centro_benef, '0'), NVL(FLAG_MOD_FEC_VM, '0')
  INTO :is_soles, :is_rep_merc_dev, :is_dolares, :il_dias_holgura, 
		 :is_doc_otr, :is_oper_ing_oc, :is_oper_ing_cdir, :is_oper_ing_prod,
		 :is_oper_vnta_terc, :is_oper_cons_interno, :is_flag_matriz_contab, 
		 :is_doc_ov, :is_flag_cenbef, :is_mod_fecha
FROM logparam  
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return 0
end if

if sqlca.sqlcode < 0 then
	Messagebox( "Error en busqueda parametros", sqlca.sqlerrtext)
	return 0	
end if

// busca moneda soles
if ISNULL( is_soles) or TRIM( is_soles) = '' then
	Messagebox("Error de parametros", "Defina codigo moneda soles en logparam")
	return 0
end if

// busca moneda dolares
if ISNULL( is_dolares) or TRIM( is_dolares) = '' then
	Messagebox("Error de parametros", "Defina codigo moneda dólares en logparam")
	return 0
end if

if ISNULL( is_rep_merc_dev) or TRIM( is_rep_merc_dev) = '' then
	Messagebox("Error de parametros", "Defina codigo (rep_merc_dev) en logparam")
	return 0
end if

if ISNULL( is_doc_otr ) or TRIM( is_doc_otr ) = '' then
	Messagebox("Error de parametros", "Defina DOCUMENTO DE ORDEN DE TRASLADO en logparam")
	return 0
end if

if ISNULL( is_doc_ov ) or TRIM( is_doc_ov ) = '' then
	Messagebox("Error de parametros", "Defina DOCUMENTO DE ORDEN DE VENTA en logparam")
	return 0
end if

if ISNULL( is_oper_ing_oc ) or TRIM( is_oper_ing_oc ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION INGRESO X COMPRA (oper_ing_oc) en logparam")
	return 0
end if

if ISNULL( is_oper_ing_cdir ) or TRIM( is_oper_ing_cdir ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION INGRESO COMPRA DIRECTA en logparam")
	return 0
end if

if ISNULL( is_oper_ing_prod ) or TRIM( is_oper_ing_prod ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION INGRESO X PRODUCCION en logparam")
	return 0
end if

if ISNULL( is_oper_vnta_terc ) or TRIM( is_oper_vnta_terc ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION VENTA A TERCEROS en logparam")
	return 0
end if

if ISNULL( is_oper_cons_interno ) or TRIM( is_oper_cons_interno ) = '' then
	Messagebox("Error de parametros", "Defina OPERACION CONSUMO INTERNO en logparam")
	return 0
end if

if ISNULL( is_flag_matriz_contab ) or TRIM( is_flag_matriz_contab ) = '' then
	Messagebox("Error de parametros", "Defina FLAG_MATRIZ_CONTAB en logparam")
	return 0
end if

// Guia de recepcion de materia prima
is_doc_grmp = 'GRMP'

return 1

end function

public function integer of_get_datos_det ();/* Evalua presupuesto 

   Retorna : 0, fallo
				 1, Ok.
*/
int j
String 	ls_cencos, ls_cnta_prsp, ls_flag_cmp_directa, ls_FLAG_INGR_EGR, &
			ls_flag_estado
Long lpos, ll_row, ll_ano
Date ld_fecha

ll_row = dw_master.GetRow()
if ll_row = 0 then return 0

ld_fecha 	= DATE(dw_master.object.fec_registro[ll_row])
ll_ano 		= year(ld_fecha)

For j = 1 to dw_detail.RowCount()
	ls_cencos    = dw_detail.object.cencos[j]
	ls_cnta_prsp = dw_detail.object.cnta_prsp[j]
	
	if il_afecta_pto <> 0 then
		if isnull( ls_cencos ) or TRIM( ls_cencos ) = '' then
			Messagebox( "Atencion", "Ingresar el centro de costo", Exclamation!)
			dw_detail.SetColumn( "cencos")
			dw_detail.SetRow(j)
			f_select_current_row(dw_detail)
			dw_detail.setfocus()
			return 0
		end if
		
		if isnull( ls_cnta_prsp ) or TRIM( ls_cnta_prsp ) = '' then
			Messagebox( "Atencion", "Ingresar la cuenta presupuestal ", Exclamation!)
			dw_detail.SetColumn( "cnta_prsp")
			dw_detail.SetRow(j)
			f_select_current_row(dw_detail)
			dw_detail.setfocus()
			return 0
		end if
		
		select FLAG_CMP_DIRECTA, FLAG_INGR_EGR, flag_estado
			into :ls_FLAG_CMP_DIRECTA, :ls_FLAG_INGR_EGR, :ls_flag_estado
		from presupuesto_partida
		where ano = :ll_ano
		  and cencos = :ls_cencos
		  and cnta_prsp = :ls_cnta_prsp;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Partida Presupuestal no existe')
			dw_detail.SetColumn('cencos')
			dw_detail.SetRow(j)
			f_select_current_row(dw_detail)
			dw_detail.SetFocus()
			return 0
		end if
		
		if ls_flag_estado = '0' then
			MessageBox('Aviso', 'Partida presupuestal esta anulada')
			dw_detail.SetColumn('cencos')
			dw_detail.SetRow(j)
			f_select_current_row(dw_detail)
			dw_detail.SetFocus()
			return 0
		end if
		
		if ls_FLAG_INGR_EGR <> 'E' then
			MessageBox('Aviso', 'Partida presupuestal no es de egreso, verifique por favor')
			dw_detail.SetColumn('cencos')
			dw_detail.SetRow(j)
			f_select_current_row(dw_detail)
			dw_detail.SetFocus()
			return 0
		end if
		
		if ls_FLAG_CMP_DIRECTA <> '2' and ls_FLAG_CMP_DIRECTA <> '0' then
			MessageBox('Aviso', 'No se permite movimiento de salidas de almacen en '&
				+ 'esta partida presupuestal ' &
				+ '~r~nLa partida presupuestal es solo para compras directas sin ' &
				+ 'movimiento de almacen')
			dw_detail.SetColumn('cnta_prsp')
			dw_detail.SetRow(j)
			f_select_current_row(dw_detail)
			dw_detail.SetFocus()
			return 0
		end if
	end if

next
return 1
end function

public function integer of_evalua_saldos (integer al_row);String 	ls_tipo_mov, ls_cod_art, ls_almacen, ls_origen
Int 		li_sldo_total, li_sldo_llegar, li_sldo_sol
Long 		ln_nro_mov_proy, ll_nro_mov  
Decimal  ld_cant, ld_cant_dig, ld_saldo_act

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]
ls_almacen  = dw_master.object.almacen[dw_master.getrow()]

dw_detail.AcceptText()
Select 	factor_sldo_total, factor_sldo_x_llegar, factor_sldo_sol
	into 	:li_sldo_total, :li_sldo_llegar, :li_sldo_sol
from articulo_mov_tipo 
where tipo_mov = :ls_tipo_mov;


ls_cod_art   = dw_detail.object.cod_art			[al_row]
ld_cant_dig  = dw_detail.object.cant_procesada	[al_row]	
	
// Que cantidad no sea cero
if dw_detail.object.cant_procesada[al_row] = 0 then
	Messagebox( "Atencion", "Cantidad no puede ser cero")
	dw_detail.SetColumn( "Cant_procesada")
	dw_detail.setFocus()
	return 0
end if
	
// Salidas
IF li_sldo_total = -1 then			
	// Verifica saldos
	SELECT Nvl(sldo_total,0)
			INTO   :ld_saldo_act
	FROM   articulo_almacen
	WHERE  almacen = :ls_almacen 
	  AND cod_art = :ls_cod_Art; 
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El articulo no existe en almacen')
		return 0
	end if
	
	if ld_saldo_act = 0 then
		MessageBox('Aviso', 'El articulo no tiene saldo en almacen')
		return 0
	end if
	
	IF ld_cant_dig > ld_saldo_act THEN
		Messagebox('Aviso','Cantidad a Procesar No Puede Exceder al Saldo Actual~r~nSaldo Actual: ' + &
	 	String (ld_saldo_act,'#0.0000'), exclamation!)
		dw_detail.object.cant_procesada[al_row] = 0
		Return 0
	END IF		
End if

return 1
end function

public function integer of_set_status_doc (datawindow idw);Int li_estado
long ll_ref

this.changemenu( m_mov_almacen)

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

m_master.m_file.m_printer.m_print1.enabled 			= true

if dw_master.getrow() = 0 then return 0

if ii_cerrado = 0	then // cerrado contablemente
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	if idw_1 = dw_detail then		
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if	
	return 0
end if

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	if is_flag_insertar = '1' then
		m_master.m_file.m_basedatos.m_insertar.enabled = true
	else
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if	

	if idw_1 = dw_detail then
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if

		IF is_solicita_ref <> '0' and is_flag_amp <> '3' then			
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		else
			if is_flag_insertar = '1' then
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			else
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if
		end if
	end if
end if

if is_Action = 'open' then
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
	
	Choose case li_estado
		case 0 	// Anulado 
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled 	= false
			m_master.m_file.m_basedatos.m_anular.enabled 		= false	
			if idw_1 = dw_master then		
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			ELSE			
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if	
			RETURN 1
		CASE is > 1   // Atendido con guia de remision
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
			m_master.m_file.m_basedatos.m_modificar.enabled = false
			m_master.m_file.m_basedatos.m_anular.enabled = false
			if idw_1 = dw_master then		
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			ELSE
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if	
			RETURN 1
	end CHOOSE
end if

if idw_1 = dw_detail and (is_solicita_ref = '0' or is_flag_amp = '3') then	
	m_master.m_file.m_basedatos.m_insertar.enabled = true		
end if

if is_Action = 'anu' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if

return 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_vale_mov
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE NUM_VALE_MOV IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_vale_mov(origen, ult_nro)
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
	FROM num_vale_mov
	where origen = :gs_origen for update;
	
	update num_vale_mov
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_vale[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_vale[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_vale[ll_j] = ls_next_nro
next

return 1
end function

public function integer of_tipo_mov (string as_tipo_mov);/* 
  Funcion que activa/desactiva campos segun tipo de movimiento
*/

String 	ls_alm, ls_flag_estado, ls_mensaje
Long 		ll_row, ln_count,	ll_saldo_pres, ll_saldo_dev, ll_saldo_consig

ll_row = dw_master.getrow()
if ll_row = 0 then
	MessageBox('Aviso', 'No ha definido cabecera del documento', StopSign!)
	return 0
end if

//Actualizo el flag de estado en articulo_mov_proy
update articulo_mov_proy amp
   set amp.flag_estado = '3'
where amp.flag_estado = '1' 
  and amp.tipo_mov = 'S01'
  and amp.nro_aprob is null
  and amp.tipo_doc = :gnvo_app.is_doc_ot;
  
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox('Aviso', "Error al momento de actualizar el flag de estado de los articulos de la Orden de Trabajo. Mensaje: " + ls_mensaje, StopSign!)
	return 0
end if  

commit;

update articulo_mov_proy amp
   set amp.flag_estado = '1'
where amp.tipo_doc = :gnvo_app.is_doc_ot
  and amp.tipo_mov = 'I09'
  and amp.flag_estado = '3';
  
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox('Aviso', "Error al momento de actualizar el flag de estado de los articulos de la Orden de Trabajo. Mensaje: " + ls_mensaje, StopSign!)
	return 0
end if  

commit;

// Tipo de Almacen
ls_alm = dw_master.object.almacen[ll_row]

// Busca indicadores segun tipo de movimiento

Select NVL(flag_solicita_prov,'0'), 	NVL(flag_solicita_doc_int,'0'), 
	    Nvl(flag_solicita_doc_ext,'0'),	NVL(flag_solicita_ref,'0'), 
		 NVL(factor_presup,0), 				NVL(flag_contabiliza,'0'),  
		 NVL(factor_ctrl_templa,0), 		NVL(flag_clase_mov, ''),
		 NVL(flag_estado, '0'),				NVL(factor_sldo_consig, 0),
		 NVL(factor_sldo_dev,0),			NVL(factor_sldo_pres, 0),
		 NVL(factor_sldo_total,0),			NVL(flag_solicita_precio, '0'),
		 NVL(tipo_mov_dev, ''),				NVL(flag_amp, '0'),
		 NVL(FLAG_SOLICITA_CENBEF, '0'),	nvl(FLAG_CNTRL_CTA_CTE, '0')
	into 	:is_solicita_prov, 				:is_doc_int, 
			:is_doc_ext, 						:is_solicita_ref, 
		 	:il_afecta_pto, 					:is_contab, 
			:il_factor_lote, 					:is_clase_mov,
			:ls_flag_estado,					:ll_saldo_consig,
			:ll_saldo_dev,						:ll_saldo_pres,
			:il_fac_total,						:is_solicita_precio,
			:is_tipo_mov_dev,					:is_flag_amp,
			:is_solicita_cenbef,				:is_FLAG_CNTRL_CTA_CTE
from articulo_mov_tipo 
where tipo_mov = :as_tipo_mov
  and flag_estado = '1';	

if SQLCA.SQLCode = 100 then
	ls_mensaje = 'Tipo de Movimiento: ' + as_tipo_mov + ' no existe o no esta activo'
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje, StopSign!)
	return 0
end if

if SQLCA.SQLCode < 0 then
	ls_mensaje = 'Ha ocurrido un error al consultar el tipo de movimiento: ' + as_tipo_mov &
				  + '. Mensaje de Error: ' + SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje, StopSign!)
	return 0
end if

if ls_flag_estado = '0' then
	ROLLBACK;
	MessageBox('Aviso', 'Tipo de movimiento esta inactivo')
	return 0
end if

//Tengo que validar que no sea por consignacion, devolucion ni prestamo
if ll_saldo_consig <> 0 and is_action = 'new' then
	ROLLBACK;
	MessageBox('Aviso', 'No esta permitido movimientos de consignacion')
	return 0
end if

if ll_saldo_pres <> 0 and is_action = 'new' then
	ROLLBACK;
	MessageBox('Aviso', 'No esta permitido movimientos de prestamo')
	return 0
end if

if ll_saldo_dev <> 0 and is_action = 'new' then
	ROLLBACK;
	MessageBox('Aviso', 'No esta permitido movimientos de devolucion')
	return 0
end if

//si el flag_centro_benef de logparam esta en cero, entonces no vale
// el flag_solicita_cenbef de articulo_mov_tipo
if is_flag_cenbef = '0' then
	is_solicita_cenbef = '0'
end if

//Determino el si el tipo mov de devolucion no es el mismo que el ingresado
if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
	if is_tipo_mov_dev = as_tipo_mov then
		MessageBox('Aviso', 'Tipo de movimiento no puede ser devolucion de si mismo')
		return 0
	end if
	
	// Obtengo el factor sldo total del movimiento de devolucion
	select NVL(factor_sldo_total, 0)
		into :il_Fac_total_dev
	from articulo_mov_tipo
	where tipo_mov = :is_tipo_mov_dev
	  and flag_Estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Tipo de mov ' + is_tipo_mov_dev + ' no existe o no esta activo')
		return 0
	end if
	
	if il_fac_total_dev = 0 then
		MessageBox('Aviso', 'Tipo de mov ' + is_tipo_mov_dev + ' no tiene factor_sldo_total')
		return 0
	end if
	
	if il_fac_total_dev = il_fac_total then
		MessageBox('Aviso', 'Tipo de mov de devolucion' + is_tipo_mov_dev &
			+ ' tiene el mismo factor_sldo_total que el tipo_mov ' + as_tipo_mov)
		return 0
	end if

end if

//Flag Solicita Proveedor
if is_solicita_prov = '0' then
	dw_master.object.proveedor.background.color = RGB(192,192,192)   
	dw_master.object.proveedor.protect = 1
	dw_master.object.proveedor.edit.required = 'no'
else
	dw_master.object.proveedor.background.color = RGB(255,255,255)
	dw_master.object.proveedor.protect = 0
	dw_master.object.proveedor.edit.required = 'Yes'
end if		

// Flag Solicita Documento Interno
if is_doc_int = '0' then			
	dw_master.object.tipo_doc_int.background.color = RGB(192,192,192)
	dw_master.object.nro_doc_int.background.color = RGB(192,192,192)
	dw_master.object.tipo_doc_int.protect 	= 1
	dw_master.object.nro_doc_int.protect 	= 1
	dw_master.object.tipo_doc_int.edit.required = 'no'
	dw_master.object.nro_doc_int.edit.required = 'no'
else		
	dw_master.object.tipo_doc_int.background.color = RGB(255,255,255)
	dw_master.object.nro_doc_int.background.color = RGB(255,255,255)
	dw_master.object.tipo_doc_int.protect = 0
	dw_master.object.nro_doc_int.protect = 0
	dw_master.object.tipo_doc_int.edit.required = 'Yes'
	dw_master.object.tipo_doc_ext.edit.required = 'Yes'
end if

//Flag Solicita Doc Externo
if is_doc_ext = '0' then
	dw_master.object.tipo_doc_ext.background.color = RGB(192,192,192)
	dw_master.object.nro_doc_ext.background.color = RGB(192,192,192)
	dw_master.object.tipo_doc_ext.protect = 1
	dw_master.object.nro_doc_ext.protect = 1
	dw_master.object.tipo_doc_ext.edit.required = 'no'
	dw_master.object.nro_doc_ext.edit.required = 'no'
else
	dw_master.object.tipo_doc_ext.background.color = RGB(255,255,255)
	dw_master.object.nro_doc_ext.background.color = RGB(255,255,255)
	dw_master.object.tipo_doc_ext.protect = 0
	dw_master.object.nro_doc_ext.protect = 0
	dw_master.object.tipo_doc_ext.edit.required = 'Yes'
	dw_master.object.nro_doc_ext.edit.required = 'Yes'
end if

//Flag Solicita Centro de Beneficio
if is_solicita_cenbef = '1' or trim(as_tipo_mov) = trim(is_oper_cons_interno) then
	dw_detail.object.centro_benef.background.color = RGB(255,255,255)
	dw_detail.object.centro_benef.protect = 0
	dw_detail.object.centro_benef.Edit.required = 'Yes'
else	
	dw_detail.object.centro_benef.background.color = RGB(192,192,192)
	dw_detail.object.centro_benef.protect = 1
	dw_detail.object.centro_benef.Edit.required = 'no'
end if

// Activar o desactivar lo del precio unitario
if is_solicita_precio = '1' or as_tipo_mov = is_oper_ing_cdir &
	or as_tipo_mov = is_oper_ing_prod then

	dw_detail.object.precio_unit.background.color = RGB(255,255,255)
	dw_detail.object.precio_unit.protect = 0
	dw_detail.object.precio_unit.EditMask.required = 'Yes'
	dw_detail.object.precio_unit.EditMask.Mask = '###,###.000000'
	
else	
	
	dw_detail.object.precio_unit.background.color = RGB(192,192,192)
	dw_detail.object.precio_unit.protect = 1
	dw_detail.object.precio_unit.EditMask.required = 'no'
	
end if

if il_afecta_pto = 0 then  // no requerido
   // Si no lo pide el factor, evalua por el c.costo
	dw_detail.object.cencos.background.color = RGB(192,192,192)	
	dw_detail.object.cencos.protect = 1
	dw_detail.object.cencos.edit.required = 'no'
	dw_detail.object.cnta_prsp.background.color = RGB(192,192,192)			
	dw_detail.object.cnta_prsp.protect = 1
	dw_detail.object.cnta_prsp.edit.required = 'no'
else
	dw_detail.object.cencos.background.color = RGB(255,255,255)			
	dw_detail.object.cencos.protect = 0
	dw_detail.object.cencos.edit.required = 'yes'
	dw_detail.object.cnta_prsp.background.color = RGB(255,255,255)			
	dw_detail.object.cnta_prsp.protect = 0
	dw_detail.object.cnta_prsp.edit.required = 'yes'
end if

// evalua si contabiliza, osea que pida matriz contable
if is_contab = '1' then  // no requerido
	dw_detail.object.matriz.background.color = RGB(255,255,255)			
	dw_detail.object.matriz.protect = 0
	dw_detail.object.matriz.edit.required = 'yes'			
else		
	dw_detail.object.matriz.background.color = RGB(192,192,192)	
	dw_detail.object.matriz.protect = 1
	dw_detail.object.matriz.edit.required = 'no'
end if		

// Si es un movimiento de devolucion no puedo modificar el articulo
if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
	dw_detail.object.cod_art.background.color = RGB(192,192,192)
	dw_detail.object.cod_art.protect = 1
	dw_detail.object.cod_art.edit.required = 'Yes'
end if



//Si el documento es nuevo o se esta editando o se esta anulando
if is_action = 'new' or is_action = 'edit' or is_action = 'anu' then	
	
	// Valida si existe el tipo para el almacen
	Select count(tipo_mov) 
		into :ln_count 
	from almacen_tipo_mov
	where tipo_mov = :as_tipo_mov 
	  and almacen 	= :ls_alm;
	  
	if ln_count = 0 then
		Messagebox( "Atencion", "tipo de movimiento no existe para este almacen", exclamation!)		
		return 0
	end if	
	
	// Que valide si tipo de mov. tiene matriz definida, solo si se contabiliza
	if is_contab = '1' then
		if is_flag_matriz_contab = 'P' then
			Select count( tipo_mov) 
				into :ln_count 
			from tipo_mov_matriz
			Where tipo_mov = :as_tipo_mov;
			
		elseif is_flag_matriz_contab = 'S' then
			
			Select count( tipo_mov) 
				into :ln_count 
			from tipo_mov_matriz_subcat
			Where tipo_mov = :as_tipo_mov;
		else
			MessageBox('Aviso', 'No esta definido FLAG_MATRIZ_CONTAB en LOGPARAM')
			ln_count = 0
		end if
		
		if ln_count = 0 and IsNull(is_tipo_mov_dev) then
			Messagebox( "Atencion", "Tipo de movimiento no tiene matriz definida", StopSign!)
			return 0
		end if
	end if	  	
	
	//Devolucion a almacen
	if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
		of_mov_devol_alm(as_tipo_mov)
		return 1
	end if

	// Hay que tener cuidado si el Flag_AMP es 3 entonces debo escoger el oper_sec de
	// la OT y ya no tendria que escoger la referencia
	if is_flag_amp = '3' then
		return this.function dynamic of_referencia_OT(as_tipo_mov)
	end if
	
	// Verifico si pide referencia, si es ingreso x compras, 
	// salida x consumo interno, Salida x venta, Orden de Traslado
	// Guia de REcepcion de Materia Prima
	if is_solicita_ref <> '0' then	
		if is_clase_mov = '' or IsNull(is_clase_mov) then
			MessageBox('Aviso', 'No ha definido tipo de referencia para el tipo ' &
					+ 'de movimiento')
			return 0
		end if
		of_referencia_mov(as_tipo_mov)
	end if
	
	//Si es una salida entonces pregunto si deseas que muestre una lista con el stock actual
	if il_fac_total = -1 then
		if MessageBox('Aviso', 'Deseas que muestre una lista de los articulos que tienen Stock para este almacen?', Information!, YesNo!, 2) = 1 then 
			of_salidas_mov(as_tipo_mov)
		end if
	end if
	
	
	
end if
dw_master.setfocus()
return 1
end function

public function integer of_evalua_saldos_und2 (integer al_row);String 	ls_tipo_mov, ls_cod_art, ls_almacen, ls_origen, ls_flag_und2
Int 		li_sldo_total, li_sldo_llegar, li_sldo_sol
Long 		ln_nro_mov_proy, ll_nro_mov  
Decimal  ld_cant, ld_cant_dig, ld_saldo_act

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]
ls_almacen  = dw_master.object.almacen[dw_master.getrow()]

dw_detail.AcceptText()
Select 	factor_sldo_total, factor_sldo_x_llegar, factor_sldo_sol
	into 	:li_sldo_total, :li_sldo_llegar, :li_sldo_sol
from articulo_mov_tipo 
where tipo_mov = :ls_tipo_mov;


ls_cod_art   = dw_detail.object.cod_art			[al_row]
ld_cant_dig  = dw_detail.object.cant_proc_und2	[al_row]	
ls_flag_und2 = dw_detail.object.flag_und2			[al_row]	
	
// Que cantidad no sea cero
if dw_detail.object.cant_proc_und2[al_row] = 0 and ls_flag_und2 = '1' then
	Messagebox( "Atencion", "Cantidad de Und2 no puede ser cero")
	dw_detail.SetColumn( "cant_proc_und2")
	dw_detail.setFocus()
	return 0
end if
	
// Salidas
IF li_sldo_total = -1 then			
	// Verifica saldos
	SELECT Nvl(sldo_total_und2,0)
			INTO   :ld_saldo_act
	FROM   articulo_almacen
	WHERE  almacen = :ls_almacen 
	  AND cod_art = :ls_cod_Art; 
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El articulo no existe en almacen')
		return 0
	end if
	
	if ld_saldo_act = 0 then
		MessageBox('Aviso', 'El articulo no tiene saldo en almacen (und2)')
		return 0
	end if
	
	IF ld_cant_dig > ld_saldo_act THEN
		Messagebox('Aviso','Cantidad a Procesar de la Segunda Unidad No Puede Exceder al Saldo Actual' &
			+ '~r~nSaldo Actual (und2): ' + String (ld_saldo_act,'#0.0000'), exclamation!)
		dw_detail.object.cant_proc_und2[al_row] = 0
		Return 0
	END IF		
End if

return 1
end function

public subroutine of_saldos_articulo (long al_row);string 	ls_cod_art, ls_almacen
decimal 	ldc_saldo, ldc_prom_sol, ldc_prom_dol, &
			ldc_saldo_und2

if al_row = 0 then return
if dw_master.Getrow() = 0 then return

ls_cod_art = dw_detail.object.cod_art[al_row]
ls_almacen = dw_master.object.almacen[dw_master.GetRow()]

select Nvl(sldo_total,0), Nvl(sldo_total_und2,0), 
			costo_prom_sol, costo_prom_dol
	into  :ldc_saldo, :ldc_saldo_und2, 
			:ldc_prom_sol, :ldc_prom_dol
from articulo_almacen
where cod_art = :ls_cod_art
  and almacen = :ls_almacen;

if SQLCA.SQLCode = 100 then
	ldc_saldo 		= 0
	ldc_saldo_und2 = 0
	select costo_prom_sol, costo_prom_dol
	  into :ldc_prom_sol, :ldc_prom_dol
	from articulo
	where cod_art = :ls_cod_art;
	
	if SQLCA.SQLCode = 100 then
		ldc_prom_sol = 0
		ldc_prom_dol = 0
	end if
end if

em_saldo.text 	    = String( ldc_saldo, '###,##0.000' ) 
em_saldo_und2.text = String( ldc_saldo_und2, '###,##0.000' ) 
em_prom_sol.text 	 = String( ldc_prom_sol,'###,##0.000' )
em_prom_dol.text   = String( ldc_prom_dol,'###,##0.000' )	  


end subroutine

public function integer of_verifica_pta_prsp (long al_row);/* Evalua presupuesto 

   Retorna : 0, fallo
				 1, Ok.
*/
String 	ls_cencos, ls_cnta_prsp, ls_flag_cmp_directa, ls_FLAG_INGR_EGR, &
			ls_flag_estado
Long lpos, ll_row, ll_ano
Date ld_fecha

ll_row = dw_master.GetRow()
if ll_row = 0 then return 0

ld_fecha 	= DATE(dw_master.object.fec_registro[ll_row])
ll_ano 		= year(ld_fecha)

ls_cencos    = dw_detail.object.cencos		[al_row]
ls_cnta_prsp = dw_detail.object.cnta_prsp	[al_row]
	
if il_afecta_pto <> 0 then
	if isnull( ls_cencos ) or TRIM( ls_cencos ) = '' then
		return 0
	end if
	
	if isnull( ls_cnta_prsp ) or TRIM( ls_cnta_prsp ) = '' then
		return 0
	end if
		
	select FLAG_CMP_DIRECTA, FLAG_INGR_EGR, flag_estado
		into :ls_FLAG_CMP_DIRECTA, :ls_FLAG_INGR_EGR, :ls_flag_estado
	from presupuesto_partida
	where ano = :ll_ano
	  and cencos = :ls_cencos
	  and cnta_prsp = :ls_cnta_prsp;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Partida Presupuestal no existe')
		dw_detail.SetColumn('cencos')
		dw_detail.SetRow(al_row)
		f_select_current_row(dw_detail)
		dw_detail.SetFocus()
		return 0
	end if
	
	if ls_flag_estado = '0' then
		MessageBox('Aviso', 'Partida presupuestal esta anulada')
		dw_detail.SetColumn('cencos')
		dw_detail.SetRow(al_row)
		f_select_current_row(dw_detail)
		dw_detail.SetFocus()
		return 0
	end if
	
	if ls_FLAG_INGR_EGR <> 'E' then
		MessageBox('Aviso', 'Partida presupuestal no es de egreso, verifique por favor')
		dw_detail.SetColumn('cencos')
		dw_detail.SetRow(al_row)
		f_select_current_row(dw_detail)
		dw_detail.SetFocus()
		return 0
	end if
	
	if ls_FLAG_CMP_DIRECTA <> '2' and ls_FLAG_CMP_DIRECTA <> '0' then
		MessageBox('Aviso', 'No se permite movimiento de salidas de almacen en '&
			+ 'esta partida presupuestal ' &
			+ '~r~nLa partida presupuestal es solo para compras directas sin ' &
			+ 'movimiento de almacen')
		dw_detail.SetColumn('cnta_prsp')
		dw_detail.SetRow(al_row)
		f_select_current_row(dw_detail)
		dw_detail.SetFocus()
		return 0
	end if
end if

return 1
end function

public function integer of_solicita_lote (string as_almacen, string as_cod_art);Integer li_ok
string	ls_cntrl_lote_art, ls_cntrl_lote_alm

select NVL(flag_cntrl_lote, '0')
	into :ls_cntrl_lote_alm
from almacen
where almacen = :as_almacen;

select NVL(flag_cntrl_lote, '0')
	into :ls_cntrl_lote_art
from articulo
where cod_art = :as_cod_art;

if ls_cntrl_lote_art = '5' then
	return 1
elseif ls_cntrl_lote_art = '0' then
	return 0
elseif ls_cntrl_lote_art = '1' and ls_cntrl_lote_alm = '1' then
	return 1
elseif ls_cntrl_lote_art = '2' and ls_cntrl_lote_alm = '1' then
	return 1
elseif ls_cntrl_lote_art = '2' and ls_cntrl_lote_alm = '2' then
	return 1
end if	  
return 0
	

end function

public function integer of_evalua_lote ();Long 		ll_i
string 	ls_almacen, ls_cod_art, ls_nro_lote

if dw_master.GetRow() = 0 then return 0

ls_almacen = dw_master.object.almacen[dw_master.GetRow()]
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'No ha definido almacen')
	dw_master.SetColumn('almacen')
	dw_master.SetFocus()
	return 0
end if

for ll_i = 1 to dw_detail.RowCount() 
	ls_cod_art 	= dw_detail.object.cod_art 	[ll_i]
	ls_nro_lote	= dw_detail.object.nro_lote	[ll_i]
	
	if ls_cod_art = '' or IsNull(ls_cod_art) then 
		MessageBox('Aviso', 'Codigo de Articulo esta en blanco')
		dw_detail.SetRow(ll_i)
		dw_detail.SetColumn('cod_art')
		dw_detail.SetFocus()
		return 0
	end if
	
	if of_solicita_lote(ls_almacen, ls_cod_art) = 1 then
		if ls_nro_lote = '' or IsNull(ls_nro_lote) then
			MessageBox('Aviso', 'Es obligatorio ingresar un nro de lote en este registro')
			dw_detail.SetRow(ll_i)
			dw_detail.SetColumn('cod_art')
			dw_detail.SetFocus()

			return 0
		end if
	end if
	
next

return 1
end function

public function integer of_set_matriz ();string 	ls_tipo_mov, ls_cod_art, ls_cencos, ls_cnta_prsp, ls_null, ls_matriz
Long 		ll_Row

SetNull(ls_null)

if dw_master.GetRow() = 0 then return 0
ls_tipo_mov = dw_master.object.tipo_mov [dw_master.GetRow()]

if dw_detail.GetRow() = 0 then return 0
ll_row = dw_detail.GetRow()

ls_cod_art 		= dw_detail.object.cod_art 	[ll_row]
ls_cencos  		= dw_detail.object.cencos  	[ll_row]
ls_cnta_prsp 	= dw_detail.object.cnta_prsp 	[ll_row]
				
if is_flag_matriz_contab = 'P' then
	if IsNull(ls_cencos) or trim(ls_cencos) = '' then return 0
	if IsNull(ls_cnta_prsp) or trim(ls_cnta_prsp) = '' then return 0
	if IsNull(ls_tipo_mov) or trim(ls_cnta_prsp) = '' then return 0
					
	ls_matriz = f_asigna_matriz(TRIM(ls_tipo_mov), ls_cencos, ls_cnta_prsp)
	dw_detail.object.matriz[ll_row] = ls_matriz
	if IsNull(ls_matriz) then 
		return 0
	else
		return 1
	end if
					
elseif is_flag_matriz_contab = 'S' then
	if IsNull(ls_cencos) or trim(ls_cencos) = '' then return 0
	if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then return 0
	if IsNull(ls_tipo_mov) or trim(ls_cnta_prsp) = '' then return 0
					
	ls_matriz = f_asigna_matriz_subcat(TRIM(ls_tipo_mov), ls_cencos, ls_cod_art)
	dw_detail.object.matriz[ll_row] = ls_matriz
	if IsNull(ls_matriz) then 
		return 0
	else
		return 1
	end if
else
	MessageBox('Error', "Valor de FLAG_MATRIZ_CONTAB incorrecto")
	dw_detail.object.matriz[ll_row] = ls_null
	return 0
end if
				
if isnull( ls_matriz) or ls_matriz = '' then
	Messagebox( "Atencion", "No existe matriz para este registro")	
	dw_detail.object.matriz[ll_row] = ls_null
	return 0
end if

return 1
end function

public subroutine of_duplica_mov_art (long al_row);Long ll_Row

if al_row = 0 then return

if IsNull(dw_Detail.object.cod_Art[al_row]) then return
if trim(dw_Detail.object.cod_Art[al_row]) = '' then return

ll_row = dw_detail.event ue_insert()

if ll_Row > 0 then
	dw_detail.object.cod_origen		[ll_row] = dw_detail.object.cod_origen			[al_row]
	dw_detail.object.nro_vale			[ll_row] = dw_detail.object.nro_vale			[al_row]
	dw_detail.object.nro_mov			[ll_row] = dw_detail.object.nro_mov				[al_row]
	dw_detail.object.origen_mov_proy	[ll_row] = dw_detail.object.origen_mov_proy	[al_row]
	dw_detail.object.nro_mov_proy		[ll_row] = dw_detail.object.nro_mov_proy		[al_row]
	dw_detail.object.flag_estado		[ll_row] = dw_detail.object.flag_estado		[al_row]
	dw_detail.object.cod_Art			[ll_row] = dw_detail.object.cod_art				[al_row]
	dw_detail.object.desc_art			[ll_row] = dw_detail.object.desc_art			[al_row]
	dw_detail.object.und					[ll_row] = dw_detail.object.und					[al_row]
	dw_detail.object.und2				[ll_row] = dw_detail.object.und2					[al_row]	
	dw_detail.object.cant_procesada	[ll_row] = dw_detail.object.cant_procesada	[al_row]	
	dw_detail.object.precio_unit		[ll_row] = dw_detail.object.precio_unit		[al_row]	
	dw_detail.object.decuento			[ll_row] = dw_detail.object.decuento			[al_row]	
	dw_detail.object.impuesto			[ll_row] = dw_detail.object.impuesto			[al_row]	
	dw_detail.object.cod_moneda		[ll_row] = is_soles
	dw_detail.object.flag_und2			[ll_row] = dw_detail.object.flag_und2			[al_row]	
	dw_detail.object.factor_conv_und	[ll_row] = dw_detail.object.factor_conv_und	[al_row]	
	dw_detail.object.flag_cntrl_lote	[ll_row] = dw_detail.object.flag_cntrl_lote	[al_row]		
	dw_detail.object.cencos				[ll_row] = dw_detail.object.cencos				[al_row]		
	dw_detail.object.cnta_prsp			[ll_row] = dw_detail.object.cnta_prsp			[al_row]		
	dw_detail.object.cod_maquina		[ll_row] = dw_detail.object.cod_maquina		[al_row]			
	dw_detail.object.peso_neto			[ll_row] = dw_detail.object.peso_neto			[al_row]			
	dw_detail.object.oper_sec			[ll_row] = dw_detail.object.oper_sec			[al_row]				
	dw_detail.object.vale_trans		[ll_row] = dw_detail.object.vale_trans			[al_row]			
	dw_detail.object.item_trans		[ll_row] = dw_detail.object.item_trans			[al_row]				
	dw_detail.object.nro_reservacion	[ll_row] = dw_detail.object.nro_reservacion	[al_row]			
	dw_detail.object.item_reservacion[ll_row] = dw_detail.object.item_reservacion	[al_row]				
	dw_detail.object.flag_replicacion[ll_Row] = '1'
	
	dw_detail.ii_update = 1
end if
end subroutine

public subroutine of_mov_devol_alm (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String 	ls_almacen, ls_tipo_doc, ls_nro_doc, ls_nro_vale
Date 		ld_fecha1, ld_fecha2
Long		ll_row_mas
str_parametros lstr_param

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return

//Obtengo información de la cabecera
ls_almacen 	= dw_master.object.almacen 		[ll_row_mas]	
ls_nro_vale	= dw_master.object.nro_doc_int 	[ll_row_mas]	

//Valido código de almacen
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN
END IF

if IsNull(ls_nro_vale) or trim(ls_nro_vale) = '' then
	//Primero obtengo el rango de fechas de los movimientos de almacen
	Open(w_get_rango_Fechas)
	
	if IsNull(Message.PowerObjectParm) or &
		not IsValid(Message.PowerObjectParm) then return
		
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
else
	lstr_param.string1 = ls_nro_vale
end if

	
//Ahora le agrego el tipo de movimiento y el almacen
lstr_param.tipo_mov_dev	= is_tipo_mov_dev
lstr_param.tipo	  	= 'DEVOL_ALM'
lstr_param.dw_or_m 	= dw_master
lstr_param.dw_or_d   = dw_detail	
lstr_param.w1			= this
lstr_param.titulo    = 'Movimientos de Almacen'
lstr_param.dw_master = 'd_abc_vale_mov_devol_tbl'      
lstr_param.dw1       = 'd_abc_articulo_mov_devol_tbl'  
lstr_param.opcion    = 6
	
OpenWithParm( w_abc_seleccion_md, lstr_param)


if Not IsValid(Message.Powerobjectparm) or IsNull(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectparm
if lstr_param.titulo = 'n' then return

end subroutine

public function integer of_referencia_ot (string as_tipo_mov);/*
   Funcion que selecciona el oper_sec de la OT siempre y cuando el 
	flag_amp = '3'
*/

String 	ls_almacen, ls_tipo_doc, ls_nro_doc
Date 		ld_fecha
Long		ll_row_mas
str_parametros lstr_param, lstr_datos

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return 0

ls_almacen 	 = dw_master.object.almacen [ll_row_mas]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN 0
END IF

// SI existe detalle y ya tiene seleccionado un documento
// Entonces lo selecciono
ls_tipo_doc = 'OT'

if NOT IsNull(dw_master.object.nro_refer[ll_row_mas]) and &
	trim(dw_master.object.nro_refer[ll_row_mas]) <> '' and &
	dw_detail.RowCount() <> 0 then 
	
	ls_nro_doc = dw_master.object.nro_refer[ll_row_mas]
else
	ls_nro_doc = ''
end if

// Verifico que la referencia sea solamente de Ingreso x Produccion (P)

if trim(as_tipo_mov) <> trim(is_oper_ing_prod) then
	MessageBox('Aviso', 'El tipo de movimiento debe ser de Ingreso x Produccion ' &
		+ as_tipo_mov + ' - ' + is_oper_ing_prod)
	return 0
end if

lstr_param.tipo		= ''
lstr_param.dw_or_m	= dw_master
lstr_param.dw_or_d   = dw_detail	
lstr_param.w1			= this

// Si ya he seleccionado un documento entonces simplemente 
// obvio este paso
if ls_tipo_doc = '' or ls_nro_doc = '' then
	
	lstr_param.tipo_doc	= ls_tipo_doc
	lstr_param.nro_doc	= ls_nro_doc
		
	OpenWithParm(w_get_tipo_doc_oper_sec , lstr_param )
	
	if IsNull(Message.PowerObjectParm) or &
		not IsValid(Message.PowerObjectParm) then return 0
	
	lstr_datos = Message.PowerObjectParm
	if lstr_datos.titulo = 'n' then return 0
	ls_nro_doc  = lstr_datos.nro_doc
		
	dw_master.object.nro_refer		[ll_row_mas] = ls_nro_doc
	dw_master.object.tipo_refer	[ll_row_mas] = ls_tipo_doc
	dw_master.object.origen_refer	[ll_row_mas] = left(ls_nro_doc, 2)
end if
	
// Si es ingreso por Producción
lstr_param.titulo    = 'Seleccione Orden Trabajo'
lstr_param.dw_master = 'd_lista_ot_flag_amp_grd'
lstr_param.dw1       = 'd_lista_oper_x_orden_grd'  
lstr_param.tipo		 = '1S'
lstr_param.opcion    = 7
lstr_param.tipo_doc	 = ls_tipo_doc
lstr_param.nro_doc	 = ls_nro_doc
lstr_param.string1	 = ls_nro_doc

OpenWithParm( w_abc_seleccion_md, lstr_param)

if IsNull(Message.PowerObjectParm) or &
	not IsValid(Message.PowerObjectParm) then return 0

lstr_datos = Message.PowerObjectParm
if lstr_datos.titulo = 'n' then return 0
is_oper_sec  = lstr_datos.string1

return 1
	

end function

public function integer of_flag_amp ();Long		ll_RowCount, ll_i, ll_row, ll_nro_mov_proy
String	ls_origen, ls_cod_art, ls_tipo_doc, ls_nro_doc, &
			ls_cencos, ls_cnta_prsp, ls_oper_sec, ls_almacen, &
			ls_cod_usr, ls_mensaje
DateTime	ldt_fec_registro
Decimal	ldc_cant_procesada, ldc_precio_unit

if is_flag_amp <> '3' then return 1

if dw_detail.RowCount() = 0 then
	MessageBox('Aviso', 'Movimiento de almacen no tiene detalle')
end if

if dw_master.GetRow() = 0 then
	MessageBox('Aviso', 'Movimiento de almacen no tiene cabecera')
end if

//Obtengo los detalles de la cabecera
ll_row = dw_master.GetRow()

ls_origen 	= dw_master.object.origen_refer	[ll_row]
ls_tipo_doc = dw_master.object.tipo_refer		[ll_row]
ls_nro_doc 	= dw_master.object.nro_refer		[ll_row]
ldt_fec_registro = DateTime(dw_master.object.fec_registro[ll_row])
ls_almacen	= dw_master.object.almacen			[ll_row]
ls_cod_usr	= dw_master.object.cod_usr			[ll_row]

//Ahora recorro el detalle
ll_RowCount = dw_detail.RowCount()

for ll_i = 1 to ll_RowCount
	If IsNull(dw_detail.object.nro_mov_proy [ll_i]) then
		
		ls_cod_art 				= dw_detail.object.cod_art[ll_i]
		ldc_cant_procesada 	= Dec(dw_detail.object.cant_procesada [ll_i])
		ldc_precio_unit	 	= Dec(dw_detail.object.precio_unit [ll_i])
		ls_cencos				= dw_detail.object.cencos		[ll_i]
		ls_cnta_prsp			= dw_detail.object.cnta_prsp	[ll_i]
		ls_oper_sec				= dw_detail.object.oper_sec	[ll_i]
		
		
		//create or replace procedure USP_ALM_FLAG_AMP3(
		//       asi_cod_origen       in origen.cod_origen%TYPE,
		//       asi_cod_art          in articulo.cod_art%TYPE,
		//       asi_tipo_doc         in articulo_mov_proy.tipo_doc%TYPE,
		//       asi_nro_doc          in articulo_mov_proy.nro_doc%TYPE,
		//       adi_fec_registro     in articulo_mov_proy.fec_registro%TYPE,
		//       ani_cant_procesada   in articulo_mov_proy.cant_procesada%TYPE,
		//       ani_precio_unit      in articulo_mov_proy.precio_unit%TYPE,
		//       asi_cencos           in centros_costo.cencos%TYPE,
		//       asi_cnta_prsp        in presupuesto_cuenta.cnta_prsp%TYPE,
		//       asi_oper_sec         in operaciones.oper_sec%TYPE,
		//       asi_almacen          in almacen.almacen%TYPE,
		//       asi_cod_usr          in usuario.cod_usr%TYPE,
		//       ano_nro_mov_proy     out articulo_mov_proy.nro_mov%TYPE          
		//) is
		//
		
		DECLARE USP_ALM_FLAG_AMP3 PROCEDURE FOR
			USP_ALM_FLAG_AMP3( :ls_origen,
									 :ls_cod_art,
									 :ls_tipo_doc,
									 :ls_nro_doc,
									 :ldt_fec_registro,
									 :ldc_cant_procesada,
									 :ldc_precio_unit,
									 :ls_cencos,
									 :ls_cnta_prsp,
									 :ls_oper_sec,
									 :ls_almacen,
									 :ls_cod_usr );

		EXECUTE USP_ALM_FLAG_AMP3;

		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE USP_ALM_FLAG_AMP3: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			SetPointer (Arrow!)
			return 0
		END IF
		
		FETCH USP_ALM_FLAG_AMP3 into :ll_nro_mov_proy;

		CLOSE USP_ALM_FLAG_AMP3;
		
		dw_detail.object.origen_mov_proy [ll_i] = ls_origen
		dw_detail.object.nro_mov_proy		[ll_i] = ll_nro_mov_proy
		dw_detail.ii_update = 1
		
	end if
next

return 1
end function

public function integer of_evalua_mov (string as_accion);string 	ls_nro_vale, ls_nro_guia, ls_tipo_doc, ls_nro_doc, ls_mensaje
long		ll_count

ls_nro_vale 	= dw_master.object.nro_vale 	[1]

if ls_nro_vale = '' or IsNull(ls_nro_vale) then
	MessageBox('Aviso', 'El nro de vale no esta definido o esta en blanco, verifique ')
	return 0
end if

//Verificando que el Vale de Almacen no pertenezca a consignacion
select count(*)
	into :ll_count
from articulo_consignacion
where (NRO_VALE_ING = :ls_nro_vale or VAL_NRO_VALE = :ls_nro_vale)
  and flag_estado <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'No puede ' + as_accion + ' este vale de almacen porque ha sido generado ' &
			 	+ 'desde la consignacion', Exclamation!)
	return 0
end if

// Verificando que el Vale de Almacen no pertenezca a Devoluciones ni
// prestamos
select count(*)
	into :ll_count
from art_devol_prestamo
where NRO_VALE 	= :ls_nro_vale
  and flag_estado <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'No puede ' + as_accion + ' este vale de almacen porque ha sido generado ' &
			 	+ 'desde Devolucion/Prestamo', Exclamation!)
	return 0
end if

//Verificando que el Vale de Almacen no haya sido generado por el módulo de Balanza

select count(*)
	into :ll_count
from 	salida_pesada 	sp,
		articulo_mov	am
where sp.org_am = am.cod_origen
  and sp.nro_am = am.nro_mov
  and am.nro_vale = :ls_nro_vale;


if ll_count > 0 then
	MessageBox('Aviso', 'No puede ' + as_accion + ' este vale de almacen porque ha sido generado ' &
			 	+ 'desde el MÓDULO DE BALANZA, para modificarlo vaya a la opcion correspondiente' &
				+ ' y modifícalo desde ahi', Exclamation!)
	return 0
end if

// Ahora verifico que el mov de almacen no haya sido generado por 
// Gastos Directos de Bahia Flota
select count(*)
	into :ll_count
from articulo_mov am,
     fl_gtos_drcts_bahia_det a
where ((am.cod_origen = a.org_am_ing and am.nro_mov = a.nro_am_ing) 
   or (am.cod_origen = a.org_am_sal and am.nro_mov = a.nro_am_sal))
   and am.flag_estado <> '0'
	and am.nro_vale = :ls_nro_vale;

if ll_count > 0 then
	MessageBox('Aviso', 'No puede ' + as_accion + ' este vale de almacen porque ha sido generado ' &
			 	+ 'desde FLOTA (GASTOS DIRECTOS DE BAHIA)', Exclamation!)
	return 0
end if

// Ahora verifico que el vale no este en una guia
select count(*)
	into :ll_count
from guia_vale gv
where gv.nro_vale = :ls_nro_vale;

if ll_count > 0 then
	select pkg_fact_electronica.of_get_full_nro(gv.nro_guia)
	  into :ls_nro_guia
	from guia_vale gv
	where gv.nro_vale = :ls_nro_vale;

	MessageBox('Aviso', 'No puede ' + as_accion + ' el vale de almacen ' + ls_nro_vale + ' porque ' &
							+ 'ha sido enlazado a la GUIA DE REMISIÓN ' + ls_nro_guia, Exclamation!)
	return 0
end if 

// Ahora verifico que el vale no este en una guia
select count(*)
	into :ll_count
from guia_vale gv
where gv.nro_vale = :ls_nro_vale;

if ll_count > 0 then
	select pkg_fact_electronica.of_get_full_nro(gv.nro_guia)
	  into :ls_nro_guia
	from guia_vale gv
	where gv.nro_vale = :ls_nro_vale;

	MessageBox('Aviso', 'No puede ' + as_accion + ' el vale de almacen ' + ls_nro_vale + ' porque ' &
							+ 'ha sido enlazado a la GUIA DE REMISIÓN ' + ls_nro_guia, Exclamation!)
	return 0
end if 


// Ahora verifico que el vale no este en una guia
select distinct
		 ccd.tipo_doc, pkg_fact_electronica.of_get_full_nro(ccd.nro_doc)
	into :ls_tipo_doc, :ls_nro_doc
  from cntas_cobrar_det ccd,
  		 cntas_cobrar		cc,
       articulo_mov     am
 where cc.tipo_doc		= ccd.tipo_doc
   and cc.nro_doc			= ccd.nro_doc
   and ccd.org_am 		= am.cod_origen
   and ccd.nro_am 		= am.nro_mov
   and am.nro_vale 		= :ls_nro_vale
	and cc.flag_estado 	<> '0'
	and rownum				= 1;

if SQLCA.SQLCOde < 0 then
	ls_mensaje = SQLCA.SQLErrTExt
	ROLLBACK;
	MessageBox('Error', 'Error en consulta de tablas CNTAS_COBRAR_DET. Mensaje: ' + ls_mensaje, StopSign!)
	return 0
end if 

if SQLCA.SQLCode <> 100 then
	MessageBox('Aviso', 'No puede ' + as_accion + ' el vale de almacen ' + ls_nro_vale + ' porque ' &
							+ 'ha sido enlazado al COMPROBANTE DE PAGO' + trim(ls_tipo_doc) + '/' + ls_nro_doc, &
							StopSign!)
	return 0
end if 


	
return 1
end function

public function integer of_cntrl_cnta_cnte ();string 	ls_mensaje, ls_cliente, ls_almacen, ls_cod_art
Decimal	ldc_monto, ldc_porc_vta, ldc_cant_proc, &
			ldc_precio, ldc_valor_venta, ldc_importe
DateTime	ldt_fecha
Long		ll_i

//Si el flag de control esta apagado entonces no proceso nada
if is_FLAG_CNTRL_CTA_CTE = '0' then return 1

//Si no existe cabecera entonces hay un error
if dw_master.GetRow() = 0 then return 0

ls_cliente 	= dw_master.object.proveedor		[dw_master.GetRow()]
ls_almacen 	= dw_master.object.almacen			[dw_master.GetRow()]
ldt_fecha 	= dw_master.object.fec_registro	[dw_master.GetRow()]

if ISNull(ls_cliente) or ls_cliente = '' then
	MessageBox('Aviso', 'Debe especificar un código de cliente')
	return 0
end if

ldc_monto = 0;
for ll_i = 1 to dw_detail.RowCount( )
	ldc_cant_proc 	= Dec(dw_detail.object.cant_procesada[ll_i])
	ldc_precio 		= Dec(dw_detail.object.precio_unit[ll_i])
	ls_cod_art		= dw_detail.object.cod_art[ll_i]
	
	// Ahora obtengo el porcentaje de venta
	SELECT NVL(PORC_VENTA,0), NVL(VALOR_VENTA,0)
	  into :ldc_porc_vta, :ldc_valor_venta
	  from articulo_almacen
	 where cod_art = :ls_cod_art
	   and almacen = :ls_almacen;
	
	if IsNull(ldc_porc_vta) then ldc_porc_vta = 0
	if IsNull(ldc_valor_venta) then ldc_valor_venta = 0
	
	// Una vez que obtengo el porcentaje de venta le añado ese porcentaje a 
	if ldc_valor_venta = 0 then
		ldc_importe = (1 + ldc_porc_vta/100) * ldc_precio*ldc_cant_proc
	else
		ldc_importe = ldc_valor_venta * ldc_cant_proc
		// El valor venta siempre esta en dolares, 
		// debo pasarlo a soles antes de sumarlo
		select usf_fl_conv_mon(:ldc_importe, :is_dolares, :is_soles, :ldt_fecha)
		  into :ldc_importe
		  from dual;
	end if
	
	ldc_monto += ldc_importe
next

//create or replace procedure USP_ALM_VERIF_CTA_CTE_CXC(
//       asi_cliente          IN proveedor.proveedor%TYPE,
//       ani_monto            IN NUMBER,
//       asi_moneda           IN moneda.cod_moneda%TYPE,
//       adi_fecha            IN DATE
//) IS

DECLARE 	USP_ALM_VERIF_CTA_CTE_CXC PROCEDURE FOR
			USP_ALM_VERIF_CTA_CTE_CXC( :ls_cliente,
												:ldc_monto,
												:is_soles,
												:ldt_fecha );

EXECUTE 	USP_ALM_VERIF_CTA_CTE_CXC;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_VERIF_CTA_CTE_CXC: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_ALM_VERIF_CTA_CTE_CXC;

return 1
end function

public subroutine of_retrieve (string as_nro);Long 	ll_row, ll_count
date	ld_fecha

//Valido si el nro de vale no es AJUSTE VALORIZACION

select count(*)
	into :ll_count
from vale_mov vm,
     articulo_mov_tipo amt
where vm.tipo_mov = amt.tipo_mov
  and vm.nro_vale = :as_nro
  and amt.flag_ajuste_valorizacion = '1';
  
if ll_count > 0 then
	MessageBox('Error', 'El nro de Vale ' + as_nro + ' es de tipo de AJUSTE_VALORIZACION, por lo que no se puede abrir por esta ventana', StopSign!)
	return
end if
  

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	ld_fecha = DATE(dw_master.object.fec_registro[ll_row])
	dw_master.Object.p_logo.filename = gs_logo
	
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro)
	
	// Busca si esta cerrado contablemente	
	ii_cerrado = invo_cntbl.of_cierre_almacen(ld_fecha)
	
	if ii_cerrado = -1 then ii_cerrado = 0
	
	if ii_cerrado = 0 then
		dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
	else
		dw_master.object.t_cierre.text = ''
	end if 
	
	// Activa/desactiva campos segun caso
	of_tipo_mov(dw_master.object.tipo_mov[ll_row]) // Evalua datos segun tipo de mov.	
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.ii_update	= 0
	dw_detail.of_protect()
	dw_detail.ResetUpdate()
	
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	of_set_status_doc( dw_master )
end if

return 
end subroutine

public function integer of_set_articulo (string as_codigo_sku, string as_almacen);String 	ls_unidad, ls_desc_art, ls_und, ls_tipo_mov, ls_flag_und2, &
			ls_msg, ls_und2, ls_tipo_mon, ls_cnta_prsp_vta, ls_almacen, ls_cod_art
Decimal 	ldc_prom_sol, ldc_saldo_total = 0, ldc_saldo_total_und2, &
			ldc_fac_conv, ldc_tipo_cambio, ldc_costo_prod, ldc_prom_dol
Integer	li_fac_total
Long 		ll_row

if dw_master.GetRow() = 0 then 
	MessageBox('Aviso', 'No exiet cabecera de movimiento de almacen')
	return 0
end if

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.GetRow()]
ls_almacen = dw_master.object.almacen[dw_master.GetRow()]

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento esta en blanco')
	return 0
end if

// Verifica que codigo ingresado exista			
Select 	cod_art, desc_art, und, Nvl(flag_und2,'0'), und2, NVL(factor_conv_und, 0)
	into 	:ls_cod_art, :ls_desc_art, :ls_und, :ls_flag_und2, :ls_und2,:ldc_fac_conv
from articulo 
Where cod_art = :as_codigo_sku
   or cod_sku = :as_codigo_sku;

if Sqlca.sqlcode = 100 then 
	ROLLBACK;
	Messagebox( "Atencion", "Codigo: '" + as_codigo_sku &
		+ "' no existe en el maestro de artículos ni como código ni como SKU, por favor verifique!", StopSign!)
	Return 0
end if		

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', "Error al buscar en ARTICULO: " + ls_msg, StopSign!)
	return 0
end if

select 	Nvl(costo_prom_sol,0), NVL(costo_prom_dol,0),
			Nvl(sldo_total,0), NVL(sldo_total_und2,0)
	into 	:ldc_prom_sol, :ldc_prom_dol,
			:ldc_saldo_total, :ldc_saldo_total_und2
from articulo_almacen
where almacen = :ls_almacen
  and cod_art = :ls_cod_art;

if SQLCA.SQLCode < 0 then
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_msg)
	return 0
end if

if Sqlca.sqlcode = 100 then 
	// Si es una salida debe salir 
	if il_fac_total = -1 then
		ROLLBACK;
		Messagebox( "Atencion ARTICULO_ALMACEN", "Codigo de articulo: '" + ls_cod_art &
			+ " no existe en almacen " + ls_almacen, StopSign!)
		return 0
	end if
end if		

//if ldc_prom_sol = 0 then
//	select Nvl(costo_prom_sol,0), NVL(costo_prom_dol,0)
//		into :ldc_prom_sol, :ldc_prom_dol
//	from articulo
//	where cod_art = :as_articulo;
//	
//	if Sqlca.sqlcode = 100 then 
//		ROLLBACK;
//		Messagebox( "Atencion ARTICULO", "Codigo de articulo: '" + as_articulo &
//			+ " no existe", StopSign!)
//		Return 0
//	end if		
//	
//	if SQLCA.SQLCode < 0 then
//		ls_msg = SQLCA.SQLErrText
//		ROLLBACK;
//		MessageBox('Aviso', ls_msg)
//		return 0
//	end if
//end if

if ls_flag_und2 = '1' and ldc_fac_conv = 0 then
	MessageBox('Aviso', 'Ese articulo maneja una Segunda Unidad, necesita ' &
		+ 'un factor un factor de conversion entre ambas unidades ')
	return 0
end if

// Si el tipo de Movimiento es Ingreso x Produccion
if ls_tipo_mov = is_oper_ing_prod then
	select costo_produccion, cod_moneda
		into :ldc_costo_prod, :ls_tipo_mon
	from articulo_venta
	where cod_art = :ls_cod_art;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Codigo de Articulo no existe en Articulo_venta')
		return 0
	end if
	
	if ldc_costo_prod = 0 or IsNull(ldc_costo_prod) then
		MessageBox('Aviso', 'El costo de produccion para el articulo es 0')
	else
		if ls_tipo_mon = '' or ISNull(ls_tipo_mon) then
			MessageBox('Aviso', 'Tiene que definir el tipo de moneda el Articulo_venta')
			return 0
		else
			if ls_tipo_mon = is_dolares then
				ldc_prom_sol = ldc_costo_prod * in_tipo_cambio
			else
				ldc_prom_sol = ldc_costo_prod
			end if
		end if
	end if
END IF

// Si el tipo de movimiento es una venta a Terceros
if ls_tipo_mov = is_oper_vnta_terc and il_afecta_pto <> 0 then
	
	select cnta_prsp_vale_sal
		into :ls_cnta_prsp_vta
	from articulo_venta
	where cod_art = :ls_cod_art;
	
	if SQLCA.SQLCode = 100 then
		SetNull(ls_cnta_prsp_vta)
		return 0
	end if
	
end if

// Activar o desactivar lo del precio unitario
if is_solicita_precio = '1' or ls_tipo_mov = is_oper_ing_cdir &
	or ls_tipo_mov = is_oper_ing_prod then

	dw_detail.object.precio_unit.background.color = RGB(255,255,255)
	dw_detail.object.precio_unit.protect = 0
	dw_detail.object.precio_unit.EditMask.required = 'Yes'
	dw_detail.object.precio_unit.EditMask.Mask = '###,###.000000'
	
else	
	
	dw_detail.object.precio_unit.background.color = RGB(192,192,192)
	dw_detail.object.precio_unit.protect = 1
	dw_detail.object.precio_unit.EditMask.required = 'no'
	
end if

ll_row = dw_detail.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'Error, no existe ninguna fila en el detalle')
	return 0
end if
if ls_flag_und2 = '0' then SetNull(ls_flag_und2)

dw_detail.object.cod_Art	 		[ll_row] = ls_cod_Art
dw_detail.object.desc_Art	 		[ll_row] = ls_desc_art
dw_detail.object.und					[ll_row] = ls_und	
dw_detail.object.und2				[ll_row] = ls_und2	
dw_detail.object.precio_unit		[ll_row] = ldc_prom_sol
dw_detail.object.flag_und2			[ll_row] = ls_flag_und2
dw_detail.object.factor_conv_und	[ll_row] = ldc_fac_conv
dw_detail.object.cnta_prsp			[ll_row] = ls_cnta_prsp_vta


em_saldo.text 	  = String( ldc_saldo_total, '###,##0.0000' ) 
em_saldo_und2.text = String( ldc_saldo_total_und2, '###,##0.0000' ) 
em_prom_sol.text = String( ldc_prom_sol, '###,##0.0000' )
em_prom_dol.text = String( ldc_prom_dol, '###,##0.0000' )		

return 1
end function

public subroutine of_referencia_mov (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String 	ls_almacen, ls_tipo_doc, ls_nro_doc, ls_opcion, ls_tipo_mov
Date 		ld_fecha
Long		ll_row_mas, ll_factor_sldo_total
str_parametros lstr_param, lstr_datos

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return

ls_almacen 	 = dw_master.object.almacen [ll_row_mas]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN
END IF

// Si el Tipo de Movimiento es una venta a Terceros entonces 
// Extraigo el Centro de Costo del Vale de Salida
if as_tipo_mov = is_oper_vnta_terc then
	select cencos_vale_salida
	  into :is_cencos_vta
	  from logparam
	 where reckey = '1';
end if

// SI existe detalle y ya tiene seleccionado un documento
// Entonces lo selecciono
if NOT IsNull(dw_master.object.tipo_refer[ll_row_mas]) and &
	trim(dw_master.object.tipo_refer[ll_row_mas]) <> '' and &
	dw_detail.RowCount() <> 0 then 
	
	ls_tipo_doc = dw_master.object.tipo_refer[ll_row_mas] 
else
	ls_tipo_doc = ''
end if

if NOT IsNull(dw_master.object.nro_refer[ll_row_mas]) and &
	trim(dw_master.object.nro_refer[ll_row_mas]) <> '' and &
	dw_detail.RowCount() <> 0 then 
	
	ls_nro_doc = dw_master.object.nro_refer[ll_row_mas]
else
	ls_nro_doc = ''
end if

ls_tipo_mov = dw_master.object.tipo_mov [1]
	
//Obtengo el factor
select factor_sldo_total	
	into :ll_factor_sldo_total
from articulo_mov_tipo amt
where amt.tipo_mov = :ls_tipo_mov;


lstr_param.tipo		 = ''
lstr_param.dw_or_m	 = dw_master
lstr_param.dw_or_d    = dw_detail	
lstr_param.w1			 = this


// Evalua campos
if is_clase_mov = 'I' then  // Ingreso por compras

	OpenWithParm( w_get_datos_ing_oc, lstr_param )

	if IsNull(Message.PowerObjectParm) or &
		not IsValid(Message.PowerObjectParm) then return

	lstr_datos = Message.PowerObjectParm
	if lstr_datos.titulo = 'n' then return
	
	if lstr_datos.string1 = '1' then
		// Ingreso por Compra Normal
		lstr_param.dw_master = 'd_sel_oc_transito'      
		lstr_param.dw1       = 'd_sel_oc_transito_det'  
		lstr_param.opcion    = 1
		lstr_param.string1 	 = is_contab
		lstr_param.tipo		 ='COMPRAS'
		lstr_param.titulo    = 'Ordenes de Compra Pendientes '
		lstr_param.tipo_doc	 = ls_tipo_doc
		lstr_param.nro_doc	 = ls_nro_doc
		lstr_param.flag_matriz_contab = is_flag_matriz_contab

	elseif lstr_datos.string1 = '2' then
		// Ingreso por Compra Transportada
		lstr_param.dw_master = 'd_sel_vale_trans_sal'      
		lstr_param.dw1       = 'd_sel_vale_trans_sal_det'  
		lstr_param.opcion    = 10
		lstr_param.string1	= is_contab
		lstr_param.tipo		= 'COMPRAS'
		lstr_param.titulo    = 'Mov. Transporte Pendientes de Ingreso'
		lstr_param.tipo_doc	 = ls_tipo_doc
		lstr_param.nro_doc	 = ls_nro_doc
		lstr_param.flag_matriz_contab = is_flag_matriz_contab
		
	else
		MessageBox('Aviso', 'Opción no se encuentra definida, por favor reintente')
		return
	end if

	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
ELSEIF is_clase_mov = 'C' THEN	// CONSUMOS INTERNOS
	
	ld_fecha = relativeDate(Date(dw_master.object.fec_registro[ll_row_mas]), &
					il_dias_holgura)
	// Si ya he seleccionado un documento entonces simplemente 
	// obvio este paso
	if ls_tipo_doc = '' or ls_nro_doc = '' then
	
		lstr_param.tipo_mov 	= is_oper_cons_interno
		lstr_param.fecha1		= ld_fecha
		lstr_param.opcion		= 1
		lstr_param.tipo_doc	= ls_tipo_doc
		lstr_param.nro_doc	= ls_nro_doc
		lstr_param.almacen	= ls_almacen
		
		
		OpenWithParm( w_get_tipo_doc_amp, lstr_param )
	
		if IsNull(Message.PowerObjectParm) or &
			not IsValid(Message.PowerObjectParm) then return
	
		lstr_datos = Message.PowerObjectParm
		if lstr_datos.titulo = 'n' then return
		ls_tipo_doc = lstr_datos.tipo_doc
		ls_nro_doc  = lstr_datos.nro_doc
		
		dw_master.object.nro_refer		[ll_row_mas] = ls_nro_doc
		dw_master.object.tipo_refer	[ll_row_mas] = ls_tipo_doc
		dw_master.object.origen_refer	[ll_row_mas] = left(ls_nro_doc, 2)
	end if
	
	// Debo indicarle al usuario si la salida del material
	// va a ser por Saldo Libre, por reservación anticipada
	// o por reservacion por Compra
	Open(w_get_reservacion)
	
	if IsNull(Message.PowerObjectParm) or &
		not IsValid(Message.PowerObjectParm) then return

	lstr_datos = Message.PowerObjectParm
	if lstr_datos.titulo = 'n' then return
	ls_opcion = lstr_datos.string1
	
	// Si es una salida x consumo interno
	lstr_param.w1				= this
	//lstr_param.dw1      		= 'd_sel_mov_proyectados'
	lstr_param.titulo    	= 'Consumo Interno '
	lstr_param.tipo		 	= '2S_V2'     // con un parametro del tipo string
	lstr_param.string1   	= is_oper_cons_interno
	lstr_param.fecha1	 		= ld_fecha
	lstr_param.string3	 	= is_contab
	lstr_param.tipo_doc	 	= ls_tipo_doc
	lstr_param.nro_doc	 	= ls_nro_doc
	lstr_param.s_opcion	 	= ls_opcion
	lstr_param.opcion    	= 1
	lstr_param.flag_matriz_contab = is_flag_matriz_contab


	OpenWithParm( w_abc_seleccion, lstr_param)

ELSEIF is_clase_mov = 'P'  THEN	// INGRESO X PRODUCCION
	
	// Si ya he seleccionado un documento entonces simplemente 
	// obvio este paso
	if ls_tipo_doc = '' or ls_nro_doc = '' then
	
		lstr_param.tipo_mov = is_oper_ing_prod
		lstr_param.fecha1	= ld_fecha
		lstr_param.opcion	= 2					// Ingreso x produccion
		lstr_param.tipo_doc	= ls_tipo_doc
		lstr_param.nro_doc	= ls_nro_doc
		lstr_param.almacen	= ls_almacen
		
		OpenWithParm( w_get_tipo_doc_amp, lstr_param )
	
		if IsNull(Message.PowerObjectParm) or &
			not IsValid(Message.PowerObjectParm) then return
	
		lstr_datos = Message.PowerObjectParm
		if lstr_datos.titulo = 'n' then return
		ls_tipo_doc = lstr_datos.tipo_doc
		ls_nro_doc  = lstr_datos.nro_doc
		
		dw_master.object.nro_refer		[ll_row_mas] = ls_nro_doc
		dw_master.object.tipo_refer	[ll_row_mas] = ls_tipo_doc
		dw_master.object.origen_refer	[ll_row_mas] = left(ls_nro_doc, 2)
	end if
	
	// Si es ingreso por Producción
	lstr_param.w1			 = this
	lstr_param.dw1        = 'd_sel_ing_prod_proy'
	lstr_param.titulo     = 'Ingreso x Producción'
	lstr_param.tipo		 = '2S_V3'     // Ingreso x producción
	lstr_param.string1    = is_oper_ing_prod
	lstr_param.string3	 = is_contab
	lstr_param.tipo_doc	 = ls_tipo_doc
	lstr_param.nro_doc	 = ls_nro_doc
	lstr_param.flag_matriz_contab = is_flag_matriz_contab
	lstr_param.opcion    = 2

	OpenWithParm( w_abc_seleccion, lstr_param)

ELSEIF is_clase_mov = 'V'  THEN	// ORDEN DE VENTAS
	
	//Movimiento para Orden de Traslado
	lstr_param.titulo    = 'Ordenes de Ventas Pendientes '
	
	if ll_factor_sldo_total < 0 then
		//Salidos por despacho
		lstr_param.dw_master = 'd_sel_ov_pendientes'
		lstr_param.dw1       = 'd_sel_ov_transito_det'  
	else
		//Ingreso por ajustes o devolución
		lstr_param.dw_master = 'd_sel_ov_devolucion'
		lstr_param.dw1       = 'd_sel_ov_devolucion_det'  
		
	end if
	lstr_param.tipo		= 'OV'
	lstr_param.opcion    = 3
	lstr_param.tipo_doc	= ls_tipo_doc
	lstr_param.nro_doc	= ls_nro_doc


	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
ELSEIF is_clase_mov = 'T' then  // Orden de traslado
	
	if ll_factor_sldo_total < 0 then
		//Es una salida por traslado
		lstr_param.dw_master = 'd_sel_otr_transito_sal_tbl'      
		lstr_param.dw1       = 'd_sel_otr_transito_sal_det_tbl' 
	else
		//Es un ingreso por traslado
		lstr_param.dw_master = 'd_sel_otr_transito_ing_tbl'      
		lstr_param.dw1       = 'd_sel_otr_transito_ing_det_tbl' 
	end if
	
	if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
		ls_nro_doc = '%%'
	else
		ls_nro_doc = trim(ls_nro_doc) + '%'
	end if
	
	lstr_param.tipo		= '1S2S'     // con un parametro del tipo string
	lstr_param.opcion    = 5
	lstr_param.titulo    = 'Ordenes de Traslados Pendientes '
	lstr_param.string1	= ls_almacen
	lstr_param.string2	= ls_nro_doc
	
	OpenWithParm( w_abc_seleccion_md, lstr_param)
	
	IF IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	
	idc_cant_proy = lstr_param.field_ret_d[2]
	//idc_cant_proc = lstr_param.field_ret_d[3]
	//idc_cant_fact = lstr_param.field_ret_d[4]
	
END IF

if dw_master.object.tipo_refer[dw_master.GetRow()] = is_doc_otr or &
	dw_master.object.tipo_refer[dw_master.GetRow()] = is_doc_ov then
	
	dw_detail.object.b_dup.visible = true
else
	dw_detail.object.b_dup.visible = false
end if	
end subroutine

public subroutine of_salidas_mov (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String 	ls_almacen
Long		ll_row_mas
str_parametros lstr_param

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return

ls_almacen 	 = dw_master.object.almacen [ll_row_mas]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN
END IF


// Si es una salida lo amarro con los lotes y CUs

lstr_param.dw_or_m	= dw_master
lstr_param.dw_or_d   = dw_detail
lstr_param.w1			= this
lstr_param.dw1      	= 'd_sel_saldo_almacen_lotes_tbl'
lstr_param.titulo    = 'Saldo Almacen Lotes Pallets'
lstr_param.tipo		= '1S'     // con un parametro del tipo string
lstr_param.string1	= ls_almacen
lstr_param.opcion    = 15


OpenWithParm( w_abc_seleccion, lstr_param)

end subroutine

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
end if

if gnvo_app.almacen.is_despacho_POST_vta = '0' then
	dw_master.DataObject = 'd_abc_vale_mov_ff'
	dw_detail.DataObject = 'd_abc_articulo_mov_tbl'
else
	dw_master.DataObject = 'd_abc_vale_mov_vta_ff'
	dw_detail.DataObject = 'd_abc_articulo_mov_vta_tbl'
end if


dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              		// asignar dw corriente
idw_1.TriggerEvent(clicked!)

dw_master.of_protect()         		// bloquear modificaciones 
dw_detail.of_protect()

ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101     

ib_log = TRUE

// Crea datastore para impresion de vale
ids_print = Create Datastore
ids_print.DataObject = 'd_frm_movimiento_almacen'
ids_print.SettransObject(sqlca)

dw_master.object.p_logo.filename = gs_logo

if is_mod_fecha = '0' then
	// Inhabilito la fecha de registro
	dw_master.object.fec_registro.protect = 1
	dw_master.object.fec_registro.background.color = RGB(192,192,192)
	
	//dw_master.object.b_fecha.visible = 0
	dw_master.object.b_fecha.Enabled = 'No'
	
else
	// Inhabilito la fecha de registro
	dw_master.object.fec_registro.protect = 0
	dw_master.object.fec_registro.background.color = RGB(255,255,255)
	
	//dw_master.object.b_fecha.visible = 1
	dw_master.object.b_fecha.Enabled = 'Yes'
end if

invo_cntbl = create n_cst_contabilidad

sle_nro.text = trim(gs_origen)
end event

event ue_update_pre;Date ld_fecha
// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then return

if dw_master.rowCount( ) > 0 then
	ld_fecha = date(dw_master.object.fec_registro [dw_master.GetRow()])
	
	if not invo_cntbl.is_valid_fec_mov_Almacen(ld_fecha) then return
end if

//of_tipo_mov( dw_master.object.tipo_mov[dw_master.getrow()])
IF is_action <> 'anu' AND is_action <> 'del' then
	if of_get_datos() = 0 then return   		// Evalua datos de cabecera
	if of_get_datos_det() = 0 then return		// Evalua datos de detalle
END IF

// verifica que tenga datos de detalle
if dw_detail.rowcount() = 0 then
	Messagebox( "Atencion", "Ingrese informacion de detalle")
	return
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_evalua_lote () = 0 then return
if of_set_numera	() = 0 then return
if of_cntrl_cnta_cnte( ) = 0 then return

if is_flag_amp = '3' then
	if of_flag_amp () = 0 then return
end if

ib_update_check = true


end event

on w_al302_mov_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.cb_3=create cb_3
this.cb_2=create cb_2
this.sle_nro=create sle_nro
this.em_saldo_und2=create em_saldo_und2
this.em_saldo=create em_saldo
this.em_prom_dol=create em_prom_dol
this.em_prom_sol=create em_prom_sol
this.st_4=create st_4
this.cb_1=create cb_1
this.st_nro=create st_nro
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_detail=create dw_detail
this.gb_1=create gb_1
this.cb_codigo_barra=create cb_codigo_barra
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.em_saldo_und2
this.Control[iCurrent+5]=this.em_saldo
this.Control[iCurrent+6]=this.em_prom_dol
this.Control[iCurrent+7]=this.em_prom_sol
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.st_nro
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.dw_detail
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.cb_codigo_barra
this.Control[iCurrent+17]=this.dw_master
end on

on w_al302_mov_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.sle_nro)
destroy(this.em_saldo_und2)
destroy(this.em_saldo)
destroy(this.em_prom_dol)
destroy(this.em_prom_sol)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.gb_1)
destroy(this.cb_codigo_barra)
destroy(this.dw_master)
end on

event ue_insert;Long  ll_row, ll_ano, ll_mes, ll_count
string ls_nro_vale

if idw_1 = dw_master and is_action = 'new' then
	Messagebox( "Atencion", "No puede adicionar otro registro, grabe el actual", exclamation!)
	return
end if

IF idw_1 = dw_detail THEN	
	IF dw_master.GetRow() = 0 THEN
		MessageBox("Error", "EL Movimiento de Almacen no tiene cabecera")
		RETURN
	END IF	
	
	if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
		MessageBox('Aviso', 'No puede insertar mas detalle a este movimiento de almacen')
		RETURN
	end if

	if Not IsNull(dw_master.object.nro_refer[dw_master.GetRow()]) and &
		dw_master.object.nro_refer[dw_master.GetRow()] <> '' then
		
		MessageBox('Aviso', 'No puede insertar detalle a este movimiento de almacen, porque pide referencia')
		RETURN
		
	end if
	
	if is_solicita_ref = '1' then
		MessageBox('Aviso', 'No puede insertar detalle a este movimiento de almacen, porque pide referencia')
		RETURN
	end if
	
	ls_nro_vale = dw_master.object.nro_vale[dw_master.GetRow()]
	
	if Not IsNull(ls_nro_vale) then
		// Evaluo si el movimiento de almacen no ha sido generado a partir de otras 
		// fuentes
		if this.of_evalua_mov('Insertar Detalle') = 0 then
			dw_master.ii_protect = 0
			dw_master.of_protect()
			
			dw_detail.ii_protect = 0
			dw_detail.of_protect()
			return
		end if		
	end if
	
else
	// Limpia dw
	dw_master.Reset()
	dw_detail.Reset()
END IF

idt_fec_registro = gnvo_app.of_fecha_Actual()

// Verifica tipo de cambio
in_tipo_cambio = gnvo_app.of_get_tipo_cambio( DATE(idt_fec_registro) )
if in_tipo_cambio = 0 THEN return

// Verifica indicador de cierre contable
ll_ano = YEAR( DATE(idt_fec_registro))
ll_mes = MONTH( DATE(idt_fec_registro))
	
// Busca si esta cerrado contablemente	
Select NVL( flag_almacen,'0') 
	into :ii_cerrado
from cntbl_cierre 
where ano = :ll_ano 
  and mes = :ll_mes;

if sqlca.sqlcode = 100 then
	Messagebox("Atencion", "Periodo contable " &
		+ string(ll_ano) + "-" + string(ll_mes) + " no encontrado, " &
		+ "~r~n Coordinar con area contable para su CREACION", StopSign!)
	  return
end if

if ii_cerrado = 0 then
	Messagebox("Atencion", "Periodo contable " &
		+ string(ll_ano) + "-" + string(ll_mes) + " esta CERRADO para movimientos de ALMACEN, " &
		+ "~r~n Coordinar con area contable para su apertura", StopSign!)
	return
end if

if ii_cerrado = 1 then
	SELECT NVL( flag_cierre_mes, '0' ) 
	  INTO :ii_cerrado  
	from cntbl_cierre 
	where ano = :ll_ano 
	  and mes = :ll_mes ;
	  
	if ii_cerrado = 0 then
		Messagebox("Atencion", "Periodo contable " &
			+ string(ll_ano) + "-" + string(ll_mes) + " esta CERRADO CONTABLEMENTE, " &
			+ "~r~n Coordinar con area contable para su apertura", StopSign!)
		return
	end if
end if  
  


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	dw_master.object.p_logo.filename = gs_logo
	of_set_status_doc(idw_1)
end if

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_modify;call super::ue_modify;string 	ls_nro_vale, ls_origen_vale
Long	 	ll_count
Int 		li_protect

IF dw_master.rowcount() = 0 then return

if is_Action = 'new' then
	return
end if

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No puede modificar este movimiento', STopSign!)
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
	
end if

// Si el movimiento de Almacen tiene como referencia
// a una Guia de Recepcion de MP no lo debo modificar
if dw_master.object.tipo_refer[dw_master.GetRow()] = is_doc_grmp then
	
	MessageBox('Aviso', 'No puede modificar este movimiento, ya que esta amarrado a una Guia de Recepcion de MP')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
	
end if

// Evaluo si el movimiento de almacen no ha sido generado a partir de otras 
// fuentes
if this.of_evalua_mov('modificar') = 0 then
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
end if

dw_master.of_protect()
dw_detail.of_protect()	

li_protect = integer(dw_master.Object.fec_registro.Protect)

of_tipo_mov(dw_master.object.tipo_mov[dw_master.GetRow()])

IF li_protect = 0 and ib_mod = true THEN
	
	// fuerza a Desactivar objetos
	dw_master.Object.almacen.Protect = 1
	dw_master.Object.tipo_mov.Protect = 1
	dw_master.Object.tipo_doc_int.Protect = 1
	dw_master.Object.nro_doc_int.Protect = 1
	dw_master.Object.tipo_doc_ext.Protect = 1
	dw_master.Object.nro_doc_ext.Protect = 1
	dw_master.Object.proveedor.Protect = 1
	dw_master.Object.job.Protect = 1
	dw_master.Object.nom_receptor.Protect = 1
END IF 

li_protect = integer(dw_detail.Object.cod_art.Protect)
if li_protect = 0 then
	dw_detail.Object.cod_art.Protect = 1
end if

if is_mod_fecha = '0' then
	// Inhabilito la fecha de registro
	dw_master.object.fec_registro.protect = 1
	dw_master.object.fec_registro.background.color = RGB(192,192,192)
else
	// Como esta habilitado el campo simplemente me ubico en el
	dw_master.SetColumn('fec_registro')
end if

if is_Action <> 'edit' then
	is_action = 'edit'
else
	is_Action = 'open'
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String ls_msg1, ls_msg2, ls_nro_vale, ls_origen_vale

if dw_master.rowcount() = 0 then return
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

IF ib_log THEN
	ib_control_lin = FALSE

	dw_master.of_create_log()
	dw_detail.of_create_log()
	
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"		
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

	ls_origen_vale = dw_master.object.cod_origen[dw_master.GetRow()]
	ls_nro_vale		= dw_master.object.nro_vale[dw_master.GetRow()]
	
	of_retrieve( ls_nro_vale)
	of_set_status_doc( dw_master)
	f_mensaje('Cambios Guardados satisfactoriamente', '')
	
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1,ls_msg2,exclamation!)	
END IF
end event

event resize;call super::resize;Long ll_y
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 35
dw_detail.height = newheight - dw_detail.y - 180	
	
gb_1.width  = newwidth  - gb_1.x - 35
gb_1.Y		= newheight - gb_1.height - 15
	
ll_y = dw_detail.y + dw_detail.height + 70

st_1.y = ll_y + 10
em_saldo. y = ll_y 
	
st_2.y  = ll_y + 10 
em_prom_sol.y = ll_y
	
st_3.y = ll_y + 10 
em_prom_dol.y= ll_y 

st_4.y = ll_y + 10 
em_saldo_und2.y= ll_y 

end event

event ue_insert_pos;call super::ue_insert_pos;idw_1.setcolumn(1)
end event

event ue_print;call super::ue_print;event ue_preview()
/*String ls_origen, ls_nro_vale
Long job, j, lx, ly

ls_origen   = dw_master.object.cod_origen[dw_master.getrow()]
ls_nro_vale = dw_master.object.nro_vale[dw_master.getrow()]

//IF f_imp_f_general () = FALSE THEN RETURN
ids_print.Retrieve(ls_origen, ls_nro_Vale)

ids_print.print()
*/
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if





end event

event ue_delete;// OVerride
String 	ls_nro_vale, ls_origen_vale
Long		ll_count, ll_row

IF dw_master.GetRow() = 0 then return

ll_row = dw_master.GetRow()

if dw_master.object.flag_estado[ll_row] <> '1' then
	MessageBox('Aviso', 'No puede modificar este movimiento')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
	
end if

// Si el movimiento de Almacen tiene como referencia
// a una Guia de Recepcion de MP no lo debo modificar
if dw_master.object.tipo_refer[ll_row] = is_doc_grmp then
	
	MessageBox('Aviso', 'No puede modificar este movimiento, ya que esta amarrado a una Guia de Recepcion de MP')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	return
	
end if


ls_nro_vale 	= dw_master.object.nro_vale 	[ll_row]
ls_origen_vale	= dw_master.object.cod_origen [ll_row]

// Ahora verifico que el mov de almacen no haya sido generado por 
// Gastos Directos de Bahia Flota
select count(*)
	into :ll_count
from articulo_mov am,
     fl_gtos_drcts_bahia_det a
where ((am.cod_origen = a.org_am_ing and am.nro_mov = a.nro_am_ing) 
   or (am.cod_origen = a.org_am_sal and am.nro_mov = a.nro_am_sal))
   and am.flag_estado <> '0'
	and am.nro_vale = :ls_nro_vale;

if ll_count > 0 then
	MessageBox('Aviso', 'No puede modificar este vale de almacen porque ha sido generado ' &
			 	+ 'desde FLOTA (GASTOS DIRECTOS DE BAHIA)', Exclamation!)
	return
end if	

//Verificando que el Vale de Almacen no pertenezca a consignacion
select count(*)
	into :ll_count
from articulo_consignacion
where ((ORIGEN_VALE_ING = :ls_origen_vale and NRO_VALE_ING = :ls_nro_vale)
   or (ORIGEN_VALE_SAL = :ls_origen_vale and VAL_NRO_VALE = :ls_nro_vale))
  and flag_estado <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'No puede modificar este vale de almacen porque ha sido generado ' &
			 	+ 'desde la consignacion', Exclamation!)
	return
end if

//Verificando que el Vale de Almacen no haya sido generado por el módulo de Balanza

select count(*)
	into :ll_count
from 	salida_pesada 	sp,
		articulo_mov	am
where sp.org_am = am.cod_origen
  and sp.nro_am = am.nro_mov
  and am.nro_vale = :ls_nro_vale;


if ll_count > 0 then
	MessageBox('Aviso', 'No puede modificar este vale de almacen porque ha sido generado ' &
			 	+ 'desde el módulo de balanza, para modificarlo vaya a la opcion correspondiente' &
				+ ' y modifícalo desde ahi', Exclamation!)
	return
end if

// Verificando que el Vale de Almacen no pertenezca a Devoluciones ni
// prestamos
select count(*)
	into :ll_count
from art_devol_prestamo
where ORIGEN_VALE = :ls_origen_vale 
  and NRO_VALE 	= :ls_nro_vale
  and flag_estado <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'No puede modificar este vale de almacen porque ha sido generado ' &
			 	+ 'desde Devolucion/Prestamo', Exclamation!)
	return
end if


//Continuamos con el procedimiento
if idw_1 = dw_master then
	Messagebox( "Atencion", "Operacion no permitida", exclamation!)
	return
end if
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

if idw_1 = dw_master then
	is_action = 'del'
end if
end event

event ue_close_pre();call super::ue_close_pre;DESTROY ids_print
end event

event close;call super::close;DESTROY invo_cntbl
DESTROY ids_print
end event

event ue_retrieve_list;// Abre ventana pop
str_parametros lstr_param

lstr_param.dw1    	= 'd_list_vale_mov'
lstr_param.titulo 	= 'Movimiento de Almacen'
lstr_param.tipo		= '1S'
lstr_param.string1	= gs_user
lstr_param.field_ret_i[1] = 1
lstr_param.field_ret_i[2] = 2


OpenWithParm( w_lista, lstr_param)
if IsNull(MESSAGE.POWEROBJECTPARM) or not IsValid(MESSAGE.POWEROBJECTPARM) then return

lstr_param = MESSAGE.POWEROBJECTPARM
if lstr_param.titulo <> 'n' then
	of_retrieve(lstr_param.field_ret[2])
END IF
end event

type cb_3 from commandbutton within w_al302_mov_almacen
boolean visible = false
integer x = 3346
integer y = 624
integer width = 462
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Listar Pallets / CUS"
end type

event clicked;parent.event ue_print_code_qr()
end event

type cb_2 from commandbutton within w_al302_mov_almacen
integer x = 3346
integer y = 520
integer width = 457
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Codigo QR Grande"
end type

event clicked;parent.event ue_print_code_qr()
end event

type sle_nro from u_sle_codigo within w_al302_mov_almacen
integer x = 283
integer y = 4
integer width = 471
integer height = 92
integer taborder = 20
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;dw_detail.reset()
cb_1.event clicked()
end event

type em_saldo_und2 from singlelineedit within w_al302_mov_almacen
integer x = 1211
integer y = 1724
integer width = 343
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type em_saldo from singlelineedit within w_al302_mov_almacen
integer x = 480
integer y = 1724
integer width = 343
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type em_prom_dol from singlelineedit within w_al302_mov_almacen
integer x = 2674
integer y = 1724
integer width = 343
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type em_prom_sol from singlelineedit within w_al302_mov_almacen
integer x = 1947
integer y = 1724
integer width = 343
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type st_4 from statictext within w_al302_mov_almacen
integer x = 873
integer y = 1732
integer width = 334
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Und2:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_al302_mov_almacen
integer x = 855
integer width = 402
integer height = 100
integer taborder = 30
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

type st_nro from statictext within w_al302_mov_almacen
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

type st_3 from statictext within w_al302_mov_almacen
integer x = 2354
integer y = 1732
integer width = 311
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Precio US$:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al302_mov_almacen
integer x = 1637
integer y = 1732
integer width = 293
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Precio S/.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_al302_mov_almacen
integer x = 105
integer y = 1732
integer width = 334
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Actual:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_al302_mov_almacen
integer y = 1152
integer width = 3621
integer height = 488
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_articulo_mov_tbl"
borderstyle borderstyle = styleraised!
integer ii_sort = 1
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
idw_mst = dw_master
idw_det = dw_detail
end event

event itemchanged;call super::itemchanged;String 	ls_tipo_mov, ls_cod_art, ls_almacen, ls_consig, ls_pide_cen, &
			ls_art, ls_matriz, ls_cencos, ls_cnta_prsp, ls_grp_cntbl, ls_estado, &
			ls_flag_und2, ls_FLAG_CMP_DIRECTA, ls_FLAG_INGR_EGR, ls_flag_estado, &
			ls_tipo_refer, ls_sub_cat
			
Decimal 	ld_cant, ld_precio, ldc_fac_conv, ldc_cant_proc_und2, ldc_cant_asig, &
			ldc_cant_devol_und1, ldc_cant_devol_und2, ldc_peso_und
			
long 		ll_count, ll_row_mas, ll_mes, ll_ano, ll_row

try 
	if dw_master.GetRow() = 0 then return
	
	ls_almacen  	= dw_master.Object.almacen		[1]
	ls_tipo_mov 	= dw_master.Object.tipo_mov	[1]
	ls_tipo_refer	= dw_master.object.tipo_refer	[1]
	if IsNull(ls_tipo_refer) then ls_tipo_refer = ''
	
	ls_cod_art 		= this.Object.cod_art[row]
	ldc_cant_asig 	= this.object.cant_procesada[row]
	
	dw_master.Accepttext()
	dw_detail.AcceptText()
	CHOOSE CASE dwo.name
		CASE 'cod_art'		
			if of_set_articulo( data, ls_almacen) = 1 &
				and f_articulo_inventariable( data ) <> 1 then 
				
				this.object.cod_art	[row] = gnvo_app.is_null
				this.object.desc_art	[row] = gnvo_app.is_null
				this.object.und		[row] = gnvo_app.is_null
				
				return 1
			end if
			
			ld_cant = this.object.cant_procesada[row]
			
			return 2
			
		CASE 'precio_unit'		
			if double( data)  < 0 then  // no acepta negativos
				Messagebox("Aviso", "No puede ingresar este precio") 
				this.object.precio_unit[row] = gnvo_app.il_null
				return 1
			end if
			
		CASE 'cant_procesada'
			ldc_fac_conv 			= dec(this.object.factor_conv_und	[row])
			ldc_cant_devol_und1 	= Dec(this.object.cant_devol_und1	[row])
			ldc_cant_devol_und2	= Dec(this.object.cant_devol_und2	[row])
			ldc_peso_und			= Dec(this.object.peso_und				[row])
			ldc_cant_proc_und2 	= Dec(this.object.cant_proc_und2		[row])
			ls_flag_und2 			= this.object.flag_und2[row]
			
			
			if IsNull(ldc_fac_conv) then ldc_fac_conv = 0
			if IsNull(ldc_peso_und) then ldc_peso_und = 0
			if IsNull(ldc_cant_devol_und1) then ldc_cant_devol_und1 = 0
			if IsNull(ldc_cant_devol_und2) then ldc_cant_devol_und2 = 0
			If IsNull(ldc_cant_proc_und2) then ldc_cant_proc_und2 = 0
	
			if dec(data) <= 0 then  // no acepta negativos
				Messagebox("Aviso", "No puede ingresar Cantidades negativas, por favor verifique!", StopSign!) 
				this.object.cant_procesada[row] = gnvo_app.il_null
				return 1
			end if
			
			if ldc_cant_devol_und1 > 0 then
				if dec(data) > ldc_cant_devol_und1  then
					MessageBox('Aviso', 'La cantidad de Devolucion de Und1 no puede exceder al movimiento Original, por favor verifica ' &
											+ '~r~nCant. Movimiento: ' + string(dec(data), "###,##0.00000000") &
											+ '~r~nCant. Devolucion: ' + string(ldc_cant_devol_und1, "###,##0.00000000"), StopSign!)
					this.object.cant_procesada	[row] = ldc_cant_devol_und1
					return 1
				end if
			end if
			
			if is_Action = 'new' and of_evalua_saldos(row) = 0 then 
				this.object.cant_procesada[row] = gnvo_app.il_null
				return 1
			end if	
			
			if ls_flag_und2 = '1' then
				this.object.cant_proc_und2[row] = dec(data) * ldc_fac_conv
				
				if is_tipo_mov_dev <> '' and Not ISNull(is_tipo_mov_dev) then
					if dec(this.object.cant_proc_und2[row]) > ldc_cant_devol_und2 then
						MessageBox('Aviso', 'La cantidad de Devolucion de Und2 no puede exceder al movimiento Original, por favor verifica ' &
												+ '~r~nCant. Movimiento: ' + string(dec(data), "###,##0.00000000") &
												+ '~r~nCant. Devolucion: ' + string(ldc_cant_devol_und2, "###,##0.00000000"), StopSign!)
						this.object.cant_proc_und2[row] = ldc_cant_devol_und2
						return 1
					end if
				end if
				
			end if
			
			//Calculando el peso neto
			this.object.peso_neto	[row] = ldc_peso_und * Dec(data)
			
		CASE 'cant_proc_und2'
			
			ldc_fac_conv 			= dec(this.object.factor_conv_und	[row])
			ldc_cant_devol_und1 	= Dec(this.object.cant_devol_und1	[row])
			ldc_cant_devol_und2	= Dec(this.object.cant_devol_und2	[row])
			ls_flag_und2 			= this.object.flag_und2[row]
			
			if IsNull(ldc_fac_conv) then ldc_fac_conv = 0
			if IsNull(ldc_cant_devol_und1) then ldc_cant_devol_und1 = 0
			if IsNull(ldc_cant_devol_und2) then ldc_cant_devol_und2 = 0
			
			if dec(data) < 0 then  // no acepta negativos
				Messagebox("Aviso", "No puede ingresar Cantidades negativas en Und2, por favor verifique!", StopSign!) 
				this.object.cant_proc_und2[row] = 0.00
				return 1
			end if
	
			if is_tipo_mov_dev <> '' and Not ISNull(is_tipo_mov_dev) then
				if dec(data) > ldc_cant_devol_und2 then
					MessageBox('Aviso', 'La cantidad de Devolucion de Und2 no puede exceder al movimiento Original, por favor verifica ' &
											+ '~r~nCant. Movimiento: ' + string(dec(data), "###,##0.00000000") &
											+ '~r~nCant. Devolucion: ' + string(ldc_cant_devol_und2, "###,##0.00000000"), StopSign!)
					this.object.cant_proc_und2[row] = ldc_cant_devol_und2
					return 1
				end if
			end if
			
			if gnvo_app.of_get_parametro('ALMACEN_CONV_UND2_TO_UND1', '1') = '1' THEN
				if ls_flag_und2 = '1' then
					if ldc_fac_conv = 0 then
						MessageBox('Aviso', 'No ha especificado Factor de Conversión en articulo, por favor verifica ' &
													+ '~r~nCant. Cod Art: ' + this.object.cod_art [row], StopSign!)
							this.object.cant_procesada	[row] = 0
							this.object.cant_proc_und2	[row] = 0
							return 1
					end if
					
					this.object.cant_procesada[row] = dec(data) / ldc_fac_conv
					
					if is_tipo_mov_dev <> '' and Not ISNull(is_tipo_mov_dev) then
						if dec(this.object.cant_procesada[row]) > ldc_cant_devol_und1 then
							MessageBox('Aviso', 'La cantidad de Devolucion de Und1 no puede exceder al movimiento Original, por favor verifica ' &
													+ '~r~nCant. Movimiento: ' + string(dec(data) / ldc_fac_conv, "###,##0.00000000") &
													+ '~r~nCant. Devolucion: ' + string(ldc_cant_devol_und1, "###,##0.00000000"), StopSign!)
							this.object.cant_procesada[row] = ldc_cant_devol_und1
							return 1
						end if
					end if
					
					
				end if
			end if
			
			if of_evalua_saldos_und2(row) = 0 then 
				this.object.cant_proc_und2[row] = 0
				return 1
			end if	
	
		CASE 'cencos' 
	
			// Si no pide el factor, evalua por el c.costo		
			Select NVL(flag_cta_presup, '0'), NVL(flag_estado, '0')
				into :ls_pide_cen, :ls_estado 
			from centros_costo 
			where cencos = :data;
			
			if SQLCA.SQLCode = 100 then
				Setnull(gnvo_app.is_null)
				Messagebox( "Atencion", "Centro de costo no existe")
				this.object.cencos[row] = gnvo_app.is_null
				return 1
			end if
			
			if ls_estado <> '1' then
				Messagebox( "Atencion", "Centro de costo esta desactivado", Exclamation!)		
				this.object.cencos[row] = gnvo_app.is_null
				Return 1
			end if		
					
			if ls_pide_cen = '1' then
				dw_detail.object.cencos.background.color 		= RGB(255,255,255)			
				dw_detail.object.cencos.protect 					= 0
				dw_detail.object.cencos.edit.required 			= 'yes'
				dw_detail.object.cnta_prsp.background.color 	= RGB(255,255,255)			
				dw_detail.object.cnta_prsp.protect 				= 0
				dw_detail.object.cnta_prsp.edit.required 		= 'yes'
			end if		
			
			if is_contab = '1' then
				if of_set_matriz() = 0 then
					this.object.matriz 	[row] = gnvo_app.is_null
					this.setfocus()
					this.setcolumn('cencos')
					return 1	
				end if	
			end if
	
			is_cencos = data
			
		CASE "cnta_prsp" 
			//Verifica que exista dato ingresado	
			Select count(cnta_prsp) 
				into :ll_count 
			from presupuesto_cuenta 
			where cnta_prsp = :data;	
			
			if ll_count = 0 then			
				Messagebox( "Atencion", "Cuenta no existe", Exclamation!)		
				this.object.cnta_prsp[row] = gnvo_app.is_null
				Return 1
			end if		
			
			if is_contab = '1' then
				if of_set_matriz() = 0 then
					this.object.matriz 	[row] = gnvo_app.is_null
					this.setfocus()
					this.setcolumn('cnta_prsp')
					return 1	
				end if	
			end if
			
			is_cnta_prsp = data				
			
		CASE "cod_maquina"
			// Verifica que codigo exista
			Select count(cod_maquina) 
				into :ll_count 
			from maquina
			Where cod_maquina = :data
			  and flag_estado = '1'
			  and nivel 		= 4;
			  
			if ll_count = 0 then			
				Messagebox( "Atencion", "Maquina no existe, no esta activo o no pertenece al nivel 4, por favor coordinar con Mantenimiento / Taller", Exclamation!)
				this.object.cod_maquina[row] = gnvo_app.is_null
				return 1
			end if
			
		CASE "matriz"
			ls_cod_art = this.object.cod_Art		[row]
			if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
				MessageBox('Error', 'Codigo de Articulo esta nulo o vacio, por favor corrija!', StopSign!)
				this.SetColumn('cod_art')
				return 1
			end if
			
			select sub_cat_art
				into :ls_sub_cat
			from articulo
			where cod_art = :ls_cod_art
			  and flag_estado = '1';
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Error', 'Codigo de Articulo ' + ls_cod_art + ' no existe o no esta activo, por favor corrija', StopSign!)
				this.object.cod_art [row] = gnvo_app.is_null
				this.SetColumn('cod_art')
				return 1
			end if
			
			if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
				MessageBox('Error', 'Codigo de Articulo ' + ls_cod_art + ' no tiene subcategoria, Por favor verifique!', StopSign!)
				this.object.cod_art [row] = gnvo_app.is_null
				this.SetColumn('cod_art')
				return 1
			end if
			
			IF il_afecta_pto = 1 THEN
				
				ls_cencos 		= this.object.cencos[row]
			
				// Busca grp_cntbl segun centro de costo
				Select grp_cntbl 
					into :ls_grp_cntbl 
				from centros_costo
				where cencos = :ls_cencos
				  and flag_estado = '1';
				  
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'Centro de Costo no existe o no esta activo, por favor verifique', StopSign!)
					this.SetColumn('cencos')
					return 1
				end if
				
				if IsNull(ls_grp_cntbl) or trim(ls_grp_cntbl) = '' then
					MessageBox('Error', 'Centro de Costo ' + ls_cencos + ' no tiene Grupo Contable, por favor corrija', StopSign! )
					this.SetColumn('cencos')
					return 1
				end if
				
				// Verifica que codigo exista
				Select count(tipo_mov) 
					into :ll_count 
				from tipo_mov_matriz_subcat
				Where tipo_mov 	= :ls_tipo_mov 
				  and grp_cntbl 	= :ls_grp_cntbl 
				  and cod_sub_cat	= :ls_sub_cat
				  and matriz 		= :data;		
				  
				if ll_count = 0 then			
					Messagebox( "Error", "Matriz elegida no corresponde a la información ingresada." &
												+ "~r~nTipo de movimiento SI afecta presupuesto." &
												+ "~r~nMatriz: " + data &
												+ "~r~nTipo Mov: " + ls_tipo_mov &
												+ "~r~nGrupo Contable: " + ls_grp_cntbl &
												+ "~r~nSub Categoría: " + ls_sub_cat, StopSign!)
					this.object.matriz[row] = gnvo_app.is_null
					return 
				end if		
				

				if row < this.RowCount() then
					if MessageBox('Pregunta', 'Desea aplicar la misma MATRIZ CONTABLE para los registros restantes?', &
									Information!, YesNo!, 2) = 2 then
						return 1
					end if
					
					for ll_row = row + 1 to this.RowCount()
						yield()
						this.object.matriz			[ll_row] = data
						yield()
					next
				end if	
				
			ELSE
				// Verifica que codigo exista
				Select count(tipo_mov) 
					into :ll_count 
				from tipo_mov_matriz_subcat
				Where tipo_mov 	= :ls_tipo_mov 
				  and cod_sub_cat = :ls_sub_cat
				  and matriz 		= :data;		
				  
				if ll_count = 0 then			
					Messagebox( "Error", "Matriz elegida no corresponde a la información ingresada." &
												+ "~r~nTipo de movimiento NO afecta presupuesto." &
												+ "~r~nMatriz: " + data &
												+ "~r~nTipo Mov: " + ls_tipo_mov &
												+ "~r~nSub Categoría: " + ls_sub_cat, StopSign!)
					this.object.matriz[row] = gnvo_app.is_null
					return 
				end if	
				
				if row < this.RowCount() then
					if MessageBox('Pregunta', 'Desea aplicar la misma MATRIZ CONTABLE para los registros restantes?', &
									Information!, YesNo!, 2) = 2 then
						return 1
					end if
					
					for ll_row = row + 1 to this.RowCount()
						yield()
						this.object.matriz			[ll_row] = data
						yield()
					next
				end if	
			END IF
			
		CASE "nro_lote"
			
			Select flag_estado 
				into :ls_estado 
			from templas 
			where cod_templa 	= :data;
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de templa ' + data + ' no existe')
				this.object.nro_lote[row] = gnvo_app.is_null
				this.SetColumn('nro_lote')
				return 1
			end if
			
			if ls_estado = '0' then
				Messagebox( "Atencion", "Nro. de templa no esta activo")
				this.object.nro_lote[row] = gnvo_app.is_null
				this.SetColumn('nro_lote')
				return 1
			end if
			
		case "centro_benef"
			
			select count(*)
				into :ll_count
			from centro_beneficio
			where centro_benef = :data
			  and flag_estado = '1';
			
			if ll_count = 0 then
				Messagebox('Aviso', "Código de Centro de Beneficio no existe o no está activo", StopSign!)
				this.object.centro_benef	[row] = gnvo_app.is_null
				return 1
			end if
	
	END CHOOSE
	
	// Evalua presupuesto en linea
	if il_afecta_pto <> 0 then
		 
		IF il_afecta_pto < 0 THEN
			ll_row_mas 	= dw_master.GetRow()
			ll_mes 		= MONTH( DATE(dw_master.object.fec_registro[ll_row_mas]))
			ll_ano		= YEAR( DATE( dw_master.object.fec_registro[ll_row_mas]))
			
			if of_verifica_pta_prsp(row) = 0 then
				return 1
			end if
			
			IF f_afecta_presup(ll_mes, ll_ano, is_cencos, is_cnta_prsp, 0) = 0 THEN
				MESSAGEBOX( "Error", 'no tiene presupuesto')
				this.object.cnta_prsp[row] = gnvo_app.is_null
				is_cnta_prsp = ''
				this.setcolumn( "cnta_prsp")
				this.setfocus()
				RETURN 1
			END IF
		END IF
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en ItemChanged')
end try


end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc( THIS)

if of_get_datos() = 0 then return
end event

event ue_insert_pre;String 	ls_tipo_mov, ls_tipo_alm, ls_alm, ls_matriz
Long		ll_row_mas

if dw_master.GetRow() = 0 then
	MessageBox('Aviso', 'Movimiento de Almacen no tiene cabecera')
	return
end if

this.object.cod_origen		[al_row] = dw_master.object.cod_origen[dw_master.GetRow()]
this.object.cod_moneda		[al_row] = is_soles
this.object.flag_estado		[al_row] = '1'
this.object.precio_unit		[al_row] = 0
this.object.cant_procesada	[al_row] = 0.00
this.object.cant_proc_und2	[al_row] = 0.00
this.object.decuento			[al_row] = 0
this.object.impuesto			[al_row] = 0
this.object.peso_neto		[al_row] = 0
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_Actual()

if is_flag_amp = '3' then
	this.object.oper_sec		[al_row] = is_oper_sec
end if

//Por defecto todo es saldo libre
this.object.flag_saldo_libre [al_row] = '1'

is_cencos = gnvo_app.is_null
is_cnta_prsp = gnvo_app.is_null
ll_row_mas = dw_master.GetRow()
if ll_row_mas = 0 then return

if is_action <> 'new' then
	this.object.nro_vale[al_row] = dw_master.object.nro_vale[ll_row_mas]
end if

ls_tipo_mov = dw_master.object.tipo_mov[ll_row_mas]

if il_afecta_pto = 0 then  // no requerido
   // Si no lo pide el factor, evalua por el c.costo
	this.object.cencos.background.color = RGB(192,192,192)	
	this.object.cencos.protect = 1
	this.object.cencos.edit.required = 'no'
	this.object.cnta_prsp.background.color = RGB(192,192,192)			
	this.object.cnta_prsp.protect = 1
	this.object.cnta_prsp.edit.required = 'no'
else
	this.object.cencos.background.color = RGB(255,255,255)			
	this.object.cencos.protect = 0
	this.object.cencos.edit.required = 'yes'
	this.object.cnta_prsp.background.color = RGB(255,255,255)			
	this.object.cnta_prsp.protect = 0
	this.object.cnta_prsp.edit.required = 'yes'
end if

// Si le operacion es una venta a terceros y que ademas afecte a presupuesto entonces
// Que ponga el centro de costo x defecto
if ls_tipo_mov = is_oper_vnta_terc and il_afecta_pto <> 0 then
	this.object.cencos [al_row] = is_cencos_vta
end if

// evalua si contabiliza, osea que pida matriz contable
if is_contab = '1' then  // no requerido
	this.object.matriz.background.color = RGB(255,255,255)			
	this.object.matriz.protect = 0
	this.object.matriz.edit.required = 'yes'			
else		
	this.object.matriz.background.color = RGB(192,192,192)	
	this.object.matriz.protect = 1
	this.object.matriz.edit.required = 'no'
end if		

// Activar o desactivar lo del precio unitario
if is_solicita_precio = '1' or ls_tipo_mov = is_oper_ing_cdir &
	or ls_tipo_mov = is_oper_ing_prod then

	this.object.precio_unit.background.color = RGB(255,255,255)
	this.object.precio_unit.protect = 0
	this.object.precio_unit.EditMask.required = 'Yes'
	this.object.precio_unit.EditMask.Mask = '###,###.000000'
	
else	
	
	this.object.precio_unit.background.color = RGB(192,192,192)
	this.object.precio_unit.protect = 1
	this.object.precio_unit.EditMask.required = 'no'
	
end if

// Si es un movimiento de devolucion no puedo modificar el articulo

this.Modify("cant_proc_und2.Protect ='1~tIf(IsNull(flag_und2),1,0)'")
this.Modify("cant_proc_und2.Background.color ='1~tIf(IsNull(flag_und2),RGB(192,192,192),RGB(255,255,255))'")
this.SetColumn('cod_art')
end event

event getfocus;call super::getfocus;if of_get_datos() = 0 then return
end event

event ue_output;call super::ue_output;of_saldos_articulo(al_row)
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          ls_boton, ls_nro_vale, ls_origen
long				 ll_row
DateTime			 ldt_fec_reg	
str_parametros 	 sl_param

If this.Describe("almacen.Protect") = '1' then RETURN

ls_boton = dwo.name

if ls_boton = 'b_dup' then	
	of_duplica_mov_art(row)	
end if

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)
end event

event ue_display;call super::ue_display;// Abre ventana de ayuda 
String 	ls_name, ls_prot, ls_tipo_mov, ls_cencos, ls_cnta_prsp, &
    		ls_matriz, ls_grp_cntbl, ls_sql, ls_codigo, &
			ls_data, ls_almacen, ls_sub_cat, ls_cod_art, ls_nivel, &
			ls_nro_pallet, ls_anaquel, ls_fila, ls_columna, ls_nro_lote
Long 		ll_count, ll_mes, ll_year, ll_row
Integer	li_factor_sldo_total
boolean	lb_Ret
str_parametros sl_param
str_Articulo	lstr_articulo
str_maquinas	lstr_maquina

if dw_master.getRow() = 0 then return

ls_tipo_mov 			= dw_master.object.tipo_mov						[1]
li_factor_sldo_total	= Integer(dw_master.object.factor_sldo_total	[1])

if IsNull(ls_tipo_mov) or trim(ls_tipo_mov) = '' then
	MessageBox('Error', 'Debe colocar un Tipo de Movimiento Valido')
	return
end if

ll_year = Long(string(dw_master.object.fec_registro[1], 'yyyy'))

choose case lower(as_columna)
	case "cod_art"
		ls_almacen = dw_master.object.almacen [1]
			
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', "Debe seleccionar el almacén primero, por favor verifique!", StopSign!)
			dw_master.SetColumn( "almacen" )
			dw_master.SetFocus()
			return
		end if
		
		/*************************************************************/
		//De acuerdo al factor Saldo Total aparece la ventana correcta
		/*************************************************************/
		if li_factor_sldo_total = 1 then
			
			lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
		
			if lstr_articulo.b_Return then
				if of_set_articulo( lstr_articulo.cod_art, ls_almacen) = 1 then
					this.object.cod_art				[al_row] = lstr_articulo.cod_art
					this.object.desc_art				[al_row] = lstr_articulo.desc_art
					this.object.und					[al_row] = lstr_articulo.und
				
					this.ii_update = 1
				end if
			end if
			
		else
			
			lstr_articulo = gnvo_app.almacen.of_get_articulo_venta( ls_almacen )
	
			if lstr_articulo.b_Return then
				if of_set_articulo( lstr_articulo.cod_art, ls_almacen) = 1 then
					this.object.cod_art				[al_row] = lstr_articulo.cod_art
					this.object.desc_art				[al_row] = lstr_articulo.desc_art
					this.object.und					[al_row] = lstr_articulo.und
					
					if this.of_ExisteCampo("previo_vta") then
						This.object.precio_vta		[al_row] = lstr_articulo.precio_vta_unidad
					end if
			
					this.ii_update = 1
				end if
			end if
		
		end if		
		
	case "cnta_prsp"
		
		ls_sql = "select distinct pc.CNTA_PRSP as codigo_cuenta, " &
				 + "pc.descripcion as descripcion_cuenta " &
				 + "from presupuesto_cuenta pc, " & 
				 + "presupuesto_partida pp " &
				 + "where pc.cnta_prsp = pp.cnta_prsp " &
				 + "and pc.flag_estado = '1' " &
				 + "and pp.ano = " + string(ll_year) &
				 + "and NVL(pp.flag_cmp_directa,'') <> '1' " &
				 + "and pp.flag_estado <> '0' " &
				 + "and pp.cencos = '" + is_cencos + "' " &
				 + "order by pc.descripcion"
					 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if isnull(ls_codigo) or trim(ls_codigo) = '' then return
		
		this.object.cnta_prsp[al_row] = ls_codigo
		is_cnta_prsp = ls_codigo		
		this.ii_update = 1		// activa flag de modificado

		if is_contab = '1' then
			if of_set_matriz() = 0 then
				this.object.matriz 	[al_row] = gnvo_app.is_null
				this.setfocus()
				this.setcolumn('cnta_prsp')
				return 
			end if	
		end if
		
	case "cencos"
		ls_sql = "select distinct cc.cencos as codi_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo cc, " & 
				 + "presupuesto_partida pp " &
				 + "where pp.cencos = cc.cencos " &
				 + "and cc.flag_estado = '1' " &
				 + "and pp.ano = " + string(ll_year) &
				 + "and NVL(pp.flag_cmp_directa,'') <> '1' " &
				 + "and pp.flag_estado <> '0' " &
				 + "order by cc.desc_cencos"
					 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if isnull(ls_codigo) or trim(ls_codigo) = '' then return
		
		this.object.cencos			[al_row] = ls_codigo
		is_Cencos = ls_codigo
		this.ii_update = 1
			
		if is_contab = '1' then
			if of_set_matriz() = 0 then
				this.object.matriz 	[al_row] = gnvo_app.is_null
				this.setfocus()
				this.setcolumn('cencos')
				return 
			end if	
		end if

	CASE	'cod_maquina'
		lstr_maquina = gnvo_app.of_get_maquina()
		
		if lstr_maquina.b_return then
			this.object.cod_maquina	[al_row] = lstr_maquina.cod_maquina
			this.ii_update = 1
		end if
		return

	case "nro_lote"
		if dw_master.GetRow() = 0 then return
		
		ls_almacen 	= dw_master.object.almacen	[dw_master.GetRow()]
		ls_cod_art	= this.object.cod_art		[al_row]
		
		if ls_almacen = '' or IsNull(ls_almacen) then
			MEssageBox('Aviso', 'Defina el almacen primero', StopSign!)
			dw_master.setFocus()
			dw_master.setColumn("almacen")
			return
		end if
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MEssageBox('Aviso', 'Defina el Código de Articulo primero', StopSign!)
			this.setColumn("cod_art")
			return
		end if
		
		if il_fac_total = 1 then
			sl_param.dw1 	 = "d_sel_templas"
			sl_param.titulo = "Lotes / Rumas disponibles"
		else
			sl_param.dw1 = "d_sel_saldo_templa_x_codigo"
			sl_param.titulo = "Lotes / Rumas disponibles"
			sl_param.tipo = '1S2S'
			sl_param.string1 = ls_cod_art
			sl_param.string2 = ls_almacen
		end if
		

		sl_param.field_ret_i[1] = 1
			
		OpenWithParm( w_search, sl_param )		
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then		
			this.object.nro_lote[al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		END IF

	case "matriz"
		// Busco la matriz contable por Codigo de SubCategoria del Articulo
		ls_cod_art = this.object.cod_Art [al_row]
		if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
			MessageBox('Error', 'Debe indicar un codigo de articulo valido, por favor verifique!', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		select sub_cat_art
			into :ls_sub_cat
		from articulo
		where cod_art = :ls_cod_art
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Articulo ' + ls_cod_art + ' no existe o no se encuentra activo.', StopSign!)
			return
		end if
		
		if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
			MessageBox('Error', 'No se ha definido Codigo de Sub Categoria en Articulo ' + ls_cod_art &
				+ ', por favor verifique!', StopSign!)
			return
		end if
		
		if il_afecta_pto = 0  then
			ls_grp_cntbl = '%%'
		else
			ls_cencos 	 = this.object.cencos	[al_row]
			
			// Busca grp_cntbl segun centro de costo
			Select NVL(trim(cc.grp_cntbl), '%') || '%'
				into :ls_grp_cntbl 
			from centros_costo cc
			where cc.cencos 		= :ls_cencos
			  and cc.flag_estado = '1';

			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Centro de Costos ' + ls_cencos &
					+ ' no existe o no se encuentra activo. Por favor verifique!', StopSign!)
				return
			end if
			
			
		end if
		
		sl_param.dw1 		= "d_sel_tipo_mov_matriz_subcat"
		sl_param.titulo 	= "Matrices de movimiento almacen"
		sl_param.tipo 		= '1S2S3S'
		sl_param.string1 	= ls_tipo_mov
		sl_param.string2 	= ls_grp_cntbl
		sl_param.string3 	= ls_sub_cat
		sl_param.factor_prsp = il_afecta_pto  	// Factor Presupuesto de Tipo_mov
		sl_param.field_ret_i[1] = 1				// Grupo
		sl_param.field_ret_i[2] = 2				// Subcategoria
		sl_param.field_ret_i[3] = 3				// Matriz
	
		OpenWithParm( w_search, sl_param)		
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then		
			//Asigno la matriz contable
			ls_grp_cntbl 				= sl_param.field_ret[1]
			ls_sub_cat 				   	= sl_param.field_ret[2]
			ls_matriz 				   	= sl_param.field_ret[3]
			
			if il_afecta_pto <> 0 then
				ls_cencos 	 = this.object.cencos[al_row]
			
				// Verifica que codigo exista
				Select count(tipo_mov) 
					into :ll_count 
				from tipo_mov_matriz_subcat
				Where tipo_mov 	= :ls_tipo_mov 
				  and grp_cntbl 	= :ls_grp_cntbl 
				  and cod_sub_Cat	= :ls_sub_cat
				  and matriz 		= :ls_matriz;		
				  
				if ll_count = 0 then			
					Messagebox( "Error", "Matriz elegida no corresponde a la información ingresada." &
												+ "~r~nTipo de movimiento SI afecta presupuesto." &					
												+ "~r~nMatriz: " + ls_matriz &
												+ "~r~nTipo Mov: " + ls_tipo_mov &
												+ "~r~nGrupo Contable: " + ls_grp_cntbl &
												+ "~r~nSub Categoría: " + ls_sub_cat, StopSign!)
					this.object.matriz[al_row] = gnvo_app.is_null
					return 
				end if		
				
				
				
			else
				
				// Verifica que codigo exista
				Select count(tipo_mov) 
					into :ll_count 
				from tipo_mov_matriz_subcat
				Where tipo_mov 	= :ls_tipo_mov 
				  and matriz 		= :ls_matriz
				  and cod_sub_cat = :ls_sub_cat;		
				  
				if ll_count = 0 then			
					Messagebox( "Error", "Matriz elegida no corresponde a la información ingresada." &
												+ "~r~nTipo de movimiento NO afecta presupuesto." &					
												+ "~r~nMatriz: " + ls_matriz &
												+ "~r~nTipo Mov: " + ls_tipo_mov &
												+ "~r~nSub Categoría: " + ls_sub_cat, StopSign!)
					this.object.matriz[al_row] = gnvo_app.is_null
					return 
				end if		
				
			end if
			
			this.object.matriz	[al_row] = ls_matriz
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma MATRIZ CONTABLE para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.matriz	[ll_row] = ls_matriz
					yield()
				next
			end if	
				
			this.ii_update = 1
		END IF
		
	case 'centro_benef'
		ls_sql = "SELECT centro_benef AS CODIGO_CenBef, " &
				  + "desc_centro AS DESCRIPCION_centro_benef " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1' " 
					 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case 'nro_pallet'
		ls_cod_art = this.object.cod_Art [al_row]
		ls_almacen = dw_master.object.almacen [1]
		
		ls_sql = "select vw.nro_pallet as nro_pallet, " &
				 + "       vw.anaquel as anaquel, " &
				 + "       vw.fila as fila, " &
				 + "       vw.columna as columna, " &
				 + "       vw.nro_lote as nro_lote, " &
				 + "       vw.saldo, " &
				 + "       vw.saldo_und2 " &
				 + "from vw_alm_pallet_ubicacion vw " &
				 + "where vw.cod_art    = '" + ls_cod_art + "'" &
				 + "  and vw.almacen 	= '" + ls_almacen + "' "
					 
		if f_lista_5ret(ls_sql, ls_nro_pallet, ls_anaquel, ls_fila, ls_columna, ls_nro_lote, '2') then
			this.object.nro_pallet	[al_row] = ls_nro_pallet
			this.object.anaquel		[al_row] = ls_anaquel
			this.object.columna		[al_row] = ls_fila
			this.object.fila			[al_row] = ls_columna
			this.object.nro_lote		[al_row] = ls_nro_lote
			this.ii_update = 1
		end if		
end choose

// Evalua presupuesto.
if of_verifica_pta_prsp(al_row) = 0 then
	return 
end if

ll_mes 	= MONTH( DATE(dw_master.object.fec_registro[dw_master.getrow()]))
ll_year	= YEAR( DATE( dw_master.object.fec_registro[dw_master.getrow()]))

IF f_afecta_presup(ll_mes, ll_year, is_cencos, is_cnta_prsp, 0) = 0 THEN
  MessageBox( "Aviso", 'No tiene presupuesto suficiente')
  this.object.cnta_prsp[al_row] = gnvo_app.is_null
  is_cnta_prsp = ''
  this.setcolumn( 'cnta_prsp')
  this.setfocus()
end if

end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

type gb_1 from groupbox within w_al302_mov_almacen
integer x = 55
integer y = 1676
integer width = 3383
integer height = 144
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldos"
end type

type cb_codigo_barra from commandbutton within w_al302_mov_almacen
integer x = 3346
integer y = 416
integer width = 457
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Codigo Barras"
end type

event clicked;parent.event ue_print_codigo_barras()
end event

type dw_master from u_dw_abc within w_al302_mov_almacen
event ue_display ( string as_columna,  long al_row )
integer y = 104
integer width = 3845
integer height = 1036
integer taborder = 40
string dataobject = "d_abc_vale_mov_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
integer ii_sort = 1
end type

event ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_data2, ls_factor_saldo_total, ls_mensaje
Long		ll_count

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		select count(*)
			into :ll_count
		from almacen_user
		where cod_usr = :gs_user;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
			return
		end if
		
		if ll_count = 0 then
			ls_sql = "SELECT almacen AS CODIGO_almacen, " &
					  + "desc_almacen AS descripcion_almacen, " &
					  + "flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen " &
					  + "where cod_origen = '" + gs_origen + "' " &
					  + "and flag_estado = '1' " &
					  + "and flag_tipo_almacen <> 'O' " &
					  + "order by almacen " 
		else
			ls_sql = "SELECT al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "al.flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "     almacen_user au " &
					  + "where al.almacen = au.almacen " &
					  + "  and au.cod_usr = '" + gs_user + "'" &
					  + "  and al.cod_origen = '" + gs_origen + "' " &
					  + "  and al.flag_estado = '1' " &
					  + "  and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		end if			

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.almacen				[al_row] = ls_codigo
			this.object.desc_almacen		[al_row] = ls_data
			this.object.flag_tipo_almacen	[al_row] = ls_data2
			this.ii_update = 1
		end if
		
		return
	
	case "vendedor"

		ls_sql = "select t.cod_usr as codigo_vendedor, " &
				 + "t.nombre as nombre_vendedor " &
				 + "from usuario t, " &
				 + "vendedor v " &
				 + "where t.cod_usr = v.vendedor " &
				 + "  and t.flag_estado = '1' " &
				 + "  and v.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.vendedor			[al_row] = ls_codigo
			this.object.nom_vendedor	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_mov"
		ls_almacen = this.object.almacen[al_row]
		
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', 'No ha ingresado el almacen', StopSign!)
			this.SetColumn('almacen')
			return
		end if
		
		ls_sql = "select a.tipo_mov as codigo_tipo_mov, " &
				 + "a.desc_tipo_mov as descripcion_tipo_mov, " &
				 + "a.tipo_mov_dev as tipo_mov_devolucion, " &
				 + "a.factor_sldo_total as factor_saldo_total " &
				 + "from articulo_mov_tipo a, " &
				 + "almacen_tipo_mov b " &
				 + "where a.tipo_mov = b.tipo_mov " &
				 + "and a.flag_estado = '1' " &
				 + "and nvl(a.factor_sldo_consig,0) = 0 " &
				 + "and nvl(a.factor_sldo_pres,0) = 0 " &
				 + "and nvl(a.factor_sldo_dev,0) = 0 " &
				 + "and nvl(a.flag_ajuste_valorizacion,'0') = '0' " &
 				 + "and b.almacen = '" + ls_almacen + "' " &
				 + "order by a.tipo_mov"

		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, is_tipo_mov_dev, ls_factor_saldo_total, '2') then
			this.object.tipo_mov  [al_row] = ls_codigo
			
			if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
				if is_tipo_mov_dev = ls_codigo then
					Messagebox('Aviso','Tipo de movimiento no puede ser devolucion de si mismo ' &
						+ '~r~nTipo de Mov	 : ' + ls_codigo &
						+ '~r~nTipo de Mov Dev: ' + is_tipo_mov_dev )
						
					this.Object.tipo_mov				[al_row] = gnvo_app.is_null
					this.object.desc_tipo_mov 		[al_row] = gnvo_app.is_null
					this.object.factor_sldo_total [al_row] = gnvo_app.il_null
					this.setcolumn( "tipo_mov" )
					this.setfocus()
					RETURN 
				end if
			end if
		
			// Evalua datos segun tipo de mov.
			if of_tipo_mov(ls_codigo)  = 0 then 
				this.object.tipo_mov 		[al_row] = gnvo_app.is_null
				this.object.desc_tipo_mov 	[al_row] = gnvo_app.is_null
				return 
			end if
			
			this.object.tipo_mov				[al_row] = ls_codigo
			this.object.desc_tipo_mov		[al_row] = ls_data
			this.object.factor_sldo_total	[al_row] = Long(ls_factor_saldo_total)
			this.ii_update = 1

			this.object.tipo_mov.background.color = RGB(192,192,192)   
			this.object.tipo_mov.protect = 1

		end if
		
		return
	
	case "proveedor"
		ls_sql = "SELECT proveedor AS codigo_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "job"
		ls_sql = "SELECT job AS codigo_job, " &
				  + "descripcion AS descripcion_job " &
				  + "FROM job " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.job		[al_row] = ls_codigo
			this.object.desc_job	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "tipo_doc_int"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_int	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_doc_ext"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_ext	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

end event

event constructor;call super::constructor;is_mastdet = 'md'	
is_dwform = 'form' // tabular form

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master
idw_det	= dw_detail
end event

event itemchanged;call super::itemchanged;Integer	li_val, li_saldo_consig, li_saldo_pres, li_saldo_dev, li_cerrado, li_factor_sldo_total, &
			li_dias_atrazo
string 	ls_nombre, ls_mensaje, ls_desc, ls_almacen, ls_flag_tipo_almacen
dateTime	ldt_today
Date		ld_Fec_produccion
Long		ll_count

try 
	This.AcceptText()
	if row = 0 then return
	if dw_master.GetRow() = 0 then return
	
	ldt_today = gnvo_app.of_fecha_Actual()
	
	CHOOSE CASE lower(dwo.name)
		CASE 'fec_registro'
			
			idt_fec_registro 	= this.object.fec_registro				[row]
			ld_fec_produccion = Date( this.object.fec_produccion	[row] )
			
			if idt_fec_registro > ldt_today then
				gnvo_app.of_mensaje_error("La fecha del movimiento de almacen no puede ser mayor que la actual" &
												+ "~r~nFecha Actual: " + string(ldt_today, 'dd/mm/yyyy hh:mi:ss') &
												+ "~r~nFecha Ingresada: " + string(idt_fec_registro, 'dd/mm/yyyy hh:mi:ss'))
				
				this.object.fec_registro[row] = ldt_today
				idt_fec_registro = ldt_today
				
				return 1
			end if
			
			//Valido los dias hacia atras
			if gnvo_app.of_get_parametro("ALM_VALIDAR_DIAS_ATRAZO", "0") = "1" then

				select trunc(sysdate) - trunc(:idt_fec_registro)
					into :li_dias_atrazo
				from dual;
				
				if li_dias_atrazo > gnvo_app.of_get_parametro("ALM_DIAS_ATRAZO", 4) then
					gnvo_app.of_mensaje_error("La fecha de ingreso " + string(idt_fec_registro, 'dd/mm/yyyy') &
													+ " no puede tener " + string(li_dias_atrazo) &
													+ " dias de trazo con respecto a la fecha actual.")
					
					this.object.fec_registro[row] = ldt_today
					idt_fec_registro = ldt_today
				
					return 1
				end if
				
			end if
			
			//Verifico si la fecha esta cerrada o no existe
			li_cerrado =  invo_cntbl.of_cierre_almacen( date(idt_fec_registro))
			
			if li_cerrado = -1 or li_cerrado = 0 then
				if li_cerrado = -1 then
					gnvo_app.of_mensaje_error("La fecha Ingresada " + string(date(idt_fec_registro), 'dd/mm/yyyy') &
													+ " no esta en un periodo válido para contabilidad. " &
													+ "Por favor coordinar con CONTABILIDAD y verifique!")
				else
					gnvo_app.of_mensaje_error("La fecha Ingresada " + string(date(idt_fec_registro), 'dd/mm/yyyy') &
													+ " esta en un periodo cerrado por contabilidad. " &
													+ "Por favor coordinar con CONTABILIDAD y verifique!")
				end if
				
				this.object.fec_registro [row] = ldt_today
				return 1
			end if
			
			// Verifica tipo de cambio
			in_tipo_cambio = f_get_tipo_cambio( Date(idt_fec_registro) )
			if in_tipo_cambio = 0 THEN 
				
				// Cojo el ultimo tipo de cambio de la tabla logparam
				Select ult_tipo_cam
					into :in_tipo_cambio 
				from logparam
				where reckey = '1';
				
				
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'No hay parametros en LogParam')
					return 1
				end if
				
				if in_tipo_cambio = 0 or IsNull(in_tipo_cambio) then
					MessageBox('Aviso', 'El ultimo tipo de cambio en LogParam es cero o nulo')
					return 1
				end if
				
			end if		
			
			if Date(idt_fec_registro) < ld_fec_produccion then
				MessageBox('Aviso', 'La fecha de registro no puede ser menor a la fecha de producción, se actualizara la fec de produccion', Information!)
				this.object.fec_produccion[row] = Date(idt_fec_registro)
			end if

		CASE 'fec_produccion'
			
			ld_fec_produccion = Date(this.object.fec_produccion[row])
			
			if ld_fec_produccion > Date(ldt_today) then
				gnvo_app.of_mensaje_error("La fecha del produccion no puede ser mayor que la actual" &
												+ "~r~nFecha Actual: " + string(ldt_today, 'dd/mm/yyyy hh:mi:ss') &
												+ "~r~nFecha Produccion: " + string(ld_fec_produccion, 'dd/mm/yyyy'))
				
				this.object.fec_produccion[row] = Date(ldt_today)
				
				return 1
			end if
			
			//Valido los dias hacia atras
			if gnvo_app.of_get_parametro("ALM_VALIDAR_DIAS_ATRAZO_FEC_PRODUCCION", "0") = "1" then

				select trunc(sysdate) - trunc(:ld_fec_produccion)
					into :li_dias_atrazo
				from dual;
				
				if li_dias_atrazo > gnvo_app.of_get_parametro("ALM_DIAS_ATRAZO_FEC_PRODUCCION", 4) then
					gnvo_app.of_mensaje_error("La fecha de produccion " + string(ld_fec_produccion, 'dd/mm/yyyy') &
													+ " no puede tener " + string(li_dias_atrazo) &
													+ " dias de trazo con respecto a la fecha actual.")
					
					this.object.fec_produccion[row] = Date(ldt_today)
				
					return 1
				end if
				
			end if
			
			//Verifico si la fecha esta cerrada o no existe
			li_cerrado =  invo_cntbl.of_cierre_almacen( date(ld_fec_produccion))
			
			if li_cerrado = -1 or li_cerrado = 0 then
				if li_cerrado = -1 then
					gnvo_app.of_mensaje_error("La fecha Produccion " + string(date(ld_fec_produccion), 'dd/mm/yyyy') &
													+ " no esta en un periodo válido para contabilidad. " &
													+ "Por favor coordinar con CONTABILIDAD y verifique!")
				else
					gnvo_app.of_mensaje_error("La fecha Produccion " + string(date(ld_fec_produccion), 'dd/mm/yyyy') &
													+ " esta en un periodo cerrado por contabilidad. " &
													+ "Por favor coordinar con CONTABILIDAD y verifique!")
				end if
				
				this.object.fec_registro [row] = ldt_today
				return 1
			end if
			
			
		CASE 'almacen'
			select count(*)
				into :ll_count
			from almacen_user
			where cod_usr = :gs_user;
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
				return
			end if
			
			if ll_count = 0 then
				SELECT desc_almacen, flag_tipo_almacen
					INTO :ls_desc, :ls_flag_tipo_almacen
				FROM almacen
				WHERE  almacen = :data
				  and flag_estado = '1'
				  and cod_origen = :gs_origen
				  and flag_tipo_almacen <> 'O'; 
				  
				IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
					if SQLCA.SQLCode = 100 then
						Messagebox('Aviso','Codigo de almacen ' + data + ' no existe, ' &
							+ 'no esta activo, no le corresponde a su origen, ' &
							+ 'o es ALMACEN DE TRÁNSITO, por favor verifique')
					else
						MessageBox('Aviso', SQLCA.SQLErrText)
					end if
					this.Object.almacen				[row] = gnvo_app.is_null
					this.object.desc_almacen		[row] = gnvo_app.is_null
					this.object.flag_tipo_almacen	[row] = gnvo_app.is_null
					this.setcolumn( "almacen" )
					this.setfocus()
					RETURN 1
				END IF
			else
				SELECT al.desc_almacen, al.flag_tipo_almacen
					INTO :ls_desc, :ls_flag_tipo_almacen
				FROM almacen al,
					  almacen_user au
				WHERE al.almacen 		= au.almacen
				  and au.cod_usr 		= :gs_user
				  and al.almacen 		= :data
				  and al.flag_estado = '1'
				  and al.cod_origen 		= :gs_origen
				  and al.flag_tipo_almacen <> 'O'; 
				  
				IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
					if SQLCA.SQLCode = 100 then
						Messagebox('Aviso','Codigo de almacen ' + data + ' no existe, ' &
									+ 'no esta activo, no le corresponde a su origen, ' &
									+ 'o no tiene asignado el almacen ' &
									+ 'o es ALMACEN DE TRÁNSITO, por favor verifique')
					else
						MessageBox('Aviso', SQLCA.SQLErrText)
					end if
					this.Object.almacen				[row] = gnvo_app.is_null
					this.object.desc_almacen		[row] = gnvo_app.is_null
					this.object.flag_tipo_almacen	[row] = gnvo_app.is_null
					this.setcolumn( "almacen" )
					this.setfocus()
					RETURN 1
				END IF
			end if
			
			this.object.desc_almacen 		[row] = ls_desc
			this.object.flag_tipo_almacen	[row] = ls_flag_tipo_almacen
	
		CASE 'vendedor'
			
			// Verifica que codigo ingresado exista			
			Select nombre
			  into :ls_desc
			  from usuario
			 Where cod_usr = :data  
				and flag_estado = '1';
				
			// Verifica que articulo solo sea de reposicion		
			if SQLCA.SQlCode = 100 then
				ROLLBACK;
				MessageBox("Error", "Código de Vendedor no existe o no se encuentra activo, por favor verifique")
				this.object.vendedor			[row] = gnvo_app.is_null
				this.object.nom_vendedor	[row] = gnvo_app.is_null
				return 1
				
			end if
	
			this.object.nom_vendedor		[row] = ls_desc
	
			
		CASE 'tipo_mov'
			ls_almacen = dw_master.object.almacen [dw_master.GetRow()]
			
			if of_tipo_mov(data)  = 0 then // Evalua datos segun tipo de mov.
				this.object.tipo_mov[row] = gnvo_app.is_null
				RETURN 1
			end if
			
			SELECT 	a.desc_tipo_mov, 		a.factor_sldo_consig,
						a.factor_sldo_dev,	a.factor_sldo_pres,
						a.tipo_mov_dev,		a.factor_sldo_total
				INTO 	:ls_nombre,				:li_saldo_consig,
						:li_saldo_pres,		:li_saldo_dev,
						:is_tipo_mov_dev,		:li_factor_sldo_total
			FROM  articulo_mov_tipo a,
					almacen_tipo_mov  b
			WHERE a.tipo_mov 		= b.tipo_mov
			  and a.flag_estado 	= '1'
			  and a.tipo_mov 		= :data 
			  and b.almacen 		= :ls_almacen;
			
			IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
				if SQLCA.SQLCOde = 100 then
					Messagebox('Aviso','Tipo de Movimiento no existe, no esta activo ' &
						+ 'o no le corresponde al almacen')
				else
					MessageBox('Aviso', SQLCA.SQLErrText)
				end if
				
				this.Object.tipo_mov				[row] = gnvo_app.is_null
				this.object.desc_tipo_mov 		[row] = gnvo_app.is_null
				this.object.factor_sldo_total [row] = gnvo_app.il_null
				this.setcolumn( "tipo_mov" )
				this.setfocus()
				RETURN 1
			END IF
			
			if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
				if is_tipo_mov_dev = data then
					Messagebox('Aviso','Tipo de movimiento no puede ser devolucion de si mismo ' &
						+ '~r~nTipo de Mov	 : ' + data &
						+ '~r~nTipo de Mov Dev: ' + is_tipo_mov_dev )
						
					this.Object.tipo_mov				[row] = gnvo_app.is_null
					this.object.desc_tipo_mov 		[row] = gnvo_app.is_null
					this.object.factor_sldo_total [row] = gnvo_app.il_null
					this.setcolumn( "tipo_mov" )
					this.setfocus()
					RETURN 1
				end if
			end if
			
			if li_saldo_consig <> 0 then
				Messagebox('Aviso','El movimiento x consignacion no se maneja por esta ventana, ' &
							+ 'Tiene que ir a la opcion de consignaciones')
				this.Object.tipo_mov				[row] = gnvo_app.is_null
				this.object.desc_tipo_mov 		[row] = gnvo_app.is_null
				this.object.factor_sldo_total [row] = gnvo_app.il_null
				this.setcolumn( "tipo_mov" )
				this.setfocus()
				RETURN 1
			end if
	
			if li_saldo_pres <> 0 or li_saldo_dev <> 0 then
				Messagebox('Aviso','El movimiento x Prestamos o Devoluciones no se maneja ' &
							+ 'por esta ventana, Tiene que ir a la opcion de ' &
							+ 'prestamos/devoluciones' )
				this.Object.tipo_mov				[row] = gnvo_app.is_null
				this.object.desc_tipo_mov 		[row] = gnvo_app.is_null
				this.object.factor_sldo_total [row] = gnvo_app.il_null
				this.setcolumn( "tipo_mov" )
				this.setfocus()
				RETURN 1
			end if
	
			this.object.desc_tipo_mov		[row] = ls_nombre
			this.object.factor_sldo_total [row] = li_factor_sldo_total
			this.object.tipo_mov.background.color = RGB(192,192,192)   
			this.object.tipo_mov.protect = 1
			
		CASE 'proveedor'
	
			SELECT NOM_PROVEEDOR 
				INTO :ls_nombre 
			FROM proveedor
			WHERE  PROVEEDOR = :data 
			  and flag_estado = '1';
			  
			IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
				if SQLCA.SQLCOde = 100 then
					Messagebox('Aviso','Codigo de Proveedor no existe, no esta activo ')
				else
					MessageBox('Aviso', SQLCA.SQLErrText)
				end if
				this.Object.Proveedor		[row] = gnvo_app.is_null
				this.object.nom_proveedor	[row] = gnvo_app.is_null
				this.setcolumn( "proveedor")
				this.setfocus()
				RETURN 1
			END IF
			
			this.object.nom_proveedor [row] = ls_nombre
			
		CASE 'tipo_doc_int'
			
			SELECT desc_tipo_doc 
				INTO :ls_desc 
			FROM doc_tipo
			WHERE  tipo_doc = :data ;
			
			IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
				if SQLCA.SQLCOde = 100 then
					Messagebox('Aviso','Tipo de Documento Interno no existe ')
				else
					MessageBox('Aviso', SQLCA.SQLErrText)
				end if
				this.Object.tipo_doc_int[row] = gnvo_app.is_null
				this.setcolumn( "tipo_doc_int" )
				this.setfocus()
				RETURN 1
			END IF
			
		CASE 'tipo_doc_ext'
			
			SELECT desc_tipo_doc 
				INTO :ls_desc 
			FROM doc_tipo
			WHERE  tipo_doc = :data ;
			
			IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
				if SQLCA.SQLCOde = 100 then
					Messagebox('Aviso','Tipo de Documento Externo no existe ')
				else
					MessageBox('Aviso', SQLCA.SQLErrText)
				end if
				this.Object.tipo_doc_ext[row] = gnvo_app.is_null
				this.setcolumn( "tipo_doc_ext" )
				this.setfocus()
				RETURN 1
			END IF
			
	END CHOOSE


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')

end try


end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String 	ls_codart[]
Long 		ll_row, ll_ano, ll_mes
dateTime	ldt_today

ldt_today = gnvo_app.of_fecha_actual()

this.Object.p_logo.filename = gs_logo

this.object.cod_origen  	[al_row] = gs_origen
this.object.flag_estado 	[al_row] = '1'		// Activo
this.object.cod_usr     	[al_row] = gs_user
this.object.fec_registro	[al_row] = ldt_today
this.object.fec_produccion	[al_row] = date(ldt_today)

if is_mod_fecha = '0' then
	// Inhabilito la fecha de registro
	this.object.fec_registro.protect = 1
	this.object.fec_registro.background.color = RGB(192,192,192)
	
	//this.object.b_fecha.visible = 0
	this.object.b_fecha.Enabled = 'No'
	
else
	// Como esta habilitado el campo simplemente me ubico en el
	this.SetColumn('fec_registro')
	
	//this.object.b_fecha.visible = 1
	this.object.b_fecha.Enabled = 'Yes'
end if

is_solicita_ref = '0'
is_action = 'new'

ll_ano = YEAR( DATE(ldt_today))
ll_mes = MONTH( DATE(ldt_today))

// Busca si esta cerrado contablemente	
ii_cerrado = invo_cntbl.of_cierre_almacen( Date(ldt_today))  

if ii_cerrado = 0 then
	this.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
else
	this.object.t_cierre.text = ''
end if 

this.object.tipo_mov.background.color = RGB(255,255,255)
this.object.tipo_mov.protect = 0
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc( THIS)

end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          ls_boton, ls_nro_vale, ls_origen, ls_tipo_mov
long				 ll_row
DateTime			 ldt_fec_reg	
str_parametros 	 sl_param

If this.Describe("almacen.Protect") = '1' then RETURN

ls_boton = dwo.name
ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]

select amt.tipo_mov_dev, nvl(amt.flag_solicita_ref, '0')
	into :is_tipo_mov_dev, :is_solicita_ref
from articulo_mov_tipo amt
where tipo_mov = :ls_tipo_mov;


if ls_boton = 'b_ref' then	
	if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
		parent.of_mov_devol_alm(ls_tipo_mov)
		return
	end if
	
	IF is_solicita_ref = '0' then
		MessageBox('Aviso', 'El tipo de Movimiento no piede referencia', StopSign!)
		Return
	END IF	
	
	of_referencia_mov(ls_tipo_mov)	
	
elseif ls_boton = 'b_fecha' then
	
	if dw_master.GetRow() = 0 then return
	
	if dw_master.object.flag_estado[dw_master.GetRow()] = '0' then
		MessageBox('Aviso', 'No puede modificar fecha en Movimiento de Almacen, porque esta anulado')
		return
	end if
	
	if is_action = 'new' then 
		MessageBox('Aviso', 'Para modificar la fecha tiene que grabar primero el movimiento de almacen')
		return
	end if
	
	ls_nro_vale = dw_master.object.nro_vale[dw_master.GetRow()]
	ls_origen   = dw_master.object.cod_origen[dw_master.GetRow()]
	
	if IsNull(ls_nro_vale) or ls_nro_vale = '' then return
	if IsNull(ls_origen) or ls_origen = '' then return
	
	ldt_fec_reg = dw_master.object.fec_registro[dw_master.GetRow()]
	
	if IsNull(ldt_fec_reg) then return
	
	if MessageBox('Aviso', 'Desea usted Modificar la fecha del Movimiento de Alamcen?', &
					Information!, YesNo!, 1) = 2 then return
	
	sl_param.string1 	 = ls_origen
	sl_param.string2 	 = ls_nro_vale
	sl_param.DateTime1 = ldt_fec_reg
	OpenWithParm(w_al906_mod_fec_mov_alm, sl_param)
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	if Message.PowerObjectParm.ClassName() <> 'str_parametros' then return
	
	sl_param = Message.PowerObjectParm
	
	if sl_param.titulo = 'n' then return
	
	of_retrieve(ls_nro_vale)
	
end if

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

