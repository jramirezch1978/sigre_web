$PBExportHeader$w_fi329_pagar_directo.srw
forward
global type w_fi329_pagar_directo from w_abc
end type
type rb_ref_ov from radiobutton within w_fi329_pagar_directo
end type
type rb_ref_os from radiobutton within w_fi329_pagar_directo
end type
type rb_ref_oc from radiobutton within w_fi329_pagar_directo
end type
type rb_sin_ref from radiobutton within w_fi329_pagar_directo
end type
type cb_2 from commandbutton within w_fi329_pagar_directo
end type
type tab_1 from tab within w_fi329_pagar_directo
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_referencia from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_referencia dw_referencia
end type
type tab_1 from tab within w_fi329_pagar_directo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_referencia from commandbutton within w_fi329_pagar_directo
end type
type rb_gen from radiobutton within w_fi329_pagar_directo
end type
type rb_esp from radiobutton within w_fi329_pagar_directo
end type
type dw_master from u_dw_abc within w_fi329_pagar_directo
end type
type gb_1 from groupbox within w_fi329_pagar_directo
end type
type gb_2 from groupbox within w_fi329_pagar_directo
end type
end forward

global type w_fi329_pagar_directo from w_abc
integer width = 3616
integer height = 2180
string title = "[FI329] Documentos Pagar Directo"
string menuname = "m_mantenimiento_cl_anular_dir"
event ue_find_exact ( )
event ue_anular ( )
event ue_anul_trans ( )
rb_ref_ov rb_ref_ov
rb_ref_os rb_ref_os
rb_ref_oc rb_ref_oc
rb_sin_ref rb_sin_ref
cb_2 cb_2
tab_1 tab_1
cb_referencia cb_referencia
rb_gen rb_gen
rb_esp rb_esp
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
end type
global w_fi329_pagar_directo w_fi329_pagar_directo

type variables
String 				is_accion,is_flag_valida_cbe, is_doc_aos, is_doc_aoc
String      	  	is_tabla, is_colname[], is_coltype[]
DatawindowChild 	idw_forma_pago

//Comprobante de movilidad local
String		is_doc_cml, is_salir
Decimal		idc_monto_max_mov

// Datawindows

u_dw_abc  	idw_detail	, idw_referencia
n_Cst_wait	invo_wait
n_cst_utilitario	invo_util
end variables

forward prototypes
public function decimal wf_total ()
public subroutine wf_verifica_anticipos (string as_origen_ref, string as_tipo_ref, string as_nro_ref, ref decimal adc_saldo_sol, ref decimal adc_saldo_dol)
public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp)
public function string of_cbenef_origen (string as_origen)
public function integer of_get_param ()
public subroutine of_cambiar_dw (string as_tipo_doc)
public function decimal of_conv_moneda_mov (decimal adec_monto_mov)
public function boolean of_verifica_documento ()
public subroutine of_asignar_dws ()
public function integer of_monto_mov (date ad_fec_mov, string as_cod_trabajador)
public function integer of_set_numera ()
end prototypes

event ue_find_exact();//
String ls_cencos,ls_cnta_prsp,ls_cod_relacion,ls_tipo_doc,ls_nro_doc
str_parametros sl_param

TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_letras_x_pagar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 6 //comprobante de egreso
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	
	ls_cod_relacion = dw_master.object.cod_relacion [dw_master.getrow()]
	ls_tipo_doc 	 = dw_master.object.tipo_doc     [dw_master.getrow()]
	ls_nro_doc 		 = dw_master.object.nro_doc	   [dw_master.getrow()]
	
	tab_1.tabpage_1.dw_detail.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	tab_1.tabpage_2.dw_referencia.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	
	dw_master.il_row = dw_master.getrow()

	TriggerEvent('ue_modify')
	is_accion = 'fileopen'
ELSE
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_referencia.Reset()
END IF	
end event

event ue_anular;Long    	ll_inicio,ll_row_master, ll_count
Integer 	li_opcion, li_count
String 	ls_flag_estado,ls_flag_cbancos, ls_proveedor, ls_tipo_doc, ls_nro_doc

ll_row_master = dw_master.getrow()
IF ll_row_master = 0 THEN RETURN

//Verifico si el documento no es de creditos de campo
ls_proveedor		= dw_master.object.cod_relacion  	[1]
ls_tipo_doc  		= dw_master.object.tipo_doc		 	[1]
ls_nro_doc   		= dw_master.object.nro_doc       	[1]
ls_flag_estado  	= dw_master.object.flag_estado 		[1] 
ls_flag_cbancos 	= dw_master.object.flag_caja_bancos [1]


//Valido si el documento existe en el esta en caja bancos
select count(*)
	into :ll_count
from caja_bancos cb,
     caja_bancos_det cbd
where cb.origen        = cbd.origen
  and cbd.nro_registro = cbd.nro_registro
  and cbd.cod_relacion = :ls_proveedor
  and cbd.tipo_doc     = :ls_tipo_doc
  and cbd.nro_doc      = :ls_nro_doc
  and cb.flag_estado   <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'El documento ya se encuentra registrado en CAJA BANCOS, no se puede modificar', StopSign!)
	
	dw_master.ii_protect  		= 0
	idw_detail.ii_protect	 	= 0
	idw_referencia.ii_protect	= 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencia.of_protect()
	
	return
end if

//Si el documento ya no se encuentra activo tambien lo desactivo
IF ls_flag_estado <> '1' OR ls_flag_cbancos = '1' THEN
	MessageBox('Aviso', 'El documento no se encuentra activo, no se puede modificar', StopSign!)
	
	dw_master.ii_protect  = 0
	idw_detail.ii_protect	 = 0
	idw_referencia.ii_protect	 = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencia.of_protect()
end if


 

IF ls_flag_cbancos = '1' THEN
	Messagebox('Aviso','Documento se encuentra Aplicado No se puede Anular ,Verifique!')
	Return
END IF

IF ls_flag_estado  <> '1' THEN 
   Messagebox('Aviso','No se Puede Anular Documento Revise En que estado se Encuentra')
	Return
END IF

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF



select count(*)
  into :li_count
from cam_creditos_det ccd
where ccd.proveedor_cxp = :ls_proveedor
  and ccd.tipo_doc_cxp  = :ls_tipo_doc
  and ccd.nro_doc_cxp	= :ls_nro_doc;

if li_count > 0 then
 	Messagebox('Aviso','No se Puede Anular Documento porque es un documento de credito de Campo', StopSign!)
	return
end if

//Verifico si el documento no se encuentra en cuenta corriente
select count(*)
  into :li_count
from cnta_crrte t
where t.cod_trabajador 	= :ls_proveedor
  and t.tipo_doc  		= :ls_tipo_doc
  and t.nro_doc			= :ls_nro_doc;

if li_count > 0 then
 	Messagebox('Aviso','No se Puede Anular Documento porque esta registrado como Cuenta Corriente en RRHH, por favor coordine con el área de RRHH para que lo elimine de su Cuenta Corriente', StopSign!)
	return
end if

//Procedo a confirmar antes de anular
li_opcion = MessageBox('Aviso','Seguro que desea eliminar registro', question!, yesno!, 2)

IF li_opcion = 2 THEN RETURN

//Anulo el documento
dw_master.object.flag_estado [ll_row_master] = '0' 
dw_master.object.importe_doc [ll_row_master] = 0.00
dw_master.object.saldo_sol   [ll_row_master] = 0.00
dw_master.object.saldo_dol   [ll_row_master] = 0.00


FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.importe [ll_inicio] = 0.00
NEXT	

/*Elimino detalle de Cntas x pagar*/
DO WHILE tab_1.tabpage_2.dw_referencia.Rowcount() > 0
	tab_1.tabpage_2.dw_referencia.Deleterow(0)
LOOP

dw_master.ii_update = 1
idw_detail.ii_update = 1
idw_referencia.ii_update = 1
is_accion = 'delete'

end event

event ue_anul_trans();Long   	ll_inicio, ll_row_master, ll_count
Integer 	li_opcion
String 	ls_flag_estado, ls_flag_cbancos, ls_proveedor, ls_tipo_doc, ls_nro_doc
Boolean lbo_ok = TRUE

ll_row_master = dw_master.getrow()
IF ll_row_master = 0 THEN RETURN

//Verifico si el documento no es de creditos de campo
ls_proveedor		= dw_master.object.cod_relacion  	[1]
ls_tipo_doc  		= dw_master.object.tipo_doc		 	[1]
ls_nro_doc   		= dw_master.object.nro_doc       	[1]
ls_flag_estado  	= dw_master.object.flag_estado 		[1] 
ls_flag_cbancos 	= dw_master.object.flag_caja_bancos [1]


//Valido si el documento existe en el esta en caja bancos
select count(*)
	into :ll_count
from caja_bancos cb,
     caja_bancos_det cbd
where cb.origen        = cbd.origen
  and cbd.nro_registro = cbd.nro_registro
  and cbd.cod_relacion = :ls_proveedor
  and cbd.tipo_doc     = :ls_tipo_doc
  and cbd.nro_doc      = :ls_nro_doc
  and cb.flag_estado   <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'El documento ya se encuentra registrado en CAJA BANCOS, no se puede modificar', StopSign!)
	
	dw_master.ii_protect  		= 0
	idw_detail.ii_protect	 	= 0
	idw_referencia.ii_protect	= 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencia.of_protect()
	
	return
end if

