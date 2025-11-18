$PBExportHeader$w_cm309_cotizacion_servic_gen.srw
forward
global type w_cm309_cotizacion_servic_gen from w_abc
end type
type pb_1 from picturebutton within w_cm309_cotizacion_servic_gen
end type
type gb_1 from groupbox within w_cm309_cotizacion_servic_gen
end type
type dw_pos_provee from u_dw_abc within w_cm309_cotizacion_servic_gen
end type
type dw_servicio from u_dw_abc within w_cm309_cotizacion_servic_gen
end type
type dw_master from u_dw_abc within w_cm309_cotizacion_servic_gen
end type
type dw_articulos from u_dw_abc within w_cm309_cotizacion_servic_gen
end type
type dw_proveedores from u_dw_abc within w_cm309_cotizacion_servic_gen
end type
type dw_2 from u_dw_abc within w_cm309_cotizacion_servic_gen
end type
type rb_2 from radiobutton within w_cm309_cotizacion_servic_gen
end type
type rb_1 from radiobutton within w_cm309_cotizacion_servic_gen
end type
end forward

global type w_cm309_cotizacion_servic_gen from w_abc
integer width = 3639
integer height = 2212
string title = "Cotizacion de Servicios [CM309]"
string menuname = "m_mtto_imp_mail"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
pb_1 pb_1
gb_1 gb_1
dw_pos_provee dw_pos_provee
dw_servicio dw_servicio
dw_master dw_master
dw_articulos dw_articulos
dw_proveedores dw_proveedores
dw_2 dw_2
rb_2 rb_2
rb_1 rb_1
end type
global w_cm309_cotizacion_servic_gen w_cm309_cotizacion_servic_gen

type variables
Datastore ids_prov

end variables

forward prototypes
public function integer of_set_numera ()
public function integer of_set_subcat_provee ()
public function integer of_update_proveedores ()
public function integer of_update_articulos ()
public function integer of_verifica_dup (string as_codigo)
public subroutine of_get_provee ()
public function integer of_bloquea_detalle ()
public subroutine of_retrieve ()
public function integer of_set_status_doc (datawindow idw)
end prototypes

event ue_anular();Long j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.Object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1		// Activa indicar para grabacion

//// Anulando Detalle
//For j = 1 to dw_detail.RowCount()
//	dw_detail.object.flag_estado[j] = '0'
//Next
//dw_detail.ii_update = 1		// Activa indicar para grabacion
is_action = 'anu'
end event

public function integer of_set_numera ();// Numera documento
Long j
String ls_cod_origen, ls_next_nro

if dw_master.getrow() = 0 then return 1
if is_action = 'new' then
	ls_next_nro = f_numera_documento('num_cotizacion',9)
	if ls_next_nro = '0' then
		return 0
	else
		dw_master.object.nro_cotiza[dw_master.getrow()] = ls_next_nro	
		ls_cod_origen = dw_master.object.cod_origen[dw_master.getrow()] 
	end if
else
	ls_next_nro = dw_master.object.nro_cotiza[dw_master.getrow()] 
	ls_cod_origen = dw_master.object.cod_origen[dw_master.getrow()]
end if
	
// Asigna numero a detalle
for j = 1 to dw_servicio.RowCount()
	dw_servicio.object.cod_origen[j] = ls_cod_origen
	dw_servicio.object.nro_cotiza[j] = ls_next_nro	
next

// Numera dw articulos
for j = 1 to dw_articulos.RowCount()
	dw_articulos.object.cod_origen[j] = ls_cod_origen
	dw_articulos.object.nro_cotiza[j] = ls_next_nro	
next

// numera dw proveedor
for j = 1 to dw_proveedores.RowCount()
	dw_proveedores.object.cod_origen[j] = ls_cod_origen
	dw_proveedores.object.nro_cotiza[j] = ls_next_nro	
next

return 1
end function

public function integer of_set_subcat_provee ();// Llena dw2 con datos de sub categorias y proveedores

Long ll_j, ll_k, ll_row
String ls_proveedor, ls_sub_cat
Boolean lb_existe

