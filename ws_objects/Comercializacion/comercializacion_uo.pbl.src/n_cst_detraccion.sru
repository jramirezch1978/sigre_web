$PBExportHeader$n_cst_detraccion.sru
forward
global type n_cst_detraccion from nonvisualobject
end type
end forward

global type n_cst_detraccion from nonvisualobject
event ue_parametros ( ) throws exception
end type
global n_cst_detraccion n_cst_detraccion

type variables
string	is_doc_dtrc, is_pcon
integer 	ii_nro_decimales
u_dw_abc	idw_master
end variables

forward prototypes
public function boolean of_insert_cta_cta_dtrc (string as_cod_rel, string as_nro_doc, date adt_fecha_doc, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_origen, string as_descrip, decimal adc_importe_doc)
public function boolean of_insert_dtrc (string as_nro_detrac, string as_flag_estado, string as_nro_deposito, date adt_fecha_deposito, string as_cod_usr, decimal adc_importe, string as_flag_tabla, string as_tipo_doc, string as_nro_doc)
public function integer of_nro_decimales ()
public function string of_next_nro (string as_origen)
public function boolean of_udpate_cta_cte_dtrc (string as_nro_detraccion, decimal adc_imp_detraccion)
public function boolean of_update_dtrc (string as_nro_detrac, date adt_fecha_doc, decimal adc_monto_detrac, string as_const_deposito, date ad_fec_deposito)
public function boolean of_anular (string as_nro_detraccion)
public function boolean of_update (string as_nro_detraccion, string as_nro_deposito, date ad_fecha_deposito, decimal adc_importe, string as_flag_tabla)
end prototypes

event ue_parametros();string ls_mensaje
n_cst_configuracion lnvo_configuracion

//Busco el documento para la detraccion por cobrar
try 
	lnvo_configuracion = create n_cst_configuracion
	
	//Detraccion por cobrar
	is_doc_dtrc = lnvo_configuracion.of_get_parameter( 'DOC_DTRC')
	ii_nro_decimales = gnvo_app.of_get_parametro( "NRO_DECIMALES_DETRACCION", 0)
	
catch ( Exception ex )
	MessageBox('Exception', ex.getMessage())
	return
finally
	destroy lnvo_configuracion
end try

end event

public function boolean of_insert_cta_cta_dtrc (string as_cod_rel, string as_nro_doc, date adt_fecha_doc, string as_cod_moneda, decimal adc_tasa_cambio, string as_cod_usr, string as_origen, string as_descrip, decimal adc_importe_doc);String  	ls_msj_err   ,ls_forma_pago ,ls_cencos  ,ls_cnta_prsp 
Decimal 	ldc_saldo_sol ,ldc_saldo_dol
Boolean 	lb_ret = TRUE		 
DAteTime	ldt_fecha

ldt_fecha = gnvo_app.of_fecha_actual()

IF as_cod_moneda = gnvo_app.is_soles THEN
	ldc_saldo_sol = adc_importe_doc
	ldc_saldo_dol = Round(adc_importe_doc / adc_tasa_cambio,2)
ELSE
	ldc_saldo_sol = Round(adc_importe_doc * adc_tasa_cambio,2)
	ldc_saldo_dol = adc_importe_doc
END IF

/*documento detraccion*/
select cencos_detraccion,cnta_prsp_detraccion 
	into :ls_cencos,:ls_cnta_prsp 
from finparam 
where reckey = '1' ;


Insert Into cntas_cobrar(
	cod_relacion     	,tipo_doc 		    	,nro_doc     		 	,flag_estado , 
	fecha_registro   	,fecha_documento    	,fecha_vencimiento 	,forma_pago  ,	
 	cod_moneda		   ,tasa_cambio	    	,cod_usr	  		 		,origen		  ,
 	observacion	   	,flag_provisionado 	,importe_doc	    	,saldo_sol	  ,
 	saldo_dol		   ,flag_control_reg  	,flag_replicacion )  
Values(
	:as_cod_rel	 		,:is_doc_dtrc       	,:as_nro_doc      	,'1'				,
 	:ldt_fecha 			,:adt_fecha_doc    	,:adt_fecha_doc   	,:is_pcon       ,
 	:as_cod_moneda 	,:adc_tasa_cambio  	,:as_cod_usr	    	,:as_origen	   ,
 	:as_descrip	 		,'D'					 	,:adc_importe_doc 	,:ldc_saldo_sol  ,
 	:ldc_saldo_dol 	,'1'					 	,'1')  ;
 
 
IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
   ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Error Cntas Pagar',ls_msj_err)
	GOTO SALIDA