IF ls_flag_cbancos = '1' THEN
	Messagebox('Aviso','Documento se encuentra Aplicado No se puede Anular ,Verifique!')
	Return
END IF

IF ls_flag_estado  = '2' THEN 
   Messagebox('Aviso','No se Puede Anular Documento Revise En que estado se Encuentra')
	Return
END IF

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

li_opcion = MessageBox('Aviso','Seguro que desea eliminar registro', question!, yesno!, 2)

IF li_opcion = 2 THEN RETURN

//eliminar
/*Elimino detalle de Cntas x pagar*/
DO WHILE tab_1.tabpage_2.dw_referencia.Rowcount() > 0
	tab_1.tabpage_2.dw_referencia.Deleterow(0)
LOOP

/*Elimino referencias de Cntas Pagar*/
DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
	tab_1.tabpage_1.dw_detail.Deleterow(0)
LOOP


/*elimino cabecera*/
dw_master.deleterow (dw_master.Getrow())


//grabacion alterna
IF	lbo_ok = TRUE THEN
	IF tab_1.tabpage_2.dw_referencia.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_referencia.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

public function decimal wf_total ();Long    ll_inicio
Decimal {2} ldc_importe = 0.00,ldc_total_importe = 0.00

For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_importe = tab_1.tabpage_1.dw_detail.object.importe [ll_inicio]
	 IF Isnull(ldc_importe) THEN ldc_importe = 0.00
	 ldc_total_importe = ldc_total_importe + ldc_importe 
Next	


Return ldc_total_importe
end function

public subroutine wf_verifica_anticipos (string as_origen_ref, string as_tipo_ref, string as_nro_ref, ref decimal adc_saldo_sol, ref decimal adc_saldo_dol);Boolean		lb_ret = TRUE


DECLARE PB_usp_fin_monto_anticipos_gen PROCEDURE FOR usp_fin_monto_anticipos_gen 
(:as_origen_ref,:as_tipo_ref,:as_nro_ref);
EXECUTE PB_usp_fin_monto_anticipos_gen ;



IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
	MessageBox("SQL error", SQLCA.SQLErrText)
	
END IF

FETCH PB_usp_fin_monto_anticipos_gen INTO :adc_saldo_sol,:adc_saldo_dol ;
CLOSE PB_usp_fin_monto_anticipos_gen ;



end subroutine

public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp);Long ll_count 

select Count(*) 
  into :ll_count 
  from presupuesto_partida pp,
   	 tipo_prtda_prsp_det ttd
 where (pp.tipo_prtda_prsp = ttd.tipo_prtda_prsp ) and
       (ttd.grp_prtda_prsp = (select ppa.grp_prtda_prsp_fondos from  presup_param ppa)) and
       (pp.ano             = :al_ano             ) and
       (pp.cencos          = :as_cencos          ) and
       (pp.cnta_prsp       = :as_cnta_prsp       ) ;
		 
		 
Return ll_count

end function

public function string of_cbenef_origen (string as_origen);
String ls_cen_ben

select cen_bef_gen_oc into :ls_cen_ben
  from origen where cod_origen = :as_origen ;
  

Return ls_cen_ben  
end function

public function integer of_get_param ();// Para obtener los parametos de comprobante de movilidad
// local
select flag_centro_benef 
	into :is_flag_valida_cbe 
from logparam 
where reckey = '1' ;

SELECT   NVL(A.DOC_MOVILIDAD, ''), NVL(A.MONTO_MAX_MOV, 0 ), a.doc_anticipo_oc, a.doc_anticipo_os
 INTO		:is_doc_cml, :idc_monto_max_mov, :is_doc_aoc, :is_doc_aos
FROM 		FINPARAM A
WHERE    RECKEY = '1';

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros " + &
					'~n~r' + 'de movilidad en FINPARAM')
	RETURN 0
END IF

IF ISNULL(is_doc_cml) OR is_doc_cml = '' THEN
	messagebox('Error', 'No ha definido tipo de comprobante' + &
				'~n~r' + 'de movilidad local en FINPARAM')
	RETURN 0
END IF

IF ISNULL(idc_monto_max_mov) OR idc_monto_max_mov = 0 THEN
	messagebox('Error', 'No ha definido el monto maximo por ' + &
				'~n~r' + 'concepto de movilidad local')
	RETURN 0
END IF

IF ISNULL(is_doc_aos) OR is_doc_aos = '' THEN
	messagebox('Error', 'No ha definido Documento de Anticipo de OS' + &
				'~n~r' + 'en FINPARAM')
	RETURN 0
END IF

IF ISNULL(is_doc_aoc) OR is_doc_aoc = '' THEN
	messagebox('Error', 'No ha definido Documento de Anticipo de OC' + &
				'~n~r' + 'en FINPARAM')
	RETURN 0
END IF



RETURN 1
end function

public subroutine of_cambiar_dw (string as_tipo_doc);integer 	li_count
String	ls_cod, ls_null

SetNull(ls_null)
// funcion para cambiar el dw si tipo_doc = comprobante movilidad

// primero verifico si la cabecera tiene registros
if dw_master.rowCount( ) = 0 then return

IF as_tipo_doc = TRIM(is_doc_cml) THEN
	// Verifico si el cod de relacion que ha ingresado sea
	// un trabajador
	ls_cod = dw_master.object.cod_relacion [dw_master.GetRow()]
	
	select count(*)
	  into :li_count
	  from maestro
	 where cod_trabajador = :ls_cod
	   and flag_estado = '1';
	 
	if li_count = 0 then
		MessageBox('Aviso', 'Para hacer un comprobante de movilidad debe seleccionar un trabajador de la empresa activo, por favor verifique')
		dw_master.object.tipo_doc [dw_master.getRow()] = ls_null
		dw_master.setfocus( )
		dw_master.setcolumn( "tipo_doc" )
		return
	end if
	
	idw_detail.dataobject = 'd_abc_comprobante_egreso_det_mov_tbl'
	idw_detail.SetTransObject( SQLCA)
ELSE
	idw_detail.dataobject = 'd_abc_comprobante_egreso_det_tbl'
	idw_detail.SetTransObject( SQLCA)
END IF

//Parent.Event resize()

end subroutine

public function decimal of_conv_moneda_mov (decimal adec_monto_mov);// Funcion para calcular el monto en Soles
Decimal	ldec_monto_mov, ldec_tasa_cambio
String	ls_cod_soles, ls_moneda_cab, ls_cod_dolares

ls_cod_soles  		= f_cod_moneda_soles()
ls_cod_dolares		= f_cod_moneda_dolares()

ls_moneda_cab 		= dw_master.object.cod_moneda  [dw_master.GetRow()]
ldec_tasa_cambio 	= dw_master.object.tasa_cambio [dw_master.GetRow()]

IF ls_moneda_cab = ls_cod_soles THEN
	ldec_monto_mov = adec_monto_mov
END IF

IF ls_moneda_cab = ls_cod_dolares THEN
	ldec_monto_mov = Round(adec_monto_mov * ldec_tasa_cambio,2)
END IF

RETURN ldec_monto_mov


end function

public function boolean of_verifica_documento ();String  ls_cod_relacion,ls_tipo_doc,ls_nro_doc
Long    ll_count

dw_master.Accepttext()

ls_cod_relacion = dw_master.object.cod_relacion [1]
ls_tipo_doc	 	 = dw_master.object.tipo_doc 	   [1]
ls_nro_doc	 	 = dw_master.object.nro_doc  	   [1]
					
// Antes de hacer la verificación al servidor de base de datos
// verifico que los datos no tengan valor nulo
if IsNull(ls_cod_relacion) or IsNull(ls_tipo_doc) or IsNull(ls_nro_doc) then 
	return true
end if
					
//VERIFIQUE SI EXISTE
select Count(*) 
  into :ll_count 
  from cntas_pagar
 where cod_relacion 	= :ls_cod_relacion  
   and tipo_doc		= :ls_tipo_doc      
	and nro_doc			= :ls_nro_doc;
			
if ll_count > 0 then
	Messagebox('Aviso','El Documento ' + ls_cod_relacion &
			+ ' ' + ls_tipo_doc + ' ' + ls_nro_doc &
			+ ' ya ha sido Registrado, por favor verifique')						
	return false
end if					

Return true
end function

public subroutine of_asignar_dws ();idw_detail = tab_1.tabpage_1.dw_detail
idw_referencia = tab_1.tabpage_2.dw_referencia
end subroutine

public function integer of_monto_mov (date ad_fec_mov, string as_cod_trabajador);// Función para calcular el monto diario en soles por movilidad
Long		ll_i
Decimal	ldec_monto_mov
String	ls_moneda_cab, ls_cod_trabajador
date		ld_fec_mov

ls_moneda_cab = dw_master.object.cod_moneda [dw_master.GetRow()]

idw_detail.SetSort('cod_trabajador A, fec_movilidad A')

ldec_monto_mov = 0
FOR ll_i = 1 TO idw_detail.Rowcount( )
	ld_fec_mov = date(idw_detail.object.fec_movilidad [ll_i])
	
	if ld_fec_mov = ad_fec_mov then
		ls_cod_trabajador = idw_detail.object.cod_trabajador [ll_i]
		
		
		if IsNull(as_cod_trabajador) or trim(as_cod_trabajador) = '' then
			
			if IsNull(ls_cod_trabajador) or trim(ls_cod_trabajador) = '' then
				ldec_monto_mov += of_conv_moneda_mov(DEC(idw_detail.object.importe [ll_i]))
			END IF
		else
			if trim(ls_cod_trabajador) = trim(as_cod_trabajador) then
				ldec_monto_mov += of_conv_moneda_mov(DEC(idw_detail.object.importe [ll_i]))
			END IF
		end if
	end if