dw_2.reset()
For ll_j = 1 to dw_articulos.RowCount()
	ls_sub_cat = dw_articulos.object.cod_sub_cat[ll_j]
 	ls_proveedor = dw_articulos.object.proveedor[ll_j]
	
	// Verifica que proveedor no se duplique	
	lb_existe = false
	For ll_k = 1 to dw_2.RowCount()
		if dw_2.object.proveedor[ll_k] = ls_proveedor then
		   lb_existe = true
		end if		
	Next
	if lb_existe = false then
		ll_row = dw_2.event ue_insert()
		if ll_row > 0 then
			dw_2.object.proveedor[ll_j] = ls_proveedor	
			dw_2.object.sub_cat[ll_j] = ls_sub_cat
		end if
	end if
Next
Return 1
end function

public function integer of_update_proveedores ();// Llena dw con datos de articulos y proveedores

Long ll_j, ll_k, ll_row
String ls_proveedor
Boolean lb_existe

if dw_2.RowCount() = 0 then return 0   // si no hay registros no grabar
	
dw_proveedores.reset()
For ll_j = 1 to dw_2.RowCount()
 	ls_proveedor = dw_2.object.proveedor[ll_j]
	
	// Verifica que proveedor no se duplique	
	lb_existe = false
	For ll_k = 1 to dw_proveedores.RowCount()
		if dw_proveedores.object.proveedor[ll_k] = ls_proveedor then
		   lb_existe = true
		end if		
	Next
	if lb_existe = false then
		ll_row = dw_proveedores.event ue_insert()
		if ll_row > 0 then
			dw_proveedores.object.proveedor[ll_j] = ls_proveedor
			dw_proveedores.object.cotizo[ll_j] = '0'
		end if
	end if
Next
Return 1
end function

public function integer of_update_articulos ();// Llena dw con datos de tipo de servicio y proveedores

String ls_sub_cat
Long ll_j, ll_k, ll_row
dw_articulos.reset()
if dw_2.RowCount() = 0 then return 0    // Si no hay registros, no debe grabar

For ll_j = 1 to dw_2.RowCount()   // proveedores-lotes
	ls_sub_cat = dw_2.object.sub_cat[ll_j]	
	
	For ll_k = 1 to dw_servicio.RowCount()		
		 if dw_servicio.object.cod_sub_cat[ll_k] = ls_sub_cat then
			ll_row = dw_articulos.event ue_insert()
		
			if ll_row > 0 then				
				dw_articulos.object.proveedor[ll_row] = dw_2.object.proveedor[ll_j]				
				dw_articulos.object.descripcion[ll_row] = dw_servicio.object.descripcion[ll_k]
				dw_articulos.object.cod_sub_cat[ll_row] = ls_sub_cat
			end if
		END IF
	Next   
Next
Return 1
end function

public function integer of_verifica_dup (string as_codigo);// Verifica codigo duplicados
// Retorna: 0 = dup, 1 = ok

long ll_find = 1, ll_end, ll_vec = 0
String ls_cad

dw_servicio.AcceptText()
ls_cad = "cod_sub_cat = '" + as_codigo + "'"
ll_end = dw_servicio.RowCount()

ll_find = dw_servicio.Find(ls_cad, ll_find, ll_end)
DO WHILE ll_find > 0
	ll_vec ++
	// Collect found row
	ll_find++
	// Prevent endless loop
	IF ll_find > ll_end THEN EXIT
	ll_find = dw_servicio.Find(ls_cad, ll_find, ll_end)
LOOP
if ll_vec > 1 then return 0

return 1
end function

public subroutine of_get_provee ();String ls_sub_cat, ls_proveedor, ls_nom_pro, ls_cod_art
Long j, k, ll_found, ll_row, ll_reg_prov

