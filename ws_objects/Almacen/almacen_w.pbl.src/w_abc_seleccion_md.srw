$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
type uo_search from n_cst_search within w_abc_seleccion_md
end type
type uo_search2 from n_cst_search within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 3639
integer height = 2588
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
dw_master dw_master
uo_search uo_search
uo_search2 uo_search2
end type
global w_abc_seleccion_md w_abc_seleccion_md

type variables
String 	is_tipo, is_type, is_almacen
integer 	ii_ik[]
str_parametros istr_datos


end variables

forward prototypes
public function double wf_verifica_factor (string as_tipo_mov)
public function integer wf_no_duplicados (string as_cod_art)
public function decimal wf_verifica_saldos (string as_codigo, string as_almacen)
public function boolean of_opcion1 ()
public function boolean of_opcion4 ()
public function boolean of_opcion5 ()
public function boolean of_opcion3 ()
public function boolean of_opcion2 ()
public function boolean of_opcion6 ()
public function boolean of_opcion7 ()
public function decimal of_precio_soles (decimal adc_precio, string as_moneda, decimal adc_descuento, date ad_fecha)
public function boolean of_opcion8 ()
public function boolean of_opcion9 ()
public function boolean of_opcion10 ()
end prototypes

public function double wf_verifica_factor (string as_tipo_mov);Double ld_factor

SELECT factor_sldo_total
  INTO :ld_factor   
  FROM articulo_mov_tipo
 WHERE tipo_mov = :as_tipo_mov ;
 
 Return ld_factor
end function

public function integer wf_no_duplicados (string as_cod_art);// Verifica codigo duplicados

long ll_find = 1, ll_end, ll_vec = 0
String ls_cad

ls_cad = "cod_art = '" + as_cod_Art + "'"
ll_vec = 0
ll_end = istr_datos.dw_or_d.RowCount()

ll_find = istr_datos.dw_or_d.Find(ls_cad, ll_find, ll_end)
DO WHILE ll_find > 0
	ll_vec ++
	// Collect found row
	ll_find++
	// Prevent endless loop
	IF ll_find > ll_end THEN EXIT
	ll_find = istr_datos.dw_or_d.Find(ls_cad, ll_find, ll_end)
LOOP			
if ll_vec > 0 then 
	messagebox( "Error", "Codigo de articulo ya existe")
	return 0	
end if
return 1
end function

public function decimal wf_verifica_saldos (string as_codigo, string as_almacen);Decimal ldc_saldo_total

SELECT Nvl(sldo_total,0)
	INTO   :ldc_saldo_total  
FROM   articulo_almacen
WHERE  almacen = :as_almacen 
	AND cod_art = :as_codigo ; 
	
IF SQLCA.SQLCode = 0 then ldc_saldo_total = 0	

Return ldc_saldo_total
end function

public function boolean of_opcion1 ();// Transfiere campos 

String      ls_almacen, ls_tipo_mov, ls_prov, ls_nombre, ls_null, ls_cod_art, &
				ls_cencos, ls_cnta_prsp, ls_org_amp_ref, ls_flag_saldo_libre
Long        ll_j, ll_row, ll_nro_amp_ref  
Date  		ld_fecha
Decimal		ldc_precio
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

// Asigna datos a dw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ldw_master.object.origen_refer[ll_row]  = dw_master.object.cod_origen[dw_master.getrow()]
ldw_master.object.tipo_refer	[ll_row]  = gnvo_app.is_doc_oc
ldw_master.object.nro_refer	[ll_row]  = dw_master.object.nro_doc	[dw_master.getrow()]
ldw_master.object.proveedor	[ll_row]  = dw_master.object.proveedor	[dw_master.getrow()]
		
ld_fecha = DATE(ldw_master.Object.fec_registro[ll_row])

// Buscar nombre de proveedor
ls_prov = dw_master.object.proveedor[dw_master.getrow()]
Select nom_proveedor 
	into :ls_nombre 
from proveedor 
where proveedor = :ls_prov;

ldw_master.object.nom_proveedor[ll_row] = ls_nombre

// Obteniendo el dato de almacen y tipo de movimiento
ls_almacen	 = ldw_master.Object.Almacen	[ll_row]
ls_tipo_mov	 = ldw_master.Object.tipo_mov	[ll_row]

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento en la cabecera es nulo')
	return false
end if

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	
	ldc_precio = of_precio_soles(dw_2.Object.precio_unit[ll_j], &
									dw_2.Object.cod_moneda	[ll_j], &
									dw_2.Object.decuento		[ll_j], &
									ld_fecha)
	
	if ldc_precio = 0 then 
		MessageBox('Aviso', 'El precio del Articulo ' + string(dw_2.Object.cod_art[ll_j]) &
				+ ' es cero, por favor verificar en la OC')
		return false
	end if
	
	ls_org_amp_ref = dw_2.Object.org_amp_ref [ll_j]
	ll_nro_amp_ref = dw_2.Object.nro_amp_ref [ll_j]
	
	If Not IsNull(ls_org_amp_ref) and not IsNull(ll_nro_amp_ref) then
		ls_flag_saldo_libre = '0'
	else
		ls_flag_saldo_libre = '1'
	end if


	ll_row = ldw_detail.event ue_insert()
	
	IF ll_row > 0 THEN
		//Obtengo el precio en Soles
		
		ldw_detail.Object.origen_mov_proy	[ll_row] = dw_2.Object.cod_origen		[ll_j]
		ldw_detail.Object.nro_mov_proy 	 	[ll_row] = dw_2.Object.nro_mov 	 		[ll_j]
		ldw_detail.Object.flag_estado  	 	[ll_row] = '1'								
		ldw_detail.Object.cod_art      	 	[ll_row] = dw_2.Object.cod_art	 		[ll_j]
		ldw_detail.Object.cant_procesada 	[ll_row] = dw_2.object.cantidad			[ll_j]
		ldw_detail.Object.precio_unit  	 	[ll_row] = ldc_precio  
		ldw_detail.Object.decuento		 		[ll_row] = 0 
		ldw_detail.Object.impuesto		 		[ll_row] = dw_2.Object.impuesto	   	[ll_j]
		ldw_detail.Object.cod_moneda		 	[ll_row] = gnvo_app.is_soles  
		ldw_detail.Object.desc_art 		 	[ll_row] = dw_2.Object.desc_art    		[ll_j]
		ldw_detail.Object.und				 	[ll_row] = dw_2.Object.und					[ll_j]	
		ldw_detail.Object.und2				 	[ll_row] = dw_2.Object.und2				[ll_j]
		ldw_detail.Object.flag_und2		 	[ll_row] = dw_2.Object.flag_und2			[ll_j]
		ldw_detail.Object.factor_conv_und 	[ll_row] = dw_2.Object.factor_conv_und	[ll_j]
		ldw_detail.Object.costo_prom_dol	 	[ll_row] = dw_2.Object.costo_prom_dol	[ll_j]	
		ldw_detail.Object.costo_prom_sol	 	[ll_row] = dw_2.Object.costo_prom_sol	[ll_j]	
		ldw_detail.Object.flag_saldo_libre 	[ll_row] = ls_flag_saldo_libre
		ldw_detail.Object.centro_benef 		[ll_row] = dw_2.Object.centro_benef 	[ll_j]	
		ldw_detail.Object.nro_serie	 		[ll_row] = dw_2.Object.nro_serie 		[ll_j]	
		ldw_detail.Object.nro_motor	 		[ll_row] = dw_2.Object.nro_motor 		[ll_j]	

		// Si se contabiliza entonces debo ponerle una matriz
		if istr_datos.string1 = '1' then						
			ls_cod_Art = dw_2.Object.cod_art	 	[ll_j]
			
			if istr_datos.flag_matriz_contab = 'P' then
				ldw_detail.object.matriz[ll_row] = f_asigna_matriz(ls_tipo_mov, ls_null, ls_null)					
			elseif istr_datos.flag_matriz_contab = 'S' then
				ldw_detail.object.matriz[ll_row] = f_asigna_matriz_subcat(ls_tipo_mov, ls_null, ls_cod_art)
			else
				MessageBox('Error', 'Valor para FLAG_MATRIZ_CONTAB esta incorrecto')
				return false
			end if
		end if

	END IF		   
