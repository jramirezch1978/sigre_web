$PBExportHeader$w_cm305_programa_compras.srw
forward
global type w_cm305_programa_compras from w_abc
end type
type dw_detail from u_dw_abc within w_cm305_programa_compras
end type
type dw_master from u_dw_abc within w_cm305_programa_compras
end type
type sle_nro from u_sle_codigo within w_cm305_programa_compras
end type
type cb_buscar from commandbutton within w_cm305_programa_compras
end type
type st_nro from statictext within w_cm305_programa_compras
end type
end forward

global type w_cm305_programa_compras from w_abc
integer width = 4169
integer height = 5628
string title = "[CM305] Programa de Compras "
string menuname = "m_mtto_lista"
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
event ue_cancelar ( )
dw_detail dw_detail
dw_master dw_master
sle_nro sle_nro
cb_buscar cb_buscar
st_nro st_nro
end type
global w_cm305_programa_compras w_cm305_programa_compras

type variables
String is_action = ''
Boolean ib_select_row=false
Date 		id_fecha1, id_fecha2
string	is_almacen, is_nro_ot, is_doc_ot, is_oper_cons_int

end variables

forward prototypes
public function integer of_verifica_dup (string as_cod_art)
public function integer of_nro_item (datawindow adw_1)
public function integer of_set_status_doc (datawindow idw)
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public subroutine of_sort_dw (ref u_dw_abc adw_1)
public subroutine of_set_modify ()
public function string of_set_comp_def (string as_cod_art)
public function string of_set_almacen_tacito (string as_cod_art)
end prototypes

event ue_anular;Integer 	li_j
decimal	ldc_cant_comprada, ldc_cant_ingresada
string	ls_nro_programa

IF dw_master.GetRow() = 0 then
	return
end if

IF dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
	MessageBox('Aviso', 'No puede anular este programa de compras')
	return
end if

// Verifico si el programa de compras tiene cantidad comprada
// o cantidad ingresada

ls_nro_programa = dw_master.object.nro_programa[dw_master.GetRow()]

SELECT  NVL(sum(PCD.CANT_PROCESADA),0), NVL(sum(PCD.cant_ingresada),0)
   into :ldc_cant_comprada, :ldc_cant_ingresada
   FROM PROG_COMPRAS_DET  PCD 
  WHERE PCD.NRO_PROGRAMA   = :ls_nro_programa;

IF ldc_cant_comprada > 0 then
	MessageBox('Aviso', 'No puede anular este programa de compras, ya esta en proceso de compra')
	return
end if

IF ldc_cant_ingresada > 0 then
	MessageBox('Aviso', 'No puede anular este programa de compras, se encuentra en proceso de atención')
	return
end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.Object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1		// Activa para grabacion

// Anulando Detalle
For li_j = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[li_j] = '0'
	dw_detail.ii_update = 1   // Activa para grabacion
Next

is_action = 'anu'
of_set_status_doc( dw_master)
end event

event ue_cancelar;// Cancela operacion, limpia todo
ib_update_check = TRUE
EVENT ue_update_request()   // Verifica actualizaciones pendientes
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

dw_master.reset()
dw_master.ii_update = 0

dw_detail.reset()
dw_detail.ii_update = 0

sle_nro.text = ''
sle_nro.SetFocus()

is_Action = ''
of_set_status_doc(dw_master)
end event

public function integer of_verifica_dup (string as_cod_art);// Verifica codigo duplicados

long ll_find = 1, ll_end, ll_vec = 0
String ls_cad

ls_cad = "cod_art = '" + as_cod_Art + "'"
ll_vec = 0
ll_end = dw_detail.RowCount()

ll_find = dw_detail.Find(ls_cad, ll_find, ll_end)
DO WHILE ll_find > 0
	ll_vec ++
	// Collect found row
	ll_find++
	// Prevent endless loop
	IF ll_find > ll_end THEN EXIT
	ll_find = dw_detail.Find(ls_cad, ll_find, ll_end)
LOOP			
if ll_vec > 0 then 
	messagebox( "Error", "Codigo de articulo ya existe")
	return 0	
end if
return 1
end function

public function integer of_nro_item (datawindow adw_1);// Genera numero de item para un dw
Integer ll_i, ll_mayor