// Adiciona proveedores por sub categoria
ll_row = dw_servicio.getrow()
if ll_row > 0 then		// Si existen servicios	
	dw_pos_provee.reset()
	ls_sub_Cat = dw_servicio.object.cod_sub_cat[ll_row]
	// cuando es nuevo
	if is_action = 'new' then		
		ll_reg_prov = ids_prov.retrieve( ls_sub_cat) 
		if ll_reg_prov = 0 then
			Messagebox( "Atencion", "No existe proveedores para esta sub categoria")
		end if
		for j = 1 to ll_reg_prov
			ls_proveedor = ids_prov.object.proveedor[j]
			ll_row = dw_pos_provee.event ue_insert()
			if ll_row > 0 then
				dw_pos_provee.object.sub_cat[ll_row] = ls_sub_cat
				dw_pos_provee.object.proveedor[ll_row] = ls_proveedor		
				Select nom_proveedor into :ls_nom_pro from proveedor
					Where proveedor = :ls_proveedor;			   
				dw_pos_provee.object.nombre[ll_row] = ls_nom_pro
			end if
		next
	else		
		For k = 1 to dw_2.RowCount()	
			ls_proveedor = dw_2.object.proveedor[k]
			if TRIM( dw_2.object.sub_cat[k]) = TRIM( ls_sub_cat) then				 
				ll_row = dw_pos_provee.event ue_insert()
				if ll_row > 0 then					
					dw_pos_provee.object.proveedor[ll_row] = dw_2.object.proveedor[k]
					Select nom_proveedor into :ls_nom_pro from proveedor
					  Where proveedor = :ls_proveedor;						 
				   dw_pos_provee.object.nombre[ll_row] = ls_nom_pro
				end if
			end if
		next	
	end if
	// Marca proveedores seleccionados
	for j = 1 to dw_2.RowCount()		
		if dw_2.object.sub_cat[j] = ls_sub_cat then			
			for k = 1 to dw_pos_provee.rowcount()
				ls_proveedor = dw_pos_provee.object.proveedor[k]				
				if dw_2.object.proveedor[j] = ls_proveedor then
					dw_pos_provee.object.status[k] = 'S'
				end if
			next
		end if
	Next
	dw_pos_provee.SetRedraw(true)
end if
end subroutine

public function integer of_bloquea_detalle ();// Funcion que bloquea detalle
		dw_servicio.object.cod_sub_cat.background.color = RGB(192,192,192)
		dw_servicio.object.descripcion.background.color = RGB(192,192,192)
//		dw_servicio.object.cod_sub_cat.protect = 1
		dw_servicio.object.cod_sub_cat.tabsequence = 0
		dw_servicio.object.descripcion.protect = 1
return 1
end function

public subroutine of_retrieve ();// Creacion de DataStore
ids_prov = CREATE datastore
ids_prov.DataObject = 'd_dddw_proveedor_sub_categ_cp'
ids_prov.SetTransObject(SQLCA)

Long ll_row

String ls_origen, ls_nro

Select cod_origen, nro_cotiza into :ls_origen, :ls_nro
   From cotizacion where nro_cotiza = (select max( to_number( nro_cotiza)) from cotizacion)
	  AND tipo = 'S';

ll_row = dw_master.retrieve(ls_origen, ls_nro)

of_bloquea_detalle()
rb_2.event clicked()
if ll_row = 0 then	
	if is_flag_insertar = '1' then		
		this.post event ue_insert()
	end if	
else
	is_Action = 'open'
	dw_master.il_row = dw_master.getrow()
	dw_master.post event ue_refresh_det()	
end if
return
end subroutine

public function integer of_set_status_doc (datawindow idw);/*
  Funcion que verifica el status del documento
*/
this.changemenu( m_mtto_imp_mail)

Int li_estado

// Activa todas las opciones
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

m_master.m_file.m_printer.m_print1.enabled = true

if dw_master.getrow() = 0 then return 0
if is_Action = 'new' then
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false			
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_basedatos.m_email.enabled = false
	
	if idw = dw_servicio and rb_2.checked = true then		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = true		
	end if
end if
if is_Action = 'open' then
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
	Choose case li_estado
		case 0		// Anulado			
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
		m_master.m_file.m_basedatos.m_email.enabled = false
		m_master.m_file.m_basedatos.m_grabar.enabled = false
	end CHOOSE
	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = true
	else
//		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if
end if

