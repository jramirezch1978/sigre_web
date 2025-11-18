$PBExportHeader$n_cst_compras.sru
forward
global type n_cst_compras from nonvisualobject
end type
end forward

global type n_cst_compras from nonvisualobject
end type
global n_cst_compras n_cst_compras

type variables
Integer			il_tam_max_cod_Art
String			is_flag_matriz_contab, is_doc_otr, is_flag_valida_cbe, is_oper_ing_prod, &
					is_oper_ing_oc, is_cod_igv
Decimal			idc_porc_igv
					
//Unidades de peso	
String			is_und_kgr, is_und_ton

n_smtp				invo_smtp
n_cst_wait			invo_wait
n_cst_serversmtp	invo_email
n_cst_inifile		invo_inifile
n_cst_utilitario	invo_util
end variables

forward prototypes
public function string of_get_firma (string as_ini_file, string as_usuario)
public function string of_telefono (string as_proveedor, string as_tipo)
public function string of_direccion_proveedor (string as_proveedor, integer ai_item)
public function boolean of_retencion_igv (string as_proveedor)
public function string of_get_firma (string as_usuario)
public function str_direccion of_get_direccion (string as_cod_relacion)
public function string of_get_firma_autorizado (string as_ini_file)
public function boolean of_save_blob (string as_cod_art, blob ablb_imagen)
public function boolean of_show_imagen (blob ablb_imagen)
public function string of_next_cod_art (string as_sub_categ)
public function boolean of_load ()
public function boolean of_act_cant_procesada ()
public function boolean of_act_monto_facturado ()
public function String of_get_email (string as_cod_relacion)
public function boolean of_show_imagen (string path_imagen)
public function boolean of_send_email_cambio_estado (u_dw_abc adw_master)
public function beanpadronruc of_leer_ruc_externo (string as_ruc)
public function string of_get_firma_autorizado (string as_ini_file, string as_user)
public function string of_get_firma_usuario (string as_ini_file, string as_user)
public function boolean of_send_email_activa_prov (u_dw_abc adw_master)
public function boolean of_send_email_aprob_oc (string as_nro_oc, string as_aprobador)
public function boolean of_send_email_desaprob_oc (string as_nro_oc, string as_aprobador)
public function boolean of_send_email_rechazo_os (string as_nro_os, string as_aprobador, string as_mensaje)
public function boolean of_send_email_aprob_os (string as_nro_os, string as_aprobador)
public function boolean of_send_email_desaprob_os (string as_nro_os, string as_aprobador)
public function boolean of_act_cant_procesada (string as_nro_oc)
public function boolean of_act_monto_facturado (string as_nro_oc)
end prototypes

public function string of_get_firma (string as_ini_file, string as_usuario);String ls_firma_jpg, ls_path

ls_path		 = ProfileString (as_ini_file, "FIRMA_" + gs_empresa, "Path", "i:\sigre_exe\firmas")
ls_firma_jpg = ProfileString (as_ini_file, "FIRMA_" + gs_empresa, trim(as_usuario), "")

return ls_path + "\" + ls_firma_jpg
end function

public function string of_telefono (string as_proveedor, string as_tipo);/*
  Funcion que retorna el numero de telefono o fax
  Param.  't' = Telefono
  			 'f' = fax
*/

String ls_nro, ls_pais, ls_ciu

if as_tipo = 't' then
	Select telef_pais, telef_ciudad, telefono 
	  into :ls_pais, :ls_ciu, :ls_nro 
	  from telefonos 
  	 where codigo = :as_proveedor;
else
	Select telef_pais, telef_ciudad, telefono 
	  into :ls_pais, :ls_ciu, :ls_nro 
	  from telefonos 
    where codigo = :as_proveedor 
		and flag_fax = '1';
end if

if ISNULL( ls_pais ) then ls_pais = ''
if ISNULL( ls_ciu ) then ls_ciu = ''
if ISNULL( ls_nro ) then ls_nro = ''

Return trim(ls_pais + ' ' + ls_ciu + ' ' + ls_nro)
end function

public function string of_direccion_proveedor (string as_proveedor, integer ai_item);// funcion que devuelve la direccion del codigo relacion
String ls_direccion,ls_tipo

//function of_get_direccion(
//    as_proveedor proveedor.proveedor%TYPE,
//    an_item     direcciones.item%TYPE
//  ) return varchar2 is
 
DECLARE of_get_direccion PROCEDURE  FOR pkg_logistica.of_get_direccion(:as_proveedor, :ai_item);

execute of_get_direccion;

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox( "Error", sqlca.sqlerrtext)
	return gnvo_app.is_null
end if

fetch of_get_direccion into :ls_direccion;

Close of_get_direccion;
//end if


Return ls_direccion

end function

public function boolean of_retencion_igv (string as_proveedor);boolean 	lb_ret_igv
string 	ls_flag_buen_contrib, ls_flag_ret_igv

select nvl(p.flag_buen_contrib, '0'), nvl(p.flag_ret_igv, '0')
	into :ls_flag_buen_contrib, :ls_flag_ret_igv
from proveedor p
where p.proveedor = :as_proveedor;

if SQLCA.SQLCode = 100 then
	return false
end if

if ls_flag_buen_contrib = '1' then return false

if ls_flag_buen_contrib = '0' and ls_flag_ret_igv = '0' then return false

return true
end function

public function string of_get_firma (string as_usuario);String ls_firma

select firma
	into :ls_firma
from usuario
where cod_usr = :as_usuario;

return ls_firma
end function

public function str_direccion of_get_direccion (string as_cod_relacion);Long				ll_count
Integer			li_item
String			ls_direccion, ls_mensaje
str_direccion 	lstr_direccion

select item, PKG_LOGISTICA.of_get_direccion(:as_cod_relacion, item)
	into :li_item, :ls_direccion
from direcciones
where codigo = :as_cod_relacion
  and flag_uso in ('1', '3');

if SQLCA.SQLCOde = 100 then
	
	lstr_direccion.b_Return = false

else
	
	lstr_direccion.b_Return 		= true
	lstr_direccion.item_direccion	= li_item
	lstr_direccion.direccion		= ls_direccion
	
end if

return lstr_direccion
end function

public function string of_get_firma_autorizado (string as_ini_file);String ls_file
try 
	invo_inifile.of_set_inifile(as_ini_file)

	ls_file		 = invo_inifile.of_get_Parametro ( "Firma_digital", gs_empresa, "I:\sigre_exe\FirmaDigital\FirmaAutorizadoOC.png ")


	return ls_file
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')
	return gnvo_app.is_null
	
end try

end function

public function boolean of_save_blob (string as_cod_art, blob ablb_imagen);Integer 	li_result
blob  	lbl_Emp_foto
string 	ls_mensaje

try
	// Actualizo el archivo blob
	UPDATEBLOB articulo 
			 SET imagen = :ablb_imagen
	WHERE cod_art = :as_cod_art;
	
	if SQLCA.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al subir la foto en la tabla ARTICULO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	COMMIT;
	
	return true
	
catch (Exception ex)
	
	gnvo_app.of_catch_exception(ex, 'Error al momento subir la imagen a la tabla ARTICULO')
end try


end function

public function boolean of_show_imagen (blob ablb_imagen);w_imagen 		lw_imagen
str_parametros	lstr_param


try
	
	lstr_param.blb_datos = ablb_imagen
	
	OpenWithParm(lw_imagen, lstr_param)
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return false
	
	lstr_param = Message.PowerObjectParm
	
	return lstr_param.b_Return
	
catch (Exception ex)
	
	gnvo_app.of_catch_exception(ex, 'Error al momento subir la imagen a la tabla ARTICULO')
end try


end function

public function string of_next_cod_art (string as_sub_categ);string 	ls_codigo, ls_sub_categ, ls_mensaje
Long		ll_next_nro, ll_long_cod_art, ll_long, ll_find, ll_count

ls_sub_categ = trim(as_sub_categ) + '.%'
ll_long	= Len(trim(as_sub_categ)) + 1

// Extraigo el ultimo codigo de articulo de la tabla articulo
select max(
        case
          when instr(a.cod_art, '.') > 0 then
            substr(a.cod_art, instr(a.cod_Art, '.') + 1)
          else
            '0'
        end
        )
	into :ls_codigo