NEXT

RETURN ldec_monto_mov
end function

public function integer of_set_numera ();Long   ll_ult_nro = 0, ll_count
String ls_tipo_doc, ls_mensaje, ls_nro_doc, ls_cod_relacion

try 
	ls_tipo_doc 		= dw_master.object.tipo_doc 		[1]
	ls_cod_relacion	= dw_master.object.cod_relacion 	[1]
	
	
	SELECT count(*)
	  INTO :ll_count
	  FROM num_doc_tipo
	 WHERE tipo_doc = :ls_tipo_doc 
		and trim(nro_serie) = trim(:gs_origen);
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox('Error','Ha ocurrido un error al consultar la tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)	
		return -1
	end if
	  
	IF ll_count = 0 THEN
		insert into num_doc_tipo(ultimo_numero, tipo_doc, nro_Serie)
		values(1, :ls_tipo_doc, :gs_origen);
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			Messagebox('Error','Ha ocurrido un error al INSERTAR la tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)	
			return -1
		end if
	
	end if;
	
	
	SELECT ultimo_numero
	  INTO :ll_ult_nro
	  FROM num_doc_tipo
	 WHERE tipo_doc = :ls_tipo_doc 
		and trim(nro_serie) = trim(:gs_origen) for update;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox('Error','Ha ocurrido un error al CONSULTAR Y BLOQUEAR la tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)	
		return -1
	end if	
	
	do
		invo_wait.of_mensaje( "Generando numero de Documento " + string(ll_ult_nro) )
			
		if gnvo_app.of_get_parametro("FINANZAS_NRO_DOC_HEXADECIMAL", "0") = "1" then
			ls_nro_doc = trim(gs_origen) + invo_util.lpad(invo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(gs_origen)), '0')
		else
			ls_nro_doc = trim(gs_origen) + invo_util.lpad(string( ll_ult_nro ), 10 - len(trim(gs_origen)), '0')
		end if	
		
		SELECT count(*)
			into :ll_count
		from cntas_pagar cp
		where cp.cod_Relacion 	= :ls_Cod_relacion
		  and cp.tipo_doc			= :ls_tipo_doc
		  and cp.nro_doc			= :ls_nro_doc;
		  
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			Messagebox('Error','Ha ocurrido un error al CONTAR LOS REGISTROS en CNTAS PAGAR. Mensaje: ' + ls_mensaje, StopSign!)	
			return -1
		end if	
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
			
	loop while ll_count > 0
	
	
	dw_master.object.nro_doc [1] = ls_nro_doc
	
	UPDATE num_doc_tipo
		SET ultimo_numero = ultimo_numero + 1
	 WHERE tipo_doc = :ls_tipo_doc 
	   and trim(nro_serie) = trim(:gs_origen);
	 
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox('Error','Ha ocurrido un error al realizar el UPDATE en la tabla NUM_DOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)	
		Return -1
	END IF	
	
	Return 1

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")

FINALLY
	invo_wait.of_close()
end try


end function

on w_fi329_pagar_directo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_dir" then this.MenuID = create m_mantenimiento_cl_anular_dir
this.rb_ref_ov=create rb_ref_ov
this.rb_ref_os=create rb_ref_os
this.rb_ref_oc=create rb_ref_oc
this.rb_sin_ref=create rb_sin_ref
this.cb_2=create cb_2
this.tab_1=create tab_1
this.cb_referencia=create cb_referencia
this.rb_gen=create rb_gen
this.rb_esp=create rb_esp
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ref_ov
this.Control[iCurrent+2]=this.rb_ref_os
this.Control[iCurrent+3]=this.rb_ref_oc
this.Control[iCurrent+4]=this.rb_sin_ref
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.cb_referencia
this.Control[iCurrent+8]=this.rb_gen
this.Control[iCurrent+9]=this.rb_esp
this.Control[iCurrent+10]=this.dw_master
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_fi329_pagar_directo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_ref_ov)
destroy(this.rb_ref_os)
destroy(this.rb_ref_oc)
destroy(this.rb_sin_ref)
destroy(this.cb_2)
destroy(this.tab_1)
destroy(this.cb_referencia)
destroy(this.rb_gen)
destroy(this.rb_esp)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;of_asignar_dws()

is_salir = ''

//Verifico que se cargen los parametros en variables de instancia
IF of_get_param() = 0 THEN
   is_salir = 'S'
	post event closequery()   
	RETURN
END IF

dw_master.SetTransObject(sqlca)  			         // Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_referencia.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
idw_detail.BorderStyle = StyleRaised!		// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija


//** Insertamos GetChild de Forma de Pago **//
dw_master.Getchild('forma_pago',idw_forma_pago)
idw_forma_pago.settransobject(sqlca)
idw_forma_pago.Retrieve()

invo_wait = CREATE n_Cst_wait	
//** **//



end event

event ue_update_pre;Long 	  	ll_inicio,ll_count,ll_ano
String  	ls_cod_relacion,ls_tipo_doc			,ls_nro_doc    	,ls_nro_reg        	,ls_flag        ,&
		  	ls_cod_moneda 	,ls_flag_llave_num 	,ls_flag_apresup	,ls_cnta_prsp   ,&
			ls_cencos  		,ls_item		  			,ls_fctrl_reg		,ls_doc_aoc		,&
		  	ls_doc_aos	  	,ls_nro_ref 					,ls_flag_estado,ls_origen_ref		,ls_tipo_ref	,&
		  	ls_doc_ov		  ,ls_cebef
Decimal 	ldc_importe_doc  ,ldc_saldo_sol		,ldc_saldo_dol		 ,ldc_monto_total	  ,&
			ldc_saldo_sol_ant,ldc_saldo_dol_ant ,ldc_saldo_sol_old ,ldc_saldo_dol_old, &
			ldc_tasa_cambio


of_asignar_dws()

if is_accion = 'delete' then return

ib_update_check = False	

IF dw_master.Rowcount() = 0  THEN
	MEssageBox('Error', 'No hay documento a grabar, por favor verifique!', StopSign!)
	RETURN
END IF	

IF dw_master.Rowcount() = 0  THEN
	MEssageBox('Error', 'No hay detalle del documento a grabar, por favor verifique!', StopSign!)
	RETURN
END IF	

IF is_accion = 'new' THEN
	if of_verifica_documento () = false then
		Return
	end if
END IF

//Verificación de Data en Cabecera de Documento
IF not gnvo_app.of_row_Processing( dw_master ) then return
IF not gnvo_app.of_row_Processing( idw_detail ) then return



//lee parametros
select doc_anticipo_oc,doc_anticipo_os 
	into :ls_doc_aoc,:ls_doc_aos
  from finparam
 where (reckey = '1') ;

 select doc_ov into :ls_doc_ov
   from logparam
  where (reckey = '1') ;
  

ls_cod_relacion = dw_master.Object.cod_relacion     [1] 
ls_tipo_doc     = dw_master.Object.tipo_doc		    [1] 
ls_nro_doc      = dw_master.Object.nro_doc  	       [1] 
ldc_importe_doc = dw_master.Object.importe_doc      [1] 
ls_cod_moneda	 = dw_master.Object.cod_moneda       [1] 
ldc_tasa_cambio = dw_master.Object.tasa_cambio      [1] 
ls_flag_apresup = dw_master.Object.flag_afecta_prsp [1] 
ls_fctrl_reg	 = dw_master.Object.flag_control_reg [1]
ls_flag_estado	 = dw_master.Object.flag_estado		 [1]



ll_ano = Long(String(dw_master.object.fecha_emision [1],'yyyy'))


IF (IsNull(ls_nro_doc) or trim(ls_nro_doc) = '') or (is_action = 'new' and f_tdoc_fnum(ls_tipo_doc) = '1') THEN 
	IF of_set_numera() = -1 THEN return		

	ls_nro_doc = dw_master.Object.nro_doc [1] 
END IF


IF ls_cod_moneda = gnvo_app.is_soles THEN 
	ldc_saldo_sol = ldc_importe_doc
	ldc_saldo_dol = Round(ldc_importe_doc / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = gnvo_app.is_dolares THEN
	ldc_saldo_sol = Round(ldc_importe_doc *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_importe_doc
END IF

//saldos
dw_master.object.saldo_sol [1] = ldc_saldo_sol 
dw_master.object.saldo_dol [1] = ldc_saldo_dol


For ll_inicio = 1  TO idw_detail.Rowcount()
	 idw_detail.object.cod_relacion [ll_inicio] = ls_cod_relacion 
	 idw_detail.object.tipo_doc     [ll_inicio] = ls_tipo_doc
	 idw_detail.object.nro_doc		  [ll_inicio] = ls_nro_doc
	 
    ls_cebef 	  = idw_detail.object.centro_benef [ll_inicio]
	 ls_item		  = Trim(String(idw_detail.object.item [ll_inicio]))
	 ls_cnta_prsp = idw_detail.object.cnta_prsp [ll_inicio]
	 ls_cencos	  = idw_detail.object.cencos    [ll_inicio]
	 
	 
	 if is_flag_valida_cbe = '1' then
//		IF idw_detail.object.flag_cebef [ll_inicio] = 1  then
		if ls_flag_estado = '0' then
			idw_detail.ii_update = 1
		elseIF Isnull(ls_cebef) OR Trim(ls_cebef) = '' THEN
				 Messagebox('Aviso','Centro de Beneficio No Puede Ser Nulo , Verifique!')
				 ib_update_check = False	
				 Return 			 	
			 END IF
//		end if
	 end if
	 
	 //verifica presupuesto de acuerdo a flag de documento
	 if ls_flag_apresup = '1' then //validar partidas
	 	 select count(*) into :ll_count from presupuesto_partida 
		  where (cencos    = :ls_cencos    ) and
		  		  (cnta_prsp = :ls_cnta_prsp ) and
				  (ano		 = :ll_ano       );
		 
		 
		 
		 if ll_count = 0 then
			 Messagebox('Aviso','Partida Presupuestal de Item'+ ls_item +' No Existe ,Verifique!')
			 RETURN
		 end if
	 end if
Next	

For ll_inicio = 1  TO idw_referencia.Rowcount()
	 idw_referencia.object.cod_relacion [ll_inicio] = ls_cod_relacion
	 idw_referencia.object.tipo_doc     [ll_inicio] = ls_tipo_doc
	 idw_referencia.object.nro_doc		[ll_inicio] = ls_nro_doc
	 
	
Next


if (trim(ls_doc_aoc) = trim(ls_tipo_doc) or trim(ls_doc_aos) = trim(ls_tipo_doc)) then
	if ls_fctrl_reg = '0' then //debe ser documento tipo cuenta corriente
		Messagebox('Aviso','Documento debe ser Tipo Cuenta Corriente')
		RETURN
	end if
end if






//datos de referencia
select flag_llave_num 
	into :ls_flag_llave_num 
from doc_tipo 
where (tipo_doc = :ls_tipo_doc ) ;

IF ls_flag_llave_num = '0' AND idw_referencia.Rowcount() > 0 THEN
	
	Messagebox('Aviso','Documento no pide Referencia ,Verifique!')
	Return
	
ELSEIF ls_flag_llave_num = '1' AND idw_referencia.Rowcount() = 0 THEN
	
	Messagebox('Aviso','Documento pide Referencia ,Verifique!')
	return	
	
ELSEIF ls_flag_llave_num = '1' AND idw_referencia.Rowcount() > 1 THEN
	
	Messagebox('Aviso','Documento solo debe pedir Una Referencia ,Verifique!')
	return		
	
END IF


/*verificar monto*/
if ls_flag_llave_num = '1' and ls_flag_estado = '1' then
	ls_origen_ref = idw_referencia.object.origen_ref [1]
	ls_tipo_ref	  = idw_referencia.object.tipo_ref   [1]
	ls_nro_ref    = idw_referencia.object.nro_ref  	 [1]

	if ls_fctrl_reg = '0' then //debe ser documento tipo cuenta corriente
		Messagebox('Aviso','Documento debe ser Tipo Cuenta Corriente')
		RETURN
	end if


	if ls_tipo_ref <> ls_doc_ov then
	
		if TRIM(ls_tipo_doc) = TRIM(ls_doc_aoc) then //orden compra
			select monto_total into :ldc_monto_total from orden_compra where nro_oc = :ls_nro_ref ;
		elseif TRIM(ls_tipo_doc) = TRIM(ls_doc_aos) then //orden servicio
			select monto_total into :ldc_monto_total from orden_servicio where nro_os = :ls_nro_ref ;
		end if
	
		if ldc_importe_doc > ldc_monto_total  and ls_flag_estado = '1' then
			Messagebox('Aviso','Monto de Anticipo no debe ser mayor al de la Orden')
			return		
		end if
	end if
	
	


	
	wf_verifica_anticipos (ls_origen_ref,ls_tipo_ref,ls_nro_ref,ldc_saldo_sol_ant,ldc_saldo_dol_ant)
	
	//verifico control de anticipos
	if is_accion = 'new' then
		if ls_cod_moneda = gnvo_app.is_soles then
			ldc_saldo_sol = ldc_saldo_sol_ant + ldc_saldo_sol
		
			if ldc_saldo_sol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		elseif ls_cod_moneda = gnvo_app.is_dolares then
			
			ldc_saldo_dol = ldc_saldo_dol_ant + ldc_saldo_dol
		
			if ldc_saldo_dol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		end if		
		
	elseif is_accion = 'fileopen' then
		//busco saldo de documento actual
		select saldo_sol,saldo_dol 
			into :ldc_saldo_sol_old,:ldc_saldo_dol_old
		from cntas_pagar 
		where tipo_doc     = :ls_tipo_doc    
		  and nro_doc      = :ls_nro_doc     
		  and cod_relacion = :ls_cod_relacion;
												
		
		if ls_cod_moneda = gnvo_app.is_soles then
			ldc_saldo_sol = (ldc_saldo_sol_ant - ldc_saldo_sol_old) + ldc_saldo_sol
		
			if ldc_saldo_sol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		elseif ls_cod_moneda = gnvo_app.is_dolares then
			
			ldc_saldo_dol = (ldc_saldo_dol_ant - ldc_saldo_dol_old)+ ldc_saldo_dol
		
			if ldc_saldo_dol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		end if		
		
	end if
	
	

end if



/*Replicacion*/
dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()
idw_referencia.of_set_flag_replicacion()

ib_update_check = True
end event

event ue_insert;call super::ue_insert;Long   ll_row,ll_row_master
String ls_flag_estado


IF idw_1 = dw_master THEN
	TriggerEvent('ue_update_request')
	idw_1.Reset ()
	tab_1.tabpage_1.dw_detail.Reset ()
	tab_1.tabpage_2.dw_referencia.Reset ()
	is_accion = 'new'
ELSEIF idw_1 = tab_1.tabpage_1.dw_detail THEN
	ll_row_master  = dw_master.getrow()
	ls_flag_estado = dw_master.object.flag_estado [ll_row_master]
	
	IF ls_flag_estado <> '1' THEN
		Messagebox('Aviso','No se Pueden Ingresar Registros en el Detalle, Verifique Estado del Documento!')
		Return
	END IF
ELSEIF idw_1 = tab_1.tabpage_2.dw_referencia THEN
	RETURN
END IF	


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR tab_1.tabpage_2.dw_referencia.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update 	 = 0
		tab_1.tabpage_2.dw_referencia.ii_update = 0
	END IF
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()
idw_referencia.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF	

IF ib_log THEN
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_referencia.of_create_log()
END IF

if is_accion = 'delete' then

	IF idw_referencia.ii_update = 1 THEN
		IF idw_referencia.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	
	IF idw_detail.ii_update = 1 THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF



	
ELSE
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_detail.ii_update = 1 THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_referencia.ii_update = 1 THEN
		IF idw_referencia.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF	
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_referencia.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_referencia.ii_update = 0

	dw_master.ResetUpdate( )
	idw_detail.ResetUpdate( )
	idw_referencia.ResetUpdate( )

	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	
	f_mensaje("Cambios grabados satisfactoriamente, por favor verifique!", "")
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_delete;//override
Long   ll_row
String ls_flag_estado,ls_flag_cbancos

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

IF idw_1 = dw_master THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado      [dw_master.Getrow()]
ls_flag_cbancos = dw_master.object.flag_caja_bancos [dw_master.Getrow()]

IF ls_flag_estado <> '1' OR ls_flag_cbancos <> '0' THEN RETURN
	

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event resize;call super::resize;of_asignar_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 30

idw_detail.width 	 	 = tab_1.tabpage_1.width  - idw_detail.x     - 10
idw_detail.height 	 = tab_1.tabpage_1.height - idw_detail.y     - 10

idw_referencia.width  = tab_1.tabpage_2.width  - idw_referencia.x - 10
idw_referencia.height = tab_1.tabpage_2.height - idw_referencia.y - 10

end event

event ue_modify;call super::ue_modify;Long    ll_row_master, ll_count
Integer li_protect
String  ls_flag_estado,ls_tipo_doc,ls_flag,ls_flag_cbancos, ls_cod_relacion, ls_nro_doc

ll_row_master = dw_master.Getrow()

ls_flag_estado  	= dw_master.Object.flag_estado      [1] 
ls_tipo_doc     	= dw_master.Object.tipo_doc         [1]
ls_flag_cbancos 	= dw_master.Object.flag_caja_bancos [1]
ls_nro_doc			= dw_master.Object.nro_doc         	[1]
ls_cod_Relacion	= dw_master.Object.cod_Relacion    	[1]

//Valido si el documento existe en el esta en caja bancos
select count(*)
	into :ll_count
from caja_bancos cb,
     caja_bancos_det cbd
where cb.origen        = cbd.origen
  and cbd.nro_registro = cbd.nro_registro
  and cbd.cod_relacion = :ls_cod_relacion
  and cbd.tipo_doc     = :ls_tipo_doc
  and cbd.nro_doc      = :ls_nro_doc
  and cb.flag_estado   <> '0';

if ll_count > 0 then
	MessageBox('Aviso', 'El documento ya se encuentra registrado en CAJA BANCOS, no se puede modificar', StopSign!)
	
	dw_master.ii_protect  		= 0
	idw_detail.ii_protect	 	= 0
	idw_referencia.ii_protect	= 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencia.of_protect()
	
	return
end if

//Si el documento ya no se encuentra activo tambien lo desactivo
IF ls_flag_estado <> '1' OR ls_flag_cbancos = '1' THEN
	MessageBox('Aviso', 'El documento no se encuentra activo, no se puede modificar', StopSign!)
	
	dw_master.ii_protect  = 0
	idw_detail.ii_protect	 = 0
	idw_referencia.ii_protect	 = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencia.of_protect()
end if


dw_master.of_protect()
idw_detail.of_protect()


IF is_accion = 'fileopen' THEN
	// Protejo tipo de cambio
	IF idw_detail.Rowcount( ) > 0 THEN
		dw_master.object.cod_moneda.Protect = 1
	END IF
	li_protect = integer(dw_master.Object.tipo_doc.Protect)
	IF li_protect = 0	THEN
		dw_master.object.tipo_doc.Protect 	  = 1
		dw_master.object.cod_relacion.Protect = 1
		dw_master.object.nro_doc.Protect      = 1
	END IF
END IF		

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio ,ll_ano ,ll_count
String ls_cencos,ls_cnta_prsp ,ls_origen ,ls_null ,ls_cebef
str_parametros sl_param

SetNull(ls_null)
TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_doc_pagar_dir_tbl'
sl_param.titulo = 'Cuentas x Pagar'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc

//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
   of_cambiar_dw(Trim(sl_param.field_ret[2]))
	idw_detail.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_2.dw_referencia.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	    if is_flag_valida_cbe = '1' then //valida centro de beneficio
	   	 ls_cencos    = tab_1.tabpage_1.dw_detail.object.cencos	  [ll_inicio]
			 ls_cnta_prsp = tab_1.tabpage_1.dw_detail.object.cnta_prsp [ll_inicio]
			 ll_ano		  = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
			 ls_origen	  = dw_master.object.origen 		  [1]	
			 
			 //VERIFICAR SIEMPRE Y CUANDO CUMPLA CONDICIONES DE PARTIDA FONDO
			 ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)

			 if ll_count > 0 then
				 tab_1.tabpage_1.dw_detail.object.flag_cebef   [ll_inicio] = ls_null	//no editable tipo fondo
				 ls_cebef = tab_1.tabpage_1.dw_detail.object.centro_benef [ll_inicio]
				 
				 if Isnull(ls_cebef) or Trim(ls_cebef) = '' then
					 tab_1.tabpage_1.dw_detail.object.centro_benef [ll_inicio] = of_cbenef_origen(ls_origen)
					 tab_1.tabpage_1.dw_detail.ii_update = 1
					 dw_master.ii_update = 1
				 end if
			 else
			    tab_1.tabpage_1.dw_detail.object.flag_cebef   [ll_inicio] = '1'     //editable		
			 end if
		 end if	 
	Next
	
	dw_master.il_row = dw_master.getrow()
	
	// Validar si es AOS y AOC
	if sl_param.field_ret[2] = is_doc_aoc then
		rb_ref_oc.checked = true
		rb_ref_oc.enabled = true
		rb_ref_os.enabled = false
		rb_ref_ov.enabled = false
		rb_sin_ref.enabled = false
		cb_referencia.enabled = true
		
	elseif sl_param.field_ret[2] = is_doc_aos then
		rb_ref_os.checked = true
		rb_ref_os.enabled = true
		rb_ref_oc.enabled = false
		rb_ref_ov.enabled = false
		rb_sin_ref.enabled = false
		cb_referencia.enabled = true
		
	else
		rb_ref_oc.enabled = true
		rb_ref_os.enabled = true
		rb_ref_ov.enabled = true
		rb_sin_ref.enabled = true
		rb_sin_ref.checked = true
		cb_referencia.enabled = false
		
	end if


	TriggerEvent('ue_modify')
	is_accion = 'fileopen'	
END IF


end event

event ue_print;call super::ue_print;String  ls_tip_doc, ls_cod_relacion,ls_nro_ce,ls_flag_rep
Str_cns_pop lstr_cns_pop
Long ll_row_master

ll_row_master = dw_master.Getrow ()
IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 OR &
	tab_1.tabpage_1.dw_detail.ii_update = 1 THEN 
	
	Messagebox('Aviso','Debe Grabar el Documento , Tiene Modificaciones , Verifique!')
	Return
	
END IF	

IF rb_gen.checked THEN
	ls_flag_rep = 'G'
ELSEIF rb_esp.checked THEN
	ls_flag_rep = 'E'	
END IF

//Verificacion de comprobante de Egreso
ls_tip_doc      = dw_master.object.tipo_doc		[ll_row_master]
ls_nro_ce       = dw_master.object.nro_doc		[ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]

lstr_cns_pop.arg[1] = trim(ls_cod_relacion)
lstr_cns_pop.arg[2] = trim(ls_tip_doc)
lstr_cns_pop.arg[3] = trim(ls_nro_ce)
lstr_cns_pop.arg[4] = trim(ls_flag_rep)
lstr_cns_pop.arg[5] = trim(is_doc_cml)
lstr_cns_pop.arg[6] = String(idc_monto_max_mov, '###,##0.00')

	

//IF f_imp_f_general () = FALSE THEN RETURN
	

OpenSheetWithParm(w_rpt_comprobante_egreso, lstr_cns_pop, this, 2, LAyered!)

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;/*actualizar cabecera*/
dw_master.object.importe_doc [dw_master.getrow()] = wf_total ()
dw_master.ii_update = 1 

IF idw_detail.rowcount( ) = 0 THEN
	dw_master.object.cod_moneda.Protect = 0
END IF
	
end event

event closequery;// Ancester Override

CHOOSE CASE is_salir
	CASE 'S'
		CLOSE (THIS)
	
	CASE ELSE
		THIS.Event ue_close_pre()
		THIS.EVENT ue_update_request()
		
		IF ib_update_check = False THEN
			ib_update_check = TRUE
			RETURN 1
		END IF
		
		Destroy	im_1
		
		of_close_sheet()
		
END CHOOSE
end event

event close;call super::close;destroy invo_wait	
end event

event ue_set_access;//Override
Datastore		lds_nc
Long				ll_total
Integer			li_x, li_y, li_opcion, li_niveles, li_c[6]
String			ls_temp, ls_c
m_mantenimiento_cl_anular_dir	lnvo_menu

IF ii_access = 1 THEN RETURN

if this.WindowType = response! then return

IF NOT IsValid(THIS.MenuID) THEN
	MessageBox('Error', 'Esta Ventana no tiene Menu', StopSign!)
	RETURN
END IF

lnvo_menu = this.MenuID


//Indico cada uno de los accesos
if is_flag_insertar = '1' then
	lnvo_menu.m_file.m_basedatos.m_insertar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	lnvo_menu.m_file.m_basedatos.m_eliminar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	lnvo_menu.m_file.m_basedatos.m_modificar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_consultar = '1' then
	lnvo_menu.m_file.m_basedatos.m_abrirlista.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_abrirlista.enabled = false
end if

if is_flag_anular = '1' then
	lnvo_menu.m_file.m_basedatos.m_anulartransacion.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_anulartransacion.enabled = false
end if

if is_flag_anular = '1' then
	lnvo_menu.m_file.m_basedatos.m_anular.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cancelar = '1' then
	lnvo_menu.m_file.m_basedatos.m_cancelar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_cancelar.enabled = false
end if

if is_flag_duplicar = '1' then
	lnvo_menu.m_file.m_basedatos.m_duplicar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_duplicar.enabled = false
end if

if is_flag_cerrar = '1' then
	lnvo_menu.m_file.m_basedatos.m_cerrar.enabled = true
else
	lnvo_menu.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_insertar = '0' and is_flag_eliminar = '0' and is_flag_modificar = '0' and &
	is_flag_anular	  = '0' and is_flag_cerrar   = '0' and is_flag_duplicar  = '0' then
	
	lnvo_menu.m_file.m_basedatos.m_grabar.enabled = false
else
	lnvo_menu.m_file.m_basedatos.m_grabar.enabled = true
	
end if


//lds_nc = CREATE Datastore
//lds_nc.DataObject = 'd_nivel_cord'
//lds_nc.SetTransObject(SQLCA)
//ll_total = lds_nc.Retrieve(gs_sistema)
//
//IF ll_total < 4 THEN
//	MessageBox('Error Sistema Seguridad', 'Faltan las Coordenadas de los Niveles', StopSign!)
//	RETURN
//END IF
//
//IF Upper(Mid(lds_nc.GetItemString(1, 'opcion'),1,3)) <> 'INS' THEN MessageBox('Error', 'Inserar tiene que ser 1')
//IF Upper(Mid(lds_nc.GetItemString(2, 'opcion'),1,3)) <> 'ELI' THEN MessageBox('Error', 'Eliminar tiene que ser 2')
//IF Upper(Mid(lds_nc.GetItemString(3, 'opcion'),1,3)) <> 'MOD' THEN MessageBox('Error', 'Modificar tiene que ser 3')
//IF Upper(Mid(lds_nc.GetItemString(4, 'opcion'),1,3)) <> 'CON' THEN MessageBox('Error', 'Consultar tiene que ser 4')
//
//IF ll_total >= 5 THEN // IF Provisional
//	IF Upper(Mid(lds_nc.GetItemString(5, 'opcion'),1,3)) <> 'DUP' THEN MessageBox('Error', 'Duplicar tiene que ser 5')
//	IF Upper(Mid(lds_nc.GetItemString(6, 'opcion'),1,3)) <> 'ANU' THEN MessageBox('Error', 'Anunar tiene que ser 6')
//	IF Upper(Mid(lds_nc.GetItemString(7, 'opcion'),1,3)) <> 'CAN' THEN MessageBox('Error', 'Cancelar tiene que ser 7')
//END IF
//
//ls_niveles = is_niveles
//
//FOR li_x = 1 to Len(is_niveles)
//	ls_temp = Mid(is_niveles, li_x, 1)
//	CHOOSE CASE ls_temp
//		CASE 'I'
//			li_opcion = 1
//			IF ll_total >= 5 THEN is_niveles = is_niveles + 'D' // Incluir Duplicacion // IF Provisional
//		CASE 'E'
//			li_opcion = 2
//		CASE 'M'
//			li_opcion = 3
//		CASE 'C'
//			IF ii_consulta = 0 THEN CONTINUE
//			li_opcion = 4
//		CASE 'D'
//			li_opcion = 5
//		CASE 'A'
//			li_opcion = 6
//		CASE 'N'
//			li_opcion = 7	
//		CASE ELSE
//			MessageBox('Error', 'Los niveles de la Ventana son Errados')
//	END CHOOSE
//	
//	// Habilitar opcion en el Menu y Toolbar
//	li_niveles = lds_nc.GetItemNumber(li_opcion, 'niveles')
//	
//	IF li_niveles < 1 THEN MessageBox('Error', 'El nro de Niveles esta errado', StopSign!)
//	FOR li_y = 1 TO li_niveles
//		ls_c = 'c'+ String(li_y)
//		li_c[li_y] =  lds_nc.GetItemNumber(li_opcion, ls_c)
//	NEXT
//	
//	CHOOSE CASE li_niveles
//		CASE 1
//			THIS.MenuID.item[li_c[1]].enabled = TRUE
//		CASE 2
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].enabled = TRUE
//		CASE 3
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].enabled = TRUE
//		CASE 4
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].enabled = TRUE
//		CASE 5
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].item[li_c[5]].enabled = TRUE
//		CASE 6
//			THIS.MenuID.item[li_c[1]].item[li_c[2]].item[li_c[3]].item[li_c[4]].item[li_c[5]].item[li_c[6]].enabled = TRUE
//		CASE ELSE
//			MessageBox('Error', 'No hay tantos Niveles')
//	END CHOOSE
//NEXT