ll_mayor = adw_1.object.nro_item[1]
if isnull(ll_mayor) then
	ll_mayor = 0
end if
For ll_i = 1 to adw_1.RowCount()
	if adw_1.object.nro_item[ll_i] > ll_mayor then
		ll_mayor = adw_1.object.nro_item[ll_i]
	end if
Next
ll_mayor ++

Return ll_mayor
end function

public function integer of_set_status_doc (datawindow idw);this.changemenu(m_mtto_lista)   // Activa menu
Int li_estado

// Activa todas las opciones
m_master.m_file.m_basedatos.m_insertar.enabled 		= f_niveles( is_niveles, 'I')  // true
m_master.m_file.m_basedatos.m_eliminar.enabled 		= f_niveles( is_niveles, 'E')  //true
m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') //true
m_master.m_file.m_basedatos.m_anular.enabled 		= f_niveles( is_niveles, 'A') //true
m_master.m_file.m_basedatos.m_abrirlista.enabled 	= true
m_master.m_file.m_printer.m_print1.enabled 			= true
m_master.m_file.m_basedatos.m_cancelar.enabled		= true
m_master.m_file.m_basedatos.m_grabar.enabled			= true

if dw_master.getrow() = 0 then return 0
if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false	
	m_master.m_file.m_basedatos.m_insertar.enabled 		= false

	if idw = dw_detail then
		m_master.m_file.m_basedatos.m_insertar.enabled = true
		m_master.m_file.m_basedatos.m_eliminar.enabled = TRUE
	end if
	
elseif is_Action = 'open' then
	
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
	
	Choose case li_estado
	case 0		// Anulado				
		m_master.m_file.m_basedatos.m_eliminar.enabled  = false
		m_master.m_file.m_basedatos.m_modificar.enabled	= false
		m_master.m_file.m_basedatos.m_anular.enabled 	= false
		m_master.m_file.m_basedatos.m_email.enabled 		= false
		m_master.m_file.m_basedatos.m_grabar.enabled 	= false
		if idw_1 = dw_detail then
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
	case 2,3		// en transito
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled 	= false
		m_master.m_file.m_basedatos.m_anular.enabled 		= false
		m_master.m_file.m_basedatos.m_email.enabled 	= false
		m_master.m_file.m_basedatos.m_grabar.enabled 		= false
		if idw_1 = dw_detail then
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
	end CHOOSE
	
elseif is_Action = 'anu' then	
	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_basedatos.m_email.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false
	
elseif is_Action = 'edit' then	
	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_basedatos.m_email.enabled 	= false
	m_master.m_file.m_printer.m_print1.enabled 			= false
end if
return 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j, ll_long, ll_count
String 	ls_ult_nro, ls_mensaje

if is_Action = 'new' then
	Select ult_nro 
		into :ll_ult_nro 
	from num_prog_compras
	where origen = :gnvo_app.is_origen for update;
	
	IF SQLCA.SQLCode = 100 then
		insert into num_prog_compras(origen, ult_nro)
		values (:gnvo_app.is_origen, 1);
		
		if SQLCA.SQLCode <> 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', ls_mensaje)
			return 0
		end if
		ll_ult_nro = 1
	end if

	ll_long 	= 10 - len(TRIM(gnvo_app.is_origen))
   ls_ult_nro = TRIM(gnvo_app.is_origen) + f_llena_caracteres('0',String(ll_ult_nro),ll_long) 		

	// Asigna numero a cabecera
	dw_master.object.nro_programa[dw_master.getrow()] = ls_ult_nro

	// Asigna numero a detalle
	for ll_j = 1 to dw_detail.RowCount()
		dw_detail.object.nro_programa	[ll_j] = ls_ult_nro
		dw_detail.ii_update = 1
	next
	

	// Incrementa contador
	ll_ult_nro ++
	Update num_prog_compras
		set ult_nro = :ll_ult_nro
	where origen = :gnvo_app.is_origen;
	
	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return 0
	end if
else
	ls_ult_nro = dw_master.object.nro_programa[dw_master.getrow()]

	// Asigna numero a detalle
	for ll_j = 1 to dw_detail.RowCount()
		dw_detail.object.nro_programa	[ll_j] = ls_ult_nro
		dw_detail.ii_update = 1
	next
	
