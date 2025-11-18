$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion_md
end type
type dw_text from datawindow within w_abc_seleccion_md
end type
type cb_1 from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
type cb_2 from commandbutton within w_abc_seleccion_md
end type
type pb_todo from picturebutton within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 3237
integer height = 2312
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
dw_master dw_master
cb_2 cb_2
pb_todo pb_todo
end type
global w_abc_seleccion_md w_abc_seleccion_md

type variables
String 	is_col = '', is_tipo, is_type, is_oper_ing_oc, is_doc_sc, &
			is_oper_cons_int, is_doc_ot, is_almacen, is_flag_cntrl_fondos, &
			is_subcateg, is_cod_art, is_desc_art, is_nro_doc, is_ot_adm, &
			is_comprador, is_nro_cotizacion, is_doc_oc, is_soles, is_dolares, &
			is_doc_ov
integer 	ii_ik[], ii_opcion
Date		id_fecha1, id_fecha2
Boolean 	ib_sel = false, ib_process = true
str_parametros ist_datos

end variables

forward prototypes
public function integer of_ubica_cod (string as_cod_art)
public function integer wf_verifica_dup (string as_cod_art)
public function integer wf_duplicados_os (datawindow adw_1, integer an_item)
public function integer wf_provee_subcat (string as_subcat)
public function integer of_opcion1 ()
public function integer of_opcion11 ()
public function integer of_get_param ()
public function integer of_articulo_cotizado (string as_codart)
public function integer of_validar_part_prsp (string as_cencos, string as_cnta_prsp, long al_ano, string as_oper_sec)
public function integer of_opcion12 ()
public function integer of_opcion2 ()
public function integer of_opcion6 ()
public function decimal of_conv_mon (decimal adc_importe, string as_moneda1, string as_moneda2, date ad_fecha)
public function integer of_opcion14 ()
public function integer of_opcion15 ()
public function integer of_opcion7 ()
public function integer of_opcion4 ()
public function integer of_opcion17 ()
public function integer of_evalua_cod (string as_cod)
public function integer of_opcion8 ()
public function integer of_opcion19 ()
public function integer of_opcion20 ()
public function boolean of_opcion21 ()
public function decimal of_precio_soles (decimal adc_precio, string as_moneda, decimal adc_descuento, date ad_fecha)
public subroutine of_insert_art_oc (string as_orden_compra)
public function boolean of_opcion22 ()
public function boolean of_opcion23 ()
public subroutine of_insert_item_os (string as_orden_os, string as_cod_moneda)
public function boolean of_opcion24 ()
public subroutine of_insert_item_grmp (string as_guia_rec_mp, string as_cod_moneda, string as_tipo_doc_grmp)
public function integer of_insert_ref_grmp (long al_item)
public function boolean of_opcion25 ()
public function boolean of_opcion26 ()
public subroutine of_insert_art_ov (string as_orden_venta)
public function boolean of_opcion27 ()
end prototypes

public function integer of_ubica_cod (string as_cod_art);/* Funcion que ubica un codigo y devuelve su posicion, para acumularlo */

long 		ll_find = 1, ll_end, ll_vec = 0
String 	ls_cad

ls_cad = "cod_art = '" + as_cod_Art + "'"
ll_vec = 0
ll_end = ist_datos.dw_d.RowCount()

ll_find = ist_datos.dw_d.Find(ls_cad, 1, ll_end)
if ll_find > 0 then
	return ll_find
end if
return 0
end function

public function integer wf_verifica_dup (string as_cod_art);// Verifica codigo duplicados

long ll_find = 1, ll_end, ll_vec = 0
String ls_cad

ls_cad = "cod_art = '" + as_cod_Art + "'"
ll_vec = 0
ll_end = ist_datos.dw_d.RowCount()

ll_find = ist_datos.dw_d.Find(ls_cad, ll_find, ll_end)
DO WHILE ll_find > 0
	ll_vec ++
	// Collect found row
	ll_find++
	// Prevent endless loop
	IF ll_find > ll_end THEN EXIT
	ll_find = ist_datos.dw_d.Find(ls_cad, ll_find, ll_end)
LOOP			
if ll_vec > 0 then 
	messagebox( "Error", "Codigo de articulo ya existe")
	return 0	
end if
return 1
end function

public function integer wf_duplicados_os (datawindow adw_1, integer an_item);/*
  funcion que evalua los duplicados en una o/servicio
  
  Parametro: an_item, es el numero de item que se le asigno en la 
  				 solicitud de servicio.
					
  Comentario: este item deberia ser parte del primary key, pero no 
     esta asi, por lo tanto este numero es el mismo numero de item
	  que se le asigna en la orden de servicio.
  Retorna:   0 = duplicados
  				 1 = no hay duplicados
*/
int j, li_count

For j = 1 to adw_1.RowCount()
	if adw_1.object.nro_item[j] = an_item then
		Messagebox( "Error", "Item " + String( adw_1.object.nro_item[j]) + &
		" Ya existe")
	   return 0
	end if
Next
return 1
end function

public function integer wf_provee_subcat (string as_subcat);/* Funcion que verifica sub categoria tenga proveedores que
 puedan cotizar
 
 Retorna = 0, fallo
 			  1, Ok.	
*/
Long ln_count

Select count(proveedor) into :ln_count from proveedor_articulo where
   cod_sub_cat = :as_subcat;
if ln_count = 0 then
	Messagebox( "Error", "Sub Categoria " + as_subcat + " No tiene proveedores")
	Return 0
end if
Return 1

end function

public function integer of_opcion1 ();Long		ll_row_mas, ll_row, ll_j
Decimal	ldc_precio
String	ls_cod_art, ls_proveedor
Date 	ld_fec_reg
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

// Actualiza origen y solicitud en cabecera				
ll_row_mas = ldw_master.getrow()	
if ll_row_mas = 0 then return 0

ls_proveedor 	= ldw_master.object.proveedor[ll_row_mas]
ld_fec_reg 		= Date(ldw_master.object.fec_registro[ll_row_mas])

For ll_j = 1 to dw_2.RowCount()
	ls_cod_art = dw_2.object.cod_art[ll_j]
	ll_row = ldw_detail.event dynamic ue_insert()
	if ll_row > 0 then
		//Verifico que el articulo no este cotizado
		if of_articulo_cotizado( ls_cod_art ) = 0 then continue			
		
		// Precio Unitario pactado
		select precio_compra
			into :ldc_precio
		from articulo_precio_pactado
		where cod_art 		= :ls_cod_art
		  and proveedor 	= :ls_proveedor
		  and trunc(fecha_inicio) <= :ld_fec_reg
		  and trunc(fecha_fin) >= :ld_fec_reg
		  and flag_estado = '1';
		  
		if IsNull(ldc_precio) then ldc_precio = 0
		
		ldw_detail.object.cod_Art      	[ll_row] = dw_2.object.cod_art	[ll_j]
		ldw_detail.object.desc_art		 	[ll_row] = dw_2.object.desc_art	[ll_j]
		ldw_detail.object.Und			 	[ll_row] = dw_2.object.und		[ll_j]
		ldw_detail.object.cod_origen	 	[ll_row] = gnvo_app.is_origen
		ldw_detail.object.flag_estado	 	[ll_row] = '1' // ok
		ldw_detail.object.tipo_mov		 	[ll_row] = is_oper_ing_oc
		ldw_detail.object.fec_proyect	 	[ll_row] = dw_2.object.fec_requerida	[ll_j]
		ldw_detail.object.cant_proyect 	[ll_row] = dw_2.object.cantidad			[ll_j]			
		ldw_detail.object.origen_ref	 	[ll_row] = dw_2.object.cod_origen		[ll_j]	
		ldw_detail.object.tipo_ref		 	[ll_row] = is_doc_sc
		ldw_detail.object.referencia	 	[ll_row] = dw_2.object.nro_sol_comp	[ll_j]	
		ldw_detail.object.dias_reposicion[ll_row] = dw_2.object.dias_reposicion	[ll_j]
		ldw_detail.object.dias_rep_import[ll_row] = dw_2.object.dias_rep_import	[ll_j]
		ldw_detail.object.cod_usr			[ll_row] = gnvo_app.is_user
		
		ist_datos.w1.dynamic of_set_articulo(dw_2.object.cod_art	[ll_j])
	end if			
Next

return 1
end function

public function integer of_opcion11 ();Long ll_row_mas, ll_row, ll_j
string 	ls_descripcion, ls_obs
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

ll_row_mas = ldw_master.GetRow()
if ll_row_mas = 0 then return 0

For ll_j = 1 to dw_2.RowCount()
	ll_row = ldw_detail.event ue_insert()
	
	if ll_row > 0 then	
		
		ls_obs = trim(dw_2.object.obs [ll_j])
		
		if IsNull(ls_obs) then ls_obs = ''
		
		ls_descripcion = trim(dw_2.object.desc_operacion [ll_j])
		if IsNull(ls_descripcion) then ls_descripcion = ''
		
		ls_descripcion += ' ' + ls_obs

		ldw_detail.object.cod_origen		[ll_row] = gnvo_app.is_origen
		ldw_detail.object.nro_orden		[ll_row] = dw_2.object.nro_orden			[ll_j]
		ldw_detail.object.fec_proyect		[ll_row] = dw_2.object.fec_inicio		[ll_j]
		ldw_detail.object.cencos			[ll_row] = dw_2.object.cencos				[ll_j]
		ldw_detail.object.cnta_prsp		[ll_row] = dw_2.object.cnta_prsp			[ll_j]
		ldw_detail.object.oper_sec			[ll_row] = dw_2.object.oper_sec			[ll_j]
		ldw_detail.object.servicio			[ll_row] = dw_2.object.servicio			[ll_j]
		ldw_detail.object.desc_servicio	[ll_row] = dw_2.object.desc_servicio	[ll_j]
		ldw_detail.object.centro_benef	[ll_row] = dw_2.object.centro_benef		[ll_j]
		ldw_detail.object.cenbef_ot		[ll_row] = dw_2.object.centro_benef		[ll_j]
		ldw_detail.object.desc_centro		[ll_row] = dw_2.object.desc_centro		[ll_j]
		ldw_detail.object.descripcion		[ll_row] = left(ls_descripcion, 200)
		
		ldw_detail.ii_update = 1
		
	end if
Next

return 1
end function

public function integer of_get_param ();select oper_ing_oc, doc_sc, doc_oc, cod_soles, cod_dolares, doc_ov
	into 	:is_oper_ing_oc, :is_doc_sc, :is_doc_oc, :is_soles, 
			:is_dolares, :is_doc_ov
from logparam
where reckey = '1';

if SQLCA.SQlCode= 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return 0
end if

if trim(is_oper_ing_oc) = '' or IsNull(is_oper_ing_oc) then
	MessageBox('Aviso', 'No ha definido Ingreso por Compra (Oper_ing_oc) en LogParam')
	return 0
end if

if trim(is_doc_sc) = '' or IsNull(is_doc_sc) then
	MessageBox('Aviso', 'No ha definido Documento Solicitud de Compra (doc_sc) en LogParam')
	return 0
end if

if is_doc_oc = '' or IsNull(is_doc_oc) then
	MessageBox('Aviso', 'No ha definido Documento Orden de Compra en LogParam')	
	return 0
end if

if is_soles = '' or IsNull(is_soles) then
	MessageBox('Aviso', 'No ha definido Tipo de Moneda Soles en LogParam')	
	return 0
end if

return 1
end function

public function integer of_articulo_cotizado (string as_codart);// Verifica codigo si esta cotizado
// Return: 0 = Cotizado
//			  1 = No cotizado
int li_count

Select Count( * ) 
	into :li_count 
from cotizacion_provee_bien_det 
where cod_art = :as_codart 
  and flag_ganador = 1;

if li_count <> 0 then
	Messagebox( "Atencion", "Articulo " + as_codart + ' esta cotizado')
	return 0   
end if

return 1
end function

public function integer of_validar_part_prsp (string as_cencos, string as_cnta_prsp, long al_ano, string as_oper_sec);string ls_flag_estado, ls_flag_cmp_directa, ls_flag_ingr_egr

if as_cencos = '' or IsNull(as_cencos) then
	MessageBox('Aviso', 'Centro de Costos esta en blanco, por favor definirla en la Orden de Trabajo')
	return 0
end if

if as_cnta_prsp = '' or IsNull(as_cnta_prsp) then
	MessageBox('Aviso', 'Cuenta Presupuestal esta en blanco, por favor definirla en la Cuenta Presupuestal '&
			+ 'de terceros para la labor')
	return 0
end if

select NVL(flag_estado,''), NVL(flag_cmp_directa,''), NVL(flag_ingr_egr, '')
	into :ls_flag_estado, :ls_flag_cmp_directa, :ls_flag_ingr_egr
from presupuesto_partida
where cencos 		= :as_cencos
  and cnta_prsp 	= :as_cnta_prsp
  and ano 			= :al_ano;

IF SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe partida presupuestal ' &
				+ '~r Centro de Costos  : ' + as_cencos &
				+ '~r Cnta Presupuestal : ' + as_cnta_prsp &
				+ '~r Año Ejecucion     : ' + string(al_ano) &
				+ '~r Oper Sec          : ' + as_oper_sec )
	return 0
end if

if ls_flag_estado = '0' or ls_flag_estado = '' then
	MessageBox('Aviso', 'Partida Presupuestal no esta activa ' &
				+ '~r Centro de Costos  : ' + as_cencos &
				+ '~r Cnta Presupuestal : ' + as_cnta_prsp &
				+ '~r Año Ejecucion     : ' + string(al_ano) &
				+ '~r Oper Sec          : ' + as_oper_sec )
	return 0
end if;
 
if ls_flag_cmp_directa = '0' or ls_flag_cmp_directa = '' then
	MessageBox('Aviso', 'Partida Presupuestal no es para gasto directo ' &
				+ '~r Centro de Costos  : ' + as_cencos &
				+ '~r Cnta Presupuestal : ' + as_cnta_prsp &
				+ '~r Año Ejecucion     : ' + string(al_ano) &
				+ '~r Oper Sec          : ' + as_oper_sec )
	return 0
end if;


if ls_flag_ingr_egr = 'I' or ls_flag_ingr_egr = '' then
	MessageBox('Aviso', 'Partida Presupuestal no es de Egresos ' &
				+ '~r Centro de Costos  : ' + as_cencos &
				+ '~r Cnta Presupuestal : ' + as_cnta_prsp &
				+ '~r Año Ejecucion     : ' + string(al_ano) &
				+ '~r Oper Sec          : ' + as_oper_sec )
	return 0
end if;


return 1
end function

public function integer of_opcion12 ();Long 		ll_row_mas, ll_row, ll_j, ll_count
Integer	li_year
Date 		ld_fec_reg
string 	ls_cod_art, ls_proveedor, ls_almacen, ls_moneda, ls_ot_adm, &
			ls_cencos, ls_cnta_prsp, ls_null
Decimal 	ldc_precio, ldc_porc_impuesto, ldc_impuesto, ldc_cant_proyect
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

SetNull(ls_null)

ll_row_mas = ldw_master.GetRow()
if ll_row_mas = 0 then return 0

ls_proveedor 	= ldw_master.object.proveedor[ll_row_mas]
ld_fec_reg 		= Date(ldw_master.object.fec_registro[ll_row_mas])
ls_moneda		= ldw_master.object.cod_moneda[ll_row_mas]