NEXT
		
return true		

end function

public function boolean of_opcion4 ();// Salida Por Devolucion

String      ls_almacen, ls_tipo_mov, ls_prov, ls_nombre, ls_null, ls_cod_art, &
				ls_mensaje
Long        ll_j, ll_row 
Date  		ld_fecha
decimal		ldc_precio, ldc_saldo_total, ldc_cantidad
u_dw_abc 	ldw_master

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

// Asigna datos a ldw master
ldw_master = istr_datos.dw_or_m

//Verifico que ldw_master al menos tenga un registro
ll_row = ldw_master.getrow()
if ll_row = 0 then return false

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'Debe seleccionar un articulo para devolucion')
	return false
end if

if dw_2.RowCount() > 1 then
	MessageBox('Aviso', 'Solo se puede devolver un articulo por movimiento')
	return false
end if

ld_fecha = Date(dw_master.object.fec_registro[dw_master.getrow()])

//Convierto el precio a soles
ldc_precio = of_precio_soles(dw_2.Object.precio_unit[1], &
									dw_2.Object.cod_moneda	[1], &
									dw_2.Object.decuento		[1], &
									ld_fecha)

//Verifico si el articulo tiene saldo en almacen
ls_almacen 		= ldw_master.object.almacen[ll_row]
ls_cod_art 		= dw_2.object.cod_art	[1]
ldc_cantidad	= dec(dw_2.object.cantidad	[1])

select sldo_total 
	into :ldc_saldo_total
from articulo_almacen
where cod_art = :ls_cod_art
  and almacen = :ls_almacen;

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MessageBox('Aviso', 'El articulo ' + ls_cod_art + 'no existe en almacen ' &
				+ ls_almacen)
	return false
end if

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return false
end if

if ldc_saldo_total < ldc_cantidad then
	ROLLBACK;
	MessageBox('Aviso', 'No hay saldo disponible del articulo ' + ls_cod_art &
			+ ' en almacen ' + ls_almacen)
	return false
end if

ldw_master.object.cod_art			[ll_row]  = ls_cod_art
ldw_master.object.desc_art			[ll_row]  = dw_2.object.desc_art	[1]
ldw_master.object.cant_salida		[ll_row]  = ldc_cantidad
ldw_master.object.origen_refer	[ll_row]  = dw_master.object.cod_origen	[dw_master.getrow()]
ldw_master.object.tipo_refer		[ll_row]  = gnvo_app.is_doc_oc
ldw_master.object.precio_unit		[ll_row]  = ldc_precio
ldw_master.object.nro_refer		[ll_row]  = dw_master.object.nro_doc		[dw_master.getrow()]
ldw_master.object.proveedor		[ll_row]  = dw_master.object.proveedor		[dw_master.getrow()]
ldw_master.object.nom_proveedor	[ll_row]  = dw_master.object.nom_proveedor[dw_master.getrow()]
ldw_master.object.centro_benef	[ll_row]  = dw_2.object.centro_benef	[1]

// El articulo y el proveedor no deben modificarse
ldw_master.object.cod_art.protect = 1
ldw_master.object.cod_art.background.color = RGB(192,192,192)

ldw_master.object.proveedor.protect = 1
ldw_master.object.proveedor.background.color = RGB(192,192,192)

istr_datos.field_ret[1] = dw_2.object.cod_origen [1]
istr_datos.field_ret[2] = string(dw_2.object.nro_mov 	[1])


ldw_master.SetColumn('tipo_doc')

return true

end function

public function boolean of_opcion5 ();// Ordenes de Traslado

String      ls_almacen, ls_tipo_mov, ls_nombre, ls_null, ls_cod_art, &
				ls_mensaje, ls_nro_otr, ls_origen_otr, ls_contab, ls_cntrl_lote, &
				ls_solicita_lote, ls_flag_und2
Long        ll_row, ll_fac_total, ll_i
Date  		ld_fecha
decimal		ldc_saldo_libre, ldc_cantidad_und, ldc_cantidad_und2, ldc_precio, ldc_factor_conv
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

// Asigna datos a ldw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

//Verifico que ldw_master al menos tenga un registro
ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ls_almacen 		= ldw_master.object.almacen	[ll_row]
ls_tipo_mov		= ldw_master.object.tipo_mov	[ll_row]
ls_nro_otr		= dw_master.object.nro_otr		[dw_master.GetRow()]
ls_origen_otr	= left(ls_nro_otr,2)

// Coloco los datos de la referencia en la Orden de Traslado
ldw_master.object.origen_refer	[ll_row] = ls_origen_otr
ldw_master.object.tipo_refer		[ll_row] = gnvo_app.logistica.is_doc_otr
ldw_master.object.nro_refer		[ll_row] = ls_nro_otr

select NVL(factor_sldo_total,0), NVL(flag_contabiliza, '0')
	into :ll_fac_total, :ls_contab
from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov;

//Evaluando cada uno del detalle
for ll_i = 1 to dw_2.RowCount() 
	ls_cod_art 		= dw_2.object.cod_art				[ll_i]
	ls_cntrl_lote	= dw_2.object.flag_cntrl_lote		[ll_i]
	ldc_factor_conv= Dec(dw_2.object.factor_conv_und[ll_i])
	
	if ll_fac_total = -1 then
		ldc_cantidad_und 		= Dec(dw_2.object.cantidad				[ll_i])
		ldc_cantidad_und2 	= Dec(dw_2.object.cantidad_und2		[ll_i])
		
		// Si es una salida evaluo si hay saldo disponible en el almacen
		select NVL(sldo_total, 0) - NVL(sldo_reservado, 0) 
			into :ldc_saldo_libre
		from articulo_almacen
		where cod_art = :ls_cod_art
		  and almacen = :ls_almacen;
		
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			MessageBox('Aviso', 'El articulo ' + ls_cod_art + 'no existe en almacen ' &
						+ ls_almacen, StopSign!)
			return false
		end if
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', 'Error al consultar la tabla articulo_almacen. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if

		if ldc_saldo_libre = 0 then
			ROLLBACK;
			MessageBox('Aviso', 'El articulo ' + ls_cod_art + 'no tiene saldo libre en almacen ' &
						+ ls_almacen, StopSign!)
			return false
		end if
		
