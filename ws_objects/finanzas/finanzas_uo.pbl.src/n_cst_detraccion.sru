$PBExportHeader$n_cst_detraccion.sru
forward
global type n_cst_detraccion from nonvisualobject
end type
end forward

global type n_cst_detraccion from nonvisualobject
end type
global n_cst_detraccion n_cst_detraccion

type variables
integer 	ii_nro_decimales
u_dw_abc	idw_master
end variables

forward prototypes
public function integer of_nro_decimales ()
public function boolean of_update_cta_cte (string as_nro_detraccion, string as_cod_relacion, string as_descripcion, date ad_fec_emision, string as_moneda, decimal adc_tasa_cambio, decimal adc_importe, string as_origen, string as_cod_usr)
public function boolean of_update (string as_origen, string as_nro_detraccion, string as_cod_relacion, string as_descripcion, date ad_fec_emision, string as_nro_deposito, date ad_fecha_deposito, string as_moneda, decimal adc_tasa_cambio, decimal adc_importe, string as_flag_tabla)
public function boolean of_anular (string as_nro_detraccion)
public function string of_next_nro (string as_origen)
public function string of_voucher_pago (string as_nro_detraccion)
public function boolean of_pagado (string as_nro_detraccion)
public function boolean of_change_estado (u_dw_abc adw_master, string as_action)
public function boolean of_duplicado (string as_nro_detraccion)
end prototypes

public function integer of_nro_decimales ();return ii_nro_decimales
end function

public function boolean of_update_cta_cte (string as_nro_detraccion, string as_cod_relacion, string as_descripcion, date ad_fec_emision, string as_moneda, decimal adc_tasa_cambio, decimal adc_importe, string as_origen, string as_cod_usr);String 	ls_cod_moneda,ls_flag_cbancos,ls_msj_err, ls_centro_benef, ls_flag_provisionado, &
			ls_flag_control_reg
Date	 	ld_fecha_em
Decimal 	ldc_importe,ldc_saldo_sol,ldc_saldo_dol, ldc_tasa_cambio

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

/*
if gnvo_app.finparam.is_dtrp_prov = '1'  then
	li_year 			= Int(idw_master.object.ano 			[idw_master.GetRow()])
	li_mes 			= Int(idw_master.object.mes 			[idw_master.GetRow()])
	li_nro_libro 	= Int(idw_master.object.nro_libro 	[idw_master.GetRow()])
	li_nro_asiento = Int(idw_master.object.nro_Asiento [idw_master.GetRow()])
	ls_flag_provisionado = 'R'
	ls_flag_control_reg = '0'
else
*/	
	SetNull(li_year)
	SetNull(li_mes)
	SetNull(li_nro_libro)
	SetNull(li_nro_asiento)
	ls_flag_provisionado = 'D'
	ls_flag_control_reg = '0'
//end if

//*Buscar documento detraccion*//
select flag_caja_bancos,fecha_emision,cod_moneda,importe_doc,tasa_cambio
  into :ls_flag_cbancos,:ld_fecha_em,:ls_cod_moneda,:ldc_importe,:ldc_tasa_cambio
  from cntas_pagar		
 where cod_relacion 	= :as_cod_relacion
   and tipo_doc		= :gnvo_app.finparam.is_doc_dtrp	
	and nro_doc			= :as_nro_detraccion ;
	
		