end if

return 1
end function

public subroutine of_retrieve (string as_nro);Long 		ll_row
String	ls_mensaje

UPDATE prog_compras_det t
   SET t.cant_ingresada = (SELECT nvl(SUM(amp.cant_procesada),0)
                             FROM articulo_mov_proy amp
                            WHERE amp.tipo_ref = (SELECT l.tipo_doc_prog_cmp FROM logparam l WHERE reckey = '1')
                              AND amp.referencia = t.nro_programa
                              AND amp.item_ref   = t.nro_item
                              AND amp.flag_estado <> '0'
                              AND amp.tipo_doc    = (SELECT doc_oc FROM logparam WHERE reckey = '1'))
where nro_programa = :as_nro;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al actualizar cant_ingresada', ls_mensaje)
	return
end if

COMMIT;
										
										
ll_row = dw_master.retrieve(as_nro)
if ll_row > 0 then
	dw_detail.Retrieve(as_nro)
else
	dw_detail.Reset()
end if

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()



is_action = 'open'



end subroutine

public subroutine of_sort_dw (ref u_dw_abc adw_1);Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(adw_1.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(adw_1.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(adw_1.ii_ck[li_x]) +" A"
NEXT

adw_1.SetSort (ls_sort)
adw_1.Sort()
end subroutine

public subroutine of_set_modify ();string ls_return
//Codigo de Articulo
dw_detail.Modify("cod_art.Protect ='1 ~t If(not IsNull(nro_amp_ot_ref) or flag_estado <> ~~'1~~',1,0)'")
dw_detail.Modify("cod_art.Background.color ='" + string(RGB(255,255,255)) + " ~t If(not IsNull(nro_amp_ot_ref), " + string(RGB(192,192,192)) + "," + string(RGB(255,255,255)) + ")'")

//Almacen
dw_detail.Modify("almacen.Protect ='1 ~t If(not IsNull(nro_amp_ot_ref) or flag_estado <> ~~'1~~',1,0)'")
dw_detail.Modify("almacen.Background.color ='RGB(255,255,255) ~t If(not IsNull(nro_amp_ot_ref) or flag_estado <> ~~'1~~', RGB(192,192,192),RGB(255,255,255))'")

end subroutine

public function string of_set_comp_def (string as_cod_art);//Asigna el comprador por defecto
string ls_sub_cat, ls_cod_comprador

SetNull(ls_cod_comprador)

select sub_cat_art
	into :ls_sub_cat
from articulo
where cod_art = :as_cod_art;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', "Codigo de Articulo '" + as_cod_art + "'no existe")
	return ls_cod_comprador
end if

if IsNull(ls_sub_cat) then
	MessageBox('Aviso', "Articulo '" + as_cod_art + "'no tiene definido subcategoria")
	return ls_cod_comprador
end if

select min(cod_comprador)
	into :ls_cod_comprador
from comprador_articulo
where cod_sub_cat = :ls_sub_cat;

return ls_cod_comprador

end function

public function string of_set_almacen_tacito (string as_cod_art);string ls_clase, ls_almacen

SetNull(ls_almacen)

select cod_clase
	into :ls_clase
from articulo
where cod_art = :as_cod_art;

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', "Codigo de Articulo '" + as_cod_art + "'no existe")
	return ls_almacen
end if

if IsNull(ls_clase) then
	MessageBox('Aviso', "Articulo '" + as_cod_art + "'no tiene definido Clase")
	return ls_almacen
end if

select almacen
	into :ls_almacen
from almacen_tacito
where cod_clase = :ls_clase
  and cod_origen = :gnvo_app.is_origen;

return ls_almacen

end function

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              			// asignar dw corriente

ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)

dw_master.object.p_logo.filename = gnvo_app.is_logo


select doc_ot, oper_cons_interno
	into :is_doc_ot, :is_oper_cons_int
from logparam
where reckey = '1';
end event

on w_cm305_programa_compras.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.sle_nro=create sle_nro
this.cb_buscar=create cb_buscar
this.st_nro=create st_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.cb_buscar
this.Control[iCurrent+5]=this.st_nro
end on

on w_cm305_programa_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.sle_nro)
destroy(this.cb_buscar)
destroy(this.st_nro)
end on