//		if ldc_saldo_libre < (ldc_cant_proyect - ldc_cant_salida) then
//			ROLLBACK;
//			MessageBox('Aviso', 'El articulo ' + ls_cod_art &
//					+ 'solo tiene un saldo libre de ' + string(ldc_saldo_libre, '###,##0.0000') &
//					+  ' en almacen ' + ls_almacen &
//					+ '~r~nCantidad Pendiente por Retirar: ' + string( ldc_cant_proyect - ldc_cant_salida, '###,##0.0000'))
//					
//			ldc_cantidad_und 	= ldc_saldo_libre
//			ldc_cantidad_und2 = ldc_cantidad_und * ldc_factor_conv
//		end if
		
	else
		ldc_cantidad_und 		= Dec(dw_2.object.cantidad				[ll_i])
		ldc_cantidad_und2 	= Dec(dw_2.object.cantidad_und2		[ll_i])

		
		//ldc_cantidad = ldc_cant_salida - ldc_cant_ingreso
		//ldc_cantidad_und	= ldc_cant_ingreso
		
	end if
	
	ll_row = ldw_detail.event ue_insert()
	
	IF ll_row > 0 THEN
		if ll_fac_total = -1 then
			//Si es una salida debo obtener el precio promedio del almacen origen
			select costo_prom_sol
				into :ldc_precio
			from articulo_almacen
			where cod_art = :ls_cod_art
			  and almacen = :ls_almacen;
			
			if SQLCA.SQLCode = 100 then
				select costo_prom_sol
					into :ldc_precio
				from articulo_almacen
				where cod_art = :ls_cod_art;
			end if
			
			if IsNull(ldc_precio) then ldc_precio = 0
		else
			// Si es un ingreso por transferencia debo coger el precio promedio
			// del almacen de ingreso
			select costo_prom_sol
				into :ldc_precio
			from articulo_almacen
			where cod_art = :ls_cod_art
			  and almacen = :ls_almacen;
			
			if SQLCA.SQLCode = 100 then
				select costo_prom_sol
					into :ldc_precio
				from articulo_almacen
				where cod_art = :ls_cod_art;
			end if
			
			if IsNull(ldc_precio) then ldc_precio = 0
		end if
		
		ldw_detail.Object.origen_mov_proy	[ll_row] = dw_2.Object.cod_origen	[ll_i]
		ldw_detail.Object.nro_mov_proy 	 	[ll_row] = dw_2.Object.nro_mov 	 	[ll_i]
		ldw_detail.Object.flag_estado  	 	[ll_row] = '1'								
		ldw_detail.Object.cod_art      	 	[ll_row] = dw_2.Object.cod_art	 	[ll_i]
		ldw_detail.Object.cant_procesada 	[ll_row] = ldc_cantidad_und
		ldw_detail.Object.precio_unit  	 	[ll_row] = ldc_precio  
		ldw_detail.Object.cod_moneda		 	[ll_row] = gnvo_app.is_soles  
		ldw_detail.Object.desc_art 		 	[ll_row] = dw_2.Object.desc_art    	[ll_i]
		ldw_detail.Object.und				 	[ll_row] = dw_2.Object.und				[ll_i]
		ldw_detail.object.flag_und2			[ll_row] = dw_2.object.flag_und2		[ll_i]
		ldw_detail.object.flag_saldo_libre	[ll_row] = '1'
		
		ls_flag_und2 = dw_2.object.flag_und2[ll_i]
		if IsNull(ls_flag_und2) then ls_flag_und2 = '0'
		
		//Pallet, Lote y posicion
		ldw_detail.Object.nro_pallet 		 	[ll_row] = dw_2.Object.nro_pallet 	[ll_i]
		ldw_detail.Object.nro_lote			 	[ll_row] = dw_2.Object.nro_lote		[ll_i]
		ldw_detail.object.anaquel				[ll_row] = dw_2.object.anaquel		[ll_i]
		ldw_detail.Object.fila		 		 	[ll_row] = dw_2.Object.fila    		[ll_i]
		ldw_detail.Object.columna			 	[ll_row] = dw_2.Object.columna		[ll_i]
		ldw_detail.object.cus					[ll_row] = dw_2.object.cus				[ll_i]
		
		if dw_2.of_existecampo( "cant_salida_und2" ) then
			ldw_detail.object.cant_proc_und2 [ll_row] = ldc_cantidad_und2
		else
			if ls_flag_und2 = '1' then
				ldw_detail.object.cant_proc_und2 [ll_row] = ldc_cantidad_und * ldc_factor_conv
			end if
		end if
		
		// Si se contabiliza entonces debo ponerle una matriz
		if ls_contab = '1' then						
			ldw_detail.object.matriz[ll_row] = f_asigna_matriz(ls_tipo_mov, ls_null, ls_null)					
		end if
		
		istr_datos.field_ret_d[1] = ldc_cantidad_und
		istr_datos.field_ret_d[2] = 0
		istr_datos.field_ret_d[3] = 0
		istr_datos.field_ret_d[4] = 0

	END IF	
	
next	

ldw_detail.Modify("cant_proc_und2.Protect ='1~tIf(IsNull(flag_und2),1,0)'")
ldw_detail.Modify("cant_proc_und2.Background.color ='1~tIf(IsNull(flag_und2),RGB(192,192,192),RGB(255,255,255))'")

return true

end function

public function boolean of_opcion3 ();// Salidas x Orden de Venta

Long 		ll_row_master, ll_j, ll_row
string	ls_prov, ls_nombre, ls_tipo_mov, ls_almacen, ls_cod_art, &
			ls_flag_und2, ls_centro_benef, ls_origen, ls_mensaje
Date		ld_fecha
Decimal	ldc_saldo_und, ldc_precio_unit, ldc_cant, ldc_cant_und2, &
			ldc_factor_conv_und, ldc_saldo_und2, ldc_peso_und
u_dw_abc ldw_master, ldw_detail

// Asigna datos a ldw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

ll_row_master = ldw_master.GetRow()

// Solo acepta una orden de venta
if ldw_master.object.nro_refer[ll_row_master] <> &
	dw_master.object.nro_ov[dw_master.getrow()] and ldw_detail.rowcount() > 0 then
	messagebox( "Error", "No puede seleccionar otra orden de venta")
	return false
end if

// Asigna datos a dw master				
ldw_master.object.origen_refer [ll_row_master] = dw_master.object.cod_origen[dw_master.getrow()]
ldw_master.object.tipo_refer	 [ll_row_master] = gnvo_app.is_doc_ov
ldw_master.object.nro_refer	 [ll_row_master] = dw_master.object.nro_ov	[dw_master.getrow()]
ldw_master.object.proveedor	 [ll_row_master] = dw_master.object.cliente	[dw_master.getrow()]

// Buscar nombre de cliente y lo asigna
ls_prov 		= dw_master.object.cliente[dw_master.getrow()]

Select nom_proveedor 
	into :ls_nombre 
from proveedor 
where proveedor = :ls_prov;

ldw_master.object.nom_proveedor[ll_row_master] = ls_nombre		

ls_almacen = ldw_master.Object.Almacen[ll_row_master]			
ld_fecha   = DATE(ldw_master.Object.fec_registro[ll_row_master])
ls_origen  = ldw_master.object.cod_origen[ll_row_master]