if SQLCA.SQLCode = 100 then

	//Inserto el documento
	select cen_bef_gen_oc 
	  into :ls_centro_benef
	  from origen 
	 where cod_origen = :as_origen ;
	  
	IF as_moneda = gnvo_app.is_soles THEN
		ldc_saldo_sol = round(adc_importe, this.of_nro_decimales())
		ldc_saldo_dol = Round(ldc_saldo_sol / adc_tasa_cambio,2)
	ELSE
		ldc_saldo_sol = Round(adc_importe * adc_tasa_cambio,this.of_nro_decimales())
		ldc_saldo_dol = Round(ldc_saldo_sol / adc_tasa_cambio,2)
	END IF
	
	Insert Into cntas_pagar	(
		cod_relacion     	,tipo_doc 		    ,nro_doc     		 ,flag_estado , 
	 	fecha_registro   	,fecha_emision     ,vencimiento 		 ,forma_pago  ,	
	 	cod_moneda		   ,tasa_cambio	    ,cod_usr	  		 ,origen		  ,
	 	descripcion	   	,flag_provisionado ,importe_doc	    ,saldo_sol	  ,
	 	saldo_dol		   ,flag_control_reg  ,flag_replicacion ,
		ano					,mes					 ,nro_libro			 ,nro_asiento)  
	Values(
		:as_cod_relacion	,:gnvo_app.finparam.is_doc_dtrp	      ,:as_nro_detraccion	,'1'				 ,
	 	sysdate 				,:ad_fec_emision   		,:ad_fec_emision  	,:gnvo_app.finparam.is_pcon ,
	 	:gnvo_app.is_soles,:adc_tasa_cambio  		,:as_cod_usr	   	,:as_origen	    ,
	 	:as_descripcion	,:ls_flag_provisionado	,:ldc_saldo_sol 		,:ldc_saldo_sol ,
	 	:ldc_saldo_dol 	,:ls_flag_control_reg	,'1'						,
		:li_year				,:li_mes						,:li_nro_libro			,:li_nro_asiento)  ;
	 
	 
	IF gnvo_app.of_existsError(SQLCA) THEN 
		Rollback ;
		return false
	END IF 
	 
	 
	Insert Into cntas_pagar_det(
		cod_relacion 		,tipo_doc 				,nro_doc 				,item 	,
	 	descripcion  		,cantidad				,importe 				,cencos	,
	 	cnta_prsp    		,flag_replicacion		,centro_benef)
	Values(
		:as_cod_relacion				 ,:gnvo_app.finparam.is_doc_dtrp	 	,:as_nro_detraccion 	 ,'1' 		 ,
	 	substr(:as_descripcion,1,60),'1'			,:ldc_saldo_sol 		 ,:gnvo_app.finparam.is_cencos_dtrp	 ,
	 	:gnvo_app.finparam.is_cnta_prsp_dtrp	 ,'1'			,:ls_centro_benef) ;
	
	IF gnvo_app.of_existsError(SQLCA) THEN 
		Rollback ;
		return false
	END IF 

	
else
	IF ls_flag_cbancos = '1' THEN
		Rollback ;
		f_mensaje('No Puede Modificar Documento Detraccion ' + as_nro_detraccion + ' ya ha sido pagado, por favor verifique', '')
		return false
	END IF	
	
	
	if ld_fecha_em <> ad_fec_emision OR ls_cod_moneda <> as_moneda OR adc_importe <> ldc_importe OR &
		ldc_tasa_cambio <> adc_tasa_cambio then //si existe modificaciones actualiza detraccion
		
		IF ls_cod_moneda = gnvo_app.is_soles THEN
			ldc_saldo_sol = round(adc_importe, this.of_nro_decimales())
			ldc_saldo_dol = Round(ldc_saldo_sol / adc_tasa_cambio,2)
		ELSE
			ldc_saldo_sol = Round(adc_importe * adc_tasa_cambio,this.of_nro_decimales())
			ldc_saldo_dol = Round(ldc_saldo_sol / adc_tasa_cambio,2)
		END IF
			
		
		update cntas_pagar
		   set 	saldo_sol     	= :ldc_saldo_sol	,
					saldo_dol   	= :ldc_saldo_dol  ,
				 	fecha_emision 	= :ad_fec_emision ,
					cod_moneda  	= :gnvo_app.is_soles ,
				 	importe_doc		= :ldc_saldo_sol	,
					tasa_cambio 	= :adc_tasa_cambio,
					flag_estado		= '1',
					flag_control_reg = :ls_flag_control_reg,
					flag_provisionado = :ls_flag_provisionado
		 where cod_relacion 	= :as_cod_relacion
		   and tipo_doc		= :gnvo_app.finparam.is_doc_dtrp  
			and nro_doc			= :as_nro_detraccion ;

				 
		IF gnvo_app.of_ExistsError(SQLCA) THEN 
			Rollback ;
			return false
		END IF				 
				 
		//error		 
		//actualiza detalle
		update cntas_pagar_det
		   set importe     	= :ldc_saldo_sol
		 where cod_relacion 	= :as_cod_relacion
		   and tipo_doc		= :gnvo_app.finparam.is_doc_dtrp     
			and nro_doc			= :as_nro_detraccion
			and item				= 1;
		
		IF gnvo_app.of_ExistsError(SQLCA) THEN 
			Rollback ;
			return false
		END IF
		
		
		// Actualizo el código de moneda de doc_pendientes_cta_cte
		update doc_pendientes_cta_cte
		   set cod_moneda = :gnvo_app.is_soles
		 where cod_relacion 	= :as_cod_relacion
		   and tipo_doc		= :gnvo_app.finparam.is_doc_dtrp  
			and nro_doc			= :as_nro_detraccion ;

		IF gnvo_app.of_ExistsError(SQLCA) THEN 
			Rollback ;
			return false
		END IF
			
	end if		
