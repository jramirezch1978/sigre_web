$PBExportHeader$w_cm306_cotizacion_bienes_gen.srw
forward
global type w_cm306_cotizacion_bienes_gen from w_abc
end type
type sle_nro from u_sle_codigo within w_cm306_cotizacion_bienes_gen
end type
type cb_1 from commandbutton within w_cm306_cotizacion_bienes_gen
end type
type st_nro from statictext within w_cm306_cotizacion_bienes_gen
end type
type sle_ori from singlelineedit within w_cm306_cotizacion_bienes_gen
end type
type st_ori from statictext within w_cm306_cotizacion_bienes_gen
end type
type tab_1 from tab within w_cm306_cotizacion_bienes_gen
end type
type tabpage_1 from userobject within tab_1
end type
type cb_sc from commandbutton within tabpage_1
end type
type cb_ot from commandbutton within tabpage_1
end type
type cb_pc from commandbutton within tabpage_1
end type
type dw_art_cot from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_sc cb_sc
cb_ot cb_ot
cb_pc cb_pc
dw_art_cot dw_art_cot
end type
type tabpage_2 from userobject within tab_1
end type
type dw_lotes from u_dw_abc within tabpage_2
end type
type dw_pos_prov from u_dw_abc within tabpage_2
end type
type st_1 from statictext within tabpage_2
end type
type st_2 from statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_lotes dw_lotes
dw_pos_prov dw_pos_prov
st_1 st_1
st_2 st_2
end type
type tabpage_4 from userobject within tab_1
end type
type dw_prov_sel from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_prov_sel dw_prov_sel
end type
type tabpage_3 from userobject within tab_1
end type
type cbx_mostrar from checkbox within tabpage_3
end type
type dw_det_cotiz from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cbx_mostrar cbx_mostrar
dw_det_cotiz dw_det_cotiz
end type
type tab_1 from tab within w_cm306_cotizacion_bienes_gen
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type
type dw_master from u_dw_abc within w_cm306_cotizacion_bienes_gen
end type
end forward

global type w_cm306_cotizacion_bienes_gen from w_abc
integer width = 3662
integer height = 2552
string title = "cotizacion  de bienes - [CM306]"
string menuname = "m_mtto_imp_mail"
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
event ue_cancelar ( )
sle_nro sle_nro
cb_1 cb_1
st_nro st_nro
sle_ori sle_ori
st_ori st_ori
tab_1 tab_1
dw_master dw_master
end type
global w_cm306_cotizacion_bienes_gen w_cm306_cotizacion_bienes_gen

type variables
//u_ds_base ids_prov
String 		is_FLAG_RESTRIC_COMP_OC, is_salir, &
				is_doc_ot, is_oper_cons_int
Boolean		ib_flag_delete, ib_chg_cant_art = false

u_dw_abc  	idw_otro, idw_art_cot, idw_lotes, &
				idw_pos_prov, idw_det_cot, idw_prov_sel

//idw_art_cot  = articulos que se van a cotizar
//idw_lotes    = Las SubCategorias de los articulos
//idw_det_cot  = Es el detalle de la cotizacion de Bienes
//idw_prov_sel = Indican a los proveedores seleccionados


end variables

forward prototypes
public function integer of_set_numera ()
public function integer of_lotes ()
public function integer of_set_prov_articulo (string as_valor)
public function integer of_set_status_doc (datawindow idw)
public subroutine of_dw_sort ()
public subroutine of_retrieve (string as_origen, string as_nro)
public subroutine of_filtrar_det_cot (boolean ab_check)
public subroutine of_verifica_art (long al_row)
public subroutine of_add_art_cot (long al_row)
public function integer of_get_param ()
public function integer of_act_cant_articulo ()
end prototypes

event ue_anular();Long j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

if dw_master.GetRow() <= 0 then return

// Anulando Cabecera
dw_master.Object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1		// Activa para grabacion
is_action = 'anu'
of_Set_status_doc( dw_master )
end event

event ue_cancelar();// Cancela operacion, limpia todo
EVENT ue_update_request()   // Verifica actualizaciones pendientes

dw_master.reset()
idw_art_cot.reset()

sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()

is_Action = ''
of_set_status_doc(dw_master)
end event

public function integer of_set_numera ();// Numera documento
Long j
String  ls_next_nro, ls_cod_origen

if dw_master.getrow() = 0 then return 1
ls_cod_origen = gs_origen
if is_action = 'new' then
	ls_next_nro = f_numera_documento('num_cotizacion',10)
	if ls_next_nro = '0' then
		return 0
	else
		dw_master.object.nro_cotiza[dw_master.getrow()] = ls_next_nro
		dw_master.object.cod_origen[dw_master.getrow()] = ls_cod_origen
	end if
else
	ls_next_nro = dw_master.object.nro_cotiza[dw_master.getrow()]
	ls_cod_origen = dw_master.object.cod_origen[dw_master.getrow()]
end if

// Asigna numero a detalle
for j = 1 to idw_art_cot.RowCount()
	idw_art_cot.object.cod_origen[j] = ls_cod_origen
	idw_art_cot.object.nro_cotiza[j] = ls_next_nro	
next

// Numera dw articulos
for j = 1 to idw_det_cot.RowCount()
	idw_det_cot.object.cod_origen[j] = ls_cod_origen
	idw_det_cot.object.nro_cotiza[j] = ls_next_nro	
next

// numera dw proveedor
for j = 1 to idw_prov_sel.RowCount()
	idw_prov_sel.object.cod_origen[j] = ls_cod_origen
	idw_prov_sel.object.nro_cotiza[j] = ls_next_nro
next


return 1
end function