For ll_j = 1 to dw_2.RowCount()
	ll_row = ldw_detail.event dynamic ue_insert()
	
	if ll_row > 0 then	
		ls_cod_art = dw_2.object.cod_art [ll_j]
		ls_almacen = dw_2.object.almacen[ll_j]
		
		//create or replace function usf_cmp_prec_compra_artic(
		//       asi_cod_art         in articulo.cod_art%TYPE,
		//       asi_proveedor       in proveedor.proveedor%type,
		//       adi_fec_reg         in orden_compra.fec_registro%type,
		//       asi_almacen         in almacen.almacen%TYPE,
		//       asi_moneda          in moneda.cod_moneda%type
		//) return number is
		SELECT usf_cmp_prec_compra_artic(:ls_cod_art, :ls_proveedor, :ld_fec_reg,
				:ls_almacen, :ls_moneda)
			INTO :ldc_precio
		FROM dual ;
		
		if SQLCA.SQlCode = -1 then
			ROLLBACK;
			MessageBox('Error en funcion usf_cmp_prec_compra_artic', SQLCA.SQlErrText)
			return 0
		end if
		
		if IsNull(ldc_precio) then ldc_precio = 0
		
		ldw_detail.object.fec_proyect		[ll_row] = dw_2.object.fec_proyect		[ll_j]
		ldw_detail.object.cod_art			[ll_row] = dw_2.object.cod_art			[ll_j]
		ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art			[ll_j]
		ldw_detail.object.und				[ll_row] = dw_2.object.und					[ll_j]
		ldw_detail.object.oper_sec			[ll_row] = dw_2.object.oper_sec			[ll_j]
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.cant_pendiente	[ll_j]
		ldw_detail.object.cant_pendiente	[ll_row] = dw_2.object.cant_pendiente	[ll_j]
		ldw_detail.object.almacen			[ll_row] = dw_2.object.almacen			[ll_j]
		ldw_detail.object.origen_ref		[ll_row] = dw_2.object.origen_ref		[ll_j]
		ldw_detail.object.tipo_ref			[ll_row] = dw_2.object.tipo_doc			[ll_j]		
		ldw_detail.object.referencia		[ll_row] = dw_2.object.nro_orden			[ll_j]
		ldw_detail.object.precio_unit		[ll_row] = ldc_precio
		ldw_detail.object.dias_reposicion[ll_row] = dw_2.object.dias_reposicion	[ll_j]
		ldw_detail.object.dias_rep_import[ll_row] = dw_2.object.dias_rep_import	[ll_j]
		ldw_detail.object.cod_usr			[ll_row] = gnvo_app.is_user
		ldw_detail.object.org_amp_ref		[ll_row] = dw_2.object.cod_origen		[ll_j]
		ldw_detail.object.nro_amp_ref		[ll_row] = dw_2.object.nro_mov			[ll_j]
		ldw_detail.object.saldo_almacen	[ll_row] = dw_2.object.saldo_almacen	[ll_j]
		ldw_detail.object.flag_almacen	[ll_row] = ls_null
				
		if is_flag_cntrl_fondos = '1' then
			//Si esta activo el flag entonces coloco el Fondo de COmpras
			//deacuerdo al OT_ADM
			ls_ot_adm  	= dw_2.object.ot_adm		[ll_j]
			li_year		= Year(Date(dw_2.object.fec_proyect[ll_j]))
			
			select cencos, cnta_prsp
				into :ls_cencos, :ls_cnta_prsp
			from compra_fondo_ot_adm
			where ot_adm = :ls_ot_adm
			  and ano = :li_year;
			
			if SQLCA.SQLCode <> 100 then
				ldw_detail.object.cencos		[ll_row] = ls_cencos
				ldw_detail.object.cnta_prsp	[ll_row] = ls_cnta_prsp
			end if
		end if

		//Calculo del impuesto
		ldc_cant_proyect  = Dec(dw_2.object.cant_pendiente	[ll_j])
		ldc_porc_impuesto = dec(ldw_detail.object.porc_impuesto[ll_row])
		ldc_impuesto 		= ldc_precio * ldc_cant_proyect * ldc_porc_impuesto / 100
		ldw_detail.object.impuesto [ll_row] = ldc_impuesto

		ldw_detail.ii_update = 1		
		
	end if
	
Next
ist_datos.w1.DYNAMIC FUNCTION of_set_total_oc()

return 1
end function

public function integer of_opcion2 ();Long 			ll_row_mst, ll_j, ll_row, ll_count
string 		ls_oper_ing_oc, ls_doc_prog, ls_cod_art, &
				ls_flag_imp, ls_proveedor, ls_moneda, ls_almacen, &
				ls_cencos, ls_cnta_prsp, ls_ot_adm, ls_null
Integer		li_dias_rep, li_dias_rep_imp, li_year
Date			ld_fecha_ent, ld_fec_reg
Decimal 		ldc_precio, ldc_impuesto, ldc_porc_impuesto, ldc_cant_proyect
u_dw_abc  	ldw_master, ldw_detail

SetNull(ls_null)

Select oper_ing_oc, tipo_doc_prog_cmp
	into :ls_oper_ing_oc, :ls_doc_prog
from logparam 
where reckey = '1';
		
if isnull( ls_oper_ing_oc ) or trim( ls_oper_ing_oc ) = '' then 
	Messagebox( "Error","Definir Movimiento Ingreso x Compra en LogParam", Exclamation!)
	return 0
end if

if isnull( ls_doc_prog ) or trim( ls_doc_prog ) = '' then 
	Messagebox( "Error","Definir Documento Programa de Compras en LogParam", Exclamation!)
	return 0
end if
		
ll_row_mst = dw_master.GetRow()
if ll_row_mst = 0 then return 0

ldw_master = ist_datos.dw_m     	//Cabecera de la Orden de Compra
ldw_detail = ist_datos.dw_d		//Detalle de la Orden de Compra

// Una Orden de Compra debe hacerse de un Programa de Compras
ld_fec_reg 		= Date(ldw_master.object.fec_registro[ldw_master.GetRow()])
ls_proveedor 	= ldw_master.object.proveedor[ldw_master.GetRow()]
ls_moneda 		= ldw_master.object.cod_moneda[ldw_master.GetRow()]
		
For ll_j = 1 to dw_2.RowCount()
			
	// Calcula Fecha de entrega, si es local o importacion
	ls_cod_art = dw_2.object.cod_art[ll_j]
			
	Select NVL(dias_reposicion,0), NVL(dias_rep_import,0) 
		into :li_dias_rep, :li_dias_rep_imp 
   from articulo 
	Where cod_Art = :ls_cod_art;
			
	ll_row = ldw_detail.event ue_insert()
			
	if ll_row > 0 then
		
		ls_almacen 	= dw_2.object.almacen	[ll_j]
		ls_cod_art 	= dw_2.object.cod_art	[ll_j]
		
		// Obtengo el precio pactado
		//create or replace function usf_cmp_prec_compra_artic(
      // 	asi_cod_art         in articulo.cod_art%TYPE,
      // 	asi_proveedor       in proveedor.proveedor%type,
      // 	adi_fec_reg         in orden_compra.fec_registro%type,
      // 	asi_almacen         in almacen.almacen%TYPE,
      //		asi_moneda          in moneda.cod_moneda%type
		//) return number is
		
		SELECT usf_cmp_prec_compra_artic(:ls_cod_art, :ls_proveedor, :ld_fec_reg, 
			:ls_almacen, :ls_moneda)
			INTO :ldc_precio
		FROM dual ;
		
		IF IsNull(ldc_precio) then ldc_precio = 0
		
  		ldw_detail.object.cod_Art     	[ll_row] = dw_2.object.cod_art			[ll_j]
		ldw_detail.object.desc_art    	[ll_row] = dw_2.object.desc_art			[ll_j]
		ldw_detail.object.Und		   	[ll_row] = dw_2.object.und					[ll_j]				
		ldw_detail.object.cod_origen  	[ll_row] = gnvo_app.is_origen
		ldw_detail.object.tipo_mov	 		[ll_row] = ls_oper_ing_oc
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.cantidad			[ll_j]
		ldw_detail.object.fec_proyect		[ll_row] = dw_2.object.fec_requerida	[ll_j]
		ldw_detail.object.oper_sec			[ll_row] = dw_2.object.oper_sec			[ll_j]
		ldw_detail.object.origen_ref		[ll_row] = dw_2.object.cod_origen		[ll_j]
		ldw_detail.object.tipo_ref			[ll_row] = ls_doc_prog
		ldw_detail.object.referencia  	[ll_row] = dw_2.object.nro_programa		[ll_j]
		ldw_detail.object.item_ref 		[ll_row] = dw_2.object.nro_item			[ll_j]
		ldw_detail.object.org_amp_ref  	[ll_row] = dw_2.object.org_amp_ot_ref	[ll_j]
		ldw_detail.object.nro_amp_ref		[ll_row] = dw_2.object.nro_amp_ot_ref	[ll_j]
		ldw_detail.object.saldo_almacen	[ll_row] = dw_2.object.saldo_almacen	[ll_j]
		ldw_detail.object.cant_pendiente	[ll_row] = dw_2.object.cant_requerida	[ll_j]
		ldw_detail.object.dias_reposicion[ll_row] = li_dias_rep
		ldw_detail.object.dias_rep_import[ll_row] = li_dias_rep_imp
		ldw_detail.object.cod_usr			[ll_row] = gnvo_app.is_user
		ldw_detail.object.precio_unit		[ll_row] = ldc_precio
		ldw_detail.object.almacen			[ll_row] = ls_almacen
		
		if is_flag_cntrl_fondos = '1' then
			//Si esta activo el flag entonces coloco el Fondo de COmpras
			//deacuerdo al OT_ADM
			ls_ot_adm  	= dw_2.object.ot_adm		[ll_j]
			li_year		= Year(Date(dw_2.object.fec_requerida[ll_j]))
			
			select cencos, cnta_prsp
				into :ls_cencos, :ls_cnta_prsp
			from compra_fondo_ot_adm
			where ot_adm = :ls_ot_adm
			  and ano = :li_year;
			
			if SQLCA.SQLCode <> 100 then
				ldw_detail.object.cencos		[ll_row] = ls_cencos
				ldw_detail.object.cnta_prsp	[ll_row] = ls_cnta_prsp
			end if
		end if
		
		//Calculo del impuesto
		ldc_cant_proyect = Dec(dw_2.object.cantidad[ll_j])
		ldc_porc_impuesto = dec(ldw_detail.object.porc_impuesto[ll_row])
		ldc_impuesto 		= ldc_precio * ldc_cant_proyect * ldc_porc_impuesto / 100
		ldw_detail.object.impuesto [ll_row] = ldc_impuesto
		
		ldw_detail.ii_update = 1
		
	end if
Next

return 1
end function

public function integer of_opcion6 ();Long 			ll_Row_mst, ll_j, ll_row
string 		ls_moneda, ls_mon_dw
decimal		ldc_precio, ldc_prec_old
Date 			ld_fecha
u_dw_abc 	ldw_master, ldw_detail



ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

ll_row_mst = ldw_master.getrow()

if ll_row_mst = 0 then
	MessageBox("Error", "No tiene Cabecera la Orden de Servicio") 
	return 0
end if

ls_mon_dw = ldw_master.object.cod_moneda [ll_row_mst]

if ls_mon_dw = '' or IsNull(ls_mon_dw) then
	MessageBox('Error', 'No ha indicado una moneda en la Orden de Servicio')
	return 0
end if

ls_moneda = dw_master.object.cod_moneda[dw_master.GetRow()]
if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Error', 'No ha indicado una moneda en la Solicitud de Servicio')
	return 0
end if

// Verifica que no pueda aceptar mas de un documento
if ldw_master.object.sol_cod_origen	[ll_row_mst] <> dw_2.object.cod_origen		[1] or &
	ldw_master.object.nro_sol_serv	[ll_row_mst] <> dw_2.object.nro_sol_serv	[1] then
	
	MessageBox("Error", "no puede seleccionar otro documento") 
	
	return 0
end if		

For ll_j = 1 to dw_2.RowCount()
	
	ll_row = ldw_detail.event ue_insert()
	
	ldc_precio 	= Dec(dw_2.object.precio[ll_j])
	ld_fecha		= DAte(dw_2.object.fec_requerida[ll_j])

	if ll_row > 0 then	
		
		ldc_precio = of_conv_mon( ldc_precio, ls_moneda, ls_mon_dw, ld_fecha )
		
		ldw_detail.object.cod_origen		[ll_row] = gnvo_app.is_origen
		ldw_detail.object.descripcion		[ll_row] = dw_2.object.descripcion	[ll_j]
		ldw_detail.object.fec_proyect		[ll_row] = dw_2.object.fec_requerida[ll_j]
		ldw_detail.object.cnta_prsp		[ll_row] = dw_2.object.cnta_prsp		[ll_j]
		ldw_detail.object.importe			[ll_row] = ldc_precio
		ldw_detail.object.cencos			[ll_row] = dw_master.object.cencos	[dw_master.getrow()]
		ldw_master.object.sol_cod_origen	[ll_row] = dw_2.object.cod_origen	[ll_j]
		ldw_master.object.nro_sol_serv	[ll_row] = dw_2.object.nro_sol_serv	[ll_j]
	end if
Next

return 1
end function

public function decimal of_conv_mon (decimal adc_importe, string as_moneda1, string as_moneda2, date ad_fecha);//create or replace function usf_fl_conv_mon(
//      	ani_importe in number,
//       asi_mon1		in varchar2,
//       asi_mon2		in varchar2,
//       adi_fecha		in date
//) return number is

String	ls_mensaje
DEcimal	ldc_precio

DECLARE usf_fl_conv_mon PROCEDURE FOR
	usf_fl_conv_mon( :adc_importe,
						  :as_moneda1,
						  :as_moneda2,
						  :ad_fecha);
EXECUTE usf_fl_conv_mon;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION usf_fl_conv_mon: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(ldc_precio)
	return ldc_precio
END IF

FETCH usf_fl_conv_mon INTO :ldc_precio;
CLOSE usf_fl_conv_mon;

return ldc_precio

end function

public function integer of_opcion14 ();Long 		ll_row_mas, ll_row, ll_j, ll_count
Long 		ll_find
String	ls_cadena, ls_req
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

ll_row_mas = ldw_master.GetRow()
if ll_row_mas = 0 then return 0

For ll_j = 1 to dw_2.RowCount()
	ls_Cadena = "org_amp_ot_ref = '" + string(dw_2.object.cod_origen[ll_j]) + "' and " &
				 + "nro_amp_ot_ref = " + string(dw_2.object.nro_mov[ll_j])
				 
	ll_find = ldw_detail.find( ls_cadena, 1, ldw_detail.RowCount())
	if ll_find > 0 then
		ls_req = string(dw_2.object.cod_origen[ll_j]) + string(dw_2.object.nro_mov[ll_j])
		MessageBox('Aviso', 'El requerimiento ' + ls_req + ' ya esta en el Programa de Compras')
		return 0
	end if
	
	ll_row = ldw_detail.event dynamic ue_insert()
	
	if ll_row > 0 then	
		ldw_detail.object.cod_art			[ll_row] = dw_2.object.cod_art			[ll_j]
		ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art			[ll_j]
		ldw_detail.object.und				[ll_row] = dw_2.object.und					[ll_j]
		ldw_detail.object.fec_requerida	[ll_row] = dw_2.object.fec_proyect		[ll_j]
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.cant_pendiente	[ll_j]
		ldw_detail.object.almacen			[ll_row] = dw_2.object.almacen			[ll_j]
		ldw_detail.object.flag_prioridad	[ll_row] = '2'
		ldw_detail.object.org_amp_ot_ref	[ll_row] = dw_2.object.cod_origen		[ll_j]
		ldw_detail.object.nro_amp_ot_ref	[ll_row] = dw_2.object.nro_mov			[ll_j]
		ldw_detail.object.nro_doc			[ll_row] = dw_2.object.nro_orden			[ll_j]
		ldw_detail.ii_update = 1
	end if
	
