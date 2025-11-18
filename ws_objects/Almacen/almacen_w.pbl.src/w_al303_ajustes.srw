$PBExportHeader$w_al303_ajustes.srw
forward
global type w_al303_ajustes from w_abc
end type
type st_nro from statictext within w_al303_ajustes
end type
type cb_1 from commandbutton within w_al303_ajustes
end type
type sle_nro from u_sle_codigo within w_al303_ajustes
end type
type em_prom_dol from editmask within w_al303_ajustes
end type
type em_saldo from editmask within w_al303_ajustes
end type
type em_prom_sol from editmask within w_al303_ajustes
end type
type st_3 from statictext within w_al303_ajustes
end type
type st_2 from statictext within w_al303_ajustes
end type
type st_1 from statictext within w_al303_ajustes
end type
type dw_detail from u_dw_abc within w_al303_ajustes
end type
type dw_master from u_dw_abc within w_al303_ajustes
end type
type gb_1 from groupbox within w_al303_ajustes
end type
end forward

global type w_al303_ajustes from w_abc
integer width = 3758
integer height = 2192
string title = "Ajustes al movimiento (AL303)"
string menuname = "m_mov_almacen"
boolean minbox = false
windowstate windowstate = maximized!
event ue_anular ( )
event ue_cancelar ( )
event ue_preview ( )
st_nro st_nro
cb_1 cb_1
sle_nro sle_nro
em_prom_dol em_prom_dol
em_saldo em_saldo
em_prom_sol em_prom_sol
st_3 st_3
st_2 st_2
st_1 st_1
dw_detail dw_detail
dw_master dw_master
gb_1 gb_1
end type
global w_al303_ajustes w_al303_ajustes

type variables
// Tipos de movimiento
String 		is_ing_venta, is_vnta_terc, is_cons_interno, &
				is_mov_consig, is_dev_prestamo, is_rep_merc_dev, &
				is_cencos, is_cnta_prsp, is_salir = 'N', &
				is_contab, is_ref, is_flag_matriz_contab, is_dolares
Int 			ii_ref
Long			il_afecta_pto
dataStore 	ids_print
DATETIME 	idt_fecha_proc
Decimal 		idc_tipo_cambio

end variables

forward prototypes
public function integer of_set_numera ()
public function integer of_evalua_saldos (integer al_row)
public function integer of_get_param ()
public function integer of_set_articulo (string as_articulo, string as_almacen)
public function integer of_set_costo_promedio (integer an_ano, integer an_mes, string as_almacen, string as_cod_art)
public function integer of_get_datos ()
public function integer of_get_datos_det ()
public function integer of_set_status_doc (datawindow idw)
public subroutine of_set_evalua_flag ()
public function integer of_tipo_mov (string as_tipo_mov)
public subroutine of_verifica_mov (string as_data)
public subroutine of_retrieve (string as_nro)
end prototypes

event ue_anular;Integer j
Long ll_row, ll_ano, ll_mes
String ls_alm

IF dw_master.rowcount() = 0 then 
	MessageBox('Error', 'El vale de ajuste no tiene cabecera, no se pueda anular', StopSign!)
	return
end if

IF dw_master.ii_update = 1 or dw_detail.ii_update = 1 then 
	MessageBox('Error', 'Este Vale de Ajuste tiene cambios pendientes por grabar, Grabe primero y luego anule', StopSign!)
	return
end if

// Lee detalle
ll_row = dw_master.getrow()
dw_detail.retrieve(dw_master.object.cod_origen[1], dw_master.object.nro_vale[1])

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

ls_alm		= dw_master.object.almacen[dw_master.getrow()]
ll_ano		= YEAR( DATE(dw_master.object.fec_registro[dw_master.getrow()]))
ll_mes		= MONTH( DATE(dw_master.object.fec_registro[dw_master.getrow()]))

// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1

// Anulando Detalle
for j = 1 to dw_detail.rowCount()	
//	of_set_costo_promedio( ll_ano, ll_mes, ls_alm, dw_detail.object.cod_art[j])
	dw_detail.object.flag_estado[j] = '0'
	dw_detail.object.cant_procesada[j] = 0
	dw_detail.object.precio_unit[j] = 0
next

dw_detail.ii_update = 1
is_action = 'anu'
//of_tipo_mov(dw_master.object.tipo_mov[dw_master.getrow()])
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

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 = 'd_frm_ajuste_valorizacion'
lstr_rep.titulo = 'Previo de Movimiento de almacen'
lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_vale[dw_master.getrow()]

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

public function integer of_set_numera ();Long ll_nro, j, ll_long
String ls_nro, ls_table, ls_mensaje

// Numera documento
if is_action = 'new' then	
	ls_table = 'LOCK TABLE NUM_VALE_MOV IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_nro 
	from num_vale_mov 
	where origen = :gs_origen;
	
	if SQLCA.SQLCode = 100 then
		Insert into num_vale_mov(origen, ult_nro)
		values (:gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		ll_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = String( ll_nro)	
	ll_long = 10 - len( TRIM( gs_origen))
   ls_nro = TRIM( gs_origen) + f_llena_caracteres('0',Trim(ls_nro),ll_long) 		
	dw_master.object.nro_vale[dw_master.getrow()] = ls_nro
	
	// Incrementa contador
	Update num_vale_mov 
		set ult_nro = ult_nro + 1 
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
else 
	ls_nro = dw_master.object.nro_vale[dw_master.getrow()] 
end if

// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_vale[j] = ls_nro
next

return 1
end function

public function integer of_evalua_saldos (integer al_row);String ls_tipo_mov, ls_cod_art, ls_almacen, ls_origen, ls_mov_sal_consig
Int li_sldo_total, li_sldo_llegar, li_sldo_sol, li_sldo_dev, li_sldo_pres, li_sldo_consig
Long ln_nro_mov_proy, ll_nro_mov  
Decimal{2} ld_cant, ld_cant_dig, ld_saldo_act

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]
ls_almacen  = dw_master.object.almacen[dw_master.getrow()]

dw_detail.AcceptText()
Select factor_sldo_total, factor_sldo_x_llegar, factor_sldo_sol, factor_sldo_dev, 
	factor_sldo_pres, factor_sldo_consig
   into :li_sldo_total, :li_sldo_llegar, :li_sldo_sol, :li_sldo_dev, :li_sldo_pres, 
			:li_sldo_consig
	from articulo_mov_tipo where tipo_mov = :ls_tipo_mov;

Select sal_cons_consig into :ls_mov_sal_consig from logparam where reckey = '1';