end if	
	
Return true		
end function

public function boolean of_update (string as_origen, string as_nro_detraccion, string as_cod_relacion, string as_descripcion, date ad_fec_emision, string as_nro_deposito, date ad_fecha_deposito, string as_moneda, decimal adc_tasa_cambio, decimal adc_importe, string as_flag_tabla);Boolean 	lb_ret = TRUE
String  	ls_msj_err
decimal	ldc_imp_soles
Long		ll_count


//detracion
/*********************************************************************
  REPLICACION
**********************************************************************/

//calculo el importe en soles, indicando si tiene o no redondeo

if as_moneda = gnvo_app.is_soles then
	ldc_imp_soles = Round(adc_importe, this.of_nro_decimales())
else
	ldc_imp_soles = Round(adc_importe * adc_tasa_cambio, this.of_nro_decimales())
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
		nro_detraccion ,flag_estado,fecha_registro,nro_deposito,
		fecha_deposito ,cod_usr    ,importe       ,flag_tabla  ,
		flag_replicacion
	)
	Values(
		:as_nro_detraccion, '1', sysdate, :as_nro_deposito,
		:ad_fecha_deposito,:gs_user    ,:ldc_imp_soles	     ,:as_flag_tabla  ,
	 '1');
	
	if gnvo_app.of_existsError(SQLCA, "Insert Tabla Detraccion") then
		rollback;
		return false
	end if


end if
 


//Actualizo tambien la cuenta corriente
lb_ret = this.of_update_cta_cte(	as_nro_detraccion, &
											as_cod_relacion, &
											as_descripcion, &
											ad_fec_emision, &
											as_moneda, &
											adc_tasa_cambio, &
											adc_importe, &
											as_origen, &
											gs_user)



Return lb_ret
end function

public function boolean of_anular (string as_nro_detraccion);String ls_flag_cbancos


select flag_caja_bancos
  into :ls_flag_cbancos
  from cntas_pagar		
 where tipo_doc		= :gnvo_app.finparam.is_doc_dtrp  	
	and nro_doc			= :as_nro_detraccion ;

if ls_flag_cbancos = '1' then
	f_mensaje("No se puede anular el comprobante de detraccion " + as_nro_detraccion + ", ya que se encuentra pagado, por favor verifique!", "")
	return false
end if

//Anular la detraccion
update detraccion 
	set 	flag_estado = '0',
			importe		= 0.00
where nro_detraccion = :as_nro_detraccion ;
				
if gnvo_app.of_ExistsError(SQLCA, "Anulación de Detraccion, Tabla Detraccion") then
	rollback;
	return false
end if
				
update cntas_pagar 
	set 	flag_estado = '0',
			importe_doc		= 0.00,
			saldo_sol		= 0.00,
			saldo_dol		= 0.00
where tipo_doc	= :gnvo_app.finparam.is_doc_dtrp  
  and nro_doc = :as_nro_detraccion;
				
if gnvo_app.of_ExistsError(SQLCA, "Anulación de Detraccion, Tabla cntas_pagar") then
	rollback;
	return false
end if

update cntas_pagar_det 
	set 	importe = 0.00
where tipo_doc	= :gnvo_app.finparam.is_doc_dtrp  
  and nro_doc  = :as_nro_detraccion;
				
if gnvo_app.of_ExistsError(SQLCA, "Anulación de Detraccion, Tabla cntas_pagar_det") then
	rollback;
	return false
end if


return true				
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

//se concatena con origen
ls_nro_detraccion = trim(as_origen) + trim(string(ll_ult_nro, '00000000'))

select count(*)
  into :ll_count
from cntas_pagar cp
where cp.nro_detraccion = :ls_nro_detraccion;

//Valido que el numero no se repita, en caso contrario incremento el numerador
do while ll_count > 0 
	ll_ult_nro ++
	
	ls_nro_detraccion = trim(as_origen) + trim(string(ll_ult_nro, '00000000'))
	
	select count(*)
	  into :ll_count
	from cntas_pagar cp
	where cp.nro_detraccion = :ls_nro_detraccion;
	
loop

//actualiza información e numeradores
update num_detraccion no
   set no.ult_nro = :ll_ult_nro + 1
 where no.origen = :as_origen;

return ls_nro_detraccion
end function