if is_Action = 'anu' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_basedatos.m_email.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false
end if
if is_Action = 'edit' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_basedatos.m_email.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false
	m_master.m_file.m_basedatos.m_grabar.enabled = true
end if

return 1


//if dw_master.getrow() = 0 then return 0
//
//// Activa desactiva opcion de modificacion, eliminacion
//if dw_master.object.flag_estado[dw_master.getrow()] <> '1' then
//	m_master.m_file.m_basedatos.m_eliminar.enabled = false
//	m_master.m_file.m_basedatos.m_modificar.enabled = false
//	m_master.m_file.m_basedatos.m_anular.enabled = false
////	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
////		m_master.m_file.m_basedatos.m_insertar.enabled = true
////	else
////		m_master.m_file.m_basedatos.m_insertar.enabled = false
////	end if
//	
//	// Desactiva botones
////	cb_1.enabled = false
//else
//	m_master.m_file.m_basedatos.m_eliminar.enabled = true
//	m_master.m_file.m_basedatos.m_modificar.enabled = true
//	m_master.m_file.m_basedatos.m_anular.enabled = true
//	
//	// activa botones
////	cb_1.enabled = true
//end if
//return 1
end function

on w_cm309_cotizacion_servic_gen.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.pb_1=create pb_1
this.gb_1=create gb_1
this.dw_pos_provee=create dw_pos_provee
this.dw_servicio=create dw_servicio
this.dw_master=create dw_master
this.dw_articulos=create dw_articulos
this.dw_proveedores=create dw_proveedores
this.dw_2=create dw_2
this.rb_2=create rb_2
this.rb_1=create rb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_pos_provee
this.Control[iCurrent+4]=this.dw_servicio
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.dw_articulos
this.Control[iCurrent+7]=this.dw_proveedores
this.Control[iCurrent+8]=this.dw_2
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.rb_1
end on

on w_cm309_cotizacion_servic_gen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.gb_1)
destroy(this.dw_pos_provee)
destroy(this.dw_servicio)
destroy(this.dw_master)
destroy(this.dw_articulos)
destroy(this.dw_proveedores)
destroy(this.dw_2)
destroy(this.rb_2)
destroy(this.rb_1)
end on

event ue_open_pre();call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_proveedores.SetTransObject( sqlca)
dw_articulos.SetTransObject( sqlca)
dw_2.SetTransObject( sqlca)
dw_servicio.SetTransObject(sqlca)

idw_1 = dw_master              		// asignar dw corriente
//dw_master.of_protect()         		// bloquear modificaciones 
//dw_servicio.of_protect()
dw_servicio.BorderStyle = StyleRaised!
//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

of_retrieve()
end event

event ue_insert();Long  ll_row

// si adiciona nueva cotizacion, limpiar dw
if idw_1 = dw_master then
	dw_articulos.reset()
	dw_proveedores.reset()
	dw_2.reset()
	dw_pos_provee.reset()

	// Adiciona registro en el master y detmast
	dw_master.reset()
//	ll_row = dw_master.Event ue_insert()	// Adiciona registro
//	ll_row = tab_1.tabpage_1.dw_servicio.Event ue_insert()			// Adiciona registro 
end if
ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_retrieve_dddw();call super::ue_retrieve_dddw;DataWindowChild	dwc_dddw	

dw_servicio.GetChild ("cod_sub_cat", dwc_dddw)
dwc_dddw.SetTransObject (sqlca)
dwc_dddw.Retrieve ('001')

end event

event ue_update_pre();call super::ue_update_pre;//Llena dw con valores
ib_update_check = false
if is_action = 'new' then
	if of_update_articulos() = 0 then 		
		Messagebox( "Error", 'No se ha ingresado tipo de servicio')
		return		
	end if
	if of_update_proveedores() = 0 then 		
		Messagebox( "Error", 'No se ha seleccionado proveedor')
		return
	end if
end if

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_articulos, "tabular") <> true then
	return
end if

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_pos_provee, "tabular") <> true then	
	return
end if
if of_set_numera() = 0 then
	return	
end if	
if is_action <> 'anu' then
	dw_master.of_protect()         			// bloquear modificaciones 