end event

type rb_ref_ov from radiobutton within w_fi329_pagar_directo
integer x = 2720
integer y = 400
integer width = 526
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Venta"
end type

event clicked;cb_referencia.enabled = true
end event

type rb_ref_os from radiobutton within w_fi329_pagar_directo
integer x = 2720
integer y = 328
integer width = 526
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Servicio"
end type

event clicked;cb_referencia.enabled = true
end event

type rb_ref_oc from radiobutton within w_fi329_pagar_directo
integer x = 2720
integer y = 256
integer width = 526
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Compra"
end type

event clicked;cb_referencia.enabled = true
end event

type rb_sin_ref from radiobutton within w_fi329_pagar_directo
integer x = 2720
integer y = 184
integer width = 526
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sin referencia"
boolean checked = true
end type

event clicked;cb_referencia.enabled = false
end event

type cb_2 from commandbutton within w_fi329_pagar_directo
integer x = 2674
integer y = 484
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Asociar a OT"
end type

event clicked;Long  ll_row_master 

str_parametros sl_param


ll_row_master = dw_master.Getrow()

IF ll_row_master = 0  THEN RETURN

IF dw_master.ii_update = 1  OR tab_1.tabpage_1.dw_detail.ii_update = 1  & 
   OR tab_1.tabpage_2.dw_referencia.ii_update = 1   THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
	Return