END IF 
 
 
 
Insert Into cntas_cobrar_det(
		tipo_doc 				,nro_doc 		, item 	,
 		descripcion  ,cantidad				,PRECIO_UNITARIO, cencos	,
 		cnta_prsp    ,flag_replicacion, 	flag_estado)
Values(
		:is_doc_dtrc 			,:as_nro_doc	,'1' 		 ,
 		:as_descrip   ,'1'			 		,:adc_importe_doc ,:ls_cencos ,
 		:ls_cnta_prsp ,'1', '1') ;


IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
   ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('Error Cntas Cobrar det',ls_msj_err)
	GOTO SALIDA	
END IF 


SALIDA:

Return lb_ret
end function

public function boolean of_insert_dtrc (string as_nro_detrac, string as_flag_estado, string as_nro_deposito, date adt_fecha_deposito, string as_cod_usr, decimal adc_importe, string as_flag_tabla, string as_tipo_doc, string as_nro_doc);Boolean 	lb_ret = TRUE
String  	ls_msj_err
DateTime	ldt_fecha

ldt_Fecha = gnvo_app.of_fecha_actual()


//detracion
/*********************************************************************
  REPLICACION
**********************************************************************/
Insert Into detraccion(
	nro_detraccion ,flag_estado,fecha_registro,nro_deposito,
	fecha_deposito ,cod_usr    ,importe       ,flag_tabla  ,
 	flag_replicacion, tipo_doc_cxc, nro_doc_cxc)
Values(
	:as_nro_detrac     ,:as_flag_estado	,:ldt_fecha,:as_nro_deposito,
 	:adt_fecha_deposito,:as_cod_usr    	,:adc_importe	     ,:as_flag_tabla  ,
 	'1'					 ,:as_tipo_doc		,:as_nro_doc);
 
IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	Rollback;
	lb_ret = FALSE
END IF

Return lb_ret 
end function

public function integer of_nro_decimales ();return ii_nro_decimales
end function

public function string of_next_nro (string as_origen);string 	ls_nro_detraccion
Long		ll_count, ll_ult_nro

//numerador de detraccion
select count(*)
 into :ll_count
 from num_detraccion no
where (no.origen = :as_origen);

if ll_count = 0 then
	insert into num_detraccion(origen, ult_nro)
   values(:as_origen, 1);
end if

select no.ult_nro
	into :ll_ult_nro
from num_detraccion no
where no.origen = :as_origen for update;

//Entra al loop para validar si existe o no el nro de detraccion
do 
	
	//se concatena con origen
	ls_nro_detraccion = trim(as_origen) + trim(string(ll_ult_nro, '00000000')) 
	
	//Valido si existe en cntas x cobrar
	select count(*)
	  into :ll_count
	  from cntas_cobrar cc
	 where cc.nro_detraccion = :ls_nro_detraccion;
	
	if ll_count > 0 then ll_ult_nro ++
 
loop while ll_count > 0

//actualiza información e numeradores
update num_detraccion no
   set no.ult_nro = :ll_ult_nro + 1
 where no.origen = :as_origen;

return ls_nro_detraccion
end function

public function boolean of_udpate_cta_cte_dtrc (string as_nro_detraccion, decimal adc_imp_detraccion);String 	ls_cod_moneda,ls_flag_cbancos,ls_msj_err, ls_centro_benef, ls_flag_provisionado, &
			ls_flag_control_reg, ls_cliente, ls_origen, ls_voucher, ls_org_cb, ls_descripcion
Date	 	ld_emision, ld_fec_pago
Long		ll_count, ll_reg_cb
Decimal 	ldc_importe,ldc_saldo_sol,ldc_saldo_dol, ldc_tasa_cambio, ldc_imp_detraccion

//DAtos para el voucher
Integer	li_year, li_mes, li_nro_libro, li_nro_asiento

if IsNull(this.idw_master) or not Isvalid(this.idw_master) then
	Rollback ;
	MessageBox('Error', 'No ha especificado el datawindows Master en el objecto ' + this.ClassName() + ', por favor verifique!', StopSign!)
	return false
end if

//Obtengo los datos del voucher original de la detraccion
if this.idw_master.RowCount() = 0 then
	Rollback ;
	MessageBox('Error', 'No existen registros en el datawindows MASTER especificado en el objecto ' + this.ClassName() + ', por favor verifique!', StopSign!)
	return false
end if