//FOR j = 1 to dw_detail.RowCount()
	ls_cod_art  = dw_detail.object.cod_art[al_row]
	ld_cant_dig = dw_detail.object.cant_procesada[al_row]	
	
	// Que cantidad no sea cero
	if dw_detail.object.cant_procesada[al_row] = 0 then
		Messagebox( "Atencion", "Cantidad no puede ser cero")
		dw_detail.SetColumn( "Cant_procesada")
		dw_detail.setFocus()
		return 0
	end if
	
	// Salidas
	IF li_sldo_total = -1 then			
		// Consignacion
		IF ls_tipo_mov = ls_mov_sal_consig then
			// Verifica que cantidad ingresada no pase la del saldo en consignacion
			ls_origen  = dw_detail.object.cod_origen[al_row]
			ll_nro_mov = dw_detail.object.nro_mov_proy[al_row]
			SELECT cant_recibida - cant_consumida 
				into :ld_saldo_act 
			from articulo_consignacion
		   Where cod_origen = :ls_origen and nro_mov = :ll_nro_mov;			
			
			
		   IF ld_saldo_act = 0 THEN
				Messagebox('Error','Saldo Actual de ' + ls_cod_art + 'es 0 Verifique!')			
				Return 0
			ELSEIF ld_cant_dig > ld_saldo_act THEN
				Messagebox('Aviso','Cantidad a Procesar No Puede Exceder al Saldo Actual~r~nSaldo Actual: ' + &
	   	 	String (ld_saldo_act,'#0.0000'), exclamation!)
				dw_detail.object.cant_procesada[al_row] = 0
				Return 0
			END IF			
		else
			// Verifica saldos
			SELECT Nvl(sldo_total,0)
				INTO   :ld_saldo_act
				FROM   articulo_almacen
				WHERE  almacen = :ls_almacen AND cod_art = :ls_cod_Art; 
			IF ld_saldo_act = 0 THEN
				Messagebox('Error','Saldo Actual de ' + ls_cod_art + 'es 0 Verifique!')
				Return 0
			ELSEIF ld_cant_dig > ld_saldo_act THEN
				Messagebox('Aviso','Cantidad a Procesar No Puede Exceder al Saldo Actual~r~nSaldo Actual: ' + &
	   	 	String (ld_saldo_act,'#0.0000'), exclamation!)
				dw_detail.object.cant_procesada[al_row] = 0
				Return 0
			END IF		
		END IF
	End if
	
	// Ingreso de Devolucion de prestamo
	// =================================
	IF li_sldo_pres = -1  then
		ls_origen  = dw_detail.object.cod_origen[al_row]
		ll_nro_mov = dw_detail.object.nro_mov_proy[al_row]
		SELECT cant_prestada - cant_devuelta into :ld_saldo_act from articulo_prestamo
		  Where cod_origen = :ls_origen and nro_mov = :ll_nro_mov;
		IF ld_saldo_act = 0 THEN
			Messagebox('Error sldo_total -1','Saldo Actual de ' + ls_cod_art + 'es 0 Verifique!')			
			Return 0
		ELSEIF ld_cant_dig > ld_saldo_act THEN
			Messagebox('Aviso','Cantidad a Procesar No Puede Exceder al Saldo Actual~r~nSaldo Actual: ' + &
	   	 String (ld_saldo_act,'#0.0000'), exclamation!)
			dw_detail.object.cant_procesada[al_row] = 0
			Return 0
		END IF
	END IF
	
	// Ingreso por reposicion mercaderia devuelta
	// ==========================================
	IF li_sldo_dev = -1  then
		ls_origen  = dw_detail.object.cod_origen[al_row]
		ll_nro_mov = dw_detail.object.nro_mov_proy[al_row]
		SELECT cant_devuelta - cant_retornada into :ld_saldo_act from articulo_devolucion
		  Where cod_origen = :ls_origen and nro_mov = :ll_nro_mov;
		IF ld_saldo_act = 0 THEN
			Messagebox('Error sldo_total -1','Saldo Actual de ' + ls_cod_art + 'es 0 Verifique!')			
			Return 0
		ELSEIF ld_cant_dig > ld_saldo_act THEN
			Messagebox('Aviso','Cantidad a Procesar No Puede Exceder al Saldo Actual~r~nSaldo Actual: ' + &
	   	 String (ld_saldo_act,'#0.0000'), exclamation!)
			dw_detail.object.cant_procesada[al_row] = 0
			Return 0
		END IF
	END IF
//Next

return 1
end function

public function integer of_get_param ();// Evalua parametros
Int li_ret = 1
Date ld_fec

// busca tipos de movimiento definidos
SELECT 	oper_ing_oc, oper_cons_interno, oper_vnta_terc, 
    		sal_cons_consig, dev_prestamo, rep_merc_dev, fecha_proceso,
			flag_matriz_contab
	INTO 	:is_ing_venta, :is_cons_interno, :is_vnta_terc, :is_mov_consig,
	  		:is_dev_prestamo, :is_rep_merc_dev, :ld_fec, :is_flag_matriz_contab
FROM logparam logp 
where reckey = '1';

if sqlca.sqlcode <> 0 then
	Messagebox( "Error", sqlca.sqlerrtext)
	li_ret = 0	
end if


if ISNULL( is_ing_venta ) or TRIM( is_ing_venta) = '' then
	Messagebox("Error", "Defina codigo (oper_ing_oc) en logparam")
	li_ret = 0	  // Fallo
end if
if ISNULL( is_cons_interno) or TRIM( is_cons_interno) = '' then
	Messagebox("Error", "Defina codigo (oper_cons_interno) en logparam")
	li_ret = 0	  // Fallo
end if
if ISNULL( is_vnta_terc) or TRIM( is_vnta_terc) = '' then
	Messagebox("Error", "Defina codigo (oper_vnta_terc) en logparam")
	li_ret = 0	  // Fallo
end if
if ISNULL( is_mov_consig) or TRIM( is_mov_consig) = '' then
	Messagebox("Error", "Defina codigo (sal_cons_consig) en logparam")
	li_ret = 0	  // Fallo
end if
if ISNULL( is_dev_prestamo) or TRIM( is_dev_prestamo) = '' then
	Messagebox("Error", "Defina codigo (dev_prestamo) en logparam")
	li_ret = 0	  // Fallo
end if

if ISNULL( is_rep_merc_dev) or TRIM( is_rep_merc_dev) = '' then
	Messagebox("Error", "Defina codigo (rep_merc_dev) en logparam")
	li_ret = 0	  // Fallo
end if

if ISNULL( ld_Fec) or TRIM( STRING(ld_fec)) = '' then
	Messagebox("Error", "Defina fecha proceso en logparam")
	li_ret = 0	  // Fallo
end if

if ISNULL(is_flag_matriz_contab) or TRIM(is_flag_matriz_contab) = '' then
	Messagebox("Error", "Defina FLAG_MATRIZ_CONTAB en logparam")
	li_ret = 0	  // Fallo
end if

return li_ret 

end function

public function integer of_set_articulo (string as_articulo, string as_almacen);String ls_unidad, ls_desc_art, ls_und
double ld_prom_sol, ld_prom_dol, ld_saldo_total = 0

// Verifica que codigo ingresado exista			
		Select desc_art, und, costo_prom_sol, costo_prom_dol
		   into :ls_desc_art, :ls_und, :ld_prom_sol, :ld_prom_dol from articulo 
   		Where cod_Art = :as_articulo;
			
		if Sqlca.sqlcode = 100 then 
			Messagebox( "Atencion", "Codigo de articulo " + as_articulo + " no existe, por favor verifique", StopSign!)
			Return 1
		end if		

		SELECT Nvl(sldo_total,0)
		INTO   :ld_saldo_total  
		FROM   articulo_almacen
		WHERE  almacen = :as_almacen 
		  AND cod_art = :as_articulo ; 		
		
		dw_detail.object.desc_Art[dw_detail.getrow()] = ls_desc_art
		dw_detail.object.und[dw_detail.getrow()] = ls_und	
		dw_detail.object.precio_unit[dw_detail.getrow()] = ld_prom_sol
		em_saldo.text = String( ld_saldo_total) 
		em_prom_sol.text = String( ld_prom_sol)
		em_prom_dol.text = String( ld_prom_dol)		
	return 0
end function

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
dw_master.Accepttext( )

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
//	dw_master.event clicked(0,0,ll_row, dwo_1)
	return 0
end if
ls_almacen = dw_master.object.almacen[ll_row]

if isnull(dw_master.object.tipo_mov[ll_row]) then
	Messagebox( "Atencion", "Ingrese tipo movimiento")
	dw_master.setcolumn( "tipo_mov")
	dw_master.setfocus()
	return 0
end if

if ls_doc_int = '1' then
	if isnull(dw_master.object.tipo_doc_int[ll_row]) then
		messagebox( "Atencion", "Indicar tipo doc. interno")
		dw_master.Setcolumn("tipo_doc_int")
		dw_master.setfocus()
		Return 0
	end if
	if isnull(dw_master.object.nro_doc_int[ll_row]) then
		messagebox( "Atencion", "Indicar nro. doc. interno")
		dw_master.Setcolumn("nro_doc_int")
		dw_master.setfocus()
		Return 0
	end if
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

public function integer of_get_datos_det ();/* Evalua presupuesto 

   Retorna : 0, fallo
				 1, Ok.
*/
int 		j
String 	ls_cencos, ls_cnta_prsp
Long 		lpos

