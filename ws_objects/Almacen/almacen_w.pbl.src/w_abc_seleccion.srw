$PBExportHeader$w_abc_seleccion.srw
forward
global type w_abc_seleccion from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion
end type
type uo_search from n_cst_search within w_abc_seleccion
end type
end forward

global type w_abc_seleccion from w_abc_list
integer width = 4009
integer height = 1948
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion w_abc_seleccion

type variables
String  	is_col = '', is_tipo, is_type, is_tipo_alm, &
			is_oper_cons_int, is_almacen, is_opcion
Date 		id_fecha
Double 	in_tipo_cambio
Long		il_opcion
str_parametros 		ist_datos
str_mov_art_consig 	ist_mov_consig
n_Cst_wait				invo_wait
end variables

forward prototypes
public function double wf_verifica_factor (string as_tipo_mov)
public function boolean of_art_consig ()
public function boolean of_consig_cons_interno ()
public function boolean of_verifica_articulo (string as_articulo, string as_almacen)
public function boolean of_opcion9 ()
public function boolean of_opcion10 ()
public function boolean of_opcion11 ()
public function decimal of_costo_prom_articulo (string as_cod_art, string as_almacen)
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
public function boolean of_ver_ing_prod (string as_articulo, string as_almacen, ref decimal adc_costo_prod)
public function boolean of_opcion12 ()
public function boolean of_opcion13 ()
public function boolean of_opcion14 ()
public function boolean of_opcion15 ()
public function boolean of_opcion16 ()
public function boolean of_opcion17 ()
public function boolean of_opcion18 ()
public function boolean of_opcion19 ()
end prototypes

public function double wf_verifica_factor (string as_tipo_mov);Double ld_factor

SELECT factor_sldo_total
  INTO :ld_factor   
  FROM articulo_mov_tipo
 WHERE tipo_mov = :as_tipo_mov ;
 
 Return ld_factor
end function

public function boolean of_art_consig ();decimal ldc_cantidad, ldc_cant_liq, ldc_cant_sol
long ll_row
u_dw_abc ldw_master

ldw_master = ist_datos.dw_m

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun articulo', StopSign!)
	return false
end if

ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe ningun vale de salida en dw_master')
	return false
end if

ldc_cant_sol = ldw_master.object.cantidad[ll_row]
ldc_cantidad = dec(dw_2.object.cantidad[1])
ldc_cant_liq = dec(dw_2.object.cantidad_liq[1])

If IsNull(ldc_cant_liq) then ldc_cant_liq = 0

if ldc_cantidad - ldc_cant_liq <= 0 then
	MessageBox('Aviso', 'No hay cantidad consignada disponible' )
	return false
end if

if ldc_cant_sol > ldc_cantidad - ldc_cant_liq then
	MessageBox('Aviso', 'No hay cantidad solicitada excede al saldo disponible' )
	ldc_cant_sol = ldc_cantidad - ldc_cant_liq
end if

ldw_master.object.cod_art			[ll_row] = dw_2.object.cod_art			[1]
ldw_master.object.desc_art			[ll_row] = dw_2.object.desc_art			[1]
ldw_master.object.proveedor		[ll_row] = dw_2.object.proveedor	 		[1]
ldw_master.object.nom_proveedor	[ll_row] = dw_2.object.nom_proveedor	[1]
ldw_master.object.precio_unitario[ll_row] = dw_2.object.precio_unitario	[1]
ldw_master.object.cantidad			[ll_row] = ldc_cant_sol
ldw_master.object.cantidad_liq	[ll_row] = ldc_cant_sol
ldw_master.object.cod_moneda		[ll_row] = dw_2.object.cod_moneda[1]
ldw_master.object.desc_moneda		[ll_row] = dw_2.object.desc_moneda[1]
ldw_master.ii_update = 1

ist_mov_consig.nro_mov			= dw_2.object.nro_mov	[1]
ist_mov_consig.tipo_mov			= dw_2.object.tipo_mov	[1]
ist_mov_consig.cod_art			= dw_2.object.cod_art	[1]
ist_mov_consig.desc_art			= dw_2.object.desc_art	[1]
ist_mov_consig.proveedor 		= dw_2.object.proveedor[1]
ist_mov_consig.nom_proveedor 	= dw_2.object.nom_proveedor[1]
ist_mov_consig.cod_moneda		= dw_2.object.cod_moneda[1]
ist_mov_consig.cantidad			= ldc_cantidad
ist_mov_consig.cantidad_liq 	= ldc_cant_liq
ist_mov_consig.cantidad_sol	= ldc_cant_sol


return true

end function

public function boolean of_consig_cons_interno ();long ll_row
u_dw_abc ldw_master
string	ls_cod_maquina, ls_nro_doc, ls_tipo_doc, ls_doc_ot

ldw_master = ist_datos.dw_m

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun articulo', StopSign!)
	return false
end if

ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe ningun vale de salida en dw_master')
	return false
end if

SetNull(ls_cod_maquina)

select doc_ot
	into :ls_doc_ot
from logparam
where reckey = '1';

if ls_doc_ot = dw_2.object.tipo_doc[1] then
	ls_nro_doc = dw_2.object.tipo_doc[1]
	
	select cod_maquina
		into :ls_cod_maquina
	from orden_trabajo
	where nro_orden = :ls_nro_doc;
	
end if

ldw_master.object.cod_art  [ll_row] = dw_2.object.cod_art[1]
ldw_master.object.desc_art [ll_row] = dw_2.object.desc_art[1]
ldw_master.object.cantidad	[ll_row] = Dec(dw_2.object.cantidad[1])

ist_datos.string1		  = dw_2.object.oper_sec	[1]
ist_datos.long1		  = Long(dw_2.object.nro_mov[1])
ist_datos.string2 	  = dw_2.object.cod_origen	[1]

ist_datos.field_ret[1] = dw_2.object.cencos		[1]
ist_datos.field_ret[2] = dw_2.object.cnta_prsp	[1]
ist_datos.field_ret[3] = ls_cod_maquina
ist_datos.tipo_doc	  = dw_2.object.tipo_doc	[1]
ist_datos.nro_doc	  	  = dw_2.object.nro_doc		[1]
ist_datos.origen_doc	  = string(dw_2.object.cod_origen[1])

return true

end function

public function boolean of_verifica_articulo (string as_articulo, string as_almacen);// Esta funcion te verifica si el articulo existe,
// si es inventariable y sobre todo si tiene saldo

String 	ls_tipo_mov, ls_und2
decimal 	ldc_prom_sol, ldc_prom_dol, ldc_saldo_total = 0
Long		ll_row
Integer	li_saldo_total
u_dw_abc ldw_master

ldw_master = ist_datos.dw_or_m  //Es la cabecera del Mov de Almacen
ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe la cabecera del Mov de almacen')
	return false
end if

// Verifica que codigo ingresado exista			
Select costo_prom_sol, costo_prom_dol
	into :ldc_prom_sol, :ldc_prom_dol 
