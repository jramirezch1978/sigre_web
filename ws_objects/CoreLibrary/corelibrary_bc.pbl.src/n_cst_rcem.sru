$PBExportHeader$n_cst_rcem.sru
forward
global type n_cst_rcem from nonvisualobject
end type
end forward

global type n_cst_rcem from nonvisualobject autoinstantiate
end type

type variables
u_ds_base  ids_lista
end variables

forward prototypes
public subroutine clear ()
public function boolean add (string as_proveedor, decimal adc_importe_cp, decimal adc_importe_rh)
public function boolean remove (string as_proveedor)
public function integer size ()
public function decimal get_importe_cp (long al_row)
public function decimal get_importe_rh (long al_row)
public function String get_ruc (long al_row)
public function string get_nom_proveedor (long al_row)
public function string of_create_txt (date ad_fec_pago)
end prototypes

public subroutine clear ();ids_lista.Reset()
end subroutine

public function boolean add (string as_proveedor, decimal adc_importe_cp, decimal adc_importe_rh);//Buscados si el ruc existe en la lista
Long 		ll_i
boolean 	lb_encontro
String	ls_ruc, ls_tipo_doc_ident, ls_mensaje, ls_nom_proveedor

//Obtengo el RUC del proveedor
select 	decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident), p.tipo_doc_ident, 
			p.nom_proveedor
  into :ls_ruc, :ls_tipo_doc_ident, :ls_nom_proveedor
  from proveedor p
 where p.proveedor = :as_proveedor;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al obtener los datos de la tabla ' &
							+ 'PROVEEDOR, Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

if ls_tipo_doc_ident <> '6' then
	ROLLBACK;
	MessageBox('Error', 'El procedimiento es solo para Empresas unicamente con RUC', StopSign!)
	return false
end if

lb_encontro = false
for ll_i = 1 to ids_lista.RowCount()
	if ids_lista.object.ruc 		[ll_i] = ls_ruc then
		ids_lista.object.importe_cp[ll_i] = Dec(ids_lista.object.importe_cp [ll_i]) + adc_importe_cp
		ids_lista.object.importe_rh[ll_i] = Dec(ids_lista.object.importe_rh [ll_i]) + adc_importe_rh
		lb_encontro = true
		exit
	end if
next

//Si no existe entonces lo añado a la lista
if not lb_encontro then
	ll_i = ids_lista.RowCount() + 1
	
	ids_lista.object.ruc 			[ll_i] = ls_ruc
	ids_lista.object.nom_proveedor[ll_i] = ls_nom_proveedor
	ids_lista.object.importe_cp 	[ll_i] = adc_importe_cp
	ids_lista.object.importe_rh 	[ll_i] = adc_importe_rh
	
end if

return true
end function

public function boolean remove (string as_proveedor);Long 		ll_i
String	ls_ruc, ls_tipo_doc_ident, ls_mensaje

//Obtengo el RUC del proveedor
select decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident), p.tipo_doc_ident
  into :ls_ruc, :ls_tipo_doc_ident
  from proveedor p
 where p.proveedor = :as_proveedor;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al obtener los datos de la tabla ' &
							+ 'PROVEEDOR, Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

if ls_tipo_doc_ident = '6' then
	ROLLBACK;
	MessageBox('Error', 'El procedimiento es solo para Empresas unicamente con RUC', StopSign!)
	return false
end if


for ll_i = 1 to ids_lista.RowCount()
	if ids_lista.object.ruc [ll_i] = ls_ruc then
		ids_lista.deleteRow(ll_i)
		return true
	end if
next

return false
end function

public function integer size ();return ids_lista.RowCount()
end function

public function decimal get_importe_cp (long al_row);if ids_lista.RowCount() <= al_row then
	return Dec(ids_lista.object.importe_cp [al_row])
else
	return -1
end if
end function

public function decimal get_importe_rh (long al_row);if ids_lista.RowCount() <= al_row then
	return Dec(ids_lista.object.importe_rh [al_row])
else
	return -1
end if
end function

public function String get_ruc (long al_row);if ids_lista.RowCount() <= al_row then
	return ids_lista.object.ruc [al_row]
else
	return ''
end if
end function

public function string get_nom_proveedor (long al_row);if ids_lista.RowCount() <= al_row then
	return ids_lista.object.nom_proveedor [al_row]
else
	return ''
end if
end function

public function string of_create_txt (date ad_fec_pago);String 		ls_filename_txt, ls_mensaje, ls_texto
Long			ll_ult_nro, ll_count, ll_i
decimal		ldc_importe
n_cst_file	lnvo_file

if ids_lista.RowCount() = 0 then 
	setNull(ls_filename_txt)
	return ls_filename_txt
end if

//Genero el nro_rc
ls_filename_txt = "RCP" + String(ad_fec_pago, 'yyyymmdd')

//Obtengo el ultimo numero
select count(*)
	into :ll_count
from num_tablas
where tabla 	= :ls_filename_txt
  and origen	= 'XX';

if ll_count = 0 then
	insert into num_Tablas(tabla, origen, ult_nro)
	values(:ls_filename_txt, 'XX', 1);
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al insertar registro en tabla num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
		return gnvo_app.is_null
	end if
end if

select ult_nro
	into :ll_ult_nro
from num_tablas
where tabla 	= :ls_filename_txt
  and origen	= 'XX' for update;

//Incremento el numerador
update num_tablas
   set ult_nro = :ll_ult_nro + 1
where tabla 	= :ls_filename_txt
  and origen	= 'XX';

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al ACTUALIZAR registro en tabla num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
	return gnvo_app.is_null
end if

//Genero el filename nuevo
ls_filename_txt = "RCP" + String(ad_fec_pago, 'yyyymmdd') + string(ll_ult_nro, '000') + '.txt'

//Obtengo el nombre completo
ls_filename_txt = lnvo_file.of_get_fullname(ls_filename_txt, ad_fec_pago)

if FileExists(ls_filename_txt) then
	FileDelete(ls_filename_txt)
end if

for ll_i = 1 to ids_lista.RowCount()
	ldc_importe = Dec(ids_lista.object.importe_cp [ll_i]) + Dec(ids_lista.object.importe_rh [ll_i])
	ls_texto = ids_lista.object.ruc [ll_i] + '|' + string(ldc_importe)
	lnvo_file.of_write( ls_filename_txt, ls_texto)
next


	
return ls_filename_txt
end function

on n_cst_rcem.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_rcem.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;destroy ids_lista
end event

event constructor;ids_lista = create u_ds_base  

ids_lista.DataObject = 'd_lista_ruc_importe_tbl'
ids_lista.setTransObject(SQLCA)


end event