For j = 1 to dw_detail.RowCount()
	ls_cencos    = dw_detail.object.cencos[j]
	ls_cnta_prsp = dw_detail.object.cnta_prsp[j]
	
	if il_afecta_pto <> 0 then		
		if isnull( ls_cencos) or TRIM( ls_cencos) = '' then
			Messagebox( "Atencion", "Ingresar el centro de costo", Exclamation!)
			dw_detail.SetColumn( "cencos")
			dw_detail.setfocus()
			return 0
		end if
		
		if isnull( ls_cnta_prsp) or TRIM( ls_cnta_prsp) = '' then
			Messagebox( "Atencion", "Ingresar la cuenta presupuestal ", Exclamation!)
			dw_detail.SetColumn( "cnta_prsp")
			dw_detail.setfocus()
			return 0
		end if
	end if

next

return 1
end function

public function integer of_set_status_doc (datawindow idw);this.changemenu( m_mov_almacen)
Int li_estado
long ll_ref

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

m_master.m_file.m_printer.m_print1.enabled = true

if dw_master.getrow() = 0 then return 0

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false	
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

		IF is_ref = 'S' then			
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
		case 0		// Anulado
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false		
		is_ref = 'N'
	CASE is > 1   // Atendido con guia de remision
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
//	case else				
	end CHOOSE	
	if idw_1 = dw_detail then			
		if is_ref = 'N' then				
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
	end if
end if

if is_Action = 'anu' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled = false
end if
return 1
end function

public subroutine of_set_evalua_flag ();/*
   of_set_status_flag
	
	Establece el flag de estado cabecera
*/

String ls_flag, ls_ori, ls_nro, ls_doc_oc, ls_doc_ov, ls_doc_sc, &
   ls_tiporef, ls_nroref
Integer j, i, ln_flagp, ln_flagt
Long ln_reg, ln_nro_mov_proy

Select doc_oc, doc_ov, doc_sc 
   into :ls_doc_oc, :ls_doc_ov, :ls_doc_sc 
	from logparam where reckey = '1';

ls_ori = dw_master.object.cod_origen [dw_master.getrow()]
ls_nro = dw_master.object.nro_vale   [dw_master.getrow()]		

// Crea data store 
DataStore ds_2, Ds_1 
ds_1 = CREATE DataStore
ds_2 = CREATE DataStore

ds_1.DataObject = "d_sel_mov_movproy"
ds_1.SetTransObject(SQLCA)
ds_1.Retrieve(ls_ori, ls_nro)

ds_2.DataObject = "d_sel_flag_ocompra"
ds_2.SetTransObject(SQLCA)

// Crea
For i = 1 to ds_1.rowcount()
	ls_tiporef = ds_1.object.tipo_doc[i] 
	ls_nroref = ds_1.object.nro_doc[i] 	
	
	ds_2.Retrieve(ls_tiporef, ls_nroref)	

	ln_flagp = 0   // Parcial
	ln_flagt = 0   // Total
	ln_reg = 0		// Total registros

	// Cuando es solicitud compra
   if ls_tiporef = ls_doc_sc then
	else
		ls_flag = '1'
		for j = 1 to ds_2.Rowcount()	
			ln_reg = ln_reg + 1
//			ls_flag = ds_2.object.flag_estado[j]
			if ds_2.object.cant_procesada[j] >= ds_2.object.cant_proyect[j] then ln_flagt = ln_flagt + 1
			if ds_2.object.cant_procesada[j] < ds_2.object.cant_proyect[j]  and & 
			   ds_2.object.cant_procesada[j] > 0 then ln_flagp = ln_flagp + 1  		
		Next

		if ln_reg > 0 then
			if ln_flagt = ln_reg and ln_flagt > 0 then
				ls_flag = '3'
   		end if;
			if ln_flagt < ln_reg and ln_flagt > 0 then
      		ls_flag = '2'
			end if			
			if ln_flagp = 0 and ln_flagt = 0 then
				ls_flag = '1'
			end if
		end if		
	end if
		
   	// Actualiza tabla
		if ls_tiporef = ls_doc_oc then			
   	   Update orden_compra set flag_estado = :ls_flag
      	  where nro_oc = :ls_nroref and
			  flag_estado  in ('1','2','3') ;  
		end if
		
		if ls_tiporef = ls_doc_ov then
			
   	   Update orden_venta set flag_estado = :ls_flag
      	  where nro_ov = :ls_nroref and
			  		  flag_estado  in ('1','2','3'); 		 
						 
			
		end if
/*		if ls_tiporef = ls_doc_sc then
   	   Update sol_salida set flag_estado = :ls_flag
      	  where nro_sol_salida = :ls_nroref; 
		end if  */
//	end if
next


/*
// Crea
For i = 1 to ds_1.rowcount()
	ls_tiporef = ds_1.object.tipo_doc[i] 
	ls_nroref = ds_1.object.nro_doc[i] 	
	
	ds_2.Retrieve(ls_tiporef, ls_nroref)	

	ln_flagp = 0   // Parcial
	ln_flagt = 0   // Total
	ln_reg = 0		// Total registros

	// Cuando es solicitud compra
   if ls_tiporef = ls_doc_sc then
/*		ls_flag = '2'
		for j = 1 to ds_2.Rowcount()	  		
			ln_reg = ln_reg + 1
			ls_flag = ds_2.object.flag_estado[j]
			if ls_flag = '5' then ln_flagp = ln_flagp + 1
			if ls_flag = '4' then ln_flagt = ln_flagt + 1  		
		Next

		if ln_reg > 0 then
			if ln_flagt = ln_reg then
				ls_flag = '5'
   		end if;
			if ln_flagt < ln_reg and ln_flagt > 0 then
      		ls_flag = '4'
			end if			
			if ln_flagp = 0 and ln_flagt = 0 then
				ls_flag = '2'
			end if
		end if  */
	else
		ls_flag = '1'
		for j = 1 to ds_2.Rowcount()	
			ln_reg = ln_reg + 1
			ls_flag = ds_2.object.flag_estado[j]
			if ls_flag = '3' then ln_flagt = ln_flagt + 1
			if ls_flag = '2' then ln_flagp = ln_flagp + 1  		
		Next

		if ln_reg > 0 then
			if ln_flagt = ln_reg and ln_flagt > 0 then
				ls_flag = '3'
   		end if;
			if ln_flagt < ln_reg and ln_flagt > 0 then
      		ls_flag = '2'
			end if			
			if ln_flagp = 0 and ln_flagt = 0 then
				ls_flag = '1'
			end if
		end if		
	end if
		
   	// Actualiza tabla
		if ls_tiporef = ls_doc_oc then			
   	   Update orden_compra set flag_estado = :ls_flag
      	  where nro_oc = :ls_nroref and
			  flag_estado  in ('1','2','3') ;  
		end if
		
		if ls_tiporef = ls_doc_ov then
			
   	   Update orden_venta set flag_estado = :ls_flag
      	  where nro_ov = :ls_nroref and
			  		  flag_estado  in ('1','2','3'); 
						 
						 
			
		end if
/*		if ls_tiporef = ls_doc_sc then
   	   Update sol_salida set flag_estado = :ls_flag
      	  where nro_sol_salida = :ls_nroref; 
		end if  */
//	end if
next

*/
Commit;
DESTROY ds_1
DESTROY ds_2
end subroutine

public function integer of_tipo_mov (string as_tipo_mov);/* 
  Funcion que activa/desactiva campos segun tipo de movimiento
*/

String ls_doc_int, ls_doc_ext, ls_alm
Long ll_row, ln_count

ls_alm = dw_master.object.almacen[dw_master.getrow()]