END IF

//datos del documento/
sl_param.string1     = dw_master.object.cod_relacion  [ll_row_master]
sl_param.string2		 = dw_master.object.tipo_doc     [ll_row_master]
sl_param.string3		 = dw_master.object.nro_doc      [ll_row_master]

OpenWithParm(w_abc_relacionar_ot, sl_param)

end event

type tab_1 from tab within w_fi329_pagar_directo
integer y = 944
integer width = 3538
integer height = 624
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3502
integer height = 504
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 3470
integer height = 464
integer taborder = 30
string dataobject = "d_abc_comprobante_egreso_det_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1	// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_rk[1] = 1 	// columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3


idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event itemchanged;call super::itemchanged;Long   	ll_count,ll_ano,ll_mes
String 	ls_codigo,ls_cencos,ls_cnta_prsp, ls_origen
Decimal	ldc_monto_mov, ls_nom_trabajador, ls_dni

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_trabajador'
		
		select nom_trabajador, nro_doc_ident_rtps
		  into :ls_nom_trabajador, :ls_dni
		  from vw_pr_trabajador m
		 Where m.cod_trabajador = :data
		   and m.flag_estado  = '1';
		 
		IF SQLCA.SQLCode = 100  THEN
			gnvo_app.of_message_Error('Código de trabajador ' + data + ' No existe o no esta activo, por favor Verifique!')
			This.Object.cod_trabajador 		[row] = gnvo_app.is_null
			This.Object.nom_trabajador 		[row] = gnvo_app.is_null
			This.Object.nro_doc_ident_rtps 	[row] = gnvo_app.is_null
			Return 1
		END IF
		
		This.Object.nom_trabajador 		[row] = ls_nom_trabajador
		This.Object.nro_doc_ident_rtps 	[row] = ls_dni
		
	CASE 'fec_movilidad'
		
		IF TRIM(dw_master.object.tipo_doc[1]) = TRIM(is_doc_cml) THEN
			
			ldc_monto_mov = of_monto_mov(DATE(this.object.fec_movilidad[row]), this.object.cod_trabajador[row])
			
			IF ldc_monto_mov > idc_monto_max_mov THEN
				gnvo_app.of_message_Error('El limite por movilidad ha sido excedido')
				This.object.importe [row] = 0
				RETURN 1
			END IF
		END IF
		
	CASE	'importe'
		IF TRIM(dw_master.object.tipo_doc[1]) = TRIM(is_doc_cml) THEN
			
			ldc_monto_mov = of_monto_mov(DATE(this.object.fec_movilidad[row]), this.object.cod_trabajador[row])
			
			IF ldc_monto_mov > idc_monto_max_mov THEN
				gnvo_app.of_message_Error('El limite por movilidad ha sido excedido')
				This.object.importe [row] = 0
				RETURN 1
			END IF
		END IF
		
		dw_master.object.importe_doc [1] = wf_total ()
		dw_master.ii_update = 1
		
	CASE 'cencos'			
		ls_origen	 = dw_master.object.origen [1]
		ll_ano		 = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
		ls_cencos	 = this.object.cencos    [row]
		ls_cnta_prsp = this.object.cnta_prsp [row]
						
		SELECT Count(*)
		  INTO :ll_count
		  FROM centros_costo
		 WHERE flag_estado = '1'   
		   AND cencos		  = :data ;
				  
		IF ll_count = 0 THEN
			gnvo_app.of_message_Error('Centro de Costo '+data+' No Existe o no esta activo, por favor Verifique!')
			This.Object.cencos [row] = gnvo_app.is_null
			Return 1 
		END IF		
		
		if is_flag_valida_cbe = '1' then //valida centro de beneficio
			//de acuerdo a parametros 
			ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)
	
			if ll_count > 0 then
				This.object.flag_cebef   [row] = gnvo_app.is_null	//no editable tipo fondo
				This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
			else
				This.object.flag_cebef [row] = '1'     //editable		
			end if
		
		end if
		
		
	CASE 'cnta_prsp'
	
		ls_origen	 = dw_master.object.origen [1]
		ll_ano		 = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
		ls_cencos	 = this.object.cencos    [row]
		ls_cnta_prsp = this.object.cnta_prsp [row]
		
	
		SELECT Count(*)
		  INTO :ll_count
		  FROM presupuesto_cuenta
		 WHERE cnta_prsp = :data
		   and flag_estado = '1';
		 
		IF ll_count = 0 THEN
			gnvo_app.of_message_Error('Cuenta Preuspuestal ' + ls_cnta_prsp + ' No Existe o no se encuentra activo, por favor Verifique!')
			This.Object.cnta_prsp [row] = gnvo_app.is_null
			Return 1
		END IF				
		
		if is_flag_valida_cbe = '1' then //valida centro de beneficio
			//de acuerdo a parametros 
			ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)
	
			if ll_count > 0 then
				This.object.flag_cebef   [row] = gnvo_app.is_null	//no editable tipo fondo
				This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
			else
				This.object.flag_cebef [row] = '1'     //editable		
			end if
		
		end if
		
		
	CASE 'centro_benef'
		select Count(*) 
		  into :ll_count 
		  from centro_beneficio
		 Where centro_benef = :data	
		   and flag_estado  = '1';
		 
		IF ll_count = 0  THEN
			gnvo_app.of_message_Error('Centro de Beneficio ' + data + ' No existe o no esta activo, por favor Verifique!')
			This.Object.centro_benef [row] = gnvo_app.is_null
			Return 1
		END IF
				
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)	
end event