//	dw_detail.of_protect()
end if
is_action = ''  
ib_update_check = true
end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_articulos.AcceptText()
dw_proveedores.AcceptText()

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
IF dw_proveedores.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_proveedores.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF	dw_articulos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_articulos.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_articulos.ii_update = 0	
	dw_proveedores.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF
of_set_status_doc(dw_master)
end event

event close;call super::close;destroy ids_prov
end event

event ue_list_open();call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_dddw_cotizaciones_tbl"
sl_param.titulo = "Cotizaciones de Servicios"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = 'S'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	dw_master.retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
	is_action = 'open'
	dw_master.event ue_refresh_det()	
END IF
end event

event type long ue_scrollrow(string as_value);call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)
dw_master.event ue_refresh_det()
RETURN ll_rc
end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
//tab_1.width = newwidth - 300
//tab_1.height = newheight - 500
dw_pos_provee.width  = newwidth  - dw_servicio.width - 80
dw_servicio.height = newheight - dw_servicio.y - 10
dw_pos_provee.height = newheight - dw_pos_provee.y - 10
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_articulos.ii_update = 1 or dw_proveedores.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_articulos.ii_update = 0
		dw_proveedores.ii_update = 0
	END IF
END IF

end event

type pb_1 from picturebutton within w_cm309_cotizacion_servic_gen
integer x = 2464
integer y = 436
integer width = 137
integer height = 112
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "\Source\Bmp\lupa.bmp"
alignment htextalign = left!
end type

event clicked;// Asigna valores a structura 
str_parametros sl_param

sl_param.dw_master = "d_dddw_solicitud_servicio_tbl"
sl_param.dw1 = "d_cns_sol_serv_detalle"
sl_param.titulo = "Solicitud de Servicio pendientes"
sl_param.dw_m = dw_master
sl_param.dw_d = dw_servicio
sl_param.w1 = parent
sl_param.opcion = 5

OpenWithParm( w_abc_seleccion_md, sl_param)

//w_abc_cotizacion_servic_gen_cm207.of_get_provee()
end event

type gb_1 from groupbox within w_cm309_cotizacion_servic_gen
integer x = 1298
integer y = 392
integer width = 1358
integer height = 168
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_pos_provee from u_dw_abc within w_cm309_cotizacion_servic_gen
integer x = 1934
integer y = 596
integer width = 1600
integer height = 1200
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_inp_cotizacion_provee_204"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1	
end event

event itemchanged;call super::itemchanged;// Activa/Inactiva proveedores, debe actualizar dw articulos y proveedores
if dwo.name = 'status' then	
	String ls_sub_cat, ls_proveedor, ls
	Long ll_row, ll_found, j
	
	ls_sub_cat = dw_servicio.object.cod_sub_cat[dw_servicio.getrow()]
	ls_proveedor = this.object.proveedor[this.getrow()]
	if data = 'S' THEN  // Se adiciona
   	ll_row = dw_2.event ue_insert()
		if ll_row > 0 then
			dw_2.object.sub_Cat[ll_row] = ls_sub_cat
			dw_2.object.proveedor[ll_row] = ls_proveedor
		end if
	else
		// Busca lote y proveedor para eliminar
		For j = 1 to dw_2.rowcount()		
			if dw_2.object.sub_cat[j] = ls_sub_cat and dw_2.object.proveedor[j] = ls_proveedor then
			   dw_2.deleterow( j )
			end if
		next
	end if
end if
dw_2.AcceptText()
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_Status_doc( this)
end event

type dw_servicio from u_dw_abc within w_cm309_cotizacion_servic_gen
integer x = 18
integer y = 596
integer width = 1888
integer height = 1200
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_cotizacion_servic_det_205_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1	
ii_rk[1] = 1
ii_rk[2] = 2
end event

event itemerror;call super::itemerror;Return 1     // Fuerza a no mostrar el mensaje 
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if is_Action <> 'new' then
	of_get_provee()   // Muestra los proveedores 
end if
of_set_Status_doc( this)
end event

event itemchanged;call super::itemchanged;Long ln_count