For ll_j = 1 to dw_2.RowCount()
	ls_cod_art   = dw_2.Object.cod_art[ll_j]
	
	// Obtengo el flag_und2 y el factor
	select NVL(flag_und2,0), NVL(factor_conv_und,0)
		into :ls_flag_und2, :ldc_factor_conv_und
	from articulo
	where cod_art = :ls_cod_art
	  and flag_estado = '1';
	
	IF SQLCA.SQLCode = 100 then
		ROLLBACK;
		
		Messagebox('Aviso','Codigo de Articulo Nº '+Trim(ls_cod_art) &
				+ ' No existe o no se encuentra ACTIVO, por favor verifique ', StopSign!)
				
		return false
		
	end if
	
	IF SQLCA.SQLCode = 100 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox('Aviso','Error al realizar la consulta en TABLA ARTICULO, Codigo de Articulo Nº '+Trim(ls_cod_art) &
				+ ' Mensaje: ' + ls_mensaje, StopSign!)
				
		return false
		
	end if
	
	//Obtengo el precio Unit
	select NVL(costo_prom_sol,0), NVL(sldo_total,0), NVL(sldo_total_und2,0)
		into :ldc_precio_unit, :ldc_saldo_und, :ldc_saldo_und2
	from articulo_almacen
	where cod_art = :ls_cod_art
	  and almacen  = :ls_almacen;
	
	IF SQLCA.SQLCode = 100 then
		ldc_saldo_und = 0
		
		select NVL(costo_prom_sol,0)
			into :ldc_precio_unit
		from articulo
		where cod_art = :ls_cod_art;
		
		if SQLCA.SQLCode = 100 then ldc_precio_unit = 0
		
	end if
	
	If IsNull(ldc_precio_unit) then ldc_precio_unit = 0
	
	ldc_cant 		= dw_2.object.cantidad			[ll_j]
	ldc_cant_und2	= Dec(dw_2.object.saldo_und2	[ll_j])
	ldc_peso_und	= Dec(dw_2.object.peso_und		[ll_j])
	
	//VAlido el Saldo del Articulo
	IF ldc_saldo_und = 0 THEN
		Messagebox('Aviso','Codigo de Articulo Nº '+Trim(ls_cod_art) &
				+ ' No Tiene Saldo Disponible ', StopSign!)
		ldc_cant = 0
	ELSE			
		IF ldc_cant > ldc_saldo_und THEN
			Messagebox('Aviso', 'Codigo de Articulo Nº '+Trim(ls_cod_art) &
									+ '~r~nNo se Puede Atender Toda la Cantidad Proyectada ' + String(ldc_cant)&
									+ '~r~nPor Exceder el Saldo Actual se tomara ' &
									+ 'en cuenta solo el Saldo Actual = ' + String(ldc_saldo_und), StopSign!)
			ldc_cant = ldc_saldo_und
		END IF
	END IF	
	
	//Valido SAldo en Und2
	if ls_flag_und2 = '1' and ldc_cant_und2 > 0 then
		IF ldc_saldo_und2 = 0 THEN
			Messagebox('Aviso','Codigo de Articulo Nº '+Trim(ls_cod_art) &
					+ ' No Tiene Saldo Disponible en SEGUNDA UNIDAD, por favor verifique! ')
			ldc_cant_und2 = 0
		ELSE			
			IF ldc_cant_und2 > ldc_saldo_und2 THEN
				Messagebox('Aviso', 'Codigo de Articulo Nº '+Trim(ls_cod_art) &
									+ '~r~nNo se Puede Atender Toda la Cantidad Proyectada en UND2 ' + String(ldc_cant_und2)&
									+ '~r~nPor Exceder el Saldo Actual en UND2 se tomara ' &
									+ 'en cuenta solo el Saldo Actual = ' + String(ldc_saldo_und2))

				ldc_cant_und2 = ldc_saldo_und2
			END IF
		END IF	
	end if
	
	if ldc_cant > 0 then	// solo cuando tenga stocks			   
		ll_row = ldw_detail.Event Dynamic ue_insert()

		IF ll_row > 0 THEN					
			ldw_detail.Object.cod_art      	 	[ll_row] = ls_cod_art
			ldw_detail.Object.flag_estado     	[ll_row] = '1'
			ldw_detail.Object.cant_procesada  	[ll_row] = ldc_cant
			ldw_detail.Object.cant_proc_und2  	[ll_row] = ldc_cant_und2
			ldw_detail.Object.desc_art 		 	[ll_row] = dw_2.Object.desc_art    	[ll_j]
			ldw_detail.Object.und				 	[ll_row] = dw_2.Object.und				[ll_j]
			ldw_detail.Object.und2				 	[ll_row] = dw_2.Object.und2			[ll_j]
			ldw_detail.Object.flag_und2		 	[ll_row] = ls_flag_und2
			ldw_detail.Object.factor_conv_und 	[ll_row] = ldc_factor_conv_und
			ldw_detail.Object.cencos 				[ll_row] = dw_2.Object.cencos			[ll_j]
			ldw_detail.Object.cnta_prsp		 	[ll_row] = dw_2.Object.cnta_prsp 	[ll_j]
			ldw_detail.Object.origen_mov_proy 	[ll_row] = dw_2.object.cod_origen   [ll_j]
			ldw_detail.Object.nro_mov_proy 	 	[ll_row] = dw_2.Object.nro_mov 	 	[ll_j]
			ldw_detail.Object.precio_unit 	 	[ll_row] = ldc_precio_unit
			ldw_detail.Object.peso_und 	 		[ll_row] = ldc_peso_und
			ldw_detail.Object.peso_neto 	 		[ll_row] = ldc_peso_und * ldc_cant
			
			//Nro Lote, Pallet, y ubicacion
			ldw_detail.Object.nro_pallet 			[ll_row] = dw_2.Object.nro_pallet	[ll_j]
			ldw_detail.Object.nro_lote 			[ll_row] = dw_2.Object.nro_lote		[ll_j]
			ldw_detail.Object.anaquel			 	[ll_row] = dw_2.Object.anaquel 		[ll_j]
			ldw_detail.Object.fila				 	[ll_row] = dw_2.object.fila     		[ll_j]
			ldw_detail.Object.columna		 	 	[ll_row] = dw_2.Object.columna 	 	[ll_j]
			ldw_detail.Object.cus			 	 	[ll_row] = dw_2.Object.cus 	 	   [ll_j]

			//Obtengo el centro de beneficio del Codigo de Articulo
			select cb.centro_benef
				into :ls_centro_benef
			from centro_benef_articulo cba,
				  centro_beneficio		cb
			where cb.centro_benef 	= cba.centro_benef
			  and cba.cod_art 		= :ls_cod_art
			  and cb.cod_origen 		= :ls_origen;
			
			ldw_detail.Object.centro_benef 	 	[ll_row] = ls_centro_benef
			
		end if
	end if
NEXT

return true

end function

public function boolean of_opcion2 ();Long 		ll_row_master, ll_j, ll_row
string	ls_prov, ls_nombre
u_dw_abc  ldw_master, ldw_detail

// Asigna datos a ldw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

// Asigna datos a dw master
ll_row_master = ldw_master.getrow()
ldw_master.object.origen_refer[ll_row_master] = dw_master.object.cod_origen[dw_master.getrow()]
ldw_master.object.tipo_refer	[ll_row_master] = gnvo_app.is_doc_oc
ldw_master.object.nro_refer	[ll_row_master] = dw_master.object.nro_doc[dw_master.getrow()]
ldw_master.object.proveedor	[ll_row_master] = dw_master.object.proveedor[dw_master.getrow()]		

// Buscar nombre de proveedor
ls_prov = dw_master.object.proveedor[dw_master.getrow()]
Select nom_proveedor 
	into :ls_nombre 
from proveedor 
where proveedor = :ls_prov;

ldw_master.object.nom_proveedor[ll_row_master] = ls_nombre
For ll_j = 1 to dw_2.RowCount()						
	ll_row = ldw_detail.event dynamic ue_insert()
	IF ll_row > 0 THEN
		ldw_detail.Object.cod_origen      [ll_row] = dw_2.Object.cod_origen	   [ll_j]				
		ldw_detail.Object.cod_art      	 [ll_row] = dw_2.Object.cod_art	 	   [ll_j]
		ldw_detail.Object.cant_recibida   [ll_row] = dw_2.object.cantidad			[ll_j]				
		ldw_detail.Object.desc_art 		 [ll_row] = dw_2.Object.desc_art    	[ll_j]
		ldw_detail.Object.und				 [ll_row] = dw_2.Object.und				[ll_j]				
	end if
NEXT

return true
end function

public function boolean of_opcion6 ();// DEvolucion a almacen de materiales

String      ls_almacen, ls_tipo_mov, ls_nro_doc, ls_tipo_doc, ls_origen_doc, &
				ls_Flag_Contab, ls_cencos, ls_cnta_prsp, ls_cod_art, &
				ls_tipo_mov_dev
Long        ll_row, ll_i
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

// Asigna datos a ldw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

//Verifico que ldw_master al menos tenga un registro
ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ls_almacen 		= ldw_master.object.almacen	[ll_row]
ls_tipo_mov		= ldw_master.object.tipo_mov	[ll_row]
ls_tipo_doc		= dw_master.object.tipo_doc	[dw_master.GetRow()]
ls_nro_doc		= dw_master.object.nro_doc		[dw_master.GetRow()]
ls_origen_doc	= dw_master.object.cod_origen	[dw_master.GetRow()]