from articulo_almacen
Where cod_art = :as_articulo
  and almacen = :as_almacen;

if Sqlca.sqlcode = 100 then 
	Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
		+ " no existe, no esta activo o no es inventariable", StopSign!)
	Return false
end if		

ls_tipo_mov = ldw_master.object.tipo_mov[ll_row]
if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento esta en blanco')
	return false
end if

select factor_sldo_total
	into :li_saldo_total
from 	articulo_mov_tipo 
where tipo_mov = :ls_tipo_mov
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Tipo de movimiento de almacen no existe o no esta activo')
	return false
end if

// Valido si existe saldo en almacen si en una salida de almacen

if li_saldo_total = -1 then
	SELECT Nvl(sldo_total,0)
		INTO :ldc_saldo_total  
	FROM   articulo_almacen
	WHERE  almacen = :as_almacen 
	  AND cod_art = :as_articulo ; 		
			
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe Articulo '+ as_articulo + ' en almacen indicado')
	end if
end if

return true
end function

public function boolean of_opcion9 ();// Ingreso x devolucion de un proveedor
long ll_row
u_dw_abc ldw_master


ldw_master = ist_datos.dw_m

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun articulo', StopSign!)
	return false
end if

ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe ningun vale de salida en dw_master')
	return false
end if

ldw_master.object.cod_art  		[ll_row] = dw_2.object.cod_art		[1]
ldw_master.object.desc_art 		[ll_row] = dw_2.object.desc_art		[1]
ldw_master.object.cant_ingreso	[ll_row] = dw_2.object.cantidad		[1]
ldw_master.object.cant_salida		[ll_row] = dw_2.object.cant_salida	[1]
ldw_master.object.proveedor		[ll_row] = dw_2.object.proveedor		[1]
ldw_master.object.nom_proveedor	[ll_row] = dw_2.object.nom_proveedor[1]
ldw_master.object.origen_refer	[ll_row] = dw_2.object.origen_refer [1]
ldw_master.object.tipo_refer		[ll_row] = dw_2.object.tipo_refer 	[1]
ldw_master.object.nro_refer		[ll_row] = dw_2.object.nro_refer 	[1]
ldw_master.object.centro_benef	[ll_row] = dw_2.object.centro_benef	[1]
ldw_master.object.precio_unit		[ll_row] = dw_2.object.precio_unit 	[1]
ldw_master.object.fec_esp_ret		[ll_row] = Date(f_fecha_actual())

ldw_master.ii_update = 1

ist_mov_consig.nro_mov			= dw_2.object.nro_mov		[1]
ist_mov_consig.tipo_mov			= dw_2.object.tipo_mov		[1]
ist_mov_consig.cod_art			= dw_2.object.cod_art		[1]
ist_mov_consig.desc_art			= dw_2.object.desc_art		[1]
ist_mov_consig.proveedor 		= dw_2.object.proveedor  	[1]
ist_mov_consig.nom_proveedor 	= dw_2.object.nom_proveedor[1]
ist_mov_consig.cantidad			= Dec(dw_2.object.cantidad	[1])

return true

end function

public function boolean of_opcion10 ();long ll_row
u_dw_abc ldw_master


ldw_master = ist_datos.dw_m

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun articulo', StopSign!)
	return false
end if

ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe ningun vale de salida en dw_master')
	return false
end if

ldw_master.object.cod_art  		[ll_row] = dw_2.object.cod_art		[1]
ldw_master.object.desc_art 		[ll_row] = dw_2.object.desc_art		[1]
ldw_master.object.cant_ingreso	[ll_row] = dw_2.object.cantidad		[1]
ldw_master.object.cant_salida		[ll_row] = dw_2.object.cant_salida	[1]
ldw_master.object.proveedor		[ll_row] = dw_2.object.proveedor		[1]
ldw_master.object.nom_proveedor	[ll_row] = dw_2.object.nom_proveedor[1]
ldw_master.object.centro_benef	[ll_row] = dw_2.object.centro_benef	[1]
ldw_master.object.precio_unit		[ll_row] = dw_2.object.precio_unit	[1]
ldw_master.ii_update = 1

ist_mov_consig.nro_mov			= dw_2.object.nro_mov		[1]
ist_mov_consig.tipo_mov			= dw_2.object.tipo_mov		[1]
ist_mov_consig.cod_art			= dw_2.object.cod_art		[1]
ist_mov_consig.desc_art			= dw_2.object.desc_art		[1]
ist_mov_consig.proveedor 		= dw_2.object.proveedor  	[1]
ist_mov_consig.nom_proveedor 	= dw_2.object.nom_proveedor[1]
ist_mov_consig.cantidad			= Dec(dw_2.object.cantidad	[1])

return true

end function

public function boolean of_opcion11 ();decimal ldc_cantidad, ldc_cant_liq, ldc_cant_sol
long ll_row
u_dw_abc ldw_master

ldw_master = ist_datos.dw_m

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun articulo', StopSign!)
	return false
end if

ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe ningun vale de salida en dw_master')
	return false
end if

ldc_cant_sol = ldw_master.object.cantidad[ll_row]
ldc_cantidad = dec(dw_2.object.cantidad[1])
ldc_cant_liq = dec(dw_2.object.cantidad_liq[1])

If IsNull(ldc_cant_liq) then ldc_cant_liq = 0

if ldc_cantidad - ldc_cant_liq <= 0 then
	MessageBox('Aviso', 'No hay cantidad consignada disponible' )
	return false
end if

if ldc_cant_sol > ldc_cantidad - ldc_cant_liq then
	MessageBox('Aviso', 'No hay cantidad solicitada excede al saldo disponible' )
	ldc_cant_sol = ldc_cantidad - ldc_cant_liq
end if

ldw_master.object.cod_art			[ll_row] = dw_2.object.cod_art			[1]
ldw_master.object.desc_art			[ll_row] = dw_2.object.desc_art			[1]
ldw_master.object.proveedor		[ll_row] = dw_2.object.proveedor	 		[1]
ldw_master.object.nom_proveedor	[ll_row] = dw_2.object.nom_proveedor	[1]
ldw_master.object.precio_unitario[ll_row] = dw_2.object.precio_unitario	[1]
ldw_master.object.cantidad			[ll_row] = ldc_cant_sol
ldw_master.object.cantidad_liq	[ll_row] = ldc_cant_sol
ldw_master.object.cod_moneda		[ll_row] = dw_2.object.cod_moneda[1]
ldw_master.object.desc_moneda		[ll_row] = dw_2.object.desc_moneda[1]
ldw_master.ii_update = 1

ist_mov_consig.nro_mov			= dw_2.object.nro_mov	[1]
ist_mov_consig.tipo_mov			= dw_2.object.tipo_mov	[1]
ist_mov_consig.cod_art			= dw_2.object.cod_art	[1]
ist_mov_consig.desc_art			= dw_2.object.desc_art	[1]
ist_mov_consig.proveedor 		= dw_2.object.proveedor[1]
ist_mov_consig.nom_proveedor 	= dw_2.object.nom_proveedor[1]
ist_mov_consig.cod_moneda		= dw_2.object.cod_moneda[1]
ist_mov_consig.cantidad			= ldc_cantidad
ist_mov_consig.cantidad_liq 	= ldc_cant_liq
ist_mov_consig.cantidad_sol	= ldc_cant_sol