if dwo.name = 'cod_sub_cat' then
	// Verifica si categoria tiene proveedores
	Select Count( proveedor) into :ln_count from proveedor_articulo
	  where cod_sub_cat = :data;
	if ln_count = 0 then
		Messagebox( "Error", "Sub Categoria no tiene proveedores")
		dw_pos_provee.reset()
		this.object.cod_sub_cat[row] = ''
		Return 1
	end if
	this.AcceptText()
	of_get_provee()
	

//	if of_verifica_dup(data) <> 1 then  // no hay forma de controlar dup.
//		Messagebox( "Error", "No se acepta servicio duplicado")
//		this.object.cod_sub_cat[row] = ''
//		return 1
//	end if
end if


end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.setcolumn( "cod_sub_cat")
this.setfocus()

if rb_1.checked = true then rb_2.enabled = false
if rb_2.checked = true then 
	rb_1.enabled = false

	dw_servicio.object.cod_sub_cat.background.color = RGB(255,255,255)
		dw_servicio.object.descripcion.background.color = RGB(255,255,255)
//		dw_servicio.object.cod_sub_cat.protect = 1
		dw_servicio.object.cod_sub_cat.tabsequence = 10
		dw_servicio.object.descripcion.protect = 0
		
	this.Setcolumn("cod_sub_cat")
end if
end event

type dw_master from u_dw_abc within w_cm309_cotizacion_servic_gen
event ue_refresh_det ( )
integer x = 23
integer y = 20
integer width = 3173
integer height = 428
string dataobject = "d_abc_cotizacion_servic_207_ff"
boolean border = false
end type

event ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             */

Long ll_row
dwobject dwo_1

ll_row = dw_master.getrow()

THIS.EVENT ue_retrieve_det(ll_row)
idw_det.ScrollToRow(ll_row)

idw_det.event clicked(0,0,1,dwo_1)

of_set_status_doc( dw_master )
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
of_set_Status_doc( this)
end event

event constructor;call super::constructor;is_mastdet = 'md'		
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 1
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master
idw_det  = dw_servicio
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;// Asigna datos
this.object.fec_registro[al_row] = TODAY()
this.object.cod_origen[al_row] = gs_origen
this.object.flag_estado[al_row] = '1'		// Activo
this.object.cod_usr[al_row] = gs_user
this.object.tipo[al_row] = 'S'		// Servicios

is_action = 'new'
of_set_status_doc( dw_master)

end event

event ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2], 'S')
dw_articulos.retrieve( aa_id[1],aa_id[2])
of_set_subcat_provee()    // llena tabla con datos

end event

event type integer ue_delete_pre();call super::ue_delete_pre;if idw_1 = dw_master then 
	Messagebox( "Error", "No se permite Eliminar este documento")	
	return 0
end if
end event

type dw_articulos from u_dw_abc within w_cm309_cotizacion_servic_gen
boolean visible = false
integer x = 2167
integer y = 552
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_cotizacion_serv_det_205_tbl"
boolean hscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		
idw_mst  = dw_master

ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos d
ii_rk[2] = 2

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_proveedores from u_dw_abc within w_cm309_cotizacion_servic_gen
boolean visible = false
integer x = 2130
integer y = 28
integer width = 526
integer height = 312
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_abc_cotizacion_provee_204_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		
idw_mst  = dw_master

ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos d
ii_rk[2] = 2



end event

event itemerror;call super::itemerror;Return 1
end event

type dw_2 from u_dw_abc within w_cm309_cotizacion_servic_gen
boolean visible = false
integer x = 2638
integer y = 348
integer width = 526
integer height = 216
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_inp_cotizacion_subcat_prov_204"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

type rb_2 from radiobutton within w_cm309_cotizacion_servic_gen
integer x = 1349
integer y = 452
integer width = 462
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sin Referencia"
boolean checked = true
end type

event clicked;pb_1.enabled = false


end event

type rb_1 from radiobutton within w_cm309_cotizacion_servic_gen
integer x = 1902
integer y = 452
integer width = 480
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Con Referencia"
end type

event clicked;pb_1.enabled = this.checked

of_bloquea_detalle()

end event