event ue_insert_pre;call super::ue_insert_pre;String 	ls_cod_relacion, ls_cencos
Integer	li_count

ls_cod_relacion = dw_master.object.cod_relacion [1]

select count(*)
	into :li_count
from maestro 
where cod_trabajador = :ls_Cod_relacion;

if li_count > 0 then
	select cencos
		into :ls_cencos
	from maestro 
	where cod_trabajador = :ls_Cod_relacion;
end if

This.Object.item     [al_row] = al_row
This.Object.cantidad [al_row] = 1
This.Object.cencos	[al_row] = ls_cencos

dw_master.object.cod_moneda.Protect = 1


end event

event getfocus;call super::getfocus;IF f_row_Processing(dw_master, "form") <> true then	
	dw_master.setFocus( )
	return
end if
end event

event ue_display;call super::ue_display;String      ls_flag_cebef, ls_sql, ls_codigo, ls_data, ls_dni, ls_year, ls_cencos


CHOOSE CASE lower(as_columna)
	CASE	'cod_trabajador'
		ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
				 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
				 + "m.NRO_DOC_IDENT_RTPS as dni " &
				 + "from vw_pr_trabajador m " &
				 + "where m.flag_estado = '1'"
				 
		gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_dni, "2")
		
		if ls_codigo <> "" then
			this.object.cod_trabajador			[al_row] = ls_codigo
			this.object.nom_trabajador			[al_row] = ls_data
			this.object.nro_doc_ident_rtps	[al_row] = ls_dni
			this.ii_update = 1
		end if
		
	CASE	'cencos'
		ls_year = string(dw_master.object.fecha_emision[dw_master.getRow()], 'yyyy')
		
		ls_sql = "SELECT distinct cc.cencos AS codigo_cencos, " &
				  + "cc.desc_cencos AS descripcion_Cencos " &
				  + "FROM centros_costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cencos = cc.cencos " &
				  + "  and pp.ano = " + ls_year &
				  + "  and cc.flag_estado = '1'" &
				  + "  and pp.flag_estado <> '0'"
				 
		gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cencos	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	CASE 'cnta_prsp'
		ls_year = string(dw_master.object.fecha_emision[dw_master.getRow()], 'yyyy')
		ls_cencos = this.object.cencos [al_row]
		
		ls_sql = "SELECT distinct pc.cnta_prsp AS codigo_cnta_prsp, " &
				  + "pc.descripcion AS descripcion_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cnta_prsp = pc.cnta_prsp " &
				  + "  and pp.ano = " + ls_year &
				  + "  and pp.cencos = '" + ls_cencos + "'" &
				  + "  and pc.flag_estado = '1'" &
				  + "  and pp.flag_estado <> '0'"
				 
		gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if
				
