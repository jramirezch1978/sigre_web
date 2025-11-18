$PBExportHeader$n_cst_contabilidad.sru
forward
global type n_cst_contabilidad from nonvisualobject
end type
end forward

global type n_cst_contabilidad from nonvisualobject
end type
global n_cst_contabilidad n_cst_contabilidad

forward prototypes
public function str_cnta_cntbl of_get_cnta_cntbl ()
public function integer of_cierre_almacen (long al_year, long al_mes)
public function integer of_cierre_almacen (date ad_fecha)
public function boolean is_valid_fec_mov_almacen (date ad_fecha)
public function str_parametros of_get_cnta_cntbl (boolean ab_multiple)
public function string of_get_matriz (string as_tipo_mov, string as_cencos, string as_cod_art) throws exception
public subroutine of_update_asientos ()
public function str_cnta_cntbl of_cnta_cntbl (string as_cnta_cntbl)
public function boolean of_cnta_cntbl (string as_cnta_cntbl, ref str_cnta_cntbl astr_param)
end prototypes

public function str_cnta_cntbl of_get_cnta_cntbl ();str_cnta_cntbl lstr_return
str_parametros lstr_param

lstr_param.dw1 	= 'd_cnta_cntbl_tv'
lstr_param.titulo = 'PLAN DE CUENTAS CONTABLES'
lstr_param.opcion	= 1

OpenWithParm(w_search_tv, lstr_param)

If IsValid(Message.PowerObjectParm) and not IsNull(Message.PowerObjectParm) then 
	lstr_return = Message.PowerObjectParm
else
	lstr_return.b_return = false
end if

return lstr_return
end function

public function integer of_cierre_almacen (long al_year, long al_mes);Integer li_cierre_mes, li_almacen, li_Cerrado

SELECT NVL( flag_almacen, 0 ), NVL( flag_cierre_mes, 0 ) 
  INTO :li_almacen, :li_cierre_mes
from cntbl_cierre 
where ano = :al_year 
  and mes = :al_mes ;

if SQLCA.SQLCode = 100 then
	gnvo_app.of_mensaje_error( "Periodo Contable " + string(al_year, '0000') + '-' + string(al_mes, '00') + ' no existe por favor verifique!')
	return -1
end if

if li_almacen = 1 then
	if li_cierre_mes = 0 then
		li_cerrado = 0
	else
		li_cerrado = 1
	end if
else
	li_Cerrado = li_almacen
end if

return li_cerrado
  
end function

public function integer of_cierre_almacen (date ad_fecha);return this.of_cierre_almacen( year(ad_fecha), month(ad_fecha))
end function

public function boolean is_valid_fec_mov_almacen (date ad_fecha);Integer li_cierre

li_cierre = this.of_cierre_almacen( ad_fecha )

if li_cierre = -1 then return false

if li_cierre = 0 then
	gnvo_app.of_mensaje_error( "El periodo contable " + string(ad_fecha, 'yyyymm') + " esta cerrado, imposible hacer cambios, por favor verifique!")
	return false
end if

return true
end function

public function str_parametros of_get_cnta_cntbl (boolean ab_multiple);str_parametros lstr_param

lstr_param.dw1 	= 'd_cnta_cntbl_multiple_tv'
lstr_param.titulo = 'PLAN DE CUENTAS CONTABLES'
lstr_param.opcion	= 1
lstr_param.select_multiple = true

OpenWithParm(w_search_tv, lstr_param)

If IsValid(Message.PowerObjectParm) and not IsNull(Message.PowerObjectParm) then 
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.b_return then
	
		if UpperBound(lstr_param.istr_cntas) = 0 then
			lstr_param.b_return = false
		end if
	else
		lstr_param.b_return = false
	end if
else
	lstr_param.b_return = false
end if

return lstr_param

end function