ls_origen				= idw_master.object.origen 					[idw_master.GetRow()]
ls_cliente	   		= idw_master.object.cod_relacion 			[idw_master.GetRow()]
ld_emision				= Date(idw_master.object.fecha_documento 	[idw_master.GetRow()])
ldc_tasa_cambio 		= Dec(idw_master.object.tasa_cambio	 		[idw_master.GetRow()])
ls_descripcion	 		= idw_master.object.observacion				[idw_master.GetRow()]
ldc_imp_detraccion 	= Dec(idw_master.object.imp_detraccion		[idw_master.GetRow()])

if IsNull(ldc_imp_detraccion) then ldc_imp_detraccion = 0 

if ldc_imp_detraccion = 0 then
	Rollback ;
	MessageBox('Error', 'El importe de la detraccion no puede ser cero, por favor verifique!', StopSign!)
	return false
end if

//Datos para la provisión de la detraccion
SetNull(li_year)
SetNull(li_mes)
SetNull(li_nro_libro)
SetNull(li_nro_asiento)
ls_flag_provisionado = 'D'
ls_flag_control_reg = '1'

//*Buscar documento detraccion*//
select flag_caja_bancos
  into :ls_flag_cbancos
  from cntas_cobrar		
 where tipo_doc		= :is_doc_dtrc
	and nro_doc			= :as_nro_detraccion ;
	

//Sino existe entonces creo el documento		
if SQLCA.SQLCode = 100 then

	//Inserto el documento
	select cen_bef_gen_oc 
	  into :ls_centro_benef
	  from origen 
	 where cod_origen = :ls_origen ;
	  
	ldc_saldo_sol = round(adc_imp_detraccion, this.of_nro_decimales())
	ldc_saldo_dol = Round(ldc_saldo_sol / ldc_tasa_cambio,2)
	
	Insert Into cntas_cobrar	(
		cod_relacion     	,tipo_doc 		    ,nro_doc     		 	,flag_estado , 
	 	fecha_registro   	,fecha_documento   ,fecha_vencimiento	,forma_pago  ,	
	 	cod_moneda		   ,tasa_cambio	    ,cod_usr	  		 	,origen		  ,
	 	observacion	   	,flag_provisionado ,importe_doc	    	,saldo_sol	  ,
	 	saldo_dol		   ,flag_control_reg  ,flag_replicacion 	,
		ano					,mes					 ,nro_libro			 	,nro_asiento)  
	Values(
		:ls_cliente				,:is_doc_dtrc	    		,:as_nro_detraccion	,'1'				 ,
	 	sysdate 					,:ld_emision   		 	,:ld_emision  			,:gnvo_app.finparam.is_pcon ,
	 	:gnvo_app.is_soles	,:ldc_tasa_cambio			,:gs_user	   		,:ls_origen	    ,
	 	:ls_descripcion		,:ls_flag_provisionado	,:ldc_saldo_sol 		,:ldc_saldo_sol ,
	 	:ldc_saldo_dol 		,:ls_flag_control_reg	,'1'						,
		:li_year					,:li_mes						,:li_nro_libro			,:li_nro_asiento)  ;
	 
	 
	IF gnvo_app.of_existsError(SQLCA, "Al grabar la cabecera de la Detraccion por cobrar en tabla cntas_cobrar") THEN 
		Rollback ;
		return false
	END IF 
	 
	 
	Insert Into cntas_cobrar_det(
		tipo_doc 							,nro_doc 				,item 					,
	 	descripcion  						,cantidad				,precio_unitario		,cencos	,
	 	flag_replicacion					,centro_benef			,flag_estado	)
	Values(
		:is_doc_dtrc	 					,:as_nro_detraccion 	 ,'1' 		 ,
	 	substr(:ls_descripcion,1,800)	,1							,:ldc_saldo_sol 		 ,:gnvo_app.finparam.is_cencos_dtrp,
	 	'1'									,:ls_centro_benef		,'1') ;
	
	IF gnvo_app.of_existsError(SQLCA, "Al Insertar el detalle del Documento de Detraccion " + is_doc_dtrc + "-" + as_nro_detraccion + " en la tabla cntas_cobrar_det") THEN 
		Rollback ;
		return false
	END IF 

	