Next

return 1
end function

public function integer of_opcion15 ();Long 		ll_row_mas, ll_row, ll_j, ll_count
Long 		ll_find, ll_item_os
String	ls_org_os, ls_nro_os
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

ll_row_mas = ldw_master.GetRow()
if ll_row_mas = 0 then return 0

ls_nro_os 	= ldw_master.object.nro_os				[ll_row_mas]
ls_org_os 	= ldw_master.object.cod_origen		[ll_row_mas]
ll_item_os	= Long(ldw_master.object.nro_item	[ll_row_mas])

For ll_j = 1 to dw_2.RowCount()
				 
	ll_row = ldw_detail.event dynamic ue_insert()
	
	if ll_row > 0 then	
		ldw_detail.object.org_amp			[ll_row] = dw_2.object.cod_origen		[ll_j]
		ldw_detail.object.nro_amp			[ll_row] = dw_2.object.nro_mov			[ll_j]
		ldw_detail.object.org_os			[ll_row] = ls_org_os
		ldw_detail.object.nro_os			[ll_row] = ls_nro_os
		ldw_detail.object.item_os			[ll_row] = ll_item_os
		ldw_detail.object.cod_art			[ll_row] = dw_2.object.cod_art			[ll_j]
		ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art			[ll_j]
		ldw_detail.object.und				[ll_row] = dw_2.object.und					[ll_j]
		ldw_detail.object.tipo_doc			[ll_row] = dw_2.object.tipo_doc			[ll_j]
		ldw_detail.object.nro_doc			[ll_row] = dw_2.object.nro_doc			[ll_j]
		ldw_detail.object.flag_estado		[ll_row] = dw_2.object.flag_estado		[ll_j]
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.cant_proyect		[ll_j]
		ldw_detail.object.precio_unit		[ll_row] = dw_2.object.precio_unit		[ll_j]
		ldw_detail.object.almacen			[ll_row] = dw_2.object.almacen			[ll_j]
		ldw_detail.ii_update = 1
		
	end if
	ldw_detail.GroupCalc()
	
Next

return 1
end function

public function integer of_opcion7 ();Long 		ll_row, ll_i
String 	ls_find, ls_cod_art

u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

For ll_i = 1 to dw_2.RowCount()
	ls_cod_art = dw_2.object.cod_art	[ll_i]
	ls_find = "cod_art = '" + ls_cod_art + "'"
	ll_row = ldw_detail.Find(ls_find, 1, ldw_detail.RowCount())
	if ll_row = 0 then
		ll_row = ldw_detail.event ue_insert() 
		if ll_row > 0 then
			ldw_detail.object.cant_cotizada   [ll_row] = 0
		end if
	end if
	if ll_row > 0 then
		ldw_detail.object.cod_Art     	 [ll_row] = dw_2.object.cod_art			[ll_i]
		ldw_detail.object.desc_art    	 [ll_row] = dw_2.object.desc_art			[ll_i]
		ldw_detail.object.Und		    	 [ll_row] = dw_2.object.und				[ll_i]
		ldw_detail.object.cod_sub_cat   	 [ll_row] = dw_2.object.cod_sub_cat		[ll_i]
		ldw_detail.object.desc_sub_cat    [ll_row] = dw_2.object.desc_sub_cat	[ll_i]
		ldw_detail.object.cant_cotizada   [ll_row] = Dec(ldw_detail.object.cant_cotizada   [ll_row]) + Dec(dw_2.object.cantidad	[ll_i])				
		
	end if
Next

ldw_detail.SetSort("cod_art A")
ldw_detail.Sort()

return 1
end function

public function integer of_opcion4 ();Long		ll_i, ll_row
String	ls_cod_art, ls_find
u_dw_abc ldw_detail

ldw_detail = ist_datos.dw_d

For ll_i = 1 to dw_2.RowCount()		
	ls_cod_art 	= dw_2.object.cod_art [ll_i]
	ls_find		= "cod_art = '" + ls_cod_art + "'"
	
	ll_row = ldw_detail.Find(ls_find, 1, ldw_detail.RowCount())
	
	if ll_row = 0 then
		ll_row = ldw_detail.event ue_insert()
		if ll_row > 0 then
			ldw_detail.object.cant_cotizada [ll_row] = 0
		end if
	end if
	
	ldw_detail.object.cod_Art			[ll_row] = ls_cod_art
	ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art		[ll_i]
	ldw_detail.object.Und				[ll_row] = dw_2.object.und				[ll_i]				
	ldw_detail.object.cod_sub_cat		[ll_row] = dw_2.object.cod_sub_cat	[ll_i]
	ldw_detail.object.desc_sub_cat	[ll_row] = dw_2.object.desc_sub_cat	[ll_i]
	ldw_detail.object.cant_cotizada	[ll_row] = Dec(ldw_detail.object.cant_cotizada[ll_row]) + Dec(dw_2.object.cant_pendiente[ll_i])
Next

ldw_detail.SetSort("cod_art A")
ldw_detail.Sort()

return 1
end function

public function integer of_opcion17 ();// Generación de OC automáticas a partir de OTs
String 	ls_null, ls_find, ls_org_amp, ls_cod_art, ls_almacen, &
			ls_ot_adm, ls_cencos, ls_cnta_prsp
Long		ll_j, ll_nro_amp, ll_find, ll_row
Integer	li_year
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

SetNull(ls_null)

For ll_j = 1 to dw_2.RowCount()
	ls_org_amp = string(dw_2.object.cod_origen [ll_j])
	ll_nro_amp = Long(dw_2.object.nro_mov [ll_j])
	
	ls_find = "org_amp_ref = '" + ls_org_amp + "' and nro_amp_ref = " &
		+ string(ll_nro_amp)
	
	ll_row = ldw_detail.Find(ls_find, 1, ldw_detail.RowCount())
	if ll_row > 0 then
		MessageBox('Aviso', 'El requerimiento ' + ls_org_amp &
			+ string(ll_nro_amp) + " ya ha sido seleccionado, por favor verifique")
		return 0
	end if
	
	ll_row = ldw_detail.event dynamic ue_insert()
	
	if ll_row > 0 then	
		ls_cod_art = dw_2.object.cod_art [ll_j]
		ls_almacen = dw_2.object.almacen	[ll_j]
		
		if ist_datos.w1.dynamic function of_set_articulo(ls_cod_art, ls_almacen, ll_row) = false then
			ldw_detail.DeleteRow(ll_row)
		end if
		
		ldw_detail.object.fec_proyect		[ll_row] = dw_2.object.fec_proyect		[ll_j]
		ldw_detail.object.cod_art			[ll_row] = dw_2.object.cod_art			[ll_j]
		ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art			[ll_j]
		ldw_detail.object.und				[ll_row] = dw_2.object.und					[ll_j]
		ldw_detail.object.oper_sec			[ll_row] = dw_2.object.oper_sec			[ll_j]
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.cant_pendiente	[ll_j]
		ldw_detail.object.cant_pendiente	[ll_row] = dw_2.object.cant_pendiente	[ll_j]
		ldw_detail.object.origen_ref		[ll_row] = dw_2.object.origen_ref		[ll_j]
		ldw_detail.object.tipo_ref			[ll_row] = dw_2.object.tipo_doc			[ll_j]		
		ldw_detail.object.nro_ref			[ll_row] = dw_2.object.nro_orden			[ll_j]
		ldw_detail.object.org_amp_ref		[ll_row] = dw_2.object.cod_origen		[ll_j]
		ldw_detail.object.nro_amp_ref		[ll_row] = dw_2.object.nro_mov			[ll_j]
				
		if is_flag_cntrl_fondos = '1' then
			//Si esta activo el flag entonces coloco el Fondo de COmpras
			//deacuerdo al OT_ADM
			ls_ot_adm  	= dw_2.object.ot_adm		[ll_j]
			li_year		= Year(Date(dw_2.object.fec_proyect[ll_j]))
			
			select cencos, cnta_prsp
				into :ls_cencos, :ls_cnta_prsp
			from compra_fondo_ot_adm
			where ot_adm = :ls_ot_adm
			  and ano = :li_year;
			
			if SQLCA.SQLCode <> 100 then
				ldw_detail.object.cencos		[ll_row] = ls_cencos
				ldw_detail.object.cnta_prsp	[ll_row] = ls_cnta_prsp
			end if
		end if

		ldw_detail.ii_update = 1		
		
	end if
	
Next

return 1
end function

public function integer of_evalua_cod (string as_cod);/*
  Funcion: 		wf_evalua_cod
  Objetivo: 	evaluar si codigo tiene cotizacion vigente
  Parametro:	as_cod, codigo de articulo 
*/
String ls_gan
Long ll_count
date ldt_hoy

ldt_hoy = date(TODAY())
ls_gan = '1'

ll_count = 0
Select count( c2.cod_art) 
  into :ll_count 
  from cotizacion_provee 				c1, 
  		 cotizacion_provee_bien_det 	c2
 Where c1.cod_origen = c2.cod_origen 
   and c1.nro_cotiza = c2.nro_cotiza 
	and c2.flag_ganador = :ls_gan 
	and c2.cod_art = :as_cod 
	and c1.fec_vigencia >= :ldt_hoy;  
if ll_count > 0 then
	return( wf_verifica_dup(as_cod))
else
	Messagebox( "Atencion", "Articulo " + as_cod + " no tiene cotizacion vigente", Exclamation!)
	return 0
end if
end function

public function integer of_opcion8 ();//Generación de una OC automática jalando datos de un Programa de compras
String 		ls_null, ls_doc_prog, ls_nro_prog, ls_cod_art, ls_almacen, ls_find, &
				ls_org_amp, ls_ot_adm, ls_cencos, ls_cnta_prsp
Long			ll_row, ll_j, ll_item_prog, ll_nro_amp
Integer		li_year
u_dw_abc  	ldw_master, ldw_detail

SetNull(ls_null)

Select tipo_doc_prog_cmp
	into :ls_doc_prog
from logparam 
where reckey = '1';
		
if isnull( ls_doc_prog ) or trim( ls_doc_prog ) = '' then 
	Messagebox( "Error","Definir Documento Programa de Compras en LogParam", Exclamation!)
	return 0
end if
		
ldw_master = ist_datos.dw_m     	//Cabecera de la Orden de Compra
ldw_detail = ist_datos.dw_d		//Detalle de la Orden de Compra

For ll_j = 1 to dw_2.RowCount()
	ls_nro_prog 	= dw_2.object.nro_programa [ll_j]
	ll_item_prog	= Long(dw_2.object.nro_item		 [ll_j])
	ls_org_amp		= dw_2.object.org_amp_ot_ref[ll_j]
	ll_nro_amp		= Long(dw_2.object.nro_amp_ot_ref[ll_j])
	ls_cod_art 		= dw_2.object.cod_art[ll_j]
	ls_almacen 		= dw_2.object.almacen[ll_j]
	
	ls_find = "tipo_ref = '" + ls_doc_prog + "' and nro_ref = '" &
			  + ls_nro_prog + "' and item_ref = " + string(ll_item_prog)
	
	ll_row = ldw_detail.find( ls_find, 1, ldw_detail.RowCount())
	if ll_row > 0 then
		MessageBox('Aviso', 'Item de Programa ya esta seleccionado. ' &
					+ 'Nro Programa: ' + ls_nro_prog + ', nro de item: ' &
					+ string(ll_item_prog))
		return 0
	end if
	
	ls_find = "org_amp_ref = '" + ls_org_amp + "' and nro_amp_ref = " &
			  + string(ll_nro_amp)
	
	ll_row = ldw_detail.find( ls_find, 1, ldw_detail.RowCount())
	if ll_row > 0 then
		MessageBox('Aviso', 'Nro de Requerimiento ya fue seleccionado. ' &
					+ 'Nro Requerimiento: ' + ls_org_amp+ string(ll_nro_amp))
		return 0
	end if	

	ll_row = ldw_detail.event ue_insert()
			
	if ll_row > 0 then
		
		if ist_datos.w1.dynamic function of_set_articulo(ls_cod_art, ls_almacen, ll_row) = false then
			ldw_detail.deleterow( ll_row )
			return 0
		end if
		
  		ldw_detail.object.cod_Art     	[ll_row] = dw_2.object.cod_art			[ll_j]
		ldw_detail.object.desc_art    	[ll_row] = dw_2.object.desc_art			[ll_j]
		ldw_detail.object.Und		   	[ll_row] = dw_2.object.und					[ll_j]				
		ldw_detail.object.cod_origen  	[ll_row] = gnvo_app.is_origen
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.cantidad			[ll_j]
		ldw_detail.object.fec_proyect		[ll_row] = dw_2.object.fec_requerida	[ll_j]
		ldw_detail.object.oper_sec			[ll_row] = dw_2.object.oper_sec			[ll_j]
		ldw_detail.object.origen_ref		[ll_row] = dw_2.object.cod_origen		[ll_j]
		ldw_detail.object.tipo_ref			[ll_row] = ls_doc_prog
		ldw_detail.object.nro_ref 			[ll_row] = dw_2.object.nro_programa		[ll_j]
		ldw_detail.object.item_ref 		[ll_row] = dw_2.object.nro_item			[ll_j]
		ldw_detail.object.org_amp_ref  	[ll_row] = dw_2.object.org_amp_ot_ref	[ll_j]
		ldw_detail.object.nro_amp_ref		[ll_row] = dw_2.object.nro_amp_ot_ref	[ll_j]
		ldw_detail.object.cant_pendiente	[ll_row] = dw_2.object.cant_requerida	[ll_j]
		
		if is_flag_cntrl_fondos = '1' then
			//Si esta activo el flag entonces coloco el Fondo de COmpras
			//deacuerdo al OT_ADM
			ls_ot_adm  	= dw_2.object.ot_adm		[ll_j]
			li_year		= Year(Date(dw_2.object.fec_requerida[ll_j]))
			
			select cencos, cnta_prsp
				into :ls_cencos, :ls_cnta_prsp
			from compra_fondo_ot_adm
			where ot_adm = :ls_ot_adm
			  and ano = :li_year;
			
			if SQLCA.SQLCode <> 100 then
				ldw_detail.object.cencos		[ll_row] = ls_cencos
				ldw_detail.object.cnta_prsp	[ll_row] = ls_cnta_prsp
			end if
		end if
		
		ldw_detail.ii_update = 1
		
	end if
Next

return 1
end function

public function integer of_opcion19 ();Long		ll_i, ll_row
String	ls_cod_art, ls_find
u_dw_abc ldw_detail

ldw_detail = ist_datos.dw_d