public function integer of_lotes ();// Segun articulos ingresados, encuentra los lotes.

Long 		ll_j, ll_found, ll_row
String 	ls_sub_cat, ls_cod_art, ls_desc_sub_cat

idw_lotes.reset()
ll_row = idw_art_cot.RowCount()
for ll_j = 1 to ll_row
	ls_cod_art 		 = idw_art_cot.object.cod_art			[ll_j]
	ls_sub_cat 		 = idw_art_cot.object.cod_sub_cat	[ll_j]
	ls_desc_sub_cat = idw_art_cot.object.desc_sub_cat	[ll_j]
	
	// Verifica que no se duplique
	ll_found = idw_lotes.find( "trim(cod_sub_cat) = '" + trim(ls_sub_cat) + "'", 1, ll_row)
	
	if ll_found = 0 then
		idw_lotes.event ue_insert()
		if idw_lotes.il_row > 0 then	// Si adiciono correctamente		 	 
			idw_lotes.object.cod_sub_cat	[idw_lotes.il_row] = ls_sub_cat
			idw_lotes.object.desc_sub		[idw_lotes.il_row] = trim(ls_desc_sub_cat)
		 end if
	 end if
Next

// Posiciona en primer registro
if idw_lotes.RowCount() > 0 then
	idw_lotes.ScrollToRow( 1 )
end if

return 1

end function

public function integer of_set_prov_articulo (string as_valor);/*

  Funcion que actualiza dw.
*/

String 	ls_sub_cat, ls_proveedor, ls_cod_art, &
			ls_filtro, ls_desc_sub_cat, ls_nom_prov, &
			ls_desc_art, ls_und, ls_flag_cotizo
Long 		ll_row, ll_found, j, k, ll_j, ll_find, ll_count
Boolean 	lb_existe

ll_row = idw_lotes.GetRow()
if ll_Row = 0 then return 0

ls_sub_cat 			= trim(idw_lotes.object.cod_sub_cat	[ll_row])
ls_desc_sub_cat 	= trim(idw_lotes.object.desc_sub		[ll_row])

ll_row = idw_pos_prov.GetRow()
if ll_Row = 0 then return 0
ls_proveedor 		= idw_pos_prov.object.proveedor[ll_row]
ls_nom_prov 		= idw_pos_prov.object.nom_proveedor[ll_row]

if as_valor = '1' THEN  // Se adiciona
	ll_find = idw_prov_sel.Find("trim(proveedor) = '" + trim(ls_proveedor) &
		+ "'", 1, idw_prov_sel.RowCount())
		
	if ll_find = 0 then
		ll_row = idw_prov_sel.event ue_insert()
	else
		ll_row = ll_find
	end if
	
	if ll_row <= 0 then
		MessageBox('Aviso', 'No se ha podido insertar correctamente el proveedor', Exclamation!)
		return 0
	end if
	
	// Adiciona proveedor en idw_prov_sel
	idw_prov_sel.object.proveedor		[ll_row] = ls_proveedor
	idw_prov_sel.object.nom_proveedor[ll_row] = ls_nom_prov
	idw_prov_sel.object.cotizo			[ll_row] = '0'
	idw_prov_sel.ii_update = 1
	
	// Adiciona nuevos articulos, segun Subcategoria seleccionada en idw_det_cot						

	ls_filtro = "trim(cod_sub_cat) = '" + trim(ls_sub_cat) + "'"
		
	idw_art_cot.SetFilter(ls_filtro)
	idw_art_cot.Filter()
			
	For ll_j = 1 to idw_art_cot.RowCount()
		ls_cod_art 	= idw_art_cot.object.cod_art	[ll_j]
		ls_desc_art = idw_art_cot.object.desc_art	[ll_j]
		ls_und		= idw_art_cot.object.und		[ll_j]
		
		ll_find = idw_det_cot.Find("trim(proveedor) = '" + trim(ls_proveedor) + "' and " &
				+ "trim(cod_art) = '" + trim(ls_cod_art) + "'", 1, idw_det_cot.RowCount() )
	
		if ll_find = 0 then
			ll_row = idw_det_cot.event ue_insert()		
			if ll_row > 0 then				
				idw_det_cot.object.proveedor		[ll_row] = ls_proveedor
				idw_det_cot.object.nom_proveedor	[ll_row] = ls_nom_prov
				idw_det_cot.object.cod_art			[ll_row] = ls_cod_art
				idw_det_cot.object.desc_art		[ll_row] = ls_desc_art
				idw_det_cot.object.und				[ll_row] = ls_und
				idw_det_cot.object.cod_sub_cat	[ll_row] = ls_sub_cat
				idw_det_cot.object.flag_ganador	[ll_row] = '0'
				idw_det_cot.object.cant_cotizada	[ll_row] = idw_art_cot.object.cant_cotizada[ll_j]
				idw_det_cot.ii_update = 1
			end if
		else
			idw_det_cot.object.cant_cotizada	[ll_find] = idw_art_cot.object.cant_cotizada[ll_j]		
		end if
		
		
		idw_det_cot.ii_update = 1
	next
	
	// Desactiva filtro
	idw_art_cot.SetFilter("")
	idw_art_cot.Filter()
	