from articulo a
where a.cod_art like : ls_sub_categ;


if SQLCA.SQlcode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'HA ocurrido un error al consultar la tabla ARTICULO. Mensaje: ' + ls_mensaje, StopSign!)
	SetNull(ls_codigo)
	return ls_codigo
end if

if SQLCA.SQlcode = 100 then
	ll_next_nro = 0
else
	ls_codigo = trim(ls_codigo)
	ll_find = Pos(ls_codigo, '.')
	if ll_find > 0 then
		ll_next_nro = Long( mid(ls_codigo, ll_find + 1) )
	else
		ll_next_nro = Long( ls_codigo )
	end if
end if

If IsNull(ll_next_nro) or ll_next_nro = 0 then
	ll_next_nro = 1
else
	//Genero el código del artículo
	ll_next_nro ++
end if

if il_tam_max_cod_art > ll_long then
	ls_codigo = trim(as_sub_Categ) + '.' + string(ll_next_nro, Fill('0', il_tam_max_cod_art - ll_long ))
else
	//ls_codigo = trim(as_sub_Categ) + '.' + string(ll_next_nro, Fill('0', il_tam_max_cod_art))
	MessageBox('Error', 'La longitud del parametro es menor a la requerida.' &
							+ '~r~nLongitud del parametro: ' + string(il_tam_max_cod_art) &
							+ '~r~nLongitud minima requerida: ' + string(ll_long)  + '.' &
							+ '~r~nPor favor corrija inmediatamente.', StopSign!)
	return gnvo_app.is_null
end if

//Verifico si el codigo ya existe sino genero el siguiente
select count(*)
	into :ll_count
from articulo
where cod_art = :ls_codigo;

do while ll_count > 0 
	ll_next_nro ++
	
	if il_tam_max_cod_art > ll_long then
		ls_codigo = trim(as_sub_Categ) + '.' + string(ll_next_nro, Fill('0', il_tam_max_cod_art - ll_long ))
	else
		//ls_codigo = trim(as_sub_Categ) + '.' + string(ll_next_nro, Fill('0', il_tam_max_cod_art))
		MessageBox('Error', 'La longitud del parametro es menor a la requerida.' &
								+ '~r~nLongitud del parametro: ' + string(il_tam_max_cod_art) &
								+ '~r~nLongitud minima requerida: ' + string(ll_long)  + '.' &
								+ '~r~nPor favor corrija inmediatamente.', StopSign!)
		return gnvo_app.is_null
	end if
	
	select count(*)
		into :ll_count
	from articulo
	where cod_art = :ls_codigo;

loop

return ls_codigo
end function

public function boolean of_load ();// Evalua parametros
string 	ls_mensaje

try 
	

	// Obtengo los parametros que necesito
	Select 	NVL(flag_matriz_Contab,'P'), doc_otr, NVL(flag_centro_benef, '0'),
				oper_ing_prod, oper_ing_oc, cod_igv
		into 	:is_flag_matriz_contab, :is_doc_otr, :is_flag_valida_cbe,
				:is_oper_ing_prod, :is_oper_ing_oc, :is_cod_igv
	from logparam 
	where reckey = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No ha definido parametros en logistica', StopSign!)
		return false
	end if
	
	if trim(is_oper_ing_prod) = '' or IsNull(is_oper_ing_prod) then
		MessageBox('Aviso', 'No ha definido INGRESO POR PRODUCCION en LogParam', StopSign!)	
		return false
	end if
	
	if trim(is_oper_ing_oc) = '' or IsNull(is_oper_ing_oc) then
		MessageBox('Aviso', 'No ha definido INGRESO POR COMPRAS en LogParam', StopSign!)	
		return false
	end if

	if trim(is_doc_otr) = '' or IsNull(is_doc_otr) then
		MessageBox('Aviso', 'No ha definido DOCUMENTO ORDEN DE TRASLADO en LogParam', StopSign!)	
		return false
	end if
	
	if trim(is_cod_igv) = '' or IsNull(is_cod_igv) then
		MessageBox('Aviso', 'No ha definido EL IGV en LogParam', StopSign!)	
		return false
	end if

	il_tam_max_cod_art 	= gnvo_app.of_get_parametro('TAMAÑO_MAXIMO_COD_ART', 12)
	
	is_und_kgr = gnvo_app.of_get_parametro("UND_KGR", "KGR")
	is_und_ton = gnvo_app.of_get_parametro("UND_TON", "TON")
	
	//Obtengo el porcentaje del IGV
	select it.tasa_impuesto
		into :idc_porc_igv
	from impuestos_tipo it
	where it.tipo_impuesto = :is_cod_igv;
	
	if SQLCA.SQLCOde = 100 then
		MessageBox('Aviso', 'No existe el impuesto ' + is_cod_igv + " en la tabla IMPUESTOS_TIPO, por favor verifique!", StopSign!)	
		return false
	end if

	return true

catch ( Exception ex)
	
	ls_mensaje = ex.getMessage()
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido una excepcion. Mensaje: ' + ex.getMessage(), StopSign!)
	return false	
	
end try


end function

public function boolean of_act_cant_procesada ();String ls_mensaje

update articulo_mov_proy amp
   set amp.cant_procesada = ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                               from articulo_mov am,  
                                    vale_mov     vm,
                                    articulo_mov_tipo amt
                              where am.nro_Vale = vm.nro_vale
                                and vm.tipo_mov = amt.tipo_mov
                                and am.flag_estado <> '0'
                                and vm.flag_estado <> '0'
                                and am.origen_mov_proy = amp.cod_origen
                                and am.nro_mov_proy    = amp.nro_mov) +
                            (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                               from vale_mov_trans_det vtd,  
                                    vale_mov_trans     vt,
                                    articulo_mov_tipo  amt
                              where vtd.nro_vale  = vt.nro_vale
                                and vt.tipo_mov   = amt.tipo_mov
                                and vtd.flag_estado <> '0'
                                and vt.flag_estado  <> '0'
                                and vtd.org_amp_oc     = amp.cod_origen
                                and vtd.nro_amp_oc     = amp.nro_mov))
  where amp.cant_procesada <> ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                               from articulo_mov am,  
                                    vale_mov     vm,
                                    articulo_mov_tipo amt
                              where am.nro_Vale = vm.nro_vale
                                and vm.tipo_mov = amt.tipo_mov
                                and am.flag_estado <> '0'
                                and vm.flag_estado <> '0'
                                and am.origen_mov_proy = amp.cod_origen
                                and am.nro_mov_proy    = amp.nro_mov) +
                            (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                               from vale_mov_trans_det vtd,  
                                    vale_mov_trans     vt,
                                    articulo_mov_tipo  amt
                              where vtd.nro_vale  = vt.nro_vale
                                and vt.tipo_mov   = amt.tipo_mov
                                and vtd.flag_estado <> '0'
                                and vt.flag_estado  <> '0'
                                and vtd.org_amp_oc     = amp.cod_origen
                                and vtd.nro_amp_oc     = amp.nro_mov))
   and amp.tipo_doc = (select doc_oc from logparam where reckey = '1');
										  
if SQLCA.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se puede actualizar la cantidad procesada en la orden de compra. Mensaje: ' + ls_mensaje, StopSign!)
	return  false
end if


commit;

return true

end function

public function boolean of_act_monto_facturado ();String ls_mensaje

// Actualizo la cantidad Facturada
update orden_compra  oc
  set oc.monto_facturado = round((
										select nvl(sum(decode(dt.flag_signo, '+', 1, -1) * cpd.importe ),0) 
										  from cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp 
										 where cpd.tipo_doc    = dt.tipo_doc
											and cpd.org_amp_ref = amp.cod_origen 
											and cpd.nro_amp_ref = amp.nro_mov
											and amp.tipo_doc    = :gnvo_app.is_doc_oc
											and amp.nro_doc     = oc.nro_oc) + 
									  (select nvl(sum(cpi.importe * decode(it.signo, '+', 1, -1) * decode(dt.flag_signo, '+', 1, -1)),0) 
										  from cp_doc_det_imp  cpi,
												 cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp,
												 impuestos_tipo    it
										 where cpd.tipo_doc    = dt.tipo_doc
											and cpd.cod_relacion = cpi.cod_relacion
											and cpd.tipo_doc     = cpi.tipo_doc
											and cpd.nro_doc      = cpi.nro_doc
											and cpd.item         = cpi.item
											and cpi.tipo_impuesto = it.tipo_impuesto
											and cpd.org_amp_ref = amp.cod_origen 
											and cpd.nro_amp_ref = amp.nro_mov
											and amp.tipo_doc    = :gnvo_app.is_doc_oc
											and amp.nro_doc     = oc.nro_oc) 
											,2),
	  oc.flag_replicacion = '1'