if is_action = 'new' or is_action = 'edit' or is_action = 'anu' then	
	
	// Valida si existe tipo de movimiento
	Select count(tipo_mov) 
		into :ln_count 
	from articulo_mov_tipo 
	where tipo_mov = :as_tipo_mov;
	
	if ln_count = 0 then
		Messagebox( "Atencion", "tipo de movimiento no existe", exclamation!)		
		return 0
	end if
	
	// Valida si existe el tipo para el almacen
	Select count(tipo_mov) 
		into :ln_count 
	from almacen_tipo_mov
	where tipo_mov = :as_tipo_mov 
	  and almacen = :ls_alm;
	  
	if ln_count = 0 then
		Messagebox( "Atencion", "tipo de movimiento no existe para este almacen", exclamation!)		
		return 0
	end if
	
	ll_row = dw_master.getrow()
		// Activa/desactiva boton de referencias segun tipo de movimiento
	Select NVL(flag_solicita_doc_int, '0'), NVL(flag_solicita_doc_ext, '0'), 
			NVL(factor_presup,0), NVL(flag_contabiliza,'0')
   	into :ls_doc_int, :ls_doc_ext, :il_afecta_pto, :is_contab
	from articulo_mov_tipo
	where tipo_mov = :as_tipo_mov;		
	
	if ls_doc_int = '0' or isnull( ls_doc_int) then
			dw_master.object.tipo_doc_int.background.color = RGB(192,192,192)
			dw_master.object.nro_doc_int.background.color = RGB(192,192,192)
			dw_master.object.tipo_doc_int.protect = 1
			dw_master.object.nro_doc_int.protect = 1
			dw_master.object.tipo_doc_int[ll_row] = ''
			dw_master.object.nro_doc_int[ll_row] = ''
	else
			dw_master.object.tipo_doc_int.background.color = RGB(255,255,255)
			dw_master.object.nro_doc_int.background.color = RGB(255,255,255)
			dw_master.object.tipo_doc_int.protect = 0
			dw_master.object.nro_doc_int.protect = 0
	end if
	
	if ls_doc_ext = '0' or isnull( ls_doc_int) then
			dw_master.object.tipo_doc_ext.background.color = RGB(192,192,192)
			dw_master.object.nro_doc_ext.background.color = RGB(192,192,192)
			dw_master.object.tipo_doc_ext.protect = 1
			dw_master.object.nro_doc_ext.protect = 1
			dw_master.object.tipo_doc_ext[ll_row] = ''
			dw_master.object.nro_doc_ext[ll_row] = ''
	else
			dw_master.object.tipo_doc_ext.background.color = RGB(255,255,255)
			dw_master.object.nro_doc_ext.background.color = RGB(255,255,255)
			dw_master.object.tipo_doc_ext.protect = 0
			dw_master.object.nro_doc_ext.protect = 0
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
			MessageBox('Error', 'VALOR EN FLAG_MATRIZ_CONTAB no es valido')
			return 0
		end if
		if ln_count = 0 then
			Messagebox( "Atencion", "Tipo de movimiento no tiene matriz definida")
			return 0
		end if
	end if	   
	
	as_tipo_mov = TRIM( as_tipo_mov)
	
	if as_tipo_mov = TRIM(is_ing_venta) or as_tipo_mov = TRIM(is_vnta_terc) or &
	   as_tipo_mov = TRIM(is_cons_interno) then		
		is_ref = 'S'
		//of_verifica_mov(dw_master.object.tipo_mov[dw_master.getrow()])
	end if	
	
end if
dw_master.setfocus()
return 1
end function

public subroutine of_verifica_mov (string as_data);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String ls_cod_almacen   
Long ln_dias
Date ld_fecha
str_parametros sl_param

ls_cod_almacen 	 = dw_master.object.almacen [dw_master.getrow()]	
IF Isnull(ls_cod_almacen) OR Trim(ls_cod_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen')
	RETURN
END IF
	
sl_param.tipo		 = ''
sl_param.dw_or_m	 = dw_master
sl_param.dw_or_d   = dw_detail	

// Evalua campos
if TRIM(as_data) = TRIM(is_ing_venta) then  // Ingreso por compras
	sl_param.dw_master = 'd_sel_oc_transito'      
	sl_param.dw1       = 'd_sel_oc_transito_det'  
	sl_param.dw_m = dw_master
	sl_param.opcion    = 1
	sl_param.string1 = is_contab
	ii_ref = 1

	sl_param.titulo    = 'Ordenes de Compra Pendientes '
	OpenWithParm( w_abc_seleccion_md, sl_param)
ELSEIF TRIM(as_data) = TRIM(is_cons_interno) THEN	
	// Busca dias de holgura
	Select NVL(dias_holgura_mat,0) into :ln_dias
	  from logparam where reckey = '1';	
		
	ld_fecha = relativeDate(Date(dw_master.object.fec_registro[dw_master.getrow()]), ln_dias)
	
	sl_param.dw1       = 'd_sel_mov_proyectados'
	sl_param.titulo    = 'Consumo Interno '
	sl_param.tipo		 = '2S'     // con un parametro del tipo string
	sl_param.string1   = is_cons_interno
	sl_param.string2	 = String(ld_fecha, 'DD/MM/YYYY')
	sl_param.string3	 = is_contab
	sl_param.opcion    = 1
	ii_ref = 1

	OpenWithParm( w_abc_seleccion, sl_param)
	
ELSEIF TRIM(as_data) = TRIM(is_vnta_terc)    THEN	
	sl_param.titulo    = 'Ordenes de Ventas Pendientes '
	sl_param.dw_master = 'd_sel_ov_pendientes'
	sl_param.dw1       = 'd_sel_oc_transito_det'  
//	sl_param.dw1       = 'd_sel_art_mov_proy_pend_tbl'
	sl_param.opcion    = 3
	ii_ref = 1

	OpenWithParm( w_abc_seleccion_md, sl_param)
	
ELSEIF TRIM(as_data) = TRIM(is_mov_consig)  THEN	// Consignacion
	sl_param.dw1       = 'd_sel_articulo_consignacion'	
	sl_param.titulo    = 'Articulos con saldo de consignacion'	
	sl_param.opcion    = 4
	ii_ref = 1

	OpenWithParm( w_abc_seleccion, sl_param)
ELSEIF TRIM(as_data) = TRIM(is_dev_prestamo) THEN	// Ingreso por devolucion de prestamo
	sl_param.dw1       = 'd_sel_articulo_prestamos'	
	sl_param.titulo    = 'Articulos prestados'	
	sl_param.opcion    = 5
	ii_ref = 1

	OpenWithParm( w_abc_seleccion, sl_param)
ELSEIF TRIM(as_data) = TRIM(is_rep_merc_dev) THEN	// Ingreso por reposicion de mercaderia devuelta
	sl_param.dw1       = 'd_sel_articulos_devolucion'
	sl_param.titulo    = 'Articulos devueltos'	
	sl_param.opcion    = 6
	ii_ref = 1

	OpenWithParm( w_abc_seleccion, sl_param)
ELSE
	RETURN
END IF
end subroutine

public subroutine of_retrieve (string as_nro);Long ll_row

dw_master.Reset()
dw_detail.Reset()

dw_master.ResetUpdate()
dw_detail.Reset()

dw_master.ii_update = 0
dw_detail.ii_update = 0

ll_row = dw_master.retrieve(as_nro)

if ll_row > 0 then		
	dw_detail.retrieve(as_nro)
	
	of_set_status_doc( dw_master )
	of_tipo_mov(dw_master.object.tipo_mov[ll_row]) // Evalua datos segun tipo de mov.	
end if

is_action = 'open'

end subroutine

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
else

	dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
	dw_detail.SetTransObject(sqlca)

	idw_1 = dw_master              		// asignar dw corriente

	dw_master.of_protect()         		// bloquear modificaciones 
	dw_detail.of_protect()

	ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
	// ii_help = 101     
   
	// Crea datastore para impresion de vale
   ids_print = Create Datastore
	ids_print.DataObject = 'd_frm_ajuste_valorizacion'
	ids_print.SettransObject(sqlca)
end if
end event

event ue_update_pre;String ls_flag_estado

// Verifica que campos son requeridos y tengan valores
ib_update_check = False

ls_flag_estado = dw_master.object.flag_estado [1]

if ls_flag_estado = '0' then
	ib_update_check = true
	return
end if

if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then return

//of_tipo_mov( dw_master.object.tipo_mov[dw_master.getrow()])
//IF is_action <> 'anu' AND is_action <> 'del' then
//	if of_get_datos() = 0 then return   		// Evalua datos de cabecera
//	if of_get_datos_det() = 0 then return		// Evalua datos de detalle
//END IF

// verifica que tenga datos de detalle
if dw_detail.rowcount() = 0 then
	Messagebox( "Atencion", "Ingrese informacion de detalle")
	return
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_set_numera() = 0 then return

ib_update_check = true


end event

on w_al303_ajustes.create
int iCurrent
call super::create
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.st_nro=create st_nro
this.cb_1=create cb_1
this.sle_nro=create sle_nro
this.em_prom_dol=create em_prom_dol
this.em_saldo=create em_saldo
this.em_prom_sol=create em_prom_sol
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.em_prom_dol
this.Control[iCurrent+5]=this.em_saldo
this.Control[iCurrent+6]=this.em_prom_sol
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.dw_detail
this.Control[iCurrent+11]=this.dw_master
this.Control[iCurrent+12]=this.gb_1
end on

on w_al303_ajustes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.cb_1)
destroy(this.sle_nro)
destroy(this.em_prom_dol)
destroy(this.em_saldo)
destroy(this.em_prom_sol)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_insert;Long  ll_row