event ue_print;call super::ue_print;if dw_master.GetRow() = 0 then return
str_parametros lstr_param

lstr_param.string1 = dw_master.object.nro_programa[dw_master.getrow()]
OpenSheetWithParm(w_cm305_programa_compras_frm, lstr_param, This, 0, layered!)

end event

event ue_update_pre;ib_update_check = False

if dw_detail.getrow() = 0 then
	Messagebox("Error", "No puede grabar sin detalle") 
	return 
end if

if of_set_numera() = 0 then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then return
if f_row_Processing( dw_detail, "tabular") <> true then return


if is_action <> 'anu' then
	dw_master.ii_protect = 0
	dw_master.of_protect()         			// bloquear modificaciones 
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
end if

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF
IF	dw_master.ii_update = 1  THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_detail.of_protect()
	is_action = 'save'
ELSE 
	ROLLBACK USING SQLCA;
END IF

of_set_status_doc( dw_master )		// Activa/desactiva opciones de menu, segun flag_estado
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_list_programa_compras_tbl"
sl_param.titulo = "Programa de compras"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[2])
END IF
end event

event type long ue_scrollrow(string as_value);call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

dw_master.event ue_refresh_det()

RETURN ll_rc
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
dw_detail.of_protect()

is_action = 'edit'

of_set_modify()
of_set_status_doc(dw_master)
end event

event ue_insert;//Ancestor Script
Long  ll_row, ll_count

select count(*)
	into :ll_count
from comprador
where comprador = :gnvo_app.is_user
  and flag_estado = '1';

if ll_count = 0 then 
	MessageBox('Aviso', 'Usted no es un comprador o no se encuentra activo')
	return
end if

if idw_1 = dw_master then
	dw_master.reset()
	dw_master.ii_update = 0
	
	dw_detail.Reset()
	dw_detail.ii_update = 0
else	
	if dw_master.rowcount() = 0 then return  // si no hay reg. en master, no ing. detalle
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

of_set_status_doc( dw_master)

end event

event resize;dw_master.width  = newwidth  - dw_master.x - this.cii_windowborder
dw_detail.width  = newwidth  - dw_detail.x - this.cii_windowborder
dw_detail.height = p_pie.y - dw_detail.y - this.cii_windowborder

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update 		= 1 OR &
	 dw_detail.ii_update 		= 1 ) THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF
end event

event ue_delete;//Ancestor Script

Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

type p_pie from w_abc`p_pie within w_cm305_programa_compras
end type

type ole_skin from w_abc`ole_skin within w_cm305_programa_compras
end type

type uo_h from w_abc`uo_h within w_cm305_programa_compras
end type

type st_box from w_abc`st_box within w_cm305_programa_compras
end type

type phl_logonps from w_abc`phl_logonps within w_cm305_programa_compras
end type

type p_mundi from w_abc`p_mundi within w_cm305_programa_compras
end type