where oc.monto_facturado <> round((select nvl(sum(decode(dt.flag_signo, '+', 1, -1) * cpd.importe ),0) 
										  from cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp 
										 where cpd.tipo_doc    = dt.tipo_doc
											and cpd.org_amp_ref = amp.cod_origen 
											and cpd.nro_amp_ref = amp.nro_mov
											and amp.tipo_doc    = :gnvo_app.is_doc_oc
											and amp.nro_doc     = oc.nro_oc) + 
									  (select nvl(sum(cpi.importe * decode(it.signo, '+', 1, -1) * decode(dt.flag_signo, '+', 1, -1)),0) 
										  from cp_doc_det_imp  cpi,
												 cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp,
												 impuestos_tipo    it
										 where cpd.tipo_doc      = dt.tipo_doc
											and cpd.cod_relacion  = cpi.cod_relacion
											and cpd.tipo_doc      = cpi.tipo_doc
											and cpd.nro_doc       = cpi.nro_doc
											and cpd.item          = cpi.item
											and cpi.tipo_impuesto = it.tipo_impuesto
											and cpd.org_amp_ref   = amp.cod_origen 
											and cpd.nro_amp_ref   = amp.nro_mov
											and amp.tipo_doc      = :gnvo_app.is_doc_oc
											and amp.nro_doc       = oc.nro_oc) 
											,2);

if SQLCA.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se puede actualizar el monto facturado en la cabecera de la OC. Mensaje: ' + ls_mensaje, StopSign!)
	return  false
end if

commit;

//Actualizo la cantidad facturada
update articulo_mov_proy amp
   set amp.cant_facturada = (select nvl(sum(cpd.cantidad * decode(dt.flag_signo, '+', 1, -1)), 0)
                             from cntas_pagar     cp,
                                  cntas_pagar_det cpd,
                                  doc_tipo        dt
                            where cp.cod_relacion = cpd.cod_relacion
                              and cp.tipo_doc     = cpd.tipo_doc
                              and cp.nro_doc      = cpd.nro_doc
                              and cp.tipo_doc     = dt.tipo_doc
                              and cp.flag_estado <> '0'
                              and cpd.org_amp_ref = amp.cod_origen
                              and cpd.nro_amp_ref = amp.nro_mov)
where amp.tipo_doc = :gnvo_app.is_doc_oc
  and amp.cant_facturada <> (select nvl(sum(cpd.cantidad * decode(dt.flag_signo, '+', 1, -1)), 0)
                             from cntas_pagar     cp,
                                  cntas_pagar_det cpd,
                                  doc_tipo        dt
                            where cp.cod_relacion = cpd.cod_relacion
                              and cp.tipo_doc     = cpd.tipo_doc
                              and cp.nro_doc      = cpd.nro_doc
                              and cp.tipo_doc     = dt.tipo_doc
                              and cp.flag_estado <> '0'
                              and cpd.org_amp_ref = amp.cod_origen
                              and cpd.nro_amp_ref = amp.nro_mov); 

if SQLCA.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se puede actualizar la cantidad facturada en el detalle de la OC. Mensaje: ' + ls_mensaje, StopSign!)
	return  false
end if
commit;

end function

public function String of_get_email (string as_cod_relacion);String			ls_email


select email
	into :ls_email
from proveedor
where proveedor = :as_cod_relacion;

return ls_email
end function

public function boolean of_show_imagen (string path_imagen);w_imagen 		lw_imagen
str_parametros	lstr_param


try
	
	lstr_param.string1 = path_imagen
	
	OpenWithParm(lw_imagen, lstr_param)
	
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return false
	
	lstr_param = Message.PowerObjectParm
	
	return lstr_param.b_Return
	
catch (Exception ex)
	
	gnvo_app.of_catch_exception(ex, 'Error al momento subir la imagen a la tabla ARTICULO')
end try
end function

public function boolean of_send_email_cambio_estado (u_dw_abc adw_master);String	ls_email_cliente, ls_email_soporte, ls_mensaje, ls_email_reply
String	ls_body_html, ls_subject

//Datos para el email
String	ls_proveedor, ls_nom_proveedor, ls_tipo_doc_ident, ls_ruc_dni, &
			ls_flag_personeria, ls_flag_nac_ext, ls_email, ls_nom_usuario, &
			ls_email_usuario, ls_hostName, ls_desc_nac_ext, ls_desc_personeria, &
			ls_tipo_relacion, ls_desc_tipo_relacion, ls_desc_tipo_doc
			