For ll_i = 1 to dw_2.RowCount()		
	ls_cod_art 	= dw_2.object.cod_art [ll_i]
	ls_find		= "cod_art = '" + ls_cod_art + "'"
	
	ll_row = ldw_detail.Find(ls_find, 1, ldw_detail.RowCount())
	
	if ll_row = 0 then
		ll_row = ldw_detail.event ue_insert()
		if ll_row > 0 then
			ldw_detail.object.cant_cotizada [ll_row] = 0
		end if
	end if
	
	ldw_detail.object.cod_Art			[ll_row] = ls_cod_art
	ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art		[ll_i]
	ldw_detail.object.Und				[ll_row] = dw_2.object.und				[ll_i]				
	ldw_detail.object.cod_sub_cat		[ll_row] = dw_2.object.cod_sub_cat	[ll_i]
	ldw_detail.object.desc_sub_cat	[ll_row] = dw_2.object.desc_sub_cat	[ll_i]	
   ldw_detail.object.cant_cotizada	[ll_row] = Dec(ldw_detail.object.cant_cotizada[ll_row])
	//ldw_detail.object.cant_cotizada	[ll_row] = Dec(ldw_detail.object.cant_cotizada[ll_row]) + Dec(dw_2.object.cant_pendiente[ll_i])
Next

ldw_detail.SetSort("cod_art A")
ldw_detail.Sort()

return 1
end function

public function integer of_opcion20 ();Long 			ll_Row_mst, ll_j, ll_row
string 		ls_moneda, ls_mon_dw
decimal		ldc_precio, ldc_prec_old
Date 			ld_fecha
u_dw_abc 	ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

ll_row_mst = ldw_master.getrow()

if ll_row_mst = 0 then
	MessageBox("Error", "La Conformidad de OS no Tiene Cabecera") 
	return 0
end if

ldw_master.object.nro_os      [ll_row_mst] = dw_master.object.nro_os    [dw_master.GetRow()]
ldw_master.object.origen_os   [ll_row_mst] = dw_master.object.origen_os [dw_master.GetRow()]

For ll_j = 1 to dw_2.RowCount()
	
	ll_row = ldw_detail.event ue_insert()

	if ll_row > 0 then		
		
		ldw_detail.object.origen_os	[ll_row] = dw_master.object.origen_os	[dw_master.GetRow()]
		ldw_detail.object.nro_os		[ll_row] = dw_master.object.nro_os		[dw_master.GetRow()]
	   ldw_detail.object.item_os     [ll_row] = dw_2.object.nro_item 		   [ll_j]
	   ldw_detail.object.glosa       [ll_row] = dw_2.object.descripcion 		[ll_j]
	   ldw_detail.object.oper_sec    [ll_row] = dw_2.object.oper_sec 		 	[ll_j]
	   ldw_detail.object.nro_orden   [ll_row] = dw_2.object.nro_orden 		[ll_j]
	   ldw_detail.object.cod_moneda  [ll_row] = dw_2.object.cod_moneda 		[ll_j]
	   ldw_detail.object.importe     [ll_row] = dw_2.object.importe 		 	[ll_j]
		ldw_detail.ii_update = 1
		
	end if
Next
return 1
end function

public function boolean of_opcion21 ();// Transfiere campos 

String      ls_almacen, ls_tipo_mov, ls_prov, ls_nombre, ls_null, ls_cod_art, &
				ls_cencos, ls_cnta_prsp, ls_org_amp_ref, ls_flag_saldo_libre
Long        ll_j, ll_row, ll_nro_amp_ref  
Date  		ld_fecha
Decimal		ldc_precio
u_dw_abc 	ldw_master, ldw_detail

if dw_2.rowcount() = 0 then return false

SetNull(ls_null)

// Asigna datos a dw master
ldw_master = ist_datos.dw_or_m
ldw_detail = ist_datos.dw_or_d

ll_row = ldw_master.getrow()
if ll_row = 0 then return false

ldw_master.object.origen_refer[ll_row]  = dw_master.object.cod_origen[dw_master.getrow()]
ldw_master.object.tipo_refer	[ll_row]  = is_doc_oc
ldw_master.object.nro_refer	[ll_row]  = dw_master.object.nro_doc[dw_master.getrow()]
ldw_master.object.proveedor	[ll_row]  = dw_master.object.proveedor[dw_master.getrow()]
		
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
		
		ldw_detail.Object.origen_mov_proy	[ll_row] = dw_2.Object.cod_origen	[ll_j]
		ldw_detail.Object.nro_mov_proy 	 	[ll_row] = dw_2.Object.nro_mov 	 	[ll_j]
		ldw_detail.Object.flag_estado  	 	[ll_row] = '1'								
		ldw_detail.Object.cod_art      	 	[ll_row] = dw_2.Object.cod_art	 	[ll_j]
		ldw_detail.Object.cant_procesada 	[ll_row] = dw_2.object.cantidad		[ll_j]
		ldw_detail.Object.precio_unit  	 	[ll_row] = ldc_precio  
		ldw_detail.Object.decuento		 		[ll_row] = 0 
		ldw_detail.Object.impuesto		 		[ll_row] = dw_2.Object.impuesto	   [ll_j]
		ldw_detail.Object.cod_moneda		 	[ll_row] = is_soles  
		ldw_detail.Object.desc_art 		 	[ll_row] = dw_2.Object.desc_art    	[ll_j]
		ldw_detail.Object.und				 	[ll_row] = dw_2.Object.und				[ll_j]	
		ldw_detail.Object.und2				 	[ll_row] = dw_2.Object.und2			[ll_j]
		ldw_detail.Object.flag_und2		 	[ll_row] = dw_2.Object.flag_und2			[ll_j]
		ldw_detail.Object.factor_conv_und 	[ll_row] = dw_2.Object.factor_conv_und	[ll_j]
		ldw_detail.Object.costo_prom_dol	 	[ll_row] = dw_2.Object.costo_prom_dol[ll_j]	
		ldw_detail.Object.costo_prom_sol	 	[ll_row] = dw_2.Object.costo_prom_sol[ll_j]	
		ldw_detail.Object.flag_saldo_libre 	[ll_row] = ls_flag_saldo_libre
		ldw_detail.Object.centro_benef 		[ll_row] = dw_2.Object.centro_benef [ll_j]	

		// Si se contabiliza entonces debo ponerle una matriz
		if ist_datos.string1 = '1' then						
			ls_cod_Art = dw_2.Object.cod_art	 	[ll_j]
			
			if ist_datos.flag_matriz_contab = 'P' then
				ldw_detail.object.matriz[ll_row] = f_asigna_matriz(ls_tipo_mov, ls_null, ls_null)					
			elseif ist_datos.flag_matriz_contab = 'S' then
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

public function decimal of_precio_soles (decimal adc_precio, string as_moneda, decimal adc_descuento, date ad_fecha);/*
   Funcion que devuelve el precio unitario en soles
*/

Decimal ldc_precio
String ls_mensaje

if as_moneda = is_dolares then
//	create or replace function usf_fl_conv_mon(
//      	ani_importe in number,
//        asi_mon1		in varchar2,
//        asi_mon2		in varchar2,
//        adi_fecha		in date
//   ) return number is
	
	ldc_precio = adc_precio - adc_descuento
	
	DECLARE proc1 PROCEDURE FOR 
		usf_fl_conv_mon(:ldc_precio, :as_moneda, :is_soles, :ad_fecha) ;
	EXECUTE proc1;		
	
	if sqlca.sqlcode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		messagebox( "Error usf_fl_conv_mon", ls_mensaje)
		return 0
	end if
	
	Fetch proc1 into :ldc_precio;	
	close proc1;
else
	ldc_precio = adc_precio - adc_descuento
end if

IF ldc_precio < 0 then
	Messagebox( "Error", "Precio no debe ser negativo, revisar")
	return 0
end if
return ldc_precio
end function

public subroutine of_insert_art_oc (string as_orden_compra);Long   ll_fdw_d,j,ll_found
String ls_soles, ls_dolares,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
		 ls_item , ls_moneda_ord ,ls_flag_cntrl_alm
Decimal {2} ldc_descuento

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 

//* Tipo de Documento Orden de Compra *//
SELECT doc_oc
  INTO :ls_tipo_doc
  FROM logparam
 WHERE (reckey = '1');
//***********************************// 
ls_moneda_ord = ist_datos.dw_m.object.cod_moneda [1] //registro de cabecera a facturar
//datos para controlar almacen
ls_flag_cntrl_alm = ist_datos.dw_m.object.flag_cntr_almacen [1] 

if isnull(ls_flag_cntrl_alm) or trim(ls_flag_cntrl_alm) = '' then
	ls_flag_cntrl_alm = '1'
end if


FOR j=1 TO dw_2.Rowcount()
	 
	 ls_cod_art    = dw_2.object.cod_art    [j] 
	 ls_cod_moneda = dw_2.object.cod_moneda [j] 
	 

	 
	 
	 ls_expresion  = 'cod_art ='+"'"+ls_cod_art+"'"
	 ll_found      = ist_datos.dw_d.find(ls_expresion,1,ist_datos.dw_d.rowcount())
	 

	    IF ist_datos.dw_d.triggerevent ('ue_insert') > 0 THEN
			 if ls_flag_cntrl_alm = '1' then
          	 ll_fdw_d = w_fi304_cnts_x_pagar.tab_1.tabpage_1.dw_ctas_pag_det.il_row
				 /*Datos del Registro Modificado*/
			 	 w_fi304_cnts_x_pagar.ib_estado_prea = TRUE
		       /**/	
				 w_fi304_cnts_x_pagar.is_orden_compra = as_orden_compra 
			 else
				 //ll_fdw_d = w_fi358_cntas_pagar_sin_control.tab_1.tabpage_1.dw_ctas_pag_det.il_row
				 
 				 /*Datos del Registro Modificado*/
			 	 //w_fi358_cntas_pagar_sin_control.ib_estado_prea = TRUE
		       /**/	
				 //w_fi358_cntas_pagar_sin_control.is_orden_compra = as_orden_compra 
			 end if
			 
			 		 
			 
	 	         
			 ldc_descuento = dw_2.Object.descuento[j]
			 IF Isnull(ldc_descuento) THEN ldc_descuento = 0.00

			 
		    IF ls_cod_moneda = ls_moneda_ord     THEN
			    ist_datos.dw_d.Object.importe [ll_fdw_d] = Round((dw_2.Object.precio_unit [j] - ldc_descuento) * dw_2.Object.cant_pendiente [j],2)
			 ELSEIF ls_cod_moneda = ls_soles      THEN
				 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(Round((dw_2.Object.precio_unit [j] - ldc_descuento) / ist_datos.db1,6) * dw_2.Object.cant_pendiente [j],2)
			 ELSEIF ls_cod_moneda = ls_dolares    THEN
				 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(Round((dw_2.Object.precio_unit [j] - ldc_descuento) * ist_datos.db1,6) * dw_2.Object.cant_pendiente [j],2)					
			 END IF
			 

			 ist_datos.dw_d.Object.cod_art          [ll_fdw_d] = dw_2.Object.cod_art 		  [j]
			 ist_datos.dw_d.Object.descripcion      [ll_fdw_d] = dw_2.Object.nom_articulo   [j]
			 ist_datos.dw_d.Object.cantidad         [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_d.Object.cencos				 [ll_fdw_d] = dw_2.Object.cencos			  [j]
			 ist_datos.dw_d.Object.cnta_prsp			 [ll_fdw_d] = dw_2.Object.cnta_prsp		  [j]
			 ist_datos.dw_d.Object.flag_hab			 [ll_fdw_d] = '1'
			 
			 //
			 
			 ist_datos.dw_d.Object.centro_benef		 [ll_fdw_d] = dw_2.Object.centro_benef	  [j]
			 
			 
			 
			 

			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
			 
			 if ls_flag_cntrl_alm = '1' then
				 w_fi304_cnts_x_pagar.wf_generacion_imp (ls_item)	
			 else
				 //w_fi358_cntas_pagar_sin_control.wf_generacion_imp (ls_item)	
			 end if	
			
			 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ls_moneda_ord
			 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
			 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
			 ist_datos.titulo = 's'	
		 END IF	
//	 END IF	
NEXT


end subroutine

public function boolean of_opcion22 ();Long 		ll_row_master, ll_found, ll_row
String	ls_orden_compra, ls_cod_origen, ls_cod_moneda, &
			ls_forma_pago, ls_obs, ls_moneda_fap, ls_fpago_fap, &
			ls_obs_fap, ls_flag_cntr, ls_tipo_doc, ls_expresion
			
ll_row_master   = dw_master.Getrow()
ls_orden_compra = dw_master.Object.nro_oc 	  [ll_row_master]
ls_cod_origen   = dw_master.Object.cod_origen  [ll_row_master]
ls_cod_moneda	 = dw_master.Object.cod_moneda  [ll_row_master]
ls_forma_pago	 = dw_master.Object.forma_pago  [ll_row_master] 
ls_obs			 = dw_master.Object.observacion [ll_row_master]

IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
	IF ls_orden_compra <> ist_datos.string2 THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Compra A Diferente a la ya Considerada')
		Return false
	END IF
END IF

IF dw_2.Rowcount() > 0 THEN
	
	/*actualiza datos de factura*/
	ls_moneda_fap = ist_datos.dw_m.object.cod_moneda  [1]
	ls_fpago_fap  = ist_datos.dw_m.object.forma_pago  [1]
	ls_obs_fap    = ist_datos.dw_m.object.descripcion [1]
	ls_flag_cntr  = ist_datos.dw_m.object.flag_cntr_almacen [1]
	
	IF Isnull(ls_flag_cntr) OR Trim(ls_flag_cntr) = '' THEN
		ls_flag_cntr = '1'
	END IF

	
	IF Isnull(ls_moneda_fap) OR Trim(ls_moneda_fap) = '' THEN
		ist_datos.dw_m.object.cod_moneda  [1] = ls_cod_moneda
		ls_moneda_fap = ls_cod_moneda
	END IF
	
	ist_datos.dw_m.object.forma_pago  [1] = ls_forma_pago	
	
	IF Isnull(ls_obs_fap) OR Trim(ls_obs_fap) = '' THEN
		ist_datos.dw_m.object.descripcion [1] = Mid(ls_obs,1,180)	
	END IF
							
	ist_datos.dw_m.Accepttext()
	
	of_insert_art_oc (ls_orden_compra)
	
	//***Selección de tipo de doc Orden de Compra***//
	SELECT doc_oc
	  INTO :ls_tipo_doc
	  FROM logparam
	 WHERE reckey = '1' ;
	//***********************************//
	ist_datos.dw_c.Accepttext()
	
	ls_expresion = 'origen_ref = '+"'"+ls_cod_origen+"'"+'  AND  nro_ref = '+"'"+ls_orden_compra+"'"
	ll_found 	 = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 
	
	IF ll_found = 0 THEN
		IF ist_datos.dw_c.triggerevent ('ue_insert') > 0 THEN
			
			if ls_flag_cntr = '1' then
				ll_row = w_fi304_cnts_x_pagar.tab_1.tabpage_2.dw_ref_x_pagar.il_row
			else
				//ll_row = w_fi358_cntas_pagar_sin_control.tab_1.tabpage_2.dw_ref_x_pagar.il_row
			end if
			
			ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'P'
			ist_datos.dw_c.Object.origen_ref     [ll_row] = ls_cod_origen
			ist_datos.dw_c.Object.tipo_ref	    [ll_row] = ls_tipo_doc
			ist_datos.dw_c.Object.nro_ref		    [ll_row] = ls_orden_compra
			ist_datos.dw_c.Object.tasa_cambio    [ll_row] = ist_datos.db1			
			ist_datos.dw_c.Object.cod_moneda	    [ll_row] = ls_moneda_fap
			ist_datos.dw_c.Object.cod_moneda_det [ll_row] = ls_cod_moneda
			ist_datos.dw_c.Object.flab_tabor	    [ll_row] = '7' //Orden de Compra
			ist_datos.titulo = 's'	
			
		END IF
	END IF

END IF

end function

public function boolean of_opcion23 ();Long 		ll_row_master, ll_found, ll_row
String	ls_orden_serv, ls_cod_origen, ls_cod_moneda, ls_forma_pago, &
			ls_obs, ls_moneda_fap, ls_fpago_fap, ls_obs_fap, ls_flag_cntr, &
			ls_tipo_doc, ls_expresion
			
ll_row_master = dw_master.Getrow()
ls_orden_serv = dw_master.Object.nro_os 	   [ll_row_master]
ls_cod_origen = dw_master.Object.cod_origen  [ll_row_master]
ls_cod_moneda = dw_master.Object.cod_moneda  [ll_row_master]
ls_forma_pago = dw_master.Object.forma_pago  [ll_row_master] 
ls_obs		  = dw_master.Object.descripcion [ll_row_master]				

IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
	IF ls_orden_serv <> ist_datos.string2 THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Servicio Diferente a la ya Considerada')
		Return false
	END IF
END IF

IF dw_2.Rowcount() > 0 THEN
	
	/*actualiza datos de factura*/
	ls_moneda_fap = ist_datos.dw_m.object.cod_moneda  [1]
	ls_fpago_fap  = ist_datos.dw_m.object.forma_pago  [1]
	ls_obs_fap    = ist_datos.dw_m.object.descripcion [1]
	ls_flag_cntr  = ist_datos.dw_m.object.flag_cntr_almacen [1]
	
	
	
	
	IF Isnull(ls_moneda_fap) OR Trim(ls_moneda_fap) = '' THEN
		ist_datos.dw_m.object.cod_moneda  [1] = ls_cod_moneda
		ls_moneda_fap = ls_cod_moneda
	END IF
	
//					IF Isnull(ls_fpago_fap) OR Trim(ls_fpago_fap) = '' THEN
		ist_datos.dw_m.object.forma_pago  [1] = ls_forma_pago	
//					END IF
	
	IF Isnull(ls_obs_fap) OR Trim(ls_obs_fap) = '' THEN
		ist_datos.dw_m.object.descripcion [1] = Mid(ls_obs,1,180)	
	END IF
	
						
	ist_datos.dw_m.Accepttext()
	
	
	of_insert_item_os (ls_orden_serv,ls_cod_moneda)
	
	//***Selección de tipo de doc Orden de Servicio***//
	SELECT doc_os
	  INTO :ls_tipo_doc
	  FROM logparam
	 WHERE reckey = '1' ;
	//***********************************//
	
	ist_datos.dw_c.Accepttext()
	
	ls_expresion = 'origen_ref = '+"'"+ls_cod_origen+"'"+'  AND  nro_ref = '+"'"+ls_orden_serv+"'"
	ll_found 	 = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 
	
	IF ll_found = 0 THEN
		IF ist_datos.dw_c.triggerevent ('ue_insert') > 0 THEN
			
			ll_row = w_fi304_cnts_x_pagar.tab_1.tabpage_2.dw_ref_x_pagar.il_row
			
			ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'P'
			ist_datos.dw_c.Object.origen_ref     [ll_row] = ls_cod_origen
			ist_datos.dw_c.Object.tipo_ref	    [ll_row] = ls_tipo_doc
			ist_datos.dw_c.Object.nro_ref		    [ll_row] = ls_orden_serv
			ist_datos.dw_c.Object.tasa_cambio    [ll_row] = ist_datos.db1			
			ist_datos.dw_c.Object.cod_moneda	    [ll_row] = ls_moneda_fap
			ist_datos.dw_c.Object.cod_moneda_det [ll_row] = ls_cod_moneda
			ist_datos.dw_c.Object.flab_tabor	    [ll_row] = '8' //Orden de Servicio
			ist_datos.titulo = 's'	
			
		END IF
	END IF

END IF

return true


end function

public subroutine of_insert_item_os (string as_orden_os, string as_cod_moneda);Long   ll_fdw_d,j
String ls_soles, ls_dolares,ls_item,ls_moneda_ord
Decimal {2} ldc_descuento

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 

FOR j=1 TO dw_2.Rowcount()
	 
    IF ist_datos.dw_d.triggerevent ('ue_insert') > 0 THEN
        ll_fdw_d = w_fi304_cnts_x_pagar.tab_1.tabpage_1.dw_ctas_pag_det.il_row
		  
		  
		 /*Datos del Registro Modificado*/
		 w_fi304_cnts_x_pagar.ib_estado_prea = TRUE
	    /**/			 
 	    w_fi304_cnts_x_pagar.is_orden_serv = as_orden_os
		  
		 /*moneda cabecera*/
		 ls_moneda_ord = ist_datos.dw_m.object.cod_moneda [1]
		 
		 
 		 ldc_descuento = dw_2.Object.descuento[j]
		 IF Isnull(ldc_descuento) THEN ldc_descuento = 0.00

		 
	    IF as_cod_moneda = ls_moneda_ord THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.importe [j] - ldc_descuento,2)
		 ELSEIF as_cod_moneda = ls_soles      THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round((dw_2.Object.importe [j] - ldc_descuento) / ist_datos.db1,2)	
		 ELSEIF as_cod_moneda = ls_dolares    THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round((dw_2.Object.importe [j] - ldc_descuento ) * ist_datos.db1,2)					
		 END IF
			 

		 ist_datos.dw_d.Object.descripcion     [ll_fdw_d] = dw_2.Object.descripcion    [j]
		 ist_datos.dw_d.Object.cantidad        [ll_fdw_d] = 1
		 ist_datos.dw_d.Object.cencos				[ll_fdw_d] = dw_2.Object.cencos			 [j]
		 ist_datos.dw_d.Object.cnta_prsp			[ll_fdw_d] = dw_2.Object.cnta_prsp		 [j]
		 ist_datos.dw_d.Object.flag_hab			[ll_fdw_d] = '1'		 
		 ist_datos.dw_d.Object.centro_benef		[ll_fdw_d] = dw_2.Object.centro_benef	 [j]
		 //Recalculo de Impuesto				 
		 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
		 w_fi304_cnts_x_pagar.wf_generacion_imp (ls_item)	
			
		 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ls_moneda_ord
		 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
		 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
		 ist_datos.dw_d.Modify("importe.Protect='1~tIf(IsNull(flag_hab),0,1)'")
		 ist_datos.titulo = 's'	
	 END IF	