// Verifico si el movimiento es de devolucion entonces obtengo el
// Movimiento de Devolucion correspondiente
select tipo_mov_dev
  into :ls_tipo_mov_dev
  from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov;

// Coloco los datos de la referencia en la Orden de Traslado
ldw_master.object.origen_refer	[ll_row] = dw_master.object.origen_refer	[dw_master.GetRow()]
ldw_master.object.tipo_refer		[ll_row] = dw_master.object.tipo_refer		[dw_master.GetRow()]
ldw_master.object.nro_refer		[ll_row] = dw_master.object.nro_refer		[dw_master.GetRow()]
ldw_master.object.tipo_doc_int	[ll_row] = dw_master.object.tipo_doc		[dw_master.GetRow()]
ldw_master.object.nro_doc_int		[ll_row] = dw_master.object.nro_doc			[dw_master.GetRow()]
ldw_master.object.proveedor		[ll_row] = dw_master.object.proveedor		[dw_master.GetRow()]
ldw_master.object.nom_proveedor	[ll_row] = dw_master.object.nom_proveedor	[dw_master.GetRow()]

select NVL(FLAG_CONTABILIZA, '0')
	into :ls_flag_contab
from articulo_mov_tipo
where tipo_mov = :ls_tipo_mov;

//Evaluando cada uno del detalle
for ll_i = 1 to dw_2.RowCount() 
	ll_row = ldw_detail.event ue_insert()
	
	IF ll_row > 0 THEN
		ldw_detail.Object.cod_art				[ll_row] = dw_2.Object.cod_art				[ll_i]
		ldw_detail.Object.desc_art				[ll_row] = dw_2.Object.desc_art				[ll_i]
		ldw_detail.Object.und					[ll_row] = dw_2.Object.und						[ll_i]
		ldw_detail.Object.und2					[ll_row] = dw_2.Object.und2					[ll_i]
		ldw_detail.Object.factor_conv_und	[ll_row] = dw_2.Object.factor_conv_und		[ll_i]
		ldw_detail.Object.flag_estado  		[ll_row] = '1'								
		ldw_detail.Object.cant_procesada 	[ll_row] = Dec(dw_2.Object.cant_procesada	[ll_i])
		ldw_detail.Object.cant_proc_und2 	[ll_row] = Dec(dw_2.Object.cant_proc_und2	[ll_i])
		ldw_detail.Object.precio_unit  		[ll_row] = Dec(dw_2.Object.precio_unit		[ll_i])
		ldw_detail.Object.cod_moneda			[ll_row] = gnvo_app.is_soles  
		ldw_detail.Object.origen_mov_proy	[ll_row] = dw_2.Object.origen_mov_proy		[ll_i]
		ldw_detail.Object.nro_mov_proy 		[ll_row] = dw_2.Object.nro_mov_proy	 		[ll_i]
		ldw_detail.object.flag_und2			[ll_row] = dw_2.object.flag_und2				[ll_i]
		ldw_detail.object.nro_lote				[ll_row] = dw_2.object.nro_lote				[ll_i]
		ldw_detail.object.cencos				[ll_row] = dw_2.object.cencos					[ll_i]
		ldw_detail.object.cnta_prsp			[ll_row] = dw_2.object.cnta_prsp				[ll_i]
		ldw_detail.object.oper_sec				[ll_row] = dw_2.object.oper_sec				[ll_i]
		ldw_detail.object.matriz				[ll_row] = dw_2.object.matriz					[ll_i]
		ldw_detail.object.org_mov_dev			[ll_row] = dw_2.object.cod_origen			[ll_i]
		ldw_detail.object.nro_mov_dev			[ll_row] = dw_2.object.nro_mov				[ll_i]
		ldw_detail.object.cant_devol_und1	[ll_row] = Dec(dw_2.object.cant_procesada	[ll_i])
		ldw_detail.object.cant_devol_und2	[ll_row] = Dec(dw_2.object.cant_proc_und2	[ll_i])
		ldw_detail.object.flag_saldo_libre	[ll_row] = dw_2.object.flag_saldo_libre	[ll_i]
		ldw_detail.object.centro_benef		[ll_row] = dw_2.object.centro_benef			[ll_i]
		ldw_detail.object.nro_reservacion	[ll_row] = dw_2.object.nro_reservacion		[ll_i]
		ldw_detail.object.item_reservacion	[ll_row] = dw_2.object.item_reservacion	[ll_i]
		
		istr_datos.cant_procesada = dec(dw_2.Object.cant_procesada	[ll_i])
		istr_datos.cant_proc_und2 = dec(dw_2.Object.cant_proc_und2	[ll_i])
		
		// Si se contabiliza entonces debo ponerle una matriz
		if ls_flag_contab = '1' then						
			ls_cod_art   = dw_2.Object.cod_art			[ll_i]
			ls_cencos    = dw_2.Object.cencos			[ll_i]
			ls_cnta_prsp = dw_2.Object.cnta_prsp		[ll_i]
			
			if IsNull(ldw_detail.object.matriz[ll_row]) or ldw_detail.object.matriz[ll_row] = '' then
				if gnvo_app.logistica.is_flag_matriz_Contab = 'P' then
					ldw_detail.object.matriz[ll_row] = f_asigna_matriz(ls_tipo_mov_dev, ls_cencos, ls_cnta_prsp)					
				else
					ldw_detail.object.matriz[ll_row] = f_asigna_matriz_subcat(ls_tipo_mov_dev, ls_cencos, ls_cod_art)					
				end if
			end if
		end if
	END IF	
next	

ldw_detail.Modify("cant_proc_und2.Protect ='1~tIf(IsNull(flag_und2),1,0)'")
ldw_detail.Modify("cant_proc_und2.Background.color ='1~tIf(IsNull(flag_und2),RGB(192,192,192),RGB(255,255,255))'")

return true


end function

public function boolean of_opcion7 ();// DEvolucion a almacen de materiales
string ls_origen_refer, ls_tipo_refer, ls_nro_refer
str_parametros lstr_datos

if dw_2.RowCount() = 0 then return false

if dw_2.RowCount() > 1 then 
	MessageBox('Aviso', 'Solo se puede transferir un solo Oper_sec')
	return false
end if

lstr_datos.string1 = dw_2.object.oper_sec[1]
lstr_datos.titulo	 = 's'

CloseWithReturn(this, lstr_datos)

return true
end function

public function decimal of_precio_soles (decimal adc_precio, string as_moneda, decimal adc_descuento, date ad_fecha);/*
   Funcion que devuelve el precio unitario en soles
*/

Decimal ldc_precio
String ls_mensaje

if as_moneda = gnvo_app.is_dolares then
	
	ldc_precio = gnvo_app.finparam.of_conv_mon(adc_precio - adc_descuento, as_moneda, gnvo_app.is_soles, ad_fecha)
	
else
	
	ldc_precio = adc_precio - adc_descuento
	
end if

IF ldc_precio < 0 then
	Messagebox( "Error", "Precio no debe ser negativo, revisar", StopSign!)
	return 0
end if

return ldc_precio
end function

public function boolean of_opcion8 ();// Generar Ingreso a almacén de Tránsito, siempre va a estar referenciado
// a una OC

String      ls_almacen, ls_tipo_mov, ls_null, ls_cod_art
Long        ll_j, ll_row
Date  		ld_fecha
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

// Asigna datos a dw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ldw_master.object.org_oc	[ll_row]  = dw_master.object.cod_origen[dw_master.getrow()]
ldw_master.object.nro_oc	[ll_row]  = dw_master.object.nro_doc[dw_master.getrow()]
		
ld_fecha = DATE(ldw_master.Object.fec_registro[ll_row])

// Obteniendo el dato de almacen y tipo de movimiento
ls_almacen	 = ldw_master.Object.Almacen	[ll_row]
ls_tipo_mov	 = ldw_master.Object.tipo_mov	[ll_row]

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento en la cabecera es nulo')
	return false