elseif as_valor = '0' then
	ll_find = idw_prov_sel.Find("trim(proveedor) = '" &
		+ trim(ls_proveedor) + "'", 1, idw_prov_sel.RowCount())
	if ll_find = 0 then return 0
	
	ll_row = ll_find
	ls_flag_cotizo = idw_prov_sel.object.cotizo[ll_row]
	
	if ls_flag_cotizo = '1' then
		MessageBox('Aviso', 'No puedo sacar a Proveedor porque ya cotizo', StopSign!)
		return 0
	end if
	
	idw_prov_sel.deleterow( ll_row )
	idw_prov_sel.ii_update = 1
	
	ll_find = idw_det_cot.Find("trim(proveedor) = '" + trim(ls_proveedor) &
		+ "' and trim(cod_sub_cat) ='" + trim(ls_sub_cat) + "'", &
		1, idw_det_cot.RowCount())
	
	do while ll_find > 0 
		
  		idw_det_cot.deleterow( ll_find )
		ll_find = idw_det_cot.Find("trim(proveedor) = '" + trim(ls_proveedor) &
				+ "' and trim(cod_sub_cat) ='" + trim(ls_sub_cat) + "'", &
				1, idw_det_cot.RowCount())
		idw_det_cot.ii_update = 1
	loop	

	
end if

return 1
end function

public function integer of_set_status_doc (datawindow idw);this.changemenu(m_mtto_imp_mail)  // activa menu
Int li_estado
if dw_master.getrow() = 0 then return 0

if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if
m_master.m_file.m_printer.m_print1.enabled 			= true

if is_Action = 'new' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false		

	// Activa desactiva opcion de modificacion, eliminacion	
	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	else
		m_master.m_file.m_basedatos.m_insertar.enabled = true
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if
	end if
end if

if is_Action = 'open' then
	li_estado = Long( dw_master.object.flag_estado[dw_master.getrow()])

	Choose case li_estado
		case 0		// Anulado	
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled 	= false
		m_master.m_file.m_basedatos.m_anular.enabled 		= false
	CASE 2,4,5   // Aprobado, Atendido parcial, total
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled 	= false
		m_master.m_file.m_basedatos.m_anular.enabled 		= false
		if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
			if is_flag_insertar = '1' then
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			else
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if
	   else			
		   m_master.m_file.m_basedatos.m_insertar.enabled = false
	   end if
	end CHOOSE
end if

if is_Action = 'anu' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled 			= false
	m_master.m_file.m_basedatos.m_email.enabled 	= false
end if

if is_Action = 'edit' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if

if is_Action = 'del' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if
return 1
end function

public subroutine of_dw_sort ();Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(idw_otro.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(idw_otro.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(idw_otro.ii_ck[li_x]) +" A"
NEXT

idw_otro.SetSort (ls_sort)
idw_otro.Sort()

end subroutine

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)
is_action = 'open'
dw_master.object.p_logo.FileName = gs_logo
dw_master.post event ue_refresh_det()
idw_1 = dw_master
idw_1.SetFocus()

idw_1.ii_protect = 0
idw_1.of_protect()

idw_art_cot.ii_protect = 0
idw_art_cot.of_protect()

idw_prov_sel.ii_protect = 0
idw_prov_sel.of_protect()

idw_det_cot.ii_protect = 0
idw_det_cot.of_protect()
end subroutine

public subroutine of_filtrar_det_cot (boolean ab_check);string 	ls_proveedor, ls_filtro, ls_ordena
Long		ll_row

if ab_check = false then
	ll_row = idw_prov_sel.GetRow()
	
	f_select_current_row(idw_pos_prov)
	
	
	if ll_row <= 0 then return
			
	ls_proveedor = idw_prov_sel.object.proveedor[ll_row]
	ls_filtro = "proveedor = '" + ls_proveedor + "'"
else
	ls_filtro = ''
end if
		
idw_det_cot.SetFilter(ls_filtro)
idw_det_cot.Filter()		

ls_ordena = "proveedor A, cod_art A"

idw_det_cot.SetSort(ls_ordena)
idw_det_cot.Sort()

end subroutine

public subroutine of_verifica_art (long al_row);string	ls_sub_cat, ls_cod_art, ls_prove
long		ll_find, ll_j

if al_row <= 0 then return

ls_sub_cat	= idw_art_cot.object.cod_sub_cat	[al_row]

ll_find = idw_lotes.Find("trim(sub_cat) = '" + trim(ls_sub_cat) + "'", &
	1, idw_lotes.RowCount() )

if ll_find = 0 then return

if ll_find > 0 then
	If MessageBox('Aviso', 'Deseas ingresar el articulo al detalle de la cotizacion?', &
		Information!, YesNo!, 2) = 2 then return
	
	idw_lotes.event ue_output(al_row)
	if idw_pos_prov.RowCount() = 0 then return
	
	for ll_j = 1 to idw_pos_prov.RowCount()
		if idw_pos_prov.object.flag_estado[ll_j] = '1' then
			of_set_prov_articulo('1')
		end if
	next
	
end if

end subroutine

public subroutine of_add_art_cot (long al_row);string 	ls_cod_art, ls_desc_art, ls_sub_cat, ls_und, ls_desc_sub_cat
decimal	ldc_cant_cot
Long		ll_find, ll_row

ls_cod_art 	= idw_det_cot.object.cod_art		[al_row]
ls_desc_art = idw_det_cot.object.desc_art		[al_row]
ls_und		= idw_det_cot.object.und			[al_row]
ls_sub_cat	= idw_det_cot.object.cod_sub_cat	[al_row]
ls_und		= idw_det_cot.object.und			[al_row]
ldc_cant_cot = dec(idw_det_cot.object.cant_cotizada[al_row])

select desc_sub_Cat
	into :ls_desc_sub_cat
from articulo_sub_categ
where cod_sub_cat = :ls_sub_Cat;

ll_find = idw_art_cot.Find("trim(cod_art) = '" + trim(ls_cod_art) &
		+ "'", 1, idw_art_cot.RowCount())

if ll_find = 0 then
	ll_row = idw_art_cot.event ue_insert()
	if ll_row > 0 then
		idw_art_cot.object.cod_art			[ll_row] = ls_cod_art
		idw_art_cot.object.desc_art		[ll_row] = ls_desc_art
		idw_art_cot.object.und				[ll_row]	= ls_und
		idw_art_cot.object.cod_sub_cat	[ll_row] = ls_sub_cat
		idw_art_cot.object.desc_sub_cat	[ll_row] = ls_desc_sub_cat
		idw_art_cot.object.cant_cotizada	[ll_row] = ldc_cant_cot
	end if
end if
	

end subroutine

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
SELECT 	NVL(FLAG_RESTRIC_COMP_OC, '0'), oper_cons_interno, doc_ot
	INTO 	:is_FLAG_RESTRIC_COMP_OC, :is_oper_cons_int, :is_doc_ot
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en Logparam")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

return 1
end function

public function integer of_act_cant_articulo ();/*

  Funcion que actualiza dw.
*/

String 	ls_cod_art
Long 		ll_find, ll_j

For ll_j = 1 to idw_det_cot.RowCount()
	ls_cod_art 	= idw_det_cot.object.cod_art	[ll_j]
	
	ll_find = idw_art_cot.Find("trim(cod_art) = '" + trim(ls_cod_art) + "'", 1, idw_det_cot.RowCount() )

	if ll_find > 0 then
		if dec(idw_det_cot.object.cant_cotizada[ll_j]) <> dec(idw_art_cot.object.cant_cotizada[ll_find]) then
			idw_det_cot.object.cant_cotizada	[ll_j] = idw_art_cot.object.cant_cotizada[ll_find]		
			idw_det_cot.ii_update = 1
		end if
	end if
	
next


return 1
end function

on w_cm306_cotizacion_bienes_gen.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.st_nro=create st_nro
this.sle_ori=create sle_ori
this.st_ori=create st_ori
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.sle_ori
this.Control[iCurrent+5]=this.st_ori
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.dw_master
end on

on w_cm306_cotizacion_bienes_gen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.sle_ori)
destroy(this.st_ori)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

