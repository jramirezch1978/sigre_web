$PBExportHeader$n_cst_seguridad_maestro.sru
forward
global type n_cst_seguridad_maestro from nonvisualobject
end type
end forward

global type n_cst_seguridad_maestro from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer of_setpersona (string as_tipdocide, string as_nrodocide, string as_apepat, string as_apemat, string as_nombre, string as_brevete)
public function integer of_getpersona (string as_tipdocide, string as_nrodocide, ref string as_apepat, ref string as_apemat, ref string as_nombre, ref string as_brevete)
public function integer of_setvehiculo (string as_placa, string as_placaremolque, string as_tiporemolque, string as_ruc)
public function integer of_getvehiculo (string as_placa, ref string as_placaremolque, ref string as_tiporemolque, ref string as_desctiporemolque, ref string as_ruc, ref string as_razonsocial)
public function integer of_getproveedor (string as_ruc, ref string as_razonsocial)
public function integer of_setproveedor (string as_ruc, string as_razonsocial)
end prototypes

public function integer of_setpersona (string as_tipdocide, string as_nrodocide, string as_apepat, string as_apemat, string as_nombre, string as_brevete);/*
-1 = error
 0 = no se hizo nada
 1 = ok
*/

if isnull(as_tipdocide) or isnull(as_nrodocide) or isnull(as_apepat) or isnull(as_nombre) then
	return 0
end if

integer li_count

select count(1)
  into :li_count
  from seg_persona 
 where tip_doc_ident = :as_tipdocide and nro_doc_ident = trim(:as_nrodocide);

if gnvo_app.of_existserror(sqlca) then
	return -1
end if

if li_count = 0 then
	
	insert into seg_persona ( tip_doc_ident, nro_doc_ident, apepat, apemat, nombre, nro_brevete )
						  values ( :as_tipdocide, trim(:as_nrodocide), 
						  			  substr(trim(:as_apepat),1,20), substr(trim(:as_apemat),1,20), 
									  substr(trim(:as_nombre),1,40), substr(trim(:as_brevete),1,15));

	if gnvo_app.of_existserror(sqlca) then
		return -1
	end if

else
	
	return 0
	
end if								

return 1
end function

public function integer of_getpersona (string as_tipdocide, string as_nrodocide, ref string as_apepat, ref string as_apemat, ref string as_nombre, ref string as_brevete);/*
-1 = error
 0 = no se hizo nada
 1 = ok
*/

if isnull(as_tipdocide) or isnull(as_nrodocide) then
	return 0
end if

select trim(apepat), trim(apemat), trim(nombre), trim(nro_brevete)
  into :as_apepat, :as_apemat, :as_nombre, :as_brevete
  from seg_persona 
 where tip_doc_ident = :as_tipdocide and nro_doc_ident = trim(:as_nrodocide);

if gnvo_app.of_existserror(sqlca) then
	return -1
end if

if sqlca.sqlcode = 100 then return 0

return 1
end function

public function integer of_setvehiculo (string as_placa, string as_placaremolque, string as_tiporemolque, string as_ruc);/*
-1 = error
 0 = no se hizo nada
 1 = ok
*/

if isnull(as_placa) then
	return 0
end if

integer li_count

select count(1)
  into :li_count
  from seg_vehiculo a
  where placa = trim(:as_placa);

if gnvo_app.of_existserror(sqlca) then
	return -1
end if

if li_count = 0 then
	
	insert into seg_vehiculo ( placa, placa_carreta, tipo_remolque, ruc )
	 				      values ( trim(:as_placa), trim(:as_placaremolque), :as_tiporemolque, :as_ruc );

	if gnvo_app.of_existserror(sqlca) then
		return -1
	end if
	
else
	
	return 0
	
end if

return 1
end function

public function integer of_getvehiculo (string as_placa, ref string as_placaremolque, ref string as_tiporemolque, ref string as_desctiporemolque, ref string as_ruc, ref string as_razonsocial);/*
-1 = error
 0 = no se hizo nada
 1 = ok
*/

if isnull(as_placa) then
	return 0
end if

select trim(a.placa_carreta), a.tipo_remolque, b.DESC_REMOLQUE, a.ruc, c.RAZON_SOCIAL
  into :as_placaremolque, :as_tiporemolque, :as_desctiporemolque, :as_ruc, :as_razonsocial
  from seg_vehiculo a, SEG_TIPO_SEMIREMOLQUE b, SEG_PROVEEDOR c
  where placa = trim(:as_placa)
    and a.tipo_remolque = b.tipo_remolque (+)
    and a.ruc = c.ruc (+) ;

if gnvo_app.of_existserror(sqlca) then
	return -1
end if

if sqlca.sqlcode = 100 then return 0

return 1
end function

public function integer of_getproveedor (string as_ruc, ref string as_razonsocial);/*
-1 = error
 0 = no se hizo nada
 1 = ok
*/

if isnull(as_ruc) then
	return 0
end if

select trim(a.razon_social)
  into :as_razonsocial
  from seg_proveedor a
  where ruc = :as_ruc;

if gnvo_app.of_existserror(sqlca) then
	return -1
end if

if sqlca.sqlcode = 100 then return 0

return 1
end function

public function integer of_setproveedor (string as_ruc, string as_razonsocial);/*
-1 = error
 0 = no se hizo nada
 1 = ok
*/

if isnull(as_ruc) or isnull(as_razonsocial) then
	return 0
end if

integer li_count

select count(1)
  into :li_count
  from seg_proveedor a
  where ruc = :as_ruc;

if gnvo_app.of_existserror(sqlca) then
	return -1
end if

if li_count = 0 then
	
	insert into seg_proveedor ( ruc, razon_social )
	 				      values ( :as_ruc, trim(:as_razonsocial) );

	if gnvo_app.of_existserror(sqlca) then
		return -1
	end if
	
else
	
	return 0
	
end if

return 1
end function

on n_cst_seguridad_maestro.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_seguridad_maestro.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