end if

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	
	ll_row = ldw_detail.event ue_insert()
	
	IF ll_row > 0 THEN
		//Obtengo el precio en Soles
		
		ldw_detail.Object.ORG_AMP_OC		[ll_row] = dw_2.Object.cod_origen	[ll_j]
		ldw_detail.Object.NRO_AMP_OC 	 	[ll_row] = dw_2.Object.nro_mov 	 	[ll_j]
		ldw_detail.Object.flag_estado  	[ll_row] = '1'								
		ldw_detail.Object.cod_art      	[ll_row] = dw_2.Object.cod_art	 	[ll_j]
		ldw_detail.Object.cant_procesada [ll_row] = dw_2.object.cantidad		[ll_j]
		ldw_detail.Object.desc_art 		[ll_row] = dw_2.Object.desc_art    	[ll_j]
		ldw_detail.Object.und				[ll_row] = dw_2.Object.und				[ll_j]	
		ldw_detail.Object.almacen_dst		[ll_row] = dw_2.Object.almacen		[ll_j]	

	END IF		   
NEXT
		
return true		

end function

public function boolean of_opcion9 ();// Generar Ingreso a almacén de Tránsito, siempre va a estar referenciado
// a una OC

String      ls_almacen, ls_tipo_mov, ls_null, ls_cod_art, &
				ls_doc_alm
Long        ll_j, ll_row
Date  		ld_fecha
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

select DOC_MOV_ALMACEN
	into :ls_doc_alm
from logparam
where reckey = '1';

// Asigna datos a dw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ld_fecha = DATE(ldw_master.Object.fec_registro[ll_row])

// Obteniendo el dato de almacen y tipo de movimiento
ls_almacen	 = ldw_master.Object.Almacen	[ll_row]
ls_tipo_mov	 = ldw_master.Object.tipo_mov	[ll_row]

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento en la cabecera es nulo')
	return false
end if

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	
	ll_row = ldw_detail.event ue_insert()
	
	IF ll_row > 0 THEN
		//Obtengo el precio en Soles
		
		ldw_detail.Object.ORG_AMP_OC		[ll_row] = dw_2.Object.org_amp_oc	[ll_j]
		ldw_detail.Object.NRO_AMP_OC 	 	[ll_row] = dw_2.Object.nro_amp_oc 	[ll_j]
		ldw_detail.Object.flag_estado  	[ll_row] = '1'								
		ldw_detail.Object.cod_art      	[ll_row] = dw_2.Object.cod_art	 	[ll_j]
		ldw_detail.Object.cant_procesada [ll_row] = dw_2.object.cantidad		[ll_j]
		ldw_detail.Object.desc_art 		[ll_row] = dw_2.Object.desc_art    	[ll_j]
		ldw_detail.Object.und				[ll_row] = dw_2.Object.und				[ll_j]	
		ldw_detail.Object.almacen_dst		[ll_row] = dw_2.Object.almacen		[ll_j]	

	END IF		   
NEXT
		
return true		

end function

public function boolean of_opcion10 ();// Transfiere campos 

String      ls_almacen, ls_tipo_mov, ls_nombre, ls_null, ls_cod_art, &
				ls_cencos, ls_cnta_prsp, ls_org_amp_ref, ls_flag_saldo_libre
Long        ll_j, ll_row, ll_nro_amp_ref 
Date  		ld_fecha
Decimal		ldc_precio, ldc_costo_sol, ldc_costo_dol
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

// Asigna datos a dw master
ldw_master = istr_datos.dw_or_m
ldw_detail = istr_datos.dw_or_d

ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ldw_master.object.origen_refer	[ll_row]  = dw_master.object.origen_oc		[dw_master.getrow()]
ldw_master.object.tipo_refer		[ll_row]  = dw_master.object.tipo_doc		[dw_master.getrow()]
ldw_master.object.nro_refer		[ll_row]  = dw_master.object.nro_oc			[dw_master.getrow()]
ldw_master.object.proveedor		[ll_row]  = dw_master.object.proveedor		[dw_master.getrow()]
ldw_master.object.nom_proveedor	[ll_row]  = dw_master.object.nom_proveedor[dw_master.getrow()]
		
ld_fecha = DATE(ldw_master.Object.fec_registro[ll_row])


// Obteniendo el dato de almacen y tipo de movimiento
ls_almacen	 = ldw_master.Object.Almacen	[ll_row]
ls_tipo_mov	 = ldw_master.Object.tipo_mov	[ll_row]

if ls_tipo_mov = '' or IsNull(ls_tipo_mov) then
	MessageBox('Aviso', 'Tipo de movimiento en la cabecera es nulo')
	return false
end if

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	//Obtengo el precio en Soles
	ldc_precio = of_precio_soles(dw_2.Object.precio_unit[ll_j], &
											dw_2.Object.cod_moneda	[ll_j], &
											dw_2.Object.decuento		[ll_j], &
											ld_fecha)
	
	if ldc_precio = 0 then 
		MessageBox('Aviso', 'El precio del Articulo ' + string(dw_2.Object.cod_art[ll_j]) &
				+ ' es cero, por favor verificar en la OC')
		return false
	end if
	
	// Verifico si es saldo Libre o reservado
	ls_org_amp_ref = dw_2.Object.org_amp_ref [ll_j]
	ll_nro_amp_ref = dw_2.Object.nro_amp_ref [ll_j]
	
	If Not IsNull(ls_org_amp_ref) and not IsNull(ll_nro_amp_ref) then
		ls_flag_saldo_libre = '0'
	else
		ls_flag_saldo_libre = '1'
	end if
	
	// Obtengo el costo promedio en soles y dolares
	ls_cod_art = dw_2.object.cod_art [ll_j]
	
	select costo_prom_sol, costo_prom_dol
		into :ldc_costo_sol, :ldc_costo_dol
	from articulo_almacen
	where cod_art = :ls_cod_art
	  and almacen = :ls_almacen;
	
	// Inserto una fila en el detalle del movimiento del almacen
	ll_row = ldw_detail.event ue_insert()
	
	IF ll_row > 0 THEN
		
		
		ldw_detail.Object.origen_mov_proy	[ll_row] = dw_2.Object.org_amp_oc		[ll_j]
		ldw_detail.Object.nro_mov_proy 	 	[ll_row] = dw_2.Object.nro_amp_oc 		[ll_j]
		ldw_detail.Object.flag_estado  	 	[ll_row] = '1'								
		ldw_detail.Object.cod_art      	 	[ll_row] = ls_cod_art
		ldw_detail.Object.cant_procesada 	[ll_row] = dw_2.object.cant_procesada	[ll_j]
		ldw_detail.Object.precio_unit  	 	[ll_row] = ldc_precio  
		ldw_detail.Object.decuento		 		[ll_row] = 0 
		ldw_detail.Object.impuesto		 		[ll_row] = dw_2.Object.impuesto	   	[ll_j]
		ldw_detail.Object.cod_moneda		 	[ll_row] = gnvo_app.is_soles  
		ldw_detail.Object.desc_art 		 	[ll_row] = dw_2.Object.desc_art    		[ll_j]
		ldw_detail.Object.und				 	[ll_row] = dw_2.Object.und					[ll_j]
		ldw_detail.Object.und2				 	[ll_row] = dw_2.Object.und2				[ll_j]
		ldw_detail.Object.flag_und2		 	[ll_row] = dw_2.Object.flag_und2			[ll_j]
		ldw_detail.Object.factor_conv_und 	[ll_row] = dw_2.Object.factor_conv_und	[ll_j]
		ldw_detail.Object.costo_prom_dol	 	[ll_row] = ldc_costo_dol
		ldw_detail.Object.costo_prom_sol	 	[ll_row] = ldc_costo_dol
		ldw_detail.Object.flag_saldo_libre 	[ll_row] = ls_flag_saldo_libre
		ldw_detail.Object.centro_benef 		[ll_row] = dw_2.Object.centro_benef 	[ll_j]
		ldw_detail.Object.vale_trans	 		[ll_row] = dw_2.Object.nro_vale		 	[ll_j]
		ldw_detail.Object.item_trans	 		[ll_row] = dw_2.Object.nro_item		 	[ll_j]
		
		// Si se contabiliza entonces debo ponerle una matriz
		if istr_datos.string1 = '1' then						
	
			if istr_datos.flag_matriz_contab = 'P' then
				ldw_detail.object.matriz[ll_row] = f_asigna_matriz(ls_tipo_mov, ls_null, ls_null)					
			elseif istr_datos.flag_matriz_contab = 'S' then
				ldw_detail.object.matriz[ll_row] = f_asigna_matriz_subcat(ls_tipo_mov, ls_null, ls_cod_art)
			else
				MessageBox('Error', 'Valor para FLAG_MATRIZ_CONTAB esta incorrecto')
				return false
			end if
		end if

	END IF		   