n_cst_emailMessage	lnvo_msg
n_winsock 				lnvo_api
try 
	
	invo_wait.of_mensaje("Validando inputs")
	

	if adw_master.RowCount() = 0 then return false
	
	ls_proveedor 		= adw_master.object.proveedor			[1]
	ls_nom_proveedor 	= adw_master.object.nom_proveedor	[1]
	ls_tipo_doc_ident = adw_master.object.tipo_doc_ident	[1]
	ls_tipo_relacion 	= adw_master.object.flag_clie_prov	[1]
	
	if ls_tipo_doc_ident = '6' then
		ls_ruc_dni = adw_master.object.ruc				[1]
	else
		ls_ruc_dni = adw_master.object.nro_doc_ident	[1]
	end if
	
	ls_flag_personeria 	= adw_master.object.flag_personeria	[1]
	ls_flag_nac_ext 		= adw_master.object.flag_nac_ext		[1]
	ls_email 				= adw_master.object.email				[1]
	
	if IsNull(ls_proveedor) or trim(ls_proveedor) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Codigo del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_nom_proveedor) or trim(ls_nom_proveedor) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado RAZON SOCIAL O NOMBRE COMPLETO del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_tipo_relacion) or trim(ls_tipo_relacion) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado EL TIPO DE RELACION del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_tipo_doc_ident) or trim(ls_tipo_doc_ident) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Tipo de Documento de Identidad del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_ruc_dni) or trim(ls_ruc_dni) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Numero de Documento de Identidad del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_flag_personeria) or trim(ls_flag_personeria) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Tipo de Personería del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_flag_nac_ext) or trim(ls_flag_nac_ext) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Si es Nacional o Extranjero del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_email) or trim(ls_email) = '' then
		ls_email = 'NO TIENE'
	end if
	
	if ls_tipo_relacion = '0' then
		ls_desc_tipo_relacion = 'CLIENTE'
	elseif ls_tipo_relacion = '1' then
		ls_desc_tipo_relacion = 'PROVEEDOR'
	elseif ls_tipo_relacion = '2' then
		ls_desc_tipo_relacion = 'CLIENTE / PROVEEDOR'
	else
		ls_desc_tipo_relacion = 'SEMBRADOR'
	end if
	
	if ls_flag_nac_ext = 'N' then
		ls_desc_nac_ext = 'NACIONAL'
	else
		ls_desc_nac_ext = 'EXTRANJERO'
	end if
	
	if ls_flag_personeria = 'N' then
		ls_desc_personeria = 'NATURAL'
	elseif ls_flag_personeria = 'J' then
		ls_desc_personeria = 'JURIDICA'
	else
		ls_desc_personeria = 'SUJETO NO DOMICILIADO'
	end if
	
	//Obtengo la descripcion del tipo de documento de identidad
	select t.desc_tipo_doc_rtps	
		into :ls_desc_tipo_doc
	from RRHH_TIPO_DOC_RTPS t
	where t.tipo_doc_rtps = :ls_tipo_doc_ident;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla RRHH_TIPO_DOC_RTPS. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No existe el Tipo de Documento de Identidad ' + ls_tipo_doc_ident + ' en la tabla RRHH_TIPO_DOC_RTPS.', StopSign!)
		return false
	end if
	
	
	//Ahora inserto el email de soporte
	invo_wait.of_mensaje("Genrando Email de Logistica")
	
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_LOGISTICA", "Charly, Chsanchez@transmarina.com;" &
																					  + "Asolimano, Asolimano@transmarina.com;" &
																					  + "Juan Bacigalupo, Jbacigalupo@transmarina.com;" &
																					  + "Sr Saravia, Hsaravia@transmarina.com;" &
																					  + "Arliaga, Jaliaga@transmarina.com;" &
																					  + "Saulo Zavaleta, Szavaleta@transmarina.com;" &
																					  + "Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	
	//MessageBox('Aviso', 'El email se enviara a los siguientes correos ' + ls_email_soporte)
	
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Obtengo el email del usuario
	select u.nombre, u.email
		into :ls_nom_usuario, :ls_email_usuario
	from usuario u
	where u.cod_usr = :gs_user;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla USUARIO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No existe el usuario ' + gs_user + ' en la tabla USUARIO.', StopSign!)
		return false
	end if
	
	if not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario)
	end if

	
	//Ahora genero el BODY del Correo
	ls_hostName = lnvo_api.of_getHostName()
	
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "EL PROVEEDOR " + upper(ls_nom_proveedor) + " HA SIDO ANULADO POR EL USUARIO " + upper(ls_nom_usuario)
	
	ls_body_html = '<table width="100%">' + char(10) + char(13) &
					 + '	<tr>' + char(10) + char(13) &
					 + '		<td>' + char(10) + char(13) &
					 + '			<h4>Sres LOGISTICA </br>' + char(10) + char(13) &
					 + ' 				 Se informa que por motivos de falta de cumplimiento de requisitos de SEGURIDAD o BASC, se ha anulado el siguiente registro: </h4>'+ char(10) + char(13) &
					 + '		<td>' + char(10) + char(13) &
					 + '	</tr>'+ char(10) + char(13) &
					 + '	<TR>'+ char(10) + char(13) &
					 + '		<td>'+ char(10) + char(13) &
					 + '			<table border="1" cellspacing="0" cellpadding="5" style="font-family: Lucida Sans Unicode, Lucida Grande, Sans-Serif; font-size: 12px;">' + char(10) + char(13) &
					 + '				<tr>' + char(10) + char(13) &
					  + '					<td>PROVEEDOR</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_proveedor + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>RAZON SOCIAL</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_nom_proveedor + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>TIPO DE RELACION</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_tipo_Relacion + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>TIPO DOCUMENTO</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_tipo_doc + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &					  
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>RUC - DNI</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_ruc_dni + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &					  
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>NACIONAL / EXTRANJERO</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_nac_ext + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>PERSONERIA</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_personeria + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>EMAIL</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_email + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>USUARIO QUE ANULO</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_nom_usuario + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>COMPUTER NAME</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_hostName + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>DIRECCION IP</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + lnvo_api.of_getIpAddress(ls_hostName) + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '			</table>' + char(10) + char(13) &
					  + '		</td>' + char(10) + char(13) &
					  + '	</tr>' + char(10) + char(13) &
					  + '<table>'
	
	if IsNull(ls_body_html) or trim(ls_body_html) = '' then
		ROLLBACK;
		MessageBox('Error', 'Error en funcion of_send_email_cambio_estado(). El cuerpo del correo esta nulo o vacio, por favor corrija!')
		return false
	end if
	
	//Poner Body y Subject (Asunto)
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Cargo los parametros
	invo_wait.of_mensaje("Cargando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then 
		ls_email_reply = gnvo_app.of_get_parametro("EMAIL_REPLY", 'no-reply@' + gnvo_app.empresa.is_sigla + '.com.pe')
		if not lnvo_msg.of_add_email_to('NO REPLY', ls_email_reply) then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Se ha cambiado datos del proveedor, se esta enviando el Correo")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	invo_wait.of_mensaje("Email de cambio de proveedor fue enviado Satisfactoriamente")
	
	return true
		

	
catch ( Exception ex )
	
	invo_wait.of_close()
	
	gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	
	return false

finally
	
	//destroy lnvo_msg
	//destroy lnvo_api
	
	invo_wait.of_close()
end try


end function

public function beanpadronruc of_leer_ruc_externo (string as_ruc);String 			ls_usuario, ls_clave, ls_url, ls_test, ls_path
Long				ll_rc, ll_Log
Exception		tmpEx
SoapConnection conn

ImplConsultaRUCService 	lnw_service
BeanPadronRUC				lnvo_obj

try
	lnvo_obj 	= create BeanPadronRUC
	ls_usuario 	= gnvo_app.of_get_parametro('USUARIO_REMOTO', 'sigre')
	ls_clave		= gnvo_app.of_get_parametro('CLAVE_REMOTO', 'sigre1234')
	ls_url		= gnvo_app.of_get_parametro('URL_WEB_SERVICES', 'http://pegazus.serveftp.com:9080/SunatWebServices/')
	ls_path 		='\SIGRE_EXE\QR_CODE_TMP\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '\'  

	If not DirectoryExists ( ls_path ) Then
	
		if not invo_util.of_CreateDirectory( ls_path ) then 
			tmpEx = create exception
			tmpEx.setMessage("No se creado el directorio correctamente. Directorio: " + ls_path)
			throw tmpEx
		end if
	
	End If

	conn = create SoapConnection
	
	ll_Log = conn.SetOptions("SoapLog=~"" + ls_path + "mySoapLog.log~"")

	//ls_url = 'http://localhost:8080/SunatWebServices/ImplConsultaRUC'
	
	ll_rc = conn.CreateInstance(lnw_service, 'ImplConsultaRUCService', ls_url + "ImplConsultaRUC?wsdl")
	
	lnvo_obj = lnw_service.consultarPB( as_ruc, gnvo_app.empresa.is_ruc, ls_usuario, ls_clave, &
												gs_empresa, gs_estacion)
	
	return lnvo_obj

catch(Exception ex)
	
	lnvo_obj = create BeanPadronRUC
	lnvo_obj.isOk = false
	lnvo_obj.mensaje = 'Exception en funcion of_leer_ruc_externo(). Mensaje: ' + ex.getMessage()
	
	return lnvo_obj
	
finally 
	
	destroy conn
	
end try
end function

public function string of_get_firma_autorizado (string as_ini_file, string as_user);String ls_file
try 
	invo_inifile.of_set_inifile(as_ini_file)
	
	ls_file		 = invo_inifile.of_get_Parametro ( "FIRMA_APROBACION_" + gs_empresa, as_user, "I:\sigre_exe\FirmaDigital\FirmaAutorizado" + as_user + ".png ")

	return ls_file
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')
	return gnvo_app.is_null
	
end try

end function

public function string of_get_firma_usuario (string as_ini_file, string as_user);String ls_file
try 
	invo_inifile.of_set_inifile(as_ini_file)

	ls_file		 = invo_inifile.of_get_Parametro ( "FIRMA_USUARIO_" + gs_empresa, as_user, "I:\sigre_exe\FirmaDigital\FirmaUsuario" + as_user + ".png ")

	return ls_file
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')
	return gnvo_app.is_null
	
end try

end function

public function boolean of_send_email_activa_prov (u_dw_abc adw_master);String	ls_email_cliente, ls_email_soporte, ls_mensaje, ls_email_reply
String	ls_body_html, ls_subject

//Datos para el email
String	ls_proveedor, ls_nom_proveedor, ls_tipo_doc_ident, ls_ruc_dni, &
			ls_flag_personeria, ls_flag_nac_ext, ls_email, ls_nom_usuario, &
			ls_email_usuario, ls_hostName, ls_desc_nac_ext, ls_desc_personeria, &
			ls_tipo_relacion, ls_desc_tipo_relacion, ls_desc_tipo_doc
			

n_cst_emailMessage	lnvo_msg
n_winsock 				lnvo_api
try 
	
	invo_wait.of_mensaje("Validando inputs")
	

	if adw_master.RowCount() = 0 then return false
	
	ls_proveedor 		= adw_master.object.proveedor			[1]
	ls_nom_proveedor 	= adw_master.object.nom_proveedor	[1]
	ls_tipo_doc_ident = adw_master.object.tipo_doc_ident	[1]
	ls_tipo_relacion 	= adw_master.object.flag_clie_prov	[1]
	
	if ls_tipo_doc_ident = '6' then
		ls_ruc_dni = adw_master.object.ruc				[1]
	else
		ls_ruc_dni = adw_master.object.nro_doc_ident	[1]
	end if
	
	ls_flag_personeria 	= adw_master.object.flag_personeria	[1]
	ls_flag_nac_ext 		= adw_master.object.flag_nac_ext		[1]
	ls_email 				= adw_master.object.email				[1]
	
	if IsNull(ls_proveedor) or trim(ls_proveedor) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Codigo del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_nom_proveedor) or trim(ls_nom_proveedor) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado RAZON SOCIAL O NOMBRE COMPLETO del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_tipo_relacion) or trim(ls_tipo_relacion) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado EL TIPO DE RELACION del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_tipo_doc_ident) or trim(ls_tipo_doc_ident) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Tipo de Documento de Identidad del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_ruc_dni) or trim(ls_ruc_dni) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Numero de Documento de Identidad del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_flag_personeria) or trim(ls_flag_personeria) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Tipo de Personería del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_flag_nac_ext) or trim(ls_flag_nac_ext) = '' then
		ROLLBACK;
		MessageBox('Error', 'No se ha especificado Si es Nacional o Extranjero del proveedor o Cliente en registro, por favor verifique!')
		return false
	end if
	
	if IsNull(ls_email) or trim(ls_email) = '' then
		ls_email = 'NO TIENE'
	end if
	
	if ls_tipo_relacion = '0' then
		ls_desc_tipo_relacion = 'CLIENTE'
	elseif ls_tipo_relacion = '1' then
		ls_desc_tipo_relacion = 'PROVEEDOR'
	elseif ls_tipo_relacion = '2' then
		ls_desc_tipo_relacion = 'CLIENTE / PROVEEDOR'
	else
		ls_desc_tipo_relacion = 'SEMBRADOR'
	end if
	
	if ls_flag_nac_ext = 'N' then
		ls_desc_nac_ext = 'NACIONAL'
	else
		ls_desc_nac_ext = 'EXTRANJERO'
	end if
	
	if ls_flag_personeria = 'N' then
		ls_desc_personeria = 'NATURAL'
	elseif ls_flag_personeria = 'J' then
		ls_desc_personeria = 'JURIDICA'
	else
		ls_desc_personeria = 'SUJETO NO DOMICILIADO'
	end if
	
	//Obtengo la descripcion del tipo de documento de identidad
	select t.desc_tipo_doc_rtps	
		into :ls_desc_tipo_doc
	from RRHH_TIPO_DOC_RTPS t
	where t.tipo_doc_rtps = :ls_tipo_doc_ident;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla RRHH_TIPO_DOC_RTPS. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No existe el Tipo de Documento de Identidad ' + ls_tipo_doc_ident + ' en la tabla RRHH_TIPO_DOC_RTPS.', StopSign!)
		return false
	end if
	
	
	//Ahora inserto el email de soporte
	invo_wait.of_mensaje("Genrando Email de Logistica")
	
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_LOGISTICA", "Charly, Chsanchez@transmarina.com;" &
																					  + "Asolimano, Asolimano@transmarina.com;" &
																					  + "Juan Bacigalupo, Jbacigalupo@transmarina.com;" &
																					  + "Sr Saravia, Hsaravia@transmarina.com;" &
																					  + "Arliaga, Jaliaga@transmarina.com;" &
																					  + "Saulo Zavaleta, Szavaleta@transmarina.com;" &
																					  + "Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	
	//MessageBox('Aviso', 'El email se enviara a los siguientes correos ' + ls_email_soporte)
	
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Obtengo el email del usuario
	select u.nombre, u.email
		into :ls_nom_usuario, :ls_email_usuario
	from usuario u
	where u.cod_usr = :gs_user;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla USUARIO. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No existe el usuario ' + gs_user + ' en la tabla USUARIO.', StopSign!)
		return false
	end if
	
	if not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario)
	end if

	
	//Ahora genero el BODY del Correo
	ls_hostName = lnvo_api.of_getHostName()
	
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "EL PROVEEDOR " + upper(ls_nom_proveedor) + " HA SIDO ACTIVADO POR EL USUARIO " + upper(ls_nom_usuario)
	
	ls_body_html = '<table width="100%">' + char(10) + char(13) &
					 + '	<tr>' + char(10) + char(13) &
					 + '		<td>' + char(10) + char(13) &
					 + '			<h4>Sres LOGISTICA </br>' + char(10) + char(13) &
					 + ' 				 Se informa que se ha ACTIVADO el siguiente CODIGO DE RELACION: </h4>'+ char(10) + char(13) &
					 + '		<td>' + char(10) + char(13) &
					 + '	</tr>'+ char(10) + char(13) &
					 + '	<TR>'+ char(10) + char(13) &
					 + '		<td>'+ char(10) + char(13) &
					 + '			<table border="1" cellspacing="0" cellpadding="5" style="font-family: Lucida Sans Unicode, Lucida Grande, Sans-Serif; font-size: 12px;">' + char(10) + char(13) &
					 + '				<tr>' + char(10) + char(13) &
					  + '					<td>PROVEEDOR</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_proveedor + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>RAZON SOCIAL</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_nom_proveedor + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>TIPO DE RELACION</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_tipo_Relacion + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>TIPO DOCUMENTO</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_tipo_doc + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &					  
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>RUC - DNI</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_ruc_dni + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &					  
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>NACIONAL / EXTRANJERO</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_nac_ext + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>PERSONERIA</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_desc_personeria + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>EMAIL</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_email + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>USUARIO QUE ANULO</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_nom_usuario + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>COMPUTER NAME</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_hostName + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>DIRECCION IP</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + lnvo_api.of_getIpAddress(ls_hostName) + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '			</table>' + char(10) + char(13) &
					  + '		</td>' + char(10) + char(13) &
					  + '	</tr>' + char(10) + char(13) &
					  + '<table>'
	
	if IsNull(ls_body_html) or trim(ls_body_html) = '' then
		ROLLBACK;
		MessageBox('Error', 'Error en funcion of_send_email_activa_prov(). El cuerpo del correo esta nulo o vacio, por favor corrija!')
		return false
	end if
	
	//Poner Body y Subject (Asunto)
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Cargo los parametros
	invo_wait.of_mensaje("Cargando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then 
		ls_email_reply = gnvo_app.of_get_parametro("EMAIL_REPLY", 'no-reply@' + gnvo_app.empresa.is_sigla + '.com.pe')
		if not lnvo_msg.of_add_email_to('NO REPLY', ls_email_reply) then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Se ha cambiado datos del proveedor, se esta enviando el Correo")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	invo_wait.of_mensaje("Email de cambio de proveedor fue enviado Satisfactoriamente")
	
	return true
		

	
catch ( Exception ex )
	
	invo_wait.of_close()
	
	gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	
	return false

finally
	
	//destroy lnvo_msg
	//destroy lnvo_api
	
	invo_wait.of_close()
end try


end function

public function boolean of_send_email_aprob_oc (string as_nro_oc, string as_aprobador);String 					ls_email_usuario, ls_nom_proveedor, ls_ruc_dni, ls_cod_usr, &
							ls_nom_usuario, ls_email_soporte, ls_nom_aprobador
String					ls_mensaje, ls_body_html, ls_subject, ls_observacion
DateTime					ldt_fec_servidor
n_cst_emailMessage	lnvo_msg

try 
	
	ldt_fec_servidor = gnvo_app.of_fecha_actual()
	
	//Nombre del aprobador
	select nombre
		into :ls_nom_aprobador
	from usuario u
	where u.cod_usr = :as_aprobador;

	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe el usuario aprobador : ' + as_aprobador + '.Por favor verifique!', StopSign!)
		return false			
	end if	
	
	
	//Obtengo el email y el nombre del cliente
	select p.nom_proveedor, 
			 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
			 oc.cod_usr,
			 u.nombre,
			 u.email,
			 oc.observacion
		into 	:ls_nom_proveedor,
				:ls_ruc_dni,
				:ls_cod_usr,
				:ls_nom_usuario,
				:ls_email_usuario,
				:ls_observacion
	from orden_compra 	oc,
		  proveedor      	p,
		  usuario        	u
	where oc.proveedor  	= p.proveedor
	  and oc.cod_usr    	= u.cod_usr
	  and oc.nro_oc		= :as_nro_oc;
     
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe la Orden de COMPRA: ' + as_nro_oc + '.Por favor verifique!', StopSign!)
		return false			
	end if
	
	//Adiciono el email del usuario que lo ha creado
	if Not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
		
				
			yield()
			invo_wait.of_mensaje("Error al validar email del usuario " + ls_mensaje + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()
	
			//invo_wait.of_close()
			
			//return false
		else
			if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
		end if
		
		
	end if
	

	//Si el email del cliente es valido entonces lo agrego
	try
		if trim(ls_email_usuario) <> '' and pos(ls_email_usuario, '@', 1) > 0 then
			
			if pos(ls_email_usuario, '/', 1) > 0 or pos(ls_email_usuario, ';', 1) > 0 then
			
				//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
				if not lnvo_msg.of_add_emails_client_from_string(ls_nom_usuario, ls_email_usuario) then return false
				
			else
				//Si no solamente adiciono el email del cliente como un unico email
				if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
				
						
					yield()
					invo_wait.of_mensaje("Error al validar: " + ls_mensaje)
					sleep(2)
					yield()
	
					//invo_wait.of_close()
					
					//return false
				end if
				
				invo_wait.of_mensaje("Adicionando Email del USUARIO")
				if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
	
			end if
			
		end if
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del USUARIO: " + e.getMessage())
	end try
	
	
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el mensaje que sería HTML
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "LA ORDEN DE COMPRA " + as_nro_oc + " HA SIDO APROBADA POR EL APROBADOR " + ls_nom_aprobador
	
	ls_body_html += "Estimado Usuario : <b><i>" + ls_nom_usuario + "</i></b><br/>" &
					  + " Su Orden de COMPRA " + as_nro_oc + " - " + ls_observacion + " ha sido aprobada por " &
					  + "<b><i>" + ls_nom_aprobador + "</i></b> a las <b><i>" + string(ldt_fec_servidor, "hh:mm") &
					  + "</i></b> del dia <b><i>" + string(ldt_fec_servidor, "dd/mm/yyyy") +"</i></b><br/><br/>"
	
	ls_body_html += "Sin otro particular<br/><br/>" &
					  + '<font face="Comic Sans MS,arial,verdana" size="1px">' &
					  + '		ERP SIGRE<br/>' &
					  + '		El ERP para su empresa<br/>' &
					  + '		</font>'
	
	ls_body_html += '</body></html>'
	
	//Poner Body y Subject (Asunto)
	
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Obtengo los Archivos correctos
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	return true
		

	
catch ( Exception ex )
	
	//gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_send_email_desaprob_oc (string as_nro_oc, string as_aprobador);String 					ls_email_usuario, ls_nom_proveedor, ls_ruc_dni, ls_cod_usr, &
							ls_nom_usuario, ls_email_soporte, ls_nom_aprobador
String					ls_mensaje, ls_body_html, ls_subject
n_cst_emailMessage	lnvo_msg

try 
	
	//Nombre del aprobador
	select nombre
		into :ls_nom_aprobador
	from usuario u
	where u.cod_usr = :as_aprobador;

	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe el usuario aprobador : ' + as_aprobador + '.Por favor verifique!', StopSign!)
		return false			
	end if	
	
	
	//Obtengo el email y el nombre del cliente
	select p.nom_proveedor, 
			 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
			 oc.cod_usr,
			 u.nombre,
			 u.email
		into 	:ls_nom_proveedor,
				:ls_ruc_dni,
				:ls_cod_usr,
				:ls_nom_usuario,
				:ls_email_usuario
	from orden_compra 	oc,
		  proveedor      	p,
		  usuario        	u
	where oc.proveedor  	= p.proveedor
	  and oc.cod_usr    	= u.cod_usr
	  and oc.nro_oc		= :as_nro_oc;
     
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe la Orden de COMPRA: ' + as_nro_oc + '.Por favor verifique!', StopSign!)
		return false			
	end if
	
	//Adiciono el email del usuario que lo ha creado
	if Not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
		
				
			yield()
			invo_wait.of_mensaje("Error al validar email del usuario " + ls_mensaje + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()
	
			//invo_wait.of_close()
			
			//return false
		else
			if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
		end if
		
		
	end if
	

	//Si el email del cliente es valido entonces lo agrego
	try
		if trim(ls_email_usuario) <> '' and pos(ls_email_usuario, '@', 1) > 0 then
			
			if pos(ls_email_usuario, '/', 1) > 0 or pos(ls_email_usuario, ';', 1) > 0 then
			
				//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
				if not lnvo_msg.of_add_emails_client_from_string(ls_nom_usuario, ls_email_usuario) then return false
				
			else
				//Si no solamente adiciono el email del cliente como un unico email
				if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
				
						
					yield()
					invo_wait.of_mensaje("Error al validar: " + ls_mensaje)
					sleep(2)
					yield()
	
					//invo_wait.of_close()
					
					//return false
				end if
				
				invo_wait.of_mensaje("Adicionando Email del USUARIO")
				if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
	
			end if
			
		end if
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del USUARIO: " + e.getMessage())
	end try
	
	
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el mensaje que sería HTML
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "LA ORDEN SE COMPRA " + as_nro_oc + " HA SIDO DESAPROBADA POR EL APROBADOR " + ls_nom_aprobador
	
	//Armo la cabecera la tabla
	ls_body_html = '<body>'

	//1. El saludo preliminar
	ls_body_html += "Estimado Usuario : " + ls_nom_usuario &
					  + " el Usuario <bold>APROBADOR : " + ls_nom_aprobador + "</bold> ha DESAPROBADO " &
					  + " su Orden de COMPRA " + as_nro_oc
	
	ls_body_html += '</body>'
	
	//Poner Body y Subject (Asunto)
	
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Obtengo los Archivos correctos
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	return true
		

	
catch ( Exception ex )
	
	//gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_send_email_rechazo_os (string as_nro_os, string as_aprobador, string as_mensaje);String 					ls_email_usuario, ls_nom_proveedor, ls_ruc_dni, ls_cod_usr, &
							ls_nom_usuario, ls_email_soporte, ls_nom_aprobador
String					ls_mensaje, ls_body_html, ls_subject
n_cst_emailMessage	lnvo_msg

try 
	
	//Nombre del aprobador
	select nombre
		into :ls_nom_aprobador
	from usuario u
	where u.cod_usr = :as_aprobador;

	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe el usuario aprobador : ' + as_aprobador + '.Por favor verifique!', StopSign!)
		return false			
	end if	
	
	
	//Obtengo el email y el nombre del cliente
	select p.nom_proveedor, 
			 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
			 os.cod_usr,
			 u.nombre,
			 u.email
		into 	:ls_nom_proveedor,
				:ls_ruc_dni,
				:ls_cod_usr,
				:ls_nom_usuario,
				:ls_email_usuario
	from orden_Servicio os,
		  proveedor      p,
		  usuario        u
	where os.proveedor  	= p.proveedor
	  and os.cod_usr    	= u.cod_usr
	  and os.nro_os		= :as_nro_os;
     
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe la Orden de Servicio: ' + as_nro_os + '.Por favor verifique!', StopSign!)
		return false			
	end if
	
	//Adiciono el email del usuario que lo ha creado
	if Not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
		
				
			yield()
			invo_wait.of_mensaje("Error al validar email del usuario " + ls_mensaje + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()
	
			//invo_wait.of_close()
			
			//return false
		else
			if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
		end if
		
		
	end if
	

	//Si el email del cliente es valido entonces lo agrego
	try
		if trim(ls_email_usuario) <> '' and pos(ls_email_usuario, '@', 1) > 0 then
			
			if pos(ls_email_usuario, '/', 1) > 0 or pos(ls_email_usuario, ';', 1) > 0 then
			
				//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
				if not lnvo_msg.of_add_emails_client_from_string(ls_nom_usuario, ls_email_usuario) then return false
				
			else
				//Si no solamente adiciono el email del cliente como un unico email
				if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
				
						
					yield()
					invo_wait.of_mensaje("Error al validar: " + ls_mensaje)
					sleep(2)
					yield()
	
					//invo_wait.of_close()
					
					//return false
				end if
				
				invo_wait.of_mensaje("Adicionando Email del cliente")
				if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
	
			end if
			
		else
			//if this.is_send_email_only_cliente = '1' then return false
		end if
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del cliente: " + e.getMessage())
	end try
	
	
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el mensaje que sería HTML
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "LA ORDEN SE SERVICIO " + as_nro_os + " HA SIDO RECHAZADA POR EL APROBADOR " + ls_nom_aprobador
	
	//Armo la cabecera la tabla
	ls_body_html = '<body>'

	//1. El saludo preliminar
	ls_body_html += "Estimado Usuario : " + ls_nom_usuario &
					  + " el Usuario <bold>APROBADOR : " + ls_nom_aprobador + "</bold> ha rechazado " &
					  + " la Orden de Servicio " + as_nro_os + " por el siguiente motivo: " + as_mensaje
	
	ls_body_html += '</body>'
	
	//Poner Body y Subject (Asunto)
	
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Obtengo los Archivos correctos
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	return true
		

	
catch ( Exception ex )
	
	//gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_send_email_aprob_os (string as_nro_os, string as_aprobador);String 					ls_email_usuario, ls_nom_proveedor, ls_ruc_dni, ls_cod_usr, &
							ls_nom_usuario, ls_email_soporte, ls_nom_aprobador, ls_Descripcion
String					ls_mensaje, ls_body_html, ls_subject
n_cst_emailMessage	lnvo_msg
DateTime					ldt_fec_servidor

try 
	
	ldt_fec_servidor = gnvo_app.of_fecha_actual()
	
	//Nombre del aprobador
	select nombre
		into :ls_nom_aprobador
	from usuario u
	where u.cod_usr = :as_aprobador;

	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe el usuario aprobador : ' + as_aprobador + '.Por favor verifique!', StopSign!)
		return false			
	end if	
	
	
	//Obtengo el email y el nombre del usuario
	select p.nom_proveedor, 
			 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
			 os.cod_usr,
			 u.nombre,
			 u.email,
			 os.descripcion
		into 	:ls_nom_proveedor,
				:ls_ruc_dni,
				:ls_cod_usr,
				:ls_nom_usuario,
				:ls_email_usuario,
				:ls_descripcion
	from orden_Servicio os,
		  proveedor      p,
		  usuario        u
	where os.proveedor  	= p.proveedor
	  and os.cod_usr    	= u.cod_usr
	  and os.nro_os		= :as_nro_os;
     
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe la Orden de SERVICIO: ' + as_nro_os + '.Por favor verifique!', StopSign!)
		return false			
	end if
	
	//Adiciono el email del usuario que lo ha creado
	if Not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
		
				
			yield()
			invo_wait.of_mensaje("Error al validar email del usuario " + ls_mensaje + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()
	
			//invo_wait.of_close()
			
			//return false
		else
			if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
		end if
		
		
	end if
	

	//Si el email del usuario es valido entonces lo agrego
	try
		if trim(ls_email_usuario) <> '' and pos(ls_email_usuario, '@', 1) > 0 then
			
			if pos(ls_email_usuario, '/', 1) > 0 or pos(ls_email_usuario, ';', 1) > 0 then
			
				//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
				if not lnvo_msg.of_add_emails_client_from_string(ls_nom_usuario, ls_email_usuario) then return false
				
			else
				//Si no solamente adiciono el email del usuario como un unico email
				if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
				
						
					yield()
					invo_wait.of_mensaje("Error al validar: " + ls_mensaje)
					sleep(2)
					yield()
	
					//invo_wait.of_close()
					
					//return false
				end if
				
				invo_wait.of_mensaje("Adicionando Email del usuario")
				if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
	
			end if
			
		end if
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del usuario: " + e.getMessage())
	end try
	
	
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el mensaje que sería HTML
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "LA ORDEN SE SERVICIO " + as_nro_os + " HA SIDO APROBADA POR EL APROBADOR " + ls_nom_aprobador
	
	//Armo la cabecera la tabla
	ls_body_html = '<html><body>'

	//1. El saludo preliminar
	ls_body_html += "Estimado Usuario : <b><i>" + ls_nom_usuario + "</i></b><br/>" &
					  + " Su Orden de Servicio " + as_nro_os + " - " + ls_descripcion + " ha sido aprobada por " &
					  + "<b><i>" + ls_nom_aprobador + "</i></b> a las <b><i>" + string(ldt_fec_servidor, "hh:mm") &
					  + "</i></b> del dia <b><i>" + string(ldt_fec_servidor, "dd/mm/yyyy") +"</i></b><br/><br/>"
	
	ls_body_html += "Sin otro particular<br/><br/>" &
					  + '<font face="Comic Sans MS,arial,verdana" size="1px">' &
					  + '		ERP SIGRE<br/>' &
					  + '		El ERP para su empresa<br/>' &
					  + '		</font>'
	
	ls_body_html += '</body></html>'
	
	//Poner Body y Subject (Asunto)
	
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Obtengo los Archivos correctos
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	return true
		

	
catch ( Exception ex )
	
	//gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_send_email_desaprob_os (string as_nro_os, string as_aprobador);String 					ls_email_usuario, ls_nom_proveedor, ls_ruc_dni, ls_cod_usr, &
							ls_nom_usuario, ls_email_soporte, ls_nom_aprobador
String					ls_mensaje, ls_body_html, ls_subject
n_cst_emailMessage	lnvo_msg

try 
	
	//Nombre del aprobador
	select nombre
		into :ls_nom_aprobador
	from usuario u
	where u.cod_usr = :as_aprobador;

	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe el usuario aprobador : ' + as_aprobador + '.Por favor verifique!', StopSign!)
		return false			
	end if	
	
	
	//Obtengo el email y el nombre del usuario
	select p.nom_proveedor, 
			 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
			 os.cod_usr,
			 u.nombre,
			 u.email
		into 	:ls_nom_proveedor,
				:ls_ruc_dni,
				:ls_cod_usr,
				:ls_nom_usuario,
				:ls_email_usuario
	from orden_Servicio os,
		  proveedor      p,
		  usuario        u
	where os.proveedor  	= p.proveedor
	  and os.cod_usr    	= u.cod_usr
	  and os.nro_os		= :as_nro_os;
     
	
	if SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		MessageBox('Error', 'No existe la Orden de SERVICIO: ' + as_nro_os + '.Por favor verifique!', StopSign!)
		return false			
	end if
	
	//Adiciono el email del usuario que lo ha creado
	if Not IsNull(ls_email_usuario) and trim(ls_email_usuario) <> '' then
		if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
		
				
			yield()
			invo_wait.of_mensaje("Error al validar email del usuario " + ls_mensaje + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()
	
			//invo_wait.of_close()
			
			//return false
		else
			if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
		end if
		
		
	end if
	

	//Si el email del usuario es valido entonces lo agrego
	try
		if trim(ls_email_usuario) <> '' and pos(ls_email_usuario, '@', 1) > 0 then
			
			if pos(ls_email_usuario, '/', 1) > 0 or pos(ls_email_usuario, ';', 1) > 0 then
			
				//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
				if not lnvo_msg.of_add_emails_client_from_string(ls_nom_usuario, ls_email_usuario) then return false
				
			else
				//Si no solamente adiciono el email del usuario como un unico email
				if not invo_smtp.of_ValidEmail(ls_email_usuario, ls_mensaje) then
				
						
					yield()
					invo_wait.of_mensaje("Error al validar: " + ls_mensaje)
					sleep(2)
					yield()
	
					//invo_wait.of_close()
					
					//return false
				end if
				
				invo_wait.of_mensaje("Adicionando Email del usuario")
				if not lnvo_msg.of_add_email_to(ls_nom_usuario, ls_email_usuario) then return false
	
			end if
			
		end if
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del usuario: " + e.getMessage())
	end try
	
	
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Ahora genero el mensaje que sería HTML
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	
	ls_subject = "LA ORDEN SE SERVICIO " + as_nro_os + " HA SIDO DESAPROBADA POR EL APROBADOR " + ls_nom_aprobador
	
	//Armo la cabecera la tabla
	ls_body_html = '<body>'

	//1. El saludo preliminar
	ls_body_html += "Estimado Usuario : " + ls_nom_usuario &
					  + " el Usuario <bold>APROBADOR : " + ls_nom_aprobador + "</bold> ha DESAPROBADO " &
					  + " su Orden de Servicio " + as_nro_os
	
	ls_body_html += '</body>'
	
	//Poner Body y Subject (Asunto)
	
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)

	//Obtengo los Archivos correctos
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	return true
		

	
catch ( Exception ex )
	
	//gnvo_app.of_catch_exception(ex, 'Error al enviar por email el comprobante')
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	
	//destroy lnvo_msg
	invo_wait.of_close()
end try


end function

public function boolean of_act_cant_procesada (string as_nro_oc);String ls_mensaje

update articulo_mov_proy amp
   set amp.cant_procesada = ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                               from articulo_mov am,  
                                    vale_mov     vm,
                                    articulo_mov_tipo amt
                              where am.nro_Vale = vm.nro_vale
                                and vm.tipo_mov = amt.tipo_mov
                                and am.flag_estado <> '0'
                                and vm.flag_estado <> '0'
                                and am.origen_mov_proy = amp.cod_origen
                                and am.nro_mov_proy    = amp.nro_mov) +
                            (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                               from vale_mov_trans_det vtd,  
                                    vale_mov_trans     vt,
                                    articulo_mov_tipo  amt
                              where vtd.nro_vale  = vt.nro_vale
                                and vt.tipo_mov   = amt.tipo_mov
                                and vtd.flag_estado <> '0'
                                and vt.flag_estado  <> '0'
                                and vtd.org_amp_oc     = amp.cod_origen
                                and vtd.nro_amp_oc     = amp.nro_mov))
  where amp.cant_procesada <> ((Select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total)),0)
                               from articulo_mov am,  
                                    vale_mov     vm,
                                    articulo_mov_tipo amt
                              where am.nro_Vale = vm.nro_vale
                                and vm.tipo_mov = amt.tipo_mov
                                and am.flag_estado <> '0'
                                and vm.flag_estado <> '0'
                                and am.origen_mov_proy = amp.cod_origen
                                and am.nro_mov_proy    = amp.nro_mov) +
                            (Select nvl(abs(sum(vtd.cant_procesada * amt.factor_sldo_total)),0)
                               from vale_mov_trans_det vtd,  
                                    vale_mov_trans     vt,
                                    articulo_mov_tipo  amt
                              where vtd.nro_vale  = vt.nro_vale
                                and vt.tipo_mov   = amt.tipo_mov
                                and vtd.flag_estado <> '0'
                                and vt.flag_estado  <> '0'
                                and vtd.org_amp_oc     = amp.cod_origen
                                and vtd.nro_amp_oc     = amp.nro_mov))
   and amp.tipo_doc 	= (select doc_oc from logparam where reckey = '1')
	and amp.nro_doc	= :as_nro_oc;
										  