idw_art_cot = tab_1.tabpage_1.dw_art_cot
idw_lotes	= tab_1.tabpage_2.dw_lotes
idw_pos_prov= tab_1.tabpage_2.dw_pos_prov
//Detalle de la cotizacion
idw_det_cot = tab_1.tabpage_3.dw_det_cotiz
//Proveedores Seleccionados
idw_prov_sel = tab_1.tabpage_4.dw_prov_sel

dw_master.SetTransObject(SQLCA)  		// Relacionar el dw con la base de datos
idw_prov_sel.SetTransObject(SQLCA)
idw_det_cot.SetTransObject(SQLCA)

idw_art_cot.SetTransObject(sqlca)
idw_lotes.SetTransObject(sqlca)
idw_pos_prov.SetTransObject(sqlca)
idw_prov_sel.SetTransObject(sqlca)

idw_1 = dw_master              		// asignar dw corriente
idw_1.SetFocus()
dw_master.of_protect()         		// bloquear modificaciones 
idw_art_cot.of_protect()

//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
dw_master.object.p_logo.FileName = gs_logo


end event

event ue_insert;Long ll_row

// Limpia dw cuando es nuevo documento
IF idw_1 = dw_master THEN
	idw_det_cot.reset()
	idw_prov_sel.reset()
	dw_master.reset()
	idw_art_cot.reset()
	idw_lotes.reset()
	idw_pos_prov.reset()
END IF

// Fuerza a que no adicione 
if idw_1 = idw_lotes then
	MEssagebox( "Aviso", "No se puede adicionar en Subcategorias", Exclamation!)
	Return 
end if

// Fuerza a que no adicione 
if idw_1 = idw_pos_prov then
	MessageBox( "Aviso", "No se puede adicionar Posibles Proveedores", Exclamation!)
	Return 
end if

ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
idw_det_cot.AcceptText()
idw_prov_sel.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF
IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

if ib_flag_delete = true then
	// Cuando se ha borrado algo de los Proveedores
	// Seleccionados debo grabar primero el detalle
	// Para que no me salga el error
	
	ib_flag_delete = false
	IF	idw_det_cot.ii_update = 1 AND lbo_ok = TRUE THEN	
		IF idw_det_cot.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF idw_prov_sel.ii_update = 1 AND lbo_ok = TRUE THEN	
		IF idw_prov_sel.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
else
	// de otra manera grabo de manera normal
	IF idw_prov_sel.ii_update = 1 AND lbo_ok = TRUE THEN	
		IF idw_prov_sel.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	IF	idw_det_cot.ii_update = 1 AND lbo_ok = TRUE THEN	
		IF idw_det_cot.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_det_cot.ii_update = 0	
	idw_prov_sel.ii_update = 0	
ELSE 
	ROLLBACK USING SQLCA;
END IF

of_set_status_doc(dw_master)  // Actualiza opciones de menu
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = false

if idw_det_cot.RowCount() = 0 then
	MessageBox('Aviso', 'No puede grabar una cotizacion sin detalle')
	return
end if

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_det_cot, "tabular") <> true then	
	return
end if

if f_row_Processing( idw_prov_sel, "tabular") <> true then	
	return
end if

if of_set_numera() = 0 then	
	return	
end if

is_action = ''
ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_det_cot.of_set_flag_replicacion()
idw_prov_sel.of_set_flag_replicacion()

if ib_chg_cant_art = true then
	ib_chg_cant_art = false
	
	this.of_act_cant_articulo( ) // Actualizo la cantidad del articulo
end if
end event

event ue_print;call super::ue_print;str_parametros lstr_rep

if dw_master.GetRow() <= 0 then return

lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_cotiza[dw_master.getrow()]