NEXT
		
return true		

end function

on w_abc_seleccion_md.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.dw_master=create dw_master
this.uo_search=create uo_search
this.uo_search2=create uo_search2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.uo_search
this.Control[iCurrent+4]=this.uo_search2
end on

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.dw_master)
destroy(this.uo_search)
destroy(this.uo_search2)
end on

event ue_open_pre;call super::ue_open_pre;Long 		ll_row, ll_fac_total
string	ls_tipo_mov, ls_alm_org, ls_alm_dst, ls_tipo_mov_dev, &
			ls_origen, ls_nro_ref, ls_nro_vale
Date		ld_fecha1, ld_fecha2
u_dw_abc	ldw_master

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo = istr_datos.tipo
dw_master.DataObject = istr_datos.dw_master
dw_master.SetTransObject( SQLCA)

dw_1.DataObject = istr_datos.dw1
dw_1.SetTransObject( SQLCA)

dw_2.DataObject = istr_datos.dw1
dw_2.SetTransObject( SQLCA)	

if TRIM( is_tipo ) = '' then 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_master.Retrieve( istr_datos.string1 )
			
		CASE '1S2S'
			ll_row = dw_master.Retrieve( istr_datos.string1, istr_datos.string2 )
			
		CASE 'COMPRAS'
			ldw_master = istr_datos.dw_or_m
			ldw_master.Accepttext( )
			
		 	is_almacen = ldw_master.object.almacen[ldw_master.GetRow()]
			ll_row = dw_master.Retrieve( is_almacen )
			
			if istr_datos.tipo_doc <> '' and istr_datos.nro_doc <> '' then
				dw_master.SetFilter("nro_doc = '" + istr_datos.nro_doc + "'")
				dw_master.Filter()
			else
				dw_master.SetFilter('')
				dw_master.Filter()
			end if
			
		CASE 'DEVOL'
			ldw_master = istr_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen = ldw_master.object.almacen[ll_row]
			ll_row = dw_master.Retrieve( is_almacen )
			
		CASE 'OV'
			ldw_master = istr_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen = ldw_master.object.almacen[ll_row]
			ll_row = dw_master.Retrieve( is_almacen )
			
			if istr_datos.tipo_doc <> '' and istr_datos.nro_doc <> '' then
				dw_master.SetFilter("nro_ov = '" + istr_datos.nro_doc + "'")
				dw_master.Filter()
			else
				dw_master.SetFilter('')
				dw_master.Filter()
			end if
			
			if dw_master.RowCount() > 0 then
				dw_master.SelectRow(0, false)
				dw_master.SelectRow(1, true)
				dw_master.SetRow(1)
				dw_master.event ue_output(1)
			end if
			
		CASE 'DEVOL_ALM'
			
			ldw_master = istr_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			ls_nro_vale 	 = istr_datos.string1
			is_almacen 		 = ldw_master.object.almacen		[ll_row]
			ls_nro_ref		 = ldw_master.object.nro_refer	[ll_row]
			ls_origen		 = ldw_master.object.cod_origen	[ll_row]
			ld_fecha1		 = istr_datos.fecha1
			ld_fecha2		 = istr_datos.fecha2
			ls_tipo_mov_dev = istr_datos.tipo_mov_dev
			
			if not IsNull(ls_nro_vale) and trim(ls_nro_Vale) <> '' then
				ld_fecha1 = DAte(gnvo_app.of_fecha_Actual())
				ld_fecha2 = ld_fecha1
			end if
			
			
			ll_row = dw_master.Retrieve( ls_origen, is_almacen, ls_tipo_mov_dev, ld_fecha1, ld_fecha2, ls_nro_vale)
			
	END CHOOSE
end if

uo_search.of_set_dw(dw_master)
uo_search2.of_set_dw( dw_1 )

This.Title = istr_datos.titulo

end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - 10
dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2

cb_transferir.x	= newwidth - cb_transferir.width - 10

uo_search.width 	= cb_transferir.x - 10 - uo_Search.x
uo_Search.event ue_resize(sizetype, cb_transferir.x - 10 - uo_Search.x, newheight)

uo_search2.width 	= newwidth/2 - uo_search2.x 
uo_Search2.event ue_resize(sizetype, uo_Search2.width, newheight)
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 948
integer width = 1362
integer height = 808
end type

event dw_1::constructor;call super::constructor;// Asigna parametro


if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	istr_datos = MESSAGE.POWEROBJECTPARM	
end if

//ii_ss      = 0 		//seleccion multiple
//is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
//is_dwform  = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_count, ll_rc
Any	la_id
Integer	li_x
string	ls_oper_sec, ls_cod_art, ls_find

if istr_datos.opcion = 4 then
	if dw_2.RowCount() > 1 then
		MessageBox('Aviso', 'Solo se puede seleccionar un articulo x vez')
		return
	end if
elseif istr_datos.opcion = 9 or istr_datos.opcion = 10 then
	ls_find = "org_amp_oc = '" + dw_1.object.org_amp_oc[al_row] &
			  + "' and nro_amp_oc = " + string(dw_1.object.nro_amp_oc[al_row])
	
   ll_row = dw_2.Find(ls_find, 1, dw_2.rowcount( ))
	
	if ll_row > 0 then
		MessageBox('Aviso', 'Item de OC ya ha sido seleccionado ' &
				+ string(dw_1.object.org_amp_oc[al_row]) + string(dw_1.object.nro_amp_oc[al_row]))
		this.Selectrow( 0, false)
		return
	end if
	
end if

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1600
integer y = 948
integer width = 1362
integer height = 808
integer taborder = 60
end type