if SQLCA.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se puede actualizar la cantidad procesada en la orden de compra. Mensaje: ' + ls_mensaje, StopSign!)
	return  false
end if


commit;

return true

end function

public function boolean of_act_monto_facturado (string as_nro_oc);String ls_mensaje

// Actualizo el monto facturado
update orden_compra  oc
  set oc.monto_facturado = round((
										select nvl(sum(decode(dt.flag_signo, '+', 1, -1) * cpd.importe ),0) 
										  from cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp 
										 where cpd.tipo_doc    = dt.tipo_doc
											and cpd.org_amp_ref = amp.cod_origen 
											and cpd.nro_amp_ref = amp.nro_mov
											and amp.tipo_doc    = :gnvo_app.is_doc_oc
											and amp.nro_doc     = oc.nro_oc) + 
									  (select nvl(sum(cpi.importe * decode(it.signo, '+', 1, -1) * decode(dt.flag_signo, '+', 1, -1)),0) 
										  from cp_doc_det_imp  cpi,
												 cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp,
												 impuestos_tipo    it
										 where cpd.tipo_doc    = dt.tipo_doc
											and cpd.cod_relacion = cpi.cod_relacion
											and cpd.tipo_doc     = cpi.tipo_doc
											and cpd.nro_doc      = cpi.nro_doc
											and cpd.item         = cpi.item
											and cpi.tipo_impuesto = it.tipo_impuesto
											and cpd.org_amp_ref = amp.cod_origen 
											and cpd.nro_amp_ref = amp.nro_mov
											and amp.tipo_doc    = :gnvo_app.is_doc_oc
											and amp.nro_doc     = oc.nro_oc) 
											,2),
	  oc.flag_replicacion = '1'