openWithParm (w_sel_cotizacion_proveedor, lstr_rep)
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_sel_cotizaciones_tbl"
sl_param.titulo = "Cotizaciones de Bienes"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = 'B'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	dw_master.retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
	is_action = 'open'
	dw_master.event ue_refresh_det()	
END IF
end event

event type long ue_scrollrow(string as_value);call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)
dw_master.post event ue_refresh_det()

RETURN ll_rc
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
idw_art_cot.of_protect()
idw_prov_sel.of_protect()
idw_det_cot.of_protect()
end event

event ue_mail_send();// Override
str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_cotiza[dw_master.getrow()]

openWithParm (w_sel_cotizacion_proveedor_email, lstr_rep)

end event

event resize;CommandButton lcb_pc, lcb_sc, lcb_sca

idw_art_cot = tab_1.tabpage_1.dw_art_cot
idw_lotes	= tab_1.tabpage_2.dw_lotes
idw_pos_prov= tab_1.tabpage_2.dw_pos_prov
//Detalle de la cotizacion
idw_det_cot = tab_1.tabpage_3.dw_det_cotiz
//Proveedores Seleccionados
idw_prov_sel = tab_1.tabpage_4.dw_prov_sel

lcb_pc  = tab_1.tabpage_1.cb_pc
lcb_sc  = tab_1.tabpage_1.cb_ot
lcb_sca = tab_1.tabpage_1.cb_sc

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width = newwidth - tab_1.X - 10
tab_1.height = newheight - tab_1.y - 10

lcb_pc.y = tab_1.height - lcb_pc.height - 150
lcb_pc.x = tab_1.width/2 - lcb_pc.width - 20

lcb_sc.y = tab_1.height - lcb_sc.height - 150
lcb_sc.x = tab_1.width/2 + 20

lcb_sca.y = tab_1.height - lcb_sca.height - 150
lcb_sca.x = tab_1.width/2 + 540

idw_art_cot.height = tab_1.height - idw_art_cot.y - 300
idw_art_cot.width  = tab_1.width - idw_art_cot.x - 50

idw_lotes.height = tab_1.height - idw_lotes.y - 150

idw_pos_prov.height = tab_1.height - idw_pos_prov.y - 150
idw_pos_prov.width  = tab_1.width - idw_pos_prov.x - 50

idw_det_cot.height = tab_1.height - idw_det_cot.y - 150
idw_det_cot.width  = tab_1.width - idw_det_cot.x - 50

idw_prov_sel.height = tab_1.height - idw_prov_sel.y - 300
idw_prov_sel.width  = tab_1.width - idw_prov_sel.x - 50

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 	OR &
	idw_det_cot.ii_update = 1 	OR &
	idw_prov_sel.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_det_cot.ii_update = 0
		idw_prov_sel.ii_update = 0
	END IF
	
END IF
end event

event open;call super::open;idw_art_cot = tab_1.tabpage_1.dw_art_cot
idw_lotes	= tab_1.tabpage_2.dw_lotes
idw_pos_prov= tab_1.tabpage_2.dw_pos_prov
//Detalle de la cotizacion
idw_det_cot = tab_1.tabpage_3.dw_det_cotiz
//Proveedores Seleccionados
idw_prov_sel = tab_1.tabpage_4.dw_prov_sel
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

type sle_nro from u_sle_codigo within w_cm306_cotizacion_bienes_gen
integer x = 923
integer y = 12
integer width = 471
integer height = 92
integer taborder = 20
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.Triggerevent( clicked!)
end event

type cb_1 from commandbutton within w_cm306_cotizacion_bienes_gen
integer x = 1454
integer y = 8
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()
of_retrieve(sle_ori.text, sle_nro.text)
end event

type st_nro from statictext within w_cm306_cotizacion_bienes_gen
integer x = 626
integer y = 24
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_cm306_cotizacion_bienes_gen
integer x = 347
integer y = 12
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_ori from statictext within w_cm306_cotizacion_bienes_gen
integer x = 96
integer y = 24
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type tab_1 from tab within w_cm306_cotizacion_bienes_gen
event create ( )
event destroy ( )
integer y = 728
integer width = 3360
integer height = 1116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_3)
end on

event selectionchanged;string 	ls_proveedor, ls_filtro
Long 		ll_row

parent.SetMicroHelp( "" )

choose case newindex
	case 2 //posibles proveedores
      of_lotes()
		parent.SetMicroHelp( "Seleccione SubCategoria " )
	case 4
		of_filtrar_det_cot(tab_1.tabpage_3.cbx_mostrar.checked)
		of_act_cant_articulo( )
		
		
end choose
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3323
integer height = 988
long backcolor = 79741120
string text = "Articulos a cotizar"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_sc cb_sc
cb_ot cb_ot
cb_pc cb_pc
dw_art_cot dw_art_cot
end type

on tabpage_1.create
this.cb_sc=create cb_sc
this.cb_ot=create cb_ot
this.cb_pc=create cb_pc
this.dw_art_cot=create dw_art_cot
this.Control[]={this.cb_sc,&
this.cb_ot,&
this.cb_pc,&
this.dw_art_cot}
end on

on tabpage_1.destroy
destroy(this.cb_sc)
destroy(this.cb_ot)
destroy(this.cb_pc)
destroy(this.dw_art_cot)
end on

type cb_sc from commandbutton within tabpage_1
integer x = 1970
integer y = 676
integer width = 485
integer height = 88
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sub. Categ. Artículo"
end type

event clicked;if dw_master.GEtRow() = 0 then return

str_parametros lstr_param