if idw_1 = dw_master and is_action = 'new' then
	Messagebox( "Atencion", "No puede adicionar otro registro, grabe el actual", exclamation!)
	return
end if

IF idw_1 = dw_detail THEN
	IF dw_master.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF	
	
//	if dw_master.object.b_ref.visible = '1' then		
//		messagebox( 'Atencion', 'Operacion no valida, Seleccione referencia')
//		Return
//	end if	
else
	// Limpia dw
	dw_master.Reset()
	dw_detail.Reset()
END IF

// busca fecha de proceso
//SELECT fecha_proceso INTO :id_fecha_proc
//  		FROM logparam where reckey = '1';
//if TRIM( STRING(id_fecha_proc)) = '' OR ISNULL( id_fecha_proc) then
//	Messagebox( "Error", "Ingrese Fecha de proceso en logparam")
//	Return
//end if

idt_fecha_proc = gnvo_app.of_fecha_actual()

// Verifica tipo de cambio
idc_tipo_cambio = gnvo_app.of_get_tipo_cambio( DATE(idt_fecha_proc))
if idc_tipo_cambio = 0 THEN return

ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
of_set_status_doc(dw_master)
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

event ue_modify();call super::ue_modify;IF dw_master.rowcount() = 0 then return

dw_master.of_protect()
dw_detail.of_protect()	

//IF ib_estado = FALSE THEN
//	dw_master.ii_protect = 0
//	dw_master.of_protect()
//	dw_detail.ii_protect = 0
//	dw_detail.of_protect()	
//END IF
end event

event ue_update;call super::ue_update;
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


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
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	is_action = 'open'
	of_set_status_doc( dw_master)
	of_set_evalua_flag()
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	of_retrieve(dw_master.object.cod_origen[1])
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF
end event

event resize;call super::resize;Long ll_y
//if is_Action <> 'new' then	
	dw_master.width  = newwidth  - dw_master.x - 10
	dw_detail.width  = newwidth  - dw_detail.x - 35
	dw_detail.height = newheight - dw_detail.y - 180	
	
//	dw_detail.height = dw_detail.height - 180	
	
	ll_y = dw_detail.y + dw_detail.height + 70
	st_1.move( 105, ll_y + 10 )
	em_saldo.move( 480, ll_y )
	
	st_2.move( 891, ll_y + 10 )
	em_prom_sol.move( 1280, ll_y )
	
	st_3.move( 1659, ll_y + 10 )
	em_prom_dol.move( 2103, ll_y )
	
	
//else
////	dw_detail.height = dw_detail.height - 150
//	dw_detail.height = newheight - dw_detail.y - 180
//	
//	ll_y = dw_detail.y + dw_detail.height + 10
//	st_1.move( 105, ll_y + 10 )
//	em_saldo.move( 480, ll_y )
//	
//	st_2.move( 891, ll_y + 10 )
//	em_prom_sol.move( 1280, ll_y )
//	
//	st_3.move( 1659, ll_y + 10 )
//	em_prom_dol.move( 2103, ll_y )
//end if
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

this.event ue_update_request()

sl_param.dw1    = 'd_list_ajuste_valorizacion'
sl_param.titulo = 'Movimiento de Almacen'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm(w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[2])
END IF
end event

event ue_insert_pos(long al_row);call super::ue_insert_pos;idw_1.setcolumn( 1)
end event

event ue_print;call super::ue_print;String ls_origen, ls_nro_vale
Long job, j, lx, ly

ls_origen   = dw_master.object.cod_origen[dw_master.getrow()]
ls_nro_vale = dw_master.object.nro_vale[dw_master.getrow()]

IF f_imp_f_general () = FALSE THEN RETURN
ids_print.Retrieve(ls_origen, ls_nro_Vale)


//PrintClose( job)
ids_print.print()



end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_delete();// OVerride

IF dw_master.rowcount() = 0 then return
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

is_action = 'del'
end event

type st_nro from statictext within w_al303_ajustes
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

type cb_1 from commandbutton within w_al303_ajustes
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

type sle_nro from u_sle_codigo within w_al303_ajustes
integer x = 283
integer y = 4
integer width = 471
integer height = 92
integer taborder = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;dw_detail.reset()
cb_1.event clicked()
end event

type em_prom_dol from editmask within w_al303_ajustes
integer x = 2103
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_saldo from editmask within w_al303_ajustes
integer x = 480
integer y = 1728
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type em_prom_sol from editmask within w_al303_ajustes
integer x = 1280
integer y = 1728
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
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_al303_ajustes
integer x = 1659
integer y = 1740
integer width = 402
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

type st_2 from statictext within w_al303_ajustes
integer x = 891
integer y = 1736
integer width = 375
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

type st_1 from statictext within w_al303_ajustes
integer x = 105
integer y = 1736
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

type dw_detail from u_dw_abc within w_al303_ajustes
integer y = 1044
integer width = 3323
integer height = 480
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_ajustes_det"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
idw_mst = dw_master
idw_det = dw_detail
end event

event itemchanged;call super::itemchanged;String 	ls_tipo_mov, ls_cod_art, ls_almacen, ls_consig, ls_pide_cen, &
			ls_null, ls_Art, ls_matriz, ls_cencos, ls_cnta_prsp, &
			ls_grp_cntbl, ls_estado, ls_sub_cat
Decimal {4} ld_precio
Double  ld_saldo_act = 0, ln_cant_asig
long ll_count, ll_null

SetNull( ll_null)
SetNull( ls_null)
ls_almacen  = dw_master.Object.almacen[dw_master.getrow()]
ls_tipo_mov = dw_master.Object.tipo_mov[dw_master.getrow()]

ln_cant_asig = this.object.cant_procesada[row]

dw_master.Accepttext()
dw_detail.AcceptText()

CHOOSE CASE dwo.name
	CASE 'cod_art'		
		of_set_articulo( data, ls_almacen)
		if f_articulo_inventariable( data ) <> 1 then 
			this.object.cod_art[row] = ls_null
			this.object.desc_art[row] = ls_null
			this.object.und[row] = ls_null
			return 1
		end if
		
	CASE 'precio_unit'		
		if double( data)  < 0 then  // no acepta negativos
			Messagebox("Aviso", "No puede ingresar este precio") 
			this.object.precio_unit[row] = ll_null
			return 1
		end if
		
	CASE 'cencos' 
		// Verifica que codigo exista
		Select count(cencos) 
			into :ll_count 
		from centros_costo
	  	Where cencos = :data;
		  
		if ll_count = 0 then
			Setnull(ls_null)
			Messagebox( "Error", "Centro de costo no existe")
			this.object.cencos[row] = ls_null
			return 1
		end if

   	// Si no pide el factor, evalua por el c.costo		
		Select NVL(flag_cta_presup, '0'), NVL(flag_estado, '0')
			into :ls_pide_cen, :ls_estado 
	   from centros_costo 
		where cencos = :data;		
		
   	if ls_estado <> '1' then
			Messagebox( "Error", "Centro de costo esta desactivado", Exclamation!)		
			this.object.cencos[row] = ls_null
			Return 1
		end if		
				
		if ls_pide_cen = '1' then
			dw_detail.object.cencos.background.color = RGB(255,255,255)			
			dw_detail.object.cencos.protect = 0
			dw_detail.object.cencos.edit.required = 'yes'
			dw_detail.object.cnta_prsp.background.color = RGB(255,255,255)			
			dw_detail.object.cnta_prsp.protect = 0
			dw_detail.object.cnta_prsp.edit.required = 'yes'
		end if		
		
		is_cencos = data
		
	CASE "cnta_prsp" 
		//Verifica que exista dato ingresado	
		Select count( cnta_prsp) 
			into :ll_count 
		from presupuesto_cuenta 
		where cnta_prsp = :data;	
		
		if ll_count = 0 then			
			Messagebox( "Error", "Cuenta no existe", Exclamation!)		
			this.object.cnta_prsp[row] = ls_null
			Return 1
		end if
		is_cnta_prsp = data

	CASE "cod_maquina"
		// Verifica que codigo exista
		Select count(cod_maquina) into :ll_count from maquina
	  		Where cod_maquina = :data;
		if ll_count = 0 then			
			Messagebox( "Error", "Maquina no existe")
			this.object.cod_maquina[row] = ls_null
			return 1
		end if
		
	CASE "matriz"
				