NEXT


end subroutine

public function boolean of_opcion24 ();Long 		ll_row_master
String 	ls_cod_grmp, ls_cod_origen, ls_cod_moneda, ls_moneda_fap, &
			ls_flag_cntr, ls_tipo_doc

ll_row_master = dw_master.Getrow()
ls_cod_grmp   = dw_master.Object.cod_guia_rec[ll_row_master]
ls_cod_origen = dw_master.Object.origen  		[ll_row_master]
ls_cod_moneda = dw_master.Object.cod_moneda  [ll_row_master]

IF dw_2.Rowcount() > 0 THEN
	/*actualiza datos de factura*/
	ls_moneda_fap = ist_datos.dw_m.object.cod_moneda  [1]
	ls_flag_cntr  = ist_datos.dw_m.object.flag_cntr_almacen [1]
	
	IF Isnull(ls_moneda_fap) OR Trim(ls_moneda_fap) = '' THEN
		ist_datos.dw_m.object.cod_moneda  [1] = ls_cod_moneda
		ls_moneda_fap = ls_cod_moneda
	END IF
	
	ist_datos.dw_m.Accepttext()
	
	ls_tipo_doc = ist_datos.string3 // Asigna el tipo de doc GRMP
	
	of_insert_item_grmp (ls_cod_grmp, ls_cod_moneda, ls_tipo_doc)

END IF

return true
end function

public subroutine of_insert_item_grmp (string as_guia_rec_mp, string as_cod_moneda, string as_tipo_doc_grmp);// Función para ingresar 

Long    	ll_fdw_d, ll_j, ll_row_master, ll_found, ll_row
String  	ls_soles, ls_dolares, ls_item, ls_moneda_ord, ls_origen_ref, &
			ls_nro_ref, ls_expresion, ls_origen_mov, ls_nro_vale, ls_tipo_mov_alm, &
			ls_moneda_fap, ls_cod_moneda
Decimal 	{2} ldc_descuento

u_dw_abc ldw_detail, ldw_master, ldw_refer
dw_2.Accepttext( )

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
FROM logparam   
WHERE reckey = '1'   ;
//***********************************// 

ldw_detail = ist_datos.dw_d	// detalle de cuentas por pagar
ldw_master = ist_datos.dw_m	// master
ldw_refer  = ist_datos.dw_c   // Referencias

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN

ll_row_master = dw_master.Getrow()

ls_origen_ref = dw_master.Object.origen  		[ll_row_master]
ls_nro_ref	  = dw_master.Object.cod_guia_rec[ll_row_master]	

FOR ll_j = 1 TO dw_2.rowcount( )
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
 		ll_fdw_d  = ldw_detail.il_row
		 /*Datos del Registro Modificado*/
		 ist_datos.w1.Dynamic Function wf_estado_prea()
		 /*moneda cabecera*/
		 ls_moneda_ord = ldw_master.object.cod_moneda [1]
	
		 IF as_cod_moneda = ls_moneda_ord THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.saldo[ll_j],2)
		 ELSEIF as_cod_moneda = ls_soles      THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.saldo[ll_j] / ist_datos.db1,2)	
		 ELSEIF as_cod_moneda = ls_dolares    THEN
			 ist_datos.dw_d.Object.importe [ll_fdw_d] = Round(dw_2.Object.saldo[ll_j] * ist_datos.db1,2)					
		 END IF

		 ist_datos.dw_d.Object.cod_art		[ll_fdw_d] = dw_2.object.cod_art		[ll_j]
		 ist_datos.dw_d.Object.descripcion  [ll_fdw_d] = dw_2.Object.desc_art   [ll_j]
		 ist_datos.dw_d.Object.item_ref	   [ll_fdw_d] = dw_2.Object.item   		[ll_j]
		 ist_datos.dw_d.Object.origen_ref	[ll_fdw_d] = ls_origen_ref
		 ist_datos.dw_d.Object.nro_ref	   [ll_fdw_d] = ls_nro_ref		 
		 ist_datos.dw_d.Object.tipo_ref	   [ll_fdw_d] = as_tipo_doc_grmp
		 ist_datos.dw_d.Object.flag_hab		[ll_fdw_d] = '1'		 
		 ist_datos.dw_d.Object.cantidad     [ll_fdw_d] = dw_2.Object.peso_venta [ll_j]
		 ist_datos.dw_d.Object.precio_unit  [ll_fdw_d] = dw_2.Object.precio		[ll_j]

		 //Recalculo de Impuesto				 
		 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
		 ist_datos.w1.dynamic function wf_generacion_imp(ls_item)
		 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ls_moneda_ord
		 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
		 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
		 ist_datos.dw_d.Modify("importe.Protect='1~tIf(IsNull(flag_hab),0,1)'")
		 ist_datos.titulo = 's'	
		 
		IF of_insert_ref_grmp(ll_j) <> 1 THEN 
			messagebox('Aviso', 'Se produjo un error a la hora de agregar la referencia')
			RETURN
		END IF
	 END IF
NEXT

end subroutine

public function integer of_insert_ref_grmp (long al_item);// Función para ingresar las referencias a las GRMP

Long    	ll_j, ll_found, ll_row, ll_row_master
String  	ls_expresion, ls_origen_mov, ls_nro_vale, ls_tipo_mov_alm, &
			ls_moneda_fap, ls_cod_moneda
Decimal 	{2} ldc_descuento

u_dw_abc ldw_detail, ldw_master, ldw_refer

ldw_detail = ist_datos.dw_d	// detalle de cuentas por pagar
ldw_master = ist_datos.dw_m	// master
ldw_refer  = ist_datos.dw_c   // Referencias

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN 0

ll_row_master = dw_master.Getrow()

/**** Ingresar las refencias ****/
ist_datos.dw_c.Accepttext()
ls_moneda_fap 	= ldw_master.object.cod_moneda [1]
ls_cod_moneda 	= dw_master.Object.cod_moneda  [ll_row_master]
ls_origen_mov	= dw_2.object.origen_mov		 [al_item]
ls_nro_vale		= dw_2.object.nro_vale			 [al_item]
ls_tipo_mov_alm= ist_datos.string4

ls_expresion = "origen_ref = '" + ls_origen_mov + "' AND tipo_ref = '" +&
					ls_tipo_mov_alm + "' AND  nro_ref = '" + ls_nro_vale + "'"
ll_found 	 = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 

IF ll_found = 0 THEN // inserta los documentos de referencias
	ll_j = ldw_refer.event ue_insert()
	IF ll_j > 0 THEN	
		ll_row  = ldw_refer.il_row
		ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'P'
		ist_datos.dw_c.Object.origen_ref     [ll_row] = ls_origen_mov
		ist_datos.dw_c.Object.tipo_ref	    [ll_row] = ls_tipo_mov_alm
		ist_datos.dw_c.Object.nro_ref		    [ll_row] = ls_nro_vale 
		ist_datos.dw_c.Object.tasa_cambio    [ll_row] = ist_datos.db1			
		ist_datos.dw_c.Object.cod_moneda	    [ll_row] = ls_moneda_fap
		ist_datos.dw_c.Object.cod_moneda_det [ll_row] = ls_cod_moneda
		ist_datos.dw_c.Object.flab_tabor	    [ll_row] = '3' //Cuentas por Pagar
		ist_datos.dw_c.Object.importe			 [ll_row] = 0.00
		ist_datos.titulo = 's'	
	END IF
END IF

RETURN 1

end function

public function boolean of_opcion25 ();// Salidas x Orden de Venta

Long 		ll_row_master, ll_j, ll_row
string	ls_prov, ls_nombre, ls_tipo_mov, ls_almacen, ls_cod_art, &
			ls_flag_und2, ls_centro_benef, ls_origen
Date		ld_fecha
Decimal	ldc_saldo_act, ldc_precio_unit, ldc_cant, ldc_cant_und2, &
			ldc_factor_conv_und
u_dw_abc ldw_master, ldw_detail

// Asigna datos a ldw master
ldw_master = ist_datos.dw_or_m
ldw_detail = ist_datos.dw_or_d

ll_row_master = ldw_master.GetRow()

// Solo acepta una orden de venta
if ldw_master.object.nro_refer[ll_row_master] <> &
	dw_master.object.nro_ov[dw_master.getrow()] and ldw_detail.rowcount() > 0 then
	messagebox( "Error", "No puede seleccionar otra orden de venta")
	return false
end if