return true

end function

public function decimal of_costo_prom_articulo (string as_cod_art, string as_almacen);Decimal ldc_costo_prom

Select NVL(costo_prom_sol,0)
	into :ldc_costo_prom 
from articulo_almacen
Where cod_art = :as_cod_art
  and almacen = :as_almacen;	

if SQLCA.SQLCode = 100 then
	Select NVL(costo_prom_sol,0)
		into :ldc_costo_prom 
	from articulo_almacen
	Where cod_art = :as_cod_art;
end if

if IsNull(ldc_costo_prom) then ldc_costo_prom = 0

return ldc_costo_prom
end function

public function boolean of_opcion1 ();// Solo para consumos internos 
Long   	ll_j, ll_row
String 	ls_tipo_mov, ls_almacen, ls_nro_ot, ls_doc_ot, ls_cod_maq
Decimal	ldc_saldo_und2
u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_or_d	// detail
ldw_master = ist_datos.dw_or_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return false

ls_almacen  = ldw_master.Object.Almacen 				[ll_row]
	 
select doc_ot
	into :ls_doc_ot
from logparam
where reckey = '1';
		
if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LOGPARAM', StopSign!)
	return false
end if
		
if ls_doc_ot = '' or IsNull(ls_doc_ot) then
	MessageBox('Aviso', 'No ha definido DOC_OT en parametros LOGPARAM')
	return false
end if

FOR ll_j = 1 TO dw_2.RowCount()								
			
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
		ldw_master.ii_update = 1	
		ldw_detail.ii_update = 1
				
		ldw_detail.Object.origen_mov_proy [ll_row] = dw_2.Object.cod_origen					[ll_j]
		ldw_detail.Object.nro_mov_proy 	 [ll_row] = dw_2.Object.nro_mov 						[ll_j]
		ldw_detail.Object.flag_estado  	 [ll_row] = '1'								
		ldw_detail.Object.cod_art      	 [ll_row] = dw_2.Object.cod_art						[ll_j]
		ldw_detail.Object.cant_procesada  [ll_row] = dw_2.object.cantidad						[ll_j]
		ldw_detail.Object.precio_unit  	 [ll_row] = dw_2.object.precio						[ll_j]  
		ldw_detail.Object.cod_moneda		 [ll_row] = gnvo_app.is_soles
		ldw_detail.Object.cencos			 [ll_row] = dw_2.Object.cencos						[ll_j]
		ldw_detail.Object.cnta_prsp 		 [ll_row] = dw_2.Object.cnta_prsp					[ll_j]
		ldw_detail.Object.desc_art 		 [ll_row] = dw_2.Object.desc_art 					[ll_j]
		ldw_detail.Object.und				 [ll_row] = dw_2.Object.und							[ll_j]
		ldw_detail.object.matriz			 [ll_row] = dw_2.Object.matriz						[ll_j] 
		ldw_detail.object.oper_sec			 [ll_row] = dw_2.object.oper_sec	   				[ll_j]
		ldw_detail.object.und2				 [ll_row] = dw_2.object.und2		   				[ll_j]
		ldw_detail.object.flag_und2		 [ll_row] = dw_2.object.flag_und2					[ll_j]
		ldw_detail.object.flag_cntrl_lote [ll_row] = dw_2.object.flag_cntrl_lote 			[ll_j]
		ldw_detail.object.flag_saldo_libre[ll_row] = dw_2.object.flag_saldo_libre			[ll_j]
		ldw_detail.object.factor_conv_und [ll_row] = dw_2.object.factor_conv_und 			[ll_j]
		ldw_detail.object.centro_benef 	 [ll_row] = dw_2.object.centro_benef 	 			[ll_j]
		ldw_detail.object.nro_reservacion [ll_row] = dw_2.object.nro_reservacion 			[ll_j]
		ldw_detail.object.item_reservacion[ll_row] = Long(dw_2.object.item_reservacion	[ll_j])
		
		//Referencia a lote, pallet y ubicacion
		ldw_detail.object.nro_lote			 [ll_row] = dw_2.object.nro_lote 					[ll_j]
		ldw_detail.object.nro_pallet		 [ll_row] = dw_2.object.nro_pallet					[ll_j]
		ldw_detail.object.anaquel			 [ll_row] = dw_2.object.anaquel 						[ll_j]
		ldw_detail.object.fila			 	 [ll_row] = dw_2.object.fila 	 						[ll_j]
		ldw_detail.object.columna			 [ll_row] = dw_2.object.columna 						[ll_j]
		ldw_detail.object.cus				 [ll_row] = dw_2.object.cus 							[ll_j]
		
		ldw_detail.Object.cant_proc_und2  [ll_row] = Dec(dw_2.object.cantidad_und2 		[ll_j])
		
		if dw_2.object.tipo_doc[ll_j] = ls_doc_ot then
			ls_nro_ot = dw_2.object.nro_doc[ll_j]
			
			select cod_maquina 
				into :ls_cod_maq
			from orden_trabajo
			where nro_orden = :ls_nro_ot;
					
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Orden de Trabajo ' + ls_nro_ot + ' no existe, por favor verifique', StopSign!)
			else
				ldw_detail.object.cod_maquina [ll_row] = ls_cod_maq
			end if
			
			
			
		end if
		ldw_detail.Modify("cant_proc_und2.Protect ='1~tIf(IsNull(flag_und2),1,0)'")
		ldw_detail.Modify("cant_proc_und2.background.color ='1~tIf(IsNull(flag_und2), RGB(192,192,192), RGB(255,255,255) )'")
		
		of_verifica_articulo( dw_2.Object.cod_art[ll_j], ls_almacen) 
	END IF					
NEXT				
return true

end function

public function boolean of_opcion2 ();// Solo para consumos internos 
Long   	ll_j, ll_row
String 	ls_tipo_mov, ls_almacen, ls_nro_ot, &
			ls_doc_ot, ls_cod_maq
decimal	ldc_precio_unit			
u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_or_d	// detail
ldw_master = ist_datos.dw_or_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return false

ls_almacen  = ldw_master.Object.Almacen 				[ll_row]
	 
select doc_ot
	into :ls_doc_ot
from logparam
where reckey = '1';
		
if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LOGPARAM', StopSign!)
	return false
end if
		
if ls_doc_ot = '' or IsNull(ls_doc_ot) then
	MessageBox('Aviso', 'No ha definido DOC_OT en parametros LOGPARAM')
	return false
end if