public function string of_get_matriz (string as_tipo_mov, string as_cencos, string as_cod_art) throws exception;String		ls_matriz, ls_cod_sub_cat, ls_grp_cntbl, ls_mensaje, ls_matriz_vs000
Integer		li_factor_presup, li_count
Exception 	ex

//Obtengo la matriz pro defecto
ls_matriz_vs000 = gnvo_app.of_get_parametro( "MATRIZ_CNTBL_VS-000", "VS-000")

//Obtengo la sucbategoria del articulo
select a.SUB_CAT_ART
  into :ls_cod_sub_cat
  from articulo a
 where a.cod_art = :as_cod_art;

if SQLCA.SQLCode = 100 then
	rollback;
	ex = create Exception
	ex.setMessage( "Error, el código de articulo " + as_cod_art + " no existe en la tabla ARTICULO, por favor verifique!")
	throw ex
	return gnvo_app.is_null
end if

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	ex = create Exception
	ex.setMessage( "Ha ocurrido un error al consulta la tabla ARTICULO, Codigo " + as_cod_art + &
						"~r~nMensaje de Error: " + ls_mensaje)
	throw ex
	return gnvo_app.is_null
end if


select factor_presup
	into :li_factor_presup
from articulo_mov_tipo
where tipo_mov = :as_tipo_mov;

if SQLCA.SQLCode = 100 then
	rollback;
	ex = create Exception
	ex.setMessage( "Error, el Tipo de Mov " + as_tipo_mov + " no existe en la tabla ARTICULO_MOV_TIPO, por favor verifique!")
	throw ex
	return gnvo_app.is_null
end if

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	ex = create Exception
	ex.setMessage( "Ha ocurrido un error al consulta la tabla ARTICULO_MOV_TIPO, Tipo MOV: " + as_tipo_mov + &
						"~r~nMensaje de Error: " + ls_mensaje)
	throw ex
	return gnvo_app.is_null
end if