// Asigna datos a dw master				
ldw_master.object.origen_refer [ll_row_master] = dw_master.object.cod_origen[dw_master.getrow()]
ldw_master.object.tipo_refer	 [ll_row_master] = is_doc_ov
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
	// Evalua si tiene saldo, solo salidas
	//ldc_saldo_act 		   = wf_verifica_saldos(ls_cod_art,ls_almacen)
	
	//Obtengo el precio Unit
	select NVL(costo_prom_sol,0), NVL(sldo_total,0)
		into :ldc_precio_unit, :ldc_saldo_act
	from articulo_almacen
	where cod_art = :ls_cod_art
	  and almacen  = :ls_almacen;
	
	IF SQLCA.SQLCode = 100 then
		ldc_saldo_act = 0
		
		select NVL(costo_prom_sol,0)
			into :ldc_precio_unit
		from articulo_almacen
		where cod_art = :ls_cod_art;
		
		if SQLCA.SQLCode = 100 then ldc_precio_unit = 0
		
	end if
	
	If IsNull(ldc_precio_unit) then ldc_precio_unit = 0
	
	ldc_cant = dw_2.object.cantidad[ll_j]
	IF ldc_saldo_act = 0 THEN
		Messagebox('Aviso','Codigo de Articulo Nº '+Trim(ls_cod_art) &
				+ ' No Tiene Saldo Disponible ')
		ldc_cant = 0
	ELSE			
		IF ldc_cant > ldc_saldo_act THEN
			Messagebox('Aviso','No se Puede Atender Toda la Cantidad Proyectada '&
				+ 'Por Exceder el Saldo Actual se tomara ' &
				+ 'en cuenta solo el Saldo Actual = ' + String(ldc_saldo_act))
			ldc_cant = ldc_saldo_act
		END IF
	END IF		
	
	//Aplico el factor de conversion para la segunda unidad si lo hubiera
	ldc_factor_conv_und  = Dec(dw_2.object.factor_conv_und[ll_j])
	ls_flag_und2		   = dw_2.object.flag_und2[ll_j]
	
	if ls_flag_und2 = '1' then
		ldc_cant_und2 = ldc_cant * ldc_factor_conv_und
	else
		ldc_cant_und2 = 0
	end if
	
	
	if ldc_cant > 0 then	// solo cuando tenga stocks			   
		ll_row = ldw_detail.Event Dynamic ue_insert()

		IF ll_row > 0 THEN					
			ldw_detail.Object.cod_art      	 [ll_row] = ls_cod_art
			ldw_detail.Object.flag_estado     [ll_row] = '1'
			ldw_detail.Object.cant_procesada  [ll_row] = ldc_cant
			ldw_detail.Object.cant_proc_und2  [ll_row] = ldc_cant_und2
			ldw_detail.Object.desc_art 		 [ll_row] = dw_2.Object.desc_art    	[ll_j]
			ldw_detail.Object.und				 [ll_row] = dw_2.Object.und				[ll_j]
			ldw_detail.Object.und2				 [ll_row] = dw_2.Object.und2				[ll_j]
			ldw_detail.Object.flag_und2		 [ll_row] = dw_2.Object.flag_und2		[ll_j]
			ldw_detail.Object.factor_conv_und [ll_row] = ldc_factor_conv_und
			ldw_detail.Object.cencos 			 [ll_row] = dw_2.Object.cencos			[ll_j]
			ldw_detail.Object.cnta_prsp		 [ll_row] = dw_2.Object.cnta_prsp 		[ll_j]
			ldw_detail.Object.origen_mov_proy [ll_row] = dw_2.object.cod_origen     [ll_j]
			ldw_detail.Object.nro_mov_proy 	 [ll_row] = dw_2.Object.nro_mov 	 	   [ll_j]
			ldw_detail.Object.precio_unit 	 [ll_row] = ldc_precio_unit
			
			//Obtengo el centro de beneficio del Codigo de Articulo
			select cb.centro_benef
				into :ls_centro_benef
			from centro_benef_articulo cba,
				  centro_beneficio		cb
			where cb.centro_benef 	= cba.centro_benef
			  and cba.cod_art 		= :ls_cod_art
			  and cb.cod_origen 		= :ls_origen
			  and cb.flag_ventas		= '1';
			
			ldw_detail.Object.centro_benef 	 [ll_row] = ls_centro_benef
			
		end if
	end if
NEXT

return true

end function

public function boolean of_opcion26 ();Long 		ll_count, ll_row_master, ll_found, ll_row
String 	ls_orden_venta, ls_origen, ls_tipo_doc, ls_expresion, &
			ls_vendedor, ls_nombre

ll_row_master  = dw_master.Getrow()
ls_orden_venta = dw_master.Object.nro_ov 		[ll_row_master]
ls_origen  		= dw_master.Object.cod_origen [ll_row_master]

IF Not (Isnull(ist_datos.string2) OR Trim(ist_datos.string2) = '') THEN
	IF ls_orden_venta <> ist_datos.string2 THEN
		Messagebox('Aviso','No Puede Seleccionar Una Orden de Venta A Diferente a la ya Considerada')
		Return false
	END IF
END IF

IF dw_2.RowCount() > 0 THEN
	//***SELECCION DE TIPO DE DOC ORDEN DE VENTA***//
	SELECT doc_ov
	  INTO :ls_tipo_doc
	  FROM logparam
	 WHERE reckey = '1' ;
	//***********************************//

	ls_expresion = "origen_ref = '" + ls_origen + "' AND nro_ref = '" + ls_orden_venta + "'"
	ll_found 	 = ist_datos.dw_c.Find(ls_expresion, 1, ist_datos.dw_c.RowCount())	 

	IF ll_found = 0 THEN
	  IF ist_datos.dw_c.triggerevent ('ue_insert') > 0 THEN
		 ll_row = w_ve310_cnts_x_cobrar.tab_1.tabpage_2.dw_detail_referencias.il_row
		 ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'C'
		 ist_datos.dw_c.Object.origen_ref 	 [ll_row] = ls_origen
		 ist_datos.dw_c.Object.tipo_ref		 [ll_row] = ls_tipo_doc
		 ist_datos.dw_c.Object.nro_ref		 [ll_row] = ls_orden_venta
		 ist_datos.dw_c.Object.flab_tabor	 [ll_row] = 'A' //Orden de VENTA
		 //verificacion de vendedor
		 select vendedor
			into :ls_vendedor
			from orden_venta
		  where nro_ov = :ls_orden_venta;
		  
		 if not ( isnull(ls_vendedor) ) or ls_vendedor <> '' then
			 select nombre
				into :ls_nombre
				from usuario
			  where cod_usr = :ls_Vendedor;
			 
			 w_ve310_cnts_x_cobrar.dw_master.object.vendedor[1] = ls_vendedor
			 w_ve310_cnts_x_cobrar.dw_master.object.nombre[1] = ls_nombre
		 end if
		 
	  END IF
	END IF
END IF

of_insert_art_ov(ls_orden_venta)

return true
end function

public subroutine of_insert_art_ov (string as_orden_venta);Long   ll_fdw_d,j,ll_found
String ls_soles, ls_dolares ,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
		 ls_item , ls_rubro   ,ls_clase  

//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 

//* Tipo de Documento Orden de Venta *//
SELECT doc_ov
  INTO :ls_tipo_doc
  FROM logparam
 WHERE (reckey = '1');
//***********************************// 

FOR j=1 TO dw_2.Rowcount()
	 
	 IF ist_datos.dw_d.Rowcount () = w_ve310_cnts_x_cobrar.ii_lin_x_doc	THEN
		 Messagebox('Aviso','No Puede Exceder de '+Trim(String(w_ve310_cnts_x_cobrar.ii_lin_x_doc))+' Items x Documento')	
		 Return 
	 END IF
	 
	 ls_cod_art    = dw_2.object.cod_art    [j] 
	 ls_cod_moneda = dw_2.object.cod_moneda [j] 
	 
	 ls_expresion  = 'cod_art ='+"'"+ls_cod_art+"'"
	 ll_found      = ist_datos.dw_d.find(ls_expresion,1,ist_datos.dw_d.rowcount())
	 
	 IF ll_found > 0 THEN 
		 Messagebox('Aviso','Articulo Nº :'+ls_cod_art+' ya Ha sido tomado en Cuenta')
	 ELSE
 	    w_ve310_cnts_x_cobrar.is_orden_venta = as_orden_venta      
	    IF ist_datos.dw_d.triggerevent ('ue_insert') > 0 THEN
          ll_fdw_d = w_ve310_cnts_x_cobrar.tab_1.tabpage_1.dw_detail.il_row
			 /*Datos del Registro Modificado*/
			 w_ve310_cnts_x_cobrar.ib_estado_prea = TRUE
		    /**/			 
			 
	 	    w_ve310_cnts_x_cobrar.is_orden_venta = as_orden_venta      
			  
			 /*busca rubro de articulo*/ 
			 select ats.factura_rubro into :ls_rubro from articulo art,articulo_sub_categ ats
			  where art.sub_cat_art = ats.cod_sub_cat and
			  		  art.cod_art		= :ls_cod_art		;
			   
			 /**/
			  
			  
		    IF ls_cod_moneda = ist_datos.string3 THEN
			    ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = dw_2.Object.precio_unit [j]				
			 ELSEIF ls_cod_moneda = ls_soles      THEN
				 ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = Round(dw_2.Object.precio_unit [j] / ist_datos.db1,6)	
			 ELSEIF ls_cod_moneda = ls_dolares    THEN
				 ist_datos.dw_d.Object.precio_unitario [ll_fdw_d] = Round(dw_2.Object.precio_unit [j] * ist_datos.db1,6)					
			 END IF
			 
		
			 
			 ist_datos.dw_d.Object.tipo_ref        [ll_fdw_d] = ls_tipo_doc
			 ist_datos.dw_d.Object.nro_ref         [ll_fdw_d] = as_orden_venta
			 ist_datos.dw_d.Object.cod_art         [ll_fdw_d] = dw_2.Object.cod_art 		 [j]
			 ist_datos.dw_d.Object.descripcion     [ll_fdw_d] = dw_2.Object.nom_articulo   [j]
			 ist_datos.dw_d.Object.cantidad        [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_d.Object.descuento		   [ll_fdw_d] = dw_2.Object.decuento		 [j]	
			 ist_datos.dw_d.Object.cant_proyect	   [ll_fdw_d] = dw_2.Object.cant_pendiente [j]
			 ist_datos.dw_m.Object.moneda_det	   [1] 		  = ist_datos.string3
			 ist_datos.dw_m.Object.tasa_cambio_det [1] 		  = ist_datos.db1
			 ist_datos.dw_m.Object.cod_relacion_det[1] 		  = ist_datos.string1
			 ist_datos.dw_d.Object.confin				[ll_fdw_d] = dw_2.Object.confin 			 [j]
			 ist_datos.dw_d.Object.matriz_cntbl	   [ll_fdw_d] = dw_2.object.matriz_cntbl   [j]
			 ist_datos.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = dw_2.object.dl27400        [j]
			 ist_datos.dw_d.Object.rubro				[ll_fdw_d] = ls_rubro
			 
			 ist_datos.dw_d.Object.centro_benef		[ll_fdw_d] = dw_2.object.centro_benef   [j]
			 
			 
			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(ist_datos.dw_d.Object.item  [ll_fdw_d]))
			 w_ve310_cnts_x_cobrar.wf_generacion_imp (ll_fdw_d)
			 
			 ist_datos.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			 
			 //Asigno total
			 w_ve310_cnts_x_cobrar.dw_master.object.importe_doc [w_ve310_cnts_x_cobrar.dw_master.getrow()] = w_ve310_cnts_x_cobrar.wf_totales ()
			 w_ve310_cnts_x_cobrar.dw_master.ii_update = 1
			 
			 
			 
			 
			 

			 
		 END IF	
	 END IF	
NEXT


end subroutine

public function boolean of_opcion27 ();Long ll_count, ll_row

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return false
END IF

IF ll_count = 1 THEN
	ll_row = ist_datos.dw_m.GetRow()
	IF ll_row = 0 THEN RETURN false
	ist_datos.dw_m.object.confin 		  [ll_row] = dw_2.Object.confin		  [1]
	ist_datos.dw_m.object.matriz_cntbl [ll_row] = dw_2.Object.matriz_cntbl [1]
	ist_datos.titulo = 's'
END IF

return true
end function

on w_abc_seleccion_md.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
this.dw_master=create dw_master
this.cb_2=create cb_2
this.pb_todo=create pb_todo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.pb_todo
end on

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.cb_2)
destroy(this.pb_todo)
end on

event ue_open_pre;call super::ue_open_pre;Long 			ll_row
string 		ls_nro_programa
u_dw_abc 	ldw_master

// Recoge parametro enviado
is_tipo = ist_datos.tipo

if ist_datos.opcion = 12 or ist_datos.opcion = 14 or ist_datos.opcion = 4 &
	or ist_datos.tipo = 'PROG_COMPRAS' or ist_datos.tipo = 'COTIZA_OT' then
	// El boton de Otra OT solo debería estar disponible
	// Cuando hago una Orden de Compra referenciada a OT's
	// O cuando hago programas de compra y estan relacionadas
	// tambien con OT's
	
	cb_2.visible = true
	cb_2.enabled = true
else
	cb_2.visible = false
	cb_2.enabled = false
end if

dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

dw_master.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)	