CASE 'centro_benef'

		ls_sql = "SELECT Cb.CENTRO_BENEF AS CODIGO, "&
				 + "cb.DESC_CENTRO AS DESCRIPCION "&
				 + "FROM CENTRO_BENEFICIO cb "&
				 + "where cb.flag_estado <> '0'"
				 
		gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.centro_benef	[al_row] = ls_codigo
			this.ii_update = 1
		end if

END CHOOSE


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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3502
integer height = 504
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_referencia dw_referencia
end type

on tabpage_2.create
this.dw_referencia=create dw_referencia
this.Control[]={this.dw_referencia}
end on

on tabpage_2.destroy
destroy(this.dw_referencia)
end on

type dw_referencia from u_dw_abc within tabpage_2
integer width = 1627
integer height = 464
integer taborder = 20
string dataobject = "d_abc_referencias_x_cobrar_directo_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;RETURN 1
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1		// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7


idw_mst = tab_1.tabpage_2.dw_referencia
//idw_det  =  				// dw_detail
end event

type cb_referencia from commandbutton within w_fi329_pagar_directo
integer x = 2720
integer y = 68
integer width = 526
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Referencias"
end type

event clicked;
Long    ll_row_master
String  ls_cod_relacion,ls_flag_estado,ls_tipo_doc,ls_flag_llave_num
str_parametros sl_param

ll_row_master = dw_master.Getrow()

dw_master.Accepttext()

IF ll_row_master = 0 THEN Return

IF rb_ref_oc.checked = FALSE AND rb_ref_os.checked = FALSE AND rb_ref_ov.checked = FALSE THEN
	Messagebox('Aviso','Debe Seleccionar Algun tipo de Referencia ,Verifique!')
	RETURN
END IF

ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_tipo_doc		 = dw_master.object.tipo_doc	   [ll_row_master]




IF tab_1.tabpage_2.dw_referencia.Rowcount() > 0 THEN
	Messagebox('Aviso','Ya Existe Referencia..Verifique!')
	return
END IF

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Relacion ,Verifique!')
	Return
END IF

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Documento ,Verifique!')
	Return
END IF



IF ls_flag_estado = '0' THEN
	Messagebox('Aviso','Documento se encuentra Anulado ,Verifique!')
	Return
END IF

select flag_llave_num into :ls_flag_llave_num from doc_tipo where (tipo_doc = :ls_tipo_doc ) ;

IF ls_flag_llave_num = '0' THEN
	Messagebox('Aviso','Documento no pide Referencia ,Verifique!')
	Return
END IF


sl_param.string1 = ls_cod_relacion

IF rb_ref_oc.checked THEN //ORDEN DE COMPRA
	sl_param.dw1		= 'd_abc_lista_oc_pendientes_directas_tbl'
	sl_param.titulo	= 'Ordenes de Compras Pendientes x Proveedor '
	sl_param.tipo 		= '1OC'
	sl_param.opcion   = 20  //ORDENES DE COMPRA
	
ELSEIF rb_ref_os.checked THEN
	
	sl_param.dw1		= 'd_abc_lista_os_pendientes_directas_tbl'
	sl_param.titulo	= 'Ordenes de Servicio Pendientes x Proveedor '
	sl_param.tipo 		= '1OS'
	sl_param.opcion   = 21  //ORDENES DE SERVICIO
	
ELSEIF rb_ref_ov.checked THEN
	
	sl_param.dw1		= 'd_abc_lista_ov_directas_tbl'
	sl_param.titulo	= 'Ordenes de Ventas x Agente de Aduana'
	sl_param.tipo 		= '1OV'
	sl_param.opcion   = 26  //ORDENES DE VENTA
	
END IF

sl_param.db1 		 = 1350
sl_param.dw_m		 = tab_1.tabpage_2.dw_referencia
sl_param.dw_or_m	 = dw_master

OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_2.dw_referencia.ii_update = 1
END IF

end event

type rb_gen from radiobutton within w_fi329_pagar_directo
integer x = 2697
integer y = 640
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato GENERAL"
boolean checked = true
end type

type rb_esp from radiobutton within w_fi329_pagar_directo
integer x = 2697
integer y = 712
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Especial"
end type

type dw_master from u_dw_abc within w_fi329_pagar_directo
integer width = 2629
integer height = 932
string dataobject = "d_abc_comprobante_egreso_cab_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event itemchanged;call super::itemchanged;String      ls_nom_proveedor, ls_forma_pago, ls_codigo, ls_flag, &
				ls_flag_afecta_prsp, ls_null
Date        ld_fecha_emision, ld_fecha_vencimiento,ld_fecha_emision_old
Decimal {3} ldc_tasa_cambio
Integer		li_dias_venc , li_opcion
Long        ll_count,ll_inicio


ld_fecha_emision_old = Date(This.Object.fecha_emision [row])			
Accepttext()
SetNull(ls_null)

tab_1.tabpage_1.dw_detail.ii_update = 1