type p_logo from w_abc`p_logo within w_cm305_programa_compras
end type

type dw_detail from u_dw_abc within w_cm305_programa_compras
integer x = 494
integer y = 1080
integer width = 3365
integer height = 1132
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_abc_programa_compras_det_210_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'

is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2


end event

event itemerror;call super::itemerror;RETURN 1
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( dw_detail)
end event

event ue_insert_pre;//Ancestor Script
string 	ls_nro_programa
Integer 	li_null

SetNull(li_null)

ls_nro_programa = dw_master.object.nro_programa[dw_master.GetRow()]

this.object.nro_item				[al_row] = of_nro_item(this)
this.object.fec_registro		[al_row] = f_fecha_actual(1)
this.object.fec_requerida		[al_row] = Date(f_fecha_actual(1))
this.object.flag_estado			[al_row] = '1'
this.object.flag_prioridad		[al_row] = '2'
this.object.flag_replicacion	[al_row] = '1'
this.object.nro_programa		[al_row] = ls_nro_programa
this.object.cant_proyect		[al_row] = 0
this.object.cant_procesada		[al_row] = 0
this.object.comprador			[al_row] = gnvo_app.is_user
this.object.nro_amp_ot_ref		[al_row] = li_null

of_set_modify()

end event

event doubleclicked;// Abre ventana de ayuda
//Override
String 	ls_name, ls_codigo, ls_data, ls_sql, ls_cod_art, ls_string, ls_evaluate
Integer	li_position = 0
str_parametros sl_param


ls_name = dwo.name

ls_string = this.Describe(lower(dwo.name) + '.Protect' ) 
if len(ls_string) > 1 then
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	 
	// Si hay comillas simples las reemplazo para que al evaluarlo me salga correcto
	do while(f_instr("'", ls_string, li_position) > 0 )
		li_position = f_instr("'", ls_string, li_position)
		ls_string = replace(ls_string, li_position, 1, "~~'")
		li_position += 3
	loop
	
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 	
 	if this.Describe(ls_evaluate) = '1' or this.Describe(ls_evaluate) = '!' then return
else
 	if ls_string = '1' then return
end if

IF ls_name = 'cod_art' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art			[row] = sl_param.field_ret[1]
		this.object.desc_art			[row] = sl_param.field_ret[2]
		this.object.und				[row] = sl_param.field_ret[3]
		this.object.comprador		[row] = gnvo_app.is_user //of_set_comp_def(sl_param.field_ret[1])
		this.object.almacen			[row] = of_set_almacen_tacito(sl_param.field_ret[1])
		this.ii_update = 1
 	END IF
	 
ELSEif ls_name = 'fec_requerida' then
	
	Datawindow ldw
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	this.ii_update = 1
	
elseIF ls_name = 'almacen' then
	
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1' " &
				  + "and flag_tipo_almacen = 'M' " &
  				  + "order by almacen " 
					 
				  //+" and cod_origen = '" + gnvo_app.is_origen + "' " &

				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen		[row] = ls_codigo
			this.ii_update = 1
		end if

elseIF ls_name = 'comprador' then
		ls_cod_art = this.object.cod_art[row]
		
		if IsNull(ls_cod_art) or ls_cod_art = '' then
			MessageBox('Aviso', 'Codigo de Articulo esta en blanco')
			return
		end if
	
		ls_sql = "SELECT a.comprador AS codigo_comprador, " &
				  + "a.nom_comprador AS nombre_comprador " &
				  + "FROM comprador a, " &
				  + "comprador_articulo b, " &
				  + "articulo c " &
				  + "where a.comprador = b.comprador " &
				  + "and b.cod_sub_cat = c.sub_cat_art " &
				  + "and a.flag_estado = '1' " &
				  + "and c.cod_art = '" + ls_cod_art + "' " &
  				  + "order by codigo_comprador " 

		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.comprador [row] = ls_codigo
			this.ii_update = 1
		end if

end if
Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event itemchanged;call super::itemchanged;String 	ls_desc_art, ls_und, ls_null, ls_sub_cat, ls_cod_art
Long 		ll_count
Decimal 	ln_cant

SetNull(ls_null)
if dwo.name = "cod_art" then
	if f_articulo_inventariable( data ) <> 1 then 
		this.object.cod_art	[row] = ls_null
		this.object.desc_art	[row] = ls_null
		this.object.und		[row] = ls_null
		return 1
	end if

	Select desc_art, und 
		into :ls_desc_art, :ls_und 
	from articulo 
   Where cod_Art = :data;
	
	this.object.desc_art		[row] = ls_desc_art
	this.object.und			[row] = ls_und
	this.object.comprador	[row] = of_set_comp_def(data)
 	this.object.almacen		[row] = of_set_almacen_tacito(data)


elseif dwo.name = 'comprador' then
	ls_cod_art = this.object.cod_art[row]
	
	if IsNull(ls_cod_art) or ls_cod_art = '' then
		this.object.cod_comprador[row] = ls_null
		MessageBox('Aviso', 'Debe indicar un Codigo de Articulo')
		return 1
	end if
	
	select sub_cat_art
		into :ls_sub_cat
	from articulo
	where cod_art = :ls_cod_art;
	
	select count(*)
		into :ll_count
	from comprador_articulo
	where comprador 	= :data
	  and COD_SUB_CAT 	= :ls_sub_cat;
	
	if ll_count = 0 then
		this.object.cod_comprador[row] = ls_null
		MessageBox('Aviso', 'Codigo de Comprador no corresponde a la Sub Categoría de Artículo')
		return 1
	end if
elseif dwo.name = 'almacen' then
	
	select count(*)
		into :ll_count
	from almacen
	where almacen 	= :data
	and flag_estado = '1';
	
	if ll_count = 0 then
		this.object.almacen[row] = ls_null
		MessageBox('Aviso', 'Codigo de Almacen no existe o no es válido')
		return 1
	end if
	
end if
end event

type dw_master from u_dw_abc within w_cm305_programa_compras
event ue_refresh_det ( )
integer x = 494
integer y = 284
integer width = 3365
integer height = 780
integer taborder = 40
string dataobject = "d_abc_programa_compra_210_ff"
boolean controlmenu = true
boolean livescroll = false
end type

event ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             */

//Long ll_row
il_row = dw_master.getrow()
if il_row > 0 then	
	THIS.EVENT ue_retrieve_det(il_row)
	idw_det.ScrollToRow(il_row)
end if
//dw_master.il_row = dw_master.getrow()

end event

event constructor;call super::constructor;is_mastdet = 'm'	
is_dwform = 'form' // tabular form
 
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2


end event

event ue_insert_pre;call super::ue_insert_pre;// Asigna datos 
string ls_nom_user
if al_row <= 0 then return

this.object.fec_registro	[al_row] = f_fecha_actual(1)
this.object.cod_origen		[al_row] = gnvo_app.is_origen
this.object.flag_estado		[al_row] = '1'
this.object.cod_usr			[al_row] = gnvo_app.is_user

select nombre
  into :ls_nom_user
  from usuario
 where cod_usr = :gnvo_app.is_user;

this.object.nom_usuario 	[al_row] = ls_nom_user
is_action = 'new'   // Nuevo documento

of_set_status_doc( dw_master)


end event

event ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
of_set_status_doc(idw_1)  // Verifica status de documento
end event

event type integer ue_delete_pre();call super::ue_delete_pre;if idw_1 = dw_master then 
	Messagebox( "Error", "No se permite Eliminar este documento")	
	return 0
end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc(this)
end event

event buttonclicked;call super::buttonclicked;Long ll_row
str_parametros lstr_param

if lower(dwo.name) = 'b_cerrar' then
	if dw_master.ii_protect = 0 and is_action <> 'new' then
		MessageBox('Aviso', 'El programa de Compras debe ser editable')
		return
	end if
	
	if dw_master.GetRow() = 0 then return
	
	if dw_master.Object.flag_estado[dw_master.GetRow()] <> '1' then
		MessageBox('Aviso', 'No se puede cerrar este Programa de Compras')
		return
	end if
	
	dw_master.object.flag_estado[dw_master.GetRow()] = '2'
	for ll_row = 1 to dw_detail.RowCount()
		dw_detail.object.flag_estado[ll_row] = '2'
	next
elseif lower(dwo.name) = 'b_datos' then

	SetNull(lstr_param.fecha1)
	SetNull(lstr_param.fecha2)
		
	OpenWithParm( w_abc_datos_ot, lstr_param )
		
	if IsNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return
		
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
		
	lstr_param.dw_master 	= "d_list_orden_trabajo_prog_grd"
	lstr_param.dw1       	= "d_list_amp_x_ot_prog_grd"	
	lstr_param.titulo 		= "Ordenes de Trabajo pendientes"
	lstr_param.dw_m 			= this
	lstr_param.dw_d 			= dw_detail
	lstr_param.tipo_doc		= is_doc_ot
	lstr_param.opcion 		= 14
	lstr_param.tipo			= 'NRO_DOC'
	lstr_param.oper_cons_interno = is_oper_cons_int
	
	OpenWithParm(w_abc_seleccion_md, lstr_param)
	
	of_set_modify()
	
end if


end event

type sle_nro from u_sle_codigo within w_cm305_programa_compras
integer x = 855
integer y = 168
integer width = 471
integer height = 92
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_buscar.Triggerevent( clicked!)
end event

type cb_buscar from commandbutton within w_cm305_programa_compras
integer x = 1408
integer y = 164
integer width = 402
integer height = 100
integer taborder = 10
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
of_retrieve(sle_nro.text)
end event

type st_nro from statictext within w_cm305_programa_compras
integer x = 553
integer y = 180
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
string text = "Numero:"
boolean focusrectangle = false
end type