else
	
	//Verifico si ya ha sido pagado y en caso de que este pagado validar
	select count(*)
		into :ll_count
	  	from caja_bancos_det cbd
	  where cbd.cod_relacion = :ls_cliente
	    and cbd.tipo_doc		 = :is_doc_dtrc
		 and cbd.nro_doc		 = :as_nro_detraccion;
	
	if ll_count > 0 then
		//Obtengo el numero de voucher y la fecha de pago
		select cb.origen, cb.nro_registro, cb.fecha_emision
			into :ls_org_cb, :ll_reg_cb, :ld_fec_pago
			from caja_bancos		cb,
				  caja_bancos_det cbd
		  where cb.origen			 = cbd.origen
			 and cb.nro_Registro	 = cbd.nro_registro
			 and cbd.cod_relacion = :ls_cliente
			 and cbd.tipo_doc		 = :is_doc_dtrc
			 and cbd.nro_doc		 = :as_nro_detraccion;
		
		gnvo_app.of_message_error('No Puede Modificar la Detraccion ' + as_nro_detraccion + ' ya ha sido pagado, por favor verifique' &
							+ '~r~nFecha Pago: ' + string(ld_fec_pago, 'dd/mm/yyyy') &
							+ '~r~nNro. registro: ' + ls_org_cb + trim(string(ll_reg_cb)))
		return false
		 
	end if
		 
	ldc_saldo_sol = round(ldc_imp_detraccion, this.of_nro_decimales())
	ldc_saldo_dol = Round(ldc_saldo_sol / ldc_tasa_cambio,2)
			
		
	update cntas_cobrar
		set 	saldo_sol     		= :ldc_saldo_sol	,
				saldo_dol   		= :ldc_saldo_dol  ,
				fecha_documento	= :ld_emision ,
				cod_moneda  		= :gnvo_app.is_soles   		,
				importe_doc			= :ldc_saldo_sol	,
				tasa_cambio 		= :ldc_tasa_cambio,
				flag_estado			= '1',
				flag_control_reg = :ls_flag_control_reg,
				flag_provisionado = :ls_flag_provisionado
				
	 where tipo_doc		= :is_doc_dtrc  
		and nro_doc			= :as_nro_detraccion ;

				 
	IF gnvo_app.of_ExistsError(SQLCA, "Error al actualizar la cabecera de la detraccion, tabla cntas_cobrar") THEN 
		Rollback ;
		return false
	END IF				 
			 
	//error		 
	//actualiza detalle
	update cntas_cobrar_det
		set precio_unitario     = :ldc_saldo_sol,
			 cantidad				= 1
	 where tipo_doc		= :is_doc_dtrc
		and nro_doc			= :as_nro_detraccion
		and item				= 1;
	
	IF gnvo_app.of_ExistsError(SQLCA, "Error al actualizar el detalle de la detraccion, tabla cntas_cobrar_det") THEN 
		Rollback ;
		return false
	END IF
		
end if	
	
Return true		
end function

public function boolean of_update_dtrc (string as_nro_detrac, date adt_fecha_doc, decimal adc_monto_detrac, string as_const_deposito, date ad_fec_deposito);String 	ls_msj_err

update detraccion
	set 	fecha_registro 	= :adt_fecha_doc,
			importe 				= :adc_monto_detrac,
			nro_deposito		= :as_const_deposito,
			fecha_deposito		= :ad_fec_deposito,
			flag_replicacion 	= '1'
 where nro_detraccion = :as_nro_detrac ;
 
if SQLCA.SQLCode = -1 then
	ls_msj_err = SQLCA.SQLErrText
	rollback ;
	gnvo_app.of_message_error("Error en actualizar detraccion por cobrar: " + ls_msj_err)
	return false
end if


Return true 
end function

public function boolean of_anular (string as_nro_detraccion);int 		li_count
Date		ld_fec_pago
String	ls_nro_registro

select count(*)
	into :li_count
from caja_bancos cb,  
     caja_bancos_det cbd
where cb.origen = cbd.origen
  and cb.nro_registro = cbd.nro_registro
  and cbd.tipo_doc    = :is_doc_dtrc
  and cbd.nro_doc		 = :as_nro_detraccion;


if li_count > 0 then
	//Obtengo el nro de registro y la fecha de cobro
	select trim(cb.origen) || trim(to_char(cb.nro_registro, '000000')), cb.fecha_emision
		into :ls_nro_registro, :ld_fec_pago
	from caja_bancos cb,  
		  caja_bancos_det cbd
	where cb.origen = cbd.origen
	  and cb.nro_registro = cbd.nro_registro
	  and cbd.tipo_doc    = :is_doc_dtrc
	  and cbd.nro_doc		 = :as_nro_detraccion;
  
	gnvo_app.of_message_error("No se puede anular el comprobante de detraccion x Cobrar " &
									+ as_nro_detraccion + ", ya que se encuentra cobrado. " &
									+ "~r~nNroRegistro: " + ls_nro_registro &
									+ "~r~nFecha Cobro: " + string(ld_fec_pago, 'dd/mm/yyyy') &
									+ "~r~nPor favor verifique!")
	return false