where oc.nro_oc	 = :as_nro_oc
  and oc.monto_facturado <> round((select nvl(sum(decode(dt.flag_signo, '+', 1, -1) * cpd.importe ),0) 
										  from cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp 
										 where cpd.tipo_doc    = dt.tipo_doc
											and cpd.org_amp_ref = amp.cod_origen 
											and cpd.nro_amp_ref = amp.nro_mov
											and amp.tipo_doc    = :gnvo_app.is_doc_oc
											and amp.nro_doc     = oc.nro_oc) + 
									  (select nvl(sum(cpi.importe * decode(it.signo, '+', 1, -1) * decode(dt.flag_signo, '+', 1, -1)),0) 
										  from cp_doc_det_imp  cpi,
												 cntas_pagar_det cpd,
												 doc_tipo        dt,
												 articulo_mov_proy amp,
												 impuestos_tipo    it
										 where cpd.tipo_doc      = dt.tipo_doc
											and cpd.cod_relacion  = cpi.cod_relacion
											and cpd.tipo_doc      = cpi.tipo_doc
											and cpd.nro_doc       = cpi.nro_doc
											and cpd.item          = cpi.item
											and cpi.tipo_impuesto = it.tipo_impuesto
											and cpd.org_amp_ref   = amp.cod_origen 
											and cpd.nro_amp_ref   = amp.nro_mov
											and amp.tipo_doc      = :gnvo_app.is_doc_oc
											and amp.nro_doc       = oc.nro_oc) 
											,2);