public function string of_voucher_pago (string as_nro_detraccion);String ls_voucher_pago


select cb.origen || '-' || trim(to_char(cb.ano, '00000')) || '-' || trim(to_char(cb.mes, '00')) || '-' ||
		 trim(to_char(cb.nro_libro, '00')) || '-' || trim(to_char(cb.nro_asiento, '000000'))
  into :ls_voucher_pago
  from caja_bancos_det 	cbd,
  		 caja_bancos		cb
 where cb.origen			= cbd.origen
   and cb.nro_registro	= cbd.nro_registro
   and cbd.tipo_doc		= :gnvo_app.finparam.is_doc_dtrp  	
	and cbd.nro_doc		= :as_nro_detraccion 
	and cbd.factor			= '1'
	and cb.flag_estado <> '0';

return ls_voucher_pago
end function

public function boolean of_pagado (string as_nro_detraccion);Integer	li_count


select count(*)
  into :li_count
  from caja_bancos 		cb,
  		 caja_bancos_det 	cbd
 where cb.origen	   	= cbd.origen
   and cb.nro_registro	= cbd.nro_registro
   and cbd.TIPO_DOC		= :gnvo_app.finparam.is_doc_dtrp  	
	and cbd.nro_doc		= :as_nro_detraccion 
	and cbd.factor			= '1'
	and cb.flag_estado	<> '0';

if li_count > 0 then
	return true
end if

return false		
end function

public function boolean of_change_estado (u_dw_abc adw_master, string as_action);String 	ls_flag_detraccion, ls_nro_detraccion
Long		ll_row

if adw_master.GetRow() = 0 then return false

ll_row = adw_master.getRow()
ls_flag_detraccion = adw_master.object.flag_detraccion [ll_row]

if ls_flag_detraccion = '0' then

	IF as_action = 'fileopen' THEN //modificacion
		ls_nro_detraccion = adw_master.object.nro_detraccion [ll_row]
	  
		/*Buscar Documento tipo Cta Cte*/	 
		if this.of_pagado(ls_nro_detraccion) then
			Messagebox('Aviso','No Puede Revertir Detraccion por que '  + Char(13) & 
								  +'se ha generado Documento tipo Cuenta Corriente , Verifique!')
			adw_master.object.flag_detraccion [ll_row] = '1'
			Return false						 
		end if
	  
	END IF
	
	adw_master.object.porc_detraccion 	[ll_row] = 0.00
	adw_master.object.imp_detraccion 	[ll_row] = 0.00
	adw_master.object.nro_detraccion  	[ll_row] = gnvo_app.is_null
	adw_master.object.bien_serv  			[ll_row] = gnvo_app.is_null
	adw_master.object.oper_detr  			[ll_row] = gnvo_app.is_null
  
	adw_master.object.bien_serv.protect = '1'
	adw_master.object.bien_serv.Background.Color = RGB(240,240,240)
	
	adw_master.object.oper_detr.protect = '1'
	adw_master.object.oper_detr.Background.Color = RGB(240,240,240)
	
	adw_master.object.porc_detraccion.protect = '1'
	adw_master.object.porc_detraccion.Background.Color = RGB(240,240,240)
	
	adw_master.object.imp_detraccion.protect = '1'


else
	adw_master.object.bien_serv.protect = '0'
	adw_master.object.bien_serv.Background.Color = RGB(255,255,255)
	adw_master.SetColumn('bien_serv')
	
	adw_master.object.oper_detr.protect = '0'
	adw_master.object.oper_detr.Background.Color = RGB(255,255,255)
	
	adw_master.object.porc_detraccion.protect = '0'
	adw_master.object.porc_detraccion.Background.Color = RGB(255,255,255)
	
	adw_master.object.imp_detraccion.protect = '0'
end if
end function

public function boolean of_duplicado (string as_nro_detraccion);Long ll_count

//*Buscar documento detraccion*//
select count(*)
  into :ll_count
  from cntas_pagar		
 where tipo_doc		= :gnvo_app.finparam.is_doc_dtrp	
	and nro_doc			= :as_nro_detraccion ;

if ll_count	> 0 then
	return true
end if

return false
end function

on n_cst_detraccion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_detraccion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;try 
	ii_nro_decimales = gnvo_app.of_get_parametro( "NRO_DECIMALES_DETRACCION", 0)
catch ( Exception ex )
	MessageBox('Excepción', 'Ha ocurrido una excepción, mensaje de error: ' + ex.getMessage(), StopSign!)
finally
	/*statementBlock*/
end try
end event