lstr_param.tipo		= ''
lstr_param.opcion		= 19
lstr_param.titulo 	= 'Selección de Artículos por SubCategoría'
lstr_param.dw_master	= 'd_abc_sub_categ_art_tbl'
lstr_param.dw1			= 'd_abc_articulo_sub_categ_todos_tbl'
lstr_param.dw_d		=  idw_art_cot
				
OpenWithParm( w_abc_seleccion_md, lstr_param)
	



end event

type cb_ot from commandbutton within tabpage_1
integer x = 1422
integer y = 676
integer width = 462
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Orden Trabajo"
end type

event clicked;str_parametros lstr_param

lstr_param.tipo = ''
SetNull(lstr_param.fecha1)
SetNull(lstr_param.fecha2)

if dw_master.GEtRow() = 0 then return

OpenWithParm( w_abc_datos_ot, lstr_param )

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm
if lstr_param.titulo = 'n' then return

lstr_param.dw_master 	= "d_list_orden_trabajo_grd"
lstr_param.dw1       	= "d_list_articulo_mov_proy_x_ot_grd"	
lstr_param.titulo 		= "Ordenes de Trabajo pendientes"
lstr_param.dw_m 			= dw_master
lstr_param.dw_d 			= idw_art_cot
lstr_param.tipo_doc		= is_doc_ot
lstr_param.opcion 		= 4
lstr_param.tipo			= 'NRO_DOC'
lstr_param.oper_cons_interno = is_oper_cons_int

OpenWithParm( w_abc_seleccion_md, lstr_param)

ib_chg_cant_art = true
end event

type cb_pc from commandbutton within tabpage_1
integer x = 859
integer y = 680
integer width = 462
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Programa compras"
end type

event clicked;// Asigna valores a structura 

str_parametros lstr_param 
SetNull(lstr_param.fecha1)
SetNull(lstr_param.fecha2)

if dw_master.GEtRow() = 0 then return

lstr_param.tipo = 'PROG_COMPRAS'

OpenWithParm( w_abc_datos_ot, lstr_param )

if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm
if lstr_param.titulo = 'n' then return

if is_FLAG_RESTRIC_COMP_OC = '1' then
	lstr_param.dw_master 	= "d_list_prog_compras_pend_usuario_tbl"
	lstr_param.dw1 			= 'd_sel_progr_compras_pend_usuario_det'
else
	lstr_param.dw_master 	= "d_list_prog_compras_pend_tbl"
	lstr_param.dw1 			= 'd_sel_programa_compras_pend_det'
end if

lstr_param.titulo 		= "Programas de compra pendientes"
lstr_param.dw_m 			= dw_master
lstr_param.dw_d 			= idw_art_cot
lstr_param.string6		= gs_user
lstr_param.tipo			= 'PROG_COMPRAS'

if is_FLAG_RESTRIC_COMP_OC = '1' then
	lstr_param.opcion 		= 16	
else
	lstr_param.opcion 		= 7	
end if

OpenWithParm( w_abc_seleccion_md, lstr_param)	

end event

type dw_art_cot from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer y = 8
integer width = 3301
integer height = 640
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_inp_cotizacion_articulos_204_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);// Abre ventana de ayuda 
String ls_cod_art, ls_sub_cat, ls_desc_sub_cat
str_parametros sl_param

IF lower(as_columna) = 'cod_art' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		ls_cod_art = sl_param.field_ret[1]
		this.object.cod_art	[al_row] = ls_cod_art
		this.object.desc_art	[al_row] = sl_param.field_ret[2]
		this.object.und		[al_row] = sl_param.field_ret[3]
		
		select a.sub_cat_art, b.desc_sub_cat
			into :ls_sub_cat, :ls_desc_sub_cat
		from articulo a, articulo_sub_categ b
		where a.sub_cat_art = b.cod_sub_cat
		  and a.cod_art = :ls_cod_art;
		
		this.object.cod_sub_cat		[al_row] = ls_sub_cat
		this.object.desc_sub_cat	[al_row] = ls_desc_sub_cat
		

 	END IF
END IF
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular'	

ii_ck[1] = 1 

end event

event rowfocuschanged;call super::rowfocuschanged;IF CurrentRow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_otro.ScrollToRow(ll_row)

end event

event ue_delete_pos;call super::ue_delete_pos;if this.rowCount() = 0 then
	cb_ot.enabled = true	
end if
end event

event doubleclicked;call super::doubleclicked;string ls_columna
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if
end event

event itemchanged;call super::itemchanged;String ls_und, ls_desc_art, ls_null, ls_sub_Cat, ls_desc_sub_Cat

SetNull( ls_null)
IF dwo.name = "cod_art" then
	if gnvo_app.almacen.of_articulo_inventariable( data ) <> 1 then 
		this.object.cod_art[row] = ls_null
		this.object.desc_art[row] = ls_null
		this.object.und[row] = ls_null
		return 1
	end if

	Select a.desc_art, a.und, a.SUB_CAT_ART, b.desc_sub_Cat
		into :ls_desc_art, :ls_und, :ls_sub_cat, :ls_desc_sub_cat
	from articulo a,
		  articulo_sub_Categ b
   Where a.sub_cat_Art = b.cod_sub_cat
	  and cod_Art = :data;
	
	this.object.desc_Art			[row] = ls_desc_art
	this.object.und				[row] = ls_und
	this.object.cod_sub_cat		[row] = ls_sub_cat
	this.object.desc_sub_cat	[row] = ls_desc_sub_cat
	
end if
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cant_cotizada[al_row] = 0
this.setcolumn('cod_art')
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event ue_insert;//Ancestor Script Override

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this )
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3323
integer height = 988
long backcolor = 79741120
string text = "Posibles proveedores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_lotes dw_lotes
dw_pos_prov dw_pos_prov
st_1 st_1
st_2 st_2
end type