FOR ll_j = 1 TO dw_2.RowCount()								
			
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
		ldw_master.ii_update = 1	
		ldw_detail.ii_update = 1
				
		ldw_detail.Object.origen_mov_proy [ll_row] = dw_2.Object.cod_origen	[ll_j]
		ldw_detail.Object.nro_mov_proy 	 [ll_row] = dw_2.Object.nro_mov 		[ll_j]
		ldw_detail.Object.flag_estado  	 [ll_row] = '1'								
		ldw_detail.Object.cod_art      	 [ll_row] = dw_2.Object.cod_art		[ll_j]
		ldw_detail.Object.cant_procesada  [ll_row] = dw_2.object.cantidad		[ll_j]
		ldw_detail.Object.cod_moneda		 [ll_row] = gnvo_app.is_soles 
		ldw_detail.Object.cencos			 [ll_row] = dw_2.Object.cencos		[ll_j]
		ldw_detail.Object.cnta_prsp 		 [ll_row] = dw_2.Object.cnta_prsp	[ll_j]
		ldw_detail.Object.desc_art 		 [ll_row] = dw_2.Object.desc_art 	[ll_j]
		ldw_detail.Object.und				 [ll_row] = dw_2.Object.und			[ll_j]
		ldw_detail.object.oper_sec			 [ll_row] = dw_2.object.oper_sec	   [ll_j]
		ldw_detail.object.und2				 [ll_row] = dw_2.object.und2		   [ll_j]
		ldw_detail.object.flag_und2		 [ll_row] = dw_2.object.flag_und2	[ll_j]
		ldw_detail.object.flag_cntrl_lote [ll_row] = dw_2.object.flag_cntrl_lote [ll_j]
		ldw_detail.object.factor_conv_und [ll_row] = dw_2.object.factor_conv_und[ll_j]
		ldw_detail.object.centro_benef 	 [ll_row] = dw_2.object.centro_benef [ll_j]
				
		if dw_2.object.tipo_doc[ll_j] = ls_doc_ot then
			ls_nro_ot = dw_2.object.nro_doc[ll_j]
			
			select cod_maquina 
				into :ls_cod_maq
			from orden_trabajo
			where nro_orden = :ls_nro_ot;
					
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Orden de Trabajo ' + ls_nro_ot + ' no existe')
			else
				ldw_detail.object.cod_maquina [ll_row] = ls_cod_maq
			end if
		end if
		ldw_detail.Modify("cant_proc_und2.Protect ='1~tIf(IsNull(flag_und2),1,0)'")
		ldw_detail.Modify("cant_proc_und2.background.color ='1~tIf(IsNull(flag_und2), RGB(192,192,192), RGB(255,255,255) )'")
		
	END IF					
	
	if dw_2.object.flag_und2	[ll_j] = '1' then
		ldw_detail.Object.cant_proc_und2  [ll_row] = dw_2.object.cantidad	[ll_j] * dw_2.object.factor_conv_und	[ll_j]
	end if
	
	if of_ver_ing_prod( dw_2.Object.cod_art[ll_j], ls_almacen, ldc_precio_unit)= true then
		ldw_detail.object.precio_unit [ll_row] = ldc_precio_unit
	end if

NEXT				
return true

end function

public function boolean of_ver_ing_prod (string as_articulo, string as_almacen, ref decimal adc_costo_prod);// Esta funcion te verifica si el articulo existe,
// si es inventariable y sobre todo si tiene saldo
// En caso de un Ingreso por produccion tambien 
// Coloca el precio de Ingreso por producción

String 	ls_tipo_mov, ls_und2
decimal 	ldc_saldo_total
Long		ll_row, ll_count
Integer 	li_factor_sldo_total
Date		ld_fecha
u_dw_abc ldw_master

ldw_master = ist_datos.dw_or_m  //Es la cabecera del Mov de Almacen
ll_row = ldw_master.GetRow()
if ll_row = 0 then
	MessageBox('Aviso', 'No existe la cabecera del Mov de almacen')
	return false
end if

ld_fecha 	= Date(ldw_master.object.fec_registro[ll_row])

// Obtengo el costo de produccion de la tabla
// prod_costos_diarios
select usf_fl_conv_mon(costo_produccion, cod_moneda, :gnvo_app.is_soles, fecha)
  into :adc_costo_prod
  from prod_costos_diarios
 where cod_art = :as_articulo
   and almacen = :as_almacen
	and trunc(fecha) = Trunc(:ld_fecha);

if Sqlca.sqlcode = 100 then 
	select usf_fl_conv_mon(costo_produccion, cod_moneda, :gnvo_app.is_soles, :ld_fecha)
	  into :adc_costo_prod
	  from (	select costo_produccion, cod_moneda
				  from prod_costos_diarios
				 where cod_art = :as_articulo
					and almacen = :as_almacen
				order by fecha desc)
		where rownum = 1;

	if SQLCA.SQLCode = 100 then
		Messagebox( "Atencion", "Codigo de articulo: '" + as_articulo &
			+ " no existe en la tabla PROD_COSTOS_DIARIOS para obtener su costo de producción", StopSign!)
		Return false
	end if
end if		

//Ahora verifico si tiene saldo en almacen
ls_tipo_mov = ldw_master.object.tipo_mov[ll_row]
if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento esta en blanco')
	return false
end if

select factor_sldo_total
	into :li_factor_sldo_total
from 	articulo_mov_tipo 
where tipo_mov = :ls_tipo_mov
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Tipo de movimiento de almacen no existe o no esta activo')
	return false
end if

// Valido si existe saldo en almacen si en una salida de almacen

if li_factor_sldo_total = -1 then
	SELECT Nvl(sldo_total,0)
		INTO :ldc_saldo_total  
	FROM   articulo_almacen
	WHERE  almacen = :as_almacen 
	  AND cod_art = :as_articulo ; 		
			
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe Articulo '+ as_articulo + ' en almacen indicado')
	end if
end if

return true
end function

public function boolean of_opcion12 ();Long		ll_row
String	ls_codigo, ls_mensaje
delete from tt_pto_cencos;

FOR ll_row = 1 to dw_2.rowcount()
	ls_codigo = dw_2.object.cencos	[ll_row]
	
	// Llena tabla temporal con el centro de costo y todas las cuentas
	// presupuestales que tenga segun indicadores
	insert into tt_pto_cencos(cencos) 
	  values (:ls_codigo);
	  
	IF SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'No se pudo insertar fila en tt_pto_cencos: ' + ls_mensaje)
		return false
	end if
NEXT
commit;

return true

end function

public function boolean of_opcion13 ();Long 		ll_row, ll_nro_am, ll_nro_mov_proy
string	ls_org_am, ls_codigo_cu, ls_nro_pallet, ls_nro_lote, ls_mensaje, &
			ls_org_mov_proy, ls_nro_vale, ls_Cod_art, ls_oper_sec, ls_sql, &
			ls_anaquel, ls_fila, ls_columna, ls_nro_doc, ls_tipo_doc, ls_nro_otr, &
			ls_tipo_doc_otr
			
Decimal	ldc_cant_procesada, ldc_cant_proc_und2, ldc_cant_proyect		
u_ds_base	lds_lista