//		ls_cod_art = this.object.cod_art [row]
//		if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
//			MessageBox('Error', 'Codigo de Articulo esta nulo o vacio', StopSign!)
//			return 1
//		end if
//		
//		select sub_cat_art
//			into :ls_sub_cat
//		from articulo
//		where cod_art = :ls_cod_art
//		  and flag_estado = '1';
//		
//		if SQLCA.SQLCode = 100 then
//			MessageBox('Error', 'Codigo de Articulo ' + ls_cod_art + ' no existe o no esta activo', StopSign!)
//			return 1
//		end if
//		
//		if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
//			MessageBox('Error', 'Codigo de Articulo no tiene subcategoria')
//			return 1
//		end if
//		
//		IF il_afecta_pto = 1 THEN
//			
//			ls_cencos 		= this.object.cencos[row]
//		
//			// Busca grp_cntbl segun centro de costo
//			Select grp_cntbl 
//				into :ls_grp_cntbl 
//			from centros_costo
//			where cencos = :ls_cencos
//			  and flag_estado = '1';
//			  
//			if SQLCA.SQLCode = 100 then
//				MessageBox('Aviso', 'Centro de Costo no existe o no esta activo')
//				this.SetColumn('cencos')
//				return 1
//			end if
//			
//			if IsNull(ls_grp_cntbl) or trim(ls_grp_cntbl) = '' then
//				MessageBox('Error', 'Centro de Costo no tiene Grupo Contable')
//				return 1
//			end if
//			
//			// Verifica que codigo exista
//			Select count(tipo_mov) 
//				into :ll_count 
//			from tipo_mov_matriz_subcat
//			Where tipo_mov 	= :ls_tipo_mov 
//			  and grp_cntbl 	= :ls_grp_cntbl 
//			  and cod_sub_cat	= :ls_sub_cat
//			  and matriz 		= :data;		
//			  
//			if ll_count = 0 then			
//				Messagebox( "Atencion", "Datos no corresponden a matriz")
//				this.object.matriz[row] = ls_null
//				this.SetColumn('matriz')
//				return 1
//			end if
//		ELSE
//			// Verifica que codigo exista
//			Select count(tipo_mov) 
//				into :ll_count 
//			from tipo_mov_matriz_subcat
//			Where tipo_mov 	= :ls_tipo_mov 
//			  and cod_sub_cat = :ls_sub_cat
//			  and matriz 		= :data;		
//			  
//			if ll_count = 0 then			
//				Messagebox( "Atencion", "Datos no corresponden a matriz")
//				this.object.matriz[row] = ls_null
//				this.SetColumn('matriz')
//				return 1
//			end if
//		END IF
			
		
END CHOOSE

this.ii_update = 1

// Evalua presupuesto en linea
if il_afecta_pto <> 0 then
	IF f_afecta_presup(MONTH( DATE(dw_master.object.fec_registro[dw_master.getrow()])), &
  		YEAR( DATE( dw_master.object.fec_registro[dw_master.getrow()])), &
  		is_cencos, is_cnta_prsp, 0) = 0 THEN
  		this.object.cnta_prsp[row] = ls_null
		is_cnta_prsp = ''
  		this.setcolumn( "cnta_prsp")
  		this.setfocus()
  		RETURN 1
	END IF
end if
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;if of_get_datos() = 0 then 
	dw_master.SetFocus( )
	return
end if

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc( THIS)

if of_get_datos() = 0 then return
end event

event ue_insert_pre;String ls_tipo_mov, ls_tipo_alm, ls_alm, ls_matriz

this.object.cod_origen		[al_row] = gs_origen
this.object.cod_moneda		[al_row] = gnvo_app.is_soles
this.object.flag_estado		[al_row] = '1'
this.object.precio_unit		[al_row] = 0
this.object.decuento			[al_row] = 0
this.object.impuesto			[al_row] = 0
this.object.cant_procesada	[al_row] = 0

is_cencos = gnvo_app.is_null
is_cnta_prsp = gnvo_app.is_null

if is_action = 'open' then
	this.object.nro_vale[al_row] = dw_master.object.nro_vale[dw_master.getrow()]
end if

// Si se adiciona con referencia, desactiva el ingreso de codigo articulo
if ii_ref = 1 then
	dw_detail.object.cod_art.background.color = RGB(192,192,192)
	dw_detail.object.cod_art.protect = 1
else
	dw_detail.object.cod_art.background.color = RGB(255,255,255)			
	dw_detail.object.cod_art.protect = 0
end if

ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]


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
if is_contab = '0' then  // no requerido
	dw_detail.object.matriz.background.color = RGB(192,192,192)	
	dw_detail.object.matriz.protect = 1
	dw_detail.object.matriz.edit.required = 'no'
else
	dw_detail.object.matriz.background.color = RGB(255,255,255)			
	dw_detail.object.matriz.protect = 0
	dw_detail.object.matriz.edit.required = 'yes'			
end if		

// Si almacen es prod. terminado, no pedir precio unit. tampoco costear
//ls_alm = dw_master.object.almacen[dw_master.getrow()]
//Select flag_tipo_almacen 
//	into :ls_tipo_alm 
//from almacen
//where almacen = :ls_alm;
//
//if ls_tipo_alm = 'T' then
//	dw_detail.object.precio_unit.background.color = RGB(192,192,192)
//	dw_detail.object.precio_unit.protect = 1
//	dw_detail.object.precio_unit.edit.required = 'no'						
//else		
//   // Solo tipo de mov. controlados, no pueden modificar el precio
//	if is_ref = 'S' then			
//		dw_detail.object.precio_unit.background.color = RGB(192,192,192)
//		dw_detail.object.precio_unit.protect = 1
//		// Fuerza a que no se edita
//		dw_detail.object.cencos.background.color = RGB(192,192,192)	
//		dw_detail.object.cencos.protect = 1			
//		dw_detail.object.cnta_prsp.background.color = RGB(192,192,192)			
//		dw_detail.object.cnta_prsp.protect = 1			
//	else
//		dw_detail.object.precio_unit.background.color = RGB(255,255,255)			
//		dw_detail.object.precio_unit.protect = 0
//	end if
//end if

this.SetColumn('cod_art')
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String 	ls_name, ls_prot, ls_tipo_mov, ls_cencos, ls_cnta_prsp, &
    		ls_grp_cntbl, ls_matriz, ls_cod_art, ls_sub_cat
Long ll_count
Str_articulo lstr_articulo
str_parametros lstr_param

if dw_master.GetRow() = 0 then return
IF row = 0 then return

ls_name = dwo.name
if this.Describe( ls_name + ".Protect") = '1' then return
ls_tipo_mov = dw_master.object.tipo_mov[dw_master.getrow()]


// Ayuda de busqueda para articulos
if ls_name = 'cod_art' then
	

	lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )

	if lstr_articulo.b_Return then

		this.object.cod_art	[row] = lstr_articulo.cod_art
		this.object.desc_art	[row] = lstr_articulo.desc_art
		this.object.und		[row] = lstr_articulo.und
		
		of_set_articulo( lstr_articulo.cod_art, dw_master.Object.almacen[dw_master.getrow()])
	end if
	