CHOOSE CASE dwo.name
	CASE 'tipo_doc'
		select Count(*) 
		  into :ll_count
		  from doc_grupo 				dg, 
		  		 doc_grupo_relacion 	dgr, 
				 finparam 				fp ,
				 doc_tipo 				dt
		 where (dg.grupo     = dgr.grupo             ) and
				 (dg.grupo     = fp.doc_grp_pag_directo) and
				 (dgr.tipo_doc	= dt.tipo_doc			   ) and
				 (dt.factor		= -1							) and
				 (dgr.tipo_doc = :data     				) ;
				 
		if ll_count = 0 then
			SetNull(ls_flag)
			This.object.tipo_doc [row] = ls_flag
			Messagebox('Aviso','Documento No Existe en Grupo de Documento x Pagar , Verifique!')
			Return 1
		end if

		// Verifico si ya existe el documento
		if of_verifica_documento( ) = false then
			this.object.tipo_doc[row] = ls_null
			this.setcolumn( "tipo_doc" )
			This.setFocus( )
			return 1
		end if
		
		ls_flag = f_tdoc_fnum(data)
		
		IF ls_flag = '1' THEN
			dw_master.object.nro_doc.Protect      = 1	
			dw_master.object.nro_doc.Background.Color = rgb(255,255,220)
		ELSE
			dw_master.object.nro_doc.Protect      = 0		
			dw_master.object.nro_doc.Background.Color = rgb(255,255,255)
		END IF
		
		//setear a nulo nro de doc
		setnull(ls_flag)
		This.Object.nro_doc [row] = ls_flag
		
		//busco flag de afectacion presupuestal
		select flag_afecta_prsp 
		  into :ls_flag_afecta_prsp 
		  from doc_tipo 
		 where (tipo_doc = :data) ;
		
		this.object.flag_afecta_prsp [row] = ls_flag_afecta_prsp
		

		// Cambiar DW si tipo_doc = comprobante movilidad
		of_cambiar_dw (TRIM(this.object.tipo_doc [row]))
		
		// Validar si es AOS y AOC
		if trim(data) = trim(is_doc_aoc) then
			rb_ref_oc.checked = true
			rb_ref_oc.enabled = true
			rb_ref_os.enabled = false
			rb_ref_ov.enabled = false
			rb_sin_ref.enabled = false
			cb_referencia.enabled = true
			
		elseif trim(data) = trim(is_doc_aos) then
			rb_ref_os.checked = true
			rb_ref_os.enabled = true
			rb_ref_oc.enabled = false
			rb_ref_ov.enabled = false
			rb_sin_ref.enabled = false
			cb_referencia.enabled = true
			
		else
			rb_ref_oc.enabled = true
			rb_ref_os.enabled = true
			rb_ref_ov.enabled = true
			rb_sin_ref.enabled = true
			rb_sin_ref.checked = true
			cb_referencia.enabled = false
			
		end if

		
	
	CASE 'cod_relacion'
		SELECT pr.nom_proveedor
		  INTO :ls_nom_proveedor
		  FROM proveedor pr
		 WHERE (pr.proveedor   = :data ) and
				 (pr.flag_estado = '1'   ) ; 
				 
		
		IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
			Messagebox('Aviso','Proveedor No Existe o no está activo, Verifique!')
			setnull(ls_flag)
			This.Object.cod_relacion [row] = ls_flag
			Return 1
		end if
		
		// Verifico si ya existe el documento
		if of_verifica_documento( ) = false then
			this.object.cod_relacion[row] = ls_null
			this.setcolumn( "cod_relacion" )
			This.setFocus( )
			return 1
		end if

		This.Object.nom_proveedor [row] = ls_nom_proveedor

	CASE 'nro_doc'
		// Verifico si ya existe el documento
		if of_verifica_documento( ) = false then
			this.object.nro_doc[row] = ls_null
			this.setcolumn( "nro_doc" )
			This.setFocus( )
			return 1
		end if


		
	CASE	'fecha_emision'
		ld_fecha_emision      = Date(This.Object.fecha_emision [row])			
		this.object.fecha_presentacion [row] = Date(This.Object.fecha_emision [row])			
		ld_fecha_vencimiento	 = Date(This.Object.vencimiento   [row])			
		ls_forma_pago			 = This.Object.forma_pago [row]	
		
		IF ld_fecha_emision > ld_fecha_vencimiento THEN
			This.Object.fecha_emision [row] = ld_fecha_emision_old
			Messagebox('Aviso','Fecha de Emisión del Documento No '&
									+'Puede Ser Mayor a la Fecha de Vencimiento')
			Return 1
		END IF
	
	
		This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
		
		IF Not (Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
			
			li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		
			IF li_dias_venc > 0 THEN
				li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
				
				IF li_opcion = 1 THEN
					ld_fecha_emision = Date(This.object.fecha_emision[row])
					ld_fecha_vencimiento = Relativedate(ld_fecha_emision,li_dias_venc)
					This.Object.vencimiento [row] = ld_fecha_vencimiento
				END IF
			END IF	
		END IF
	
	CASE 'vencimiento'	
		ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
		ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
		
		IF ld_fecha_vencimiento < ld_fecha_emision THEN
			This.Object.fecha_vencimiento [row] = ld_fecha_emision
			Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
									+'Puede Ser Menor a la Fecha de Emisión')
			Return 1
		END IF
	
	CASE	'forma_pago'
		li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		
		IF li_dias_venc > 0 THEN
			
			li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
			IF li_opcion = 1 THEN
				ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_emision[row]),li_dias_venc)
				This.Object.vencimiento [row] = ld_fecha_vencimiento
			END IF
		ELSE
			This.Object.vencimiento [row] = This.object.fecha_emision[row]
		END IF
				
END CHOOSE

				
end event

event itemerror;call super::itemerror;Return 1
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


ii_ck[1] = 1 // columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_dk[1] = 1 // columnas que se pasan al detalle
ii_dk[2] = 2 
ii_dk[3] = 3

idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_comp_egr

try 
	SELECT comprobante_egr INTO :ls_comp_egr FROM finparam WHERE reckey = '1' ;
	
	
	IF Isnull(ls_comp_egr) OR Trim(ls_comp_egr) = '' THEN 
		Messagebox('Aviso','Debe Ingresar Tipo Comprobante De Egreso en Finparam ')
	END IF	
	
	
	This.object.flag_estado       [al_row] = '1'
	This.object.flag_provisionado [al_row] = 'D'
	This.object.cod_usr           [al_row] = gs_user
	This.object.origen            [al_row] = gs_origen
	This.object.fecha_registro    [al_row] = DateTime(gd_fecha, now())
	This.object.fecha_emision     [al_row] = DateTime(gd_fecha, now())
	this.object.fecha_presentacion[al_row] = DateTime(gd_fecha, now())
	This.object.tasa_cambio       [al_row] = gnvo_app.of_tasa_cambio()
	This.object.flag_control_reg  [al_row] = '0'
	This.object.flag_caja_bancos  [al_row] = '0'
	
	//BLOQUEAR NRO DE DOCUMENTO...SE HABILITARA DE ACUERDO A DOCUMENTO
	dw_master.object.nro_doc.Protect = 1
	dw_master.object.nro_doc.Background.Color = rgb(155,155,155)
	
	if gnvo_app.of_get_parametro("FINANZAS_EDIT_FEC_EMISION_DPD", "0") = '1' THEN
		dw_master.object.fecha_emision.Protect = 1
	else
		dw_master.object.fecha_emision.Protect = 0
	END IF

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al insertar un registro")
	
finally
	/*statementBlock*/
end try

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event buttonclicked;call super::buttonclicked;string ls_data1, ls_data2, ls_null
SetNull(ls_null)
this.AcceptText()
choose case lower(dwo.name)
	case "b_1"
		if is_accion = 'new' then
			if of_verifica_documento () = false then
				Return
			end if
		end if
end choose
end event

event ue_display;call super::ue_display;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot ,ls_flag,ls_flag_afecta_prsp, ls_sql, ls_codigo, ls_data
Date		   ld_fecha_emision ,ld_fecha_vencimiento	
Decimal {3} ldc_tasa_cambio
boolean		lb_ret


CHOOSE CASE lower(as_columna)
		
	CASE 'tipo_doc'
		ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC,"&
				 + "DESC_TIPO_DOC AS DESCRIPCION "&
				 + "FROM VW_FIN_DOC_X_GRUPO_PAGAR" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.tipo_doc[al_row] = ls_codigo

			// Verifico si ya existe el documento
			if of_verifica_documento( ) = false then
				this.object.tipo_doc[al_row] = gnvo_app.is_null
				this.setcolumn( "tipo_doc" )
				This.setFocus( )
				return 
			end if			
			
			//NUMERADORES
			ls_flag = f_tdoc_fnum(ls_codigo)
		
			IF ls_flag = '1' THEN
				dw_master.object.nro_doc.Protect      = 1	
				dw_master.object.nro_doc.Background.Color = rgb(255,255,220)
			ELSE
				dw_master.object.nro_doc.Protect      = 0		
				dw_master.object.nro_doc.Background.Color = rgb(255,255,255)
			END IF
		
			//setear a nulo nro de doc
			This.Object.nro_doc [al_row] = gnvo_app.is_null					
			
			//busco flag de afectacion presupuestal
			select flag_afecta_prsp 
			  into :ls_flag_afecta_prsp 
			  from doc_tipo 
			  where (tipo_doc = :ls_codigo) ;
		
			this.object.flag_afecta_prsp [al_row] = ls_flag_afecta_prsp
			
			// Cambiar DW si tipo_doc = comprobante movilidad
			of_cambiar_dw (TRIM(this.object.tipo_doc [al_row]))
			
			// Validar si es AOS y AOC
			if ls_codigo = is_doc_aoc then
				rb_ref_oc.checked = true
				rb_ref_oc.enabled = true
				rb_ref_os.enabled = false
				rb_ref_ov.enabled = false
				rb_sin_ref.enabled = false
				cb_referencia.enabled = true
				
			elseif ls_codigo = is_doc_aos then
				rb_ref_os.checked = true
				rb_ref_os.enabled = true
				rb_ref_oc.enabled = false
				rb_ref_ov.enabled = false
				rb_sin_ref.enabled = false
				cb_referencia.enabled = true
				
			else
				rb_ref_oc.enabled = true
				rb_ref_os.enabled = true
				rb_ref_ov.enabled = true
				rb_sin_ref.enabled = true
				rb_sin_ref.checked = true
				cb_referencia.enabled = false
				
			end if
			
			// Hacer actualizable el datawindow
			this.ii_update = 1

		end if
		
	CASE 'cod_relacion'
	
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO_proveedor , "&
				 + "P.NOM_PROVEEDOR AS razon_social,"&
				 + "P.RUC AS NRO_RUC "				   &
				 + "FROM PROVEEDOR P " &
				 + "WHERE P.FLAG_ESTADO = '1'" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.cod_relacion[al_row] = ls_codigo
			this.object.nom_proveedor[al_row] = ls_data

			// Verifico si ya existe el documento
			if of_verifica_documento( ) = false then
				this.object.tipo_doc[al_row] = gnvo_app.is_null
				this.setcolumn( "tipo_doc" )
				This.setFocus( )
				return
			end if				
			ii_update = 1
		END IF
	
			
END CHOOSE


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type gb_1 from groupbox within w_fi329_pagar_directo
integer x = 2670
integer y = 592
integer width = 649
integer height = 212
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresión"
end type

type gb_2 from groupbox within w_fi329_pagar_directo
integer x = 2670
integer y = 16
integer width = 649
integer height = 464
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencia"
end type