if TRIM( is_tipo ) = '' then 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_master.Retrieve( ist_datos.string1)
		
		CASE 'OC_DET_OS_DET'
			id_fecha1	   = ist_datos.fecha1
			id_fecha2		= ist_datos.fecha2
			is_cod_art		= ist_datos.string1
			is_desc_art		= ist_datos.string2
			is_nro_doc		= ist_datos.string3
			is_almacen		= ist_datos.string5

			dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
									  is_desc_art, is_nro_doc, is_almacen )
			  
		CASE 'NRO_DOC'
			is_oper_cons_int = ist_datos.oper_cons_interno
			is_doc_ot			 = ist_datos.tipo_doc
			 
			id_fecha1		 = ist_datos.fecha1
			id_fecha2		 = ist_datos.fecha2
			is_cod_art		 = ist_datos.string1
			is_desc_art		 = ist_datos.string2
		   is_nro_doc	  	 = ist_datos.string3
			is_ot_adm		 = ist_datos.string4
			is_almacen		 = ist_datos.string5
			is_flag_cntrl_fondos = ist_datos.flag_cntrl_fondos
			is_subcateg		 = ist_datos.cod_subcateg
			
		   dw_master.Retrieve( id_fecha1, id_fecha2 ,&
			  							 is_cod_art, is_desc_art, is_doc_ot, &
										 is_nro_doc, is_ot_adm, is_oper_cons_int, is_almacen, is_subcateg )
			  
			if (ist_datos.opcion = 12 or ist_datos.opcion = 4) and dw_master.RowCount() = 0 then
				  // Si es Una Orden de Compra a partir de una Orden de Trabajo
				  // y no existen registros recuperados debe darme un mensaje 
			 	  // de error
				MessageBox('Aviso', "No existen articulos proyectados para " &
					   		+ "atender en la Orden de Trabajo " + ist_datos.nro_doc, &
								Information!)
		   end if

		CASE 'OV'
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen = ldw_master.object.almacen[ll_row]
			ll_row = dw_master.Retrieve( is_almacen )
			
			if ist_datos.tipo_doc <> '' and ist_datos.nro_doc <> '' then
				dw_master.SetFilter("nro_ov = '" + ist_datos.nro_doc + "'")
				dw_master.Filter()
			else
				dw_master.SetFilter('')
				dw_master.Filter()
			end if
			  
		CASE 'COTIZA_OT'
			is_oper_cons_int   	= ist_datos.oper_cons_interno
			is_doc_ot			 	= ist_datos.tipo_doc
			 
			id_fecha1		 		= ist_datos.fecha1
			id_fecha2		 		= ist_datos.fecha2
			is_cod_art		 		= ist_datos.string1
			is_desc_art		 		= ist_datos.string2
		   is_nro_doc	  	 		= ist_datos.string3
			is_ot_adm		 		= ist_datos.string4
			is_almacen		 		= ist_datos.string5
			is_flag_cntrl_fondos = ist_datos.flag_cntrl_fondos
			is_subcateg		   	= ist_datos.cod_subcateg
			is_nro_cotizacion 	= ist_datos.nro_cotizacion
			
		   dw_master.Retrieve( id_fecha1, id_fecha2 ,&
			  							 is_cod_art, is_desc_art, is_doc_ot, &
										 is_nro_doc, is_ot_adm, is_oper_cons_int, &
										 is_almacen, is_subcateg, is_nro_cotizacion )

			if dw_master.RowCount() = 0 then
				  // Si es Una Orden de Compra a partir de una Orden de Trabajo
				  // y no existen registros recuperados debe darme un mensaje 
			 	  // de error
				MessageBox('Aviso', "No existen articulos proyectados para " &
					   		+ "atender en la Orden de Trabajo " + ist_datos.nro_doc, &
								Information!)
		   end if
			
			CASE 'PROG_COMPRAS'
				id_fecha1	= ist_datos.fecha1
				id_fecha2	= ist_datos.fecha2
				is_cod_art	= ist_datos.string1
				is_desc_art	= ist_datos.string2
				is_nro_doc	= ist_datos.string3
				is_ot_adm	= ist_datos.string4
				is_almacen	= ist_datos.string5
				is_comprador= ist_datos.string6
				is_flag_cntrl_fondos = ist_datos.flag_cntrl_fondos
				is_subcateg	= ist_datos.cod_subcateg
	
				if ist_datos.opcion = 2 or ist_datos.opcion = 7 then 
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg )
				elseif ist_datos.opcion = 13 or ist_datos.opcion = 16 then
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg, is_comprador )
				end if
			  
			CASE 'COTIZA_PROG'
				id_fecha1	= ist_datos.fecha1
				id_fecha2	= ist_datos.fecha2
				is_cod_art	= ist_datos.string1
				is_desc_art	= ist_datos.string2
				is_nro_doc	= ist_datos.string3
				is_ot_adm	= ist_datos.string4
				is_almacen	= ist_datos.string5
				is_comprador= ist_datos.string6
				is_flag_cntrl_fondos = ist_datos.flag_cntrl_fondos
				is_subcateg	= ist_datos.cod_subcateg
				is_nro_cotizacion = ist_datos.nro_cotizacion
	
				if ist_datos.opcion = 8 then 
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg, is_nro_cotizacion)
				elseif ist_datos.opcion = 18 then
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg, is_nro_cotizacion, is_comprador )
				end if
				
			CASE '1OT' //Orden trabajo para generar orden de servicio
				  dw_master.Retrieve(ist_datos.fecha1,ist_datos.fecha2)	
			
			CASE 'COMPRAS'
				ldw_master = ist_datos.dw_or_m
				ldw_master.Accepttext( )
				
				is_almacen = ldw_master.object.almacen[ldw_master.GetRow()]
				ll_row = dw_master.Retrieve( is_almacen )
				
				if ist_datos.tipo_doc <> '' and ist_datos.nro_doc <> '' then
					dw_master.SetFilter("nro_doc = '" + ist_datos.nro_doc + "'")
					dw_master.Filter()
				else
					dw_master.SetFilter('')
					dw_master.Filter()
				end if

	END CHOOSE
end if

This.Title 		= ist_datos.titulo
is_col 			= dw_master.Describe("#1" + ".name")
st_campo.text 	= "Orden: " + is_col

of_get_param()
end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - this.cii_windowborder

end event

type p_pie from w_abc_list`p_pie within w_abc_seleccion_md
end type

type ole_skin from w_abc_list`ole_skin within w_abc_seleccion_md
end type

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 784
integer width = 1362
integer height = 688
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) &
	or Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	
	MessageBox('Aviso ' + This.ClassName(), 'Parametros mal pasados', StopSign!)
	return 
	
end if

ist_datos = MESSAGE.POWEROBJECTPARM	

ii_opcion = ist_datos.opcion

ii_ck[1] = 1         // columnas de lectrua de este dw


end event

event dw_1::ue_selected_row_pro;Long		ll_row, ll_rc, ll_find, ll_count, ll_nro_item, ll_nro_amp
Any		la_id
Integer	li_x
string	ls_sol_cmp, ls_origen, ls_cod_art, ls_oper_sec, &
			ls_nro_mov, ls_nro_programa, ls_org_amp

choose case ist_datos.opcion
	case 2,13,7,16	//Generacion de Orden de Compra a Partir del Programa de Compras
		
		// tengo que validar que no ingrese el mismo item del
		// misma programa en la misma orden de Compra
		
		ls_nro_programa	= this.object.nro_programa	[al_row]
		ll_nro_item			= Long(this.object.nro_item [al_row])
		
		ll_find = dw_2.Find("nro_programa = '" + ls_nro_programa + "'" &
			+ " and nro_item = " + string(ll_nro_item), 1, dw_2.RowCount())
		
		if ll_find > 0 then
			// El item del programa ya se encuentra
			MessageBox('Aviso', "El Item " + string(ll_nro_item) + " del programa " &
					+"de Compra " + ls_nro_programa + " ya fue seleccionado", Information!)
			ib_process = false
			return false
		end if 
		
	case 11  //Orden de servicios a partir de Orden de Trabajo
		// tengo que validar que no ingrese el mismo opersec
		
		ls_oper_sec = this.object.oper_sec		[al_row]
		
		ll_find = dw_2.Find("oper_sec = '" + ls_oper_sec + "'", 1, dw_2.RowCount())
		
		if ll_find > 0 then
			// El opersec ya existe
			MessageBox('Aviso', "La operaciones " + ls_oper_sec &
				+ " ya ha sido seleccionada", Information!)
			ib_process = false
			return false
		end if 		

	case 12,4  // Generación de Compras a partir de OTs
		ls_org_amp = this.object.cod_origen	[al_row]
		ll_nro_amp = this.object.nro_mov		[al_row]
		
		if dw_2.Find("cod_origen = '" + ls_org_amp + "' and nro_mov = " &
				+ string(ll_nro_amp), 1, dw_2.RowCount()) > 0 then
				
			MessageBox('Aviso', 'Solo se puede seleccionar un AMP por vez')
			ib_process = false
			return false
			
		end if			

end choose

// Si todo esta ok se procede a pasar el registro al otro dw
ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)

// Indico que el proceso ha concluido satisfactoriamente
ib_process = true
return true
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

if ib_process = false then return

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1600
integer y = 784
integer width = 1362
integer height = 688
integer taborder = 60
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
Choose Case ist_datos.opcion 
	Case 1
	ii_rk[1] = 1				// Deploy key
	ii_rk[2] = 2				
	ii_rk[3] = 3				// Deploy key
	ii_rk[4] = 4
	ii_rk[5] = 5				
	ii_rk[6] = 6				
	ii_rk[7] = 7				
	ii_rk[8] = 8
	ii_rk[9] = 9	
	ii_dk[1] = 1				// Receive key
	ii_dk[2] = 2				// Receive key
	ii_dk[3] = 3				
	ii_dk[4] = 4
	ii_dk[5] = 5				
	ii_dk[6] = 6				
	ii_dk[7] = 7				
	ii_dk[8] = 8
	ii_dk[9] = 9	
Case 4,9   // 
	ii_rk[1] = 1				// Deploy key
	ii_rk[2] = 2				
	ii_rk[3] = 3				// Deploy key
	ii_rk[4] = 4
	ii_rk[5] = 5				
	ii_rk[6] = 6				
	ii_rk[7] = 7				
	ii_rk[8] = 8
	ii_rk[9] = 9
	ii_rk[10] = 10
	ii_rk[11] = 11
	ii_rk[12] = 12
	ii_rk[13] = 13
	ii_rk[14] = 14
	ii_rk[15] = 15
	ii_rk[16] = 16
	ii_dk[1] = 1				// Receive key
	ii_dk[2] = 2				// Receive key
	ii_dk[3] = 3				
	ii_dk[4] = 4
	ii_dk[5] = 5				
	ii_dk[6] = 6				
	ii_dk[7] = 7				
	ii_dk[8] = 8
	ii_dk[9] = 9
	ii_dk[10] = 10
	ii_dk[11] = 11
	ii_dk[12] = 12
	ii_dk[13] = 13
	ii_dk[14] = 14
	ii_dk[15] = 15
	ii_dk[16] = 16	
Case 2,7,8, 10
	ii_rk[1] = 1				// Deploy key
	ii_rk[2] = 2				
	ii_rk[3] = 3				// Deploy key
	ii_rk[4] = 4
	ii_rk[5] = 5				
	ii_rk[6] = 6				
	ii_rk[7] = 7				
	ii_rk[8] = 8
	ii_rk[9] = 9
	ii_rk[10] = 10
	ii_rk[11] = 11
	ii_dk[1] = 1				// Receive key
	ii_dk[2] = 2				// Receive key
	ii_dk[3] = 3				
	ii_dk[4] = 4
	ii_dk[5] = 5				
	ii_dk[6] = 6				
	ii_dk[7] = 7				
	ii_dk[8] = 8
	ii_dk[9] = 9
	ii_dk[10] = 10
	ii_dk[11] = 11
	Case 3     // Orden de compra  - Compras sugeridas
	ii_dk[1] = 1				
	ii_dk[2] = 2				
	ii_dk[3] = 3
	ii_dk[4] = 4
	ii_dk[5] = 5
	ii_dk[6] = 6				
	ii_dk[7] = 7				
	ii_dk[8] = 8
	ii_dk[9] = 9
	ii_rk[1] = 1
	ii_rk[2] = 2				
	ii_rk[3] = 3				
	ii_rk[4] = 4
	ii_rk[5] = 5
	ii_rk[6] = 6				
	ii_rk[7] = 7				
	ii_rk[8] = 8
	ii_rk[9] = 9
Case 5     // Cotizacion servicios / solicitud de servicios
	ii_dk[1] = 1				
	ii_dk[2] = 2
	ii_dk[3] = 3
	ii_dk[4] = 4
	ii_dk[5] = 5
	ii_rk[1] = 1
	ii_rk[2] = 2
	ii_rk[3] = 3				
	ii_rk[4] = 4
	ii_rk[5] = 5
  Case 6     // Orden de servicios / Solicitud servicios
	ii_dk[1] = 1				
	ii_dk[2] = 2
	ii_dk[3] = 3
	ii_dk[4] = 4
	ii_dk[5] = 5
	ii_dk[6] = 6
	ii_dk[7] = 7
	ii_dk[8] = 8
	ii_rk[1] = 1
	ii_rk[2] = 2
	ii_rk[3] = 3				
	ii_rk[4] = 4
	ii_rk[5] = 5
	ii_rk[6] = 6
	ii_rk[7] = 7
	ii_rk[8] = 8
end choose
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long		ll_row, ll_rc, ll_count
Any		la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
if ll_row < 0 then return false

ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
return true
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1426
integer y = 864
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
integer y = 1052
integer taborder = 50
end type

type st_campo from statictext within w_abc_seleccion_md
integer x = 23
integer y = 20
integer width = 713
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_abc_seleccion_md
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 28
integer width = 1449
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

end event

event dwnenter;dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_longitud
string 	ls_item, ls_ordenado_por, ls_comando, ls_campo
Long 		ll_fila, li_x

SetPointer(hourglass!)

if TRIM( is_col ) <> '' THEN

	ls_item = upper( this.GetText() )

	li_longitud = len( ls_item )
	
	if li_longitud > 0 then		// si ha escrito algo

		IF UPPER( is_type ) = 'N' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_type ) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF		

		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())	
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			
			// ubica			
			dw_master.Event ue_output(ll_fila)			
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_1.reset()
	this.insertrow(0)
end if	

SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion_md
integer x = 2830
integer y = 32
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
Long 		j, ll_row_mst, ll_row, ll_count
String 	ls_tipo_mov, ls_codart, ls_tipo_ref, ls_sub_cat, &
			ls_desc_sub_cat, ls_cod_art, ls_proveedor, ls_almacen, ls_moneda
Int 		li_res, li_row
Decimal  ldc_precio
Date 		ld_fec_reg

if dw_2.rowcount() = 0 then return
Choose case ist_datos.opcion
	CASE 1 // Orden de compra con solicitud de compras
		if of_opcion1() = 0 then return
	
	CASE 2,13 // Orden de compra con programa de compras
				 // La opcion 2 No restringe por Comprador
				 // La opcion 13 si restringe por comprador
		if of_opcion2() = 0 then return
		
	CASE 3		//CASO PARTICULAR DE CONFIN
			   
		IF dw_2.Rowcount() > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		END IF

		IF dw_2.Rowcount() = 1 THEN
			ll_row = ist_datos.dw_m.GetRow()
			IF ll_row = 0 THEN RETURN
			
			ist_datos.dw_m.object.confin [ll_row] = dw_2.Object.confin [1]
			ist_datos.titulo = 's'
		END IF
		
		
	CASE 4 // Cotizacion con solicitud de compras
		if of_opcion4() = 0 then return
		
	CASE 5 // Cotizacion de servicios con solicitud de servicios
		For j = 1 to dw_2.RowCount()
			if wf_provee_subcat( dw_2.object.cod_sub_cat[j]) = 0 then continue
			if ist_datos.dw_d.triggerevent ("ue_insert") > 0 then	
				li_row = ist_datos.dw_d.getrow()
  	   		ist_datos.dw_d.object.cod_sub_cat [li_row] = dw_2.object.cod_sub_cat[j]
				ist_datos.dw_d.object.descripcion [li_row] = dw_2.object.descripcion[j]
			end if
		Next		
	CASE 6 // Orden de servicios con solicitud de servicios
		if of_opcion6() = 0 then return
		
	CASE 7,16 // cotizacion con programa de compras		
		if of_opcion7() = 0 then return

		
	CASE 8, 18 // Orden de compra Automatica - con programa de compras
		if of_opcion8() = 0 then return
		
	CASE 10 // Orden de trabajo
		ll_row_mst = ist_datos.dw_m.getrow()
		// Verifica que no pueda aceptar mas de un documento
		if ist_datos.dw_m.object.sol_cod_origen[ll_row_mst] <> dw_2.object.cod_origen[1] or &
     		ist_datos.dw_m.object.nro_sol_serv[ll_row_mst] <> dw_2.object.nro_sol_serv[1] then
	  		messagebox("Error", "no puede seleccionar otro documento") 
			CloseWithReturn( parent, ist_datos)
	  		return 
		end if		

		For j = 1 to dw_2.RowCount()
			if ist_datos.dw_d.triggerevent ("ue_insert") > 0 then	
				li_row = ist_datos.dw_d.getrow()
				
				ist_datos.dw_d.object.cod_origen		[j] 		 = gnvo_app.is_origen
  	   		ist_datos.dw_d.object.flag_estado	[j] 		 = '1'
				ist_datos.dw_d.object.nro_item		[j] 		 = dw_2.object.nro_item[j]
				ist_datos.dw_d.object.descripcion	[j] 		 = dw_2.object.descripcion[j]
				ist_datos.dw_d.object.fec_proyect	[j] 		 = dw_2.object.fec_requerida[j]
				ist_datos.dw_d.object.cnta_prsp		[j] 		 = dw_2.object.cnta_prsp[j]
				ist_datos.dw_d.object.importe			[j] 		 = dw_2.object.precio[j]
				ist_datos.dw_d.object.cencos			[j] 		 = dw_master.object.cencos[dw_master.getrow()]
				ist_datos.dw_m.object.sol_cod_origen[ll_row_mst] = dw_2.object.cod_origen[j]
				ist_datos.dw_m.object.nro_sol_serv[ll_row_mst] 	 = dw_2.object.nro_sol_serv[j]
				ist_datos.dw_d.object.cod_sub_cat	[j] 	 	 = dw_2.object.cod_sub_cat[j]				
			end if
		Next
		
	CASE 11 //Orden de Servicio a Partir de una Orden de Trabajo
		if of_opcion11() = 0 then return
	
	CASE 12  //Orden de Compra a Partir de una Orden de Trabajo
		if of_opcion12() = 0 then return
		
	CASE 14  //Programa de Compras a Partir de Ordenes de Trabajo
		if of_opcion14() = 0 then return

	CASE 15  //Programa de Compras a Partir de Ordenes de Trabajo
		if of_opcion15() = 0 then return
		
	CASE 17  //Programa de Compras a Partir de Ordenes de Trabajo
		if of_opcion17() = 0 then return
		
	CASE 19  //Sub Categoria de Articulos
		if of_opcion19() = 0 then return
	CASE 20  //Acta de Conformidad de OS
		if of_opcion20() = 0 then return
	
	CASE 21
		if  of_opcion21() = false then return

	CASE 22
		if  of_opcion22() = false then return
		
	CASE 23
		if  of_opcion23() = false then return

	CASE 24
		if  of_opcion24() = false then return

	CASE 25
		if  of_opcion25() = false then return

	CASE 26
		if  of_opcion26() = false then return

	CASE 27  // Concepto Financiero
		if  of_opcion27() = false then return