try 
	
	
	ll_nro_am = ist_datos.long1
	ls_org_am = ist_datos.string3
	
	lds_lista = create u_ds_base
	lds_lista.DataObject = 'd_lista_articulo_mov_tbl'
	lds_lista.setTransobject( SQLCA )
	
	lds_lista.Retrieve(ls_org_am, ll_nro_am)
	
	if lds_lista.rowCount() = 0 then
		gnvo_app.of_mensaje_error( "No hay registros para poder depurar en lds_lista")
		return false
	end if
	
	//Apago el trigger;
//	ls_sql = 'ALTER TABLE articulo_mov DISABLE ALL TRIGGERS'
//	execute immediate :ls_sql;
//	
//	if SQLCA.SQLCode = -1 then
//		ls_mensaje = SQLCa.SQLErrText
//		rollback;
//		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
//		return false
//	end if

	ls_org_mov_proy 	= lds_lista.object.origen_mov_proy	[1]
	ll_nro_mov_proy 	= Long(lds_lista.object.nro_mov_proy[1])
	
	ls_nro_vale	 		= lds_lista.object.nro_vale			[1]
	ls_cod_art	 		= lds_lista.object.cod_art				[1]
	ls_oper_sec	 		= lds_lista.object.oper_sec			[1]
	
	//Obtengo la cantidad procesada
	ldc_cant_procesada = 0
	FOR ll_row = 1 to dw_2.rowcount()
		ldc_cant_procesada	+= Dec(dw_2.object.saldo			[ll_row])
	next
	
	//Obtengo la cant proyectada
	select amp.nro_doc, amp.tipo_doc, nvl(sum(amp.cant_proyect), 0)
		into :ls_nro_otr, :ls_tipo_doc_otr, :ldc_cant_proyect
		from articulo_mov_proy amp
	where amp.cod_origen = :ls_org_mov_proy
	  and amp.nro_mov		= :ll_nro_mov_proy
	group by amp.nro_doc, amp.tipo_doc;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al consultar en tabla articulo_mov_proy. Mensaje: " + ls_mensaje)
		return false
	end if
	
	
	if ldc_cant_proyect < ldc_cant_procesada then
		update articulo_mov_proy amp
			set amp.cant_proyect = :ldc_Cant_procesada,
				 amp.flag_estado 	= '1',
				 amp.flag_modificacion = '1'
		 where amp.tipo_doc 	= :ls_tipo_doc_otr
	      and amp.nro_doc	= :ls_nro_otr;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCa.SQLErrText
			rollback;
			gnvo_app.of_mensaje_error( "Error al actualizar tabla articulo_mov_proy. Mensaje: " + ls_mensaje)
			return false
		end if
	end if

	//Actualizo la cantidad procesada e ingresada en cero

	update articulo_mov_proy amp
	   set amp.cant_facturada = 0
	where amp.cod_origen = :ls_org_mov_proy
	  and amp.nro_mov		= :ll_nro_mov_proy;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al ejecutar al actualizar articulo_mov_proy: " + ls_mensaje)
		return false
	end if
	
	//Elimino el item innecesario
	delete articulo_mov am
	where am.cod_origen 	= :ls_org_am
	  and am.nro_mov		= :ll_nro_am;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al eliminar en articulo_mov. Mensaje: " + ls_mensaje)
		return false
	end if
	
	//Actualizo la cantidad procesada e ingresada en cero
	update articulo_mov_proy amp
	   set amp.cant_procesada = 0
	where amp.cod_origen = :ls_org_mov_proy
	  and amp.nro_mov		= :ll_nro_mov_proy;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCa.SQLErrText
		rollback;
		gnvo_app.of_mensaje_error( "Error al eliminar en articulo_mov_proy. Mensaje: " + ls_mensaje)
		return false
	end if
	  
	//Activo el trigger
//	ls_sql = 'ALTER TABLE articulo_mov ENABLE ALL TRIGGERS'
//	execute immediate :ls_sql;
//	
//	if SQLCA.SQLCode = -1 then
//		ls_mensaje = SQLCa.SQLErrText
//		rollback;
//		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
//		return false
//	end if
	
	
	FOR ll_row = 1 to dw_2.rowcount()
		invo_wait.of_mensaje( "Procesando registro " + string(ll_row) + " de " + string(dw_2.RowCount()))
		
		ls_codigo_cu 			= dw_2.object.cus					[ll_row]
		ls_nro_pallet			= dw_2.object.nro_pallet		[ll_row]
		ls_nro_lote				= dw_2.object.nro_lote			[ll_row]
		
		ls_anaquel				= dw_2.object.anaquel			[ll_row]
		ls_fila					= dw_2.object.fila				[ll_row]
		ls_columna				= dw_2.object.columna			[ll_row]
		
		ldc_cant_procesada	= Dec(dw_2.object.saldo			[ll_row])
		ldc_cant_proc_und2	= Dec(dw_2.object.saldo_und2	[ll_row])
	
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCa.SQLErrText
			rollback;
			gnvo_app.of_mensaje_error( "Error al eliminar item en articulo_mov: " + ls_mensaje)
			return false
		end if
		
		
		
		
		
		insert into articulo_mov(
       	cod_origen, origen_mov_proy, nro_mov_proy, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit,
       	decuento, impuesto, cod_moneda, nro_lote, oper_sec, cant_proc_und2, cus, nro_pallet,
			 anaquel, fila, columna)
		values(
			:ls_org_am, :ls_org_mov_proy, :ll_nro_mov_proy, :ls_nro_vale, '1', :ls_cod_art, :ldc_cant_procesada, 0.00,
			0.00, 0.00, :gnvo_app.is_soles, :ls_nro_lote, :ls_oper_sec, :ldc_cant_proc_und2, :ls_codigo_cu, :ls_nro_pallet,
			:ls_anaquel, :ls_fila, :ls_columna);
			
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCa.SQLErrText
			rollback;
			gnvo_app.of_mensaje_error( "Error al insertar item en articulo_mov: " + ls_mensaje)
			return false
		end if
		
		
	NEXT
	
	commit;
	
	return true
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')

finally
	destroy lds_lista
	
//	ls_sql = 'ALTER TABLE articulo_mov ENABLE ALL TRIGGERS'
//	execute immediate :ls_sql;
//	
//	if SQLCA.SQLCode = -1 then
//		ls_mensaje = SQLCa.SQLErrText
//		rollback;
//		gnvo_app.of_mensaje_error( "Error al ejecutar la sentencia " + ls_sql + ": " + ls_mensaje)
//		return false
//	end if
	
	invo_wait.of_close()
	
end try


end function

public function boolean of_opcion14 ();Long 			ll_row
u_dw_abc		ldw_master