if li_factor_presup = 0 then
	//si no afecta presupuesto, no busco grupo contable
	select matriz
	  into :ls_matriz
	from tipo_mov_matriz_subcat
	where tipo_mov 	= :as_tipo_mov
	  and cod_sub_cat = :ls_cod_sub_cat
	  and item			= 1;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		ex = create Exception
		ex.setMessage( "Ha ocurrido un error al consulta la tabla TIPO_MOV_MATRIZ_SUBCAT, " &
							+ "~r~nTipo MOV: " + as_tipo_mov &
							+ "~r~nSub Categoria: " + ls_cod_sub_cat &
							+ "~r~nMensaje de Error: " + ls_mensaje)
		throw ex
		return gnvo_app.is_null
	end if
	
	if SQLCA.SQLCode = 100 then
		insert into tipo_mov_matriz_subcat( tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
		values(:as_tipo_mov, '20', :ls_cod_sub_cat, 1, :ls_matriz_vs000);
		
		ls_matriz = ls_matriz_vs000
	end if


else
	// Si en caso pida presupuesto, entonces debe tener centro de costos y grupo contable
	if IsNull(as_cencos) or trim(as_cencos) = '' then
		rollback;
		ex = create Exception
		ex.setMessage( "EL tipo de movimiento " + as_tipo_mov + " pide cuenta presupuestal, " &
						 + "pero no ha indicado Centro de costos")
		throw ex
		return gnvo_app.is_null
	end if
	
	//Obtengo el grupo contable
	select grp_cntbl
		into :ls_grp_cntbl
	from centros_costo cc
	where cc.cencos = :as_cencos;
	
	if SQLCA.SQLCode = 100 then
		rollback;
		ex = create Exception
		ex.setMessage( "Error, el Centro de Costos " + as_cencos + " no existe en la tabla CENTROS_COSTO, por favor verifique!")
		throw ex
		return gnvo_app.is_null
	end if
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		ex = create Exception
		ex.setMessage( "Ha ocurrido un error al consulta la tabla CENTROS_COSTO, Centros Costo: " + as_cencos + &
							"~r~nMensaje de Error: " + ls_mensaje)
		throw ex
		return gnvo_app.is_null
	end if
	
	//si no afecta presupuesto, no busco grupo contable
	select matriz
	  into :ls_matriz
	from tipo_mov_matriz_subcat
	where tipo_mov 	= :as_tipo_mov
	  and grp_cntbl	= :ls_grp_cntbl
	  and cod_sub_cat = :ls_cod_sub_cat
	  and item			= 1;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		rollback;
		ex = create Exception
		ex.setMessage( "Ha ocurrido un error al consulta la tabla TIPO_MOV_MATRIZ_SUBCAT, " &
							+ "~r~nTipo MOV: " + as_tipo_mov &
							+ "~r~nSub Categoria: " + ls_cod_sub_cat &
							+ "~r~nMensaje de Error: " + ls_mensaje)
		throw ex
		return gnvo_app.is_null
	end if
	
	if SQLCA.SQLCode = 100 then
		insert into tipo_mov_matriz_subcat( tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
		values(:as_tipo_mov, :ls_grp_cntbl, :ls_cod_sub_cat, 1, :ls_matriz_vs000);
		
		ls_matriz = ls_matriz_vs000
	end if


end if

return ls_matriz
end function

public subroutine of_update_asientos ();update cntbl_Asiento ca
   set ca.tot_soldeb = (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_soldeb <> (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);
                                                                            
update cntbl_Asiento ca
   set ca.tot_solhab = (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_solhab <> (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);
                           
update cntbl_Asiento ca
   set ca.tot_doldeb = (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_doldeb <> (select nvl(sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);

update cntbl_Asiento ca
   set ca.tot_dolhab = (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento)
where ca.tot_dolhab <> (select nvl(sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)),0)
                          from cntbl_Asiento_det cad 
                         where cad.origen = ca.origen
                           and cad.ano    = ca.ano
                           and cad.mes    = ca.mes
                           and cad.nro_libro = ca.nro_libro
                           and cad.nro_asiento = ca.nro_Asiento);         

commit;

                           
end subroutine

public function str_cnta_cntbl of_cnta_cntbl (string as_cnta_cntbl);String			ls_mensaje
str_cnta_cntbl lstr_return

SELECT flag_ctabco  ,
       flag_cencos  ,
       flag_doc_ref ,
       flag_codrel  ,
		 flag_centro_benef,
		 DESC_CNTA,
		 flag_estado
 INTO  :lstr_return.flag_ctabco,
 		 :lstr_return.flag_cencos,
		 :lstr_return.flag_doc_ref,
 		 :lstr_return.flag_codrel,
		 :lstr_return.flag_centro_benef,
		 :lstr_return.desc_cnta,
		 :lstr_return.flag_estado
 FROM  cntbl_cnta
WHERE cnta_ctbl = :as_cnta_cntbl ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox("SQL error", "Error al consultar tabla  CNTBL_CNTA. Error: " + ls_mensaje)
	lstr_return.b_return = false
	lstr_return.mensaje = ls_mensaje
	return lstr_return
END IF

IF SQLCA.SQLCode = 100 THEN 
	ROLLBACK;
	MessageBox("SQL error", "La Cuenta Contable " + as_cnta_Cntbl + " no existe en el maestro de cuentas contables, por favor verifique")
	
	lstr_return.b_return = false
	lstr_return.mensaje = ls_mensaje
	return lstr_return
END IF

lstr_return.cnta_cntbl 	= as_cnta_cntbl
lstr_return.b_return 	= true

Return lstr_return
end function

public function boolean of_cnta_cntbl (string as_cnta_cntbl, ref str_cnta_cntbl astr_param);astr_param = this.of_cnta_cntbl(as_cnta_cntbl)

Return astr_param.b_return
end function

on n_cst_contabilidad.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_contabilidad.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