end if

//Anular la detraccion
update detraccion 
	set 	flag_estado = '0',
			importe		= 0.00
where nro_detraccion = :as_nro_detraccion ;
				
if gnvo_app.of_ExistsError(SQLCA, "Anulación de Detraccion " + as_nro_detraccion + ", Tabla Detraccion") then
	rollback;
	return false
end if
				
update cntas_cobrar 
	set 	flag_estado = '0',
			importe_doc		= 0.00,
			saldo_sol		= 0.00,
			saldo_dol		= 0.00
where tipo_doc	= :is_doc_dtrc
  and nro_doc  = :as_nro_detraccion;
				
if gnvo_app.of_ExistsError(SQLCA, "Anulación de Detraccion " + as_nro_detraccion + ", Tabla cntas_cobrar") then
	rollback;
	return false
end if

update cntas_cobrar_det 
	set 	precio_unitario = 0.00
where tipo_doc	= :is_doc_dtrc
  and nro_doc  = :as_nro_detraccion;
				
if gnvo_app.of_ExistsError(SQLCA, "Anulación de Detraccion " + as_nro_detraccion + ", Tabla cntas_cobrar_det") then
	rollback;
	return false
end if


return true				
end function

public function boolean of_update (string as_nro_detraccion, string as_nro_deposito, date ad_fecha_deposito, decimal adc_importe, string as_flag_tabla);Boolean 	lb_ret = TRUE
String  	ls_msj_err, ls_moneda
decimal	ldc_imp_soles, ldc_tasa_cambio
Long		ll_count


//detracion
/*********************************************************************
  VALIDACION PARA VER SI LE HAN ASIGNADO O NO EL DW_MASTER
**********************************************************************/
if IsNull(this.idw_master) or not Isvalid(this.idw_master) then
	Rollback ;
	MessageBox('Error', 'No ha especificado el datawindows Master en el objecto ' + this.ClassName() + ', por favor verifique!', StopSign!)
	return false
end if

//Obtengo los datos del voucher original de la detraccion
if this.idw_master.RowCount() = 0 then
	Rollback ;
	MessageBox('Error', 'No existen registros en el datawindows MASTER especificado en el objecto ' + this.ClassName() + ', por favor verifique!', StopSign!)
	return false
end if

//calculo el importe en soles, indicando si tiene o no redondeo
ldc_tasa_cambio 	= Dec(idw_master.object.tasa_cambio	[idw_master.getRow()])
ls_moneda			= idw_master.object.cod_moneda [idw_master.getRow()]

if ls_moneda = gnvo_app.is_soles then
	ldc_imp_soles = Round(adc_importe, this.of_nro_decimales())
else
	ldc_imp_soles = Round(adc_importe * ldc_tasa_cambio, this.of_nro_decimales())
end if

select count(*)
	into :ll_count
from detraccion
where nro_detraccion 	= :as_nro_detraccion;

if ll_count > 0 then

	update detraccion
		set 	importe 			= :ldc_imp_soles,
				nro_Deposito	= :as_nro_deposito,
				fecha_deposito	= :ad_fecha_deposito
	where nro_detraccion 	= :as_nro_detraccion;
	
	if gnvo_app.of_existsError(SQLCA, "Update Tabla Detraccion") then
		rollback;
		return false
	end if


else
	Insert Into detraccion (
		nro_detraccion 		,flag_estado	,fecha_registro	,nro_deposito,
		fecha_deposito 		,cod_usr    	,importe       	,flag_tabla  ,
		flag_replicacion
	)
	Values(
		:as_nro_detraccion	, '1'				, sysdate			, :as_nro_deposito,
		:ad_fecha_deposito	,:gs_user    	,:ldc_imp_soles	,:as_flag_tabla  ,
	 	'1');
	
	if gnvo_app.of_existsError(SQLCA, "Insert Tabla Detraccion") then
		rollback;
		return false
	end if


end if
 


//Actualizo tambien la cuenta corriente
lb_ret = this.of_udpate_cta_cte_dtrc(	as_nro_detraccion, adc_importe )



Return lb_ret
end function

on n_cst_detraccion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_detraccion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;string ls_mensaje

//Busco el documento para la detraccion por cobrar
try 
	
	//Detraccion por cobrar
	is_doc_dtrc = gnvo_app.of_get_parametro( 'DOC_DTRC', 'DTRC')
	ii_nro_decimales = gnvo_app.of_get_parametro( "NRO_DECIMALES_DETRACCION", 0)
	
catch ( Exception ex )
	MessageBox('Exception', ex.getMessage())
	return -1

end try


end event