event dw_2::constructor;call super::constructor;ii_ss = 0 
ii_ck[1] = 1
Choose Case istr_datos.opcion 
	 	 Case 1   // 
			ii_dk[1]  =  1
				ii_dk[2]  =  2 
				ii_dk[5]  =  5	
				ii_dk[6]  =  6
				ii_dk[7]  =  7
				ii_dk[8]  =  8
				ii_dk[9]  =  9
				ii_dk[10] = 10
				ii_dk[11] = 11
				ii_dk[12] = 12
				ii_dk[13] = 13
				ii_dk[14] = 14
				ii_dk[15] = 15
				ii_dk[16] = 16
				ii_dk[17] = 17
				ii_dk[18] = 18
				ii_dk[19] = 19
				ii_dk[20] = 20
				ii_rk[1]  =  1
				ii_rk[2]  =  2 
				ii_rk[5]  =  5	
				ii_rk[6]  =  6
				ii_rk[7]  =  7
				ii_rk[8]  =  8
				ii_rk[9]  =  9
				ii_rk[10] = 10
				ii_rk[11] = 11
				ii_rk[12] = 12
				ii_rk[13] = 13
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16
				ii_rk[17] = 17
				ii_rk[18] = 18
				ii_rk[19] = 19
				ii_rk[20] = 20
		Case 2
				ii_dk[1]  =  1
				ii_dk[2]  =  2
				ii_dk[3]  =  3
				ii_dk[4]  =  4	
				ii_dk[5]  =  5	
				ii_dk[6]  =  6	
				ii_rk[1]  =  1
				ii_rk[2]  =  2
				ii_rk[3]  =  3
				ii_rk[4]  =  4
				ii_rk[5]  =  5	
				ii_rk[6]  =  6
	Case 3
				ii_dk[1]  =  1
				ii_dk[2]  =  2
				ii_dk[3]  =  3
				ii_dk[4]  =  4	
				ii_dk[5]  =  5
				ii_dk[6]  =  6
				ii_dk[7]  =  7
				ii_dk[8]  =  8
				ii_dk[9]  =  9
				ii_dk[10]  = 10
				ii_dk[11]  = 11
				ii_dk[12]  = 12
				ii_dk[13]  = 13
				ii_dk[14]  = 14
				ii_rk[1]  =  1
				ii_rk[2]  =  2
				ii_rk[3]  =  3
				ii_rk[4]  =  4
				ii_rk[5]  =  5
				ii_rk[6]  =  6
				ii_rk[7]  =  7
				ii_rk[8]  =  8
				ii_rk[9]  =  9
				ii_rk[10]  = 10
				ii_rk[11]  = 11
				ii_rk[12]  = 12
				ii_rk[13]  = 13
				ii_rk[14]  = 14
end choose

end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_count, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1426
integer y = 1176
integer taborder = 40
end type

event pb_1::clicked;call super::clicked;//Long ll_row_mst
//
//
//ll_row_mst = ist_datos.dw_m.getrow()
//
//messagebox( ist_datos.dw_m.object.nro_sol_serv[ll_row_mst], '')
//messagebox( dw_2.object.nro_sol_serv[1], '' )
//  if ist_datos.dw_m.object.sol_cod_origen[ll_row_mst] <> dw_2.object.cod_origen[1] or &
//     ist_datos.dw_m.object.nro_sol_serv[ll_row_mst] <> dw_2.object.nro_sol_serv[1] then
//	  messagebox("Error", "no puede seleccionar otro documento") 
//	  return 
//end if
end event

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1417
integer y = 1364
integer taborder = 50
end type

type cb_transferir from commandbutton within w_abc_seleccion_md
integer x = 2953
integer width = 338
integer height = 88
integer taborder = 30
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

if dw_2.rowcount() = 0 then return

Choose case istr_datos.opcion
	CASE 1 // Ingreso x Compras 
		if of_opcion1() then
			istr_datos.Titulo = 's'
		else
			return
		end if
		
	CASE 2  // Orden de compra Pendientes/consignacion	
		if of_opcion2() then
			istr_datos.Titulo = 's'
		else
			return
		end if
		
	CASE 3  // Orden de venta
		if of_opcion3() then
			istr_datos.Titulo = 's'
		else
			return
		end if
		
	case 4 	//Salidas por devoluciones
		if of_opcion4() then
			istr_datos.Titulo = 's'
		else
			return
		end if
	case 5 	//Orden de traslados
		if of_opcion5() then
			istr_datos.Titulo = 's'
		else
			return
		end if
	case 6 	//Devolucion a Almacen
		if of_opcion6() then
			istr_datos.Titulo = 's'
		else
			return
		end if
		
	case 7 	//FLAG_AMP = 3, Orden de Trabajo, Ingreso x Produccion
		of_opcion7()
		return

	case 8 	//Ingreso por Transporte
		if of_opcion8() then
			istr_datos.Titulo = 's'
		else
			return
		end if

	case 9 	//Salida por Transporte
		if of_opcion9() then
			istr_datos.Titulo = 's'
		else
			return
		end if

	case 10 	//Ingreso x compra de Salida por Transporte
		if of_opcion10() then
			istr_datos.Titulo = 's'
		else
			return
		end if

END CHOOSE
CloseWithReturn( parent, istr_datos)

end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 96
integer width = 2894
integer height = 752
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event ue_output;call super::ue_output;// Muestra detalle
Long 			ll_count
String 		ls_nro_ref, ls_nro_oc, ls_nro_vale, ls_vale_ref, ls_almacen
u_dw_abc 	ldw_master
if al_row = 0 then return
dw_2.Accepttext()

ll_count = dw_2.RowCount()

Choose case istr_datos.opcion 
	Case 1		// Ingresos x Compra 
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		ls_nro_oc = istr_datos.dw_or_m.object.nro_refer[istr_datos.dw_or_m.getRow()]
		ls_nro_ref = this.object.nro_doc[al_row]				
		if ls_nro_ref <> ls_nro_oc then
			Messagebox( "Atencion", "No puede seleccionar otro documento", Exclamation!)
			dw_1.reset()
			dw_2.reset()
			Return
		end if
		dw_1.Retrieve( gnvo_app.is_doc_oc, this.object.nro_doc[al_row], is_almacen)
		
	Case 2				// consignacion
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		dw_1.Retrieve( gnvo_app.is_doc_oc, this.object.nro_doc[al_row])
	case 3				// Ordenes de venta
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		dw_1.Retrieve( this.object.nro_ov[al_row], is_almacen)
	case 4				// Devoluciones al Proveedor
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		dw_1.Retrieve( this.object.nro_doc[al_row], is_almacen)
	case 5				// Ordenes de Traslado
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		dw_1.Retrieve( this.object.nro_otr[al_row], this.object.almacen[al_row])
	case 6				// Devoluciones a Almacen
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		dw_1.Retrieve( this.object.nro_doc[al_row])
	case 7				// FALG_AMP = 3
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		dw_1.Retrieve( this.object.nro_orden[al_row] )
	Case 8		// Ingresos a almacén en Tránsito
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		ls_nro_oc = istr_datos.dw_or_m.object.nro_oc[istr_datos.dw_or_m.getRow()]
		ls_nro_ref = this.object.nro_doc[al_row]				
		if ls_nro_ref <> ls_nro_oc then
			Messagebox( "Atencion", "No puede seleccionar otro documento", Exclamation!)
			dw_1.reset()
			dw_2.reset()
			Return
		end if
		dw_1.Retrieve( this.object.tipo_doc[al_row], this.object.nro_doc[al_row], is_almacen)
		
	Case 9		// Salidas de los mov de almacen en tránsito
		ls_almacen = this.object.almacen[al_row]
		ls_nro_oc  = this.object.nro_oc[al_row]
		dw_1.Retrieve( ls_almacen, ls_nro_oc)
	
	case 10		// Ingresos x Compra de las Salidas por Transito
		if ll_count > 0 then
			Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
			This.setredraw(false)
			This.Selectrow(0,False)
			This.Selectrow(al_row,True)
			This.setfocus()
			This.setredraw(true)	
			dw_1.reset()
			dw_2.reset()
		end if
		
		ls_nro_oc = istr_datos.dw_or_m.object.nro_refer[istr_datos.dw_or_m.getRow()]
		ls_nro_ref = this.object.nro_oc[al_row]				
		if ls_nro_ref <> ls_nro_oc then
			Messagebox( "Atencion", "No puede seleccionar otro documento", Exclamation!)
			dw_1.reset()
			dw_2.reset()
			Return
		end if

		ls_almacen = this.object.almacen	[al_row]
		ls_nro_oc  = this.object.nro_oc	[al_row]
		dw_1.Retrieve( ls_almacen, ls_nro_oc)
end Choose

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	THIS.Event ue_output(currentrow)
	RETURN
END IF
end event

type uo_search from n_cst_search within w_abc_seleccion_md
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type uo_search2 from n_cst_search within w_abc_seleccion_md
integer y = 856
integer taborder = 30
boolean bringtotop = true
end type

on uo_search2.destroy
call n_cst_search::destroy
end on