on tabpage_2.create
this.dw_lotes=create dw_lotes
this.dw_pos_prov=create dw_pos_prov
this.st_1=create st_1
this.st_2=create st_2
this.Control[]={this.dw_lotes,&
this.dw_pos_prov,&
this.st_1,&
this.st_2}
end on

on tabpage_2.destroy
destroy(this.dw_lotes)
destroy(this.dw_pos_prov)
destroy(this.st_1)
destroy(this.st_2)
end on

type dw_lotes from u_dw_abc within tabpage_2
event ue_busca_prov ( long al_row )
integer y = 108
integer width = 1632
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_inp_cotizacion_subcat_204"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 
ii_dk[2] = 2
idw_det  = dw_pos_prov
is_dwform = 'tabular'
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

event ue_output;call super::ue_output;String 	ls_sub_cat, ls_proveedor, ls_filtro
Long		ll_find, ll_j

this.AcceptText()
	
ls_sub_Cat = trim(this.object.cod_sub_cat[al_row])

dw_pos_prov.Retrieve(ls_sub_cat)
	
// Verifico si hay prov. a cotizar	
if dw_pos_prov.RowCount() = 0 then	
	Messagebox( "Atencion", "SubCategoria no tiene proveedores a cotizar", exclamation!)		
	return
end if

// Le pongo un check a todos aquellos proveedores
// que ya estan en la cotizacion
idw_det_cot.SetFilter('')
idw_det_cot.Filter()

for ll_j = 1 to idw_pos_prov.RowCount()
	ls_proveedor = idw_pos_prov.object.proveedor[ll_j]
	
	ll_find = idw_det_cot.find("proveedor = '" + ls_proveedor + "' and " &
		+ "cod_sub_cat = '" + ls_sub_cat + "'", 1, idw_det_cot.RowCount() )
	
	if ll_find > 0 then
		idw_pos_prov.object.flag_estado[ll_j] = '1'
	end if
next

if idw_prov_sel.RowCount() > 0 then
	idw_prov_sel.ScrollToRow(1)
end if



end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this )
end event

type dw_pos_prov from u_dw_abc within tabpage_2
integer x = 1669
integer y = 108
integer width = 1614
integer height = 672
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_sub_cat_grid"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		
idw_mst  = dw_master
is_dwform = 'tabular'	
//
ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos d
ii_rk[2] = 2

ii_ss = 1

end event

event itemerror;call super::itemerror;Return 1    // Fuerza a no mostrar mensaje
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String ls_name, ls_prot
str_parametros sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_name = 'proveedor'  and ls_prot = '0' then
		sl_param.dw1 = "d_dddw_proveedor"
		sl_param.titulo = "Proveedores"
		sl_param.field_ret_i[1] = 1

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then
			this.object.proveedor[row] = sl_param.field_ret[1]
		END IF
END IF
end event

event itemchanged;// Activa/Inactiva proveedores, debe actualizar dw articulos y proveedores
string ls_flag_estado
Boolean lb_existe
this.AcceptText()

choose case lower(dwo.name)
	case 'flag_estado'
		ls_flag_estado = data
		of_set_prov_articulo(ls_flag_estado)
		ib_chg_cant_art = false
end choose
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this )
end event

type st_1 from statictext within tabpage_2
integer y = 24
integer width = 1632
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 10789024
boolean enabled = false
string text = "Sub Categoría Articulos"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_2 from statictext within tabpage_2
integer x = 1669
integer y = 24
integer width = 1632
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 10789024
boolean enabled = false
string text = "Proveedores Segun SubCategoria"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3323
integer height = 988
long backcolor = 79741120
string text = "Proveedores Seleccionados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_prov_sel dw_prov_sel
end type

on tabpage_4.create
this.dw_prov_sel=create dw_prov_sel
this.Control[]={this.dw_prov_sel}
end on

on tabpage_4.destroy
destroy(this.dw_prov_sel)
end on

type dw_prov_sel from u_dw_abc within tabpage_4
event ue_display ( string as_columna,  long al_row )
integer width = 3086
integer height = 788
integer taborder = 20
string dataobject = "d_abc_cotizacion_provee_204_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "proveedor"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO_PROV, " &
				 + "NOM_PROVEEDOR AS DESCRIPCION_PROVEEDOR " &
				 + "FROM PROVEEDOR " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;IF CurrentRow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro[al_row] = Today()
this.object.cotizo		[al_row] = '0'
end event

event itemerror;call super::itemerror;return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this )
end event

event ue_delete;//Overrride
string 	ls_proveedor
long 		ll_row, ll_find

ib_insert_mode = False
ll_row = this.GetRow()
if ll_row = 0 then return -1

ls_proveedor = this.object.proveedor[ll_row]

ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	return -1
end if

this.il_totdel ++
this.ii_update = 1								// indicador de actualizacion pendiente

ll_find = idw_det_cot.Find("proveedor = '" + ls_proveedor &
	+ "'", 1, idw_det_cot.RowCount() )

do while ll_find > 0
	idw_det_cot.deleteRow(ll_find)
	ll_find = idw_det_cot.Find("proveedor = '" + ls_proveedor &
		+ "'", 1, idw_det_cot.RowCount() )
	idw_det_cot.ii_update = 1
loop

ib_flag_delete = true

RETURN ll_row
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' &
	and upper(dwo.name) <> 'ESPECIE' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3323
integer height = 988
long backcolor = 79741120
string text = "Detalle de la Cotizacion"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cbx_mostrar cbx_mostrar
dw_det_cotiz dw_det_cotiz
end type