elseif ls_name = 'cnta_prsp' then
	
	lstr_param.dw1 = "d_dddw_cntas_presupuestal"
	lstr_param.titulo = "Cuentas Presupuestales"
	lstr_param.field_ret_i[1] = 1		

	OpenWithParm( w_search, lstr_param)
	lstr_param = MESSAGE.POWEROBJECTPARM
	if lstr_param.titulo <> 'n' then			
		this.object.cnta_prsp	[row] = lstr_param.field_ret[1]
		is_cnta_prsp = lstr_param.field_ret[1]
		this.ii_update = 1		// activa flag de modificado
	END IF
	
elseif ls_name = 'cencos' then
	
	lstr_param.dw1 = "d_dddw_cencos"
	lstr_param.titulo = "Centro de Costos"
	lstr_param.field_ret_i[1] = 1

	OpenWithParm( w_search, lstr_param)		
	lstr_param = MESSAGE.POWEROBJECTPARM
	if lstr_param.titulo <> 'n' then		
		this.object.cencos	[row] = lstr_param.field_ret[1]
		is_cencos = lstr_param.field_ret[1]
		this.ii_update = 1
	END IF
	
elseif ls_name = 'cod_maquina' then
	
	lstr_param.dw1 = "d_lista_maquinas_tbl"
	lstr_param.titulo = "Lista de maquinas"
	lstr_param.field_ret_i[1] = 1

	OpenWithParm( w_search, lstr_param)		
	lstr_param = MESSAGE.POWEROBJECTPARM
	if lstr_param.titulo <> 'n' then		
		this.object.cod_maquina[row] = lstr_param.field_ret[1]
		this.ii_update = 1
	END IF
	
elseif ls_name = 'matriz' then
	
	// Busco la matriz contable por Cuenta Presupuestal
		if is_flag_matriz_contab = 'P' then
			lstr_param.dw1 		= "d_sel_tipo_mov_matriz_x_op"
			lstr_param.titulo 	= "Matrices de movimiento almacen"
			lstr_param.tipo 		= '1S2S3S'
			lstr_param.string1 	= ls_tipo_mov
			lstr_param.string2 	= this.object.cencos[row]
			lstr_param.string3 	= this.object.cnta_prsp[row]
			lstr_param.factor_prsp = il_afecta_pto  // Factor Presupuesto de Tipo_mov
			lstr_param.field_ret_i[1] = 3
		
			OpenWithParm( w_search, lstr_param)		
			lstr_param = MESSAGE.POWEROBJECTPARM
			if lstr_param.titulo <> 'n' then		
				this.object.matriz[row] = lstr_param.field_ret[1]		
				ls_matriz 				   = lstr_param.field_ret[1]
				
				if il_afecta_pto <> 0 then
					ls_cencos 	 = this.object.cencos	[row]
					ls_cnta_prsp = this.object.cnta_prsp[row]		
				
					// Busca grp_cntbl segun centro de costo
					Select grp_cntbl 
						into :ls_grp_cntbl 
					from centros_costo
					where cencos = :ls_cencos;
				
					// Verifica que codigo exista
					Select count(tipo_mov) 
						into :ll_count 
					from tipo_mov_matriz
					Where tipo_mov 	= :ls_tipo_mov 
					  and grp_cntbl 	= :ls_grp_cntbl 
					  and cnta_prsp 	= :ls_cnta_prsp 
					  and matriz 		= :ls_matriz;		
					  
					if ll_count = 0 then			
						Messagebox( "Error", "Datos no corresponden a matriz")
						this.object.matriz[row] = gnvo_app.is_null
						return 
					end if		
				else
					// Verifica que codigo exista
					Select count(tipo_mov) 
						into :ll_count 
					from tipo_mov_matriz
					Where tipo_mov = :ls_tipo_mov 
					  and matriz 	= :ls_matriz;		
					  
					if ll_count = 0 then			
						Messagebox( "Error", "Datos no corresponden a matriz")
						this.object.matriz[row] = gnvo_app.is_null
						return 
					end if		
				end if
				this.ii_update = 1
			END IF
			
		elseif is_flag_matriz_contab = 'S' then
			
			// Busco la matriz contable por Codigo de SubCategoria del Articulo
			ls_cod_art = this.object.cod_Art [row]
			if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
				MessageBox('Error', 'Debe indicar un codigo de articulo valido', StopSign!)
				return
			end if
			
			select sub_cat_art
				into :ls_sub_cat
			from articulo
			where cod_art = :ls_cod_art
			  and flag_estado = '1';
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de Articulo ' + ls_cod_art + ' no existe o no se encuentra activo', StopSign!)
				return
			end if
			
			if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
				MessageBox('Error', 'No se ha definido Codigo de Sub Categoria en Articulo')
				return
			end if
			
			if il_afecta_pto = 0  then
				ls_grp_cntbl = '%%'
			else
				ls_cencos 	 = this.object.cencos	[row]
				
				// Busca grp_cntbl segun centro de costo
				Select NVL(trim(grp_cntbl), '%') || '%'
					into :ls_grp_cntbl 
				from centros_costo
				where cencos = :ls_cencos;
				
				
			end if
			
			lstr_param.dw1 		= "d_sel_tipo_mov_matriz_subcat"
			lstr_param.titulo 	= "Matrices de movimiento almacen"
			lstr_param.tipo 		= '1S2S3S'
			lstr_param.string1 	= ls_tipo_mov
			lstr_param.string2 	= ls_grp_cntbl
			lstr_param.string3 	= ls_sub_cat
			lstr_param.factor_prsp = il_afecta_pto  // Factor Presupuesto de Tipo_mov
			lstr_param.field_ret_i[1] = 3
		
			OpenWithParm( w_search, lstr_param)		
			lstr_param = MESSAGE.POWEROBJECTPARM
			if lstr_param.titulo <> 'n' then		
				this.object.matriz[row] = lstr_param.field_ret[1]		
				ls_matriz 				   = lstr_param.field_ret[1]
				
				if il_afecta_pto <> 0 then
					ls_cencos 	 = this.object.cencos[row]
				
					// Verifica que codigo exista
					Select count(tipo_mov) 
						into :ll_count 
					from tipo_mov_matriz_subcat
					Where tipo_mov 	= :ls_tipo_mov 
					  and grp_cntbl 	= :ls_grp_cntbl 
					  and cod_sub_Cat	= :ls_sub_cat
					  and matriz 		= :ls_matriz;		
					  
					if ll_count = 0 then			
						Messagebox( "Error", "Datos no corresponden a matriz")
						this.object.matriz[row] = gnvo_app.is_null
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
						Messagebox( "Error", "Datos no corresponden a matriz")
						this.object.matriz[row] = gnvo_app.is_null
						return 
					end if		
				end if
				this.ii_update = 1
			END IF
		else
			MessageBox('Error', 'Valor de FLAG_MATRIZ_CONTABLE incorrecto')
			return
		end if
	
end if

//Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter

// Evalua presupuesto.
IF f_afecta_presup(MONTH( DATE(dw_master.object.fec_registro[dw_master.getrow()])), &
  YEAR( DATE( dw_master.object.fec_registro[dw_master.getrow()])), &
  is_cencos, is_cnta_prsp, 0) = 0 THEN
  messagebox( "Evaluando pres", '')
  this.object.cnta_prsp[row] = ''
  is_cnta_prsp = ''
  this.setcolumn( 'cnta_prsp')
  this.setfocus()
end if

end event

event dberror;// Override


String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name, ls_Cad
Integer	li_pos_ini, li_pos_fin, li_pos_nc
Long lpos, ll_error, lpos2

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
	CASE 1                        // Llave Duplicada
        Messagebox('Error PK','Llave Duplicada, Linea: ' + String(row))
        Return 1 
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	case 20000 to 29999
		// Encontrar el error
		
		lpos = POS( sqlerrtext, ':')
		ll_error = LONG( MID( sqlerrtext, 5, 5) )			
		
		ls_cad = MID( sqlerrtext, lpos + 2, len( sqlerrtext) - lpos )			
		lpos2 = pos( ls_cad, 'ORA')
		ls_cad = MID( sqlerrtext, lpos + 2, lpos2 - 1)
		Messagebox( "Error", ls_cad, stopsign!)

       Return 1
	
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE





end event

type dw_master from u_dw_abc within w_al303_ajustes
event ue_display ( string as_columna,  long al_row )
integer y = 108
integer width = 3323
integer height = 924
integer taborder = 40
string dataobject = "d_abc_ajustes"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where cod_origen = '" + gs_origen + "' " &
				  + "and flag_estado = '1' " &
  				  + "order by almacen " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	case "tipo_mov"
		ls_almacen = this.object.almacen[al_row]
		
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', 'No ha ingresado el almacen')
			this.SetColumn('almacen')
			return
		end if
		
		ls_sql = "select a.tipo_mov as codigo_tipo_mov, " &
				 + "a.desc_tipo_mov as descripcion_tipo_mov " &
				 + "from articulo_mov_tipo a, " &
				 + "almacen_tipo_mov b " &
				 + "where a.tipo_mov = b.tipo_mov " &
				 + "and a.flag_estado = '1' " &
				 + "and a.factor_sldo_consig = 0 " &
				 + "and a.factor_sldo_pres = 0 " &
				 + "and a.factor_sldo_dev = 0 " &
				 + "and NVL(a.factor_sldo_total,0) <> 0 " &
				 + "and a.flag_ajuste_valorizacion = '1' " &
 				 + "and b.almacen = '" + ls_almacen + "' " &
				 + "order by a.tipo_mov"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_mov  [al_row] = ls_codigo
		
			// Evalua datos segun tipo de mov.
			if of_tipo_mov(ls_codigo)  = 0 then 
				this.object.tipo_mov 		[al_row] = ls_null
				this.object.desc_tipo_mov 	[al_row] = ls_null
				return 
			end if
			
			this.object.tipo_mov			[al_row] = ls_codigo
			this.object.desc_tipo_mov	[al_row] = ls_data
			this.ii_update = 1

			this.object.tipo_mov.background.color = RGB(192,192,192)   
			this.object.tipo_mov.protect = 1

		end if
		
		return
	
	case "tipo_doc_int"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " &
				  + "where flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_int	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_doc_ext"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " &
				  + "where flag_estado = '1" 
				 
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

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master
idw_det	= dw_detail
end event

event itemchanged;Int 		li_val
string 	ls_nombre, ls_desc, ls_doc, ls_almacen

This.Accepttext()

CHOOSE CASE dwo.name
	CASE 'fec_registro'
		idt_fecha_proc = this.object.fec_registro[row]
		
		// Verifica tipo de cambio
		idc_tipo_cambio = gnvo_app.of_get_tipo_cambio( DATE(idt_fecha_proc))
		
		if idc_tipo_cambio = 0 THEN 
			this.object.fec_registro[row] = gnvo_app.idt_null
			return 1
		end if		
		
	CASE 'almacen'

		SELECT desc_almacen 
			INTO :ls_desc
		FROM almacen
   	WHERE  almacen = :data
		  and flag_estado = '1'
		  and cod_origen = :gs_origen; 
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de almacen no existe, ' &
					+ 'no esta activo o no le corresponde a su origen ')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.almacen		[row] = gnvo_app.is_null
			this.object.desc_almacen[row] = gnvo_app.is_null
			this.setcolumn( "almacen" )
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.desc_almacen [row] = ls_desc
		
	CASE 'tipo_mov'
		ls_almacen = this.object.almacen[row]
		
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', 'No ha ingresado el almacen', StopSign!)
			this.SetColumn('almacen')
			return		
		end if
		
		if of_tipo_mov(data)  = 0 then // Evalua datos segun tipo de mov.
			this.object.tipo_mov			[row] = gnvo_app.is_null
			this.object.desc_tipo_mov	[row] = gnvo_app.is_null
			RETURN 1
		end if
		
		SELECT a.desc_tipo_mov 
			INTO :ls_nombre 
		FROM 	articulo_mov_tipo a
   	WHERE a.tipo_mov 		= :data 
		  and a.flag_estado 	= '1'
		  and NVL(a.flag_ajuste_valorizacion,'0') = '1'
		  and NVL(a.factor_sldo_total,0) <> 0;
		
		IF SQLCA.SQLCODE <> 0 THEN			
			Messagebox('Aviso','Tipo de movimiento no existe o ' &
				+ 'esta anulado, o no se encuentra correctamente configurado', StopSign!)
				
			this.Object.tipo_mov			[row] = gnvo_app.is_null
			this.Object.desc_tipo_mov	[row] = gnvo_app.is_null
			this.setcolumn( "tipo_mov")
			this.setfocus()
			RETURN 1
		END IF
		
		this.object.desc_tipo_mov[row] = ls_nombre
		this.object.tipo_mov.background.color = RGB(192,192,192)   
		this.object.tipo_mov.protect = 1		

	CASE 'tipo_doc_int'

		SELECT desc_tipo_doc 
			INTO :ls_nombre 
		FROM doc_tipo
   	WHERE  tipo_doc = :data 
		  and flag_estado = '1';
		
		IF SQLCA.SQLCODE = 100 THEN			
			Messagebox('Aviso','Tipo de Documento no existe')
			this.Object.tipo_doc_int[row] = gnvo_app.is_null
			this.setcolumn( "tipo_doc_int")
			this.setfocus()
			RETURN 1
		END IF

	CASE 'tipo_doc_ext'

		SELECT desc_tipo_doc 
			INTO :ls_nombre 
		FROM doc_tipo
   	WHERE  tipo_doc = :data 
		  and flag_estado = '1';
		
		IF SQLCA.SQLCODE = 100 THEN			
			Messagebox('Aviso','Tipo de Documento no existe')
			this.Object.tipo_doc_ext[row] = gnvo_app.is_null
			this.setcolumn( "tipo_doc_ext")
			this.setfocus()
			RETURN 1
		END IF

END CHOOSE
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen  [al_row]  = gs_origen
this.object.flag_estado [al_row]  = '1'		// Activo
this.object.cod_usr     [al_row]  = gs_user
this.object.fec_registro[al_row] = gnvo_app.of_fecha_actual( )

//this.object.fec_registro[al_row] =  //TODAY()
is_ref = 'N'
is_action = 'new'

dw_master.object.tipo_mov.background.color = RGB(255,255,255)
dw_master.object.tipo_mov.protect = 0

ii_ref = 0 	// Flag de indicador de referencias
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_status_doc( THIS)

end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          ls_boton
long	ll_row
Str_parametros 	 sl_param

ls_boton = dwo.name

if ls_boton = 'b_tipo' and this.Describe( "tipo_mov.Protect") = '0' then
	string ls_alm
	ls_alm = dw_master.object.almacen[row]
	sl_param.dw1 = "d_sel_tipo_mov_ajustes"
	sl_param.titulo = "tipos de movimiento"
	sl_param.tipo = '1S'
	sl_param.string1 = ls_alm
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then
		this.object.tipo_mov[this.getrow()] = sl_param.field_ret[1]		
		this.object.desc_tipo_mov[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1
		
		if of_tipo_mov(sl_param.field_ret[1])  = 0 then // Evalua datos segun tipo de mov.
			this.object.tipo_mov[row] = '' 
			RETURN 1
		end if
		dw_master.object.tipo_mov.background.color = RGB(192,192,192)   
		dw_master.object.tipo_mov.protect = 1
		
	END IF
end if

if ls_boton = 'b_detalle' then 
	ll_row = dw_master.getrow()
	dw_detail.retrieve(dw_master.object.cod_origen[ll_row], dw_master.object.nro_vale[ll_row])
end if
end event

event dberror;//Override


String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
	CASE 1                        // Llave Duplicada
        Messagebox('Error PK','Llave Duplicada, Linea: ' + String(row))
        Return 1 
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	CASE -3
		Messagebox( "Error Fatal", 'Operacion no podra ser grabada, ~r~ncomunicar con sistemas', stopsign!)

       Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE
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

type gb_1 from groupbox within w_al303_ajustes
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