END CHOOSE
CloseWithReturn( parent, ist_datos)
return
end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 140
integer width = 2894
integer height = 624
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = mid(ls_column,1,li_pos - 1)
	st_campo.text = "Buscar por: " + dw_master.describe( is_col + "_t.text")

	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()		

	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
END  IF
end event

event ue_output;call super::ue_output;// Muestra detalle
String 	ls_nro_sol, ls_nro_ref,ls_flag_estruct,ls_nro_orden, &
			ls_mensaje, ls_nro_oc
Long		ll_count			

if ib_sel = false then
	if al_row > 0 then
		Choose case ist_datos.opcion 
			Case 1 				// Solicitud de compra pendientes				
				dw_1.Retrieve( this.object.cod_origen[al_row], this.object.nro_sol_comp[al_row])
			Case 9 				// Solicitud de compra pendientes
				dw_1.Retrieve( this.object.cod_origen[al_row], this.object.nro_sol_comp[al_row])
			Case 8, 18				// Programa de compras
				if ist_datos.opcion = 8 then
					dw_1.Retrieve( this.object.nro_programa[al_row], &
							id_fecha1, id_fecha2, is_cod_art, is_desc_art, &
							is_almacen, is_subcateg, is_nro_cotizacion )
				elseif ist_datos.opcion = 18 then
					dw_1.Retrieve( this.object.nro_programa[al_row], &
						id_fecha1, id_fecha2, is_cod_art, is_desc_art, &
						is_almacen, is_subcateg, is_nro_cotizacion, &
						is_comprador )
				end if
			Case 2,13,7,16
				if ist_datos.opcion = 2 or ist_datos.opcion = 7 then
					dw_1.Retrieve( this.object.nro_programa[al_row], &
							id_fecha1, id_fecha2, is_cod_art, is_desc_art, &
							is_almacen, is_subcateg )
				elseif ist_datos.opcion = 13 or ist_datos.opcion = 16 then
					dw_1.Retrieve( this.object.nro_programa[al_row], &
						id_fecha1, id_fecha2, is_cod_art, is_desc_art, &
						is_almacen, is_subcateg, is_comprador )
				end if
			case 3				// Compras Sugeridas
				dw_1.Retrieve( this.object.cod_art[al_row])
			Case 5 				// Solicitud de servicios
				dw_1.Retrieve( this.object.cod_origen[al_row], this.object.nro_sol_serv[al_row])
			Case 6 				// Solicitud de servicios pendientes
				dw_1.Retrieve( this.object.cod_origen[al_row], this.object.nro_sol_serv[al_row])
			Case 10				// Orden de trabajo
				dw_1.Retrieve( this.object.nro_orden[al_row])
			Case 11 //orden trabajo genera orden de servivio
				
				ls_flag_estruct = this.object.flag_estructura [al_row]
				ls_nro_orden	 = this.object.nro_orden	    [al_row]
				
				if ls_flag_estruct = '1' then
					//ejecuta procedimiento					
					DECLARE USP_CMP_OT_ESTRUC_SERV PROCEDURE FOR 
							USP_CMP_OT_ESTRUC_SERV (:ls_nro_orden);
					EXECUTE USP_CMP_OT_ESTRUC_SERV ;

					IF SQLCA.SQLCode = -1 THEN 
						ls_mensaje = SQLCA.SQLErrText
						MessageBox("SQL error USP_CMP_OT_ESTRUC_SERV", ls_mensaje)
						ROLLBACK;
						return
					END IF

					CLOSE USP_CMP_OT_ESTRUC_SERV ;
					
					//asigna nuevo dw
					dw_1.dataobject = 'd_lista_oper_x_orden_struct_grd'
					dw_1.settransobject(sqlca)
					dw_1.retrieve(ist_datos.fecha1,ist_datos.fecha2)
					
				else
					//asigna nuevo dw
					dw_1.dataobject = 'd_lista_oper_x_orden_grd'
					dw_1.settransobject(sqlca)
					dw_1.retrieve(this.object.nro_orden[al_row],ist_datos.fecha1, ist_datos.fecha2 )	
				end if
				
			Case 12,14,4 	// Orden trabajo genera orden de compra
							// Programa de Compras a Partir de OT
				
				dw_1.Retrieve(is_doc_ot, this.object.nro_orden[al_row] ,&
								  id_fecha1, id_fecha2 ,&
								  is_cod_art, is_desc_art, is_oper_cons_int, is_almacen, is_subcateg )
				
			Case 15 	// Orden trabajo genera orden de compra
							// Programa de Compras a Partir de OT
				
				dw_1.Retrieve(this.object.nro_oc[al_row], is_cod_art, is_desc_art, is_almacen)
				
			Case 17 	// Generacion de una OC Automatica (cotizaciones) jalando
						// datos de una OT
				dw_1.Retrieve(is_doc_ot, this.object.nro_orden[al_row] ,&
								  id_fecha1, id_fecha2 ,&
								  is_cod_art, is_desc_art, is_oper_cons_int, is_almacen, &
								  is_subcateg, is_nro_cotizacion )
			Case 19	// Cotizaciones de una subcategoría completa
				dw_1.Retrieve( this.object.cod_sub_cat[al_row])
			Case 20 // Ordenes de Servicio con flag de Acta de conformidad
				dw_1.retrieve( this.object.origen_os[al_row], this.object.nro_os[al_row])

			Case 21		// Ingresos x Compra 
				if ll_count > 0 then
					Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
					This.setredraw(false)
					This.SelectRow(0,False)
					This.SelectRow(al_row,True)
					This.setfocus()
					This.setredraw(true)	
					dw_1.reset()
					dw_2.reset()
				end if
				
				ls_nro_oc = ist_datos.dw_or_m.object.nro_refer[ist_datos.dw_or_m.getrow()]
				ls_nro_ref = this.object.nro_doc[al_row]				
				if ls_nro_ref <> ls_nro_oc then
					Messagebox( "Atencion", "No puede seleccionar otro documento", Exclamation!)
					dw_1.reset()
					dw_2.reset()
					Return
				end if
				dw_1.Retrieve( is_doc_oc, this.object.nro_doc[al_row], is_almacen)
				
			CASE 22 //ORDEN COMPRA		(Cuentas x Pagar)
				dw_1.Retrieve(This.object.cod_origen[al_row],This.object.nro_oc[al_row])
				
			CASE 23 //ORDEN SERVICIO 	(Cuentas x Pagar)
				dw_1.Retrieve(This.object.cod_origen[al_row],This.object.nro_os[al_row])	

  			CASE 24 //Guia de Recepcion de Materia Prima (cntas x pagar)
				dw_1.Retrieve(ist_datos.string1, This.object.cod_guia_rec[al_row])
				
			case 25				// Ordenes de venta
				ll_count = dw_2.Rowcount()
				if ll_count > 0 then
					Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)	
					This.setredraw(false)
					This.SelectRow(0,False)
					This.SelectRow(al_row,True)
					This.setfocus()
					This.setredraw(true)	
					dw_1.reset()
					dw_2.reset()
				end if
				
				dw_1.Retrieve( this.object.nro_ov[al_row], is_almacen)

			CASE 26 	// Guias de remisión, Articulo Mov Proy
				dw_1.Retrieve(this.object.cod_origen[al_row],this.object.nro_ov[al_row])

			CASE 27
				dw_1.Retrieve(this.object.grupo[al_row])
				  
	    end Choose
	end if
else
	Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)
	dw_1.reset()
	dw_2.reset()
end if
end event

type cb_2 from commandbutton within w_abc_seleccion_md
boolean visible = false
integer x = 2354
integer y = 32
integer width = 338
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Mas Datos"
end type

event clicked;str_parametros lstr_param, lstr_datos

lstr_param.fecha1 	= id_fecha1
lstr_param.fecha2		= id_fecha2
lstr_param.string1	= is_cod_art
lstr_param.string2	= is_desc_art
lstr_param.string3	= is_nro_doc
lstr_param.string4	= is_ot_adm
lstr_param.string5	= is_almacen
lstr_param.tipo		= is_tipo
lstr_param.nro_cotizacion 		= ist_datos.nro_cotizacion
lstr_param.flag_oc_automatico = ist_datos.flag_oc_automatico
	
OpenWithParm( w_abc_datos_ot, lstr_param )

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_datos = Message.PowerObjectParm
if lstr_datos.titulo = 'n' then return

if TRIM( is_tipo ) = '' then 	// Si tipo no es indicado, hace un retrieve
	dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			dw_master.Retrieve( lstr_datos.string1)
	
		CASE 'OC_DET_OS_DET'
			id_fecha1	   = lstr_datos.fecha1
			id_fecha2		= lstr_datos.fecha2
			is_cod_art		= lstr_datos.string1
			is_desc_art		= lstr_datos.string2
			is_nro_doc		= lstr_datos.string3
			is_almacen		= lstr_datos.string5

			dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
									  is_desc_art, is_nro_doc, is_almacen )
			  
		CASE 'NRO_DOC'
			id_fecha1		 = lstr_datos.fecha1
			id_fecha2		 = lstr_datos.fecha2
			is_cod_art		 = lstr_datos.string1
			is_desc_art		 = lstr_datos.string2
		   is_nro_doc	  	 = lstr_datos.string3
			is_ot_adm		 = lstr_datos.string4
			is_almacen		 = lstr_datos.string5
			is_subcateg		 = lstr_datos.cod_subcateg
			
		   dw_master.Retrieve( id_fecha1, id_fecha2 ,&
			  							 is_cod_art, is_desc_art, is_doc_ot, &
										 is_nro_doc, is_ot_adm, is_oper_cons_int, is_almacen, is_subcateg )
			  
			if (ist_datos.opcion = 12 or ist_datos.opcion = 4) and dw_master.RowCount() = 0 then
				  // Si es Una Orden de Compra a partir de una Orden de Trabajo
				  // y no existen registros recuperados debe darme un mensaje 
			 	  // de error
				MessageBox('Aviso', "No existen articulos proyectados para " &
					   		+ "atender en la Orden de Trabajo " + lstr_datos.nro_doc, &
								Information!)
		   end if
			  
		CASE 'COTIZA_OT'
			id_fecha1		 		= lstr_datos.fecha1
			id_fecha2		 		= lstr_datos.fecha2
			is_cod_art		 		= lstr_datos.string1
			is_desc_art		 		= lstr_datos.string2
		   is_nro_doc	  	 		= lstr_datos.string3
			is_ot_adm		 		= lstr_datos.string4
			is_almacen		 		= lstr_datos.string5
			is_subcateg		   	= lstr_datos.cod_subcateg
						
		   dw_master.Retrieve( id_fecha1, id_fecha2 ,&
			  							 is_cod_art, is_desc_art, is_doc_ot, &
										 is_nro_doc, is_ot_adm, is_oper_cons_int, &
										 is_almacen, is_subcateg, is_nro_cotizacion )

			if dw_master.RowCount() = 0 then
				  // Si es Una Orden de Compra a partir de una Orden de Trabajo
				  // y no existen registros recuperados debe darme un mensaje 
			 	  // de error
				MessageBox('Aviso', "No existen articulos proyectados para " &
					   		+ "atender en la Orden de Trabajo " + lstr_datos.nro_doc, &
								Information!)
		   end if
			
			CASE 'PROG_COMPRAS'
				id_fecha1	= lstr_datos.fecha1
				id_fecha2	= lstr_datos.fecha2
				is_cod_art	= lstr_datos.string1
				is_desc_art	= lstr_datos.string2
				is_nro_doc	= lstr_datos.string3
				is_ot_adm	= lstr_datos.string4
				is_almacen	= lstr_datos.string5
				is_comprador= lstr_datos.string6
				is_subcateg	= lstr_datos.cod_subcateg
	
				if ist_datos.opcion = 2 or ist_datos.opcion = 7 then 
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg )
				elseif ist_datos.opcion = 13 or ist_datos.opcion = 16 then
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg, is_comprador )
				end if

			CASE 'COTIZA_PROG'
				id_fecha1	= ist_datos.fecha1
				id_fecha2	= ist_datos.fecha2
				is_cod_art	= ist_datos.string1
				is_desc_art	= ist_datos.string2
				is_nro_doc	= ist_datos.string3
				is_ot_adm	= ist_datos.string4
				is_almacen	= ist_datos.string5
				is_comprador= ist_datos.string6
				is_subcateg	= ist_datos.cod_subcateg
	
				if ist_datos.opcion = 8 then 
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg, is_nro_cotizacion)
				elseif ist_datos.opcion = 18 then
					dw_master.Retrieve( id_fecha1, id_fecha2, is_cod_art, &
											  is_desc_art, is_almacen, is_nro_doc, &
											  is_subcateg, is_nro_cotizacion, is_comprador )
				end if
				
			CASE '1OT' //Orden trabajo para generar orden de servicio
				  dw_master.Retrieve(ist_datos.string1,ist_datos.string2)	
		end choose
end if

dw_1.Reset()
			  




end event

type pb_todo from picturebutton within w_abc_seleccion_md
integer x = 2711
integer y = 32
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom035!"
string disabledname = "Custom035!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Trasladar Todo"
end type

event clicked;Long ll_i, ll_j

for ll_i = 1 to dw_master.RowCount()
	dw_master.SetRow(ll_i)
	dw_master.ScrollToRow(ll_i)
	dw_master.Selectrow( 0, false)
	dw_master.Selectrow( ll_i, true)
	
	ib_process = true
	dw_master.event ue_output(ll_i)
	if ib_process = false then return
	
	if dw_1.RowCount() > 0 then
		dw_1.Selectrow( 0, false )
		for ll_j = 1 to dw_1.RowCount()
			dw_1.SelectRow(ll_j, true)
		next
		ib_process = true
		pb_1.event clicked()
		if ib_process = false then return
	end if
	
next
end event