on tabpage_3.create
this.cbx_mostrar=create cbx_mostrar
this.dw_det_cotiz=create dw_det_cotiz
this.Control[]={this.cbx_mostrar,&
this.dw_det_cotiz}
end on

on tabpage_3.destroy
destroy(this.cbx_mostrar)
destroy(this.dw_det_cotiz)
end on

type cbx_mostrar from checkbox within tabpage_3
integer x = 965
integer y = 16
integer width = 878
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar todos los proveedores"
boolean checked = true
end type

event clicked;of_filtrar_det_cot(this.checked)	

end event

type dw_det_cotiz from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer y = 104
integer width = 3287
integer height = 812
integer taborder = 20
string dataobject = "d_abc_cotizacion_bien_det_204_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, &
		  	ls_sub_cat, ls_proveedor
Long		ll_find			  

choose case lower(as_columna)
		
	case "cod_art"
		
		ls_proveedor = this.object.proveedor[al_row]
		
		if ls_proveedor = '' or IsNull(ls_proveedor) then
			MessageBox('Aviso', 'No ha definido el proveedor', Exclamation!)
			return
		end if
		
		ls_sql = "SELECT COD_ART AS CODIGO, " &
				 + "DESC_ART AS DESCRIPCION " &
				 + "FROM vw_cmp_articulo_prov " &
				 + "WHERE PROVEEDOR = '" + ls_proveedor + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			
			select sub_cat_art, und
				into :ls_sub_cat, :ls_und
			from articulo
			where cod_Art = :ls_codigo;
			
			this.object.cod_sub_cat	[al_row] = ls_sub_cat
			this.object.und			[al_row] = ls_und
			
			of_add_art_cot(al_row)
			
			this.ii_update = 1
		end if
		
end choose
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' &
	and upper(dwo.name) <> 'ESPECIE' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event itemerror;call super::itemerror;return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this )
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_proveedor, ls_nom_prov
Long		ll_row

ll_row = idw_prov_sel.GetRow()

ls_proveedor 	= idw_prov_sel.object.proveedor[ll_row]
ls_nom_prov 	= idw_prov_sel.object.nom_proveedor[ll_row]

this.object.proveedor		[al_row] = ls_proveedor
this.object.nom_proveedor	[al_row] = ls_nom_prov

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_sub_cat, ls_und, ls_proveedor
Long 		ll_row

this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "cant_cotizada"
		of_add_art_cot(row)

	case	"cod_art"
		
		ls_proveedor = this.object.proveedor[row]
		
		if ls_proveedor = '' or IsNull(ls_proveedor) then
			MessageBox('Aviso', 'No ha definido el proveedor', Exclamation!)
			return
		end if
		
		ls_codigo = this.object.cod_art[row]

		SetNull(ls_data)
		
		select desc_art, und, sub_cat_art
			into :ls_data, :ls_und, :ls_sub_cat
		from vw_cmp_articulo_prov
		where cod_art = :ls_codigo
		  and proveedor = :ls_proveedor;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE ARTICULO NO EXISTE O NO PERTENECE A LA CATEGORIA DEL PROVEEDOR", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_art			[row] = ls_codigo
			this.object.desc_art			[row] = ls_codigo
			this.object.und				[row] = ls_codigo
			this.object.cod_sub_cat		[row] = ls_codigo
			this.object.cant_cotizada	[row] = 0.00
			return 1
		end if

		this.object.desc_art			[row] = ls_data
		this.object.und				[row] = ls_und
		this.object.cod_sub_cat		[row] = ls_sub_cat
		this.object.cant_cotizada	[row] = 0.00
				 
		of_add_art_cot(row)

end choose
end event

type dw_master from u_dw_abc within w_cm306_cotizacion_bienes_gen
event ue_refresh_det ( )
integer y = 152
integer width = 3397
integer height = 556
integer taborder = 50
string dataobject = "d_abc_cotizacion_bienes_204_ff"
end type

event ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             */

Long ll_row
dwobject dwo_1
ll_row = dw_master.getrow()

IF ll_row = 0 then return
THIS.EVENT ue_retrieve_det(ll_row)

of_set_status_doc( dw_master )
end event

event constructor;call super::constructor;idw_art_cot = tab_1.tabpage_1.dw_art_cot
idw_lotes	= tab_1.tabpage_2.dw_lotes
idw_pos_prov= tab_1.tabpage_2.dw_pos_prov
//Detalle de la cotizacion
idw_det_cot = tab_1.tabpage_3.dw_det_cotiz
//Proveedores Seleccionados
idw_prov_sel = tab_1.tabpage_4.dw_prov_sel


is_mastdet = 'md'		
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master
idw_det  = tab_1.tabpage_1.dw_art_cot
end event

event ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.cod_origen		[al_row] = gs_origen
this.object.flag_estado		[al_row] = '1'		// Activo
this.object.cod_usr			[al_row] = gs_user
this.object.tipo				[al_row] = 'B'		// bienes

this.object.p_logo.FileName = gs_logo

is_Action = 'new'
of_set_status_doc( dw_master)
end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.Reset()
idw_det_cot.reset()
idw_prov_sel.reset()
//dw_2.reset()

//Recupero todos los articulos que se cotizaron
idw_det.retrieve(aa_id[1],aa_id[2])

//Recupero el detalle de la cotizacion
idw_det_cot.retrieve( aa_id[1],aa_id[2])

idw_prov_sel.retrieve(aa_id[1],aa_id[2])


end event

event type integer ue_delete_pre();call super::ue_delete_pre;if idw_1 = dw_master then 
	Messagebox( "Error", "No se permite Eliminar este documento")	
	return 0
end if
end event

event ue_output(long al_row);call super::ue_output;messagebox( 'ue_outp', '')
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this)
end event