try 
		
	if dw_2.RowCount() > 1 then 
		MessageBox('Error', 'Solo puede seleccionar una orden de Venta', StopSign!)
		return false
	end if
	
	ldw_master = ist_datos.dw_m
	
	FOR ll_row = 1 to dw_2.rowcount()
		
		invo_wait.of_mensaje( "Procesando registro " + string(ll_row) + " de " + string(dw_2.RowCount()))
		
		ldw_master.object.origen_refer[1]		= dw_2.object.cod_origen	[ll_row]
		ldw_master.object.tipo_refer	[1]		= dw_2.object.tipo_doc		[ll_row]
		ldw_master.object.nro_refer	[1]		= dw_2.object.nro_ov			[ll_row]
		ldw_master.object.cliente		[1]		= dw_2.object.cliente		[ll_row]
		ldw_master.object.nom_cliente	[1]		= dw_2.object.nom_proveedor[ll_row]
		
		
	NEXT
	
	commit;
	
	return true
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error')

finally

	
	invo_wait.of_close()
	
end try


end function

public function boolean of_opcion15 ();// Solo para consumos internos 
Long   	ll_j, ll_row
String 	ls_tipo_mov
Decimal	ldc_saldo_und2
u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_or_d	// detail
ldw_master = ist_datos.dw_or_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return false

 

FOR ll_j = 1 TO dw_2.RowCount()								
			
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
		ldw_master.ii_update = 1	
		ldw_detail.ii_update = 1
				
		ldw_detail.Object.flag_estado  	 [ll_row] = '1'								
		ldw_detail.Object.cod_art      	 [ll_row] = dw_2.Object.cod_art						[ll_j]
		ldw_detail.Object.cant_procesada  [ll_row] = Dec(dw_2.object.saldo					[ll_j])
		ldw_detail.Object.precio_unit  	 [ll_row] = 0.00
		ldw_detail.Object.cod_moneda		 [ll_row] = gnvo_app.is_soles 
		ldw_detail.Object.desc_art 		 [ll_row] = dw_2.Object.desc_art 					[ll_j]
		ldw_detail.Object.und				 [ll_row] = dw_2.Object.und							[ll_j]
		ldw_detail.object.und2				 [ll_row] = dw_2.object.und2		   				[ll_j]
		ldw_detail.object.flag_und2		 [ll_row] = dw_2.object.flag_und2					[ll_j]
		ldw_detail.object.flag_cntrl_lote [ll_row] = dw_2.object.flag_cntrl_lote 			[ll_j]
		ldw_detail.object.factor_conv_und [ll_row] = dw_2.object.factor_conv_und 			[ll_j]
		
		//Referencia a lote, pallet y ubicacion
		ldw_detail.object.nro_lote			 [ll_row] = dw_2.object.nro_lote 					[ll_j]
		ldw_detail.object.nro_pallet		 [ll_row] = dw_2.object.nro_pallet					[ll_j]
		ldw_detail.object.anaquel			 [ll_row] = dw_2.object.anaquel 						[ll_j]
		ldw_detail.object.fila			 	 [ll_row] = dw_2.object.fila 	 						[ll_j]
		ldw_detail.object.columna			 [ll_row] = dw_2.object.columna 						[ll_j]
		ldw_detail.object.cus				 [ll_row] = dw_2.object.cus 							[ll_j]
		
		ldw_detail.Object.cant_proc_und2  [ll_row] = Dec(dw_2.object.saldo_und2 	[ll_j])
		
	END IF					
NEXT				
return true

end function

public function boolean of_opcion16 ();// Para procesar los registros seleccionados de Clase de Articulos
Long 		ll_j
String	ls_cod_clase, ls_mensaje

delete tt_alm_seleccion;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MEssageBox('Error', 'Ha ocurrido un error al eliminar registros en la tabla tt_alm_seleccion. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

FOR ll_j = 1 TO dw_2.RowCount()								
			
	ls_cod_clase = dw_2.Object.cod_clase						[ll_j]
	
	insert into tt_alm_seleccion(cod_clase)
	values(:ls_cod_clase);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error al insertar el registro en la tabla tt_alm_seleccion. Mensaje: ' + ls_mensaje, StopSign!)
		return true
	end if
NEXT		

commit;

return true

end function

public function boolean of_opcion17 ();Long 		ll_inicio
String	ls_string1, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_GUIA_PLACA_CHOFER;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIA_PLACA_CHOFER' ) then
	rollback;
	return false;
end if	
commit;

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_string1	= dw_2.object.nro_placa  	  [ll_inicio]				 				
	ls_string2	= dw_2.object.nom_chofer  	  [ll_inicio]				 				
	
	
	Insert into TT_GUIA_PLACA_CHOFER(nro_placa, nom_chofer)
	Values (:ls_string1, :ls_string2) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion18 ();Long 		ll_inicio
String	ls_string1

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_GUIAS;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIAS' ) then
	rollback;
	return false;
end if	
commit;

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_string1	= dw_2.object.nro_guia  	  [ll_inicio]				 				
	
	
	Insert into TT_GUIAS(nro_guia)
	Values (:ls_string1) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIAS' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion19 ();Long 		ll_inicio
String	ls_string1, ls_string2

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_COMPROBANTES;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_COMPROBANTES' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_string1	= dw_2.object.tipo_doc	[ll_inicio]				 				
	ls_string2	= dw_2.object.nro_doc	[ll_inicio]				 				
	
	
	Insert into TT_COMPROBANTES(tipo_doc, nro_doc)
	Values (:ls_string1, :ls_string2) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_COMPROBANTES' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

on w_abc_seleccion.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;Long 		ll_row
string 	ls_articulo, ls_datawindow
date		ld_fecha
u_dw_abc	ldw_master

ii_access = 1   // sin menu


invo_wait = create n_cst_wait

// Recoge parametro enviado
if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	return
end if

If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	return
end if

ist_datos = Message.PowerObjectParm

is_tipo 		= ist_datos.tipo
il_opcion 	= ist_datos.opcion
if il_opcion = 1 then
	// Para la salida de materiales x consumo interno
	// Reservados o saldo libre
	is_opcion = ist_datos.s_opcion 
	
	// primero debo vencer todos los items vencidos de reservacion_det
	update reservacion_det
		set flag_estado = '5'
	where trunc(fec_vencimiento) < trunc(sysdate)
	  and flag_estado = '1';
	
	IF SQLCA.SQLCode <> -1 then 
		commit;
	else
		rollback;
	end if
	
	//Muestro los datos deacuerdo a la opcion indicada
	if is_opcion = '1' then
		ls_datawindow = 'd_sel_mov_saldo_libre'
	elseif is_opcion = '2' then
		ls_datawindow = 'd_sel_mov_saldo_reserv'
	else
		MessageBox('Aviso', 'Opcion ' + is_opcion + ' no ha sido programada, por favor verificar')
		return
	end if
else
	is_opcion = '0'
	ls_datawindow = ist_datos.dw1
end if

dw_1.DataObject = ls_datawindow
dw_2.DataObject = ls_datawindow
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)	