if SQLCA.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se puede actualizar el monto facturado en la cabecera de la OC. Mensaje: ' + ls_mensaje, StopSign!)
	return  false
end if

commit;

//Actualizo la cantidad facturada
update articulo_mov_proy amp
   set amp.cant_facturada = (select nvl(sum(cpd.cantidad * decode(dt.flag_signo, '+', 1, -1)), 0)
                             from cntas_pagar     cp,
                                  cntas_pagar_det cpd,
                                  doc_tipo        dt
                            where cp.cod_relacion = cpd.cod_relacion
                              and cp.tipo_doc     = cpd.tipo_doc
                              and cp.nro_doc      = cpd.nro_doc
                              and cp.tipo_doc     = dt.tipo_doc
                              and cp.flag_estado <> '0'
                              and cpd.org_amp_ref = amp.cod_origen
                              and cpd.nro_amp_ref = amp.nro_mov)
where amp.tipo_doc = :gnvo_app.is_doc_oc
  and amp.nro_doc	 = :as_nro_oc
  and amp.cant_facturada <> (select nvl(sum(cpd.cantidad * decode(dt.flag_signo, '+', 1, -1)), 0)
                             from cntas_pagar     cp,
                                  cntas_pagar_det cpd,
                                  doc_tipo        dt
                            where cp.cod_relacion = cpd.cod_relacion
                              and cp.tipo_doc     = cpd.tipo_doc
                              and cp.nro_doc      = cpd.nro_doc
                              and cp.tipo_doc     = dt.tipo_doc
                              and cp.flag_estado <> '0'
                              and cpd.org_amp_ref = amp.cod_origen
                              and cpd.nro_amp_ref = amp.nro_mov); 

if SQLCA.SQlCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se puede actualizar la cantidad facturada en el detalle de la OC. Mensaje: ' + ls_mensaje, StopSign!)
	return  false
end if

commit;

end function

on n_cst_compras.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_compras.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//this.of_load( )
invo_wait 	= create n_Cst_wait
invo_inifile = create n_Cst_inifile


end event

event destructor;destroy invo_wait
destroy invo_inifile
end event