IF TRIM(is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve(ist_datos.string1)
		CASE '1S2S'
			ll_row = dw_1.Retrieve(ist_datos.string1, ist_datos.string2)
		CASE '1D2D'
			ll_row = dw_1.Retrieve(ist_datos.date1, ist_datos.date2)
		CASE '2S'				
			ll_row = dw_1.Retrieve(ist_datos.string1, ist_datos.string2)
		CASE '1D2D1S'
			ll_row = dw_1.Retrieve(ist_datos.fecha1, ist_datos.fecha2, ist_datos.string1)
			
		CASE '2S_V2'	// Salida x Consumo Interno
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( ist_datos.string1, ist_datos.fecha1, is_almacen, &
					 ist_datos.tipo_doc, ist_datos.nro_doc)
					 
		CASE '2S_V3'	// Ingreso por produccion			
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen, ist_datos.tipo_doc, ist_datos.nro_doc)

		CASE 'CONSIG'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ld_fecha    = ist_datos.fecha1
			ll_row = dw_1.Retrieve( ist_datos.string1, ld_fecha, is_almacen)
			
		CASE 'CONSIG_2'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			ls_articulo = ldw_master.object.cod_art[ll_row]
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen, ls_articulo )
			
		CASE 'CONSIG_3'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )
			
		CASE 'DEVOL'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )
			
		CASE 'PRESTAMOS'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )

		CASE 'DEVOL_ALMACEN'				
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( ist_datos.oper_cons_interno, ist_datos.fecha1, &
						is_almacen, ist_datos.tipo_doc, ist_datos.nro_doc)
			
	END CHOOSE
END IF

This.Title = ist_datos.titulo

uo_search.of_set_dw( dw_1 )


if ist_datos.opcion = 1 then  // Consumos internos
	ldw_master 	= ist_datos.dw_or_m
	is_almacen  = ldw_master.Object.Almacen [ldw_master.getrow()]
	id_fecha 	= DATE(ldw_master.object.fec_registro[ldw_master.getrow()])
	// busca el tipo de almacen, para valorizar cuando sea 'M'
	Select flag_tipo_almacen 
		into :is_tipo_alm 
	from almacen 
	where almacen = :is_almacen;	
	
	// busca tipo de cambio
	in_tipo_cambio = f_get_tipo_cambio( id_fecha)
end if
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

event resize;call super::resize;dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2

cb_transferir.x	= newwidth - cb_transferir.width - 10
uo_search.width 	= cb_transferir.x - 10 - uo_Search.x

uo_Search.event ue_resize(sizetype, cb_transferir.x - 10 - uo_Search.x, newheight)
end event

event close;call super::close;destroy invo_wait
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion
event type integer ue_selected_row_now ( long al_row )
integer x = 0
integer y = 92
integer width = 1362
end type

event type integer dw_1::ue_selected_row_now(long al_row);String 		ls_cod, ls_matriz, ls_tipo_mov, ls_almacen, &
				ls_flag_saldo_libre, ls_cencos, ls_cnta_prsp, ls_cod_art
				
Decimal 		ldc_saldo_act, ldc_saldo_cons, ldc_cantidad, ldc_costo_prom

Long			ll_row, ll_rc, ll_nro_mov, j, ll_count
Any			la_id
Integer		li_x
u_dw_abc		ldw_master, ldw_detail

// Valida codigo

if ist_datos.opcion >= 7 and ist_datos.opcion < 12 then
	if idw_det.RowCount() > 0 then
		MessageBox('Aviso', 'No puede seleccionar mas de un articulo', StopSign!)
		return 0
	end if
end if

if this.of_existecampo( "nro_mov") then
	ll_nro_mov 	= Long(this.object.nro_mov[al_row])
else
	ll_nro_mov	= -1
end if

if this.of_existecampo( "cod_art") then
	ls_cod 		= this.object.cod_art[al_row]
else
	SetNull(ls_cod)
end if


ldw_master  = ist_datos.dw_or_m
ldw_detail  = ist_datos.dw_or_d


CHOOSE CASE ist_datos.opcion	
	
   CASE 1 // consumos internos		
		ls_almacen  			= ldw_master.Object.Almacen 	[ldw_master.getrow()]
		ls_tipo_mov				= ldw_master.Object.tipo_mov	[ldw_master.getrow()]
		ls_flag_saldo_libre 	= this.object.flag_saldo_libre[dw_1.GetRow()]
		
		// Valida que tenga matriz
		if ist_datos.string3 = '1' then
			ls_cod_Art 		= this.object.cod_art	[al_row]
			ls_Cencos 	 	= this.object.cencos	[al_row]
			ls_cnta_prsp	= this.object.cnta_prsp[al_row]
			
			if ist_datos.flag_matriz_contab = 'P' then
				ls_matriz = f_asigna_matriz(ls_tipo_mov, ls_cencos, ls_cnta_prsp)
				if isnull(ls_matriz) then
					Messagebox( "Atencion", "No existe matriz para este registro:" + STRING( ll_nro_mov))
					return 0
				end if
			elseif ist_datos.flag_matriz_contab = 'S' then
				ls_matriz = f_asigna_matriz_subcat(ls_tipo_mov, ls_cencos, ls_cod_art)
				if isnull(ls_matriz) then
					Messagebox( "Atencion", "No existe matriz para este registro:" + STRING( ll_nro_mov))
					return 0
				end if
			else
				MessageBox('Error', 'Valor para FLAG_MATRIZ_CONTAB esta incorrecto')
				return 0
			end if
		end if
		
		if ls_flag_saldo_libre = '0' then
			// Si el movimiento no es por saldo libre entonces verifico 
			// solo el saldo reservado
			SELECT Nvl(sldo_reservado,0) 
				INTO :ldc_saldo_act
			FROM  articulo_almacen
			WHERE almacen = :ls_almacen 
			  AND cod_art = :ls_cod; 
		else
			// Si el movimiento es saldo libre
			SELECT Nvl(sldo_total,0) - NVL(sldo_reservado,0) 
				INTO :ldc_saldo_act
			FROM  articulo_almacen
			WHERE almacen = :ls_almacen 
			  AND cod_art = :ls_cod; 
		end if;
		  
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Articulo ' + ls_cod + ' en almacen indicado ' &
				+ ls_almacen, StopSign!)
			return 0
		end if
				
		IF ldc_saldo_act <= 0 THEN
			
			MessageBox('Aviso', 'El Articulo ' + ls_cod + ' no tiene saldo ' &
				+ 'disponible en almacen indicado ' + ls_almacen, StopSign!)
			return 0
			
		ELSEIF this.object.cantidad[al_row] > ldc_saldo_act THEN	
			if ls_flag_saldo_libre = '1' then
					Messagebox('Aviso','Cantidad a Retirar No Puede Exceder al Saldo Libre ' &
							+ '~r~nSaldo Libre     : ' + string (ldc_saldo_act,'#0.0000') &
							+ '~r~nSaldo Solicitado: ' + string (this.object.cantidad[al_row],'#0.0000') , &
							exclamation!)
			else
					Messagebox('Aviso','Cantidad a Retirar No Puede Exceder al Saldo Reservado ' &
							+ '~r~nSaldo Reservado : ' + string (ldc_saldo_act,'#0.0000') &
							+ '~r~nSaldo Solicitado: ' + string (this.object.cantidad[al_row],'#0.0000') , &
							exclamation!)
			end if
		END IF
		
		ldc_costo_prom = of_costo_prom_articulo(ls_cod, ls_almacen)
		ldc_cantidad = this.object.cantidad[al_row]
		
		// Evalua presupuesto en linea
		IF f_afecta_presup(MONTH( id_fecha ), YEAR( id_fecha ), &
	 			this.Object.cencos[al_row], this.Object.cnta_prsp[al_row], &
				 ldc_cantidad * ldc_costo_prom / in_tipo_cambio) = 0 THEN 
  			//return 0
		END IF		
END CHOOSE

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

// Asigna datos
CHOOSE CASE ist_datos.opcion		
   CASE 1 // consumos internos
		idw_det.object.precio	[ll_row] = ldc_costo_prom
		idw_det.object.matriz	[ll_row] = ls_matriz
END CHOOSE


idw_det.ScrollToRow(ll_row)

return 1
end event

event dw_1::constructor;call super::constructor;
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0

end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row;//
Long	ll_row, ll_y, ll_rows, ll_item

dw_2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)
ll_rows = this.RowCount()

//ll_item = 1

Do While ll_row <> 0
	//invo_wait.of_mensaje("Traslandando registro " + string(ll_item) + " de " + string(ll_rows))
	// si retorna 0 (fallo en el row_now), deselecciona
	if THIS.EVENT ue_selected_row_now(ll_row) = 0 then
		this.selectRow(ll_row, false);
	end if
	ll_row = THIS.GetSelectedRow(ll_row)
	
	//ll_item ++
Loop

//invo_wait.of_close()

THIS.EVENT ue_selected_row_pos()


end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion
integer x = 1563
integer y = 96
integer width = 1362
integer taborder = 50
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw

end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

if ist_datos.opcion >= 7 and ist_datos.opcion <= 10 then
	
	ll_row = idw_det.EVENT ue_insert()
	ll_count = Long(this.object.Datawindow.Column.Count)
	FOR li_x = 1 to ll_count
		la_id = THIS.object.data.primary.current[al_row, li_x]	
		ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
	NEXT
	
else
	ll_row = idw_det.EVENT ue_insert()
	
	FOR li_x = 1 to UpperBound(ii_dk)
		la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
		ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
	NEXT
	
end if

idw_det.ScrollToRow(ll_row)


end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion
integer x = 1390
integer y = 392
integer taborder = 30
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion
integer x = 1394
integer y = 540
integer taborder = 40
end type

type cb_transferir from commandbutton within w_abc_seleccion
integer x = 2935
integer y = 4
integer width = 338
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 
Double 	ln_null, ld_factor, ln_costo_prom 
Long   	j, ll_found, ll_row
String 	ls_tipo_mov, ls_almacen, ls_cod_art, ls_nro_ot, ls_doc_ot, ls_cod_maq
Date 		ld_fecha
u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_or_d	// detail
ldw_master = ist_datos.dw_or_m	// master

if not IsNull(ldw_master) and IsValid(ldw_master) then
	ls_almacen  = ldw_master.Object.Almacen [ldw_master.getrow()]
	ld_fecha = DATE(ldw_master.object.fec_registro[ldw_master.getrow()])
else
	SetNull(ls_almacen)
	SetNull(ld_fecha)
end if


	 
CHOOSE CASE ist_datos.opcion
		
	CASE 1 // consumos internos
		if of_opcion1() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if

	CASE 2 // Ingreso por Produccion
		if of_opcion2() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if
		
	CASE 3 // Orden de Ventas

	   ls_almacen  = ldw_master.Object.Almacen [ldw_master.getrow()]
		ls_tipo_mov	= ldw_master.Object.tipo_mov[ldw_master.getrow()]
		ld_factor 	= wf_verifica_factor(ls_tipo_mov)
				
		FOR j = 1 TO dw_2.RowCount()										 
			ls_cod_art  = dw_2.Object.cod_art[j]					
			ll_row 		= ldw_detail.event ue_insert()

			IF ld_factor < 0 THEN  // Salidas						  
				// busca costo promedio - solo salidas
				Select costo_prom_sol 
					into :ln_costo_prom 
				from articulo
				Where cod_art = :ls_cod_art;
     		END IF  
					  
			IF ll_row > 0 THEN
				ldw_master.ii_update = 1						
				ldw_detail.ii_update = 1
				ldw_detail.Object.cod_origen   [ll_row] = gs_origen
				ldw_detail.Object.flag_estado  [ll_row] = '1'								
				ldw_detail.Object.cod_art      [ll_row] = dw_2.Object.cod_art	 	   [j]
				ldw_detail.Object.precio_unit  [ll_row] = ln_costo_prom
				ldw_detail.Object.cod_moneda	 [ll_row] = gnvo_app.is_soles //dw_2.Object.cod_moneda     [j]
				ldw_detail.Object.desc_art 	 [ll_row] = dw_2.Object.desc_art    	[j]
				ldw_detail.Object.und			 [ll_row] = dw_2.Object.und				[j]
				w_al302_mov_almacen.of_set_articulo( dw_2.Object.cod_art[j], ls_almacen) 
			END IF
		NEXT		
		
		ist_datos.titulo = 's'
		CloseWithReturn(parent, ist_datos)
		
	CASE 7 // Consumo de Articulos x Consignación
		
		if of_art_Consig() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
			return
		else
			return
		end if
		
	case 8
		if of_consig_cons_interno() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if
		
	case 9
		if of_opcion9() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
			return
		else
			return
		end if

	case 10
		if of_opcion10() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
			return
		else
			return
		end if
		
	case 11
		if of_opcion11() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
			return
		else
			return
		end if
		
	case 12
		if of_opcion12() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
			return
		else
			return
		end if
	
	CASE 13 //Pallets
		if of_opcion13() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if
	
	case 14
		if of_opcion14() then
			ist_datos.Titulo = 's'
			CloseWithReturn(parent, ist_datos)
			return
		else
			return
		end if
	
	CASE 15 //salidas del saldo por lotes
		if of_opcion15() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if

	CASE 16 //Seleccion de Clases de Articulos
		if of_opcion16() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if		
	
	CASE 17 //Seleccion de Placas - Choferes
		if of_opcion17() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if		
	
	CASE 18 //Seleccion de GUIAS - UBIGEO Destino
		if of_opcion18() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if	
	
	CASE 19 //Seleccion de Comprobantes de Venta
		if of_opcion19() then 
			ist_datos.titulo = 's'
			CloseWithReturn(parent, ist_datos)
		else
			return
		end if	
		
END CHOOSE
//CloseWithReturn( parent, ist_datos)
end event

type uo_search from n_cst_search within w_abc_seleccion
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

